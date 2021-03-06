from efl.elementary.enums cimport Elm_Win_Type, Elm_Win_Indicator_Mode, \
    Elm_Win_Indicator_Opacity_Mode, Elm_Win_Keyboard_Mode, Elm_Illume_Command

cdef extern from "Elementary.h":
    Evas_Object             *elm_win_add(Evas_Object *parent, const char *name, Elm_Win_Type type)
    Evas_Object             *elm_win_util_standard_add(const char *name, const char *title)
    Evas_Object             *elm_win_util_dialog_add(Evas_Object *parent, const char *name, const char *title)
    void                     elm_win_resize_object_add(Evas_Object *obj, Evas_Object* subobj)
    void                     elm_win_resize_object_del(Evas_Object *obj, Evas_Object* subobj)
    void                     elm_win_title_set(Evas_Object *obj, const char *title)
    const char *             elm_win_title_get(const Evas_Object *obj)
    Elm_Win_Type             elm_win_type_get(const Evas_Object *obj)
    void                     elm_win_icon_name_set(Evas_Object *obj, const char *icon_name)
    const char *             elm_win_icon_name_get(const Evas_Object *obj)
    void                     elm_win_role_set(Evas_Object *obj, const char *role)
    const char *             elm_win_role_get(const Evas_Object *obj)
    void                     elm_win_icon_object_set(Evas_Object* obj, Evas_Object* icon)
    const Evas_Object       *elm_win_icon_object_get(const Evas_Object*)
    void                     elm_win_autodel_set(Evas_Object *obj, Eina_Bool autodel)
    Eina_Bool                elm_win_autodel_get(const Evas_Object *obj)
    void                     elm_win_autohide_set(Evas_Object *obj, Eina_Bool autodel)
    Eina_Bool                elm_win_autohide_get(const Evas_Object *obj)
    void                     elm_win_activate(Evas_Object *obj)
    void                     elm_win_lower(Evas_Object *obj)
    void                     elm_win_raise(Evas_Object *obj)
    void                     elm_win_center(Evas_Object *obj, Eina_Bool h, Eina_Bool v)
    void                     elm_win_borderless_set(Evas_Object *obj, Eina_Bool borderless)
    Eina_Bool                elm_win_borderless_get(const Evas_Object *obj)
    void                     elm_win_shaped_set(Evas_Object *obj, Eina_Bool shaped)
    Eina_Bool                elm_win_shaped_get(const Evas_Object *obj)
    void                     elm_win_alpha_set(Evas_Object *obj, Eina_Bool alpha)
    Eina_Bool                elm_win_alpha_get(const Evas_Object *obj)
    void                     elm_win_override_set(Evas_Object *obj, Eina_Bool override)
    Eina_Bool                elm_win_override_get(const Evas_Object *obj)
    void                     elm_win_fullscreen_set(Evas_Object *obj, Eina_Bool fullscreen)
    Eina_Bool                elm_win_fullscreen_get(const Evas_Object *obj)
    Evas_Object          *elm_win_main_menu_get(const Evas_Object *obj)
    void                     elm_win_maximized_set(Evas_Object *obj, Eina_Bool maximized)
    Eina_Bool                elm_win_maximized_get(const Evas_Object *obj)
    void                     elm_win_iconified_set(Evas_Object *obj, Eina_Bool iconified)
    Eina_Bool                elm_win_iconified_get(const Evas_Object *obj)
    void                     elm_win_withdrawn_set(Evas_Object *obj, Eina_Bool withdrawn)
    Eina_Bool                elm_win_withdrawn_get(const Evas_Object *obj)

    void                  elm_win_available_profiles_set(Evas_Object *obj, const char **profiles, unsigned int count)
    Eina_Bool             elm_win_available_profiles_get(const Evas_Object *obj, char ***profiles, unsigned int *count)
    void                  elm_win_profile_set(Evas_Object *obj, const char *profile)
    const char           *elm_win_profile_get(const Evas_Object *obj)

    void                     elm_win_urgent_set(Evas_Object *obj, Eina_Bool urgent)
    Eina_Bool                elm_win_urgent_get(const Evas_Object *obj)
    void                     elm_win_demand_attention_set(Evas_Object *obj, Eina_Bool demand_attention)
    Eina_Bool                elm_win_demand_attention_get(const Evas_Object *obj)
    void                     elm_win_modal_set(Evas_Object *obj, Eina_Bool modal)
    Eina_Bool                elm_win_modal_get(const Evas_Object *obj)
    void                     elm_win_aspect_set(Evas_Object *obj, double aspect)
    double                   elm_win_aspect_get(const Evas_Object *obj)
    void                     elm_win_size_base_set(Evas_Object *obj, int w, int h)
    void                     elm_win_size_base_get(const Evas_Object *obj, int *w, int *h)
    void                     elm_win_size_step_set(Evas_Object *obj, int w, int h)
    void                     elm_win_size_step_get(const Evas_Object *obj, int *w, int *h)
    void                     elm_win_layer_set(Evas_Object *obj, int layer)
    int                      elm_win_layer_get(const Evas_Object *obj)
    void                  elm_win_norender_push(Evas_Object *obj)
    void                  elm_win_norender_pop(Evas_Object *obj)
    int                   elm_win_norender_get(const Evas_Object *obj)
    void                  elm_win_render(Evas_Object *obj)
    void                     elm_win_rotation_set(Evas_Object *obj, int rotation)
    void                     elm_win_rotation_with_resize_set(Evas_Object *obj, int rotation)
    int                      elm_win_rotation_get(const Evas_Object *obj)
    void                     elm_win_sticky_set(Evas_Object *obj, Eina_Bool sticky)
    Eina_Bool                elm_win_sticky_get(const Evas_Object *obj)
    void                     elm_win_conformant_set(Evas_Object *obj, Eina_Bool conformant)
    Eina_Bool                elm_win_conformant_get(const Evas_Object *obj)

    void                     elm_win_quickpanel_set(Evas_Object *obj, Eina_Bool quickpanel)
    Eina_Bool                elm_win_quickpanel_get(const Evas_Object *obj)
    void                     elm_win_quickpanel_priority_major_set(Evas_Object *obj, int priority)
    int                      elm_win_quickpanel_priority_major_get(const Evas_Object *obj)
    void                     elm_win_quickpanel_priority_minor_set(Evas_Object *obj, int priority)
    int                      elm_win_quickpanel_priority_minor_get(const Evas_Object *obj)
    void                     elm_win_quickpanel_zone_set(Evas_Object *obj, int zone)
    int                      elm_win_quickpanel_zone_get(const Evas_Object *obj)

    void                     elm_win_prop_focus_skip_set(Evas_Object *obj, Eina_Bool skip)
    void                     elm_win_illume_command_send(Evas_Object *obj, Elm_Illume_Command command, params)
    Evas_Object             *elm_win_inlined_image_object_get(const Evas_Object *obj)
    Eina_Bool                elm_win_focus_get(const Evas_Object *obj)
    void                     elm_win_screen_constrain_set(Evas_Object *obj, Eina_Bool constrain)
    Eina_Bool                elm_win_screen_constrain_get(const Evas_Object *obj)
    void                     elm_win_screen_size_get(const Evas_Object *obj, int *x, int *y, int *w, int *h)
    void                     elm_win_screen_dpi_get(const Evas_Object *obj, int *xdpi, int *ydpi)

    void                     elm_win_focus_highlight_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool                elm_win_focus_highlight_enabled_get(const Evas_Object *obj)
    void                     elm_win_focus_highlight_style_set(Evas_Object *obj, const char *style)
    const char *             elm_win_focus_highlight_style_get(const Evas_Object *obj)
    void                     elm_win_focus_highlight_animate_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool                elm_win_focus_highlight_animate_get(const Evas_Object *obj)

    void                     elm_win_keyboard_mode_set(Evas_Object *obj, Elm_Win_Keyboard_Mode mode)
    Elm_Win_Keyboard_Mode    elm_win_keyboard_mode_get(const Evas_Object *obj)
    void                     elm_win_keyboard_win_set(Evas_Object *obj, Eina_Bool is_keyboard)
    Eina_Bool                elm_win_keyboard_win_get(const Evas_Object *obj)

    void                     elm_win_indicator_mode_set(Evas_Object *obj, Elm_Win_Indicator_Mode mode)
    Elm_Win_Indicator_Mode   elm_win_indicator_mode_get(const Evas_Object *obj)
    void                     elm_win_indicator_opacity_set(Evas_Object *obj, Elm_Win_Indicator_Opacity_Mode mode)
    Elm_Win_Indicator_Opacity_Mode elm_win_indicator_opacity_get(const Evas_Object *obj)

    void                     elm_win_screen_position_get(const Evas_Object *obj, int *x, int *y)
    Eina_Bool                elm_win_socket_listen(Evas_Object *obj, const char *svcname, int svcnum, Eina_Bool svcsys)

    Eina_Bool                elm_win_wm_rotation_supported_get(const Evas_Object *obj)
    void                     elm_win_wm_rotation_preferred_rotation_set(const Evas_Object *obj, int rotation)
    int                      elm_win_wm_rotation_preferred_rotation_get(const Evas_Object *obj)
    void                     elm_win_wm_rotation_available_rotations_set(Evas_Object *obj, int *rotations, unsigned int count)
    Eina_Bool                elm_win_wm_rotation_available_rotations_get(const Evas_Object *obj, int **rotations, unsigned int *count)
    void                     elm_win_wm_rotation_manual_rotation_done_set(Evas_Object *obj, Eina_Bool set)
    Eina_Bool                elm_win_wm_rotation_manual_rotation_done_get(const Evas_Object *obj)
    void                     elm_win_wm_rotation_manual_rotation_done(Evas_Object *obj)

    void                     elm_win_floating_mode_set(Evas_Object *obj, Eina_Bool floating)
    Eina_Bool                elm_win_floating_mode_get(const Evas_Object *obj)

    Eina_Bool                elm_win_noblank_get(const Evas_Object *obj)
    void                     elm_win_noblank_set(Evas_Object *obj, Eina_Bool noblank)

    # X specific call - won't work on non-x engines (return 0)
    unsigned int             elm_win_xwindow_get(const Evas_Object *obj)
