.. currentmodule:: efl.elementary

Spinner
#######

.. image:: /images/spinner-preview.png


Widget description
==================

A spinner is a widget which allows the user to increase or decrease
numeric values using arrow buttons, or edit values directly, clicking
over it and typing the new value.

By default the spinner will not wrap and has a label
of ``"%.0f"`` (just showing the integer value of the double).

A spinner has a label that is formatted with floating
point values and thus accepts a printf-style format string, like
``"%1.2f units"``.

It also allows specific values to be replaced by pre-defined labels.


Emitted signals
===============

- ``changed`` - Whenever the spinner value is changed.
- ``delay,changed`` - A short time after the value is changed by
  the user.  This will be called only when the user stops dragging
  for a very short period or when they release their finger/mouse,
  so it avoids possibly expensive reactions to the value change.
- ``spinner,drag,start`` - When dragging has started.
- ``spinner,drag,stop`` - When dragging has stopped.
- ``min,reached`` - Called when spinner value reached min (since 1.20)
- ``max,reached`` - Called when spinner value reached max (since 1.20)


Available styles
================

- ``default``: Default style
- ``vertical``: up/down buttons at the right side and text left aligned.


Inheritance diagram
===================

.. inheritance-diagram:: Spinner
    :parts: 2


.. autoclass:: Spinner
