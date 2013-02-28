
"""D-Bus python integration for Ecore main loop."""

cimport enums

EDBUS_CONNECTION_TYPE_UNKNOWN = enums.EDBUS_CONNECTION_TYPE_UNKNOWN
EDBUS_CONNECTION_TYPE_SESSION = enums.EDBUS_CONNECTION_TYPE_SESSION
EDBUS_CONNECTION_TYPE_SYSTEM = enums.EDBUS_CONNECTION_TYPE_SYSTEM
EDBUS_CONNECTION_TYPE_STARTER = enums.EDBUS_CONNECTION_TYPE_STARTER
EDBUS_CONNECTION_TYPE_LAST = enums.EDBUS_CONNECTION_TYPE_LAST

import dbus
import dbus.mainloop
import atexit

import_dbus_bindings("edbus")

cdef EDBus_Connection *edbc

def module_cleanup():
    edbus_connection_unref(edbc)
    edbus_shutdown()
    ecore_shutdown()

ecore_init()
edbus_init()
atexit.register(module_cleanup)

cdef dbus_bool_t dbus_py_ecore_setup_conn(DBusConnection *conn, void* data):
    cdef EDBus_Connection_Type ctype = enums.EDBUS_CONNECTION_TYPE_SESSION
    edbc = edbus_connection_get(ctype)
    return True

cdef object dbus_ecore_native_mainloop():
    cdef PyObject *ml = DBusPyNativeMainLoop_New4(dbus_py_ecore_setup_conn, NULL, NULL, NULL)
    return <object>ml

def DBusEcoreMainLoop(set_as_default=False):
    """Returns a NativeMainLoop to attach the Ecore main loop to D-Bus from
    within Python."""

    ml = dbus_ecore_native_mainloop()

    if ml and set_as_default:
        res = dbus.set_default_main_loop(ml)

        if res is None:
            raise RuntimeError("Could not set up main loop")

    return ml
