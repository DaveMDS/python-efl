from efl.evas cimport Eina_Bool, Evas_Object
from object_item cimport Elm_Object_Item, ObjectItem
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_segment_control_add(Evas_Object *parent)
    Elm_Object_Item         *elm_segment_control_item_add(Evas_Object *obj, Evas_Object *icon, const_char *label)
    Elm_Object_Item         *elm_segment_control_item_insert_at(Evas_Object *obj, Evas_Object *icon, const_char *label, int index)
    void                     elm_segment_control_item_del_at(Evas_Object *obj, int index)
    int                      elm_segment_control_item_count_get(Evas_Object *obj)
    Elm_Object_Item         *elm_segment_control_item_get(Evas_Object *obj, int index)
    const_char *             elm_segment_control_item_label_get(Evas_Object *obj, int index)
    Evas_Object             *elm_segment_control_item_icon_get(Evas_Object *obj, int index)
    int                      elm_segment_control_item_index_get(Elm_Object_Item *it)
    Evas_Object             *elm_segment_control_item_object_get(Elm_Object_Item *it)
    Elm_Object_Item         *elm_segment_control_item_selected_get(Evas_Object *obj)
    void                     elm_segment_control_item_selected_set(Elm_Object_Item *it, Eina_Bool select)
