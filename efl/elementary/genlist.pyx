# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

.. image:: /images/genlist-preview.png

Widget description
------------------

This widget aims to have more expansive list than the simple list in
Elementary that could have more flexible items and allow many more
entries while still being fast and low on memory usage. At the same time
it was also made to be able to do tree structures. But the price to pay
is more complexity when it comes to usage. If all you want is a simple
list with icons and a single text, use the normal
:py:class:`~efl.elementary.list.List` object.

Genlist has a fairly large API, mostly because it's relatively complex,
trying to be both expansive, powerful and efficient. First we will begin
an overview on the theory behind genlist.

Genlist item classes - creating items
=====================================

In order to have the ability to add and delete items on the fly, genlist
implements a class (callback) system where the application provides a
structure with information about that type of item (genlist may contain
multiple different items with different classes, states and styles).
Genlist will call the functions in this struct (methods) when an item is
"realized" (i.e., created dynamically, while the user is scrolling the
grid). All objects will simply be deleted when no longer needed with
:py:meth:`~efl.evas.Object.delete`. :py:class:`GenlistItemClass` contains the
following members:

- ``item_style`` - This is a constant string and simply defines the name
  of the item style. It **must** be specified and the default should be
  ``"default".``
- ``decorate_item_style`` - This is a constant string and simply defines
  the name of the decorate mode item style. It is used to specify
  decorate mode item style. It can be used when you call
  :py:attr:`GenlistItem.decorate_mode`.
- ``decorate_all_item_style`` - This is a constant string and simply
  defines the name of the decorate all item style. It is used to specify
  decorate all item style. It can be used to set selection, checking and
  deletion mode. This is used when you call
  :py:attr:`Genlist.decorate_mode`.
- ``func`` - A struct with pointers to functions that will be called when
  an item is going to be actually created. All of them receive a ``data``
  parameter that will point to the same data passed to
  :py:meth:`GenlistItem.append_to` and related item creation functions, and an
  ``obj`` parameter that points to the genlist object itself.

The function pointers inside ``func`` are ``text_get``, ``content_get``,
``state_get`` and ``del``. The 3 first functions also receive a ``part``
parameter described below. A brief description of these functions follows:

- ``text_get`` - The ``part`` parameter is the name string of one of the
  existing text parts in the Edje group implementing the item's theme.
  See :py:meth:`GenlistItemClass.text_get`.
- ``content_get`` - The ``part`` parameter is the name string of one of the
  existing (content) swallow parts in the Edje group implementing the
  item's theme. It must return ``None``, when no content is desired, or
  a valid object handle, otherwise.  The object will be deleted by the
  genlist on its deletion or when the item is "unrealized". See
  :py:meth:`GenlistItemClass.content_get`.
- ``func.state_get`` - The ``part`` parameter is the name string of one of
  the state parts in the Edje group implementing the item's theme. Return
  ``False`` for false/off or ``True`` for true/on. Genlists will
  emit a signal to its theming Edje object with ``"elm,state,xxx,active"``
  and ``"elm"`` as "emission" and "source" arguments, respectively, when
  the state is true (the default is false), where ``xxx`` is the name of
  the (state) part.  See :py:meth:`GenlistItemClass.state_get`.
- ``func.del`` - This is intended for use when genlist items are deleted,
  so any data attached to the item (e.g. its data parameter on creation)
  can be deleted. See :py:meth:`GenlistItemClass.delete`.

Available item styles:

- default
- default_style - The text part is a textblock
- double_label
- icon_top_text_bottom
- group_index

- one_icon - Only 1 icon (left) :since: 1.1
- end_icon - Only 1 icon (at end/right) :since: 1.1
- no_icon - No icon (at end/right) :since: 1.1

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

A genlist item may be at one of several styles. Elementary provides one
by default - "default", but this can be extended by system or application
custom themes/overlays/extensions (see :py:mod:`themes<efl.elementary.theme>`)
for more details).

Editing and Navigating
======================

Items can be added by several calls. All of them return a
:py:class:`GenlistItem` handle that is an internal member inside the genlist.
They all take a data parameter that is meant to be used for a handle to
the applications internal data (eg. the struct with the original item
data). The parent parameter is the parent genlist item this belongs to if
it is a tree or an indexed group, and None if there is no parent. The
flags can be a bitmask of #ELM_GENLIST_ITEM_NONE, #ELM_GENLIST_ITEM_TREE
and #ELM_GENLIST_ITEM_GROUP. If #ELM_GENLIST_ITEM_TREE is set then this
item is displayed as an item that is able to expand and have child items.
If #ELM_GENLIST_ITEM_GROUP is set then this item is group index item that
is displayed at the top until the next group comes. The func parameter is
a convenience callback that is called when the item is selected and the
data parameter will be the func_data parameter, ``obj`` be the genlist
object and event_info will be the genlist item.

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
with :py:attr:`Genlist.first_item` which will return the item pointer, and
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
limited to the largest item. D not use ELM_LIST_LIMIT mode with homogenous
mode turned on. ELM_LIST_COMPRESS can be combined with a different style
that uses edjes' ellipsis feature (cutting text off like this: "tex...").

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

