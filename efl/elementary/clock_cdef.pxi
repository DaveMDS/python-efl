from efl.elementary.enums cimport Elm_Clock_Edit_Mode

cdef extern from "Elementary.h":
    Evas_Object             *elm_clock_add(Evas_Object *parent)
    void                     elm_clock_time_set(Evas_Object *obj, int hrs, int min, int sec)
    void                     elm_clock_time_get(const Evas_Object *obj, int *hrs, int *min, int *sec)
    void                     elm_clock_edit_set(Evas_Object *obj, Eina_Bool edit)
    Eina_Bool                elm_clock_edit_get(const Evas_Object *obj)
    void                     elm_clock_edit_mode_set(Evas_Object *obj, Elm_Clock_Edit_Mode mode)
    Elm_Clock_Edit_Mode      elm_clock_edit_mode_get(const Evas_Object *obj)
    void                     elm_clock_show_am_pm_set(Evas_Object *obj, Eina_Bool am_pm)
    Eina_Bool                elm_clock_show_am_pm_get(const Evas_Object *obj)
    void                     elm_clock_show_seconds_set(Evas_Object *obj, Eina_Bool seconds)
    Eina_Bool                elm_clock_show_seconds_get(const Evas_Object *obj)
    void                     elm_clock_first_interval_set(Evas_Object *obj, double interval)
    double                   elm_clock_first_interval_get(const Evas_Object *obj)
    Eina_Bool                elm_clock_pause_get(const Evas_Object *obj)
    void                     elm_clock_pause_set(Evas_Object *obj, Eina_Bool pause)
