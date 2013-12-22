# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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

"""

Widget description
------------------

.. image:: /images/calendar-preview.png
    :align: left

This is a calendar widget.

It helps applications to flexibly display a calender with day of the week,
date, year and month. Applications are able to set specific dates to be
reported back, when selected, in the smart callbacks of the calendar widget.
The API of this widget lets the applications perform other functions, like:

- placing marks on specific dates
- setting the bounds for the calendar (minimum and maximum years)
- setting the day names of the week (e.g. "Thu" or "Thursday")
- setting the year and month format.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - emitted when the date in the calendar is changed.
- ``display,changed`` - emitted when the current month displayed in the
  calendar is changed.
- ``focused`` - When the calendar has received focus. (since 1.8)
- ``unfocused`` - When the calendar has lost focus. (since 1.8)


Enumerations
------------

.. _Elm_Calendar_Mark_Repeat_Type:

Calendar mark repeat types
==========================

.. data:: ELM_CALENDAR_UNIQUE

    Default value.

    Marks will be displayed only on event day.

.. data:: ELM_CALENDAR_DAILY

    Marks will be displayed every day after event day (inclusive).

.. data:: ELM_CALENDAR_WEEKLY

    Marks will be displayed every week after event day (inclusive) - i.e.
    each seven days.

.. data:: ELM_CALENDAR_MONTHLY

    Marks will be displayed every month day that coincides to event day.

    E.g.: if an event is set to 30th Jan, no marks will be displayed on Feb,
    but will be displayed on 30th Mar

.. data:: ELM_CALENDAR_ANNUALLY

    Marks will be displayed every year that coincides to event day (and month).

    E.g. an event added to 30th Jan 2012 will be repeated on 30th Jan 2013.

.. data:: ELM_CALENDAR_LAST_DAY_OF_MONTH

    Marks will be displayed every last day of month after event day
    (inclusive).


.. _Elm_Calendar_Select_Mode:

Calendar selection modes
========================

.. data:: ELM_CALENDAR_SELECT_MODE_DEFAULT

    Default mode

.. data:: ELM_CALENDAR_SELECT_MODE_ALWAYS

    Select always

.. data:: ELM_CALENDAR_SELECT_MODE_NONE

    Don't select

.. data:: ELM_CALENDAR_SELECT_MODE_ONDEMAND

    Select on demand


.. _Elm_Calendar_Selectable:

Selectable
==========

.. data:: ELM_CALENDAR_SELECTABLE_NONE

    None selectable

.. data:: ELM_CALENDAR_SELECTABLE_YEAR

    Year is selectable

.. data:: ELM_CALENDAR_SELECTABLE_MONTH

    Month is selectable

.. data:: ELM_CALENDAR_SELECTABLE_DAY

    Day is selectable


.. _Elm_Calendar_Weekday:

Days
====

.. data:: ELM_DAY_SUNDAY

    Sunday

.. data:: ELM_DAY_MONDAY

    Monday

.. data:: ELM_DAY_TUESDAY

    Tuesday

.. data:: ELM_DAY_WEDNESDAY

    Wednesday

.. data:: ELM_DAY_THURSDAY

    Thursday

.. data:: ELM_DAY_FRIDAY

    Friday

.. data:: ELM_DAY_SATURDAY

    Saturday

"""

from cpython cimport PyUnicode_AsUTF8String, PyMem_Malloc, PyMem_Free

from efl.utils.conversions cimport _ctouni, array_of_strings_to_python_list, \
    python_list_strings_to_array_of_strings
from efl.eo cimport _object_mapping_register
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

from datetime import date

cimport enums

