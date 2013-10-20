from efl.evas cimport Eina_Bool, Evas_Object, const_Evas_Object, Eina_List
from enums cimport Elm_Dayselector_Day
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_dayselector_add(Evas_Object *parent)
    void                     elm_dayselector_day_selected_set(Evas_Object *obj, Elm_Dayselector_Day day, Eina_Bool selected)
    Eina_Bool                elm_dayselector_day_selected_get(const_Evas_Object *obj, Elm_Dayselector_Day day)
    void                     elm_dayselector_week_start_set(Evas_Object *obj, Elm_Dayselector_Day day)
    Elm_Dayselector_Day      elm_dayselector_week_start_get(const_Evas_Object *obj)
    void                     elm_dayselector_weekend_start_set(Evas_Object *obj, Elm_Dayselector_Day day)
    Elm_Dayselector_Day      elm_dayselector_weekend_start_get(const_Evas_Object *obj)
    void                     elm_dayselector_weekend_length_set(Evas_Object *obj, unsigned int length)
    unsigned int             elm_dayselector_weekend_length_get(const_Evas_Object *obj)
    void                     elm_dayselector_weekdays_names_set(Evas_Object *obj, const_char *weekdays[])
    Eina_List               *elm_dayselector_weekdays_names_get(const_Evas_Object *obj)
