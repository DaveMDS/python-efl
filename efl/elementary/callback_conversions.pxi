from libc.string cimport const_char
from object_item cimport Elm_Object_Item
from object_item cimport _object_item_to_python

def _cb_string_conv(long addr):
    cdef const_char *s = <const_char *>addr
    return _ctouni(s) if s is not NULL else None

def _cb_object_item_conv(long addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)
