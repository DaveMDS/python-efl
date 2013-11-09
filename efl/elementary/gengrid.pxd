from efl.evas cimport Eina_Bool, Eina_List, Evas_Object, Evas_Smart_Cb, \
    Evas_Coord, Eina_Compare_Cb, const_Evas_Object
from object_item cimport Elm_Object_Item
from general cimport Elm_Tooltip_Item_Content_Cb
from enums cimport Elm_Genlist_Item_Scrollto_Type, Elm_Scroller_Policy, \
    Elm_Object_Select_Mode
from libc.string cimport const_char
from libc.stdlib cimport const_void

cdef extern from "Elementary.h":
    ctypedef char           *(*GengridItemLabelGetFunc)     (void *data, Evas_Object *obj, const_char *part)
    ctypedef Evas_Object    *(*GengridItemIconGetFunc)      (void *data, Evas_Object *obj, const_char *part)
    ctypedef Eina_Bool       (*GengridItemStateGetFunc)     (void *data, Evas_Object *obj, const_char *part)
    ctypedef void            (*GengridItemDelFunc)          (void *data, Evas_Object *obj)

    ctypedef struct Elm_Gengrid_Item_Class_Func:
        GengridItemLabelGetFunc text_get
        GengridItemIconGetFunc content_get
        GengridItemStateGetFunc state_get
        GengridItemDelFunc del_ "del"

    ctypedef struct Elm_Gengrid_Item_Class:
        char *item_style
        Elm_Gengrid_Item_Class_Func func
    ctypedef Elm_Gengrid_Item_Class const_Elm_Gengrid_Item_Class "const Elm_Gengrid_Item_Class"

    Evas_Object *           elm_gengrid_add(Evas_Object *parent)
    void                    elm_gengrid_clear(Evas_Object *obj)
    void                    elm_gengrid_multi_select_set(Evas_Object *obj, Eina_Bool multi)
    Eina_Bool               elm_gengrid_multi_select_get(Evas_Object *obj)
    void                    elm_gengrid_horizontal_set(Evas_Object *obj, Eina_Bool setting)
    Eina_Bool               elm_gengrid_horizontal_get(Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_item_append(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const_void *data, Evas_Smart_Cb func, const_void *func_data)
    Elm_Object_Item *       elm_gengrid_item_prepend(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const_void *data, Evas_Smart_Cb func, const_void *func_data)
    Elm_Object_Item *       elm_gengrid_item_insert_before(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const_void *data, Elm_Object_Item *before, Evas_Smart_Cb func, const_void *func_data)
    Elm_Object_Item *       elm_gengrid_item_insert_after(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const_void *data, Elm_Object_Item *after, Evas_Smart_Cb func, const_void *func_data)
    Elm_Object_Item *       elm_gengrid_item_sorted_insert(Evas_Object *obj, const_Elm_Gengrid_Item_Class *gic, const_void *data, Eina_Compare_Cb comp, Evas_Smart_Cb func, const_void *func_data)
    Elm_Object_Item *       elm_gengrid_selected_item_get(Evas_Object *obj)
    Eina_List *             elm_gengrid_selected_items_get(Evas_Object *obj)
    Eina_List *             elm_gengrid_realized_items_get(Evas_Object *obj)
    void                    elm_gengrid_realized_items_update(Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_first_item_get(Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_last_item_get(Evas_Object *obj)
    unsigned int            elm_gengrid_items_count(Evas_Object *obj)
    void                    elm_gengrid_item_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void                    elm_gengrid_item_size_get(Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                    elm_gengrid_group_item_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void                    elm_gengrid_group_item_size_get(Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                    elm_gengrid_align_set(Evas_Object *obj,  double align_x, double align_y)
    void                    elm_gengrid_align_get(Evas_Object *obj,  double *align_x, double *align_y)
    void                    elm_gengrid_reorder_mode_set(Evas_Object *obj, Eina_Bool reorder_mode)
    Eina_Bool               elm_gengrid_reorder_mode_get(Evas_Object *obj)
    void                    elm_gengrid_page_show(Evas_Object *obj, int h_pagenum, int v_pagenum)
    void                    elm_gengrid_filled_set(Evas_Object *obj, Eina_Bool fill)
    Eina_Bool               elm_gengrid_filled_get(Evas_Object *obj)
    void                    elm_gengrid_select_mode_set(Evas_Object *obj, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_gengrid_select_mode_get(Evas_Object *obj)
    void                    elm_gengrid_highlight_mode_set(Evas_Object *obj, Eina_Bool highlight)
    Eina_Bool               elm_gengrid_highlight_mode_get(Evas_Object *obj)

    Elm_Object_Item *       elm_gengrid_first_item_get(Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_last_item_get(Evas_Object *obj)
    int                     elm_gengrid_item_index_get(Elm_Object_Item *it)
    void                    elm_gengrid_item_select_mode_set(Elm_Object_Item *it, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_gengrid_item_select_mode_get(Elm_Object_Item *it)
    Elm_Object_Item *       elm_gengrid_item_next_get(Elm_Object_Item *item)
    Elm_Object_Item *       elm_gengrid_item_prev_get(Elm_Object_Item *item)
    void                    elm_gengrid_item_selected_set(Elm_Object_Item *item, Eina_Bool selected)
    Eina_Bool               elm_gengrid_item_selected_get(Elm_Object_Item *item)
    void                    elm_gengrid_item_show(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_gengrid_item_bring_in(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_gengrid_item_update(Elm_Object_Item *item)
    void                    elm_gengrid_item_pos_get(Elm_Object_Item *item, unsigned int *x, unsigned int *y)
    void                    elm_gengrid_item_tooltip_text_set(Elm_Object_Item *item, const_char *text)
    void                    elm_gengrid_item_tooltip_content_cb_set(Elm_Object_Item *item, Elm_Tooltip_Item_Content_Cb func, void *data, Evas_Smart_Cb del_cb)
    void                    elm_gengrid_item_tooltip_unset(Elm_Object_Item *item)
    void                    elm_gengrid_item_tooltip_style_set(Elm_Object_Item *item, const_char *style)
    const_char *            elm_gengrid_item_tooltip_style_get(Elm_Object_Item *item)
    Eina_Bool               elm_gengrid_item_tooltip_window_mode_set(Elm_Object_Item *it, Eina_Bool disable)
    Eina_Bool               elm_gengrid_item_tooltip_window_mode_get(Elm_Object_Item *it)
    void                    elm_gengrid_item_cursor_set(Elm_Object_Item *item, const_char *cursor)
    const_char *            elm_gengrid_item_cursor_get(Elm_Object_Item *item)
    void                    elm_gengrid_item_cursor_unset(Elm_Object_Item *item)
    void                    elm_gengrid_item_cursor_style_set(Elm_Object_Item *item, const_char *style)
    const_char *            elm_gengrid_item_cursor_style_get(Elm_Object_Item *item)
    void                    elm_gengrid_item_cursor_engine_only_set(Elm_Object_Item *item, Eina_Bool engine_only)
    Eina_Bool               elm_gengrid_item_cursor_engine_only_get(Elm_Object_Item *item)
    Elm_Object_Item *       elm_gengrid_nth_item_get(const_Evas_Object *obj, unsigned int nth)
    Elm_Object_Item *       elm_gengrid_at_xy_item_get(const_Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *xposret, int *yposret)
