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

from datetime import datetime


cdef class Datetime(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_datetime_add(parent.obj))

    property format:
        def __get__(self):
            return _ctouni(elm_datetime_format_get(self.obj))
        def __set__(self, fmt):
            elm_datetime_format_set(self.obj, _cfruni(fmt))

    property value_max:
        def __get__(self):
            cdef tm time
            elm_datetime_value_max_get(self.obj, &time)
            ret = datetime( time.tm_year + 1900,
                            time.tm_mon + 1,
                            time.tm_mday,
                            time.tm_hour,
                            time.tm_min,
                            time.tm_sec)
            return ret

        def __set__(self, newtime):
            cdef tm time
            tmtup = newtime.timetuple()
            time.tm_sec = tmtup.tm_sec
            time.tm_min = tmtup.tm_min
            time.tm_hour = tmtup.tm_hour
            time.tm_mday = tmtup.tm_mday
            time.tm_mon = tmtup.tm_mon - 1
            time.tm_year = tmtup.tm_year - 1900
            time.tm_wday = tmtup.tm_wday
            time.tm_yday = tmtup.tm_yday
            time.tm_isdst = tmtup.tm_isdst
            elm_datetime_value_max_set(self.obj, &time)

    property value_min:
        def __get__(self):
            cdef tm time
            elm_datetime_value_min_get(self.obj, &time)
            ret = datetime( time.tm_year + 1900,
                            time.tm_mon + 1,
                            time.tm_mday,
                            time.tm_hour,
                            time.tm_min,
                            time.tm_sec)
            return ret

        def __set__(self, newtime):
            cdef tm time
            tmtup = newtime.timetuple()
            time.tm_sec = tmtup.tm_sec
            time.tm_min = tmtup.tm_min
            time.tm_hour = tmtup.tm_hour
            time.tm_mday = tmtup.tm_mday
            time.tm_mon = tmtup.tm_mon - 1
            time.tm_year = tmtup.tm_year - 1900
            time.tm_wday = tmtup.tm_wday
            time.tm_yday = tmtup.tm_yday
            time.tm_isdst = tmtup.tm_isdst
            elm_datetime_value_min_set(self.obj, &time)

    property field_limit:
        def __get__(self):
            cdef int min, max
            cdef Elm_Datetime_Field_Type fieldtype = ELM_DATETIME_YEAR
            elm_datetime_field_limit_get(self.obj, fieldtype, &min, &max)
            return (fieldtype, min, max)

        def __set__(self, value):
            cdef int min, max
            cdef Elm_Datetime_Field_Type fieldtype
            min, max, fieldtype = value
            elm_datetime_field_limit_set(self.obj, fieldtype, min, max)

    property value:
        def __get__(self):
            cdef tm time
            elm_datetime_value_get(self.obj, &time)
            ret = datetime( time.tm_year + 1900,
                            time.tm_mon + 1,
                            time.tm_mday,
                            time.tm_hour,
                            time.tm_min,
                            time.tm_sec)
            return ret

        def __set__(self, newtime):
            cdef tm time
            tmtup = newtime.timetuple()
            time.tm_sec = tmtup.tm_sec
            time.tm_min = tmtup.tm_min
            time.tm_hour = tmtup.tm_hour
            time.tm_mday = tmtup.tm_mday
            time.tm_mon = tmtup.tm_mon - 1
            time.tm_year = tmtup.tm_year - 1900
            time.tm_wday = tmtup.tm_wday
            time.tm_yday = tmtup.tm_yday
            time.tm_isdst = tmtup.tm_isdst
            elm_datetime_value_set(self.obj, &time)

    def field_visible_get(self, fieldtype):
        return bool(elm_datetime_field_visible_get(self.obj, fieldtype))

    def field_visible_set(self, fieldtype, visible):
        elm_datetime_field_visible_set(self.obj, fieldtype, visible)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_languge_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_datetime", Datetime)
