from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord, Evas_Event_Flags
from enums cimport Elm_Gesture_State, Elm_Gesture_Type

cdef extern from "Elementary.h":
    ctypedef struct Elm_Gesture_Taps_Info:
        Evas_Coord   x, y
        unsigned int n
        unsigned int timestamp

    ctypedef struct Elm_Gesture_Momentum_Info:
        Evas_Coord   x1
        Evas_Coord   y1
        Evas_Coord   x2
        Evas_Coord   y2

        unsigned int tx
        unsigned int ty

        Evas_Coord   mx
        Evas_Coord   my

        unsigned int n

    ctypedef struct _Elm_Gesture_Line_Info:
        Elm_Gesture_Momentum_Info momentum
        double                    angle

    ctypedef struct _Elm_Gesture_Zoom_Info:
        Evas_Coord x, y
        Evas_Coord radius
        double     zoom
        double     momentum

    ctypedef struct _Elm_Gesture_Rotate_Info:
        Evas_Coord x, y
        Evas_Coord radius
        double     base_angle
        double     angle
        double     momentum

    ctypedef Evas_Event_Flags (*Elm_Gesture_Event_Cb)(void *data, void *event_info)

    # Gesture layer
    void                     elm_gesture_layer_cb_set(Evas_Object *obj, Elm_Gesture_Type idx, Elm_Gesture_State cb_type, Elm_Gesture_Event_Cb cb, void *data)
    Eina_Bool                elm_gesture_layer_hold_events_get(Evas_Object *obj)
    void                     elm_gesture_layer_hold_events_set(Evas_Object *obj, Eina_Bool hold_events)
    void                     elm_gesture_layer_zoom_step_set(Evas_Object *obj, double step)
    double                   elm_gesture_layer_zoom_step_get(Evas_Object *obj)
    void                     elm_gesture_layer_rotate_step_set(Evas_Object *obj, double step)
    double                   elm_gesture_layer_rotate_step_get(Evas_Object *obj)
    Eina_Bool                elm_gesture_layer_attach(Evas_Object *obj, Evas_Object *target)
    Evas_Object             *elm_gesture_layer_add(Evas_Object *parent)

