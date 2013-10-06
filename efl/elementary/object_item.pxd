from efl.evas cimport Eina_Bool, const_Eina_List, Evas_Object, Evas_Smart_Cb, \
    Eina_List, const_Eina_List

cdef extern from "Elementary.h":

    ctypedef struct Elm_Object_Item
    ctypedef Elm_Object_Item const_Elm_Object_Item "const Elm_Object_Item"

    Evas_Object *   elm_object_item_widget_get(Elm_Object_Item *it)
    void *          elm_object_item_data_get(Elm_Object_Item *item)
    void            elm_object_item_data_set(Elm_Object_Item *item, void *data)

cdef _object_item_to_python(Elm_Object_Item *it)
cdef Elm_Object_Item * _object_item_from_python(ObjectItem item) except NULL
cdef _object_item_list_to_python(const_Eina_List *lst)
cdef void _object_item_del_cb(void *data, Evas_Object *o, void *event_info) with gil
cdef void _object_item_callback(void *data, Evas_Object *obj, void *event_info) with gil

cdef class ObjectItem(object):
    cdef:
        Elm_Object_Item *item
        object cb_func
        tuple args
        dict kwargs
        int _set_obj(self, Elm_Object_Item *item) except 0

    cpdef text_set(self, text)
    cpdef text_get(self)
    cpdef access_info_set(self, txt)
    cpdef tooltip_style_set(self, style=*)
    cpdef tooltip_style_get(self)
    cpdef cursor_set(self, cursor)
    cpdef cursor_get(self)
    cpdef cursor_unset(self)
    cpdef cursor_style_set(self, style=*)
    cpdef cursor_style_get(self)