ELM_CALENDAR_UNIQUE = enums.ELM_CALENDAR_UNIQUE
ELM_CALENDAR_DAILY = enums.ELM_CALENDAR_DAILY
ELM_CALENDAR_WEEKLY = enums.ELM_CALENDAR_WEEKLY
ELM_CALENDAR_MONTHLY = enums.ELM_CALENDAR_MONTHLY
ELM_CALENDAR_ANNUALLY = enums.ELM_CALENDAR_ANNUALLY
ELM_CALENDAR_LAST_DAY_OF_MONTH = enums.ELM_CALENDAR_LAST_DAY_OF_MONTH

ELM_CALENDAR_SELECT_MODE_DEFAULT = enums.ELM_CALENDAR_SELECT_MODE_DEFAULT
ELM_CALENDAR_SELECT_MODE_ALWAYS = enums.ELM_CALENDAR_SELECT_MODE_ALWAYS
ELM_CALENDAR_SELECT_MODE_NONE = enums.ELM_CALENDAR_SELECT_MODE_NONE
ELM_CALENDAR_SELECT_MODE_ONDEMAND = enums.ELM_CALENDAR_SELECT_MODE_ONDEMAND

ELM_DAY_SUNDAY = enums.ELM_DAY_SUNDAY
ELM_DAY_MONDAY = enums.ELM_DAY_MONDAY
ELM_DAY_TUESDAY = enums.ELM_DAY_TUESDAY
ELM_DAY_WEDNESDAY = enums.ELM_DAY_WEDNESDAY
ELM_DAY_THURSDAY = enums.ELM_DAY_THURSDAY
ELM_DAY_FRIDAY = enums.ELM_DAY_FRIDAY
ELM_DAY_SATURDAY = enums.ELM_DAY_SATURDAY
ELM_DAY_LAST = enums.ELM_DAY_LAST


cdef class CalendarMark(object):

    """An item for the Calendar widget.

    A mark that will be drawn in the calendar respecting the insertion
    time and periodicity. It will emit the type as signal to the widget theme.
    Default theme supports "holiday" and "checked", but it can be extended.

    Instantiating it won't immediately update the calendar, drawing the marks.
    For this, call :py:func:`Calendar.marks_draw`. However, when user selects
    next or previous month calendar forces marks drawn.

    Marks created with this method can be deleted with :py:func:`delete`.

    Example::

        from datetime import date, timedelta

        cal = Calendar(win)

        selected_time = date.today() + timedelta(5)
        cal.mark_add("holiday", selected_time, ELM_CALENDAR_ANNUALLY)

        selected_time = date.today() + timedelta(1)
        cal.mark_add("checked", selected_time, ELM_CALENDAR_UNIQUE)

        cal.marks_draw()

    """

    cdef Elm_Calendar_Mark *obj

    def __init__(self, evasObject cal, mark_type, mark_time,
            Elm_Calendar_Mark_Repeat_Type repeat):
        """

        :param mark_type: A string used to define the type of mark. It will be
            emitted to the theme, that should display a related modification on these
            days representation.
        :type mark_type: string
        :param mark_time: A date object to represent the date of inclusion of the
            mark. For marks that repeats it will just be displayed after the inclusion
            date in the calendar.
        :type mark_time: datetime.date
        :param repeat: Repeat the event following this periodicity. Can be a unique
            mark (that don't repeat), daily, weekly, monthly or annually.
        :type repeat: :ref:`Elm_Calendar_Mark_Repeat_Type`

        :return: The created mark or ``None`` upon failure.
        :rtype: :py:class:`CalendarMark`

        """
        cdef tm time
        tmtup = mark_time.timetuple()
        time.tm_mday = tmtup.tm_mday
        time.tm_mon = tmtup.tm_mon - 1
        time.tm_year = tmtup.tm_year - 1900
        time.tm_wday = tmtup.tm_wday
        time.tm_yday = tmtup.tm_yday
        time.tm_isdst = tmtup.tm_isdst
        if isinstance(mark_type, unicode): mark_type = PyUnicode_AsUTF8String(mark_type)
        self.obj = elm_calendar_mark_add(cal.obj,
            <const_char *>mark_type if mark_type is not None else NULL,
            &time, repeat)

    def delete(self):
        """delete()

        Delete a mark from the calendar.

        If deleting all calendar marks is required, ``del``
        :py:attr:`Calendar.marks` should be used instead of getting marks list
        and deleting each one.

        .. seealso:: :py:meth:`Calendar.mark_add`

        :param mark: The mark to be deleted.
        :type mark: :py:class:`CalendarMark`

        """
        elm_calendar_mark_del(self.obj)

