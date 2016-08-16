from efl.elementary.enums cimport Elm_Image_Orient

cdef extern from "Elementary.h":
    ctypedef struct Elm_Image_Progress:
        double now
        double total

    ctypedef struct Elm_Image_Error:
        int status
        Eina_Bool open_error

    Evas_Object             *elm_image_add(Evas_Object *parent)
    Eina_Bool                elm_image_file_set(Evas_Object *obj, const char *file, const char *group)
    void                     elm_image_file_get(const Evas_Object *obj, const char **file, const char **group)
    void                     elm_image_prescale_set(Evas_Object *obj, int size)
    int                      elm_image_prescale_get(const Evas_Object *obj)
    # TODO: Eina_Bool                elm_image_mmap_set(Evas_Object *obj, const Eina_File *file, const char *group)
    void                     elm_image_smooth_set(Evas_Object *obj, Eina_Bool smooth)
    Eina_Bool                elm_image_smooth_get(const Evas_Object *obj)
    void                     elm_image_animated_play_set(Evas_Object *obj, Eina_Bool play)
    Eina_Bool                elm_image_animated_play_get(const Evas_Object *obj)
    void                     elm_image_animated_set(Evas_Object *obj, Eina_Bool animated)
    Eina_Bool                elm_image_animated_get(const Evas_Object *obj)
    Eina_Bool                elm_image_animated_available_get(const Evas_Object *obj)
    void                     elm_image_editable_set(Evas_Object *obj, Eina_Bool editable)
    Eina_Bool                elm_image_editable_get(const Evas_Object *obj)
    Eina_Bool                elm_image_memfile_set(Evas_Object *obj, const void *img, size_t size, const char *format, const char *key)
    void                     elm_image_fill_outside_set(Evas_Object *obj, Eina_Bool fill_outside)
    Eina_Bool                elm_image_fill_outside_get(const Evas_Object *obj)
    void                     elm_image_preload_disabled_set(Evas_Object *obj, Eina_Bool disabled)
    void                     elm_image_orient_set(Evas_Object *obj, Elm_Image_Orient orient)
    Elm_Image_Orient         elm_image_orient_get(const Evas_Object *obj)
    Evas_Object             *elm_image_object_get(const Evas_Object *obj)
    void                     elm_image_object_size_get(const Evas_Object *obj, int *w, int *h)
    void                     elm_image_resizable_set(Evas_Object *obj, Eina_Bool scale_up,Eina_Bool scale_down)
    void                     elm_image_resizable_get(const Evas_Object *obj, Eina_Bool *scale_up,Eina_Bool *scale_down)
    void                     elm_image_no_scale_set(Evas_Object *obj, Eina_Bool no_scale)
    Eina_Bool                elm_image_no_scale_get(const Evas_Object *obj)
    void                     elm_image_aspect_fixed_set(Evas_Object *obj, Eina_Bool fixed)
    Eina_Bool                elm_image_aspect_fixed_get(const Evas_Object *obj)
