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

include "calendar_cdef.pxi"

cdef class CalendarMark(object):
    """

    An item for the Calendar widget.

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
        """CalendarMark(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
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
            <const char *>mark_type if mark_type is not None else NULL,
            &time, repeat)

    def delete(self):
        """Delete a mark from the calendar.

        If deleting all calendar marks is required, ``del``
        :py:attr:`Calendar.marks` should be used instead of getting marks list
        and deleting each one.

        .. seealso:: :py:meth:`Calendar.mark_add`

        :param mark: The mark to be deleted.
        :type mark: :py:class:`CalendarMark`

        """
        elm_calendar_mark_del(self.obj)

cdef class Calendar(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Calendar(..)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
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
        """A constructor for a :py:class:`CalendarMark`.

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
                const Eina_List *lst = elm_calendar_marks_get(self.obj)
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
        """Draw calendar marks.

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
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_display_changed_add(self, func, *args, **kwargs):
        """Emitted when the current month displayed in the calendar is changed."""
        self._callback_add("display,changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("display,changed", func)


_object_mapping_register("Elm_Calendar", Calendar)
