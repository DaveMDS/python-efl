from efl.evas cimport Eina_Bool, Evas_Object, Evas_Smart_Cb
from object_item cimport Elm_Object_Item
from enums cimport Elm_Ctxpopup_Direction
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_ctxpopup_add(Evas_Object *parent)
    void                     elm_ctxpopup_hover_parent_set(Evas_Object *obj, Evas_Object *parent)
    Evas_Object             *elm_ctxpopup_hover_parent_get(Evas_Object *obj)
    void                     elm_ctxpopup_clear(Evas_Object *obj)
    void                     elm_ctxpopup_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_ctxpopup_horizontal_get(Evas_Object *obj)
    Elm_Object_Item         *elm_ctxpopup_item_append(Evas_Object *obj, const_char *label, Evas_Object *icon, Evas_Smart_Cb func, void *data)
    void                     elm_ctxpopup_direction_priority_set(Evas_Object *obj, Elm_Ctxpopup_Direction first, Elm_Ctxpopup_Direction second, Elm_Ctxpopup_Direction third, Elm_Ctxpopup_Direction fourth)
    void                     elm_ctxpopup_direction_priority_get(Evas_Object *obj, Elm_Ctxpopup_Direction *first, Elm_Ctxpopup_Direction *second, Elm_Ctxpopup_Direction *third, Elm_Ctxpopup_Direction *fourth)
    Elm_Ctxpopup_Direction   elm_ctxpopup_direction_get(Evas_Object *obj)
    void                     elm_ctxpopup_dismiss(Evas_Object *obj)

