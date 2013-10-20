from efl.evas cimport Eina_Bool, Evas_Object

cdef extern from "Elementary.h":
    Evas_Object             *elm_separator_add(Evas_Object *parent)
    void                     elm_separator_horizontal_set(Evas_Object *obj, Eina_Bool)
    Eina_Bool                elm_separator_horizontal_get(Evas_Object *obj)
