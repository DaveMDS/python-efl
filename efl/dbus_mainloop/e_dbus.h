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

/*
 * Glue code to attach the Ecore main loop to D-Bus from within Python.
 */

#include <dbus/dbus.h>
#include <Ecore.h>


typedef struct E_DBus_Connection E_DBus_Connection;
typedef struct E_DBus_Handler_Data E_DBus_Handler_Data;
typedef struct E_DBus_Timeout_Data E_DBus_Timeout_Data;

struct E_DBus_Connection
{
  DBusConnection *conn;
  Eina_List *fd_handlers;
  Eina_List *timeouts;
  Ecore_Idler *idler;
};

struct E_DBus_Handler_Data
{
  int fd;
  Ecore_Fd_Handler *fd_handler;
  E_DBus_Connection *cd;
  DBusWatch *watch_read;
  DBusWatch *watch_write;
};

struct E_DBus_Timeout_Data
{
  Ecore_Timer *handler;
  DBusTimeout *timeout;
  E_DBus_Connection *cd;
};


int e_dbus_init(void);
int e_dbus_shutdown(void);
E_DBus_Connection *e_dbus_connection_setup(DBusConnection *conn);
void e_dbus_connection_close(E_DBus_Connection *conn);
