cdef extern from "Elementary.h":

    cpdef enum Elm_Slider_Indicator_Visible_Mode:
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_DEFAULT
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_ALWAYS
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_ON_FOCUS
        ELM_SLIDER_INDICATOR_VISIBLE_MODE_NONE
    ctypedef enum Elm_Slider_Indicator_Visible_Mode:
        pass

    Evas_Object *   elm_slider_add(Evas_Object *parent)
    void            elm_slider_span_size_set(Evas_Object *obj, Evas_Coord size)
    Evas_Coord      elm_slider_span_size_get(const Evas_Object *obj)
    void            elm_slider_unit_format_set(Evas_Object *obj, const char *format)
    const char *    elm_slider_unit_format_get(const Evas_Object *obj)
    void            elm_slider_indicator_format_set(Evas_Object *obj, const char *indicator)
    const char *    elm_slider_indicator_format_get(const Evas_Object *obj)
    # TODO: void            elm_slider_indicator_format_function_set(Evas_Object *obj, const char(*func)(double val), void (*free_func)(const char *str))
    # TODO: void           elm_slider_units_format_function_set(Evas_Object *obj, const char *(*func)(double val), void (*free_func)(const char *str))
    void            elm_slider_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool       elm_slider_horizontal_get(const Evas_Object *obj)
    void            elm_slider_min_max_set(Evas_Object *obj, double min, double max)
    void            elm_slider_min_max_get(const Evas_Object *obj, double *min, double *max)
    void            elm_slider_value_set(Evas_Object *obj, double val)
    double          elm_slider_value_get(const Evas_Object *obj)
    void            elm_slider_inverted_set(Evas_Object *obj, Eina_Bool inverted)
    Eina_Bool       elm_slider_inverted_get(const Evas_Object *obj)
    void            elm_slider_indicator_show_set(Evas_Object *obj, Eina_Bool show)
    Eina_Bool       elm_slider_indicator_show_get(const Evas_Object *obj)
    void            elm_slider_indicator_visible_mode_set(const Evas_Object *obj, Elm_Slider_Indicator_Visible_Mode indicator_visible_mode)
    Elm_Slider_Indicator_Visible_Mode  elm_slider_indicator_visible_mode_get(const Evas_Object *obj)
    void            elm_slider_step_set(Evas_Object *obj, double step)
    double          elm_slider_step_get(const Evas_Object *obj)
