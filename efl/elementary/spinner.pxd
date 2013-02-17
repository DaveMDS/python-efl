from efl.evas cimport Eina_Bool, Evas_Object
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_spinner_add(Evas_Object *parent)
    void                     elm_spinner_label_format_set(Evas_Object *obj, const_char *format)
    const_char *             elm_spinner_label_format_get(Evas_Object *obj)
    void                     elm_spinner_min_max_set(Evas_Object *obj, double min, double max)
    void                     elm_spinner_min_max_get(Evas_Object *obj, double *min, double *max)
    void                     elm_spinner_step_set(Evas_Object *obj, double step)
    double                   elm_spinner_step_get(Evas_Object *obj)
    void                     elm_spinner_value_set(Evas_Object *obj, double val)
    double                   elm_spinner_value_get(Evas_Object *obj)
    void                     elm_spinner_wrap_set(Evas_Object *obj, Eina_Bool wrap)
    Eina_Bool                elm_spinner_wrap_get(Evas_Object *obj)
    void                     elm_spinner_editable_set(Evas_Object *obj, Eina_Bool editable)
    Eina_Bool                elm_spinner_editable_get(Evas_Object *obj)
    void                     elm_spinner_special_value_add(Evas_Object *obj, double value, const_char *label)
    void                     elm_spinner_interval_set(Evas_Object *obj, double interval)
    double                   elm_spinner_interval_get(Evas_Object *obj)
    void                     elm_spinner_base_set(Evas_Object *obj, double base)
    double                   elm_spinner_base_get(Evas_Object *obj)
    void                     elm_spinner_round_set(Evas_Object *obj, int rnd)
    int                      elm_spinner_round_get(Evas_Object *obj)
