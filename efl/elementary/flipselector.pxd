from efl.evas cimport Eina_Bool, Evas_Object, Eina_List
from efl.evas cimport Evas_Smart_Cb
from object_item cimport Elm_Object_Item

cdef extern from "Elementary.h":
    Evas_Object             *elm_flipselector_add(Evas_Object *parent)
    void                     elm_flipselector_flip_next(Evas_Object *obj)
    void                     elm_flipselector_flip_prev(Evas_Object *obj)
    Elm_Object_Item         *elm_flipselector_item_append(Evas_Object *obj, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_flipselector_item_prepend(Evas_Object *obj, const char *label, Evas_Smart_Cb func, void *data)
    const Eina_List         *elm_flipselector_items_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_flipselector_first_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_flipselector_last_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_flipselector_selected_item_get(const Evas_Object *obj)
    void                     elm_flipselector_item_selected_set(Elm_Object_Item *it, Eina_Bool selected)
    Eina_Bool                elm_flipselector_item_selected_get(const Elm_Object_Item *it)
    Elm_Object_Item         *elm_flipselector_item_prev_get(const Elm_Object_Item *it)
    Elm_Object_Item         *elm_flipselector_item_next_get(const Elm_Object_Item *it)
    void                     elm_flipselector_first_interval_set(Evas_Object *obj, double interval)
    double                   elm_flipselector_first_interval_get(const Evas_Object *obj)

