from efl.evas cimport Eina_Bool, Evas_Object
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_photo_add(Evas_Object *parent)
    Eina_Bool                elm_photo_file_set(Evas_Object *obj, const_char *file)
    void                     elm_photo_thumb_set(Evas_Object *obj, const_char *file, const_char *group)
    void                     elm_photo_size_set(Evas_Object *obj, int size)
    void                     elm_photo_fill_inside_set(Evas_Object *obj, Eina_Bool fill)
    void                     elm_photo_editable_set(Evas_Object *obj, Eina_Bool editable)
    void                     elm_photo_aspect_fixed_set(Evas_Object *obj, Eina_Bool fixed)
    Eina_Bool                elm_photo_aspect_fixed_get(Evas_Object *obj)
