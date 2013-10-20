from efl.evas cimport Eina_Bool, Evas_Object
from enums cimport Elm_Panel_Orient

cdef extern from "Elementary.h":
    Evas_Object             *elm_panel_add(Evas_Object *parent)
    void                     elm_panel_orient_set(Evas_Object *obj, Elm_Panel_Orient orient)
    Elm_Panel_Orient         elm_panel_orient_get(Evas_Object *obj)
    void                     elm_panel_hidden_set(Evas_Object *obj, Eina_Bool hidden)
    Eina_Bool                elm_panel_hidden_get(Evas_Object *obj)
    void                     elm_panel_toggle(Evas_Object *obj)
