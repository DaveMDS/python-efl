from efl.evas cimport Eina_Bool, Evas_Object
from efl.evas.enums cimport Evas_Load_Error
from enums cimport Elm_Photocam_Zoom_Mode
from libc.string cimport const_char

cdef extern from "Elementary.h":
    ctypedef struct Elm_Photocam_Progress:
        double now
        double total

    ctypedef struct Elm_Photocam_Error:
        int status
        Eina_Bool open_error

    Evas_Object             *elm_photocam_add(Evas_Object *parent)
    Evas_Load_Error          elm_photocam_file_set(Evas_Object *obj, const_char *file)
    const_char *             elm_photocam_file_get(Evas_Object *obj)
    void                     elm_photocam_zoom_set(Evas_Object *obj, double zoom)
    double                   elm_photocam_zoom_get(Evas_Object *obj)
    void                     elm_photocam_zoom_mode_set(Evas_Object *obj, Elm_Photocam_Zoom_Mode mode)
    Elm_Photocam_Zoom_Mode   elm_photocam_zoom_mode_get(Evas_Object *obj)
    void                     elm_photocam_image_size_get(Evas_Object *obj, int *w, int *h)
    void                     elm_photocam_image_region_get(Evas_Object *obj, int *x, int *y, int *w, int *h)
    void                     elm_photocam_image_region_show(Evas_Object *obj, int x, int y, int w, int h)
    void                     elm_photocam_image_region_bring_in(Evas_Object *obj, int x, int y, int w, int h)
    void                     elm_photocam_paused_set(Evas_Object *obj, Eina_Bool paused)
    Eina_Bool                elm_photocam_paused_get(Evas_Object *obj)
    Evas_Object             *elm_photocam_internal_image_get(Evas_Object *obj)
    void                     elm_photocam_gesture_enabled_set(Evas_Object *obj, Eina_Bool gesture)
    Eina_Bool                elm_photocam_gesture_enabled_get(Evas_Object *obj)
