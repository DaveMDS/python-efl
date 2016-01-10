.. currentmodule:: efl.elementary

Flipselector
############

.. image:: /images/flipselector-preview.png


Widget description
==================

A flip selector is a widget to show a set of *text* items, one at a time, with
the same sheet switching style as the :py:class:`~efl.elementary.clock.Clock`
widget, when one changes the current displaying sheet (thus, the "flip" in the
name).

User clicks to flip sheets which are *held* for some time will
make the flip selector to flip continuously and automatically for
the user. The interval between flips will keep growing in time,
so that it helps the user to reach an item which is distant from
the current selection.


Emitted signals
===============

- ``selected`` - when the widget's selected text item is changed
- ``overflowed`` - when the widget's current selection is changed
  from the first item in its list to the last
- ``underflowed`` - when the widget's current selection is changed
  from the last item in its list to the first


Layout text parts
=================

- ``default`` - label of the flipselector item


Inheritance diagram
===================

.. inheritance-diagram::
    FlipSelector
    FlipSelectorItem
    :parts: 2


.. autoclass:: FlipSelector
.. autoclass:: FlipSelectorItem
