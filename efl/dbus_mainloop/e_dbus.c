/*
 * Copyright (C) 2007-2013 various contributors (see AUTHORS)
 * 
 * This file is part of Python-EFL.
 * 
 * Python-EFL is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * Python-EFL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdbool.h>
#include "e_dbus.h"


int E_DBUS_EVENT_SIGNAL = 0;
static int connection_slot = -1;
static int e_dbus_idler_active = 0;
static int close_connection = 0;
static int _edbus_init_count = 0;


static void
e_dbus_fd_handler_del(E_DBus_Handler_Data *hd)
{
  if (!hd->fd_handler) return;

  printf("handler disabled\n");
  hd->cd->fd_handlers = eina_list_remove(hd->cd->fd_handlers, hd->fd_handler);
  ecore_main_fd_handler_del(hd->fd_handler);
  hd->fd_handler = NULL;
}

static Eina_Bool
e_dbus_fd_handler(void *data, Ecore_Fd_Handler *fd_handler)
{
  E_DBus_Handler_Data *hd;
  unsigned int condition = 0;

  printf("fd handler (%p)!\n", fd_handler);

  hd = data;

  if (!hd->enabled)
    {
       e_dbus_fd_handler_del(hd);
       return ECORE_CALLBACK_CANCEL;
    }
  if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_READ)) condition |= DBUS_WATCH_READABLE;
  if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_WRITE)) condition |= DBUS_WATCH_WRITABLE;
  if (ecore_main_fd_handler_active_get(fd_handler, ECORE_FD_ERROR)) condition |= DBUS_WATCH_ERROR;
  printf("fdh || READ: %d, WRITE: %d\n",
      (condition & DBUS_WATCH_READABLE) == DBUS_WATCH_READABLE,
      (condition & DBUS_WATCH_WRITABLE) == DBUS_WATCH_WRITABLE);

  if (condition & DBUS_WATCH_ERROR) printf("DBUS watch error\n");
  dbus_watch_handle(hd->watch, condition);
  hd = NULL;

  return ECORE_CALLBACK_RENEW;
}

static void
e_dbus_fd_handler_add(E_DBus_Handler_Data *hd)
{
  unsigned int dflags;
  Ecore_Fd_Handler_Flags eflags;
  Eina_List *l;
  Ecore_Fd_Handler *fdh;

  if (hd->fd_handler) return;
  dflags = dbus_watch_get_flags(hd->watch);
  eflags = ECORE_FD_ERROR;
  if (dflags & DBUS_WATCH_READABLE) eflags |= ECORE_FD_READ;
  if (dflags & DBUS_WATCH_WRITABLE) eflags |= ECORE_FD_WRITE;

  EINA_LIST_FOREACH(hd->cd->fd_handlers, l, fdh)
    {
       if (ecore_main_fd_handler_fd_get(fdh) == hd->fd) return;
    }

  printf("fd handler add (%d)\n", hd->fd);
  hd->fd_handler = ecore_main_fd_handler_add(hd->fd,
                                             eflags,
                                             e_dbus_fd_handler,
                                             hd,
                                             NULL,
                                             NULL);

  hd->cd->fd_handlers = eina_list_append(hd->cd->fd_handlers, hd->fd_handler);
}

static void
e_dbus_handler_data_free(void *data)
{
  E_DBus_Handler_Data *hd = data;
  
  printf("e_dbus_handler_data_free\n");
  if (hd->fd_handler)
  {
    hd->cd->fd_handlers = eina_list_remove(hd->cd->fd_handlers, hd->fd_handler);
    ecore_main_fd_handler_del(hd->fd_handler);
  }
  free(hd);
}

static void
e_dbus_connection_data_watch_add(E_DBus_Connection *cd, DBusWatch *watch)
{
  E_DBus_Handler_Data *hd;

  hd = calloc(1, sizeof(E_DBus_Handler_Data));
  dbus_watch_set_data(watch, hd, e_dbus_handler_data_free);
  hd->cd = cd;
  hd->watch = watch;

  hd->enabled = dbus_watch_get_enabled(watch);
// #if (DBUS_VERSION_MAJOR == 1 && DBUS_VERSION_MINOR == 1 && DBUS_VERSION_MICRO>= 1) || (DBUS_VERSION_MAJOR == 1 && DBUS_VERSION_MINOR > 1) || (DBUS_VERSION_MAJOR > 1)
  hd->fd = dbus_watch_get_unix_fd(hd->watch);
// #else
  // hd->fd = dbus_watch_get_fd(hd->watch);
// #endif
  printf("watch add (enabled: %d)\n", hd->enabled);
  if (hd->enabled) e_dbus_fd_handler_add(hd);
}

static void
e_dbus_message_free(void *data, void *message)
{
  dbus_message_unref(message);
}

static DBusHandlerResult
e_dbus_filter(DBusConnection *conn, DBusMessage *message, void *user_data)
{
  E_DBus_Connection *cd = user_data;
  printf("-----------------\n");
  printf("Message!\n");

  printf("type: %s\n", dbus_message_type_to_string(dbus_message_get_type(message)));
  printf("path: %s\n", dbus_message_get_path(message));
  printf("interface: %s\n", dbus_message_get_interface(message));
  printf("member: %s\n", dbus_message_get_member(message));
  printf("sender: %s\n", dbus_message_get_sender(message));

  switch (dbus_message_get_type(message))
  {
    case DBUS_MESSAGE_TYPE_METHOD_CALL:
      printf("signature: %s\n", dbus_message_get_signature(message));
      break;
    case DBUS_MESSAGE_TYPE_METHOD_RETURN:
      printf("reply serial %d\n", dbus_message_get_reply_serial(message));
      break;
    case DBUS_MESSAGE_TYPE_ERROR:
      printf("error: %s\n", dbus_message_get_error_name(message));
      break;
    case DBUS_MESSAGE_TYPE_SIGNAL:
      dbus_message_ref(message);
      if (cd->signal_dispatcher) cd->signal_dispatcher(cd, message);
      ecore_event_add(E_DBUS_EVENT_SIGNAL, message, e_dbus_message_free, NULL);
      break;
    default:
      break;
  }
  printf("-----------------\n");

  return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
}

static Eina_Bool
e_dbus_idler(void *data)
{
  E_DBus_Connection *cd;
  cd = data;

  if (DBUS_DISPATCH_COMPLETE == dbus_connection_get_dispatch_status(cd->conn))
  {
    printf("done dispatching!\n");
    cd->idler = NULL;
    return ECORE_CALLBACK_CANCEL;
  }
  e_dbus_idler_active++;
  dbus_connection_ref(cd->conn);
  printf("dispatch()\n");
  dbus_connection_dispatch(cd->conn);
  dbus_connection_unref(cd->conn);
  e_dbus_idler_active--;
  // e_dbus_signal_handlers_clean(cd); // TODO XXX
  if (!e_dbus_idler_active && close_connection)
  {
    do
    {
      e_dbus_connection_close(cd);
    } while (--close_connection);
  }
  return ECORE_CALLBACK_RENEW;
}

static void
cb_dispatch_status(DBusConnection *conn, DBusDispatchStatus new_status, void *data)
{
  E_DBus_Connection *cd;

  printf("dispatch status: %d!\n", new_status);
  cd = data;

  if (new_status == DBUS_DISPATCH_DATA_REMAINS && !cd->idler)
     cd->idler = ecore_idler_add(e_dbus_idler, cd);
  else if (new_status != DBUS_DISPATCH_DATA_REMAINS && cd->idler) 
    {
       ecore_idler_del(cd->idler);
       cd->idler = NULL;
    }
}


/* watch */
static dbus_bool_t 
cb_watch_add(DBusWatch *watch, void *data)
{
  E_DBus_Connection *cd;
  cd = data;

  printf("cb_watch_add\n");
  e_dbus_connection_data_watch_add(cd, watch);

  return true;
}

