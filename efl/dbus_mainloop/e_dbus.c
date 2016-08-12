/*
 * Copyright (C) 2007-2016 various contributors (see AUTHORS)
 * 
 * This file is part of Python-EFL.
 * 
 * Python-EFL is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 * 
 * Python-EFL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "e_dbus.h"
#include <stdbool.h>


#ifndef E_DBUS_COLOR_DEFAULT
#define E_DBUS_COLOR_DEFAULT EINA_COLOR_CYAN
#endif
static int _e_dbus_log_dom = -1;
#define DBG(...)   EINA_LOG_DOM_DBG(_e_dbus_log_dom, __VA_ARGS__)
#define INFO(...)    EINA_LOG_DOM_INFO(_e_dbus_log_dom, __VA_ARGS__)
#define WARN(...) EINA_LOG_DOM_WARN(_e_dbus_log_dom, __VA_ARGS__)
#define ERR(...)   EINA_LOG_DOM_ERR(_e_dbus_log_dom, __VA_ARGS__)

static int _edbus_connection_slot = -1;
static int _edbus_idler_active = 0;
static int _edbus_close_connection = 0;
static int _edbus_init_count = 0;

// change this define for extra debug
// #define DDBG(...) printf(__VA_ARGS__); printf("\n");
#define DDBG(...)


static Eina_Bool
e_dbus_idler(void *data)
{
   E_DBus_Connection *cd = data;

   if (DBUS_DISPATCH_COMPLETE == dbus_connection_get_dispatch_status(cd->conn))
   {
      DBG("done dispatching!");
      cd->idler = NULL;
      return ECORE_CALLBACK_CANCEL;
   }
   _edbus_idler_active++;
   dbus_connection_ref(cd->conn);
   DBG("dispatch()");
   dbus_connection_dispatch(cd->conn);
   dbus_connection_unref(cd->conn);
   _edbus_idler_active--;
   if (!_edbus_idler_active && _edbus_close_connection)
   {
      do
      {
         e_dbus_connection_close(cd);
      } while (--_edbus_close_connection);
   }
   return ECORE_CALLBACK_RENEW;
}

static void
cb_dispatch_status(DBusConnection *conn, DBusDispatchStatus new_status, void *data)
{
   E_DBus_Connection *cd = data;

   if (_edbus_init_count <= 0)
      return;

   DBG("dispatch status: %d!", new_status);

   if (new_status == DBUS_DISPATCH_DATA_REMAINS && !cd->idler)
      cd->idler = ecore_idler_add(e_dbus_idler, cd);
   else if (new_status != DBUS_DISPATCH_DATA_REMAINS && cd->idler) 
   {
      ecore_idler_del(cd->idler);
      cd->idler = NULL;
   }
}


/* ecore fd handler */
static Eina_Bool
e_dbus_fd_handler(void *data, Ecore_Fd_Handler *fd_handler)
{
   E_DBus_Handler_Data *hd = data;
   unsigned int condition = 0;

   DDBG("DATA READY ON FD");
   if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_READ))
      condition |= DBUS_WATCH_READABLE;
   if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_WRITE))
      condition |= DBUS_WATCH_WRITABLE;
   if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_ERROR))
      condition |= DBUS_WATCH_ERROR;

   if (hd->watch_read && dbus_watch_get_enabled(hd->watch_read))
      dbus_watch_handle(hd->watch_read, condition);
   if (hd->watch_read != hd->watch_write &&
       hd->watch_write && dbus_watch_get_enabled(hd->watch_write))
      dbus_watch_handle(hd->watch_write, condition);
   
   return ECORE_CALLBACK_RENEW;
}

static void
e_dbus_fd_handler_update(E_DBus_Handler_Data *hd)
{
   Ecore_Fd_Handler_Flags eflags = ECORE_FD_ERROR;

   if (hd->watch_read && dbus_watch_get_enabled(hd->watch_read))
      eflags |= ECORE_FD_READ;
   if (hd->watch_write && dbus_watch_get_enabled(hd->watch_write))
      eflags |= ECORE_FD_WRITE;

   DDBG("FD update %d (flags: %d)", hd->fd, eflags)
   ecore_main_fd_handler_active_set(hd->fd_handler, eflags);
}

static void
e_dbus_fd_handler_add(E_DBus_Connection *cd, DBusWatch *watch)
{
   E_DBus_Handler_Data *hd = NULL, *hd2;
   Eina_List *l;
   int dflags;
   int fd;

   fd = dbus_watch_get_unix_fd(watch);
   dflags = dbus_watch_get_flags(watch);

   EINA_LIST_FOREACH(cd->fd_handlers, l, hd2)
   {
      if (hd2->fd == fd)
      {
         hd = hd2;
         break;
      }
   }

   if (!hd)
   {
      hd = calloc(1, sizeof(E_DBus_Handler_Data));
      if (!hd) return;
      hd->cd = cd;
      hd->fd = fd;
      hd->fd_handler = ecore_main_fd_handler_add(fd, ECORE_FD_ERROR,
                                                 e_dbus_fd_handler,
                                                 hd, NULL, NULL);
      if (!hd->fd_handler) { DDBG("ERROR! cannot create FD handler") }
      cd->fd_handlers = eina_list_append(cd->fd_handlers, hd);
   }

   if (dflags & DBUS_WATCH_READABLE) hd->watch_read = watch;
   if (dflags & DBUS_WATCH_WRITABLE) hd->watch_write = watch;
   dbus_watch_set_data(watch, hd, NULL);
   e_dbus_fd_handler_update(hd);
}

