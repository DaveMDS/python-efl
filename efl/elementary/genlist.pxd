cdef extern from "Elementary.h":
    ctypedef struct Elm_Genlist_Item_Class

cdef class GenlistItemClass(object):
    cdef:
        Elm_Genlist_Item_Class *cls
        object _text_get_func
        object _content_get_func
        object _state_get_func
        object _del_func
        object _item_style
        object _decorate_item_style
        object _decorate_all_item_style
