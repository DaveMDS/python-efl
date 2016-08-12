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

:mod:`efl.eo` Module
####################

Classes
=======

.. toctree::

   class-eo.rst

"""

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String

from libc.stdint cimport uintptr_t
from efl.eina cimport Eina_Bool, \
    Eina_Hash, eina_hash_string_superfast_new, eina_hash_add, eina_hash_del, \
    eina_hash_find, EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, \
    Eina_Iterator, eina_iterator_next, eina_iterator_free
from efl.c_eo cimport Eo as cEo, eo_init, eo_shutdown, eo_del, \
    eo_class_name_get, eo_class_get, eo_base_class_get,\
    eo_key_data_set, eo_key_data_get, \
    eo_event_callback_add, eo_event_callback_del, EO_EVENT_DEL, \
    eo_parent_get, eo_parent_set, Eo_Event_Description, \
    eo_event_freeze, eo_event_thaw, eo_event_freeze_count_get, \
    eo_event_global_freeze, eo_event_global_thaw, \
    eo_event_global_freeze_count_get, eo_event_callback_stop, \
    eo_children_iterator_new, Eo_Event

from efl.utils.logger cimport add_logger

# Set this to public and export it in pxd if you need it in another module
cdef int PY_EFL_EO_LOG_DOMAIN = add_logger(__name__).eina_log_domain

cdef int PY_REFCOUNT(object o):
    cdef PyObject *obj = <PyObject *>o
    return obj.ob_refcnt

import atexit

######################################################################

def init():
    EINA_LOG_DOM_INFO(PY_EFL_EO_LOG_DOMAIN, "Initializing efl.eo", NULL)
    return eo_init()

def shutdown():
    EINA_LOG_DOM_INFO(PY_EFL_EO_LOG_DOMAIN, "Shutting down efl.eo", NULL)
    return eo_shutdown()

init()
atexit.register(shutdown)

def event_global_freeze_count_get():
    return eo_event_global_freeze_count_get(<const cEo *>eo_base_class_get())

def event_global_freeze():
    eo_event_global_freeze(<const cEo *>eo_base_class_get())

def event_global_thaw():
    eo_event_global_thaw(<const cEo *>eo_base_class_get())

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


cdef api object object_from_instance(cEo *obj):
    """ Create a python object from a C Eo object pointer. """
    cdef:
        void *data = NULL
        Eo o
        const char *cls_name = eo_class_name_get(eo_class_get(obj))
        type cls
        void *cls_ret

    if obj == NULL:
        return None

    data = eo_key_data_get(obj, "python-eo")
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

cdef api cEo *instance_from_object(object obj):
    cdef Eo o = obj
    return o.obj


cdef void _register_decorated_callbacks(Eo obj):
    """

    Search every attrib of the pyobj for a __decorated_callbacks__ object,
    a list actually. If found then exec the functions listed there, with their
    arguments. Must be called just after the _set_obj call.
    List items signature: ("function_name", *args)

    """
    cdef object attr_name, attrib, func_name, func
    cdef type cls = type(obj)

    # FIXME: This whole thing is really slow. Can we do it better?

    for attr_name, attrib in cls.__dict__.items():
        if "__decorated_callbacks__" in dir(attrib):
            for (func_name, *args) in getattr(attrib, "__decorated_callbacks__"):
                func = getattr(obj, func_name)
                func(*args)


######################################################################


cdef void _eo_event_del_cb(void *data, const Eo_Event *event) with gil:
    cdef:
        Eo self = <Eo>data
        const char *cls_name = eo_class_name_get(eo_class_get(self.obj))

    EINA_LOG_DOM_DBG(PY_EFL_EO_LOG_DOMAIN, "Deleting Eo: %s", cls_name)

    eo_event_callback_stop(self.obj)
    eo_event_callback_del(self.obj, EO_EVENT_DEL, _eo_event_del_cb, <const void *>self)
    eo_key_data_set(self.obj, "python-eo", NULL)
    self.obj = NULL
    Py_DECREF(self)


cdef class EoIterator:

    def __iter__(self):
        return self

    def __next__(self):
        cdef:
            void* tmp
            Eina_Bool result

        if not eina_iterator_next(self.itr, &tmp):
            raise StopIteration

        return object_from_instance(<cEo *>tmp)

    def __dealloc__(self):
        eina_iterator_free(self.itr)


cdef class Eo(object):
    """

    Base class used by all the object in the EFL.

    """

    # c globals declared in eo.pxd (to make the class available to others)

    def __cinit__(self):
        self.data = dict()
        self.internal_data = dict()

    def __init__(self, *args, **kwargs):
        if type(self) is Eo:
            raise TypeError("Must not instantiate Eo, but subclasses")

    def __repr__(self):
        cdef cEo *parent = NULL
        if self.obj != NULL:
            parent = eo_parent_get(self.obj)
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
        eo_key_data_set(self.obj, "python-eo", <void *>self)
        eo_event_callback_add(self.obj, EO_EVENT_DEL, _eo_event_del_cb, <const void *>self)
        Py_INCREF(self)

        # from efl 1.18 eo.parent changed behaviour, objects are now reparented
        # when, fe, swallowed. This is the hack to keep the old behavior.
        try:
            parent = object_from_instance(eo_parent_get(obj))
        except ValueError:
            parent = None
        self.internal_data["_legacy_parent"] = parent

        return 1

    def _wipe_obj_data_NEVER_USE_THIS(self):
        # only used in tests/eo/test_02_class_names.py
        # to force object_from_instance() to recreate the obj
        eo_key_data_set(self.obj, "python-eo", NULL)

    cdef int _set_properties_from_keyword_args(self, dict kwargs) except 0:
        if kwargs:
            for k, v in kwargs.items():
                setattr(self, k, v)
        return 1

    def __iter__(self):
        return EoIterator.create(eo_children_iterator_new(self.obj))

    def delete(self):
        """Delete the object and free internal resources.

        .. note:: This will not delete the python object, but only the internal
            C one. The python object will be automatically deleted by the
            garbage collector when there are no more reference to it.

        """
        eo_del(self.obj)

    def is_deleted(self):
        """Check if the object has been deleted thus leaving the object shallow.

        :return: True if the object has been deleted yet, False otherwise.
        :rtype: bool

        """
        return bool(self.obj == NULL)

    property parent:
        """The parent object

        :type: :class:`Eo`

        """
        def __set__(self, Eo parent):
            self.internal_data["_legacy_parent"] = parent
            eo_parent_set(self.obj, parent.obj)

        def __get__(self):
            return self.internal_data["_legacy_parent"]

    def parent_set(self, Eo parent):
        self.internal_data["_legacy_parent"] = parent
        eo_parent_set(self.obj, parent.obj)

    def parent_get(self):
        return self.internal_data["_legacy_parent"]

    def event_freeze(self):
        """Pause event propagation for this object."""
        eo_event_freeze(self.obj)

    def event_thaw(self):
        """Restart event propagation for this object."""
        eo_event_thaw(self.obj)

    def event_freeze_count_get(self):
        """Get the event freeze count for this object.

        :return: the freeze count
        :rtype: int

        """
        return eo_event_freeze_count_get(self.obj)
