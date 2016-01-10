.. currentmodule:: efl.elementary

Slider
######

.. image:: /images/slider-preview.png


Widget description
==================

The slider adds a draggable "slider" widget for selecting the value of
something within a range.

A slider can be horizontal or vertical. It can contain an Icon and has a
primary label as well as a units label (that is formatted with floating
point values and thus accepts a printf-style format string, like
``"%1.2f units"``. There is also an indicator string that may be somewhere
else (like on the slider itself) that also accepts a format string like
units. Label, Icon Unit and Indicator strings/objects are optional.

A slider may be inverted which means values invert, with high vales being
on the left or top and low values on the right or bottom (as opposed to
normally being low on the left or top and high on the bottom and right).

The slider should have its minimum and maximum values set by the
application with  :py:attr:`Slider.min_max` and value should also be set by
the application before use with  :py:attr:`Slider.value`. The span of the
slider is its length (horizontally or vertically). This will be scaled by
the object or applications scaling factor. At any point code can query the
slider for its value with :py:attr:`Slider.value`.


Emitted signals
===============

- ``changed`` - Whenever the slider value is changed by the user.
- ``slider,drag,start`` - dragging the slider indicator around has
  started.
- ``slider,drag,stop`` - dragging the slider indicator around has
  stopped.
- ``delay,changed`` - A short time after the value is changed by
  the user. This will be called only when the user stops dragging
  for a very short period or when they release their finger/mouse,
  so it avoids possibly expensive reactions to the value change.


Layout content parts
====================

- ``icon`` - An icon of the slider
- ``end`` - A end part content of the slider


Layout text parts
=================

- ``default`` - Label of the slider


Inheritance diagram
===================

.. inheritance-diagram:: Slider
    :parts: 2


.. autoclass:: Slider
