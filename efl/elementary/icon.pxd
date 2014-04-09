from efl.evas cimport Eina_Bool, Evas_Object
from image cimport Image
from enums cimport Elm_Icon_Lookup_Order, Elm_Icon_Type

cdef extern from "Elementary.h":
    Evas_Object *           elm_icon_add(Evas_Object *parent)
    void                    elm_icon_thumb_set(Evas_Object *obj, const char *file, const char *group)
    Eina_Bool               elm_icon_standard_set(Evas_Object *obj, const char *name)
    const char *            elm_icon_standard_get(const Evas_Object *obj)
    void                    elm_icon_order_lookup_set(Evas_Object *obj, Elm_Icon_Lookup_Order order)
    Elm_Icon_Lookup_Order   elm_icon_order_lookup_get(const Evas_Object *obj)

