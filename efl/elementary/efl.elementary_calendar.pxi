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

from datetime import date

cdef class CalendarMark(object):
    cdef Elm_Calendar_Mark *obj

    def __init__(self, evasObject cal, mark_type, mark_time, repeat):
        cdef tm time
        tmtup = mark_time.timetuple()
        time.tm_mday = tmtup.tm_mday
        time.tm_mon = tmtup.tm_mon - 1
        time.tm_year = tmtup.tm_year - 1900
        time.tm_wday = tmtup.tm_wday
        time.tm_yday = tmtup.tm_yday
        time.tm_isdst = tmtup.tm_isdst
        self.obj = elm_calendar_mark_add(cal.obj, _cfruni(mark_type), &time, repeat)

    def delete(self):
        elm_calendar_mark_del(self.obj)


cdef class Calendar(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_calendar_add(parent.obj))

    property weekdays_names:
        def __get__(self):
            cdef const_char_ptr *lst
            cdef const_char_ptr weekday
            ret = []
            lst = elm_calendar_weekdays_names_get(self.obj)
            for i from 0 <= i < 7:
                weekday = lst[i]
                if weekday != NULL:
                    ret.append(_ctouni(weekday))
            return ret

        def __set__(self, weekdays):
            cdef int i, day_len
            cdef char **days, *weekday
            days = <char **>PyMem_Malloc(7 * sizeof(char*))
            for i from 0 <= i < 7:
                weekday = _fruni(weekdays[i])
                day_len = len(weekday)
                days[i] = <char *>PyMem_Malloc(day_len + 1)
                memcpy(days[i], weekday, day_len + 1)
            elm_calendar_weekdays_names_set(self.obj, <const_char_ptr *>days)

    property min_max_year:
        def __get__(self):
            cdef int min, max
            elm_calendar_min_max_year_get(self.obj, &min, &max)
            return (min, max)
        def __set__(self, value):
            cdef int min, max
            min, max = value
            elm_calendar_min_max_year_set(self.obj, min, max)

    property select_mode:
        def __get__(self):
            return elm_calendar_select_mode_get(self.obj)
        def __set__(self, mode):
            elm_calendar_select_mode_set(self.obj, mode)

    property selected_time:
        def __get__(self):
            cdef tm time
            elm_calendar_selected_time_get(self.obj, &time)
            ret = date( time.tm_year + 1900,
                        time.tm_mon + 1,
                        time.tm_mday)
            return ret

        def __set__(self, selected_time):
            cdef tm time
            tmtup = selected_time.timetuple()
            time.tm_mday = tmtup.tm_mday
            time.tm_mon = tmtup.tm_mon - 1
            time.tm_year = tmtup.tm_year - 1900
            time.tm_wday = tmtup.tm_wday
            time.tm_yday = tmtup.tm_yday
            time.tm_isdst = tmtup.tm_isdst
            elm_calendar_selected_time_set(self.obj, &time)

    def format_function_set(self, format_func):
        pass
        #elm_calendar_format_function_set(self.obj, format_func)

    def mark_add(self, mark_type, mark_time, repeat):
        return CalendarMark(self, mark_type, mark_time, repeat)

    property marks:
        #def __get__(self):
            #const_Eina_List         *elm_calendar_marks_get(self.obj)
        #def __set__(self, value):
        def __del__(self):
            elm_calendar_marks_clear(self.obj)

    def marks_draw(self):
        elm_calendar_marks_draw(self.obj)

    property interval:
        def __get__(self):
            return elm_calendar_interval_get(self.obj)
        def __set__(self, interval):
            elm_calendar_interval_set(self.obj, interval)

    property first_day_of_week:
        def __get__(self):
            return elm_calendar_first_day_of_week_get(self.obj)
        def __set__(self, day):
            elm_calendar_first_day_of_week_set(self.obj, day)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("elm_calendar", Calendar)
