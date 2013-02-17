from efl.evas cimport Eina_Bool, Evas_Object, Evas_Smart_Cb
from object_item cimport Elm_Object_Item, ObjectItem
from enums cimport Elm_Wrap_Type, Elm_Popup_Orient
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_popup_add(Evas_Object *parent)
    Elm_Object_Item         *elm_popup_item_append(Evas_Object *obj, const_char *label, Evas_Object *icon, Evas_Smart_Cb func, void *data)
    void                     elm_popup_content_text_wrap_type_set(Evas_Object *obj, Elm_Wrap_Type wrap)
    Elm_Wrap_Type            elm_popup_content_text_wrap_type_get(Evas_Object *obj)
    void                     elm_popup_orient_set(Evas_Object *obj, Elm_Popup_Orient orient)
    Elm_Popup_Orient         elm_popup_orient_get(Evas_Object *obj)
    void                     elm_popup_timeout_set(Evas_Object *obj, double timeout)
    double                   elm_popup_timeout_get(Evas_Object *obj)
    void                     elm_popup_allow_events_set(Evas_Object *obj, Eina_Bool allow)
    Eina_Bool                elm_popup_allow_events_get(Evas_Object *obj)
