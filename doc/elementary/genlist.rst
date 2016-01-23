.. currentmodule:: efl.elementary

Genlist
#######

.. image:: /images/genlist-preview.png


Widget description
==================

This widget aims to have more expansive list than the simple list in
Elementary that could have more flexible items and allow many more
entries while still being fast and low on memory usage. At the same time
it was also made to be able to do tree structures. But the price to pay
is more complexity when it comes to usage. If all you want is a simple
list (not much items) with icons and a single text, use the normal
:class:`List` object.

Genlist has a fairly large API, mostly because it's relatively complex,
trying to be both expansive, powerful and efficient. First we will begin
an overview on the theory behind genlist.


Genlist item classes - creating items
=====================================

In order to have the ability to add and delete items on the fly, genlist
implements the item class (callback) system where the application provides a
structure with information about that type of item (genlist may contain
multiple different items with different classes, states and styles).
Genlist will call the functions in this class (methods) when an item is
"realized" (i.e., created dynamically, while the user is scrolling the
grid). All objects will simply be deleted when no longer needed with
:func:`efl.evas.Object.delete`. :class:`GenlistItemClass` contains the
following members:

- ``item_style`` - This is a constant string and define the name of the default
  item style. It **must** be provided.
- ``decorate_item_style`` - This is a constant string and define the name of
  the style to be used in the "decorate" mode.
  See :attr:`GenlistItem.decorate_mode`.
- ``decorate_all_item_style`` - This is a constant string and
  define the name of the style to be used in the "decorate all" mode.
  See :attr:`Genlist.decorate_mode`.
- ``text_get`` - This function will be called for every text part. Should
  return the text to display. See :func:`GenlistItemClass.text_get`.
- ``content_get`` - This function will be called for every content part.
  Should return an object to display, the object will be deleted by the
  genlist on its deletion or when the item is "unrealized". See
  :func:`GenlistItemClass.content_get`.
- ``state_get`` - This function will be called for every state part. Must
  return ``True`` for false/off or ``True`` for true/on. Genlists will
  emit a signal to its theming Edje object with ``"elm,state,xxx,active"``
  and ``"elm"`` as "emission" and "source" arguments, respectively, when
  the state is true (the default is false), where ``xxx`` is the name of
  the (state) part.  See :func:`GenlistItemClass.state_get`.
- ``func.del`` - This is intended for use when genlist items are deleted,
  so any data attached to the item (e.g. its data parameter on creation)
  can be deleted. See :func:`GenlistItemClass.delete`.


Available item styles
=====================

- ``default`` The default style: icon, text, end icon
- ``default_style`` The text part is a textblock and can use markups
- ``double_label`` Two different text parts
- ``icon_top_text_bottom``
- ``group_index``
- ``one_icon`` Only 1 icon (left) (since: 1.1)
- ``end_icon`` Only 1 icon (at end/right) (since: 1.1)
- ``no_icon`` No icon (since: 1.1)
- ``full`` Only one object, elm.swallow.content, which consumes whole area of
  the genlist item (since: 1.7)


Structure of items
==================

