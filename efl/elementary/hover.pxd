from efl.evas cimport Evas_Object
from layout_class cimport LayoutClass
from enums cimport Elm_Hover_Axis

cdef extern from "Elementary.h":
    Evas_Object             *elm_hover_add(Evas_Object *parent)
    void                     elm_hover_target_set(Evas_Object *obj, Evas_Object *target)
    Evas_Object             *elm_hover_target_get(Evas_Object *obj)
    void                     elm_hover_parent_set(Evas_Object *obj, Evas_Object *parent)
    Evas_Object             *elm_hover_parent_get(Evas_Object *obj)
    char                    *elm_hover_best_content_location_get(Evas_Object *obj, Elm_Hover_Axis pref_axis)
    void                     elm_hover_dismiss(Evas_Object *obj)

cdef class Hover(LayoutClass):
    pass
