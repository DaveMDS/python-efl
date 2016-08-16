from efl.elementary.enums cimport Elm_Bubble_Pos

cdef extern from "Elementary.h":
    Evas_Object             *elm_bubble_add(Evas_Object *parent)
    void                     elm_bubble_pos_set(Evas_Object *obj, Elm_Bubble_Pos pos)
    Elm_Bubble_Pos           elm_bubble_pos_get(const Evas_Object *obj)
