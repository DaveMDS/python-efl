from efl.elementary.enums cimport Elm_Photocam_Zoom_Mode

cdef extern from "Elementary.h":
    ctypedef struct Elm_Photocam_Progress:
        double now
        double total

    ctypedef struct Elm_Photocam_Error:
        int status
        Eina_Bool open_error

    Evas_Object             *elm_photocam_add(Evas_Object *parent)
    Evas_Load_Error          elm_photocam_file_set(Evas_Object *obj, const char *file)
    const char *             elm_photocam_file_get(const Evas_Object *obj)
    void                     elm_photocam_zoom_set(Evas_Object *obj, double zoom)
    double                   elm_photocam_zoom_get(const Evas_Object *obj)
    void                     elm_photocam_zoom_mode_set(Evas_Object *obj, Elm_Photocam_Zoom_Mode mode)
    Elm_Photocam_Zoom_Mode   elm_photocam_zoom_mode_get(const Evas_Object *obj)
    void                     elm_photocam_image_size_get(const Evas_Object *obj, int *w, int *h)
    void                     elm_photocam_image_region_get(const Evas_Object *obj, int *x, int *y, int *w, int *h)
    void                     elm_photocam_image_region_show(Evas_Object *obj, int x, int y, int w, int h)
    void                     elm_photocam_image_region_bring_in(Evas_Object *obj, int x, int y, int w, int h)
    Evas_Image_Orient        elm_photocam_image_orient_get(const Evas_Object *obj)
    void                     elm_photocam_image_orient_set(const Evas_Object *obj, Evas_Image_Orient orient)
    void                     elm_photocam_paused_set(Evas_Object *obj, Eina_Bool paused)
    Eina_Bool                elm_photocam_paused_get(const Evas_Object *obj)
    Evas_Object             *elm_photocam_internal_image_get(const Evas_Object *obj)
    void                     elm_photocam_gesture_enabled_set(Evas_Object *obj, Eina_Bool gesture)
    Eina_Bool                elm_photocam_gesture_enabled_get(const Evas_Object *obj)
