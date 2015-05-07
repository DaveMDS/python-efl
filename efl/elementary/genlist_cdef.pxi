cdef extern from "Elementary.h":

    cpdef enum Elm_Genlist_Item_Type:
        ELM_GENLIST_ITEM_NONE
        ELM_GENLIST_ITEM_TREE
        ELM_GENLIST_ITEM_GROUP
        ELM_GENLIST_ITEM_MAX
    ctypedef enum Elm_Genlist_Item_Type:
        pass

    cpdef enum Elm_Genlist_Item_Field_Type:
        ELM_GENLIST_ITEM_FIELD_ALL
        ELM_GENLIST_ITEM_FIELD_TEXT
        ELM_GENLIST_ITEM_FIELD_CONTENT
        ELM_GENLIST_ITEM_FIELD_STATE
    ctypedef enum Elm_Genlist_Item_Field_Type:
        pass

    cpdef enum Elm_Genlist_Item_Scrollto_Type:
        ELM_GENLIST_ITEM_SCROLLTO_NONE
        ELM_GENLIST_ITEM_SCROLLTO_IN
        ELM_GENLIST_ITEM_SCROLLTO_TOP
        ELM_GENLIST_ITEM_SCROLLTO_MIDDLE
    ctypedef enum Elm_Genlist_Item_Scrollto_Type:
        pass

    cpdef enum Elm_List_Mode:
        ELM_LIST_COMPRESS
        ELM_LIST_SCROLL
        ELM_LIST_LIMIT
        ELM_LIST_EXPAND
    ctypedef enum Elm_List_Mode:
        pass

    cpdef enum Elm_Object_Select_Mode:
        ELM_OBJECT_SELECT_MODE_DEFAULT
        ELM_OBJECT_SELECT_MODE_ALWAYS
        ELM_OBJECT_SELECT_MODE_NONE
        ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
        ELM_OBJECT_SELECT_MODE_MAX
    ctypedef enum Elm_Object_Select_Mode:
        pass

    cpdef enum Elm_Sel_Format:
        ELM_SEL_FORMAT_TARGETS
        ELM_SEL_FORMAT_NONE
        ELM_SEL_FORMAT_TEXT
        ELM_SEL_FORMAT_MARKUP
        ELM_SEL_FORMAT_IMAGE
        ELM_SEL_FORMAT_VCARD
        ELM_SEL_FORMAT_HTML
    ctypedef enum Elm_Sel_Format:
        pass

    cpdef enum Elm_Sel_Type:
        ELM_SEL_TYPE_PRIMARY
        ELM_SEL_TYPE_SECONDARY
        ELM_SEL_TYPE_XDND
        ELM_SEL_TYPE_CLIPBOARD
    ctypedef enum Elm_Sel_Type:
        pass


    ctypedef char           *(*GenlistItemLabelGetFunc)     (void *data, Evas_Object *obj, const char *part)
    ctypedef Evas_Object    *(*GenlistItemIconGetFunc)      (void *data, Evas_Object *obj, const char *part)
    ctypedef Eina_Bool       (*GenlistItemStateGetFunc)     (void *data, Evas_Object *obj, const char *part)
    ctypedef void            (*GenlistItemDelFunc)          (void *data, Evas_Object *obj)

    ctypedef struct Elm_Genlist_Item_Class_Func:
        GenlistItemLabelGetFunc text_get
        GenlistItemIconGetFunc content_get
        GenlistItemStateGetFunc state_get
        GenlistItemDelFunc del_ "del"

    ctypedef struct Elm_Genlist_Item_Class:
        const char *item_style
        const char *decorate_item_style
        const char *decorate_all_item_style
        Elm_Genlist_Item_Class_Func func

    Evas_Object *           elm_genlist_add(Evas_Object *parent)
    void                    elm_genlist_clear(Evas_Object *obj)
    void                    elm_genlist_multi_select_set(Evas_Object *obj, Eina_Bool multi)
    Eina_Bool               elm_genlist_multi_select_get(const Evas_Object *obj)
    void                    elm_genlist_mode_set(Evas_Object *obj, Elm_List_Mode mode)
    Elm_List_Mode           elm_genlist_mode_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_item_append(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_prepend(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_insert_before(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Object_Item *before, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_insert_after(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Object_Item *after, Elm_Genlist_Item_Type flags, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_item_sorted_insert(Evas_Object *obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Eina_Compare_Cb comp, Evas_Smart_Cb func, void *func_data)
    Elm_Object_Item *       elm_genlist_selected_item_get(const Evas_Object *obj)
    Eina_List *             elm_genlist_selected_items_get(const Evas_Object *obj)
    Eina_List *             elm_genlist_realized_items_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_first_item_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_last_item_get(const Evas_Object *obj)

    Elm_Object_Item *       elm_genlist_item_next_get(const Elm_Object_Item *item)
    Elm_Object_Item *       elm_genlist_item_prev_get(const Elm_Object_Item *item)
    void                    elm_genlist_item_selected_set(Elm_Object_Item *item, Eina_Bool selected)
    Eina_Bool               elm_genlist_item_selected_get(const Elm_Object_Item *item)
    void                    elm_genlist_item_show(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_genlist_item_bring_in(Elm_Object_Item *item, Elm_Genlist_Item_Scrollto_Type scrollto_type)
    void                    elm_genlist_item_update(Elm_Object_Item *item)
    void                    elm_genlist_item_item_class_update(Elm_Object_Item *it, Elm_Genlist_Item_Class *itc)
    # TODO: Elm_Genlist_Item_Class *elm_genlist_item_item_class_get(const Elm_Object_Item *it)
    int                     elm_genlist_item_index_get(const Elm_Object_Item *it)
    void                    elm_genlist_realized_items_update(Evas_Object *obj)
    unsigned int            elm_genlist_items_count(Evas_Object *obj)

    Elm_Genlist_Item_Class *elm_genlist_item_class_new()
    void                    elm_genlist_item_class_free(Elm_Genlist_Item_Class *itc)
    void                    elm_genlist_item_class_ref(Elm_Genlist_Item_Class *itc)
    void                    elm_genlist_item_class_unref(Elm_Genlist_Item_Class *itc)

    void                    elm_genlist_homogeneous_set(Evas_Object *obj, Eina_Bool homogeneous)
    Eina_Bool               elm_genlist_homogeneous_get(const Evas_Object *obj)
    void                    elm_genlist_block_count_set(Evas_Object *obj, int n)
    int                     elm_genlist_block_count_get(const Evas_Object *obj)
    void                    elm_genlist_longpress_timeout_set(Evas_Object *obj, double timeout)
    double                  elm_genlist_longpress_timeout_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_at_xy_item_get(const Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *posret)
    Elm_Object_Item *       elm_genlist_search_by_text_item_get(const Evas_Object *obj, Elm_Object_Item *item_to_search_from, const char *part_name, const char *pattern, Elm_Glob_Match_Flags flags)

    Elm_Object_Item *       elm_genlist_item_parent_get(const Elm_Object_Item *it)
    void                    elm_genlist_item_subitems_clear(Elm_Object_Item *item)
    unsigned int            elm_genlist_item_subitems_count(const Elm_Object_Item *it)
    const Eina_List *       elm_genlist_item_subitems_get(const Elm_Object_Item *it)
    void                    elm_genlist_item_expanded_set(Elm_Object_Item *item, Eina_Bool expanded)
    Eina_Bool               elm_genlist_item_expanded_get(const Elm_Object_Item *item)
    int                     elm_genlist_item_expanded_depth_get(const Elm_Object_Item *it)
    void                    elm_genlist_item_all_contents_unset(Elm_Object_Item *it, Eina_List **l)
    void                    elm_genlist_item_promote(Elm_Object_Item *it)
    void                    elm_genlist_item_demote(Elm_Object_Item *it)
    void                    elm_genlist_item_fields_update(Elm_Object_Item *item, const char *parts, Elm_Genlist_Item_Field_Type itf)
    void                    elm_genlist_item_decorate_mode_set(Elm_Object_Item *it, const char *decorate_it_type, Eina_Bool decorate_it_set)
    const char *            elm_genlist_item_decorate_mode_get(const Elm_Object_Item *it)

    Elm_Object_Item *       elm_genlist_decorated_item_get(const Evas_Object *obj)
    void                    elm_genlist_reorder_mode_set(Evas_Object *obj, Eina_Bool reorder_mode)
    Eina_Bool               elm_genlist_reorder_mode_get(const Evas_Object *obj)
    Elm_Genlist_Item_Type   elm_genlist_item_type_get(const Elm_Object_Item *it)
    void                    elm_genlist_decorate_mode_set(Evas_Object *obj, Eina_Bool decorated)
    Eina_Bool               elm_genlist_decorate_mode_get(const Evas_Object *obj)
    void                    elm_genlist_item_flip_set(Elm_Object_Item *it, Eina_Bool flip)
    Eina_Bool               elm_genlist_item_flip_get(const Elm_Object_Item *it)
    void                    elm_genlist_tree_effect_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool               elm_genlist_tree_effect_enabled_get(const Evas_Object *obj)
    void                    elm_genlist_item_select_mode_set(Elm_Object_Item *it, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_genlist_item_select_mode_get(const Elm_Object_Item *it)
    void                    elm_genlist_highlight_mode_set(Evas_Object *obj, Eina_Bool highlight)
    Eina_Bool               elm_genlist_highlight_mode_get(const Evas_Object *obj)
    void                    elm_genlist_select_mode_set(Evas_Object *obj, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode  elm_genlist_select_mode_get(const Evas_Object *obj)
    Elm_Object_Item *       elm_genlist_nth_item_get(const Evas_Object *obj, unsigned int nth)
    void                    elm_genlist_focus_on_selection_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool               elm_genlist_focus_on_selection_get(const Evas_Object *obj)
