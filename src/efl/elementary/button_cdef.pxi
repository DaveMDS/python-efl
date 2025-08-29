cdef extern from "Elementary.h":

    Evas_Object             *elm_button_add(Evas_Object *parent)
    void                     elm_button_autorepeat_set(Evas_Object *obj, Eina_Bool on)
    Eina_Bool                elm_button_autorepeat_get(const Evas_Object *obj)
    void                     elm_button_autorepeat_initial_timeout_set(Evas_Object *obj, double t)
    double                   elm_button_autorepeat_initial_timeout_get(const Evas_Object *obj)
    void                     elm_button_autorepeat_gap_timeout_set(Evas_Object *obj, double t)
    double                   elm_button_autorepeat_gap_timeout_get(const Evas_Object *obj)
