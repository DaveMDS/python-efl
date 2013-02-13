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


cdef class Clock(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_clock_add(parent.obj))

    def time_set(self, hours, minutes, seconds):
        elm_clock_time_set(self.obj, hours, minutes, seconds)

    def time_get(self):
        cdef int hrs, min, sec

        elm_clock_time_get(self.obj, &hrs, &min, &sec)
        return (hrs, min, sec)

    property time:
        def __get__(self):
            cdef int hrs, min, sec
            elm_clock_time_get(self.obj, &hrs, &min, &sec)
            return (hrs, min, sec)

        def __set__(self, value):
            cdef int hrs, min, sec
            hrs, min, sec = value
            elm_clock_time_set(self.obj, hrs, min, sec)

    def edit_set(self, edit):
        elm_clock_edit_set(self.obj, edit)

    def edit_get(self, edit):
        return bool(elm_clock_edit_get(self.obj))

    property edit:
        def __get__(self):
            return bool(elm_clock_edit_get(self.obj))

        def __set__(self, edit):
            elm_clock_edit_set(self.obj, edit)

    def edit_mode_set(self, mode):
        elm_clock_edit_mode_set(self.obj, mode)

    def edit_mode_get(self):
        return elm_clock_edit_mode_get(self.obj)

    property edit_mode:
        def __get__(self):
            return elm_clock_edit_mode_get(self.obj)

        def __set__(self, mode):
            elm_clock_edit_mode_set(self.obj, mode)

    def show_am_pm_set(self, am_pm):
        elm_clock_show_am_pm_set(self.obj, am_pm)

    def show_am_pm_get(self):
        return elm_clock_show_am_pm_get(self.obj)

    property show_am_pm:
        def __get__(self):
            return elm_clock_show_am_pm_get(self.obj)

        def __set__(self, am_pm):
            elm_clock_show_am_pm_set(self.obj, am_pm)

    def show_seconds_set(self, seconds):
        elm_clock_show_seconds_set(self.obj, seconds)

    def show_seconds_get(self):
        return elm_clock_show_seconds_get(self.obj)

    property show_seconds:
        def __get__(self):
            return elm_clock_show_seconds_get(self.obj)

        def __set__(self, seconds):
            elm_clock_show_seconds_set(self.obj, seconds)

    def first_interval_set(self, interval):
        elm_clock_first_interval_set(self.obj, interval)

    def first_interval_get(self):
        return elm_clock_first_interval_get(self.obj)

    property first_interval:
        def __get__(self):
            return elm_clock_first_interval_get(self.obj)

        def __set__(self, interval):
            elm_clock_first_interval_set(self.obj, interval)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("elm_clock", Clock)