If you wish to control the scolling behaviour using these functions,
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

Genlist smart events
====================

Signals that you can add callbacks for are:

- ``activated`` - The user has double-clicked or pressed
  (enter|return|spacebar) on an item. The ``event_info`` parameter is the
  item that was activated.
- ``clicked,double`` - The user has double-clicked an item.  The
  ``event_info`` parameter is the item that was double-clicked.
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
  physically highlighted. The %c event_info parameter is the item that was
  highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted. The %c event_info parameter is the item that
  was unhighlighted.
- ``focused`` - When the genlist has received focus. (since 1.8)
- ``unfocused`` - When the genlist has lost focus. (since 1.8)


Enumerations
------------

.. _Elm_Genlist_Item_Type:

Genlist item types
==================

.. data:: ELM_GENLIST_ITEM_NONE

    Simple item

.. data:: ELM_GENLIST_ITEM_TREE

    The item may be expanded and have child items

.. data:: ELM_GENLIST_ITEM_GROUP

    An index item of a group of items


.. _Elm_Genlist_Item_Field_Type:

Genlist items' field types
==========================

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
==============================

.. data:: ELM_GENLIST_ITEM_SCROLLTO_NONE

    No scroll to

.. data:: ELM_GENLIST_ITEM_SCROLLTO_IN

    Scroll to the nearest viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_TOP

    Scroll to the top of viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

    Scroll to the middle of viewport


.. _Elm_Genlist_List_Mode:

List sizing
===========

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


.. _Elm_Genlist_Object_Select_Mode:

Selection modes
===============

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Default select mode

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    Always select mode

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    No select mode

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


