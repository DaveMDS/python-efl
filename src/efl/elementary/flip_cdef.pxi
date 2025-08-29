from efl.elementary.enums cimport Elm_Flip_Direction, Elm_Flip_Interaction, \
    Elm_Flip_Mode

cdef extern from "Elementary.h":
    Evas_Object             *elm_flip_add(Evas_Object *parent)
    Eina_Bool                elm_flip_front_visible_get(const Evas_Object *obj)
    void                     elm_flip_perspective_set(Evas_Object *obj, Evas_Coord foc, Evas_Coord x, Evas_Coord y)
    void                     elm_flip_go(Evas_Object *obj, Elm_Flip_Mode mode)
    void                     elm_flip_go_to(Evas_Object *obj, Eina_Bool front, Elm_Flip_Mode mode)
    void                     elm_flip_interaction_set(Evas_Object *obj, Elm_Flip_Interaction mode)
    Elm_Flip_Interaction     elm_flip_interaction_get(const Evas_Object *obj)
    void                     elm_flip_interaction_direction_enabled_set(Evas_Object *obj, Elm_Flip_Direction dir, Eina_Bool enabled)
    Eina_Bool                elm_flip_interaction_direction_enabled_get(const Evas_Object *obj, Elm_Flip_Direction dir)
    void                     elm_flip_interaction_direction_hitsize_set(Evas_Object *obj, Elm_Flip_Direction dir, double hitsize)
    double                   elm_flip_interaction_direction_hitsize_get(const Evas_Object *obj, Elm_Flip_Direction dir)
