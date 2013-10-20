from efl.evas cimport Evas_Object, Eina_Bool
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object *   elm_layout_add(Evas_Object *parent)
    Eina_Bool       elm_layout_content_set(Evas_Object *obj, const_char *swallow, Evas_Object *content)
    Evas_Object *   elm_layout_content_get(Evas_Object *obj, const_char *swallow)
    Evas_Object *   elm_layout_content_unset(Evas_Object *obj, const_char *swallow)
    Eina_Bool       elm_layout_text_set(Evas_Object *obj, const_char *part, const_char *text)
    const_char *    elm_layout_text_get(Evas_Object *obj, const_char *part)
