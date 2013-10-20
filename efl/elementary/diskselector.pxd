from efl.evas cimport Eina_Bool, const_Eina_List, Evas_Object, Evas_Smart_Cb
from object_item cimport Elm_Object_Item, ObjectItem
from enums cimport Elm_Scroller_Policy
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_diskselector_add(Evas_Object *parent)
    void                     elm_diskselector_round_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool                elm_diskselector_round_enabled_get(Evas_Object *obj)
    int                      elm_diskselector_side_text_max_length_get(Evas_Object *obj)
    void                     elm_diskselector_side_text_max_length_set(Evas_Object *obj, int len)
    void                     elm_diskselector_display_item_num_set(Evas_Object *obj, int num)
    int                      elm_diskselector_display_item_num_get(Evas_Object *obj)
    void                     elm_diskselector_bounce_set(Evas_Object *obj, Eina_Bool h_bounce, Eina_Bool v_bounce)
    void                     elm_diskselector_bounce_get(Evas_Object *obj, Eina_Bool *h_bounce, Eina_Bool *v_bounce)
    void                     elm_diskselector_scroller_policy_get(Evas_Object *obj, Elm_Scroller_Policy *policy_h, Elm_Scroller_Policy *policy_v)
    void                     elm_diskselector_scroller_policy_set(Evas_Object *obj, Elm_Scroller_Policy policy_h, Elm_Scroller_Policy policy_v)
    void                     elm_diskselector_clear(Evas_Object *obj)
    const_Eina_List         *elm_diskselector_items_get(Evas_Object *obj)
    Elm_Object_Item         *elm_diskselector_item_append(Evas_Object *obj, const_char *label, Evas_Object *icon, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_diskselector_selected_item_get(Evas_Object *obj)
    void                     elm_diskselector_item_selected_set(Elm_Object_Item *it, Eina_Bool selected)
    Eina_Bool                elm_diskselector_item_selected_get(Elm_Object_Item *it)
    Elm_Object_Item         *elm_diskselector_first_item_get(Evas_Object *obj)
    Elm_Object_Item         *elm_diskselector_last_item_get(Evas_Object *obj)
    Elm_Object_Item         *elm_diskselector_item_prev_get(Elm_Object_Item *it)
    Elm_Object_Item         *elm_diskselector_item_next_get(Elm_Object_Item *it)

