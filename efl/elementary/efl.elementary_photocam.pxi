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

from efl.evas cimport Image as evasImage

cdef class Photocam(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_photocam_add(parent.obj))

    property file:
        def __set__(self, file):
            elm_photocam_file_set(self.obj, _cfruni(file))
            #TODO: handle errors from return status
        def __get__(self):
            return _ctouni(elm_photocam_file_get(self.obj))

    property zoom:
        def __set__(self, zoom):
            elm_photocam_zoom_set(self.obj, zoom)
        def __get__(self):
            return elm_photocam_zoom_get(self.obj)

    property zoom_mode:
        def __set__(self, mode):
            elm_photocam_zoom_mode_set(self.obj, mode)
        def __get__(self):
            return elm_photocam_zoom_mode_get(self.obj)

    property image_size:
        def __get__(self):
            cdef int w, h
            elm_photocam_image_size_get(self.obj, &w, &h)
            return (w, h)

    property image_region:
        def __get__(self):
            cdef int x, y, w, h
            elm_photocam_image_region_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

    def image_region_show(self, x, y, w, h):
        elm_photocam_image_region_show(self.obj, x, y, w, h)

    def image_region_bring_in(self, x, y, w, h):
        elm_photocam_image_region_bring_in(self.obj, x, y, w, h)

    property paused:
        def __set__(self, paused):
            elm_photocam_paused_set(self.obj, paused)
        def __get__(self):
            return bool(elm_photocam_paused_get(self.obj))

    property internal_image:
        def __get__(self):
            cdef evasImage img = evasImage()
            cdef Evas_Object *obj = elm_photocam_internal_image_get(self.obj)
            img.obj = obj
            return img

    property bounce:
        def __set__(self, value):
            h_bounce, v_bounce = value
            elm_scroller_bounce_set(self.obj, h_bounce, v_bounce)
        def __get__(self):
            cdef Eina_Bool h_bounce, v_bounce
            elm_scroller_bounce_get(self.obj, &h_bounce, &v_bounce)
            return (h_bounce, v_bounce)

    property gesture_enabled:
        def __set__(self, gesture):
            elm_photocam_gesture_enabled_set(self.obj, gesture)
        def __get__(self):
            return bool(elm_photocam_gesture_enabled_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_press_add(self, func, *args, **kwargs):
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_load_add(self, func, *args, **kwargs):
        self._callback_add("load", func, *args, **kwargs)

    def callback_load_del(self, func):
        self._callback_del("load", func)

    def callback_loaded_add(self, func, *args, **kwargs):
        self._callback_add("loaded", func, *args, **kwargs)

    def callback_loaded_del(self, func):
        self._callback_del("loaded", func)

    def callback_load_detail_add(self, func, *args, **kwargs):
        self._callback_add("load,detail", func, *args, **kwargs)

    def callback_load_detail_del(self, func):
        self._callback_del("load,detail", func)

    def callback_loaded_detail_add(self, func, *args, **kwargs):
        self._callback_add("loaded,detail", func, *args, **kwargs)

    def callback_loaded_detail_del(self, func):
        self._callback_del("loaded,detail", func)

    def callback_zoom_start_add(self, func, *args, **kwargs):
        self._callback_add("zoom,start", func, *args, **kwargs)

    def callback_zoom_start_del(self, func):
        self._callback_del("zoom,start", func)

    def callback_zoom_stop_add(self, func, *args, **kwargs):
        self._callback_add("zoom,stop", func, *args, **kwargs)

    def callback_zoom_stop_del(self, func):
        self._callback_del("zoom,stop", func)

    def callback_zoom_change_add(self, func, *args, **kwargs):
        self._callback_add("zoom,change", func, *args, **kwargs)

    def callback_zoom_change_del(self, func):
        self._callback_del("zoom,change", func)

    def callback_scroll_add(self, func, *args, **kwargs):
        self._callback_add("scroll", func, *args, **kwargs)

    def callback_scroll_del(self, func):
        self._callback_del("scroll", func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,start", func, *args, **kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,stop", func, *args, **kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,start", func, *args, **kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,stop", func, *args, **kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)


_object_mapping_register("elm_photocam", Photocam)
