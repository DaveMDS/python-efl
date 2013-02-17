from efl.evas cimport Eina_Bool, Evas_Object
from enums cimport Elm_Thumb_Animation_Setting
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_thumb_add(Evas_Object *parent)
    void                     elm_thumb_reload(Evas_Object *obj)
    void                     elm_thumb_file_set(Evas_Object *obj, const_char *file, const_char *key)
    void                     elm_thumb_file_get(Evas_Object *obj, const_char **file, const_char **key)
    void                     elm_thumb_path_get(Evas_Object *obj, const_char **file, const_char **key)
    void                     elm_thumb_animate_set(Evas_Object *obj, Elm_Thumb_Animation_Setting s)
    Elm_Thumb_Animation_Setting elm_thumb_animate_get(Evas_Object *obj)
    void                    *elm_thumb_ethumb_client_get()
    Eina_Bool                elm_thumb_ethumb_client_connected_get()
    Eina_Bool                elm_thumb_editable_set(Evas_Object *obj, Eina_Bool edit)
    Eina_Bool                elm_thumb_editable_get(Evas_Object *obj)
