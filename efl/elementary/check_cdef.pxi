cdef extern from "Elementary.h":
    Evas_Object             *elm_check_add(Evas_Object *parent)
    void                     elm_check_state_set(Evas_Object *obj, Eina_Bool state)
    Eina_Bool                elm_check_state_get(const Evas_Object *obj)
