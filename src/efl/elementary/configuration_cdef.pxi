from efl.elementary.enums cimport Elm_Softcursor_Mode, \
    Elm_Slider_Indicator_Visible_Mode, Elm_Focus_Move_Policy, \
    Elm_Focus_Autoscroll_Mode, Edje_Channel

cdef extern from "Elementary.h":
    ctypedef struct Elm_Font_Overlay:
        const char *text_class
        const char *font
        Evas_Font_Size size

    ctypedef struct Elm_Text_Class:
        const char *name
        const char *desc

    ctypedef struct Elm_Color_Class:
        const char *name
        const char *desc


    ctypedef struct _Elm_Color_Overlay_Color:
        int r, g, b, a

    ctypedef struct Elm_Color_Overlay:
        const char *color_class
        _Elm_Color_Overlay_Color color, outline, shadow


    Eina_Bool               elm_config_save()
    void                    elm_config_reload()
    void                    elm_config_all_flush()

    const char *            elm_config_profile_get()
    const char *            elm_config_profile_dir_get(const char *profile, Eina_Bool is_user)
    void                    elm_config_profile_dir_free(const char *p_dir)
    Eina_List *             elm_config_profile_list_get()
    Eina_List *             elm_config_profile_list_full_get()
    void                    elm_config_profile_list_free(Eina_List *l)
    void                    elm_config_profile_set(const char *profile)
    Eina_Bool               elm_config_profile_exists(const char *profile)
    void                    elm_config_profile_derived_add(const char *profile, const char *derive_options)
    void                    elm_config_profile_derived_del(const char *profile)
    void                    elm_config_profile_save(const char *profile)

    Eina_Bool               elm_config_scroll_bounce_enabled_get()
    void                    elm_config_scroll_bounce_enabled_set(Eina_Bool enabled)
    double                  elm_config_scroll_bounce_friction_get()
    void                    elm_config_scroll_bounce_friction_set(double friction)
    double                  elm_config_scroll_page_scroll_friction_get()
    void                    elm_config_scroll_page_scroll_friction_set(double friction)
    double                  elm_config_scroll_bring_in_scroll_friction_get()
    void                    elm_config_scroll_bring_in_scroll_friction_set(double friction)
    double                  elm_config_scroll_zoom_friction_get()
    void                    elm_config_scroll_zoom_friction_set(double friction)
    double                  elm_config_scroll_accel_factor_get()
    void                    elm_config_scroll_accel_factor_set(double factor)
    Eina_Bool               elm_config_scroll_animation_disabled_get()
    void                    elm_config_scroll_animation_disabled_set(Eina_Bool disabled)

    Eina_Bool               elm_config_scroll_thumbscroll_enabled_get()
    void                    elm_config_scroll_thumbscroll_enabled_set(Eina_Bool enabled)
    unsigned int            elm_config_scroll_thumbscroll_threshold_get()
    void                    elm_config_scroll_thumbscroll_threshold_set(unsigned int threshold)
    unsigned int            elm_config_scroll_thumbscroll_hold_threshold_get()
    void                    elm_config_scroll_thumbscroll_hold_threshold_set(unsigned int threshold)
    double                  elm_config_scroll_thumbscroll_momentum_threshold_get()
    void                    elm_config_scroll_thumbscroll_momentum_threshold_set(double threshold)
    unsigned int            elm_config_scroll_thumbscroll_flick_distance_tolerance_get()
    void                    elm_config_scroll_thumbscroll_flick_distance_tolerance_set(unsigned int distance)
    double                  elm_config_scroll_thumbscroll_friction_get()
    void                    elm_config_scroll_thumbscroll_friction_set(double friction)
    double                  elm_config_scroll_thumbscroll_min_friction_get()
    void                    elm_config_scroll_thumbscroll_min_friction_set(double friction)
    double                  elm_config_scroll_thumbscroll_friction_standard_get()
    void                    elm_config_scroll_thumbscroll_friction_standard_set(double standard)
    double                  elm_config_scroll_thumbscroll_border_friction_get()
    void                    elm_config_scroll_thumbscroll_border_friction_set(double friction)
    double                  elm_config_scroll_thumbscroll_sensitivity_friction_get()
    void                    elm_config_scroll_thumbscroll_sensitivity_friction_set(double friction)
    double                  elm_config_scroll_thumbscroll_acceleration_threshold_get()
    void                    elm_config_scroll_thumbscroll_acceleration_threshold_set(double threshold)
    double                  elm_config_scroll_thumbscroll_acceleration_time_limit_get()
    void                    elm_config_scroll_thumbscroll_acceleration_time_limit_set(double time_limit)
    double                  elm_config_scroll_thumbscroll_acceleration_weight_get()
    void                    elm_config_scroll_thumbscroll_acceleration_weight_set(double weight)
    Eina_Bool               elm_config_scroll_thumbscroll_smooth_start_get()
    void                    elm_config_scroll_thumbscroll_smooth_start_set(Eina_Bool enable)
    double                  elm_config_scroll_thumbscroll_smooth_amount_get()
    void                    elm_config_scroll_thumbscroll_smooth_amount_set(double amount)
    double                  elm_config_scroll_thumbscroll_smooth_time_window_get()
    void                    elm_config_scroll_thumbscroll_smooth_time_window_set(double amount)

    double                  elm_config_longpress_timeout_get()
    void                    elm_config_longpress_timeout_set(double longpress_timeout)
    void                    elm_config_softcursor_mode_set(Elm_Softcursor_Mode mode)
    Elm_Softcursor_Mode     elm_config_softcursor_mode_get()
    double                  elm_config_tooltip_delay_get()
    Eina_Bool               elm_config_tooltip_delay_set(double delay)
    int                     elm_config_cursor_engine_only_get()
    Eina_Bool               elm_config_cursor_engine_only_set(int engine_only)
    double                  elm_config_scale_get()
    void                    elm_config_scale_set(double scale)

    Eina_Bool               elm_config_password_show_last_get()
    void                    elm_config_password_show_last_set(Eina_Bool password_show_last)
    double                  elm_config_password_show_last_timeout_get()
    void                    elm_config_password_show_last_timeout_set(double password_show_last_timeout)

    const char *            elm_config_engine_get()
    void                    elm_config_engine_set(const char *engine)
    const char *            elm_config_preferred_engine_get()
    void                    elm_config_preferred_engine_set(const char *engine)
    const char *            elm_config_accel_preference_get()
    void                    elm_config_accel_preference_set(const char *pref)
    Eina_Bool               elm_config_accel_preference_override_get()
    void                    elm_config_accel_preference_override_set(Eina_Bool enabled)

    Eina_List *             elm_config_color_classes_list_get()
    void                    elm_config_color_classes_list_free(Eina_List *list)
    const Eina_List *       elm_config_color_overlay_list_get()
    void                    elm_config_color_overlay_set(const char *color_class, int r, int g, int b, int a, int r2, int g2, int b2, int a2, int r3, int g3, int b3, int a3)
    void                    elm_config_color_overlay_unset(const char *color_class)
    void                    elm_config_color_overlay_apply()

    Eina_List *             elm_config_text_classes_list_get()
    void                    elm_config_text_classes_list_free(Eina_List *list)
    Eina_List *             elm_config_font_overlay_list_get()
    void                    elm_config_font_overlay_set(const char *text_class, const char *font, Evas_Font_Size size)
    #TODO: Eina_Bool               elm_config_access_get()
    #TODO: void                    elm_config_access_set(Eina_Bool is_access)
    Eina_Bool               elm_config_selection_unfocused_clear_get()
    void                    elm_config_selection_unfocused_clear_set(Eina_Bool enabled)
    void                    elm_config_font_overlay_unset(const char *text_class)
    void                    elm_config_font_overlay_apply()
    void                    elm_config_font_hint_type_set(int type)
    Evas_Coord              elm_config_finger_size_get()
    void                    elm_config_finger_size_set(Evas_Coord size)

    int                     elm_config_cache_flush_interval_get()
    void                    elm_config_cache_flush_interval_set(int size)
    Eina_Bool               elm_config_cache_flush_enabled_get()
    void                    elm_config_cache_flush_enabled_set(Eina_Bool enabled)
    int                     elm_config_cache_font_cache_size_get()
    void                    elm_config_cache_font_cache_size_set(int size)
    int                     elm_config_cache_image_cache_size_get()
    void                    elm_config_cache_image_cache_size_set(int size)
    int                     elm_config_cache_edje_file_cache_size_get()
    void                    elm_config_cache_edje_file_cache_size_set(int size)
    int                     elm_config_cache_edje_collection_cache_size_get()
    void                    elm_config_cache_edje_collection_cache_size_set(int size)

    Eina_Bool               elm_config_focus_highlight_enabled_get()
    void                    elm_config_focus_highlight_enabled_set(Eina_Bool enable)
    Eina_Bool               elm_config_focus_highlight_animate_get()
    void                    elm_config_focus_highlight_animate_set(Eina_Bool animate)
    Eina_Bool               elm_config_focus_highlight_clip_disabled_get()
    void                    elm_config_focus_highlight_clip_disabled_set(Eina_Bool disabled)
    Elm_Focus_Move_Policy   elm_config_focus_move_policy_get()
    void                    elm_config_focus_move_policy_set(Elm_Focus_Move_Policy policy)
    Eina_Bool               elm_config_item_select_on_focus_disabled_get()
    void                    elm_config_item_select_on_focus_disabled_set(Eina_Bool disabled)
    Eina_Bool               elm_config_first_item_focus_on_first_focusin_get()
    void                    elm_config_first_item_focus_on_first_focusin_set(Eina_Bool enabled)

    const char *            elm_config_icon_theme_get()
    void                    elm_config_icon_theme_set(const char *theme)

    Eina_Bool               elm_config_vsync_get()
    void                    elm_config_vsync_set(Eina_Bool enabled)

    Elm_Focus_Autoscroll_Mode elm_config_focus_autoscroll_mode_get()
    void                    elm_config_focus_autoscroll_mode_set(Elm_Focus_Autoscroll_Mode mode)
    Eina_Bool               elm_config_window_auto_focus_enable_get()
    void                    elm_config_window_auto_focus_enable_set(Eina_Bool enable)
    Eina_Bool               elm_config_window_auto_focus_animate_get()
    void                    elm_config_window_auto_focus_animate_set(Eina_Bool enable)

    Eina_Bool               elm_config_context_menu_disabled_get()
    void                    elm_config_context_menu_disabled_set(Eina_Bool disabled)

    Eina_Bool               elm_config_mirrored_get()
    void                    elm_config_mirrored_set(Eina_Bool mirrored)

    Eina_Bool               elm_config_clouseau_enabled_get()
    void                    elm_config_clouseau_enabled_set(Eina_Bool enabled)

    Eina_Bool               elm_config_popup_scrollable_get()
    void                    elm_config_popup_scrollable_set(Eina_Bool scrollable)

    const char *            elm_config_web_backend_get()
    void                    elm_config_web_backend_set(const char *backend)

    const char *            elm_config_indicator_service_get(int rotation)

    double                  elm_config_glayer_long_tap_start_timeout_get()
    void                    elm_config_glayer_long_tap_start_timeout_set(double long_tap_timeout)
    double                  elm_config_glayer_double_tap_timeout_get()
    void                    elm_config_glayer_double_tap_timeout_set(double double_tap_timeout)

    Eina_Bool               elm_config_magnifier_enable_get()
    void                    elm_config_magnifier_enable_set(Eina_Bool enable)
    double                  elm_config_magnifier_scale_get()
    void                    elm_config_magnifier_scale_set(double scale)
    Eina_Bool               elm_config_audio_mute_get(Edje_Channel channel)
    void                    elm_config_audio_mute_set(Edje_Channel channel, Eina_Bool mute)
    Eina_Bool               elm_config_atspi_mode_get()
    void                    elm_config_atspi_mode_set(Eina_Bool is_atspi)

    void                    elm_config_slider_indicator_visible_mode_set(Elm_Slider_Indicator_Visible_Mode mode)
    Elm_Slider_Indicator_Visible_Mode elm_config_slider_indicator_visible_mode_get()
    void                    elm_config_transition_duration_factor_set(double factor)
    double                  elm_config_transition_duration_factor_get()

