from efl.evas cimport Eina_Bool, Evas_Object

cdef extern from "Elementary.h":
    Evas_Object             *elm_panes_add(Evas_Object *parent)
    void                     elm_panes_fixed_set(Evas_Object *obj, Eina_Bool fixed)
    Eina_Bool                elm_panes_fixed_get(Evas_Object *obj)
    double                   elm_panes_content_left_size_get(Evas_Object *obj)
    void                     elm_panes_content_left_size_set(Evas_Object *obj, double size)
    double                   elm_panes_content_right_size_get(Evas_Object *obj)
    void                     elm_panes_content_right_size_set(Evas_Object *obj, double size)
    void                     elm_panes_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_panes_horizontal_get(Evas_Object *obj)