static void
cb_watch_del(DBusWatch *watch, void *data)
{
  E_DBus_Handler_Data *hd;

  printf("cb_watch_del\n");
  hd = (E_DBus_Handler_Data *)dbus_watch_get_data(watch);
  e_dbus_fd_handler_del(hd);
}

static void
cb_watch_toggle(DBusWatch *watch, void *data)
{
  E_DBus_Handler_Data *hd;

  printf("cb_watch_toggle\n");
  hd = dbus_watch_get_data(watch);

  if (!hd) return;

  hd->enabled = dbus_watch_get_enabled(watch);

  printf("watch %p is %sabled\n", hd, hd->enabled ? "en" : "dis");
  if (hd->enabled) e_dbus_fd_handler_add(hd);
  else e_dbus_fd_handler_del(hd);
}


/* timeout */
static Eina_Bool
e_dbus_timeout_handler(void *data)
{
  E_DBus_Timeout_Data *td;

  td = data;

  if (!dbus_timeout_get_enabled(td->timeout))
  {
    printf("timeout_handler (not enabled, ending)\n");
    td->handler = NULL;
    return ECORE_CALLBACK_CANCEL;
  }

  printf("timeout handler!\n");
  dbus_timeout_handle(td->timeout);
  return ECORE_CALLBACK_CANCEL;
}

static void
e_dbus_timeout_data_free(void *timeout_data)
{
  E_DBus_Timeout_Data *td = timeout_data;
  printf("e_dbus_timeout_data_free\n");
  if (td->handler) ecore_timer_del(td->handler);
  free(td);
}

