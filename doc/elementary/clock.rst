.. currentmodule:: efl.elementary

Clock
#####

.. image:: /images/clock-preview.png


Widget description
==================

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


Emitted signals
===============

- ``changed`` - the clock's user changed the time


Enumerations
============

.. _Elm_Clock_Edit_Mode:

Clock edit modes
----------------

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


Inheritance diagram
===================

.. inheritance-diagram:: Clock
    :parts: 2


.. autoclass:: Clock
