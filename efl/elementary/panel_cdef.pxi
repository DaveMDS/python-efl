from efl.elementary.enums cimport Elm_Panel_Orient

cdef extern from "Elementary.h":
    Evas_Object             *elm_panel_add(Evas_Object *parent)
    void                     elm_panel_orient_set(Evas_Object *obj, Elm_Panel_Orient orient)
    Elm_Panel_Orient         elm_panel_orient_get(const Evas_Object *obj)
    void                     elm_panel_hidden_set(Evas_Object *obj, Eina_Bool hidden)
    Eina_Bool                elm_panel_hidden_get(const Evas_Object *obj)
    void                     elm_panel_toggle(Evas_Object *obj)
    void                     elm_panel_scrollable_set(Evas_Object *obj, Eina_Bool scrollable)
    Eina_Bool                elm_panel_scrollable_get(const Evas_Object *obj)
    void                     elm_panel_scrollable_content_size_set(Evas_Object *obj, double ratio)
