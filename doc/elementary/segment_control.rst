.. currentmodule:: efl.elementary

Segment Control
###############

.. image:: /images/segmentcontrol-preview.png


Widget description
==================

Segment control widget is a horizontal control made of multiple
segment items, each segment item functioning similar to discrete two
state button. A segment control groups the items together and provides
compact single button with multiple equal size segments.

Segment item size is determined by base widget size and the number of
items added. Only one segment item can be at selected state. A segment
item can display combination of Text and any Evas_Object like Images or
other widget.


Emitted signals
===============

- ``changed`` - When the user clicks on a segment item which is not
  previously selected and get selected. The event_info parameter is the
  segment item.


Layout content parts
====================

- ``icon`` - An icon in a segment control item


Layout text parts
=================

- ``default`` - Title label in a segment control item


Inheritance diagram
===================

.. inheritance-diagram:: SegmentControl
    :parts: 2


.. autoclass:: SegmentControl
.. autoclass:: SegmentControlItem
