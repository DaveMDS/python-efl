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

from cpython cimport PyObject, Py_INCREF, Py_DECREF
from efl cimport Eina_Bool, const_Eina_List, eina_list_append
from efl.c_eo cimport Eo as cEo
from efl.c_eo cimport eo_init, eo_shutdown, eo_del, eo_unref, eo_wref_add, eo_add, Eo_Class
from efl.c_eo cimport eo_do, eo_class_name_get, eo_class_get
from efl.c_eo cimport eo_base_data_set, eo_base_data_get, eo_base_data_del
from efl.c_eo cimport eo_event_callback_add, eo_event_callback_del, Eo_Event_Description
from efl.c_eo cimport eo_parent_get
from efl.c_eo cimport EO_EV_DEL


######################################################################

cdef int PY_REFCOUNT(object o):
    cdef PyObject *obj = <PyObject *>o
    return obj.ob_refcnt
 

cdef inline unicode _touni(char* s):
    return s.decode('UTF-8', 'strict') if s else None


cdef inline unicode _ctouni(const_char_ptr s):
    return s.decode('UTF-8', 'strict') if s else None


cdef inline char *_fruni(s):
    cdef char *c_string
    if s is None:
        return NULL
    if isinstance(s, unicode):
        string = s.encode('UTF-8')
        c_string = string
    elif isinstance(s, str):
        c_string = s
    else:
        raise TypeError("Expected str or unicode object, got %s" % (type(s).__name__))
    return c_string


cdef inline const_char_ptr _cfruni(s):
    cdef const_char_ptr c_string
    if s is None:
        return NULL
    if isinstance(s, unicode):
        string = s.encode('UTF-8')
        c_string = string
    elif isinstance(s, str):
        c_string = s
    else:
        raise TypeError("Expected str or unicode object, got %s" % (type(s).__name__))
    return c_string


cdef _strings_to_python(const_Eina_List *lst):
    cdef const_char_ptr s
    ret = []
    while lst:
        s = <const_char_ptr>lst.data
        if s != NULL:
            ret.append(_ctouni(s))
        lst = lst.next
    return ret


cdef Eina_List * _strings_from_python(strings):
    cdef Eina_List *lst = NULL
    for s in strings:
        lst = eina_list_append(lst, _cfruni(s))
    return lst


cdef inline _object_list_to_python(const_Eina_List *lst):
    ret = []
    while lst:
        ret.append(object_from_instance(<cEo *>lst.data))
        lst = lst.next
    return ret


######################################################################


cdef object object_mapping
"""Object mapping is a dictionary into which object type names can be
registered. These can be used to find a bindings class for an object using
the object_from_instance function."""
object_mapping = dict()


cdef _object_mapping_register(char *name, cls):
#     print("REGISTER: %s => %s" % (name, cls))
    if name in object_mapping:
        raise ValueError("object type name '%s' already registered." % name)
    object_mapping[name] = cls


cdef _object_mapping_unregister(char *name):
    object_mapping.pop(name)


cdef object object_from_instance(cEo *obj):
    """ Create a python object from a C Eo object pointer. """
    cdef void *data
    cdef Eo o

    if obj == NULL:
        return None

    eo_do(obj, eo_base_data_get("python-eo", &data))
    if data != NULL:
#         print("Found: %s" % Eo.__repr__(<Eo>data))
        return <Eo>data

    klass_name = eo_class_name_get(eo_class_get(obj))
    if klass_name == NULL:
        raise ValueError("Eo object %#x does not have a type!" % <long>obj)
#     print("Klass name: %s" % klass_name)

    klass = object_mapping.get(klass_name, None)
    if klass == None:
        raise ValueError("Eo object %#x of type %s does not have a mapping!" %
                         (<long>obj, klass_name))

#     print "MAPPING OBJECT:", klass_name, "=>", klass
    o = klass.__new__(klass)
    o._set_obj(obj)
    return o
