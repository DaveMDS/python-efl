from efl.evas cimport Eina_Bool, Evas_Object
from image cimport Image
from enums cimport Elm_Icon_Lookup_Order, Elm_Icon_Type
from libc.string cimport const_char

cdef extern from "Elementary.h":

    # Icon                  (api:DONE  cb:DONE  test:DONE  doc:DONE  py3:DONE)
    Evas_Object *           elm_icon_add(Evas_Object *parent)
    void                    elm_icon_thumb_set(Evas_Object *obj, const_char *file, const_char *group)
    Eina_Bool               elm_icon_standard_set(Evas_Object *obj, const_char *name)
    const_char *            elm_icon_standard_get(Evas_Object *obj)
    void                    elm_icon_order_lookup_set(Evas_Object *obj, Elm_Icon_Lookup_Order order)
    Elm_Icon_Lookup_Order   elm_icon_order_lookup_get(Evas_Object *obj)

