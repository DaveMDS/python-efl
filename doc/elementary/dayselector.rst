.. currentmodule:: efl.elementary

Dayselector
###########

.. image:: /images/dayselector-preview.png


Widget description
==================

Dayselector displays all seven days of the week and allows the user to
select multiple days.

The selection can be toggle by just clicking on the day.

Dayselector also provides the functionality to check whether a day is
selected or not.

First day of the week is taken from config settings by default. It can be
altered by using the API :py:attr:`~Dayselector.week_start` API.

APIs are provided for setting the duration of weekend
:py:attr:`~Dayselector.weekend_start` and :py:attr:`~Dayselector.weekend_length`
does this job.

Two styles of weekdays and weekends are supported in Dayselector.
Application can emit signals on individual check objects for setting the
weekday, weekend styles.

Once the weekend start day or weekend length changes, all the weekday &
weekend styles will be reset to default style. It's the application's
responsibility to set the styles again by sending corresponding signals.

"day0" indicates Sunday, "day1" indicates Monday etc. continues and so,
"day6" indicates the Saturday part name.

Application can change individual day display string by using the API
:py:meth:`~efl.elementary.object.Object.part_text_set`.

:py:meth:`~efl.elementary.object.Object.part_content_set` API sets the
individual day object only if the passed one is a Check widget.

Check object representing a day can be set/get by the application by using
the elm_object_part_content_set/get APIs thus providing a way to handle
the different check styles for individual days.


Emitted signals
===============

- ``dayselector,changed`` - when the user changes the state of a day.


Enumerations
============

.. _Elm_Dayselector_Day:

Dayselector days
----------------

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


Inheritance diagram
===================

.. inheritance-diagram:: Dayselector
    :parts: 2

.. autoclass:: Dayselector
