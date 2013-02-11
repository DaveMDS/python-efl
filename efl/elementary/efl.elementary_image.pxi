# Copyright (c) 2008-2009 Simon Busch
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

cdef class Image(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_image_add(parent.obj))

    #def memfile_set(self, img, size, format, key):
        #return bool(elm_image_memfile_set(self.obj, img, size, _cfruni(format), _cfruni(key)))

    def file_set(self, filename, group = None):
        if group == None:
            elm_image_file_set(self.obj, _cfruni(filename), NULL)
        else:
            elm_image_file_set(self.obj, _cfruni(filename), _cfruni(group))

    def file_get(self):
        cdef const_char_ptr filename, group
        elm_image_file_get(self.obj, &filename, &group)
        return (_ctouni(filename), _ctouni(group))

    property file:
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            # TODO: check return value
            elm_image_file_set(self.obj, _cfruni(filename), _cfruni(group))

        def __get__(self):
            cdef const_char_ptr filename, group
            elm_image_file_get(self.obj, &filename, &group)
            return (_ctouni(filename), _ctouni(group))

    def smooth_set(self, smooth):
        elm_image_smooth_set(self.obj, smooth)

    def smooth_get(self):
        return bool(elm_image_smooth_get(self.obj))

    property smooth:
        def __get__(self):
            return bool(elm_image_smooth_get(self.obj))

        def __set__(self, smooth):
            elm_image_smooth_set(self.obj, smooth)

    def object_size_get(self):
        cdef int width, height
        elm_image_object_size_get(self.obj, &width, &height)
        return (width, height)

    property object_size:
        def __get__(self):
            cdef int width, height
            elm_image_object_size_get(self.obj, &width, &height)
            return (width, height)

    def no_scale_set(self, no_scale):
        elm_image_no_scale_set(self.obj, no_scale)

    def no_scale_get(self):
        return bool(elm_image_no_scale_get(self.obj))

    property no_scale:
        def __get__(self):
            return bool(elm_image_no_scale_get(self.obj))
        def __set__(self, no_scale):
            elm_image_no_scale_set(self.obj, no_scale)

    def resizable_set(self, size_up, size_down):
        elm_image_resizable_set(self.obj, size_up, size_down)

    def resizable_get(self):
        cdef Eina_Bool size_up, size_down
        elm_image_resizable_get(self.obj, &size_up, &size_down)
        return (size_up, size_down)

    property resizable:
        def __get__(self):
            cdef Eina_Bool size_up, size_down
            elm_image_resizable_get(self.obj, &size_up, &size_down)
            return (size_up, size_down)

        def __set__(self, value):
            size_up, size_down = value
            elm_image_resizable_set(self.obj, size_up, size_down)

    def fill_outside_set(self, fill_outside):
        elm_image_fill_outside_set(self.obj, fill_outside)

    def fill_outside_get(self):
        return bool(elm_image_fill_outside_get(self.obj))

    property fill_outside:
        def __get__(self):
            return bool(elm_image_fill_outside_get(self.obj))

        def __set__(self, fill_outside):
            elm_image_fill_outside_set(self.obj, fill_outside)

    def preload_disabled_set(self, disabled):
        elm_image_preload_disabled_set(self.obj, disabled)

    property preload_disabled:
        def __set__(self, disabled):
            elm_image_preload_disabled_set(self.obj, disabled)

    def prescale_set(self, size):
        elm_image_prescale_set(self.obj, size)

    def prescale_get(self):
        return elm_image_prescale_get(self.obj)

    property prescale:
        def __get__(self):
            return elm_image_prescale_get(self.obj)
        def __set__(self, size):
            elm_image_prescale_set(self.obj, size)

    def orient_set(self, orientation):
        elm_image_orient_set(self.obj, orientation)

    def orient_get(self):
        return elm_image_orient_get(self.obj)

    property orient:
        def __get__(self):
            return elm_image_orient_get(self.obj)
        def __set__(self, orientation):
            elm_image_orient_set(self.obj, orientation)

    def editable_set(self, editable):
        elm_image_editable_set(self.obj, editable)

    def editable_get(self):
        return bool(elm_image_editable_get(self.obj))

    property editable:
        def __get__(self):
            return bool(elm_image_editable_get(self.obj))
        def __set__(self, editable):
            elm_image_editable_set(self.obj, editable)

    def object_get(self):
        return object_from_instance(elm_image_object_get(self.obj))

    property object:
        def __get__(self):
            return object_from_instance(elm_image_object_get(self.obj))

    def aspect_fixed_set(self, fixed):
        elm_image_aspect_fixed_set(self.obj, fixed)

    def aspect_fixed_get(self):
        return bool(elm_image_aspect_fixed_get(self.obj))

    property aspect_fixed:
        def __get__(self):
            return bool(elm_image_aspect_fixed_get(self.obj))
        def __set__(self, fixed):
            elm_image_aspect_fixed_set(self.obj, fixed)

    def animated_available_get(self):
        return bool(elm_image_animated_available_get(self.obj))

    property animated_available:
        def __get__(self):
            return bool(elm_image_animated_available_get(self.obj))

    def animated_set(self, animated):
        elm_image_animated_set(self.obj, animated)

    def animated_get(self):
        return bool(elm_image_animated_get(self.obj))

    property animated:
        def __get__(self):
            return bool(elm_image_animated_get(self.obj))
        def __set__(self, animated):
            elm_image_animated_set(self.obj, animated)

    def animated_play_set(self, play):
        elm_image_animated_play_set(self.obj, play)

    def animated_play_get(self):
        return bool(elm_image_animated_play_get(self.obj))

    property animated_play:

        def __get__(self):
            return bool(elm_image_animated_play_get(self.obj))
        def __set__(self, play):
            elm_image_animated_play_set(self.obj, play)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_drop_add(self, func, *args, **kwargs):
        self._callback_add_full("drop", _cb_string_conv, func, *args, **kwargs)

    def callback_drop_del(self, func):
        self._callback_del_full("drop", _cb_string_conv, func)


_object_mapping_register("elm_image", Image)
