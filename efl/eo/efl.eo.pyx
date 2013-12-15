# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy, strdup
from libc.stdint cimport uintptr_t
from efl.eina cimport Eina_Bool, const_Eina_List, eina_list_append, const_void, \
    Eina_Hash, eina_hash_string_superfast_new, eina_hash_add, eina_hash_del, \
    eina_hash_find, EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO
from efl.c_eo cimport Eo as cEo, eo_init, eo_shutdown, eo_del, eo_do, \
    eo_class_name_get, eo_class_get, eo_base_data_set, eo_base_data_get, \
    eo_base_data_del, eo_event_callback_add, eo_event_callback_del, \
    Eo_Event_Description, const_Eo_Event_Description, \
    eo_parent_get, EO_EV_DEL, EO_BASE_BASE_ID, eo_base_class_get, \
    eo_event_freeze, eo_event_thaw, eo_event_freeze_get, \
    eo_event_global_freeze, eo_event_global_thaw, eo_event_global_freeze_get, \
    const_Eo, eo_parent_set

cimport efl.eo.enums as enums

from efl.utils.logger cimport add_logger

# Set this to public and export it in pxd if you need it in another module
cdef int PY_EFL_EO_LOG_DOMAIN = add_logger(__name__).eina_log_domain

cdef int PY_REFCOUNT(object o):
    cdef PyObject *obj = <PyObject *>o
    return obj.ob_refcnt

######################################################################

def init():
    EINA_LOG_DOM_INFO(PY_EFL_EO_LOG_DOMAIN, "Initializing efl.eo", NULL)
    return eo_init()

def shutdown():
    EINA_LOG_DOM_INFO(PY_EFL_EO_LOG_DOMAIN, "Shutting down efl.eo", NULL)
    return eo_shutdown()

init()

def event_global_freeze_get():
    cdef int fcount
    eo_do(
        <const_Eo *>eo_base_class_get(),
        eo_event_global_freeze_get(&fcount),
        )
    return fcount

def event_global_freeze():
    eo_do(
        <const_Eo *>eo_base_class_get(),
        eo_event_global_freeze(),
        )

def event_global_thaw():
    eo_do(
        <const_Eo *>eo_base_class_get(),
        eo_event_global_thaw()
        )

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

    cdef object cls_name = cls.__name__
    if isinstance(cls_name, unicode): cls_name = PyUnicode_AsUTF8String(cls_name)

    EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN,
        "REGISTER: %s => %s", <char *>name, <char *>cls_name)
    eina_hash_add(object_mapping, name, <PyObject *>cls)


cdef void _object_mapping_unregister(char *name):
    eina_hash_del(object_mapping, name, NULL)


cdef object object_from_instance(cEo *obj):
    """ Create a python object from a C Eo object pointer. """
    cdef:
        void *data
        Eo o
        const_char *cls_name = eo_class_name_get(eo_class_get(obj))
        type cls
        void *cls_ret

    if obj == NULL:
        return None

    eo_do(obj, eo_base_data_get("python-eo", &data))
    if data != NULL:
        EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN,
            "Returning a Python object instance for Eo of type %s.", cls_name)
        return <Eo>data

    if cls_name == NULL:
        raise ValueError(
            "Eo object at %#x does not have a type!" % <uintptr_t>obj)

    cls_ret = eina_hash_find(object_mapping, cls_name)

    if cls_ret == NULL:
        # TODO: Add here a last ditch effort to import the class from a module
        raise ValueError(
            "Eo object at %#x of type %s does not have a mapping!" % (
                <uintptr_t>obj, cls_name)
            )

    cls = <type>cls_ret

    if cls is None:
        raise ValueError(
            "Mapping for Eo object at %#x, type %s, contains None!" % (
                <uintptr_t>obj, cls_name))

    EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN,
        "Constructing a Python object from Eo of type %s.", cls_name)

    o = cls.__new__(cls)
    o._set_obj(obj)
    return o


cdef void _register_decorated_callbacks(Eo obj):
    """

    Search every attrib of the pyobj for a __decorated_callbacks__ object,
    a list actually. If found then exec the functions listed there, with their
    arguments. Must be called just after the _set_obj call.
    List items signature: ("function_name", *args)

    """
    cdef object attr_name, attrib, func_name, func
    cdef type cls = type(obj)

    # XXX: This whole thing is really slow. Can we do it better?

    for attr_name, attrib in cls.__dict__.items():
        if "__decorated_callbacks__" in dir(attrib):
            for (func_name, *args) in getattr(attrib, "__decorated_callbacks__"):
                func = getattr(obj, func_name)
                func(*args)


######################################################################


EO_CALLBACK_STOP = enums.EO_CALLBACK_STOP
EO_CALLBACK_CONTINUE = enums.EO_CALLBACK_CONTINUE


######################################################################


cdef Eina_Bool _eo_event_del_cb(void *data, cEo *obj,
    const_Eo_Event_Description *desc, void *event_info) with gil:
    cdef:
        Eo self = <Eo>data
        const_char *cls_name = eo_class_name_get(eo_class_get(obj))

    EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN, "Deleting Eo: %s", cls_name)

    eo_do(self.obj,
        eo_event_callback_del(EO_EV_DEL, _eo_event_del_cb, <const_void *>self))
    eo_do(self.obj, eo_base_data_del("python-eo"))
    self.obj = NULL
    Py_DECREF(self)

    return enums.EO_CALLBACK_STOP


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

    def __repr__(self):
        cdef cEo *parent = NULL
        if self.obj != NULL:
            eo_do(self.obj, eo_parent_get(&parent))
        return ("<%s object (Eo) at %#x (obj=%#x, parent=%#x, refcount=%d)>") % (
            type(self).__name__,
            <uintptr_t><void *>self,
            <uintptr_t>self.obj,
            <uintptr_t>parent,
            PY_REFCOUNT(self))

    def __nonzero__(self):
        return 1 if self.obj != NULL else 0

    cdef int _set_obj(self, cEo *obj) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_base_data_set("python-eo", <void *>self, NULL))
        eo_do(self.obj,
            eo_event_callback_add(EO_EV_DEL, _eo_event_del_cb, <const_void *>self))
        Py_INCREF(self)

        return 1

    cdef int _set_properties_from_keyword_args(self, dict kwargs) except 0:
        if not kwargs:
            return 1
        cdef list cls_list = dir(self)
        for k, v in kwargs.items():
            assert k in cls_list, "%s has no attribute with the name %s." % (self, k)
            setattr(self, k, v)
        return 1

    def delete(self):
        eo_del(self.obj)

    def is_deleted(self):
        "Check if the object has been deleted thus leaving the object shallow"
        return bool(self.obj == NULL)

    def parent_set(self, Eo parent):
        eo_do(self.obj, eo_parent_set(parent.obj))

    def parent_get(self):
        cdef cEo *parent = NULL
        eo_do(self.obj, eo_parent_get(&parent))
        return object_from_instance(parent)

    def event_freeze(self):
        eo_do(self.obj, eo_event_freeze())

    def event_thaw(self):
        eo_do(self.obj, eo_event_thaw())

    def event_freeze_get(self):
        cdef int fcount
        eo_do(self.obj, eo_event_freeze_get(&fcount))
        return fcount
