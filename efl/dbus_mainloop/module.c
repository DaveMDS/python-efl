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

/*
 * Glue code to attach the Ecore main loop to D-Bus from within Python.
 */

#include <Python.h>
#include <dbus/dbus-python.h>
#include "e_dbus.h"


static dbus_bool_t
dbus_py_ecore_set_up_conn(DBusConnection *conn, void *data)
{
    Py_BEGIN_ALLOW_THREADS
    e_dbus_connection_setup(conn);
    Py_END_ALLOW_THREADS

    return TRUE;
}

static PyObject *
dbus_ecore_native_mainloop(void *data)
{
    return DBusPyNativeMainLoop_New4(dbus_py_ecore_set_up_conn,
                                     NULL, NULL, NULL);
}

PyDoc_STRVAR(DBusEcoreMainLoop__doc__,
"Returns a NativeMainLoop to attach the Ecore main loop to D-Bus\n"
"from within Python.\n");
static PyObject *
dbus_ecore_main_loop(PyObject *self, PyObject *args, PyObject *kwargs)
{
    static char *kwlist[] = { "set_as_default", NULL };
    int set_as_default = 0;
    PyObject *ml;

    if (PyTuple_Size(args) != 0) {
        PyErr_SetString(PyExc_TypeError,
                        "DBusEcoreMainLoop() takes no positional arguments");
        return NULL;
    }

    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i",
                                     kwlist, &set_as_default))
        return NULL;

    ml = dbus_ecore_native_mainloop(NULL);

    if (ml && set_as_default) {
        PyObject *func, *res;

        if (!_dbus_bindings_module) {
            PyErr_SetString(PyExc_ImportError, "_dbus_bindings not imported");
            Py_DECREF(ml);
            return NULL;
        }

        func = PyObject_GetAttrString(_dbus_bindings_module,
                                      "set_default_main_loop");
        if (!func) {
            Py_DECREF(ml);
            return NULL;
        }

        res = PyObject_CallFunctionObjArgs(func, ml, NULL);
        Py_DECREF(func);
        if (!res) {
            Py_DECREF(ml);
            return NULL;
        }

        Py_DECREF(res);
    }

    return ml;
}

static PyMethodDef module_functions[] = {
    { "DBusEcoreMainLoop", (PyCFunction)dbus_ecore_main_loop,
      METH_VARARGS | METH_KEYWORDS, DBusEcoreMainLoop__doc__ },
    { NULL, NULL, 0, NULL }
};

static void
module_cleanup(void)
{
    e_dbus_shutdown();
    ecore_shutdown();
}

PyDoc_STRVAR(module_doc,
"D-Bus python integration for Ecore main loop.\n");

#if defined(__GNUC__) && (__GNUC__ >= 4)
__attribute__ ((visibility("default")))
#endif

PyMODINIT_FUNC
initdbus_mainloop(void)
{
    PyObject *mod;

    if (import_dbus_bindings("efl.dbus_mainloop") < 0) {
        PyErr_SetString(PyExc_ImportError, "failed to import D-Bus bindings");
        return;
    }

    mod = Py_InitModule3("efl.dbus_mainloop", module_functions, module_doc);
    if (!mod) {
        PyErr_SetString(PyExc_ImportError,
                        "Py_InitModule3(\"efl.dbus_mainloop\") failed");
        return;
    }

    ecore_init();
    e_dbus_init();

    Py_AtExit(module_cleanup);
}
