from efl.evas cimport Eina_Bool, Eina_List, const_Eina_List, Evas_Object, Evas_Coord
from enums cimport Elm_Transit_Effect_Flip_Axis, Elm_Transit_Effect_Wipe_Dir, \
    Elm_Transit_Effect_Wipe_Type, Elm_Transit_Tween_Mode

cdef extern from "Elementary.h":

    ctypedef struct Elm_Transit
    ctypedef struct Elm_Transit_Effect

    ctypedef void            (*Elm_Transit_Effect_Transition_Cb)(Elm_Transit_Effect *effect, Elm_Transit *transit, double progress)
    ctypedef void            (*Elm_Transit_Effect_End_Cb)   (Elm_Transit_Effect *effect, Elm_Transit *transit)
    ctypedef void            (*Elm_Transit_Del_Cb)          (void *data, Elm_Transit *transit)

    Elm_Transit             *elm_transit_add()
    void                     elm_transit_del(Elm_Transit *transit)
    void                     elm_transit_effect_add(Elm_Transit *transit, Elm_Transit_Effect_Transition_Cb transition_cb, Elm_Transit_Effect *effect, Elm_Transit_Effect_End_Cb end_cb)
    void                     elm_transit_effect_del(Elm_Transit *transit, Elm_Transit_Effect_Transition_Cb transition_cb, Elm_Transit_Effect *effect)
    void                     elm_transit_object_add(Elm_Transit *transit, Evas_Object *obj)
    void                     elm_transit_object_remove(Elm_Transit *transit, Evas_Object *obj)
    const_Eina_List         *elm_transit_objects_get(Elm_Transit *transit)
    void                     elm_transit_objects_final_state_keep_set(Elm_Transit *transit, Eina_Bool state_keep)
    Eina_Bool                elm_transit_objects_final_state_keep_get(Elm_Transit *transit)
    void                     elm_transit_event_enabled_set(Elm_Transit *transit, Eina_Bool enabled)
    Eina_Bool                elm_transit_event_enabled_get(Elm_Transit *transit)
    void                     elm_transit_del_cb_set(Elm_Transit *transit, Elm_Transit_Del_Cb cb, void *data)
    void                     elm_transit_auto_reverse_set(Elm_Transit *transit, Eina_Bool reverse)
    Eina_Bool                elm_transit_auto_reverse_get(Elm_Transit *transit)
    void                     elm_transit_repeat_times_set(Elm_Transit *transit, int repeat)
    int                      elm_transit_repeat_times_get(Elm_Transit *transit)
    void                     elm_transit_tween_mode_set(Elm_Transit *transit, Elm_Transit_Tween_Mode tween_mode)
    Elm_Transit_Tween_Mode   elm_transit_tween_mode_get(Elm_Transit *transit)
    void                     elm_transit_duration_set(Elm_Transit *transit, double duration)
    double                   elm_transit_duration_get(Elm_Transit *transit)
    void                     elm_transit_go(Elm_Transit *transit)
    void                     elm_transit_paused_set(Elm_Transit *transit, Eina_Bool paused)
    Eina_Bool                elm_transit_paused_get(Elm_Transit *transit)
    double                   elm_transit_progress_value_get(Elm_Transit *transit)
    void                     elm_transit_chain_transit_add(Elm_Transit *transit, Elm_Transit *chain_transit)
    void                     elm_transit_chain_transit_del(Elm_Transit *transit, Elm_Transit *chain_transit)
    Eina_List               *elm_transit_chain_transits_get(Elm_Transit *transit)
    Elm_Transit_Effect      *elm_transit_effect_resizing_add(Elm_Transit *transit, Evas_Coord from_w, Evas_Coord from_h, Evas_Coord to_w, Evas_Coord to_h)
    Elm_Transit_Effect      *elm_transit_effect_translation_add(Elm_Transit *transit, Evas_Coord from_dx, Evas_Coord from_dy, Evas_Coord to_dx, Evas_Coord to_dy)
    Elm_Transit_Effect      *elm_transit_effect_zoom_add(Elm_Transit *transit, float from_rate, float to_rate)
    Elm_Transit_Effect      *elm_transit_effect_flip_add(Elm_Transit *transit, Elm_Transit_Effect_Flip_Axis axis, Eina_Bool cw)
    Elm_Transit_Effect      *elm_transit_effect_resizable_flip_add(Elm_Transit *transit, Elm_Transit_Effect_Flip_Axis axis, Eina_Bool cw)
    Elm_Transit_Effect      *elm_transit_effect_wipe_add(Elm_Transit *transit, Elm_Transit_Effect_Wipe_Type type, Elm_Transit_Effect_Wipe_Dir dir)
    Elm_Transit_Effect      *elm_transit_effect_color_add(Elm_Transit *transit, unsigned int from_r, unsigned int from_g, unsigned int from_b, unsigned int from_a, unsigned int to_r, unsigned int to_g, unsigned int to_b, unsigned int to_a)
    Elm_Transit_Effect      *elm_transit_effect_fade_add(Elm_Transit *transit)
    Elm_Transit_Effect      *elm_transit_effect_blend_add(Elm_Transit *transit)
    Elm_Transit_Effect      *elm_transit_effect_rotation_add(Elm_Transit *transit, float from_degree, float to_degree)
    Elm_Transit_Effect      *elm_transit_effect_image_animation_add(Elm_Transit *transit, Eina_List *images)

