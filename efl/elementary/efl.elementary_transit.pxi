# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.


cdef class Transit(object):

    cdef Elm_Transit* obj

    def __cinit__(self, *a, **ka):
        self.obj = NULL

    def __init__(self):
        self.obj = elm_transit_add()

    def delete(self):
        elm_transit_del(self.obj)

    #def effect_add(self, Elm_Transit_Effect_Transition_Cb transition_cb, effect, Elm_Transit_Effect_End_Cb end_cb):
        #elm_transit_effect_add(self.obj, transition_cb, effect, end_cb)

    #def effect_del(self, Elm_Transit_Effect_Transition_Cb transition_cb, effect):
        #elm_transit_effect_del(self.obj, transition_cb, effect)

    def object_add(self, evasObject obj):
        elm_transit_object_add(self.obj, obj.obj)

    def object_remove(self, evasObject obj):
        elm_transit_object_remove(self.obj, obj.obj)

    property objects:
        def __get__(self):
            return _object_list_to_python(elm_transit_objects_get(self.obj))

    property objects_final_state_keep:
        def __set__(self, state_keep):
            elm_transit_objects_final_state_keep_set(self.obj, state_keep)

        def __get__(self):
            return bool(elm_transit_objects_final_state_keep_get(self.obj))

    property event_enabled:
        def __set__(self, enabled):
            elm_transit_event_enabled_set(self.obj, enabled)
        def __get__(self):
            return bool(elm_transit_event_enabled_get(self.obj))

    def del_cb_set(self, cb, *args, **kwargs):
        pass
        #elm_transit_del_cb_set(self.obj, cb, data)

    property auto_reverse:
        def __set__(self, reverse):
            elm_transit_auto_reverse_set(self.obj, reverse)
        def __get__(self):
            return bool(elm_transit_auto_reverse_get(self.obj))

    property repeat_times:
        def __set__(self, repeat):
            elm_transit_repeat_times_set(self.obj, repeat)
        def __get__(self):
            return elm_transit_repeat_times_get(self.obj)

    property tween_mode:
        def __set__(self, tween_mode):
            elm_transit_tween_mode_set(self.obj, tween_mode)
        def __get__(self):
            return elm_transit_tween_mode_get(self.obj)

    property duration:
        def __set__(self, duration):
            elm_transit_duration_set(self.obj, duration)
        def __get__(self):
            return elm_transit_duration_get(self.obj)

    def go(self):
        elm_transit_go(self.obj)

    property paused:
        def __set__(self, paused):
            elm_transit_paused_set(self.obj, paused)
        def __get__(self):
            return bool(elm_transit_paused_get(self.obj))

    property progress_value:
        def __get__(self):
            return elm_transit_progress_value_get(self.obj)

    def chain_transit_add(self, Transit chain_transit):
        elm_transit_chain_transit_add(self.obj, chain_transit.obj)

    def chain_transit_del(self, Transit chain_transit):
        elm_transit_chain_transit_del(self.obj, chain_transit.obj)

    property chain_transits:
        def __get__(self):
            return _object_list_to_python(elm_transit_chain_transits_get(self.obj))

    def effect_resizing_add(self, Evas_Coord from_w, Evas_Coord from_h, Evas_Coord to_w, Evas_Coord to_h):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_resizing_add(self.obj, from_w, from_h, to_w, to_h)

    def effect_translation_add(self, Evas_Coord from_dx, Evas_Coord from_dy, Evas_Coord to_dx, Evas_Coord to_dy):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_translation_add(self.obj, from_dx, from_dy, to_dx, to_dy)

    def effect_zoom_add(self, float from_rate, float to_rate):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_zoom_add(self.obj, from_rate, to_rate)

    def effect_flip_add(self, Elm_Transit_Effect_Flip_Axis axis, Eina_Bool cw):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_flip_add(self.obj, axis, cw)

    def effect_resizable_flip_add(self, Elm_Transit_Effect_Flip_Axis axis, Eina_Bool cw):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_resizable_flip_add(self.obj, axis, cw)

    def effect_wipe_add(self, Elm_Transit_Effect_Wipe_Type type, Elm_Transit_Effect_Wipe_Dir dir):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_wipe_add(self.obj, type, dir)

    def effect_color_add(self, unsigned int from_r, unsigned int from_g, unsigned int from_b, unsigned int from_a, unsigned int to_r, unsigned int to_g, unsigned int to_b, unsigned int to_a):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_color_add(self.obj, from_r, from_g, from_b, from_a, to_r, to_g, to_b, to_a)

    def effect_fade_add(self):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_fade_add(self.obj)

    def effect_blend_add(self):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_blend_add(self.obj)

    def effect_rotation_add(self, float from_degree, float to_degree):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_rotation_add(self.obj, from_degree, to_degree)

    def effect_image_animation_add(self, images):
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_image_animation_add(self.obj, _strings_from_python(images))
