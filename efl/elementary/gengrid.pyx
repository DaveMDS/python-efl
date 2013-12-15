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
#

"""

.. image:: /images/gengrid-preview.png

Widget description
------------------

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
evas_object_del(). The #Elm_Gengrid_Item_Class structure contains the
following members:

- ``item_style`` - This is a constant string and simply defines the name
  of the item style. It **must** be specified and the default should be
  ``"default".``
- ``func.text_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to elm_gengrid_item_append() and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the existing text parts
  in the Edje group implementing the item's theme. This function
  **must** return a strdup'()ed string, as the caller will free() it
  when done. See :py:meth:`GengridItem.text_get`.
- ``func.content_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to :py:meth:`GengridItem.append_to` and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the existing (content)
  swallow parts in the Edje group implementing the item's theme. It must
  return ``None,`` when no content is desired, or a valid object handle,
  otherwise. The object will be deleted by the gengrid on its deletion
  or when the item is "unrealized". See :py:meth:`GengridItem.content_get`.
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
  part. See #Elm_Gengrid_Item_State_Get_Cb.
- ``func.del`` - This is called when elm_object_item_del() is called on
  an item or elm_gengrid_clear() is called on the gengrid. This is
  intended for use when gengrid items are deleted, so any data attached
  to the item (e.g. its data parameter on creation) can be deleted. See
  :py:meth:`GengridItem.delete`.

Usage hints
===========

If the user wants to have multiple items selected at the same time,
elm_gengrid_multi_select_set() will permit it. If the gengrid is
single-selection only (the default), then elm_gengrid_select_item_get()
will return the selected item or ``None``, if none is selected. If the
gengrid is under multi-selection, then elm_gengrid_selected_items_get()
will return a list (that is only valid as long as no items are modified
(added, deleted, selected or unselected) of child items on a gengrid.

If an item changes (internal (boolean) state, text or content changes),
then use elm_gengrid_item_update() to have gengrid update the item with
the new state. A gengrid will re-"realize" the item, thus calling the
functions in the #Elm_Gengrid_Item_Class set for that item.

To programmatically (un)select an item, use
elm_gengrid_item_selected_set(). To get its selected state use
elm_gengrid_item_selected_get(). To make an item disabled (unable to be
selected and appear differently) use elm_object_item_disabled_set() to
set this and elm_object_item_disabled_get() to get the disabled state.

Grid cells will only have their selection smart callbacks called when
firstly getting selected. Any further clicks will do nothing, unless you
enable the "always select mode", with elm_gengrid_select_mode_set() as
ELM_OBJECT_SELECT_MODE_ALWAYS, thus making every click to issue
selection callbacks. elm_gengrid_select_mode_set() as
ELM_OBJECT_SELECT_MODE_NONE will turn off the ability to select items
entirely in the widget and they will neither appear selected nor call
the selection smart callbacks.

Remember that you can create new styles and add your own theme
augmentation per application with elm_theme_extension_add(). If you
absolutely must have a specific style that overrides any theme the user
or system sets up you can use elm_theme_overlay_add() to add such a file.

Gengrid smart events
====================

Smart events that you can add callbacks for are:

- ``activated`` - The user has double-clicked or pressed
  (enter|return|spacebar) on an item. The ``event_info`` parameter
  is the gengrid item that was activated.
- ``clicked,double`` - The user has double-clicked an item.
  The ``event_info`` parameter is the gengrid item that was double-clicked.
- ``longpressed`` - This is called when the item is pressed for a certain
  amount of time. By default it's 1 second.
- ``selected`` - The user has made an item selected. The
  ``event_info`` parameter is the gengrid item that was selected.
- ``unselected`` - The user has made an item unselected. The
  ``event_info`` parameter is the gengrid item that was unselected.
- ``realized`` - This is called when the item in the gengrid
  has its implementing Evas object instantiated, de facto.
  ``event_info`` is the gengrid item that was created. The object
  may be deleted at any time, so it is highly advised to the
  caller **not** to use the object returned from
  :py:attr:`GengridItem.object`, because it may point to freed
  objects.
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
  interaction in a reorder mode. The %c event_info parameter is the item that
  was moved.
- ``index,update`` - This is called when a gengrid item index is changed.
  Note that this callback is called while each item is being realized.
- ``highlighted`` - an item in the list is highlighted. This is called when
  the user presses an item or keyboard selection is done so the item is
  physically highlighted. The %c event_info parameter is the item that was
  highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted. The %c event_info parameter is the item that
  was unhighlighted.
- ``language,changed`` - This is called when the program's language is
  changed. Call the elm_gengrid_realized_items_update() if items text should
  be translated.
- ``focused`` - When the gengrid has received focus. (since 1.8)
- ``unfocused`` - When the gengrid has lost focus. (since 1.8)


Enumerations
------------

.. _Elm_Gengrid_Item_Scrollto_Type:

Items' scroll to types
======================

.. data:: ELM_GENLIST_ITEM_SCROLLTO_NONE

    No scroll to

.. data:: ELM_GENLIST_ITEM_SCROLLTO_IN

    Scroll to the nearest viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_TOP

    Scroll to the top of viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

    Scroll to the middle of viewport

"""

