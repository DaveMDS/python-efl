cdef extern from "Elementary.h":
    Evas_Object             *elm_radio_add(Evas_Object *parent)
    void                     elm_radio_group_add(Evas_Object *obj, Evas_Object *group)
    void                     elm_radio_state_value_set(Evas_Object *obj, int value)
    int                      elm_radio_state_value_get(const Evas_Object *obj)
    void                     elm_radio_value_set(Evas_Object *obj, int value)
    int                      elm_radio_value_get(const Evas_Object *obj)
    void                     elm_radio_value_pointer_set(Evas_Object *obj, int *valuep)
    Evas_Object             *elm_radio_selected_object_get(const Evas_Object *obj)