#
# TODO extended object mapping (for SmartObject, EdjeExternal, etc)
#
#         t = evas_object_type_get(obj)
#         if t == NULL:
#             raise ValueError("Evas object %#x does not have a type!" %
#                              <long>obj)
#         ot = _ctouni(t)
#         c = Canvas_from_instance(evas_object_evas_get(obj))
#         cls = object_mapping.get(ot, None)
#         if cls is None:
#             cls_resolver = extended_object_mapping.get(ot, None)
#             if cls_resolver is None:
#                 warnings.warn(
#                     ("Evas_Object %#x of type %s has no direct or "
#                      "extended mapping! Using generic wrapper.") %
#                     (<unsigned long>obj, ot))
#                 cls = Object
#             else:
#                 cls = cls_resolver(<unsigned long>obj)
#         o = cls.__new__(cls)
#         o._set_evas(c)


######################################################################


EO_CALLBACK_STOP = 0
EO_CALLBACK_CONTINUE = 1


######################################################################


cdef Eina_Bool _eo_event_del_cb(void *data, cEo *obj, Eo_Event_Description *desc, void *event_info) with gil:
    cdef Eo self = <Eo>data

#     print("DEL CB: %s" % Eo.__repr__(self))

    eo_do(self.obj, eo_event_callback_del(EO_EV_DEL, _eo_event_del_cb, <void *>self))
    eo_do(self.obj, eo_base_data_del("python-eo"))
    self.obj = NULL
    Py_DECREF(self)

    return EO_CALLBACK_STOP


cdef class Eo(object):
    """
    Base class used by all the Eo object in the bindings, its not meant to be
    used by users, but only by internal classes.
    """

    # c globals declared in eo.pxd (to make the class available to others)

    def __cinit__(self):
        self.obj = NULL
        self.data = dict()

    def __init__(self):
#         print("Eo __init__()")
        pass

    def __dealloc__(self):
#         print("Eo __dealloc__(): %s" % Eo.__repr__(self))
        pass
        

    def __str__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (self.__class__.__name__, <unsigned long>self.obj,
                 <unsigned long>eo_parent_get(self.obj) if self.obj else 0,
                 PY_REFCOUNT(self))
        

    def __repr__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (self.__class__.__name__, <unsigned long>self.obj,
                 <unsigned long>eo_parent_get(self.obj) if self.obj else 0,
                 PY_REFCOUNT(self))

#     cdef _add_obj(self, Eo_Class *klass, cEo *parent):
#         cdef cEo *obj
#         assert self.obj == NULL, "Object must be clean"
#         obj = eo_add(klass, parent)
#         self._set_obj(obj)
#         eo_unref(obj)

    cdef _set_obj(self, cEo *obj):
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_base_data_set("python-eo", <void *>self, NULL))
        eo_do(self.obj, eo_event_callback_add(EO_EV_DEL, _eo_event_del_cb, <void *>self))
        Py_INCREF(self)

#     cdef _unset_obj(self): # __UNUSED__
#         if self.obj != NULL:
#             self.obj = NULL
#             Py_DECREF(self) ????????????????????'
        # TODO evas_object_data_del("python-eo") ??

#     def delete(self):
#         """
#         Delete object and free it's internal (wrapped) resources.
# 
#         @note: after this operation the object will be still alive in
#             Python, but it will be shallow and every operation
#             will have no effect (and may raise exceptions).
#         @raise ValueError: if object already deleted.
#         """
#         if self.obj == NULL:
#             raise ValueError("Object already deleted")
#         print("Eo delete: %s" % Eo.__repr__(self))
#         eo_del(self.obj)

    def is_deleted(self):
        """
        Check if the Eo object associated with this python object has been
        deleted, thus leaving the object as shallow.
        """
        return bool(self.obj == NULL)


def init():
    return eo_init()


def shutdown():
    return eo_shutdown()


init()
