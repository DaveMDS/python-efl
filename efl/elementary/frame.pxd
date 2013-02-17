from efl.evas cimport Eina_Bool, Evas_Object

cdef extern from "Elementary.h":
    Evas_Object             *elm_frame_add(Evas_Object *parent)
    void                     elm_frame_autocollapse_set(Evas_Object *obj, Eina_Bool autocollapse)
    Eina_Bool                elm_frame_autocollapse_get(Evas_Object *obj)
    void                     elm_frame_collapse_set(Evas_Object *obj, Eina_Bool collapse)
    Eina_Bool                elm_frame_collapse_get(Evas_Object *obj)
    void                     elm_frame_collapse_go(Evas_Object *obj, Eina_Bool collapse)
