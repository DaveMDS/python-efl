# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

from efl cimport evas

cdef Evas_Event_Flags _gesture_layer_event_cb(void *data, void *event_info) with gil:
    (callback, args, kwargs) = <object>data
    try:
        ret = callback(args, kwargs)
        if ret is not None:
            return <Evas_Event_Flags>ret
        else:
            return evas.EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()


cdef class GestureLayer(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_gesture_layer_add(parent.obj))

    def cb_set(self, Elm_Gesture_Type idx, callback, Elm_Gesture_State cb_type, *args, **kwargs):
        cdef Elm_Gesture_Event_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _gesture_layer_event_cb

        data = (callback, args, kwargs)

        elm_gesture_layer_cb_set(   self.obj,
                                    idx,
                                    cb_type,
                                    cb,
                                    <void *>data)

    property hold_events:
        def __get__(self):
            return bool(elm_gesture_layer_hold_events_get(self.obj))

        def __set__(self, hold_events):
            elm_gesture_layer_hold_events_set(self.obj, hold_events)

    property zoom_step:
        def __set__(self, step):
            elm_gesture_layer_zoom_step_set(self.obj, step)

        def __get__(self):
            return elm_gesture_layer_zoom_step_get(self.obj)

    property rotate_step:
        def __set__(self, step):
            elm_gesture_layer_rotate_step_set(self.obj, step)

        def __get__(self):
            return elm_gesture_layer_rotate_step_get(self.obj)

    def attach(self, evasObject target):
        return bool(elm_gesture_layer_attach(self.obj, target.obj))


_object_mapping_register("elm_gesture_layer", GestureLayer)
