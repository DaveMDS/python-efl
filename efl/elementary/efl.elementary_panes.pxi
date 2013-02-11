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

cdef class Panes(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_panes_add(parent.obj))

    property fixed:
        def __set__(self, fixed):
            elm_panes_fixed_set(self.obj, fixed)
        def __get__(self):
            return bool(elm_panes_fixed_get(self.obj))

    property content_left_size:
        def __get__(self):
            return elm_panes_content_left_size_get(self.obj)
        def __set__(self, size):
            elm_panes_content_left_size_set(self.obj, size)

    property content_right_size:
        def __get__(self):
            return elm_panes_content_right_size_get(self.obj)
        def __set__(self, size):
            elm_panes_content_right_size_set(self.obj, size)

    property horizontal:
        def __set__(self, horizontal):
            elm_panes_horizontal_set(self.obj, horizontal)
        def __get__(self):
            return bool(elm_panes_horizontal_get(self.obj))

    def callback_press_add(self, func, *args, **kwargs):
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_unpress_add(self, func, *args, **kwargs):
        self._callback_add("unpress", func, *args, **kwargs)

    def callback_unpress_del(self, func):
        self._callback_del("unpress", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)


_object_mapping_register("elm_panes", Panes)