An item in a genlist can have 0 or more texts (they can be regular text
or textblock Evas objects - that's up to the style to determine), 0 or
more contents (which are simply objects swallowed into the genlist item's
theming Edje object) and 0 or more **boolean states**, which have the
behavior left to the user to define. The Edje part names for each of
these properties will be looked up, in the theme file for the genlist,
under the Edje (string) data items named ``labels``, ``contents``
and ``states``, respectively. For each of those properties, if more
than one part is provided, they must have names listed separated by
spaces in the data fields. For the default genlist item theme, we have
**one** text part (``elm.text``), **two** content parts
(``elm.swallow.icon`` and ``elm.swallow.end``) and **no** state parts.


Editing and Navigating
======================

Items can be added by several calls. All of them return a
:py:class:`GenlistItem` handle that is an internal member inside the genlist.
They all take a data parameter that is meant to be used for a handle to the
applications internal data (eg. the struct with the original item data). The
parent parameter is the parent genlist item this belongs to if it is a tree or
an indexed group, and None if there is no parent. The flags can be a bitmask of
:attr:`ELM_GENLIST_ITEM_NONE`, :attr:`ELM_GENLIST_ITEM_TREE` and
:attr:`ELM_GENLIST_ITEM_GROUP`. If :attr:`ELM_GENLIST_ITEM_TREE` is set then
this item is displayed as an item that is able to expand and have child items.
If :attr:`ELM_GENLIST_ITEM_GROUP` is set then this item is group index item
that is displayed at the top until the next group comes. The func parameter is
a convenience callback that is called when the item is selected and the data
parameter will be the func_data parameter, ``obj`` be the genlist object and
event_info will be the genlist item.

:py:meth:`GenlistItem.append_to` adds an item to the end of the list, or if
there is a parent, to the end of all the child items of the parent.
:py:meth:`GenlistItem.prepend_to` is the same but adds to the beginning of
the list or children list. :py:meth:`GenlistItem.insert_before` inserts at
item before another item and :py:meth:`GenlistItem.insert_after` inserts after
the indicated item.

The application can clear the list with :py:meth:`Genlist.clear` which deletes
all the items in the list and
:py:meth:`~efl.elementary.object_item.ObjectItem.delete` will delete a specific
item. :py:meth:`GenlistItem.subitems_clear` will clear all items that are
children of the indicated parent item.

To help inspect list items you can jump to the item at the top of the list
with :py:attr:`Genlist.first_item` which will return the first item, and
similarly :py:attr:`Genlist.last_item` gets the item at the end of the list.
:py:attr:`GenlistItem.next` and :py:attr:`GenlistItem.prev` get the next
and previous items respectively relative to the indicated item. Using
these calls you can walk the entire item list/tree. Note that as a tree
the items are flattened in the list, so :py:attr:`GenlistItem.parent` will
let you know which item is the parent (and thus know how to skip them if
wanted).


Multi-selection
===============

If the application wants multiple items to be able to be selected,
:py:attr:`Genlist.multi_select` can enable this. If the list is
single-selection only (the default), then :py:attr:`Genlist.selected_item`
will return the selected item, if any, or None if none is selected. If the
list is multi-select then :py:attr:`Genlist.selected_items` will return a
list (that is only valid as long as no items are modified (added, deleted,
selected or unselected)).


Usage hints
===========

There are also convenience functions.
:py:attr:`efl.elementary.object_item.ObjectItem.widget` will return the genlist
object the item belongs to. :py:meth:`GenlistItem.show` will make the scroller
scroll to show that specific item so its visible.
:py:attr:`efl.elementary.object_item.ObjectItem.data` returns the data pointer
set by the item creation functions.

If an item changes (state of boolean changes, text or contents change),
then use :py:meth:`GenlistItem.update` to have genlist update the item with
the new state. Genlist will re-realize the item and thus call the functions
in the _Elm_Genlist_Item_Class for that item.

Use :py:attr:`GenlistItem.selected` to programmatically (un)select an item or
get its selected state. Similarly to expand/contract an item and get its
expanded state, use :py:attr:`GenlistItem.expanded`. And again to make an item
disabled (unable to be selected and appear differently) use
:py:attr:`GenlistItem.disabled` to set this and get the disabled state.

In general to indicate how the genlist should expand items horizontally to
fill the list area, use :py:attr:`Genlist.mode`. Valid modes are
ELM_LIST_LIMIT, ELM_LIST_COMPRESS and ELM_LIST_SCROLL. The default is
ELM_LIST_SCROLL. This mode means that if items are too wide to fit, the
scroller will scroll horizontally. Otherwise items are expanded to
fill the width of the viewport of the scroller. If it is
ELM_LIST_LIMIT, items will be expanded to the viewport width
if larger than the item, but genlist widget with is
limited to the largest item. D not use ELM_LIST_LIMIT mode with homogeneous
mode turned on. ELM_LIST_COMPRESS can be combined with a different style
that uses Edje's ellipsis feature (cutting text off like this: "tex...").

Items will only call their selection func and callback when first becoming
selected. Any further clicks will do nothing, unless you enable always
select with :py:attr:`Genlist.select_mode` as ELM_OBJECT_SELECT_MODE_ALWAYS.
This means even if selected, every click will make the selected callbacks
be called. :py:attr:`Genlist.select_mode` as ELM_OBJECT_SELECT_MODE_NONE will
turn off the ability to select items entirely and they will neither
appear selected nor call selected callback functions.

Remember that you can create new styles and add your own theme augmentation per
application with :py:meth:`efl.elementary.theme.Theme.extension_add`. If you
absolutely must have a specific style that overrides any theme the user or
system sets up you can use :py:meth:`efl.elementary.theme.Theme.overlay_add` to
add such a file.


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


Implementation
==============

Evas tracks every object you create. Every time it processes an event
(mouse move, down, up etc.) it needs to walk through objects and find out
what event that affects. Even worse every time it renders display updates,
in order to just calculate what to re-draw, it needs to walk through many
many many objects. Thus, the more objects you keep active, the more
overhead Evas has in just doing its work. It is advisable to keep your
active objects to the minimum working set you need. Also remember that
object creation and deletion carries an overhead, so there is a
middle-ground, which is not easily determined. But don't keep massive lists
of objects you can't see or use. Genlist does this with list objects. It
creates and destroys them dynamically as you scroll around. It groups them
into blocks so it can determine the visibility etc. of a whole block at
once as opposed to having to walk the whole list. This 2-level list allows
for very large numbers of items to be in the list (tests have used up to
2,000,000 items). Also genlist employs a queue for adding items. As items
may be different sizes, every item added needs to be calculated as to its
size and thus this presents a lot of overhead on populating the list, this
genlist employs a queue. Any item added is queued and spooled off over
time, actually appearing some time later, so if your list has many members
you may find it takes a while for them to all appear, with your process
consuming a lot of CPU while it is busy spooling.

Genlist also implements a tree structure, but it does so with callbacks to
the application, with the application filling in tree structures when
requested (allowing for efficient building of a very deep tree that could
even be used for file-management). See the above smart signal callbacks for
details.


Emitted signals
===============

- ``activated`` - The user has double-clicked or pressed
  (enter|return|spacebar) on an item. The ``event_info`` parameter is the
  item that was activated.
- ``clicked,double`` - The user has double-clicked an item.  The
  ``event_info`` parameter is the item that was double-clicked.
- ``clicked,right`` - The user has right-clicked an item.  The
  ``event_info`` parameter is the item that was right-clicked. (since: 1.13)
- ``selected`` - This is called when a user has made an item selected.
  The event_info parameter is the genlist item that was selected.
- ``unselected`` - This is called when a user has made an item
  unselected. The event_info parameter is the genlist item that was
  unselected.
- ``expanded`` - This is called when :py:attr:`GenlistItem.expanded` is
  called and the item is now meant to be expanded. The event_info
  parameter is the genlist item that was indicated to expand.  It is the
  job of this callback to then fill in the child items.
- ``contracted`` - This is called when :py:attr:`GenlistItem.expanded` is
  called and the item is now meant to be contracted. The event_info
  parameter is the genlist item that was indicated to contract. It is the
  job of this callback to then delete the child items.
- ``expand,request`` - This is called when a user has indicated they want
  to expand a tree branch item. The callback should decide if the item can
  expand (has any children) and then call :py:attr:`GenlistItem.expanded`
  appropriately to set the state. The event_info parameter is the genlist
  item that was indicated to expand.
- ``contract,request`` - This is called when a user has indicated they
  want to contract a tree branch item. The callback should decide if the
  item can contract (has any children) and then call
  :py:attr:`GenlistItem.expanded` appropriately to set the state. The
  event_info parameter is the genlist item that was indicated to contract.
- ``realized`` - This is called when the item in the list is created as a
  real evas object. event_info parameter is the genlist item that was
  created.
- ``unrealized`` - This is called just before an item is unrealized.
  After this call content objects provided will be deleted and the item
  object itself delete or be put into a floating cache.
- ``drag,start,up`` - This is called when the item in the list has been
  dragged (not scrolled) up.
- ``drag,start,down`` - This is called when the item in the list has been
  dragged (not scrolled) down.
- ``drag,start,left`` - This is called when the item in the list has been
  dragged (not scrolled) left.
- ``drag,start,right`` - This is called when the item in the list has
  been dragged (not scrolled) right.
- ``drag,stop`` - This is called when the item in the list has stopped
  being dragged.
- ``drag`` - This is called when the item in the list is being dragged.
- ``longpressed`` - This is called when the item is pressed for a certain
  amount of time. By default it's 1 second. The event_info parameter is the
  longpressed genlist item.
- ``scroll,anim,start`` - This is called when scrolling animation has
  started.
- ``scroll,anim,stop`` - This is called when scrolling animation has
  stopped.
- ``scroll,drag,start`` - This is called when dragging the content has
  started.
- ``scroll,drag,stop`` - This is called when dragging the content has
  stopped.
- ``edge,top`` - This is called when the genlist is scrolled until
  the top edge.
- ``edge,bottom`` - This is called when the genlist is scrolled
  until the bottom edge.
- ``edge,left`` - This is called when the genlist is scrolled
  until the left edge.
- ``edge,right`` - This is called when the genlist is scrolled
  until the right edge.
- ``multi,swipe,left`` - This is called when the genlist is multi-touch
  swiped left.
- ``multi,swipe,right`` - This is called when the genlist is multi-touch
  swiped right.
- ``multi,swipe,up`` - This is called when the genlist is multi-touch
  swiped up.
- ``multi,swipe,down`` - This is called when the genlist is multi-touch
  swiped down.
- ``multi,pinch,out`` - This is called when the genlist is multi-touch
  pinched out.
- ``multi,pinch,in`` - This is called when the genlist is multi-touch
  pinched in.
- ``swipe`` - This is called when the genlist is swiped.
- ``moved`` - This is called when a genlist item is moved in reorder mode.
- ``moved,after`` - This is called when a genlist item is moved after
  another item in reorder mode. The event_info parameter is the reordered
  item. To get the relative previous item, use :py:attr:`GenlistItem.prev`.
  This signal is called along with "moved" signal.
- ``moved,before`` - This is called when a genlist item is moved before
  another item in reorder mode. The event_info parameter is the reordered
  item. To get the relative previous item, use :py:attr:`GenlistItem.next`.
  This signal is called along with "moved" signal.
- ``language,changed`` - This is called when the program's language is
  changed.
- ``tree,effect,finished`` - This is called when a genlist tree effect
  is finished.
- ``highlighted`` - an item in the list is highlighted. This is called when
  the user presses an item or keyboard selection is done so the item is
  physically highlighted. The ``event_info`` parameter is the item that was
  highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted. The ``event_info`` parameter is the item that
  was unhighlighted.
- ``item,focused`` - When the genlist item has received focus. (since 1.10)
- ``item,unfocused`` - When the genlist item has lost focus. (since 1.10)
- ``changed`` - Genlist is now changed their items and properties and all
  calculation is finished. (since 1.16)
- ``filter,done`` - Genlist filter operation is completed.. (since 1.17)


Enumerations
============

.. _Elm_Genlist_Item_Type:

Genlist item types
------------------

.. data:: ELM_GENLIST_ITEM_NONE

    Simple item

.. data:: ELM_GENLIST_ITEM_TREE

    The item may be expanded and have child items

.. data:: ELM_GENLIST_ITEM_GROUP

    An index item of a group of items


.. _Elm_Genlist_Item_Field_Type:

Genlist items' field types
--------------------------

.. data:: ELM_GENLIST_ITEM_FIELD_ALL

    Match all fields

.. data:: ELM_GENLIST_ITEM_FIELD_TEXT

    Match text fields

.. data:: ELM_GENLIST_ITEM_FIELD_CONTENT

    Match content fields

.. data:: ELM_GENLIST_ITEM_FIELD_STATE

    Match state fields


.. _Elm_Genlist_Item_Scrollto_Type:

Genlist items' scroll-to types
------------------------------

.. data:: ELM_GENLIST_ITEM_SCROLLTO_NONE

    No scroll to

.. data:: ELM_GENLIST_ITEM_SCROLLTO_IN

    Scroll to the nearest viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_TOP

    Scroll to the top of viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

    Scroll to the middle of viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_BOTTTOM

    Scroll to the bottom of viewport

    .. versionadded:: 1.17


Inheritance diagram
===================

.. inheritance-diagram::
    Genlist
    GenlistItem
    GenlistItemClass
    :parts: 2


.. autoclass:: Genlist
.. autoclass:: GenlistItem
.. autoclass:: GenlistItemClass
