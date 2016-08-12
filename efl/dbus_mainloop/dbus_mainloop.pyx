# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

D-Bus python integration for Ecore main loop.

"""

import dbus
import dbus.mainloop
import atexit

cdef dbus_bool_t dbus_py_ecore_set_up_conn(DBusConnection *conn, void *data) with gil:
    e_dbus_connection_setup(conn)
    return True

cdef object dbus_ecore_native_mainloop():
    return <object>DBusPyNativeMainLoop_New4(dbus_py_ecore_set_up_conn,
                                     NULL, NULL, NULL)

def DBusEcoreMainLoop(set_as_default = None):
    """Returns a NativeMainLoop to attach the Ecore main loop to D-Bus
    from within Python."""

    ml = dbus_ecore_native_mainloop()

    if ml is not None and set_as_default:
        dbus.set_default_main_loop(ml)

    return ml

def module_cleanup():
    e_dbus_shutdown()

if import_dbus_bindings("efl.dbus_mainloop") < 0:
    raise ImportError("failed to import D-Bus bindings")

e_dbus_init()

atexit.register(module_cleanup)
