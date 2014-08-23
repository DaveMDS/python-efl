from cpython cimport PyObject

cdef extern from "dbus/dbus.h":
    ctypedef int dbus_bool_t
    ctypedef struct DBusConnection
    ctypedef struct DBusServer

cdef extern from "dbus/dbus-python.h":
    ctypedef dbus_bool_t (*_dbus_py_conn_setup_func)(DBusConnection *, void *)
    ctypedef dbus_bool_t (*_dbus_py_srv_setup_func)(DBusServer *, void *)
    ctypedef void (*_dbus_py_free_func)(void *)
    PyObject *DBusPyNativeMainLoop_New4(_dbus_py_conn_setup_func conn_func, _dbus_py_srv_setup_func srv_func, _dbus_py_free_func free_func, void *)
    int import_dbus_bindings(const char *this_module_name)

cdef extern from "e_dbus.h":
    ctypedef struct E_DBus_Connection

    int e_dbus_init()
    int e_dbus_shutdown()
    E_DBus_Connection *e_dbus_connection_setup(DBusConnection *conn)
    void e_dbus_connection_close(E_DBus_Connection *conn)

