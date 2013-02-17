from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_progressbar_add(Evas_Object *parent)
    void                     elm_progressbar_pulse_set(Evas_Object *obj, Eina_Bool pulse)
    Eina_Bool                elm_progressbar_pulse_get(Evas_Object *obj)
    void                     elm_progressbar_pulse(Evas_Object *obj, Eina_Bool state)
    void                     elm_progressbar_value_set(Evas_Object *obj, double val)
    double                   elm_progressbar_value_get(Evas_Object *obj)
    void                     elm_progressbar_span_size_set(Evas_Object *obj, Evas_Coord size)
    Evas_Coord               elm_progressbar_span_size_get(Evas_Object *obj)
    void                     elm_progressbar_unit_format_set(Evas_Object *obj, const_char *format)
    const_char *             elm_progressbar_unit_format_get(Evas_Object *obj)
    void                     elm_progressbar_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_progressbar_horizontal_get(Evas_Object *obj)
    void                     elm_progressbar_inverted_set(Evas_Object *obj, Eina_Bool inverted)
    Eina_Bool                elm_progressbar_inverted_get(Evas_Object *obj)
