.. currentmodule:: efl.elementary

List
####

.. image:: /images/list-preview.png


Widget description
==================

A list widget is a container whose children are displayed vertically or
horizontally, in order, and can be selected.
The list can accept only one or multiple items selection. Also has many
modes of items displaying.

A list is a very simple type of list widget.  For more robust
lists, :py:class:`~efl.elementary.genlist.Genlist` should probably be used.


Emitted signals
===============

- ``activated`` - The user has double-clicked or pressed
  (enter|return|spacebar) on an item.
- ``clicked,double`` - The user has double-clicked an item.
- ``clicked,right`` - The user has right-clicked an item. (since: 1.13)
- ``selected`` - when the user selected an item
- ``unselected`` - when the user unselected an item
- ``longpressed`` - an item in the list is long-pressed
- ``edge,top`` - the list is scrolled until the top edge
- ``edge,bottom`` - the list is scrolled until the bottom edge
- ``edge,left`` - the list is scrolled until the left edge
- ``edge,right`` - the list is scrolled until the right edge
- ``highlighted`` - an item in the list is highlighted. This is called when
  the user presses an item or keyboard selection is done so the item is
  physically highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted.
- ``item,focused`` - When the list item has received focus. (since 1.10)
- ``item,unfocused`` - When the list item has lost focus. (since 1.10)


Available styles
================

- ``default``


Layout content parts
====================

- ``start`` - A start position object in the list item
- ``end`` - A end position object in the list item


Layout text parts
=================

- ``default`` - label in the list item


Scrollable Interface
====================

This widget supports the scrollable interface.

If you wish to control the scolling behaviour using these functions,
inherit both the widget class and the
:py:class:`~efl.elementary.scroller.Scrollable` class
using multiple inheritance, for example::

    class ScrollableGenlist(Genlist, Scrollable):
        def __init__(self, canvas, *args, **kwargs):
            Genlist.__init__(self, canvas)


Enumerations
============

.. _Elm_List_Mode:

List sizing modes
-----------------

.. data:: ELM_LIST_COMPRESS

    The list won't set any of its size hints to inform how a possible container
    should resize it.

    Then, if it's not created as a "resize object", it might end with zeroed
    dimensions. The list will respect the container's geometry and, if any of
    its items won't fit into its transverse axis, one won't be able to scroll it
    in that direction.

.. data:: ELM_LIST_SCROLL

    Default value.

    This is the same as ELM_LIST_COMPRESS, with the exception that if any of
    its items won't fit into its transverse axis, one will be able to scroll
    it in that direction.

.. data:: ELM_LIST_LIMIT

    Sets a minimum size hint on the list object, so that containers may
    respect it (and resize itself to fit the child properly).

    More specifically, a minimum size hint will be set for its transverse
    axis, so that the largest item in that direction fits well. This is
    naturally bound by the list object's maximum size hints, set externally.

.. data:: ELM_LIST_EXPAND

    Besides setting a minimum size on the transverse axis, just like on
    ELM_LIST_LIMIT, the list will set a minimum size on the longitudinal
    axis, trying to reserve space to all its children to be visible at a time.

    This is naturally bound by the list object's maximum size hints, set
    externally.


Inheritance diagram
===================

.. inheritance-diagram::
    List
    ListItem
    :parts: 2


.. autoclass:: List
.. autoclass:: ListItem
