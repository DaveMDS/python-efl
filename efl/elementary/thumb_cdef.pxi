from efl.elementary.enums cimport Ethumb_Thumb_Aspect, Ethumb_Thumb_Format, \
    Ethumb_Thumb_Orientation, Ethumb_Thumb_FDO_Size, Elm_Thumb_Animation_Setting

cdef extern from "Elementary.h":
    Evas_Object             *elm_thumb_add(Evas_Object *parent)
    void                     elm_thumb_reload(Evas_Object *obj)
    void                     elm_thumb_file_set(Evas_Object *obj, const char *file, const char *key)
    void                     elm_thumb_file_get(const Evas_Object *obj, const char **file, const char **key)
    void                     elm_thumb_path_get(const Evas_Object *obj, const char **file, const char **key)
    void                     elm_thumb_aspect_set(Evas_Object *obj, Ethumb_Thumb_Aspect aspect)
    Ethumb_Thumb_Aspect      elm_thumb_aspect_get(const Evas_Object *obj)
    void                     elm_thumb_fdo_size_set(Evas_Object *obj, Ethumb_Thumb_FDO_Size size)
    Ethumb_Thumb_FDO_Size    elm_thumb_fdo_size_get(const Evas_Object *obj)
    void                     elm_thumb_format_set(Evas_Object *obj, Ethumb_Thumb_Format format)
    Ethumb_Thumb_Format      elm_thumb_format_get(const Evas_Object *obj)
    void                     elm_thumb_orientation_set(Evas_Object *obj, Ethumb_Thumb_Orientation orient)
    Ethumb_Thumb_Orientation elm_thumb_orientation_get(const Evas_Object *obj)
    void                     elm_thumb_size_set(Evas_Object *obj, int tw, int th)
    void                     elm_thumb_size_get(const Evas_Object *obj, int *tw, int *th)
    void                     elm_thumb_crop_align_set(Evas_Object *obj, double cropx, double cropy)
    void                     elm_thumb_crop_align_get(const Evas_Object *obj, double *cropx, double *cropy)
    void                     elm_thumb_compress_set(Evas_Object *obj, int compress)
    void                     elm_thumb_compress_get(const Evas_Object *obj, int *compress)
    void                     elm_thumb_quality_set(Evas_Object *obj, int quality)
    void                     elm_thumb_quality_get(const Evas_Object *obj, int *quality)
    void                     elm_thumb_animate_set(Evas_Object *obj, Elm_Thumb_Animation_Setting s)
    Elm_Thumb_Animation_Setting elm_thumb_animate_get(const Evas_Object *obj)
    void                    *elm_thumb_ethumb_client_get()
    Eina_Bool                elm_thumb_ethumb_client_connected_get()
    Eina_Bool                elm_thumb_editable_set(Evas_Object *obj, Eina_Bool edit)
    Eina_Bool                elm_thumb_editable_get(const Evas_Object *obj)
