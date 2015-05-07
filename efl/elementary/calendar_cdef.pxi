cdef extern from "time.h":
    struct tm:
        int tm_sec
        int tm_min
        int tm_hour
        int tm_mday
        int tm_mon
        int tm_year
        int tm_wday
        int tm_yday
        int tm_isdst

        long int tm_gmtoff
        const char *tm_zone

cdef extern from "Elementary.h":

    cpdef enum Elm_Calendar_Mark_Repeat_Type:
        ELM_CALENDAR_UNIQUE
        ELM_CALENDAR_DAILY
        ELM_CALENDAR_WEEKLY
        ELM_CALENDAR_MONTHLY
        ELM_CALENDAR_ANNUALLY
        ELM_CALENDAR_LAST_DAY_OF_MONTH
    ctypedef enum Elm_Calendar_Mark_Repeat_Type:
        pass

    cpdef enum Elm_Calendar_Select_Mode:
        ELM_CALENDAR_SELECT_MODE_DEFAULT
        ELM_CALENDAR_SELECT_MODE_ALWAYS
        ELM_CALENDAR_SELECT_MODE_NONE
        ELM_CALENDAR_SELECT_MODE_ONDEMAND
    ctypedef enum Elm_Calendar_Select_Mode:
        pass

    cpdef enum Elm_Calendar_Selectable:
        ELM_CALENDAR_SELECTABLE_NONE
        ELM_CALENDAR_SELECTABLE_YEAR
        ELM_CALENDAR_SELECTABLE_MONTH
        ELM_CALENDAR_SELECTABLE_DAY
    ctypedef enum Elm_Calendar_Selectable:
        pass

    cpdef enum Elm_Calendar_Weekday:
        ELM_DAY_SUNDAY
        ELM_DAY_MONDAY
        ELM_DAY_TUESDAY
        ELM_DAY_WEDNESDAY
        ELM_DAY_THURSDAY
        ELM_DAY_FRIDAY
        ELM_DAY_SATURDAY
        ELM_DAY_LAST
    ctypedef enum Elm_Calendar_Weekday:
        pass


    ctypedef char           *(*Elm_Calendar_Format_Cb)     (tm *stime)


    ctypedef struct Elm_Calendar_Mark:
        pass


    Evas_Object *               elm_calendar_add(Evas_Object *parent)
    const char **               elm_calendar_weekdays_names_get(const Evas_Object *obj)
    void                        elm_calendar_weekdays_names_set(Evas_Object *obj, const char *weekdays[])
    void                        elm_calendar_min_max_year_set(Evas_Object *obj, int min, int max)
    void                        elm_calendar_min_max_year_get(const Evas_Object *obj, int *min, int *max)
    void                        elm_calendar_select_mode_set(Evas_Object *obj, Elm_Calendar_Select_Mode mode)
    Elm_Calendar_Select_Mode    elm_calendar_select_mode_get(const Evas_Object *obj)
    void                        elm_calendar_selected_time_set(Evas_Object *obj, tm *selected_time)
    Eina_Bool                   elm_calendar_selected_time_get(const Evas_Object *obj, tm *selected_time)
    #TODO: void                 elm_calendar_format_function_set(Evas_Object *obj, Elm_Calendar_Format_Cb format_func)
    Elm_Calendar_Mark *         elm_calendar_mark_add(Evas_Object *obj, const char *mark_type, tm *mark_time, Elm_Calendar_Mark_Repeat_Type repeat)
    void                        elm_calendar_mark_del(Elm_Calendar_Mark *mark)
    void                        elm_calendar_marks_clear(Evas_Object *obj)
    const Eina_List *           elm_calendar_marks_get(const Evas_Object *obj)
    void                        elm_calendar_marks_draw(Evas_Object *obj)
    void                        elm_calendar_interval_set(Evas_Object *obj, double interval)
    double                      elm_calendar_interval_get(const Evas_Object *obj)
    void                        elm_calendar_first_day_of_week_set(Evas_Object *obj, Elm_Calendar_Weekday day)
    Elm_Calendar_Weekday        elm_calendar_first_day_of_week_get(const Evas_Object *obj)
    void                        elm_calendar_selectable_set(Evas_Object *obj, Elm_Calendar_Selectable selectable)
    Elm_Calendar_Selectable     elm_calendar_selectable_get(const Evas_Object *obj)
    Eina_Bool                   elm_calendar_displayed_time_get(const Evas_Object *obj, tm *displayed_time)

