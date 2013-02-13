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


cdef class Spinner(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_spinner_add(parent.obj))

    def label_format_set(self, format):
        elm_spinner_label_format_set(self.obj, _cfruni(format))

    def label_format_get(self):
        return _ctouni(elm_spinner_label_format_get(self.obj))

    property label_format:
        def __get__(self):
            return _ctouni(elm_spinner_label_format_get(self.obj))

        def __set__(self, format):
            elm_spinner_label_format_set(self.obj, _cfruni(format))

    def min_max_set(self, min, max):
        elm_spinner_min_max_set(self.obj, min, max)

    def min_max_get(self):
        cdef double min, max
        elm_spinner_min_max_get(self.obj, &min, &max)
        return (min, max)

    property min_max:
        def __get__(self):
            cdef double min, max
            elm_spinner_min_max_get(self.obj, &min, &max)
            return (min, max)

        def __set__(self, value):
            min, max = value
            elm_spinner_min_max_set(self.obj, min, max)

    def step_set(self, step):
        elm_spinner_step_set(self.obj, step)

    def step_get(self):
        return elm_spinner_step_get(self.obj)

    property step:
        def __get__(self):
            return elm_spinner_step_get(self.obj)

        def __set__(self, step):
            elm_spinner_step_set(self.obj, step)

    def value_set(self, value):
        elm_spinner_value_set(self.obj, value)

    def value_get(self):
        return elm_spinner_value_get(self.obj)

    property value:
        def __get__(self):
            return elm_spinner_value_get(self.obj)
        def __set__(self, value):
            elm_spinner_value_set(self.obj, value)

    def wrap_set(self, wrap):
        elm_spinner_wrap_set(self.obj, wrap)

    def wrap_get(self):
        return elm_spinner_wrap_get(self.obj)

    property wrap:
        def __get__(self):
            return elm_spinner_wrap_get(self.obj)
        def __set__(self, wrap):
            elm_spinner_wrap_set(self.obj, wrap)

    def editable_set(self, editable):
        elm_spinner_editable_set(self.obj, editable)

    def editable_get(self):
        return elm_spinner_editable_get(self.obj)

    property editable:
        def __get__(self):
            return elm_spinner_editable_get(self.obj)
        def __set__(self, editable):
            elm_spinner_editable_set(self.obj, editable)

    def special_value_add(self, value, label):
        elm_spinner_special_value_add(self.obj, value, _cfruni(label))

    def interval_set(self, interval):
        elm_spinner_interval_set(self.obj, interval)

    def interval_get(self):
        return elm_spinner_interval_get(self.obj)

    property interval:
        def __get__(self):
            return elm_spinner_interval_get(self.obj)

        def __set__(self, interval):
            elm_spinner_interval_set(self.obj, interval)

    def base_set(self, base):
        elm_spinner_base_set(self.obj, base)

    def base_get(self):
        return elm_spinner_base_get(self.obj)

    property base:
        def __get__(self):
            return elm_spinner_base_get(self.obj)

        def __set__(self, base):
            elm_spinner_base_set(self.obj, base)

    def round_set(self, rnd):
        elm_spinner_round_set(self.obj, rnd)

    def round_get(self):
        return elm_spinner_round_get(self.obj)

    property round:
        def __get__(self):
            return elm_spinner_round_get(self.obj)

        def __set__(self, rnd):
            elm_spinner_round_set(self.obj, rnd)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        self._callback_add("delay,changed", func, *args, **kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del("delay,changed", func)


_object_mapping_register("elm_spinner", Spinner)
