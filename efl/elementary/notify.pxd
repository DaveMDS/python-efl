from efl.evas cimport Eina_Bool, Evas_Object
from enums cimport Elm_Notify_Orient

cdef extern from "Elementary.h":
    Evas_Object             *elm_notify_add(Evas_Object *parent)
    void                     elm_notify_parent_set(Evas_Object *obj, Evas_Object *parent)
    Evas_Object             *elm_notify_parent_get(Evas_Object *obj)
    void                     elm_notify_orient_set(Evas_Object *obj, int orient)
    int                      elm_notify_orient_get(Evas_Object *obj)
    void                     elm_notify_timeout_set(Evas_Object *obj, double timeout)
    double                   elm_notify_timeout_get(Evas_Object *obj)
    void                     elm_notify_allow_events_set(Evas_Object *obj, Eina_Bool repeat)
    Eina_Bool                elm_notify_allow_events_get(Evas_Object *obj)

