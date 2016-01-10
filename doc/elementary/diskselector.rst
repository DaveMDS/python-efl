.. currentmodule:: efl.elementary

Diskselector
############

.. image:: /images/diskselector-preview.png


Widget description
==================

A diskselector is a kind of list widget. It scrolls horizontally,
and can contain label and icon objects. Three items are displayed
with the selected one in the middle.

It can act like a circular list with round mode and labels can be
reduced for a defined length for side items.


Emitted signals
===============

- ``selected`` - when item is selected, i.e. scroller stops.
- ``clicked`` - This is called when a user clicks an item
- ``scroll,anim,start`` - scrolling animation has started
- ``scroll,anim,stop`` - scrolling animation has stopped
- ``scroll,drag,start`` - dragging the diskselector has started
- ``scroll,drag,stop`` - dragging the diskselector has stopped

.. note:: The ``scroll,anim,*`` and ``scroll,drag,*`` signals are only emitted
          by user intervention.

Layout content parts
====================

- ``icon`` - An icon in the diskselector item


Layout text parts
=================

- ``default`` - Label of the diskselector item


Scrollable Interface
====================

This widget supports the scrollable interface.

If you wish to control the scrolling behaviour using these functions,
inherit both the widget class and the
:py:class:`~efl.elementary.scroller.Scrollable` class
using multiple inheritance, for example::

    class ScrollableGenlist(Genlist, Scrollable):
        def __init__(self, canvas, *args, **kwargs):
            Genlist.__init__(self, canvas)


Inheritance diagram
===================

.. inheritance-diagram::
    Diskselector
    DiskselectorItem
    :parts: 2


.. autoclass:: Diskselector
.. autoclass:: DiskselectorItem
