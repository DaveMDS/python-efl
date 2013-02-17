from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord
from enums cimport Elm_Wrap_Type

cdef extern from "Elementary.h":
    Evas_Object             *elm_label_add(Evas_Object *parent)
    void                     elm_label_line_wrap_set(Evas_Object *obj, Elm_Wrap_Type wrap)
    Elm_Wrap_Type            elm_label_line_wrap_get(Evas_Object *obj)
    void                     elm_label_wrap_width_set(Evas_Object *obj, Evas_Coord w)
    Evas_Coord               elm_label_wrap_width_get(Evas_Object *obj)
    void                     elm_label_ellipsis_set(Evas_Object *obj, Eina_Bool ellipsis)
    Eina_Bool                elm_label_ellipsis_get(Evas_Object *obj)
    void                     elm_label_slide_set(Evas_Object *obj, Eina_Bool slide)
    Eina_Bool                elm_label_slide_get(Evas_Object *obj)
    void                     elm_label_slide_duration_set(Evas_Object *obj, double duration)
    double                   elm_label_slide_duration_get(Evas_Object *obj)

