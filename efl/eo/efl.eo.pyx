# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

cimport cython
from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String, \
    PyString_FromFormatV
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy, strdup
from efl.eina cimport Eina_Bool, const_Eina_List, eina_list_append, const_void, \
    Eina_Hash, eina_hash_string_superfast_new, eina_hash_add, eina_hash_del, \
    eina_hash_find, Eina_Log_Domain, const_Eina_Log_Domain, Eina_Log_Level, \
    eina_log_print_cb_set, eina_log_domain_register, \
    eina_log_level_set, eina_log_level_get, eina_log_domain_level_get, \
    eina_log_domain_level_set, EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO
from efl.c_eo cimport Eo as cEo, eo_init, eo_shutdown, eo_del, eo_do, \
    eo_class_name_get, eo_class_get, eo_base_data_set, eo_base_data_get, \
    eo_base_data_del, eo_event_callback_add, eo_event_callback_del, \
    Eo_Event_Description, const_Eo_Event_Description, \
    eo_parent_get, EO_EV_DEL


cdef extern from "stdarg.h":
    ctypedef struct va_list:
        pass

cdef void py_eina_log_print_cb(const_Eina_Log_Domain *d,
                              Eina_Log_Level level,
                              const_char *file, const_char *fnc, int line,
                              const_char *fmt, void *data, va_list args) with gil:

    cdef str msg = PyString_FromFormatV(fmt, args)
    rec = logging.LogRecord(d.name, log_levels[level], file, line, msg, None, None, fnc)
    loggers[d.name].handle(rec)

eina_log_print_cb_set(py_eina_log_print_cb, NULL)


import logging

cdef tuple log_levels = (
    50,
    40,
    30,
    20,
    10
)

cdef dict loggers = dict()

class PyEFLLogger(logging.Logger):
    def __init__(self, name):
        self.eina_log_domain = eina_log_domain_register(name, NULL)
        loggers[name] = self
        logging.Logger.__init__(self, name)

    def setLevel(self, lvl):
        eina_log_domain_level_set(self.name, log_levels.index(lvl))
        logging.Logger.setLevel(self, lvl)

logging.setLoggerClass(PyEFLLogger)

# TODO: Handle messages from root Eina Log with this one?
rootlog = logging.getLogger("efl")
rootlog.propagate = False
rootlog.setLevel(logging.WARNING)
rootlog.addHandler(logging.NullHandler())

log = logging.getLogger(__name__)
log.propagate = True
log.setLevel(logging.WARNING)
log.addHandler(logging.NullHandler())

logging.setLoggerClass(logging.Logger)

cdef int PY_EFL_EO_LOG_DOMAIN = log.eina_log_domain




def init():
    EINA_LOG_DOM_INFO(PY_EFL_EO_LOG_DOMAIN, "Initializing %s", <char *>__name__)
    return eo_init()

def shutdown():
    return eo_shutdown()

init()


cdef int PY_REFCOUNT(object o):
    cdef PyObject *obj = <PyObject *>o
    return obj.ob_refcnt


######################################################################

"""

Object mapping is an Eina Hash table into which object type names can be
registered. These can be used to find a bindings class for an object using
the function object_from_instance.

"""
cdef Eina_Hash *object_mapping = eina_hash_string_superfast_new(NULL)


cdef void _object_mapping_register(char *name, object cls) except *:

    if eina_hash_find(object_mapping, name) != NULL:
        raise ValueError("Object type name '%s' already registered." % name)

    EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN, "REGISTER: %s => %s", name, <char *>cls.__name__)
    eina_hash_add(object_mapping, name, <PyObject *>cls)


cdef void _object_mapping_unregister(char *name):
    eina_hash_del(object_mapping, name, NULL)


