cdef extern from "Elementary.h":

    cpdef enum Elm_Icon_Lookup_Order:
        ELM_ICON_LOOKUP_FDO_THEME
        ELM_ICON_LOOKUP_THEME_FDO
        ELM_ICON_LOOKUP_FDO
        ELM_ICON_LOOKUP_THEME
    ctypedef enum Elm_Icon_Lookup_Order:
        pass

    cpdef enum Elm_Object_Select_Mode:
        ELM_OBJECT_SELECT_MODE_DEFAULT
        ELM_OBJECT_SELECT_MODE_ALWAYS
        ELM_OBJECT_SELECT_MODE_NONE
        ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
        ELM_OBJECT_SELECT_MODE_MAX
    ctypedef enum Elm_Object_Select_Mode:
        pass

    cpdef enum Elm_Toolbar_Item_Scrollto_Type:
        ELM_TOOLBAR_ITEM_SCROLLTO_NONE
        ELM_TOOLBAR_ITEM_SCROLLTO_IN
        ELM_TOOLBAR_ITEM_SCROLLTO_FIRST
        ELM_TOOLBAR_ITEM_SCROLLTO_MIDDLE
        ELM_TOOLBAR_ITEM_SCROLLTO_LAST
    ctypedef enum Elm_Toolbar_Item_Scrollto_Type:
        pass

    cpdef enum Elm_Toolbar_Shrink_Mode:
        ELM_TOOLBAR_SHRINK_NONE
        ELM_TOOLBAR_SHRINK_HIDE
        ELM_TOOLBAR_SHRINK_SCROLL
        ELM_TOOLBAR_SHRINK_MENU
        ELM_TOOLBAR_SHRINK_EXPAND
        ELM_TOOLBAR_SHRINK_LAST
    ctypedef enum Elm_Toolbar_Shrink_Mode:
        pass


    ctypedef struct Elm_Toolbar_Item_State:
        pass

    Evas_Object             *elm_object_item_widget_get(const Elm_Object_Item *it)

    Evas_Object             *elm_toolbar_add(Evas_Object *parent)
    void                     elm_toolbar_icon_size_set(Evas_Object *obj, int icon_size)
    int                      elm_toolbar_icon_size_get(const Evas_Object *obj)
    void                     elm_toolbar_icon_order_lookup_set(Evas_Object *obj, Elm_Icon_Lookup_Order order)
    Elm_Icon_Lookup_Order    elm_toolbar_icon_order_lookup_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_toolbar_item_append(Evas_Object *obj, const char *icon, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_toolbar_item_prepend(Evas_Object *obj, const char *icon, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_toolbar_item_insert_before(Evas_Object *obj, Elm_Object_Item *before, const char *icon, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_toolbar_item_insert_after(Evas_Object *obj, Elm_Object_Item *after, const char *icon, const char *label, Evas_Smart_Cb func, void *data)
    Elm_Object_Item         *elm_toolbar_first_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_toolbar_last_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_toolbar_item_next_get(const Elm_Object_Item *item)
    Elm_Object_Item         *elm_toolbar_item_prev_get(const Elm_Object_Item *item)
    void                     elm_toolbar_item_priority_set(Elm_Object_Item *item, int priority)
    int                      elm_toolbar_item_priority_get(const Elm_Object_Item *item)
    Elm_Object_Item         *elm_toolbar_item_find_by_label(Evas_Object *obj, const char *label)
    Eina_Bool                elm_toolbar_item_selected_get(const Elm_Object_Item *item)
    void                     elm_toolbar_item_selected_set(Elm_Object_Item *item, Eina_Bool selected)
    Elm_Object_Item         *elm_toolbar_selected_item_get(const Evas_Object *obj)
    Elm_Object_Item         *elm_toolbar_more_item_get(const Evas_Object *obj)
    void                     elm_toolbar_item_icon_set(Elm_Object_Item *item, const char *icon)
    const char *             elm_toolbar_item_icon_get(const Elm_Object_Item *item)
    Evas_Object             *elm_toolbar_item_object_get(const Elm_Object_Item *item)
    Evas_Object             *elm_toolbar_item_icon_object_get(const Elm_Object_Item *item)
    # TODO: Eina_Bool                elm_toolbar_item_icon_memfile_set(Elm_Object_Item *item, const char *img, const char *size, const char *format, const char *key)
    Eina_Bool                elm_toolbar_item_icon_file_set(Elm_Object_Item *item, const char *file, const char *key)
    void                     elm_toolbar_item_separator_set(Elm_Object_Item *item, Eina_Bool separator)
    Eina_Bool                elm_toolbar_item_separator_get(const Elm_Object_Item *item)
    void                     elm_toolbar_shrink_mode_set(Evas_Object *obj, Elm_Toolbar_Shrink_Mode shrink_mode)
    Elm_Toolbar_Shrink_Mode  elm_toolbar_shrink_mode_get(const Evas_Object *obj)
    void                     elm_toolbar_transverse_expanded_set(Evas_Object *obj, Eina_Bool transverse_expanded)
    Eina_Bool                elm_toolbar_transverse_expanded_get(const Evas_Object *obj)
    void                     elm_toolbar_homogeneous_set(Evas_Object *obj, Eina_Bool homogeneous)
    Eina_Bool                elm_toolbar_homogeneous_get(const Evas_Object *obj)
    void                     elm_toolbar_menu_parent_set(Evas_Object *obj, Evas_Object *parent)
    Evas_Object             *elm_toolbar_menu_parent_get(const Evas_Object *obj)
    void                     elm_toolbar_align_set(Evas_Object *obj, double align)
    double                   elm_toolbar_align_get(const Evas_Object *obj)
    void                     elm_toolbar_item_menu_set(Elm_Object_Item *item, Eina_Bool menu)
    Evas_Object             *elm_toolbar_item_menu_get(const Elm_Object_Item *item)
    Elm_Toolbar_Item_State  *elm_toolbar_item_state_add(Elm_Object_Item *item, const char *icon, const char *label, Evas_Smart_Cb func, void *data)
    Eina_Bool                elm_toolbar_item_state_del(Elm_Object_Item *item, Elm_Toolbar_Item_State *state)
    Eina_Bool                elm_toolbar_item_state_set(Elm_Object_Item *item, Elm_Toolbar_Item_State *state)
    void                     elm_toolbar_item_state_unset(Elm_Object_Item *item)
    Elm_Toolbar_Item_State  *elm_toolbar_item_state_get(const Elm_Object_Item *item)
    Elm_Toolbar_Item_State  *elm_toolbar_item_state_next(Elm_Object_Item *item)
    Elm_Toolbar_Item_State  *elm_toolbar_item_state_prev(Elm_Object_Item *item)
    void                     elm_toolbar_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_toolbar_horizontal_get(const Evas_Object *obj)
    unsigned int             elm_toolbar_items_count(Evas_Object *obj)
    void                     elm_toolbar_standard_priority_set(Evas_Object *obj, int priority)
    int                      elm_toolbar_standard_priority_get(const Evas_Object *obj)
    void                     elm_toolbar_select_mode_set(Evas_Object *obj, Elm_Object_Select_Mode mode)
    Elm_Object_Select_Mode   elm_toolbar_select_mode_get(const Evas_Object *obj)

    void                     elm_toolbar_reorder_mode_set(Evas_Object *obj, Eina_Bool reorder_mode)
    Eina_Bool                elm_toolbar_reorder_mode_get(const Evas_Object *obj)
    void                     elm_toolbar_item_show(Elm_Object_Item *it, Elm_Toolbar_Item_Scrollto_Type type)
    void                     elm_toolbar_item_bring_in(Elm_Object_Item *it, Elm_Toolbar_Item_Scrollto_Type type)
