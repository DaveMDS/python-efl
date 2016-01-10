.. currentmodule:: efl.elementary

Calendar
########

.. image:: /images/calendar-preview.png


Widget description
==================

This is a calendar widget.

It helps applications to flexibly display a calender with day of the week,
date, year and month. Applications are able to set specific dates to be
reported back, when selected, in the smart callbacks of the calendar widget.
The API of this widget lets the applications perform other functions, like:

- placing marks on specific dates
- setting the bounds for the calendar (minimum and maximum years)
- setting the day names of the week (e.g. "Thu" or "Thursday")
- setting the year and month format.


Emitted signals
===============

- ``changed`` - emitted when the date in the calendar is changed.
- ``display,changed`` - emitted when the current month displayed in the
  calendar is changed.


Enumerations
============

.. _Elm_Calendar_Mark_Repeat_Type:

Calendar mark repeat types
--------------------------

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
------------------------

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
----------

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
----

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


Inheritance diagram
===================

.. inheritance-diagram::
    Calendar
    CalendarMark
    :parts: 2


.. autoclass:: Calendar
.. autoclass:: CalendarMark
