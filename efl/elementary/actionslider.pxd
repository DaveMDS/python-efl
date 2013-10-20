from efl.evas cimport Evas_Object
from enums cimport Elm_Actionslider_Pos

cdef extern from "Elementary.h":
    Evas_Object             *elm_actionslider_add(Evas_Object *parent)
    char                    *elm_actionslider_selected_label_get(Evas_Object *obj)
    void                     elm_actionslider_indicator_pos_set(Evas_Object *obj, Elm_Actionslider_Pos pos)
    Elm_Actionslider_Pos     elm_actionslider_indicator_pos_get(Evas_Object *obj)
    void                     elm_actionslider_magnet_pos_set(Evas_Object *obj, Elm_Actionslider_Pos pos)
    Elm_Actionslider_Pos     elm_actionslider_magnet_pos_get(Evas_Object *obj)
    void                     elm_actionslider_enabled_pos_set(Evas_Object *obj, Elm_Actionslider_Pos pos)
    Elm_Actionslider_Pos     elm_actionslider_enabled_pos_get(Evas_Object *obj)