cdef class Calendar(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_calendar_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property weekdays_names:
        """The weekdays' names to be displayed by the calendar.

        By default, weekdays abbreviations get from system are displayed:
        E.g. for an en_US locale: "Sun, Mon, Tue, Wed, Thu, Fri, Sat"

        The first string should be related to Sunday, the second to Monday...

        The usage should be like this::

            weekdays =
            (
              "Sunday", "Monday", "Tuesday", "Wednesday",
              "Thursday", "Friday", "Saturday"
            )
            calendar.weekdays_names = weekdays

        :type: tuple of strings

        .. warning:: It must have 7 elements, or it will access invalid memory.

        """
        def __get__(self):
            return array_of_strings_to_python_list(
                <char **>elm_calendar_weekdays_names_get(self.obj), 7)

        def __set__(self, weekdays):
            elm_calendar_weekdays_names_set(self.obj,
                python_list_strings_to_array_of_strings(weekdays))

    property min_max_year:
        """The minimum and maximum values for the year

        Maximum must be greater than minimum, except if you don't want to set
        maximum year.
        Default values are 1902 and -1.

        If the maximum year is a negative value, it will be limited depending
        on the platform architecture (year 2037 for 32 bits)

        :type: (int **min**, int **max**)

        """
        def __get__(self):
            cdef int min, max
            elm_calendar_min_max_year_get(self.obj, &min, &max)
            return (min, max)
        def __set__(self, value):
            cdef int min, max
            min, max = value
            elm_calendar_min_max_year_set(self.obj, min, max)

    property select_mode:
        """The day selection mode used.

        :type: :ref:`Elm_Calendar_Select_Mode`

        """
        def __get__(self):
            return elm_calendar_select_mode_get(self.obj)
        def __set__(self, mode):
            elm_calendar_select_mode_set(self.obj, mode)

    property selected_time:
        """Selected date on the calendar.

        Setting this changes the displayed month if needed.
        Selected date changes when the user goes to next/previous month or
        select a day pressing over it on calendar.

        :type: datetime.date

        .. versionchanged:: 1.8
            Returns None when the selected date cannot be fetched.

        """
        def __get__(self):
            cdef tm time
            if not elm_calendar_selected_time_get(self.obj, &time):
                return None
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

    # TODO:
    # property format_function:
    #     """Set a function to format the string that will be used to display
    #     month and year.

    #     By default it uses strftime with "%B %Y" format string.
    #     It should allocate the memory that will be used by the string,
    #     that will be freed by the widget after usage.
    #     A pointer to the string and a pointer to the time struct will be provided.

    #     Example::

    #         static char *
    #         _format_month_year(struct tm selected_time)
    #         {
    #             char buf[32];
    #             if (!strftime(buf, sizeof(buf), "%B %Y", selected_time)) return NULL;
    #             return strdup(buf);
    #         }

    #         elm_calendar_format_function_set(calendar, _format_month_year);

    #     :param format_func: Function to set the month-year string given
    #         the selected date
    #     :type format_func: function

    #     """
    #     def __set__(self, format_func):
    #         elm_calendar_format_function_set(self.obj, format_func)

    def mark_add(self, mark_type, mark_time, Elm_Calendar_Mark_Repeat_Type repeat):
        """mark_add(mark_type, mark_time, Elm_Calendar_Mark_Repeat_Type repeat) -> CalendarMark

        A constructor for a :py:class:`CalendarMark`.

        :param mark_type: A string used to define the type of mark. It will be
            emitted to the theme, that should display a related modification on these
            days representation.
        :type mark_type: string
        :param mark_time: A date object to represent the date of inclusion of the
            mark. For marks that repeats it will just be displayed after the inclusion
            date in the calendar.
        :type mark_time: datetime.date
        :param repeat: Repeat the event following this periodicity. Can be a unique
            mark (that don't repeat), daily, weekly, monthly or annually.
        :type repeat: :ref:`Elm_Calendar_Mark_Repeat_Type`
        :return: The created mark or ``None`` upon failure.
        :rtype: :py:class:`CalendarMark`

        """
        return CalendarMark(self, mark_type, mark_time, repeat)

    property marks:
        """Calendar marks.

        :type: list of :py:class:`CalendarMark`

        """
        def __get__(self):
            cdef:
                Elm_Calendar_Mark *obj
                const_Eina_List *lst = elm_calendar_marks_get(self.obj)
                list ret = list()
                CalendarMark o

            while lst:
                obj = <Elm_Calendar_Mark *>lst.data
                lst = lst.next
                o = CalendarMark.__new__(CalendarMark)
                o.obj = obj
                if o is not None:
                    ret.append(o)
            return ret

        #TODO: def __set__(self, value):
        def __del__(self):
            elm_calendar_marks_clear(self.obj)

    def marks_draw(self):
        """marks_draw()

        Draw calendar marks.

        Should be used after adding, removing or clearing marks.
        It will go through the entire marks list updating the calendar.
        If lots of marks will be added, add all the marks and then call
        this function.

        When the month is changed, i.e. user selects next or previous month,
        marks will be drawn.

        :seealso: :py:class:`CalendarMark`

        """
        elm_calendar_marks_draw(self.obj)

    property interval:
        """Set the interval on time updates for an user mouse button hold
        on calendar widgets' month selection.

        This interval value is **decreased** while the user holds the
        mouse pointer either selecting next or previous month.

        This helps the user to get to a given month distant from the
        current one easier/faster, as it will start to change quicker and
        quicker on mouse button holds.

        The calculation for the next change interval value, starting from
        the one set with this call, is the previous interval divided by
        1.05, so it decreases a little bit.

        The default starting interval value for automatic changes is
        **0.85** seconds.

        :type: float

        """
        def __get__(self):
            return elm_calendar_interval_get(self.obj)
        def __set__(self, interval):
            elm_calendar_interval_set(self.obj, interval)

    property first_day_of_week:
        """The first day of week to use on the calendar widget.

        :type: int

        """
        def __get__(self):
            return elm_calendar_first_day_of_week_get(self.obj)
        def __set__(self, day):
            elm_calendar_first_day_of_week_set(self.obj, day)

    property selectable:
        """How selected_time manages a date

        :type: :ref:`Elm_Calendar_Selectable`

        .. versionadded:: 1.8

        """
        def __set__(self, Elm_Calendar_Selectable selectable):
            elm_calendar_selectable_set(self.obj, selectable)

        def __get__(self):
            return int(elm_calendar_selectable_get(self.obj))

    property displayed_time:
        """Get the current time displayed in the widget

        :type: datetime.date

        .. versionadded:: 1.8

        """
        def __get__(self):
            cdef tm time
            if not elm_calendar_displayed_time_get(self.obj, &time):
                return None
            ret = date( time.tm_year + 1900,
                        time.tm_mon + 1,
                        time.tm_mday)
            return ret

    def callback_changed_add(self, func, *args, **kwargs):
        """Emitted when the date in the calendar is changed."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_display_changed_add(self, func, *args, **kwargs):
        """Emitted when the current month displayed in the calendar is changed."""
        self._callback_add("display,changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("display,changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the calendar has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the calendar has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Calendar", Calendar)
