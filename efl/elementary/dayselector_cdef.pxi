cdef extern from "Elementary.h":

    cpdef enum Elm_Dayselector_Day:
        ELM_DAYSELECTOR_SUN
        ELM_DAYSELECTOR_MON
        ELM_DAYSELECTOR_TUE
        ELM_DAYSELECTOR_WED
        ELM_DAYSELECTOR_THU
        ELM_DAYSELECTOR_FRI
        ELM_DAYSELECTOR_SAT
        ELM_DAYSELECTOR_MAX
    ctypedef enum Elm_Dayselector_Day:
        pass


    Evas_Object             *elm_dayselector_add(Evas_Object *parent)
    void                     elm_dayselector_day_selected_set(Evas_Object *obj, Elm_Dayselector_Day day, Eina_Bool selected)
    Eina_Bool                elm_dayselector_day_selected_get(const Evas_Object *obj, Elm_Dayselector_Day day)
    void                     elm_dayselector_week_start_set(Evas_Object *obj, Elm_Dayselector_Day day)
    Elm_Dayselector_Day      elm_dayselector_week_start_get(const Evas_Object *obj)
    void                     elm_dayselector_weekend_start_set(Evas_Object *obj, Elm_Dayselector_Day day)
    Elm_Dayselector_Day      elm_dayselector_weekend_start_get(const Evas_Object *obj)
    void                     elm_dayselector_weekend_length_set(Evas_Object *obj, unsigned int length)
    unsigned int             elm_dayselector_weekend_length_get(const Evas_Object *obj)
    void                     elm_dayselector_weekdays_names_set(Evas_Object *obj, const char *weekdays[])
    Eina_List               *elm_dayselector_weekdays_names_get(const Evas_Object *obj)
