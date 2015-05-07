cdef extern from "Elementary.h":
    Evas_Object             *elm_separator_add(Evas_Object *parent)
    void                     elm_separator_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_separator_horizontal_get(const Evas_Object *obj)
