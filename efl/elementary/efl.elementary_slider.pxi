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


cdef class Slider(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_slider_add(parent.obj))

    def span_size_set(self, size):
        elm_slider_span_size_set(self.obj, size)

    def span_size_get(self):
        return elm_slider_span_size_get(self.obj)

    property span_size:
        def __get__(self):
            return elm_slider_span_size_get(self.obj)

        def __set__(self, size):
            elm_slider_span_size_set(self.obj, size)

    def unit_format_set(self, format):
        elm_slider_unit_format_set(self.obj, _cfruni(format))

    def unit_format_get(self):
        return _ctouni(elm_slider_unit_format_get(self.obj))

    property unit_format:
        def __get__(self):
            return _ctouni(elm_slider_unit_format_get(self.obj))

        def __set__(self, format):
            elm_slider_unit_format_set(self.obj, _cfruni(format))

    def indicator_format_set(self, format):
        elm_slider_indicator_format_set(self.obj, _cfruni(format))

    def indicator_format_get(self):
        return _ctouni(elm_slider_indicator_format_get(self.obj))

    property indicator_format:
        def __get__(self):
            return _ctouni(elm_slider_indicator_format_get(self.obj))

        def __set__(self, format):
            elm_slider_indicator_format_set(self.obj, _cfruni(format))

    #TODO: def indicator_format_function_set(self, func, free_func)
#~         """Set the format function pointer for the indicator label
#~
#~         Set the callback function to format the indicator string.
#~
#~         @see: L{indicator_format_set()} for more info on how this works.
#~
#~         @param func: The indicator format function.
#~         @type func: function
#~         @param free_func: The freeing function for the format string.
#~         @type free_func: function
#~
#~         """
        #elm_slider_indicator_format_function_set(self.obj, char(*func)(double val), void (*free_func)(charstr))

    #TODO: def units_format_function_set(self, func, free_func)
#~         """Set the format function pointer for the units label
#~
#~         Set the callback function to format the units string.
#~
#~         @see: L{units_format_set() for more info on how this works.
#~
#~         @param func: The units format function.
#~         @type func: function
#~         @param free_func: The freeing function for the format string.
#~         @type free_func: function
#~
#~         """
        #elm_slider_units_format_function_set(self.obj, char(*func)(double val), void (*free_func)(charstr))

    def horizontal_set(self, horizontal):
        elm_slider_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return bool(elm_slider_horizontal_get(self.obj))

    property horizontal:
        def __get__(self):
            return bool(elm_slider_horizontal_get(self.obj))
        def __set__(self, horizontal):
            elm_slider_horizontal_set(self.obj, horizontal)

    def min_max_set(self, min, max):
        elm_slider_min_max_set(self.obj, min, max)

    def min_max_get(self):
        cdef double min, max
        elm_slider_min_max_get(self.obj, &min, &max)
        return (min, max)

    property min_max:
        def __get__(self):
            cdef double min, max
            elm_slider_min_max_get(self.obj, &min, &max)
            return (min, max)

        def __set__(self, value):
            min, max = value
            elm_slider_min_max_set(self.obj, min, max)

    def value_set(self, value):
        elm_slider_value_set(self.obj, value)

    def value_get(self):
        return elm_slider_value_get(self.obj)

    property value:
        def __get__(self):
            return elm_slider_value_get(self.obj)
        def __set__(self, value):
            elm_slider_value_set(self.obj, value)

    def inverted_set(self, inverted):
        elm_slider_inverted_set(self.obj, inverted)

    def inverted_get(self):
        return bool(elm_slider_inverted_get(self.obj))

    property inverted:
        def __get__(self):
            return bool(elm_slider_inverted_get(self.obj))

        def __set__(self, inverted):
            elm_slider_inverted_set(self.obj, inverted)

    def indicator_show_set(self, show):
        elm_slider_indicator_show_set(self.obj, show)

    def indicator_show_get(self):
        return bool(elm_slider_indicator_show_get(self.obj))

    property indicator_show:
        def __get__(self):
            return bool(elm_slider_indicator_show_get(self.obj))

        def __set__(self, show):
            elm_slider_indicator_show_set(self.obj, show)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_slider_drag_start_add(self, func, *args, **kwargs):
        self._callback_add("slider,drag,start", func, *args, **kwargs)

    def callback_slider_drag_start_del(self, func):
        self._callback_del("slider,drag,start", func)

    def callback_slider_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add("slider,drag,stop", func, *args, **kwargs)

    def callback_slider_drag_stop_del(self, func):
        self._callback_del("slider,drag,stop", func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        self._callback_add("delay,changed", func, *args, **kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del("delay,changed", func)


_object_mapping_register("elm_slider", Slider)
