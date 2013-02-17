from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_slider_add(Evas_Object *parent)
    void                     elm_slider_span_size_set(Evas_Object *obj, Evas_Coord size)
    Evas_Coord               elm_slider_span_size_get(Evas_Object *obj)
    void                     elm_slider_unit_format_set(Evas_Object *obj, const_char *format)
    const_char *             elm_slider_unit_format_get(Evas_Object *obj)
    void                     elm_slider_indicator_format_set(Evas_Object *obj, const_char *indicator)
    const_char *             elm_slider_indicator_format_get(Evas_Object *obj)
    #void                     elm_slider_indicator_format_function_set(Evas_Object *obj, const_char *(*func)(double val), void (*free_func)(const_char *str))
    #void                     elm_slider_units_format_function_set(Evas_Object *obj, const_char *(*func)(double val), void (*free_func)(const_char *str))
    void                     elm_slider_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_slider_horizontal_get(Evas_Object *obj)
    void                     elm_slider_min_max_set(Evas_Object *obj, double min, double max)
    void                     elm_slider_min_max_get(Evas_Object *obj, double *min, double *max)
    void                     elm_slider_value_set(Evas_Object *obj, double val)
    double                   elm_slider_value_get(Evas_Object *obj)
    void                     elm_slider_inverted_set(Evas_Object *obj, Eina_Bool inverted)
    Eina_Bool                elm_slider_inverted_get(Evas_Object *obj)
    void                     elm_slider_indicator_show_set(Evas_Object *obj, Eina_Bool show)
    Eina_Bool                elm_slider_indicator_show_get(Evas_Object *obj)

