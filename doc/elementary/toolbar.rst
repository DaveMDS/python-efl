.. currentmodule:: efl.elementary

Toolbar
#######

.. image:: /images/toolbar-preview.png


Widget description
==================

A toolbar is a widget that displays a list of items inside a box. It
can be scrollable, show a menu with items that don't fit to toolbar size
or even crop them.

Only one item can be selected at a time.

Items can have multiple states, or show menus when selected by the user.


Emitted signals
===============

- ``clicked`` - when the user clicks on a toolbar item and becomes selected.
- ``longpressed`` - when the toolbar is pressed for a certain amount of time.
- ``item,focused`` - When the toolbar item has received focus. (since 1.10)
- ``item,unfocused`` - When the toolbar item has lost focus. (since 1.10)


Available styles
================

- ``default``
- ``transparent`` - no background or shadow, just show the content


Layout text parts
=================

- ``default`` - label of the toolbar item


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


Enumerations
============

.. _Elm_Toolbar_Shrink_Mode:

Toolbar shrink modes
--------------------

.. data:: ELM_TOOLBAR_SHRINK_NONE

    Set toolbar minimum size to fit all the items

.. data:: ELM_TOOLBAR_SHRINK_HIDE

    Hide exceeding items

.. data:: ELM_TOOLBAR_SHRINK_SCROLL

    Allow accessing exceeding items through a scroller

.. data:: ELM_TOOLBAR_SHRINK_MENU

    Inserts a button to pop up a menu with exceeding items

.. data:: ELM_TOOLBAR_SHRINK_EXPAND

    Expand all items according the size of the toolbar.


.. _Elm_Toolbar_Item_Scrollto_Type:

Toolbar item scrollto types
---------------------------

Where to position the item in the toolbar.

.. data:: ELM_TOOLBAR_ITEM_SCROLLTO_NONE

    No scrollto

.. data:: ELM_TOOLBAR_ITEM_SCROLLTO_IN

    To the nearest viewport

.. data:: ELM_TOOLBAR_ITEM_SCROLLTO_FIRST

    To the first of viewport

.. data:: ELM_TOOLBAR_ITEM_SCROLLTO_MIDDLE

    To the middle of viewport

.. data:: ELM_TOOLBAR_ITEM_SCROLLTO_LAST

    To the last of viewport


Inheritance diagram
===================

.. inheritance-diagram::
    Toolbar
    ToolbarItem
    ToolbarItemState
    :parts: 2


.. autoclass:: Toolbar
.. autoclass:: ToolbarItem
.. autoclass:: ToolbarItemState
