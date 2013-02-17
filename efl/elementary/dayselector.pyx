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
#

"""

.. rubric:: Dayselector days

.. data:: ELM_DAYSELECTOR_SUN

    Sunday

.. data:: ELM_DAYSELECTOR_MON

    Monday

.. data:: ELM_DAYSELECTOR_TUE

    Tuesday

.. data:: ELM_DAYSELECTOR_WED

    Wednesday

.. data:: ELM_DAYSELECTOR_THU

    Thursday

.. data:: ELM_DAYSELECTOR_FRI

    Friday

.. data:: ELM_DAYSELECTOR_SAT

    Saturday

"""

include "widget_header.pxi"

from layout_class cimport LayoutClass

cimport enums

ELM_DAYSELECTOR_SUN = enums.ELM_DAYSELECTOR_SUN
ELM_DAYSELECTOR_MON = enums.ELM_DAYSELECTOR_MON
ELM_DAYSELECTOR_TUE = enums.ELM_DAYSELECTOR_TUE
ELM_DAYSELECTOR_WED = enums.ELM_DAYSELECTOR_WED
ELM_DAYSELECTOR_THU = enums.ELM_DAYSELECTOR_THU
ELM_DAYSELECTOR_FRI = enums.ELM_DAYSELECTOR_FRI
ELM_DAYSELECTOR_SAT = enums.ELM_DAYSELECTOR_SAT
ELM_DAYSELECTOR_MAX = enums.ELM_DAYSELECTOR_MAX

cdef class Dayselector(LayoutClass):

    """

    Dayselector displays all seven days of the week and allows the user to
    select multiple days.

    The selection can be toggle by just clicking on the day.

    Dayselector also provides the functionality to check whether a day is
    selected or not.

    First day of the week is taken from config settings by default. It can be
    altered by using the API :py:attr:`week_start` API.

    APIs are provided for setting the duration of weekend
    :py:attr:`weekend_start` and :py:attr:`weekend_length` does this job.

    Two styles of weekdays and weekends are supported in Dayselector.
    Application can emit signals on individual check objects for setting the
    weekday, weekend styles.

    Once the weekend start day or weekend length changes, all the weekday &
    weekend styles will be reset to default style. It's the application's
    responsibility to set the styles again by sending corresponding signals.

    "day0" indicates Sunday, "day1" indicates Monday etc. continues and so,
    "day6" indicates the Saturday part name.

    Application can change individual day display string by using the API
    :py:func:`elementary.object.Object.part_text_set()`.

    :py:func:`elementary.object.Object.part_content_set()` API sets the
    individual day object only if the passed one is a Check widget.

    Check object representing a day can be set/get by the application by using
    the elm_object_part_content_set/get APIs thus providing a way to handle
    the different check styles for individual days.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``"dayselector,changed"`` - when the user changes the state of a day.
    - ``"language,changed"`` - the program's language changed

    Available styles for dayselector are:

    - default

    """
    def __init__(self, evasObject parent):
        self._set_obj(elm_dayselector_add(parent.obj))

    def day_selected_set(self, day, selected):
        """day_selected_set(int day, bool selected)

        Set the state of given Dayselector_Day.

        .. seealso:: Elm_Dayselector_Day
        .. seealso:: :py:func:`day_selected_get()`

        :param day: The day that the user want to set state.
        :type day: Elm_Dayselector_Day
        :param selected: state of the day. ``True`` is selected.
        :type selected: bool

        """
        elm_dayselector_day_selected_set(self.obj, day, selected)

    def day_selected_get(self, day):
        """day_selected_get(int day):

        Get the state of given Dayselector_Day.

        .. seealso:: Elm_Dayselector_Day
        .. seealso:: :py:func:`day_selected_set()`

        :param day: The day that the user want to know state.
        :type day: Elm_Dayselector_Day
        :return: ``True``, if the Day is selected
        :rtype: bool

        """
        return bool(elm_dayselector_day_selected_get(self.obj, day))

    property week_start:
        """The starting day of Dayselector.

        :type: Elm_Dayselector_Day

        """
        def __get__(self):
            return elm_dayselector_week_start_get(self.obj)
        def __set__(self, day):
            elm_dayselector_week_start_set(self.obj, day)

    property weekend_start:
        """The weekend starting day of Dayselector.

        :type: Elm_Dayselector_Day

        """
        def __get__(self):
            return elm_dayselector_weekend_start_get(self.obj)
        def __set__(self, day):
            elm_dayselector_weekend_start_set(self.obj, day)

    property weekend_length:
        """The weekend length of Dayselector.

        :type: int

        """
        def __get__(self):
            return elm_dayselector_weekend_length_get(self.obj)
        def __set__(self, length):
            elm_dayselector_weekend_length_set(self.obj, length)

    def callback_dayselector_changed_add(self, func, *args, **kwargs):
        """when the user changes the state of a day."""
        self._callback_add("dayselector,changed", func, *args, **kwargs)

    def callback_dayselector_changed_del(self, func):
        self._callback_del("dayselector,changed", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """the program's language changed"""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_dayselector", Dayselector)