static dbus_bool_t 
cb_timeout_add(DBusTimeout *timeout, void *data)
{
  E_DBus_Connection *cd;
  E_DBus_Timeout_Data *td;
  
  cd = data;
  printf("timeout add!\n");
  td = calloc(1, sizeof(E_DBus_Timeout_Data));
  td->cd = cd;
  dbus_timeout_set_data(timeout, (void *)td, e_dbus_timeout_data_free);

  td->interval = dbus_timeout_get_interval(timeout);
  td->timeout = timeout;

  if (dbus_timeout_get_enabled(timeout))
    td->handler = ecore_timer_add(td->interval, e_dbus_timeout_handler, td);
  td->cd->timeouts = eina_list_append(td->cd->timeouts, td->handler);

  return true;
}

static void
cb_timeout_del(DBusTimeout *timeout, void *data)
{
  E_DBus_Timeout_Data *td;
  printf("timeout del!\n");

  td = (E_DBus_Timeout_Data *)dbus_timeout_get_data(timeout);

  if (td->handler) 
  {
    td->cd->timeouts = eina_list_remove(td->cd->timeouts, td->handler);
    ecore_timer_del(td->handler);
    td->handler = NULL;
  }

  /* Note: timeout data gets freed when the timeout itself is freed by dbus */
}

static void
cb_timeout_toggle(DBusTimeout *timeout, void *data)
{
  E_DBus_Timeout_Data *td;
  printf("timeout toggle!\n");

  td = (E_DBus_Timeout_Data *)dbus_timeout_get_data(timeout);

  if (dbus_timeout_get_enabled(td->timeout))
  {
    td->interval = dbus_timeout_get_interval(timeout);
    td->handler = ecore_timer_add(td->interval, e_dbus_timeout_handler, td);
  }
  else
  {
    ecore_timer_del(td->handler);
    td->handler = NULL;
  }
}


/* dbus connection */
static E_DBus_Connection *
e_dbus_connection_new(DBusConnection *conn)
{
  E_DBus_Connection *cd;
  const char *conn_name;

  cd = calloc(1, sizeof(E_DBus_Connection));
  if (!cd) return NULL;

  cd->conn = conn;
  conn_name = dbus_bus_get_unique_name(conn);
  if (conn_name)
  {
    printf("Connected! Name: %s\n", conn_name);
    cd->conn_name = strdup(conn_name);
  }
  else
    printf("Not connected\n");

  cd->shared_type = (unsigned int)-1;
  cd->fd_handlers = NULL;
  cd->timeouts = NULL;

  return cd;
}

static void
e_dbus_connection_free(void *data)
{
  E_DBus_Connection *cd = data;
  Ecore_Fd_Handler *fd_handler;
  Ecore_Timer *timer;
  printf("e_dbus_connection free!\n");

  EINA_LIST_FREE(cd->fd_handlers, fd_handler)
    ecore_main_fd_handler_del(fd_handler);

  EINA_LIST_FREE(cd->timeouts, timer)
    ecore_timer_del(timer);

  // if (cd->shared_type != (unsigned int)-1)
    // shared_connections[cd->shared_type] = NULL;

  // e_dbus_signal_handlers_free_all(cd);

  if (cd->conn_name) free(cd->conn_name);

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

  if (!ecore_init())
    {
      fprintf(stderr, "E-dbus: Unable to initialize ecore\n");
      eina_shutdown();
      return --_edbus_init_count;
    }

  E_DBUS_EVENT_SIGNAL = ecore_event_type_new();
  // e_dbus_object_init();

  return _edbus_init_count;
}

int
e_dbus_shutdown(void)
{
  if (_edbus_init_count <= 0)
     {
        fprintf(stderr, "Init count not greater than 0 in shutdown.\n");
        return 0;
     }
  if (--_edbus_init_count)
    return _edbus_init_count;

  // e_dbus_object_shutdown();
  ecore_shutdown();
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
  dbus_connection_allocate_data_slot(&connection_slot);

  dbus_connection_set_data(cd->conn, connection_slot, (void *)cd, e_dbus_connection_free);
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
  dbus_connection_add_filter(cd->conn, e_dbus_filter, cd, NULL);

  cb_dispatch_status(cd->conn, dbus_connection_get_dispatch_status(cd->conn), cd);

  return cd;
}

void
e_dbus_connection_close(E_DBus_Connection *conn)
{
  if (!conn) return;
  printf("e_dbus_connection_close\n");

  if (e_dbus_idler_active)
  {
    close_connection++;
    return;
  }
  if (--(conn->refcount) != 0) return;

  dbus_connection_free_data_slot(&connection_slot);
  dbus_connection_remove_filter(conn->conn, e_dbus_filter, conn);
  dbus_connection_set_watch_functions (conn->conn,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL, NULL);

  dbus_connection_set_timeout_functions (conn->conn,
                                         NULL,
                                         NULL,
                                         NULL,
                                         NULL, NULL);

  dbus_connection_set_dispatch_status_function (conn->conn, NULL, NULL, NULL);

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


