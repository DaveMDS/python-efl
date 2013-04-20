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

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy, strdup
from efl cimport Eina_Bool, const_Eina_List, eina_list_append, const_void, \
    Eina_Hash, eina_hash_string_superfast_new, eina_hash_add, eina_hash_del, \
    eina_hash_find
from efl.c_eo cimport Eo as cEo, eo_init, eo_shutdown, eo_del, eo_do, \
    eo_class_name_get, eo_class_get, eo_base_data_set, eo_base_data_get, \
    eo_base_data_del, eo_event_callback_add, eo_event_callback_del, \
    Eo_Event_Description, const_Eo_Event_Description, \
    eo_parent_get, EO_EV_DEL

import traceback

######################################################################
#
# TODO: Automate these
#
# Call eo_init and put eo_shutdown to atexit, and don't expose in our API.
#
# Do the same in other packages as well, making sure the packages main
# module is always imported.
#
def init():
    return eo_init()

def shutdown():
    return eo_shutdown()

init()


cdef int PY_REFCOUNT(object o):
    cdef PyObject *obj = <PyObject *>o
    return obj.ob_refcnt

cdef unicode _touni(char* s):
    """

    Converts a char * to a python string object

    """
    return s.decode('UTF-8', 'strict') if s else None


cdef unicode _ctouni(const_char *s):
    """

    Converts a const_char * to a python string object

    """
    return s.decode('UTF-8', 'strict') if s else None


cdef list convert_array_of_strings_to_python_list(char **array, int array_length):
    """

    Converts an array of strings to a python list.

    """
    cdef:
        char *string
        list ret = list()
        int i

    for i in range(array_length):
        string = array[i]
        ret.append(_touni(string))
    return ret


cdef const_char ** convert_python_list_strings_to_array_of_strings(list strings) except NULL:
    """

    Converts a python list to an array of strings.

    Note: Remember to free the array when it's no longer needed.

    """
    cdef:
        const_char **array = NULL
        const_char *string
        unsigned int str_len, i
        unsigned int arr_len = len(strings)

    # TODO: Should we just return NULL in this case?
    if arr_len == 0:
        array = <const_char **>malloc(sizeof(const_char*))
        if not array:
            raise MemoryError()
        array[0] = NULL
        return array

    array = <const_char **>malloc(arr_len * sizeof(const_char*))
    if not array:
        raise MemoryError()

    for i in range(arr_len):
        s = strings[i]
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        array[i] = <const_char *>strdup(s)

    return array


cdef list convert_eina_list_strings_to_python_list(const_Eina_List *lst):
    cdef:
        const_char *s
        list ret = []
        Eina_List *itr = <Eina_List *>lst
    while itr:
        s = <const_char *>itr.data
        ret.append(_ctouni(s))
        itr = itr.next
    return ret


cdef Eina_List *convert_python_list_strings_to_eina_list(list strings):
    cdef Eina_List *lst = NULL
    for s in strings:
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        lst = eina_list_append(lst, strdup(s))
    return lst


cdef list _object_list_to_python(const_Eina_List *lst):
    cdef list ret = list()
    while lst:
        ret.append(object_from_instance(<cEo *>lst.data))
        lst = lst.next
    return ret


cdef Eina_List *convert_python_list_objects_to_eina_list(list objects):
    cdef:
        Eina_List *lst
        Eo o
    for o in objects:
        lst = eina_list_append(lst, o.obj)
    return lst


cdef void _METHOD_DEPRECATED(object self, char *message):
    cdef:
        object stack
        tuple caller
        str msg

    stack = traceback.extract_stack()
    caller = stack[-1]
    caller_module, caller_line, caller_name, caller_code = caller
    if caller_code is not None:
        msg = "%s:%s %s (class %s) is deprecated. %s" % \
            (caller_module, caller_line, caller_code,
            type(self).__name__, message)
    else:
        msg = "%s:%s %s.%s() is deprecated. %s" % \
            (caller_module, caller_line,
            type(self).__name__, caller_name, message)
#     log.warn(msg)
    print(msg)


######################################################################


"""
Object mapping is an Eina Hash table into which object type names can be
registered. These can be used to find a bindings class for an object using
the object_from_instance function."""
cdef Eina_Hash *object_mapping = eina_hash_string_superfast_new(NULL)


cdef void _object_mapping_register(char *name, object cls) except *:

    if eina_hash_find(object_mapping, name) != NULL:
        raise ValueError("Object type name '%s' already registered." % name)

    #print("REGISTER: %s => %s" % (name, cls))
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

    cls = <type>eina_hash_find(object_mapping, cls_name)
    if cls is None:
        raise ValueError("Eo object %#x of type %s does not have a mapping!" %
                         (<long>obj, cls_name))

    #print "MAPPING OBJECT:", cls_name, "=>", cls
    o = cls.__new__(cls)
    o._set_obj(obj)
    return o


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
        self.obj = NULL
        self.data = dict()

    def __dealloc__(self):
        self.data.clear()

    def __init__(self, *args, **kwargs):
        if type(self) is Eo:
            raise TypeError("Must not instantiate Eo, but subclasses")

    def __str__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (type(self).__name__, <unsigned long>self.obj,
                 <unsigned long>eo_parent_get(self.obj) if self.obj != NULL else 0,
                 PY_REFCOUNT(self))

    def __repr__(self):
        return ("Eo(class=%s, obj=%#x, parent=%#x, refcount=%d)") % \
                (type(self).__name__, <unsigned long>self.obj,
                 <unsigned long>eo_parent_get(self.obj) if self.obj != NULL else 0,
                 PY_REFCOUNT(self))

    cdef void _set_obj(self, cEo *obj) except *:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_base_data_set("python-eo", <void *>self, NULL))
        eo_do(self.obj, eo_event_callback_add(EO_EV_DEL, _eo_event_del_cb, <const_void *>self))
        Py_INCREF(self)

    def is_deleted(self):
        "Check if the object has been deleted thus leaving the object shallow"
        return bool(self.obj == NULL)

