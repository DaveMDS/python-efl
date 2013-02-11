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

cdef class Button(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_button_add(parent.obj))

    def autorepeat_set(self, on):
        elm_button_autorepeat_set(self.obj, on)

    def autorepeat_get(self):
        return bool(elm_button_autorepeat_get(self.obj))

    property autorepeat:
        def __get__(self):
            return bool(elm_button_autorepeat_get(self.obj))
        def __set__(self, on):
            elm_button_autorepeat_set(self.obj, on)

    def autorepeat_initial_timeout_set(self, t):
        elm_button_autorepeat_initial_timeout_set(self.obj, t)

    def autorepeat_initial_timeout_get(self):
        return elm_button_autorepeat_initial_timeout_get(self.obj)

    property autorepeat_initial_timeout:
        def __get__(self):
            return elm_button_autorepeat_initial_timeout_get(self.obj)
        def __set__(self, t):
            elm_button_autorepeat_initial_timeout_set(self.obj, t)

    def autorepeat_gap_timeout_set(self, t):
        elm_button_autorepeat_gap_timeout_set(self.obj, t)

    def autorepeat_gap_timeout_get(self):
        return elm_button_autorepeat_gap_timeout_get(self.obj)

    property autorepeat_gap_timeout:
        def __get__(self):
            return elm_button_autorepeat_gap_timeout_get(self.obj)
        def __set__(self, t):
            elm_button_autorepeat_gap_timeout_set(self.obj, t)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_repeated_add(self, func, *args, **kwargs):
        self._callback_add("repeated", func, *args, **kwargs)

    def callback_repeated_del(self, func):
        self._callback_del("repeated", func)

    def callback_pressed_add(self, func, *args, **kwargs):
        self._callback_add("pressed", func, *args, **kwargs)

    def callback_pressed_del(self, func):
        self._callback_del("pressed", func)

    def callback_unpressed_add(self, func, *args, **kwargs):
        self._callback_add("unpressed", func, *args, **kwargs)

    def callback_unpressed_del(self, func):
        self._callback_del("unpressed", func)


_object_mapping_register("elm_button", Button)
