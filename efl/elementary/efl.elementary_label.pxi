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


cdef class Label(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_label_add(parent.obj))

    def line_wrap_set(self, Elm_Wrap_Type wrap):
        elm_label_line_wrap_set(self.obj, wrap)

    def line_wrap_get(self):
        return elm_label_line_wrap_get(self.obj)

    property line_wrap:
        def __get__(self):
            return elm_label_line_wrap_get(self.obj)
        def __set__(self, wrap):
            elm_label_line_wrap_set(self.obj, wrap)

    def wrap_width_set(self, int w):
        elm_label_wrap_width_set(self.obj, w)

    def wrap_width_get(self):
        return elm_label_wrap_width_get(self.obj)

    property wrap_width:
        def __get__(self):
            return elm_label_wrap_width_get(self.obj)
        def __set__(self, w):
            elm_label_wrap_width_set(self.obj, w)

    def ellipsis_set(self, bool ellipsis):
        elm_label_ellipsis_set(self.obj, ellipsis)

    def ellipsis_get(self):
        return elm_label_ellipsis_get(self.obj)

    property ellipsis:
        def __get__(self):
            return elm_label_ellipsis_get(self.obj)
        def __set__(self, ellipsis):
            elm_label_ellipsis_set(self.obj, ellipsis)

    def slide_set(self, bool slide):
        elm_label_slide_set(self.obj, slide)

    def slide_get(self):
        return elm_label_slide_get(self.obj)

    property slide:
        def __get__(self):
            return elm_label_slide_get(self.obj)
        def __set__(self, slide):
            elm_label_slide_set(self.obj, slide)

    def slide_duration_set(self, duration):
        elm_label_slide_duration_set(self.obj, duration)

    def slide_duration_get(self):
        return elm_label_slide_duration_get(self.obj)

    property slide_duration:
        def __get__(self):
            return elm_label_slide_duration_get(self.obj)
        def __set__(self, duration):
            elm_label_slide_duration_set(self.obj, duration)

    def callback_language_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_label", Label)
