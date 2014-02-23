from efl.evas cimport Eina_Bool, Eina_Rectangle, Evas_Object, \
    const_Evas_Object, Evas_Coord, Evas_Smart_Cb
from enums cimport Elm_Wrap_Type, Elm_Text_Format, Elm_Cnp_Mode, \
    Elm_Scroller_Policy, Elm_Input_Panel_Layout, Elm_Input_Panel_Lang, \
    Elm_Input_Panel_Lang, Elm_Input_Panel_Return_Key_Type, \
    Elm_Autocapital_Type, Elm_Icon_Type, Elm_Sel_Type, Elm_Sel_Format, \
    Elm_Xdnd_Action
from libc.string cimport const_char
from libc.stdlib cimport const_void

cdef extern from "Elementary.h":
    ctypedef struct Elm_Entry_Anchor_Info:
        char *name
        int   button
        Evas_Coord x
        Evas_Coord y
        Evas_Coord w
        Evas_Coord h

    ctypedef struct Elm_Entry_Anchor_Hover_Info:
        Elm_Entry_Anchor_Info *anchor_info
        Evas_Object *hover
        Eina_Rectangle hover_parent
        Eina_Bool hover_left
        Eina_Bool hover_right
        Eina_Bool hover_top
        Eina_Bool hover_bottom

    ctypedef struct Elm_Selection_Data:
        Evas_Coord       x, y
        Elm_Sel_Format   format
        void            *data
        size_t           len
        Elm_Xdnd_Action  action

    ctypedef struct Elm_Entry_Context_Menu_Item:
        pass

    ctypedef Elm_Entry_Context_Menu_Item const_Elm_Entry_Context_Menu_Item "const Elm_Entry_Context_Menu_Item"

    ctypedef void (*Elm_Entry_Filter_Cb)(void *data, Evas_Object *entry, char **text)

    ctypedef Eina_Bool       (*Elm_Drop_Cb)                 (void *data, Evas_Object *obj, Elm_Selection_Data *ev)

    # Data for the elm_entry_filter_limit_size() entry filter.
    ctypedef struct Elm_Entry_Filter_Limit_Size:
        int max_char_count      # The maximum number of characters allowed.
        int max_byte_count      # The maximum number of bytes allowed.

    # Data for the elm_entry_filter_accept_set() entry filter.
    ctypedef struct Elm_Entry_Filter_Accept_Set:
        const_char *accepted      # Set of characters accepted in the entry.
        const_char *rejected      # Set of characters rejected from the entry.

    Evas_Object *           elm_entry_add(Evas_Object *parent)
    void                    elm_entry_text_style_user_push(Evas_Object *obj, const_char *style)
    void                    elm_entry_text_style_user_pop(Evas_Object *obj)
    const_char*             elm_entry_text_style_user_peek(const_Evas_Object *obj)
    void                    elm_entry_single_line_set(Evas_Object *obj, Eina_Bool single_line)
    Eina_Bool               elm_entry_single_line_get(Evas_Object *obj)
    void                    elm_entry_password_set(Evas_Object *obj, Eina_Bool password)
    Eina_Bool               elm_entry_password_get(Evas_Object *obj)
    void                    elm_entry_entry_set(Evas_Object *obj, const_char *entry)
    const_char *            elm_entry_entry_get(Evas_Object *obj)
    void                    elm_entry_entry_append(Evas_Object *obj, const_char *text)
    Eina_Bool               elm_entry_is_empty(Evas_Object *obj)
    const_char *            elm_entry_selection_get(Evas_Object *obj)
    Evas_Object *           elm_entry_textblock_get(Evas_Object *obj)
    void                    elm_entry_calc_force(Evas_Object *obj)
    void                    elm_entry_entry_insert(Evas_Object *obj, const_char *entry)
    void                    elm_entry_line_wrap_set(Evas_Object *obj, Elm_Wrap_Type wrap)
    Elm_Wrap_Type           elm_entry_line_wrap_get(Evas_Object *obj)
    void                    elm_entry_editable_set(Evas_Object *obj, Eina_Bool editable)
    Eina_Bool               elm_entry_editable_get(Evas_Object *obj)
    void                    elm_entry_select_none(Evas_Object *obj)
    void                    elm_entry_select_all(Evas_Object *obj)
    void                    elm_entry_select_region_set(Evas_Object *obj, int start, int end)
    Eina_Bool               elm_entry_cursor_next(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_prev(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_up(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_down(Evas_Object *obj)
    void                    elm_entry_cursor_begin_set(Evas_Object *obj)
    void                    elm_entry_cursor_end_set(Evas_Object *obj)
    void                    elm_entry_cursor_line_begin_set(Evas_Object *obj)
    void                    elm_entry_cursor_line_end_set(Evas_Object *obj)
    void                    elm_entry_cursor_selection_begin(Evas_Object *obj)
    void                    elm_entry_cursor_selection_end(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_is_format_get(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_is_visible_format_get(Evas_Object *obj)
    const_char *            elm_entry_cursor_content_get(Evas_Object *obj)
    Eina_Bool               elm_entry_cursor_geometry_get(Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)
    void                    elm_entry_cursor_pos_set(Evas_Object *obj, int pos)
    int                     elm_entry_cursor_pos_get(Evas_Object *obj)
    void                    elm_entry_selection_cut(Evas_Object *obj)
    void                    elm_entry_selection_copy(Evas_Object *obj)
    void                    elm_entry_selection_paste(Evas_Object *obj)
    void                    elm_entry_context_menu_clear(Evas_Object *obj)
    void                    elm_entry_context_menu_item_add(Evas_Object *obj, const_char *label, const_char *icon_file, Elm_Icon_Type icon_type, Evas_Smart_Cb func, const_void *data)
    void                    elm_entry_context_menu_disabled_set(Evas_Object *obj, Eina_Bool disabled)
    Eina_Bool               elm_entry_context_menu_disabled_get(Evas_Object *obj)
    # TODO: void               elm_entry_item_provider_append(Evas_Object *obj, Elm_Entry_Item_Provider_Cb func, void *data)
    # TODO: void               elm_entry_item_provider_prepend(Evas_Object *obj, Elm_Entry_Item_Provider_Cb func, void *data)
    # TODO: void               elm_entry_item_provider_remove(Evas_Object *obj, Elm_Entry_Item_Provider_Cb func, void *data)
    void               elm_entry_markup_filter_append(Evas_Object *obj, Elm_Entry_Filter_Cb func, void *data)
    void               elm_entry_markup_filter_prepend(Evas_Object *obj, Elm_Entry_Filter_Cb func, void *data)
    void               elm_entry_markup_filter_remove(Evas_Object *obj, Elm_Entry_Filter_Cb func, void *data)
    char *                  elm_entry_markup_to_utf8(const_char *s)
    char *                  elm_entry_utf8_to_markup(const_char *s)
    Eina_Bool               elm_entry_file_set(Evas_Object *obj, const_char *file, Elm_Text_Format format)
    void                    elm_entry_file_get(Evas_Object *obj, const_char **file, Elm_Text_Format *format)
    void                    elm_entry_file_save(Evas_Object *obj)
    void                    elm_entry_autosave_set(Evas_Object *obj, Eina_Bool autosave)
    Eina_Bool               elm_entry_autosave_get(Evas_Object *obj)
    void                    elm_entry_scrollable_set(Evas_Object *obj, Eina_Bool scrollable)
    Eina_Bool               elm_entry_scrollable_get(Evas_Object *obj)
    void                    elm_entry_icon_visible_set(Evas_Object *obj, Eina_Bool setting)
    void                    elm_entry_end_visible_set(Evas_Object *obj, Eina_Bool setting)
    void                    elm_entry_input_panel_layout_set(Evas_Object *obj, Elm_Input_Panel_Layout layout)
    Elm_Input_Panel_Layout  elm_entry_input_panel_layout_get(Evas_Object *obj)
    void                    elm_entry_input_panel_layout_variation_set(Evas_Object *obj, int variation)
    int                     elm_entry_input_panel_layout_variation_get(const_Evas_Object *obj)
    void                    elm_entry_autocapital_type_set(Evas_Object *obj, Elm_Autocapital_Type autocapital_type)
    Elm_Autocapital_Type    elm_entry_autocapital_type_get(const_Evas_Object *obj)
    void                    elm_entry_input_panel_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool               elm_entry_input_panel_enabled_get(Evas_Object *obj)
    void                    elm_entry_input_panel_show(Evas_Object *obj)
    void                    elm_entry_input_panel_hide(Evas_Object *obj)
    void                    elm_entry_input_panel_language_set(Evas_Object *obj, Elm_Input_Panel_Lang lang)
    Elm_Input_Panel_Lang    elm_entry_input_panel_language_get(Evas_Object *obj)
    # TODO: void                   elm_entry_input_panel_imdata_set(Evas_Object *obj, const_void *data, int len)
    # TODO: void                   elm_entry_input_panel_imdata_get(const_Evas_Object *obj, void *data, int *len)
    void                    elm_entry_input_panel_return_key_type_set(Evas_Object *obj, Elm_Input_Panel_Return_Key_Type return_key_type)
    Elm_Input_Panel_Return_Key_Type elm_entry_input_panel_return_key_type_get(Evas_Object *obj)
    void                    elm_entry_input_panel_return_key_disabled_set(Evas_Object *obj, Eina_Bool disabled)
    Eina_Bool               elm_entry_input_panel_return_key_disabled_get(Evas_Object *obj)
    void                    elm_entry_input_panel_return_key_autoenabled_set(Evas_Object *obj, Eina_Bool disabled)
    Eina_Bool               elm_entry_input_panel_show_on_demand_get(const_Evas_Object *obj)
    void                    elm_entry_input_panel_show_on_demand_set(Evas_Object *obj, Eina_Bool ondemand)

    void                    elm_entry_imf_context_reset(Evas_Object *obj)
    void                    elm_entry_prediction_allow_set(Evas_Object *obj, Eina_Bool allow)
    Eina_Bool               elm_entry_prediction_allow_get(Evas_Object *obj)
    # TODO: void                    elm_entry_filter_limit_size(void *data, Evas_Object *entry, char **text)
    # TODO: void                    elm_entry_filter_accept_set(void *data, Evas_Object *entry, char **text)
    # TODO: void                  *elm_entry_imf_context_get(Evas_Object *obj)
    void                    elm_entry_cnp_mode_set(Evas_Object *obj, Elm_Cnp_Mode cnp_mode)
    Elm_Cnp_Mode            elm_entry_cnp_mode_get(Evas_Object *obj)
    void                    elm_entry_anchor_hover_parent_set(Evas_Object *obj, Evas_Object *anchor_hover_parent)
    Evas_Object *           elm_entry_anchor_hover_parent_get(Evas_Object *obj)
    void                    elm_entry_anchor_hover_style_set(Evas_Object *obj, const_char *anchor_hover_style)
    const_char *            elm_entry_anchor_hover_style_get(Evas_Object *obj)
    void                    elm_entry_anchor_hover_end(Evas_Object *obj)

    const_char *            elm_entry_context_menu_item_label_get(const_Elm_Entry_Context_Menu_Item *item)
    void                    elm_entry_context_menu_item_icon_get(const_Elm_Entry_Context_Menu_Item *item, const_char **icon_file, const_char **icon_group, Elm_Icon_Type *icon_type)

    Eina_Bool               elm_cnp_selection_get(Evas_Object *obj, Elm_Sel_Type selection, Elm_Sel_Format format, Elm_Drop_Cb datacb, void *udata)
