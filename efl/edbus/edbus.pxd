from cpython cimport PyObject
from libc.string cimport const_char

from enums cimport EDBus_Connection_Type

cdef extern from "dbus/dbus.h":
    ctypedef int dbus_bool_t
    ctypedef struct DBusConnection
    ctypedef struct DBusServer

cdef extern from "dbus/dbus-python.h":
    ctypedef dbus_bool_t (*_dbus_py_conn_setup_func)(DBusConnection *, void *)
    ctypedef dbus_bool_t (*_dbus_py_srv_setup_func)(DBusServer *, void *)
    ctypedef void (*_dbus_py_free_func)(void *)
    PyObject *DBusPyNativeMainLoop_New4(_dbus_py_conn_setup_func conn_func, _dbus_py_srv_setup_func srv_func, _dbus_py_free_func free_func, void *)
    void import_dbus_bindings(const_char *this_module_name)

cdef extern from "Ecore.h":
    int ecore_init()
    void ecore_shutdown()

cdef extern from "EDBus.h":
    ctypedef struct EDBus_Connection

    EDBus_Connection *edbus_connection_from_dbus_connection(EDBus_Connection_Type type, void *conn)
    void edbus_connection_unref(EDBus_Connection *conn)
    int edbus_init()
    void edbus_shutdown()
