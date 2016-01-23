.. currentmodule:: efl.elementary

Gengrid
#######

.. image:: /images/gengrid-preview.png


Widget description
==================

This widget aims to position objects in a grid layout while actually
creating and rendering only the visible ones, using the same idea as the
:py:class:`~efl.elementary.genlist.Genlist`: the user defines a **class** for
each item, specifying functions that will be called at object creation,
deletion, etc. When those items are selected by the user, a callback
function is issued. Users may interact with a gengrid via the mouse (by
clicking on items to select them and clicking on the grid's viewport and
swiping to pan the whole view) or via the keyboard, navigating through
item with the arrow keys.


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


Gengrid layouts
===============

Gengrid may layout its items in one of two possible layouts:

- horizontal or
- vertical.

When in "horizontal mode", items will be placed in **columns**, from top
to bottom and, when the space for a column is filled, another one is
started on the right, thus expanding the grid horizontally, making for
horizontal scrolling. When in "vertical mode" , though, items will be
placed in **rows**, from left to right and, when the space for a row is
filled, another one is started below, thus expanding the grid vertically
(and making for vertical scrolling).


Gengrid items
=============

An item in a gengrid can have 0 or more texts (they can be regular text
or textblock Evas objects - that's up to the style to determine), 0 or
more contents (which are simply objects swallowed into the gengrid
item's theming Edje object) and 0 or more **boolean states**, which
have the behavior left to the user to define. The Edje part names for
each of these properties will be looked up, in the theme file for the
gengrid, under the Edje (string) data items named ``"texts"``,
``"contents"`` and ``"states"``, respectively. For each of those
properties, if more than one part is provided, they must have names
listed separated by spaces in the data fields. For the default gengrid
item theme, we have **one** text part (``"elm.text"``), **two** content
parts (``"elm.swalllow.icon"`` and ``"elm.swallow.end"``) and **no**
state parts.

A gengrid item may be at one of several styles. Elementary provides one
by default - "default", but this can be extended by system or
application custom themes/overlays/extensions (see
:py:class:`~efl.elementary.theme.Theme` for more details).


Gengrid item classes
====================

In order to have the ability to add and delete items on the fly, gengrid
implements a class (callback) system where the application provides a
structure with information about that type of item (gengrid may contain
multiple different items with different classes, states and styles).
Gengrid will call the functions in this struct (methods) when an item is
"realized" (i.e., created dynamically, while the user is scrolling the
grid). All objects will simply be deleted when no longer needed with
:meth:`~efl.eo.Eo.delete`. The :class:`GengridItemClass` class contains the
following attributes and methods:

- ``item_style`` - This is a constant string and simply defines the name
  of the item style. It **must** be specified and the default should be
  ``default``.
- ``func.text_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to :meth:`~Gengrid.item_append` and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the existing text parts
  in the Edje group implementing the item's theme.
  See :py:meth:`GengridItemClass.text_get`.
- ``func.content_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to :py:meth:`GengridItem.append_to` and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the existing (content)
  swallow parts in the Edje group implementing the item's theme. It must
  return ``None,`` when no content is desired, or a valid object handle,
  otherwise. The object will be deleted by the gengrid on its deletion
  or when the item is "unrealized". See :py:meth:`GengridItemClass.content_get`.
- ``func.state_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to :py:meth:`GengridItem.append_to` and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the state parts in the
  Edje group implementing the item's theme. Return ``False`` for
  false/off or ``True`` for true/on. Gengrids will emit a signal to
  its theming Edje object with ``"elm,state,xxx,active"`` and ``"elm"``
  as "emission" and "source" arguments, respectively, when the state is
  true (the default is false), where ``xxx`` is the name of the (state)
  part. See :py:meth:`GengridItemClass.state_get`.
- ``func.del`` - This is called when
  :meth:`efl.elementary.object_item.ObjectItem.delete` is called on
  an item or :meth:`~Gengrid.clear` is called on the gengrid. This is
  intended for use when gengrid items are deleted, so any data attached
  to the item (e.g. its data parameter on creation) can be deleted. See
  :py:meth:`GengridItemClass.delete`.


Usage hints
===========

If the user wants to have multiple items selected at the same time,
:attr:`~Gengrid.multi_select` will permit it. If the gengrid is
single-selection only (the default), then :attr:`~Gengrid.selected_item`
will return the selected item or ``None``, if none is selected. If the
gengrid is under multi-selection, then :attr:`~Gengrid.selected_items`
will return a list (that is only valid as long as no items are modified
(added, deleted, selected or unselected) of child items on a gengrid.

If an item changes (internal (boolean) state, text or content changes),
then use :meth:`~GengridItem.update` to have gengrid update the item with
the new state. A gengrid will re-"realize" the item, thus calling the
functions in the :class:`GengridItemClass` set for that item.

To programmatically (un)select an item or get the selected state, use
:attr:`GengridItem.selected`. To make an item disabled (unable to be
selected and appear differently) or get the disabled state
use :attr:`GengridItem.disabled`.

Grid cells will only have their selection smart callbacks called when
firstly getting selected. Any further clicks will do nothing, unless you
enable the "always select mode", with :attr:`~Gengrid.select_mode` as
:attr:`ELM_OBJECT_SELECT_MODE_ALWAYS`, thus making every click to issue
selection callbacks. :attr:`~Gengrid.select_mode` as
:attr:`ELM_OBJECT_SELECT_MODE_NONE` will turn off the ability to select items
entirely in the widget and they will neither appear selected nor call
the selection smart callbacks.

Remember that you can create new styles and add your own theme
augmentation per application with
:meth:`Theme.extension_add<efl.elementary.theme.Theme.extension_add>`. If you
absolutely must have a specific style that overrides any theme the user
or system sets up you can use
:meth:`Theme.extension_add<efl.elementary.theme.Theme.overlay_add>` to add such
a file.


Emitted signals
===============

- ``activated`` - The user has double-clicked or pressed
  (enter|return|spacebar) on an item. The ``event_info`` parameter
  is the gengrid item that was activated.
- ``clicked,double`` - The user has double-clicked an item.
  The ``event_info`` parameter is the gengrid item that was double-clicked.
- ``clicked,right`` - The user has right-clicked an item.  The
  ``event_info`` parameter is the item that was right-clicked. (since: 1.13)
- ``longpressed`` - This is called when the item is pressed for a certain
  amount of time. By default it's 1 second.
- ``selected`` - The user has made an item selected. The
  ``event_info`` parameter is the gengrid item that was selected.
- ``unselected`` - The user has made an item unselected. The
  ``event_info`` parameter is the gengrid item that was unselected.
- ``realized`` - This is called when the item in the gengrid
  has its implementing Evas object instantiated, de facto.
  ``event_info`` is the gengrid item that was created.
- ``unrealized`` - This is called when the implementing Evas
  object for this item is deleted. ``event_info`` is the gengrid
  item that was deleted.
- ``changed`` - Called when an item is added, removed, resized
  or moved and when the gengrid is resized or gets "horizontal"
  property changes.
- ``scroll,anim,start`` - This is called when scrolling animation has
  started.
- ``scroll,anim,stop`` - This is called when scrolling animation has
  stopped.
- ``drag,start,up`` - Called when the item in the gengrid has
  been dragged (not scrolled) up.
- ``drag,start,down`` - Called when the item in the gengrid has
  been dragged (not scrolled) down.
- ``drag,start,left`` - Called when the item in the gengrid has
  been dragged (not scrolled) left.
- ``drag,start,right`` - Called when the item in the gengrid has
  been dragged (not scrolled) right.
- ``drag,stop`` - Called when the item in the gengrid has
  stopped being dragged.
- ``drag`` - Called when the item in the gengrid is being
  dragged.
- ``scroll`` - called when the content has been scrolled
  (moved).
- ``scroll,drag,start`` - called when dragging the content has
  started.
- ``scroll,drag,stop`` - called when dragging the content has
  stopped.
- ``edge,top`` - This is called when the gengrid is scrolled until
  the top edge.
- ``edge,bottom`` - This is called when the gengrid is scrolled
  until the bottom edge.
- ``edge,left`` - This is called when the gengrid is scrolled
  until the left edge.
- ``edge,right`` - This is called when the gengrid is scrolled
  until the right edge.
- ``moved`` - This is called when a gengrid item is moved by a user
  interaction in a reorder mode. The ``event_info`` parameter is the item that
  was moved.
- ``index,update`` - This is called when a gengrid item index is changed.
  Note that this callback is called while each item is being realized.
- ``highlighted`` - an item in the list is highlighted. This is called when
  the user presses an item or keyboard selection is done so the item is
  physically highlighted. The ``event_info`` parameter is the item that was
  highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted. The ``event_info`` parameter is the item that
  was unhighlighted.
- ``item,focused`` - When the gengrid item has received focus. (since 1.10)
- ``item,unfocused`` - When the gengrid item has lost focus. (since 1.10)
- ``item,reorder,anim,start`` - This is called when a gengrid item movement
  has just started by keys in reorder mode. The parameter is the item that
  is going to move. (since 1.10)
- ``item,reorder,anim,stop`` - This is called when a gengrid item movement just
  stopped in reorder mode. The parameter is the item that was moved. (since 1.10)


Enumerations
============

.. _Elm_Gengrid_Item_Scrollto_Type:

Items' scroll to types
----------------------

.. data:: ELM_GENGRID_ITEM_SCROLLTO_NONE

    No scroll to

.. data:: ELM_GENGRID_ITEM_SCROLLTO_IN

    Scroll to the nearest viewport

.. data:: ELM_GENGRID_ITEM_SCROLLTO_TOP

    Scroll to the top of viewport

.. data:: ELM_GENGRID_ITEM_SCROLLTO_MIDDLE

    Scroll to the middle of viewport

.. data:: ELM_GENGRID_ITEM_SCROLLTO_BOTTOM

    Scroll to the bottom of viewport

    .. versionadded:: 1.17


.. _Elm_Gengrid_Object_Multi_Select_Mode:

Multi-select mode
-----------------

.. data:: ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT

    Default multiple select mode

    .. versionadded:: 1.10

.. data:: ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL

    Disallow mutiple selection when clicked without control key pressed

    .. versionadded:: 1.10

.. data:: ELM_OBJECT_MULTI_SELECT_MODE_MAX

    Value unknown

    .. versionadded:: 1.10


.. _Elm_Gengrid_Reorder_Type:

Reorder type
------------

.. data:: ELM_GENGRID_REORDER_TYPE_NORMAL

    Normal reorder mode

    .. versionadded:: 1.11

.. data:: ELM_GENGRID_REORDER_TYPE_SWAP

    Swap reorder mode

    .. versionadded:: 1.11


Inheritance diagram
===================

.. inheritance-diagram::
    Gengrid
    GengridItem
    GengridItemClass
    :parts: 2


.. autoclass:: Gengrid
.. autoclass:: GengridItem
.. autoclass:: GengridItemClass
