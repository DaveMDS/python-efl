cdef extern from "Elementary.h":

    cpdef enum Elm_Datetime_Field_Type:
        ELM_DATETIME_YEAR
        ELM_DATETIME_MONTH
        ELM_DATETIME_DATE
        ELM_DATETIME_HOUR
        ELM_DATETIME_MINUTE
        ELM_DATETIME_AMPM
    ctypedef enum Elm_Datetime_Field_Type:
        pass


    Evas_Object *           elm_datetime_add(Evas_Object *parent)
    const char *            elm_datetime_format_get(const Evas_Object *obj)
    void                    elm_datetime_format_set(Evas_Object *obj, const char *fmt)
    Eina_Bool               elm_datetime_value_max_get(const Evas_Object *obj, tm *maxtime)
    Eina_Bool               elm_datetime_value_max_set(Evas_Object *obj, tm *maxtime)
    Eina_Bool               elm_datetime_value_min_get(const Evas_Object *obj, tm *mintime)
    Eina_Bool               elm_datetime_value_min_set(Evas_Object *obj, tm *mintime)
    void                    elm_datetime_field_limit_get(const Evas_Object *obj, Elm_Datetime_Field_Type fieldtype, int *min, int *max)
    void                    elm_datetime_field_limit_set(Evas_Object *obj, Elm_Datetime_Field_Type fieldtype, int min, int max)
    Eina_Bool               elm_datetime_value_get(const Evas_Object *obj, tm *currtime)
    Eina_Bool               elm_datetime_value_set(Evas_Object *obj, tm *newtime)
    Eina_Bool               elm_datetime_field_visible_get(const Evas_Object *obj, Elm_Datetime_Field_Type fieldtype)
    void                    elm_datetime_field_visible_set(Evas_Object *obj, Elm_Datetime_Field_Type fieldtype, Eina_Bool visible)