static void
e_dbus_fd_handler_del(E_DBus_Handler_Data *hd)
{
   DDBG("  FD handler del");
   hd->cd->fd_handlers = eina_list_remove(hd->cd->fd_handlers, hd);
   ecore_main_fd_handler_del(hd->fd_handler);
   free(hd);
}

/* watch */
static dbus_bool_t 
cb_watch_add(DBusWatch *watch, void *data)
{
   E_DBus_Connection *cd = data;

   DDBG("Watch add on fd: %d (flags: %d) enable: %d",
        dbus_watch_get_unix_fd(watch), dbus_watch_get_flags(watch),
        dbus_watch_get_enabled(watch));

   e_dbus_fd_handler_add(cd, watch);

   return true;
}

static void
cb_watch_del(DBusWatch *watch, void *data)
{
   E_DBus_Handler_Data *hd;

   if (_edbus_init_count <= 0)
      return;

   DDBG("Watch del on fd: %d (flags: %d)", dbus_watch_get_unix_fd(watch),
        dbus_watch_get_flags(watch));

   hd = dbus_watch_get_data(watch);

   int dflags = dbus_watch_get_flags(watch);
   if (dflags & DBUS_WATCH_READABLE) hd->watch_read = NULL;
   if (dflags & DBUS_WATCH_WRITABLE) hd->watch_write = NULL;

   if (!hd->watch_read && !hd->watch_write)
      e_dbus_fd_handler_del(hd);
   else
      e_dbus_fd_handler_update(hd);
}

static void
cb_watch_toggle(DBusWatch *watch, void *data)
{
   E_DBus_Handler_Data *hd;

   if (_edbus_init_count <= 0)
      return;

   DDBG("Watch toggle on fd: %d (flags: %d) enable: %d",
        dbus_watch_get_unix_fd(watch), dbus_watch_get_flags(watch),
        dbus_watch_get_enabled(watch));

   hd = dbus_watch_get_data(watch);
   e_dbus_fd_handler_update(hd);
}


/* timeout */
static Eina_Bool
e_dbus_timeout_handler(void *data)
{
   E_DBus_Timeout_Data *td = data;

   DBG("timeout expired!");

   if (dbus_timeout_get_enabled(td->timeout))
      dbus_timeout_handle(td->timeout);

   td->cd->timeouts = eina_list_remove(td->cd->timeouts, td->handler);
   td->handler = NULL;
   return ECORE_CALLBACK_CANCEL;
}

static void
e_dbus_timeout_data_free(void *timeout_data)
{
   E_DBus_Timeout_Data *td = timeout_data;

   DBG("timeout data free!");
   if (td->handler) ecore_timer_del(td->handler);
   free(td);
}

static dbus_bool_t 
cb_timeout_add(DBusTimeout *timeout, void *data)
{
   E_DBus_Connection *cd = data;
   E_DBus_Timeout_Data *td;
   double interval = (double)dbus_timeout_get_interval(timeout) / 1000;

   DBG("timeout add! enabled: %d, interval: %.2f secs",
       dbus_timeout_get_enabled(timeout), interval);

   td = calloc(1, sizeof(E_DBus_Timeout_Data));
   td->cd = cd;
   td->timeout = timeout;
   dbus_timeout_set_data(timeout, (void *)td, e_dbus_timeout_data_free);

   if (dbus_timeout_get_enabled(timeout))
   {
      td->handler = ecore_timer_add(interval, e_dbus_timeout_handler, td);
      cd->timeouts = eina_list_append(cd->timeouts, td->handler);
   }

   return true;
}

static void
cb_timeout_del(DBusTimeout *timeout, void *data)
{
   E_DBus_Connection *cd = data;
   E_DBus_Timeout_Data *td = dbus_timeout_get_data(timeout);

   DBG("timeout del!");

   if (td->handler) 
   {
      cd->timeouts = eina_list_remove(cd->timeouts, td->handler);
      ecore_timer_del(td->handler);
      td->handler = NULL;
   }

   /* Note: timeout data gets freed when the timeout itself is freed by dbus */
}