"""

include "tooltips.pxi"

from cpython cimport PyUnicode_AsUTF8String, Py_DECREF, Py_INCREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject

from efl.utils.deprecated cimport DEPRECATED
from scroller cimport elm_scroller_policy_get, elm_scroller_policy_set, \
    elm_scroller_bounce_get, elm_scroller_bounce_set, Elm_Scroller_Policy

from object_item cimport ObjectItem, _object_item_to_python, \
    elm_object_item_widget_get, _object_item_from_python, \
    _object_item_list_to_python, elm_object_item_data_get
from general cimport strdup

from general cimport PY_EFL_ELM_LOG_DOMAIN
from efl.eina cimport EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, EINA_LOG_DOM_WARN, \
    EINA_LOG_DOM_ERR, EINA_LOG_DOM_CRIT

cimport enums

import traceback
import logging

ELM_GENLIST_ITEM_NONE = enums.ELM_GENLIST_ITEM_NONE
ELM_GENLIST_ITEM_TREE = enums.ELM_GENLIST_ITEM_TREE
ELM_GENLIST_ITEM_GROUP = enums.ELM_GENLIST_ITEM_GROUP
ELM_GENLIST_ITEM_MAX = enums.ELM_GENLIST_ITEM_MAX

ELM_GENLIST_ITEM_FIELD_ALL = enums.ELM_GENLIST_ITEM_FIELD_ALL
ELM_GENLIST_ITEM_FIELD_TEXT = enums.ELM_GENLIST_ITEM_FIELD_TEXT
ELM_GENLIST_ITEM_FIELD_CONTENT = enums.ELM_GENLIST_ITEM_FIELD_CONTENT
ELM_GENLIST_ITEM_FIELD_STATE = enums.ELM_GENLIST_ITEM_FIELD_STATE

ELM_GENLIST_ITEM_SCROLLTO_NONE = enums.ELM_GENLIST_ITEM_SCROLLTO_NONE
ELM_GENLIST_ITEM_SCROLLTO_IN = enums.ELM_GENLIST_ITEM_SCROLLTO_IN
ELM_GENLIST_ITEM_SCROLLTO_TOP = enums.ELM_GENLIST_ITEM_SCROLLTO_TOP
ELM_GENLIST_ITEM_SCROLLTO_MIDDLE = enums.ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

ELM_LIST_COMPRESS = enums.ELM_LIST_COMPRESS
ELM_LIST_SCROLL = enums.ELM_LIST_SCROLL
ELM_LIST_LIMIT = enums.ELM_LIST_LIMIT
ELM_LIST_EXPAND = enums.ELM_LIST_EXPAND

ELM_OBJECT_SELECT_MODE_DEFAULT = enums.ELM_OBJECT_SELECT_MODE_DEFAULT
ELM_OBJECT_SELECT_MODE_ALWAYS = enums.ELM_OBJECT_SELECT_MODE_ALWAYS
ELM_OBJECT_SELECT_MODE_NONE = enums.ELM_OBJECT_SELECT_MODE_NONE
ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY = enums.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
ELM_OBJECT_SELECT_MODE_MAX = enums.ELM_OBJECT_SELECT_MODE_MAX

ELM_SEL_FORMAT_TARGETS = enums.ELM_SEL_FORMAT_TARGETS
ELM_SEL_FORMAT_NONE = enums.ELM_SEL_FORMAT_NONE
ELM_SEL_FORMAT_TEXT = enums.ELM_SEL_FORMAT_TEXT
ELM_SEL_FORMAT_MARKUP = enums.ELM_SEL_FORMAT_MARKUP
ELM_SEL_FORMAT_IMAGE = enums.ELM_SEL_FORMAT_IMAGE
ELM_SEL_FORMAT_VCARD = enums.ELM_SEL_FORMAT_VCARD
ELM_SEL_FORMAT_HTML = enums.ELM_SEL_FORMAT_HTML

ELM_SEL_TYPE_PRIMARY = enums.ELM_SEL_TYPE_PRIMARY
ELM_SEL_TYPE_SECONDARY = enums.ELM_SEL_TYPE_SECONDARY
ELM_SEL_TYPE_XDND = enums.ELM_SEL_TYPE_XDND
ELM_SEL_TYPE_CLIPBOARD = enums.ELM_SEL_TYPE_CLIPBOARD

def _cb_object_item_conv(uintptr_t addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef char *_py_elm_genlist_item_text_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)

    func = item.item_class._text_get_func
    if func is None:
        return NULL

    try:
        o = object_from_instance(obj)
        ret = func(o, u, item.item_data)
    except:
        traceback.print_exc()
        return NULL

    if ret is not None:
        if isinstance(ret, unicode): ret = PyUnicode_AsUTF8String(ret)
        return strdup(ret)
    else:
        return NULL

cdef Evas_Object *_py_elm_genlist_item_content_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)
        evasObject icon

    func = item.item_class._content_get_func
    if func is None:
        return NULL

    o = object_from_instance(obj)

    try:
        icon = func(o, u, item.item_data)
    except:
        traceback.print_exc()
        return NULL

    if icon is not None:
        return icon.obj
    else:
        return NULL

cdef Eina_Bool _py_elm_genlist_item_state_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)

    func = item.item_class._state_get_func
    if func is None:
        return 0

    try:
        o = object_from_instance(obj)
        ret = func(o, u, item.item_data)
    except:
        traceback.print_exc()
        return 0

    return ret if ret is not None else 0

cdef void _py_elm_genlist_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GenlistItem item = <GenlistItem>data

    if item is None:
        return

    func = item.item_class._del_func

    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, item.item_data)
        except:
            traceback.print_exc()

    item._unset_obj()

cdef void _py_elm_genlist_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GenlistItem item

    assert data != NULL, "data is NULL in Genlist select cb"

    item = <GenlistItem>data

    if item.cb_func is not None:
        try:
            o = object_from_instance(obj)
            item.cb_func(item, o, item.func_data)
        except:
            traceback.print_exc()

cdef int _py_elm_genlist_compare_func(const_void *data1, const_void *data2) with gil:
    cdef:
        Elm_Object_Item *citem1 = <Elm_Object_Item *>data1
        Elm_Object_Item *citem2 = <Elm_Object_Item *>data2
        GenlistItem item1 = <GenlistItem>elm_object_item_data_get(citem1)
        GenlistItem item2 = <GenlistItem>elm_object_item_data_get(citem2)
        object func

    if item1.comparison_func is not None:
        func = item1.comparison_func
    elif item2.comparison_func is not None:
        func = item2.comparison_func
    else:
        return 0

    ret = func(item1, item2)
    if ret is not None:
        try:
            return ret
        except:
            traceback.print_exc()
            return 0
    else:
        return 0

cdef class GenlistIterator(object):
    cdef:
        Elm_Object_Item *current_item
        GenlistItem ret

    def __cinit__(self, Genlist gl):
        self.current_item = elm_genlist_first_item_get(gl.obj)

    def __next__(self):
        if self.current_item == NULL:
            raise StopIteration
        ret = _object_item_to_python(self.current_item)
        self.current_item = elm_genlist_item_next_get(self.current_item)
        return ret

class GenlistItemsCount(int):
    def __new__(cls, Object obj, int count):
        return int.__new__(cls, count)

    def __init__(self, Object obj, int count):
        self.obj = obj

    @DEPRECATED("1.8", "Use items_count instead.")
    def __call__(self):
        return self.obj._items_count()

include "genlist_item_class.pxi"
include "genlist_item.pxi"
include "genlist_widget.pxi"
