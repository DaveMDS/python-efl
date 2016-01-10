.. currentmodule:: efl.elementary

Index
#####

.. image:: /images/index-preview.png


Widget description
==================

An index widget gives you an index for fast access to whichever
group of other UI items one might have.

It's a list of text items (usually letters, for alphabetically ordered
access).

Index widgets are by default hidden and just appear when the
user clicks over it's reserved area in the canvas. In its
default theme, it's an area one ``finger`` wide on
the right side of the index widget's container.

When items on the index are selected, smart callbacks get called, so that its
user can make other container objects to show a given area or child object
depending on the index item selected. You'd probably be using an index together
with :py:class:`~efl.elementary.list.List`,
:py:class:`~efl.elementary.genlist.Genlist` or
:py:class:`~efl.elementary.gengrid.Gengrid`.


Emitted signals
===============

- ``changed`` - When the selected index item changes. ``event_info``
  is the selected item's data.
- ``delay,changed`` - When the selected index item changes, but
  after a small idling period. ``event_info`` is the selected
  item's data.
- ``selected`` - When the user releases a mouse button and
  selects an item. ``event_info`` is the selected item's data.
- ``level,up`` - when the user moves a finger from the first
  level to the second level
- ``level,down`` - when the user moves a finger from the second
  level to the first level

The ``delay,changed`` event has a delay on change before the event is actually
reported and moreover just the last event happening on those time frames will
actually be reported.


Inheritance diagram
===================

.. inheritance-diagram::
    Index
    IndexItem
    :parts: 2


.. autoclass:: Index
.. autoclass:: IndexItem
