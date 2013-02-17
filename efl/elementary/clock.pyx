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

.. rubric:: Clock edit modes

.. data:: ELM_CLOCK_EDIT_DEFAULT

    Default edit

.. data:: ELM_CLOCK_EDIT_HOUR_DECIMAL

    Edit hours' decimal

.. data:: ELM_CLOCK_EDIT_HOUR_UNIT

    Edit hours' unit

.. data:: ELM_CLOCK_EDIT_MIN_DECIMAL

    Edit minutes' decimal

.. data:: ELM_CLOCK_EDIT_MIN_UNIT

    Edit minutes' unit

.. data:: ELM_CLOCK_EDIT_SEC_DECIMAL

    Edit seconds' decimal

.. data:: ELM_CLOCK_EDIT_SEC_UNIT

    Edit seconds' unit

.. data:: ELM_CLOCK_EDIT_ALL

    Edit all

"""

include "widget_header.pxi"

from layout_class cimport LayoutClass

cimport enums

ELM_CLOCK_EDIT_DEFAULT = enums.ELM_CLOCK_EDIT_DEFAULT
ELM_CLOCK_EDIT_HOUR_DECIMAL = enums.ELM_CLOCK_EDIT_HOUR_DECIMAL
ELM_CLOCK_EDIT_HOUR_UNIT = enums.ELM_CLOCK_EDIT_HOUR_UNIT
ELM_CLOCK_EDIT_MIN_DECIMAL = enums.ELM_CLOCK_EDIT_MIN_DECIMAL
ELM_CLOCK_EDIT_MIN_UNIT = enums.ELM_CLOCK_EDIT_MIN_UNIT
ELM_CLOCK_EDIT_SEC_DECIMAL = enums.ELM_CLOCK_EDIT_SEC_DECIMAL
ELM_CLOCK_EDIT_SEC_UNIT = enums.ELM_CLOCK_EDIT_SEC_UNIT
ELM_CLOCK_EDIT_ALL = enums.ELM_CLOCK_EDIT_ALL

cdef class Clock(LayoutClass):

    """

    This is a digital clock widget.

    In its default theme, it has a vintage "flipping numbers clock" appearance,
    which will animate sheets of individual algarisms individually as time goes
    by.

    A newly created clock will fetch system's time (already considering
    local time adjustments) to start with, and will tick accordingly. It may
    or may not show seconds.

    Clocks have an **edition** mode. When in it, the sheets will display
    extra arrow indications on the top and bottom and the user may click on
    them to raise or lower the time values. After it's told to exit edition
    mode, it will keep ticking with that new time set (it keeps the
    difference from local time).

    Also, when under edition mode, user clicks on the cited arrows which are
    **held** for some time will make the clock to flip the sheet, thus
    editing the time, continuously and automatically for the user. The
    interval between sheet flips will keep growing in time, so that it helps
    the user to reach a time which is distant from the one set.

    The time display is, by default, in military mode (24h), but an am/pm
    indicator may be optionally shown, too, when it will switch to 12h.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``changed`` - the clock's user changed the time

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_clock_add(parent.obj))

    property time:
        """The clock widget's time

        This property reflects the time that is showed by the clock widget.

        Values **must** be set within the following ranges:

        - 0 - 23, for hours
        - 0 - 59, for minutes
        - 0 - 59, for seconds,

        even if the clock is not in "military" mode.

        .. warning:: The behavior for values set out of those ranges is
            **undefined**.

        :type: (int h, int m, int s)

        """
        def __get__(self):
            cdef int hrs, min, sec
            elm_clock_time_get(self.obj, &hrs, &min, &sec)
            return (hrs, min, sec)

        def __set__(self, value):
            cdef int hrs, min, sec
            hrs, min, sec = value
            elm_clock_time_set(self.obj, hrs, min, sec)

    def time_set(self, hours, minutes, seconds):
        elm_clock_time_set(self.obj, hours, minutes, seconds)
    def time_get(self):
        cdef int hrs, min, sec
        elm_clock_time_get(self.obj, &hrs, &min, &sec)
        return (hrs, min, sec)

    property edit:
        """Whether a given clock widget is under **edition mode** or under
        (default) displaying-only mode.

        This property reflects whether the clock editable or not **by user
        interaction**. When in edition mode, clocks **stop** ticking, until
        one brings them back to canonical mode. The :py:attr:`edit_mode`
        property will influence which digits of the clock will be editable.

        .. note:: am/pm sheets, if being shown, will **always** be editable
            under edition mode.

        :type: bool

        """
        def __get__(self):
            return bool(elm_clock_edit_get(self.obj))

        def __set__(self, edit):
            elm_clock_edit_set(self.obj, edit)

    def edit_set(self, edit):
        elm_clock_edit_set(self.obj, edit)
    def edit_get(self, edit):
        return bool(elm_clock_edit_get(self.obj))

    property edit_mode:
        """Which digits of the given clock widget should be editable when in
        edition mode.

        :type: Elm_Clock_Edit_Mode

        """
        def __get__(self):
            return elm_clock_edit_mode_get(self.obj)

        def __set__(self, mode):
            elm_clock_edit_mode_set(self.obj, mode)

    def edit_mode_set(self, mode):
        elm_clock_edit_mode_set(self.obj, mode)
    def edit_mode_get(self):
        return elm_clock_edit_mode_get(self.obj)

    property show_am_pm:
        """Whether the given clock widget must show hours in military or
        am/pm mode

        This property reflects if the clock must show hours in military or
        am/pm mode. In some countries like Brazil the military mode
        (00-24h-format) is used, in opposition to the USA, where the
        am/pm mode is more commonly used.

        ``True``, if in am/pm mode, ``False`` if in military

        :type: bool

        """
        def __get__(self):
            return elm_clock_show_am_pm_get(self.obj)

        def __set__(self, am_pm):
            elm_clock_show_am_pm_set(self.obj, am_pm)

    def show_am_pm_set(self, am_pm):
        elm_clock_show_am_pm_set(self.obj, am_pm)
    def show_am_pm_get(self):
        return elm_clock_show_am_pm_get(self.obj)

    property show_seconds:
        """Whether the given clock widget must show time with seconds or not

        By default, they are **not** shown.

        :type: bool

        """
        def __get__(self):
            return elm_clock_show_seconds_get(self.obj)

        def __set__(self, seconds):
            elm_clock_show_seconds_set(self.obj, seconds)

    def show_seconds_set(self, seconds):
        elm_clock_show_seconds_set(self.obj, seconds)
    def show_seconds_get(self):
        return elm_clock_show_seconds_get(self.obj)

    property first_interval:
        """The first interval on time updates for a user mouse button hold
        on clock widgets' time edition.

        This interval value is **decreased** while the user holds the
        mouse pointer either incrementing or decrementing a given the
        clock digit's value.

        This helps the user to get to a given time distant from the
        current one easier/faster, as it will start to flip quicker and
        quicker on mouse button holds.

        The calculation for the next flip interval value, starting from
        the one set with this call, is the previous interval divided by
        1.05, so it decreases a little bit.

        The default starting interval value for automatic flips is
        **0.85** seconds.

        :type: float

        """
        def __get__(self):
            return elm_clock_first_interval_get(self.obj)

        def __set__(self, interval):
            elm_clock_first_interval_set(self.obj, interval)

    def first_interval_set(self, interval):
        elm_clock_first_interval_set(self.obj, interval)
    def first_interval_get(self):
        return elm_clock_first_interval_get(self.obj)

    def callback_changed_add(self, func, *args, **kwargs):
        """The clock's user changed the time"""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("elm_clock", Clock)
