# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
#

include "datetime_cdef.pxi"

cdef class Datetime(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Datetime(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_datetime_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property format:
        """The datetime format. Format is a combination of allowed Libc date format
        specifiers like: "%b %d, %Y %I : %M %p".

        Maximum allowed format length is 64 chars.

        Format can include separators for each individual datetime field except
        for AM/PM field.

        Each separator can be a maximum of 6 UTF-8 bytes.
        Space is also taken as a separator.

        Following are the allowed set of format specifiers for each datetime field.

        **%%Y** The year as a decimal number including the century.

        **%%y** The year as a decimal number without a century (range 00 to 99).

        **%%m** The month as a decimal number (range 01 to 12).

        **%%b** The abbreviated month name according to the current locale.

        **%%B** The full month name according to the current locale.

        **%%h** The abbreviated month name according to the current locale(same as %%b).

        **%%d** The day of the month as a decimal number (range 01 to 31).

        **%%e** The day of the month as a decimal number (range 1 to 31). single
                digits are preceded by a blank.

        **%%I** The hour as a decimal number using a 12-hour clock (range 01 to 12).

        **%%H** The hour as a decimal number using a 24-hour clock (range 00 to 23).

        **%%k** The hour (24-hour clock) as a decimal number (range 0 to 23). single
                digits are preceded by a blank.

        **%%l** The hour (12-hour clock) as a decimal number (range 1 to 12); single
                digits are preceded by a blank.

        **%%M** The minute as a decimal number (range 00 to 59).

        **%%p** Either 'AM' or 'PM' according to the given time value, or the
                corresponding strings for the current locale. Noon is treated as 'PM'
                and midnight as 'AM'.

        **%%P** Like %p but in lower case: 'am' or 'pm' or a corresponding string for
                the current locale.

        **%%c** The preferred date and time representation for the current locale.

        **%%x** The preferred date representation for the current locale without the time.

        **%%X** The preferred time representation for the current locale without the date.

        **%%r** The complete calendar time using the AM/PM format of the current locale.

        **%%R** The hour and minute in decimal numbers using the format %H:%M.

        **%%T** The time of day in decimal numbers using the format %H:%M:%S.

        **%%D** The date using the format %%m/%%d/%%y.

        **%%F** The date using the format %%Y-%%m-%%d.

        These specifiers can be arranged in any order and the widget will display the
        fields accordingly.

        Default format is taken as per the system locale settings.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_datetime_format_get(self.obj))
        def __set__(self, fmt):
            if isinstance(fmt, unicode): fmt = PyUnicode_AsUTF8String(fmt)
            elm_datetime_format_set(self.obj,
                <const char *>fmt if fmt is not None else NULL)

    property value_max:
        """The upper boundary of a field.

        Year: years since 1900. Negative value represents year below 1900 (year
        value -30 represents 1870). Year default range is from 70 to 137.

        Month: default value range is from 0 to 11.

        Date: default value range is from 1 to 31 according to the month value.

        Hour: default value will be in terms of 24 hr format (0~23)

        Minute: default value range is from 0 to 59.

        :raise RuntimeError: when the max value could not be set.

        :type: datetime.datetime

        .. versionchanged:: 1.8
            Returns None when the max value cannot be fetched, raise
            RuntimeError when setting the max value failed.

        """
        def __get__(self):
            cdef tm time
            if not elm_datetime_value_max_get(self.obj, &time):
                return None
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
            if not elm_datetime_value_max_set(self.obj, &time):
                raise RuntimeError

    property value_min:
        """The lower boundary of a field.

        Year: years since 1900. Negative value represents year below 1900 (year
        value -30 represents 1870). Year default range is from 70 to 137.

        Month: default value range is from 0 to 11.

        Date: default value range is from 1 to 31 according to the month value.

        Hour: default value will be in terms of 24 hr format (0~23)

        Minute: default value range is from 0 to 59.

        :raise RuntimeError: when the min value could not be set.

        :type: datetime.datetime

        .. versionchanged:: 1.8
            Returns None when the min value cannot be fetched, raise
            RuntimeError when setting the min value failed.

        """
        def __get__(self):
            cdef tm time
            if not elm_datetime_value_min_get(self.obj, &time):
                return None
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
            if not elm_datetime_value_min_set(self.obj, &time):
                raise RuntimeError

    def field_limit_get(self, Elm_Datetime_Field_Type fieldtype):
        """Get the field limits of a field.

        Limits can be set to individual fields, independently, except for AM/PM field.
        Any field can display the values only in between these Minimum and Maximum limits unless
        the corresponding time value is restricted from MinTime to MaxTime.
        That is, Min/ Max field limits always works under the limitations of MinTime/ MaxTime.

        There is no provision to set the limits of AM/PM field.

        :param fieldtype: Type of the field.
        :type fieldtype: :ref:`Elm_Datetime_Field_Type`

        """
        cdef int min, max
        elm_datetime_field_limit_get(self.obj, fieldtype, &min, &max)
        return min, max

    def field_limit_set(self, Elm_Datetime_Field_Type fieldtype, int min, int max):
        """Set the field limits of a field.

        Limits can be set to individual fields, independently, except for AM/PM field.
        Any field can display the values only in between these Minimum and Maximum limits unless
        the corresponding time value is restricted from MinTime to MaxTime.
        That is, Min/ Max field limits always works under the limitations of MinTime/ MaxTime.

        There is no provision to set the limits of AM/PM field.

        :param fieldtype: Type of the field.
        :type fieldtype: :ref:`Elm_Datetime_Field_Type`
        :param int min: Reference to field's minimum value
        :param int max: Reference to field's maximum value

        """
        elm_datetime_field_limit_set(self.obj, fieldtype, min, max)

    property value:
        """The current value of a field.

        Year: years since 1900. Negative value represents year below 1900 (year
        value -30 represents 1870). Year default range is from 70 to 137.

        Month: default value range is from 0 to 11.

        Date: default value range is from 1 to 31 according to the month value.

        Hour: default value will be in terms of 24 hr format (0~23)

        Minute: default value range is from 0 to 59.

        :raise RuntimeError: when the value could not be set.

        :type: datetime.datetime

        .. versionchanged:: 1.8
            Returns None when the value cannot be fetched, raise RuntimeError
            when setting the value failed.

        """
        def __get__(self):
            cdef tm time
            if not elm_datetime_value_get(self.obj, &time):
                return None
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
            if not elm_datetime_value_set(self.obj, &time):
                raise RuntimeError

    def field_visible_get(self, fieldtype):
        """Whether a field can be visible/not

        .. seealso:: :py:meth:`field_visible_set`

        :param fieldtype: Type of the field.
        :type fieldtype: :ref:`Elm_Datetime_Field_Type`
        :return: ``True``, if field can be visible. ``False`` otherwise.
        :rtype: bool

        """
        return bool(elm_datetime_field_visible_get(self.obj, fieldtype))

    def field_visible_set(self, fieldtype, visible):
        """Set a field to be visible or not.

        Setting this API True does not ensure that the field is visible,
        apart from this, the field's format must be present in Datetime
        overall format. If a field's visibility is set to False then it
        won't appear even though its format is present in overall format. So
        if and only if this API is set true and the corresponding field's
        format is present in Datetime format, the field is visible.

        By default the field visibility is set to True.

        .. seealso:: :py:meth:`field_visible_get`

        :param fieldtype: Type of the field.
        :type fieldtype: :ref:`Elm_Datetime_Field_Type`
        :param visible: ``True`` field can be visible, ``False`` otherwise.
        :type visible: bool

        """
        elm_datetime_field_visible_set(self.obj, fieldtype, visible)

    def callback_changed_add(self, func, *args, **kwargs):
        """Whenever Datetime field value is changed, this signal is sent."""
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("Elm_Datetime", Datetime)