include "tooltips.pxi"

from libc.string cimport strdup
from libc.stdint cimport uintptr_t
from cpython cimport Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String
from efl.eo cimport object_from_instance, _object_mapping_register, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni, _touni

from efl.evas cimport Object as evasObject
from object cimport Object
from object_item cimport ObjectItem, _object_item_to_python, \
    elm_object_item_widget_get, _object_item_from_python, \
    _object_item_list_to_python, elm_object_item_data_get
cimport enums

import traceback

from efl.utils.deprecated cimport DEPRECATED
from scroller cimport elm_scroller_policy_get, elm_scroller_policy_set, \
    elm_scroller_bounce_get, elm_scroller_bounce_set, Elm_Scroller_Policy


ELM_GENLIST_ITEM_SCROLLTO_NONE = enums.ELM_GENLIST_ITEM_SCROLLTO_NONE
ELM_GENLIST_ITEM_SCROLLTO_IN = enums.ELM_GENLIST_ITEM_SCROLLTO_IN
ELM_GENLIST_ITEM_SCROLLTO_TOP = enums.ELM_GENLIST_ITEM_SCROLLTO_TOP
ELM_GENLIST_ITEM_SCROLLTO_MIDDLE = enums.ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

def _cb_object_item_conv(uintptr_t addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef char *_py_elm_gengrid_item_text_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GengridItem item = <GengridItem>data
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

cdef Evas_Object *_py_elm_gengrid_item_content_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GengridItem item = <GengridItem>data
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

cdef Eina_Bool _py_elm_gengrid_item_state_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef:
        GengridItem item = <GengridItem>data
        unicode u = _ctouni(part)

    func = item.item_class._state_get_func
    if func is None:
        return 0

    try:
        o = object_from_instance(obj)
        ret = func(o, part, item.item_data)
    except:
        traceback.print_exc()
        return 0

    return ret if ret is not None else 0

cdef void _py_elm_gengrid_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GengridItem item = <GengridItem>data

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

cdef void _py_elm_gengrid_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GengridItem item

    assert data != NULL, "data is NULL in Gengrid select cb"

    item = <GengridItem>data

    if item.cb_func is not None:
        try:
            o = object_from_instance(obj)
            item.cb_func(item, o, item.func_data)
        except:
            traceback.print_exc()

cdef int _gengrid_compare_cb(const_void *data1, const_void *data2) with gil:
    cdef:
        Elm_Object_Item *citem1 = <Elm_Object_Item *>data1
        Elm_Object_Item *citem2 = <Elm_Object_Item *>data2
        GengridItem item1 = <GengridItem>elm_object_item_data_get(citem1)
        GengridItem item2 = <GengridItem>elm_object_item_data_get(citem2)
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

include "gengrid_widget.pxi"
include "gengrid_item_class.pxi"
include "gengrid_item.pxi"
