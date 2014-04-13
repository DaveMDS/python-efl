from efl.evas cimport Eina_Bool, Eina_List, Evas_Object, Evas_Smart_Cb
from object_item cimport Elm_Object_Item

cdef extern from "Elementary.h":

    ctypedef Eina_Bool (*Elm_Multibuttonentry_Item_Filter_Cb)(Evas_Object *obj, const char *item_label, void *item_data, void *data)
    ctypedef char * (*Elm_Multibuttonentry_Format_Cb)(int count, void *data)

    Evas_Object             *elm_multibuttonentry_add(Evas_Object *parent)
    Evas_Object             *elm_multibuttonentry_entry_get(const Evas_Object *obj)
    Eina_Bool                elm_multibuttonentry_expanded_get(const Evas_Object *obj)
    void                     elm_multibuttonentry_expanded_set(Evas_Object *obj, Eina_Bool expanded)
    Elm_Object_Item         *elm_multibuttonentry_item_prepend(Evas_Object *obj, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_multibuttonentry_item_append(Evas_Object *obj, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_multibuttonentry_item_insert_before(Evas_Object *obj, Elm_Object_Item *before, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_multibuttonentry_item_insert_after(Evas_Object *obj, Elm_Object_Item *after, const char *label, Evas_Smart_Cb func, void *data)
    const Eina_List         *elm_multibuttonentry_items_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_multibuttonentry_first_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_multibuttonentry_last_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_multibuttonentry_selected_item_get(const Evas_Object *obj)
    void                     elm_multibuttonentry_item_selected_set(Elm_Object_Item *it, Eina_Bool selected)
    Eina_Bool                elm_multibuttonentry_item_selected_get(const Elm_Object_Item *it)
    void                     elm_multibuttonentry_clear(Evas_Object *obj)
    Elm_Object_Item         *elm_multibuttonentry_item_prev_get(const Elm_Object_Item *it)
    Elm_Object_Item         *elm_multibuttonentry_item_next_get(const Elm_Object_Item *it)
    void                     elm_multibuttonentry_item_filter_append(Evas_Object *obj, Elm_Multibuttonentry_Item_Filter_Cb func, void *data)
    void                     elm_multibuttonentry_item_filter_prepend(Evas_Object *obj, Elm_Multibuttonentry_Item_Filter_Cb func, void *data)
    # TODO: void                     elm_multibuttonentry_item_filter_remove(Evas_Object *obj, Elm_Multibuttonentry_Item_Filter_Cb func, void *data)
    void                    elm_multibuttonentry_editable_set(Evas_Object *obj, Eina_Bool editable)
    Eina_Bool               elm_multibuttonentry_editable_get(const Evas_Object *obj)
    void                    elm_multibuttonentry_format_function_set(Evas_Object *obj, Elm_Multibuttonentry_Format_Cb f_func, const void *data)
