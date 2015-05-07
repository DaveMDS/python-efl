cdef extern from "Elementary.h":

    cpdef enum Elm_Thumb_Animation_Setting:
        ELM_THUMB_ANIMATION_START
        ELM_THUMB_ANIMATION_LOOP
        ELM_THUMB_ANIMATION_STOP
        ELM_THUMB_ANIMATION_LAST
    ctypedef enum Elm_Thumb_Animation_Setting:
        pass

    cpdef enum Ethumb_Thumb_FDO_Size:
        ETHUMB_THUMB_NORMAL
        ETHUMB_THUMB_LARGE
    ctypedef enum Ethumb_Thumb_FDO_Size:
        pass

    cpdef enum Ethumb_Thumb_Format:
        ETHUMB_THUMB_FDO
        ETHUMB_THUMB_JPEG
        ETHUMB_THUMB_EET
    ctypedef enum Ethumb_Thumb_Format:
        pass

    cpdef enum Ethumb_Thumb_Aspect:
        ETHUMB_THUMB_KEEP_ASPECT
        ETHUMB_THUMB_IGNORE_ASPECT
        ETHUMB_THUMB_CROP
    ctypedef enum Ethumb_Thumb_Aspect:
        pass

    cpdef enum Ethumb_Thumb_Orientation:
        ETHUMB_THUMB_ORIENT_NONE
        ETHUMB_THUMB_ROTATE_90_CW
        ETHUMB_THUMB_ROTATE_180
        ETHUMB_THUMB_ROTATE_90_CCW
        ETHUMB_THUMB_FLIP_HORIZONTAL
        ETHUMB_THUMB_FLIP_VERTICAL
        ETHUMB_THUMB_FLIP_TRANSPOSE
        ETHUMB_THUMB_FLIP_TRANSVERSE
        ETHUMB_THUMB_ORIENT_ORIGINAL
    ctypedef enum Ethumb_Thumb_Orientation:
        pass


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