static void
cb_timeout_toggle(DBusTimeout *timeout, void *data)
{
   E_DBus_Connection *cd = data;
   E_DBus_Timeout_Data *td = dbus_timeout_get_data(timeout);
   double interval = (double)dbus_timeout_get_interval(timeout) / 1000;

   DBG("timeout toggle!");

   if (dbus_timeout_get_enabled(td->timeout))
   {
      td->handler = ecore_timer_add(interval, e_dbus_timeout_handler, td);
      cd->timeouts = eina_list_append(cd->timeouts, td->handler);
   }
   else
   {
      cd->timeouts = eina_list_remove(cd->timeouts, td->handler);
      ecore_timer_del(td->handler);
      td->handler = NULL;
   }
}


/* dbus connection */
static E_DBus_Connection *
e_dbus_connection_new(DBusConnection *conn)
{
   E_DBus_Connection *cd;

   cd = calloc(1, sizeof(E_DBus_Connection));
   if (!cd) return NULL;
   cd->conn = conn;

   return cd;
}

static void
e_dbus_connection_free(void *data)
{
   E_DBus_Connection *cd = data;
   E_DBus_Handler_Data *hd;
   Ecore_Timer *timer;
   Eina_List *l, *ll;

   if (_edbus_init_count <= 0)
      return;

   EINA_LIST_FOREACH_SAFE(cd->fd_handlers, l, ll, hd)
      e_dbus_fd_handler_del(hd);

   EINA_LIST_FREE(cd->timeouts, timer)
      ecore_timer_del(timer);

   if (cd->idler) ecore_idler_del(cd->idler);

   free(cd);
}


/* public functions */
int
e_dbus_init(void)
{
   if (++_edbus_init_count != 1)
      return _edbus_init_count;
  
   if (!eina_init())
   {
      fprintf(stderr,"E-dbus: Enable to initialize eina\n");
      return --_edbus_init_count;
   }

   _e_dbus_log_dom = eina_log_domain_register("e_dbus", E_DBUS_COLOR_DEFAULT);
   if (_e_dbus_log_dom < 0)
   {
      EINA_LOG_ERR("Unable to create an 'e_dbus' log domain");
      eina_shutdown();
      return --_edbus_init_count;
   }

   if (!ecore_init())
   {
      ERR("E-dbus: Unable to initialize ecore");
      eina_shutdown();
      return --_edbus_init_count;
   }

   return _edbus_init_count;
}

int
e_dbus_shutdown(void)
{
   if (_edbus_init_count <= 0)
   {
      EINA_LOG_ERR("Init count not greater than 0 in shutdown.");
      return 0;
   }
   if (--_edbus_init_count)
      return _edbus_init_count;

   ecore_shutdown();
   eina_log_domain_unregister(_e_dbus_log_dom);
   _e_dbus_log_dom = -1;
   eina_shutdown();

   return _edbus_init_count;
}

E_DBus_Connection *
e_dbus_connection_setup(DBusConnection *conn)
{
   E_DBus_Connection *cd;

   cd = e_dbus_connection_new(conn);
   if (!cd) return NULL;

   /* connection_setup */
   dbus_connection_set_exit_on_disconnect(cd->conn, EINA_FALSE);
   dbus_connection_allocate_data_slot(&_edbus_connection_slot);

   dbus_connection_set_data(cd->conn, _edbus_connection_slot, (void *)cd,
                            e_dbus_connection_free);
   dbus_connection_set_watch_functions(cd->conn,
                                       cb_watch_add,
                                       cb_watch_del,
                                       cb_watch_toggle,
                                       cd,
                                       NULL);

   dbus_connection_set_timeout_functions(cd->conn,
                                         cb_timeout_add,
                                         cb_timeout_del,
                                         cb_timeout_toggle,
                                         cd,
                                         NULL);

   dbus_connection_set_dispatch_status_function(cd->conn, cb_dispatch_status, cd, NULL);
   cb_dispatch_status(cd->conn, dbus_connection_get_dispatch_status(cd->conn), cd);

   return cd;
}

void
e_dbus_connection_close(E_DBus_Connection *conn)
{
   if (!conn) return;
   DBG("e_dbus_connection_close");

   if (_edbus_idler_active)
   {
      _edbus_close_connection++;
      return;
   }

   dbus_connection_free_data_slot(&_edbus_connection_slot);
   dbus_connection_set_watch_functions(conn->conn,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL, NULL);

   dbus_connection_set_timeout_functions(conn->conn,
                                         NULL,
                                         NULL,
                                         NULL,
                                         NULL, NULL);

   dbus_connection_set_dispatch_status_function(conn->conn, NULL, NULL, NULL);

   /* Idler functin must be cancelled when dbus connection is  unreferenced */
   if (conn->idler)
   {
      ecore_idler_del(conn->idler);
      conn->idler = NULL;
   }

   dbus_connection_close(conn->conn);
   dbus_connection_unref(conn->conn);

   // Note: the E_DBus_Connection gets freed when the dbus_connection is cleaned up by the previous unref
}


#undef DDBG
