from efl.evas cimport Eina_Bool, Eina_List, Eina_Compare_Cb, Evas_Object, Evas_Smart_Cb, Evas_Coord
from object cimport Object
from object_item cimport Elm_Object_Item
from general cimport Elm_Tooltip_Item_Content_Cb
from enums cimport Elm_Scroller_Policy, Elm_List_Mode, Elm_Object_Select_Mode, \
    Elm_Genlist_Item_Type, Elm_Genlist_Item_Scrollto_Type, \
    Elm_Genlist_Item_Field_Type
from libc.string cimport const_char

cdef extern from "Elementary.h":

    #genlist
    ctypedef char           *(*GenlistItemLabelGetFunc)     (void *data, Evas_Object *obj, const_char *part)
    ctypedef Evas_Object    *(*GenlistItemIconGetFunc)      (void *data, Evas_Object *obj, const_char *part)
    ctypedef Eina_Bool       (*GenlistItemStateGetFunc)     (void *data, Evas_Object *obj, const_char *part)
    ctypedef void            (*GenlistItemDelFunc)          (void *data, Evas_Object *obj)

    ctypedef struct Elm_Genlist_Item_Class_Func:
        GenlistItemLabelGetFunc text_get
        GenlistItemIconGetFunc content_get
        GenlistItemStateGetFunc state_get
        GenlistItemDelFunc del_ "del"

    ctypedef struct Elm_Genlist_Item_Class:
        char *item_style
        Elm_Genlist_Item_Class_Func func

    # Generic List          (api:TODO  cb:DONE  test:DONE  doc:TODO  py3:TODO)
    Evas_Object *           elm_genlist_add(Evas_Object *parent)
    void                    elm_genlist_clear(Evas_Object *obj)
    void                    elm_genlist_multi_select_set(Evas_Object *obj, Eina_Bool multi)
    Eina_Bool               elm_genlist_multi_select_get(Evas_Object *obj)
    void                    elm_genlist_mode_set(Evas_Object *obj, Elm_List_Mode mode)
    Elm_List_Mode           elm_genlist_mode_get(Evas_Object *obj)
    void                    elm_genlist_bounce_set(Evas_Object *obj, Eina_Bool h_bounce, Eina_Bool v_bounce)
    void                    elm_genlist_bounce_get(Evas_Object *obj, Eina_Bool *h_bounce, Eina_Bool *v_bounce)
    Elm_Object_Item *       elm_genlist_item_append(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_prepend(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_insert_before(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Object_Item *before, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_insert_after(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Object_Item *after, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_sorted_insert(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Eina_Compare_Cb comp, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_selected_item_get(Evas_Object *obj)
    Eina_List *             elm_genlist_selected_items_get(Evas_Object *obj)
    Eina_List *             elm_genlist_realized_items_get(Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_first_item_get(Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_last_item_get(Evas_Object *obj)
    void                    elm_genlist_scroller_policy_set(Evas_Object *obj, Elm_Scroller_Policy policy_h, Elm_Scroller_Policy policy_v)
    void                    elm_genlist_scroller_policy_get(Evas_Object *obj, Elm_Scroller_Policy *policy_h, Elm_Scroller_Policy *policy_v)

    Elm_Object_Item *       elm_genlist_item_next_get(Elm_Object_Item *item)
    Elm_Object_Item *       elm_genlist_item_prev_get(Elm_Object_Item *item)
    void                    elm_genlist_item_selected_set(Elm_Object_Item *item, Eina_Bool selected)
    Eina_Bool               elm_genlist_item_selected_get(Elm_Object_Item *item)
    void                    elm_genlist_item_show(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_genlist_item_bring_in(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_genlist_item_update(Elm_Object_Item *item)
    void                    elm_genlist_item_item_class_update(Elm_Object_Item *it, Elm_Genlist_Item_Class *itc)
    Elm_Genlist_Item_Class *elm_genlist_item_item_class_get(Elm_Object_Item *it)
    int                     elm_genlist_item_index_get(Elm_Object_Item *it)
    void                    elm_genlist_realized_items_update(Evas_Object *obj)
    unsigned int            elm_genlist_items_count(Evas_Object *obj)
    void                    elm_genlist_item_tooltip_text_set(Elm_Object_Item *item, const_char *text)
    void                    elm_genlist_item_tooltip_content_cb_set(Elm_Object_Item *item, Elm_Tooltip_Item_Content_Cb func, void *data, Evas_Smart_Cb del_cb)
    void                    elm_genlist_item_tooltip_unset(Elm_Object_Item *item)
    void                    elm_genlist_item_tooltip_style_set(Elm_Object_Item *item, const_char *style)
    const_char *            elm_genlist_item_tooltip_style_get(Elm_Object_Item *item)
    Eina_Bool               elm_genlist_item_tooltip_window_mode_set(Elm_Object_Item *it, Eina_Bool disable)
    Eina_Bool               elm_genlist_item_tooltip_window_mode_get(Elm_Object_Item *it)
    void                    elm_genlist_item_cursor_set(Elm_Object_Item *item, const_char *cursor)
    const_char *            elm_genlist_item_cursor_get(Elm_Object_Item *it)
    void                    elm_genlist_item_cursor_unset(Elm_Object_Item *item)
    void                    elm_genlist_item_cursor_style_set(Elm_Object_Item *item, const_char *style)
    const_char *            elm_genlist_item_cursor_style_get(Elm_Object_Item *item)
    void                    elm_genlist_item_cursor_engine_only_set(Elm_Object_Item *item, Eina_Bool engine_only)
    Eina_Bool               elm_genlist_item_cursor_engine_only_get(Elm_Object_Item *item)
    void                    elm_genlist_homogeneous_set(Evas_Object *obj, Eina_Bool homogeneous)
    Eina_Bool               elm_genlist_homogeneous_get(Evas_Object *obj)
    void                    elm_genlist_block_count_set(Evas_Object *obj, int n)
    int                     elm_genlist_block_count_get(Evas_Object *obj)
    void                    elm_genlist_longpress_timeout_set(Evas_Object *obj, double timeout)
    double                  elm_genlist_longpress_timeout_get(Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_at_xy_item_get(Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *posret)
    Elm_Object_Item *       elm_genlist_item_parent_get(Elm_Object_Item *it)
    void                    elm_genlist_item_subitems_clear(Elm_Object_Item *item)
    void                    elm_genlist_item_expanded_set(Elm_Object_Item *item, Eina_Bool expanded)
    Eina_Bool               elm_genlist_item_expanded_get(Elm_Object_Item *item)
    int                     elm_genlist_item_expanded_depth_get(Elm_Object_Item *it)
    void                    elm_genlist_item_all_contents_unset(Elm_Object_Item *it, Eina_List **l)
    void                    elm_genlist_item_promote(Elm_Object_Item *it)
    void                    elm_genlist_item_demote(Elm_Object_Item *it)
    void                    elm_genlist_item_fields_update(Elm_Object_Item *item, const_char *parts, Elm_Genlist_Item_Field_Type itf)
    void                    elm_genlist_item_decorate_mode_set(Elm_Object_Item *it, const_char *decorate_it_type, Eina_Bool decorate_it_set)
    const_char *            elm_genlist_item_decorate_mode_get(Elm_Object_Item *it)
    Elm_Object_Item *       elm_genlist_decorated_item_get(Evas_Object *obj)
    void                    elm_genlist_reorder_mode_set(Evas_Object *obj, Eina_Bool reorder_mode)
    Eina_Bool               elm_genlist_reorder_mode_get(Evas_Object *obj)
    Elm_Genlist_Item_Type   elm_genlist_item_type_get(Elm_Object_Item *it)
    void                    elm_genlist_decorate_mode_set(Evas_Object *obj, Eina_Bool decorated)
    Eina_Bool               elm_genlist_decorate_mode_get(Evas_Object *obj)
    void                    elm_genlist_item_flip_set(Elm_Object_Item *it, Eina_Bool flip)
    Eina_Bool               elm_genlist_item_flip_get(Elm_Object_Item *it)
    void                    elm_genlist_tree_effect_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool               elm_genlist_tree_effect_enabled_get(Evas_Object *obj)
    void                    elm_genlist_item_select_mode_set(Elm_Object_Item *it, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_genlist_item_select_mode_get(Elm_Object_Item *it)
    void                    elm_genlist_highlight_mode_set(Evas_Object *obj, Eina_Bool highlight)
    Eina_Bool               elm_genlist_highlight_mode_get(Evas_Object *obj)
    void                    elm_genlist_select_mode_set(Evas_Object *obj, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_genlist_select_mode_get(Evas_Object *obj)

