cdef extern from "Elementary.h":

    ctypedef cEo Elm_Gengrid

    cpdef enum Elm_Genlist_Item_Scrollto_Type:
        ELM_GENLIST_ITEM_SCROLLTO_NONE
        ELM_GENLIST_ITEM_SCROLLTO_IN
        ELM_GENLIST_ITEM_SCROLLTO_TOP
        ELM_GENLIST_ITEM_SCROLLTO_MIDDLE
    ctypedef enum Elm_Genlist_Item_Scrollto_Type:
        pass

    cpdef enum Elm_Object_Select_Mode:
        ELM_OBJECT_SELECT_MODE_DEFAULT
        ELM_OBJECT_SELECT_MODE_ALWAYS
        ELM_OBJECT_SELECT_MODE_NONE
        ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
        ELM_OBJECT_SELECT_MODE_MAX
    ctypedef enum Elm_Object_Select_Mode:
        pass

    cpdef enum Elm_Object_Multi_Select_Mode:
        ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT
        ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL
        ELM_OBJECT_MULTI_SELECT_MODE_MAX
    ctypedef enum Elm_Object_Multi_Select_Mode:
        pass

    cpdef enum Elm_Gengrid_Reorder_Type:
        ELM_GENGRID_REORDER_TYPE_NORMAL
        ELM_GENGRID_REORDER_TYPE_SWAP
    ctypedef enum Elm_Gengrid_Reorder_Type:
        pass


    ctypedef char           *(*GengridItemLabelGetFunc)     (void *data, Evas_Object *obj, const char *part)
    ctypedef Evas_Object    *(*GengridItemIconGetFunc)      (void *data, Evas_Object *obj, const char *part)
    ctypedef Eina_Bool       (*GengridItemStateGetFunc)     (void *data, Evas_Object *obj, const char *part)
    ctypedef void            (*GengridItemDelFunc)          (void *data, Evas_Object *obj)

    ctypedef struct Elm_Gengrid_Item_Class_Func:
        GengridItemLabelGetFunc text_get
        GengridItemIconGetFunc content_get
        GengridItemStateGetFunc state_get
        GengridItemDelFunc del_ "del"

    ctypedef struct Elm_Gengrid_Item_Class:
        char *item_style
        Elm_Gengrid_Item_Class_Func func

    Evas_Object *           elm_gengrid_add(Evas_Object *parent)
    void                    elm_gengrid_clear(Evas_Object *obj)
    void                    elm_gengrid_multi_select_set(Evas_Object *obj, Eina_Bool multi)
    Eina_Bool               elm_gengrid_multi_select_get(const Evas_Object *obj)
    void                    elm_gengrid_multi_select_mode_set(Elm_Gengrid *obj, Elm_Object_Multi_Select_Mode mode)
    Elm_Object_Multi_Select_Mode elm_gengrid_multi_select_mode_get(const Elm_Gengrid *obj)
    void                    elm_gengrid_horizontal_set(Evas_Object *obj, Eina_Bool setting)
    Eina_Bool               elm_gengrid_horizontal_get(const Evas_Object *obj)
    void                    elm_gengrid_page_size_set(Elm_Gengrid *obj, Evas_Coord h_pagesize, Evas_Coord v_pagesize)
    Elm_Object_Item *       elm_gengrid_item_append(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const void *data, Evas_Smart_Cb func, const void *func_data)
    Elm_Object_Item *       elm_gengrid_item_prepend(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const void *data, Evas_Smart_Cb func, const void *func_data)
    Elm_Object_Item *       elm_gengrid_item_insert_before(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const void *data, Elm_Object_Item *before, Evas_Smart_Cb func, const void *func_data)
    Elm_Object_Item *       elm_gengrid_item_insert_after(Evas_Object *obj, Elm_Gengrid_Item_Class *itc, const void *data, Elm_Object_Item *after, Evas_Smart_Cb func, const void *func_data)
    Elm_Object_Item *       elm_gengrid_item_sorted_insert(Evas_Object *obj, const Elm_Gengrid_Item_Class *gic, const void *data, Eina_Compare_Cb comp, Evas_Smart_Cb func, const void *func_data)
    Elm_Object_Item *       elm_gengrid_selected_item_get(const Evas_Object *obj)
    Eina_List *             elm_gengrid_selected_items_get(const Evas_Object *obj)
    Eina_List *             elm_gengrid_realized_items_get(const Evas_Object *obj)
    void                    elm_gengrid_realized_items_update(Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_first_item_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_last_item_get(const Evas_Object *obj)
    void                    elm_gengrid_wheel_disabled_set(Elm_Gengrid *obj, Eina_Bool disabled)
    Eina_Bool               elm_gengrid_wheel_disabled_get(const Elm_Gengrid *obj)
    unsigned int            elm_gengrid_items_count(Evas_Object *obj)
    void                    elm_gengrid_item_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void                    elm_gengrid_item_size_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                    elm_gengrid_group_item_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void                    elm_gengrid_group_item_size_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                    elm_gengrid_align_set(Evas_Object *obj,  double align_x, double align_y)
    void                    elm_gengrid_align_get(const Evas_Object *obj,  double *align_x, double *align_y)
    void                    elm_gengrid_reorder_mode_set(Evas_Object *obj, Eina_Bool reorder_mode)
    Eina_Bool               elm_gengrid_reorder_mode_get(const Evas_Object *obj)
    void                    elm_gengrid_reorder_mode_start(Evas_Object *obj, Ecore_Pos_Map tween_mode)
    void                    elm_gengrid_reorder_mode_stop(Evas_Object *obj)
    void                    elm_gengrid_reorder_type_set(Evas_Object *obj, Elm_Gengrid_Reorder_Type reorder_type)
    void                    elm_gengrid_page_show(Evas_Object *obj, int h_pagenum, int v_pagenum)
    void                    elm_gengrid_filled_set(Evas_Object *obj, Eina_Bool fill)
    Eina_Bool               elm_gengrid_filled_get(const Evas_Object *obj)
    void                    elm_gengrid_page_relative_set(Elm_Gengrid *obj, double h_pagerel, double v_pagerel)
    void                    elm_gengrid_page_relative_get(const Elm_Gengrid *obj, double *h_pagerel, double *v_pagerel)
    void                    elm_gengrid_select_mode_set(Evas_Object *obj, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_gengrid_select_mode_get(const Evas_Object *obj)
    void                    elm_gengrid_highlight_mode_set(Evas_Object *obj, Eina_Bool highlight)
    Eina_Bool               elm_gengrid_highlight_mode_get(const Evas_Object *obj)

    Elm_Object_Item *       elm_gengrid_first_item_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_gengrid_last_item_get(const Evas_Object *obj)
    int                     elm_gengrid_item_index_get(const Elm_Object_Item *it)

    Elm_Gengrid_Item_Class *elm_gengrid_item_class_new()
    void                    elm_gengrid_item_class_free(Elm_Gengrid_Item_Class *itc)
    void                    elm_gengrid_item_class_ref(Elm_Gengrid_Item_Class *itc)
    void                    elm_gengrid_item_class_unref(Elm_Gengrid_Item_Class *itc)

    void                    elm_gengrid_item_select_mode_set(Elm_Object_Item *it, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_gengrid_item_select_mode_get(const Elm_Object_Item *it)
    Elm_Object_Item *       elm_gengrid_item_next_get(const Elm_Object_Item *item)
    Elm_Object_Item *       elm_gengrid_item_prev_get(const Elm_Object_Item *item)
    void                    elm_gengrid_item_selected_set(Elm_Object_Item *item, Eina_Bool selected)
    Eina_Bool               elm_gengrid_item_selected_get(const Elm_Object_Item *item)
    void                    elm_gengrid_item_show(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_gengrid_item_bring_in(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_gengrid_item_update(Elm_Object_Item *item)
    void                    elm_gengrid_item_pos_get(const Elm_Object_Item *item, unsigned int *x, unsigned int *y)
    Elm_Object_Item *       elm_gengrid_nth_item_get(const Evas_Object *obj, unsigned int nth)
    Elm_Object_Item *       elm_gengrid_at_xy_item_get(const Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *xposret, int *yposret)
    Elm_Object_Item *       elm_gengrid_search_by_text_item_get(const Evas_Object *obj, Elm_Object_Item *item_to_search_from, const char *part_name, const char *pattern, Elm_Glob_Match_Flags flags)