cdef object object_from_instance(cEo *obj):
    """ Create a python object from a C Eo object pointer. """
    cdef:
        void *data
        Eo o
        const_char *cls_name
        type cls
        void *cls_ret

    if obj == NULL:
        return None

    eo_do(obj, eo_base_data_get("python-eo", &data))
    if data != NULL:
        #print("Found: %s" % Eo.__repr__(<Eo>data))
        return <Eo>data

    cls_name = eo_class_name_get(eo_class_get(obj))
    if cls_name == NULL:
        raise ValueError("Eo object %#x does not have a type!" % <long>obj)
    #print("Class name: %s" % cls_name)

    cls_ret = eina_hash_find(object_mapping, cls_name)

    if cls_ret == NULL:
        raise ValueError("Eo object %#x of type %s does not have a mapping!" %
                         (<long>obj, cls_name))

    cls = <type?>cls_ret

    if cls is None:
        raise ValueError("Eo object %#x of type %s does not have a mapping!" %
                         (<long>obj, cls_name))

    #print("MAPPING OBJECT:", cls_name, "=>", cls)
    o = cls.__new__(cls)
    o._set_obj(obj)
    return o


cdef void _register_decorated_callbacks(object obj):
    """

    Search every attrib of the pyobj for a __decorated_callbacks__ object,
    a list actually. If found then exec the functions listed there, with their
    arguments. Must be called just after the _set_obj call.
    List items signature: ("function_name", *args)

    """
    cdef object attr_name, attrib, func_name, func

    for attr_name in dir(obj):
        attrib = getattr(obj, attr_name)
        if hasattr(attrib, "__decorated_callbacks__"):
            for (func_name, *args) in getattr(attrib, "__decorated_callbacks__"):
                func = getattr(obj, func_name)
                func(*args)


######################################################################


# TODO: Move these to enums.pxd
cdef:
    int C_EO_CALLBACK_STOP = 0
    int C_EO_CALLBACK_CONTINUE = 1

EO_CALLBACK_STOP = C_EO_CALLBACK_STOP
EO_CALLBACK_CONTINUE = C_EO_CALLBACK_CONTINUE


######################################################################


cdef Eina_Bool _eo_event_del_cb(void *data, cEo *obj, const_Eo_Event_Description *desc, void *event_info) with gil:
    cdef Eo self = <Eo>data

#     print("DEL CB: %s" % Eo.__repr__(self))
    eo_do(self.obj, eo_event_callback_del(EO_EV_DEL, _eo_event_del_cb, <const_void *>self))
    eo_do(self.obj, eo_base_data_del("python-eo"))
    self.obj = NULL
    Py_DECREF(self)

    return C_EO_CALLBACK_STOP


cdef class Eo(object):
    """

    Base class used by all the Eo object in the bindings, its not meant to be
    used by users, but only by internal classes.

    """

    # c globals declared in eo.pxd (to make the class available to others)

    def __cinit__(self):
        self.data = dict()

    def __init__(self, *args, **kwargs):
        if type(self) is Eo:
            raise TypeError("Must not instantiate Eo, but subclasses")

    def __str__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (type(self).__name__, <unsigned long>self.obj,
                 <unsigned long><void *>eo_parent_get(&self.obj) if self.obj != NULL else 0,
                 PY_REFCOUNT(self))

    def __repr__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (type(self).__name__, <unsigned long>self.obj,
                 <unsigned long><void *>eo_parent_get(&self.obj) if self.obj != NULL else 0,
                 PY_REFCOUNT(self))

    def __nonzero__(self):
        return 1 if self.obj != NULL else 0

    cdef void _set_obj(self, cEo *obj) except *:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_base_data_set("python-eo", <void *>self, NULL))
        eo_do(self.obj, eo_event_callback_add(EO_EV_DEL, _eo_event_del_cb, <const_void *>self))
        Py_INCREF(self)

    cdef void _set_properties_from_keyword_args(self, dict kwargs) except *:
        for k, v in kwargs.items():
            assert hasattr(self, k), "%s has no attribute with the name %s." % (self, k)
            setattr(self, k, v)

    def is_deleted(self):
        "Check if the object has been deleted thus leaving the object shallow"
        return bool(self.obj == NULL)

