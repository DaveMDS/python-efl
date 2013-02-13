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


cdef class Progressbar(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_progressbar_add(parent.obj))

    def pulse_set(self, pulse):
        elm_progressbar_pulse_set(self.obj, pulse)

    def pulse_get(self):
        return elm_progressbar_pulse_get(self.obj)

    def pulse(self, state):
        elm_progressbar_pulse(self.obj, state)

    def value_set(self, value):
        elm_progressbar_value_set(self.obj, value)

    def value_get(self):
        return elm_progressbar_value_get(self.obj)

    property value:
        def __get__(self):
            return elm_progressbar_value_get(self.obj)

        def __set__(self, value):
            elm_progressbar_value_set(self.obj, value)

    def span_size_set(self, size):
        elm_progressbar_span_size_set(self.obj, size)

    def span_size_get(self):
        return elm_progressbar_span_size_get(self.obj)

    property span_size:
        def __get__(self):
            return elm_progressbar_span_size_get(self.obj)

        def __set__(self, size):
            elm_progressbar_span_size_set(self.obj, size)

    def unit_format_set(self, format):
        if format is None:
            elm_progressbar_unit_format_set(self.obj, NULL)
        else:
            elm_progressbar_unit_format_set(self.obj, _cfruni(format))

    def unit_format_get(self):
        return _ctouni(elm_progressbar_unit_format_get(self.obj))

    property unit_format:
        def __get__(self):
            return _ctouni(elm_progressbar_unit_format_get(self.obj))

        def __set__(self, format):
            if format is None:
                elm_progressbar_unit_format_set(self.obj, NULL)
            else:
                elm_progressbar_unit_format_set(self.obj, _cfruni(format))

    property unit_format_function:
        def __set__(self, func not None):
            pass
            #if not callable(func):
                #raise TypeError("func is not callable")
            #TODO: char * func(double value)
            #elm_progressbar_unit_format_function_set(self.obj, func, NULL)

    def horizontal_set(self, horizontal):
        elm_progressbar_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return bool(elm_progressbar_horizontal_get(self.obj))

    property horizontal:
        def __get__(self):
            return bool(elm_progressbar_horizontal_get(self.obj))

        def __set__(self, horizontal):
            elm_progressbar_horizontal_set(self.obj, horizontal)

    def inverted_set(self, inverted):
        elm_progressbar_inverted_set(self.obj, inverted)

    def inverted_get(self):
        return bool(elm_progressbar_inverted_get(self.obj))

    property inverted:
        def __get__(self):
            return bool(elm_progressbar_inverted_get(self.obj))

        def __set__(self, inverted):
            elm_progressbar_inverted_set(self.obj, inverted)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("elm_progressbar", Progressbar)
