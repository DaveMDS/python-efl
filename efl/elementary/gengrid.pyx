# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
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
:py:class:`efl.elementary.genlist.Genlist`: the user defines a **class** for
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
:py:class:`Scrollable<efl.elementary.scroller.Scrollable>` class
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
:py:class:`elementary.theme.Theme` for more details).

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
  when done. See #Elm_Gengrid_Item_Text_Get_Cb.
- ``func.content_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to elm_gengrid_item_append() and related item creation
  functions. The ``obj`` parameter is the gengrid object itself, while
  the ``part`` one is the name string of one of the existing (content)
  swallow parts in the Edje group implementing the item's theme. It must
  return ``None,`` when no content is desired, or a valid object handle,
  otherwise. The object will be deleted by the gengrid on its deletion
  or when the item is "unrealized". See #Elm_Gengrid_Item_Content_Get_Cb.
- ``func.state_get`` - This function is called when an item object is
  actually created. The ``data`` parameter will point to the same data
  passed to elm_gengrid_item_append() and related item creation
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
  #Elm_Gengrid_Item_Del_Cb.

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
  caller **not** to use the object pointer returned from
  elm_gengrid_item_object_get(), because it may point to freed
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

include "callback_conversions.pxi"
include "tooltips.pxi"

from libc.string cimport strdup
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

cdef char *_py_elm_gengrid_item_text_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GengridItem item = <object>data
    cdef GengridItemClass itc = item.cls

    func = itc._text_get_func
    if func is None:
        return NULL

    try:
        o = object_from_instance(obj)
        ret = func(o, part, item.item_data)
    except:
        traceback.print_exc()
        return NULL

    if isinstance(ret, unicode): ret = PyUnicode_AsUTF8String(ret)
    return strdup(ret) if ret is not None else NULL

cdef Evas_Object *_py_elm_gengrid_item_content_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GengridItem item = <object>data
    cdef evasObject icon
    cdef GengridItemClass itc = item.cls

    func = itc._content_get_func
    if func is None:
        return NULL

    try:
        o = object_from_instance(obj)
        ret = func(o, _ctouni(part), item.item_data)
    except:
        traceback.print_exc()
        return NULL

    if ret is None:
        return NULL

    icon = ret
    return icon.obj

cdef Eina_Bool _py_elm_gengrid_item_state_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GengridItem item = <object>data
    cdef GengridItemClass itc = item.cls

    func = itc._state_get_func
    if func is None:
        return False

    try:
        o = object_from_instance(obj)
        ret = func(o, part, item.item_data)
    except:
        traceback.print_exc()
        return 0

    if ret is not None:
        return bool(ret)
    else:
        return False

cdef void _py_elm_gengrid_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GengridItem item = <object>data
    cdef GengridItemClass itc = item.cls

    if item is None:
        return

    func = itc._del_func
    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, item.item_data)
        except:
            traceback.print_exc()
    item._unset_obj()
    Py_DECREF(item)

cdef void _py_elm_gengrid_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GengridItem item

    print("in item_cb")

    assert data != NULL, "data is NULL in Gengrid select cb"

    item = <GengridItem?>data

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

cdef class GengridItemClass:
    """

    Defines the behavior of each grid item.

    This class should be created and handled to the Gengrid itself.

    It may be subclassed, in this case the methods :py:func:`text_get()`,
    :py:func:`content_get()`, :py:func:`state_get()` and ``delete()`` will be used.

    It may also be instantiated directly, given getters to override as
    constructor parameters.

    """
    cdef Elm_Gengrid_Item_Class obj
    cdef readonly object _item_style
    cdef readonly object _text_get_func
    cdef readonly object _content_get_func
    cdef readonly object _state_get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self._item_style = "default"
        self._text_get_func = None
        self._content_get_func = None
        self._state_get_func = None
        self._del_func = None

        self.obj.item_style = NULL
        self.obj.func.text_get = _py_elm_gengrid_item_text_get
        self.obj.func.content_get = _py_elm_gengrid_item_content_get
        self.obj.func.state_get = _py_elm_gengrid_item_state_get
        self.obj.func.del_ = _py_elm_gengrid_object_item_del

    def __init__(self, item_style=None, text_get_func=None,
                 content_get_func=None, state_get_func=None, del_func=None):
        """GengridItemClass constructor.

        :param item_style: the string that defines the gengrid item
            theme to be used. The corresponding edje group will
            have this as suffix.

        :param text_get_func: if provided will override the
            behavior defined by :py:func:`text_get()` in this class. Its
            purpose is to return the label string to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> str``

        :param content_get_func: if provided will override the behavior
            defined by :py:func:`content_get()` in this class. Its purpose is
            to return the icon object to be used (swalloed) by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> obj``

        :param state_get_func: if provided will override the
            behavior defined by :py:func:`state_get()` in this class. Its
            purpose is to return the boolean state to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> bool``

        :param del_func: if provided will override the behavior
            defined by ``delete()`` in this class. Its purpose is to be
            called when item is deleted, thus finalizing resources
            and similar. This function should have the signature:
            ``func(obj, item_data)``

        .. note:: In all these signatures, 'obj' means Gengrid and
            'item_data' is the value given to Gengrid item append/prepend
            methods, it should represent your item model as you want.
        """
        if text_get_func and not callable(text_get_func):
            raise TypeError("text_get_func is not callable!")
        elif text_get_func:
            self._text_get_func = text_get_func
        else:
            self._text_get_func = self.text_get

        if content_get_func and not callable(content_get_func):
            raise TypeError("content_get_func is not callable!")
        elif content_get_func:
            self._content_get_func = content_get_func
        else:
            self._content_get_func = self.content_get

        if state_get_func and not callable(state_get_func):
            raise TypeError("state_get_func is not callable!")
        elif state_get_func:
            self._state_get_func = state_get_func
        else:
            self._state_get_func = self.state_get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

        a1 = item_style
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if a1 is not None:
            self._item_style = a1
        self.obj.item_style = <char *>self._item_style

    def __str__(self):
        return ("%s(item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Gengrid_Item_Class=%#x, "
                "item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                <unsigned long><void *>self,
                PY_REFCOUNT(self),
                <unsigned long>&self.obj,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    property item_style:
        def __get__(self):
            return self._item_style

    def text_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its label.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: label to be used.
        :rtype: str or None
        """
        return None

    def content_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its icon.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

    def state_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its state.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: boolean state to be used.
        :rtype: bool or None
        """
        return False

cdef class GengridItem(ObjectItem):

    """An item for the :py:class:`Gengrid` widget."""

    cdef:
        object item_data, func_data, compare_func
        GengridItemClass cls

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef void _unset_obj(self):
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL

    def __init__(self, GengridItemClass item_class not None, item_data = None, \
        func = None, func_data = None):
        """

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        """
        if func is not None:
            if not callable(func):
                raise TypeError("func is not None or callable")

        self.cls = item_class
        self.cb_func = func
        self.item_data = item_data
        self.func_data = func_data

    def append_to(self, Gengrid gengrid not None):
        """item_append(Gengrid gengrid) -> GengridItem

        Append a new item (add as last item) to this gengrid.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_append(gengrid.obj,
            &self.cls.obj, <void*>self,
            cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def prepend_to(self, Gengrid gengrid not None):
        """item_prepend(Gengrid gengrid) -> GengridItem

        Prepend a new item (add as first item) to this gengrid.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_prepend(gengrid.obj, &self.cls.obj, <void*>self,
            cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def insert_before(self, GengridItem before not None):
        """insert_before(GengridItem before not None) -> GengridItem

        Insert a new item before another item in this gengrid.

        :param before: a reference item to use, the new item
            will be inserted before it.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            Gengrid gengrid = before.widget

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_insert_before(gengrid.obj, &self.cls.obj,
            <void*>self, before.item, cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def insert_after(self, GengridItem after not None):
        """insert_after(GengridItem after not None) -> GengridItem

        Insert a new item after another item in this gengrid.

        :param after: a reference item to use, the new item
            will be inserted after it.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            Gengrid gengrid = after.widget

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_insert_after(gengrid.obj, &self.cls.obj,
            <void*>self, after.item, cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def sorted_insert(self, Gengrid gengrid not None, compare_func not None):
        """insert_after(GengridItem after not None) -> GengridItem

        Insert a new item after another item in this gengrid.

        :param after: a reference item to use, the new item
            will be inserted after it.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        self.compare_func = compare_func

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_sorted_insert(gengrid.obj, &self.cls.obj,
            <void*>self, _gengrid_compare_cb, cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None



    def __str__(self):
        return "%s(item_class=%s, func=%s, item_data=%s)" % \
               (type(self).__name__,
                type(self.cls).__name__,
                self.cb_func,
                self.item_data)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)") % \
               (type(self).__name__,
                <unsigned long><void*>self,
                PY_REFCOUNT(self),
                <unsigned long>self.item,
                type(self.cls).__name__,
                self.cb_func,
                self.item_data)

    property data:
        """User data for the item."""
        def __get__(self):
            return self.item_data

    def data_get(self):
        return self.item_data

    property next:
        """This returns the item placed after the item, on the container
        gengrid.

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_gengrid_item_next_get(self.item))

    property prev:
        """This returns the item placed before the item, on the container
        gengrid.

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_gengrid_item_prev_get(self.item))

    property index:
        """Get the index of the item. It is only valid once displayed.

        """
        def __get__(self):
            return elm_gengrid_item_index_get(self.item)

    def index_get(self):
        return elm_gengrid_item_index_get(self.item)

    def update(self):
        """update()

        This updates an item by calling all the item class functions
        again to get the contents, texts and states. Use this when the
        original item data has changed and you want the changes to be
        reflected.

        """
        elm_gengrid_item_update(self.item)

    property selected:
        """This sets the selected state of an item. If multi-selection is
        not enabled on the containing gengrid and *selected* is ``True``,
        any other previously selected items will get unselected in favor of
        this new one.

        .. seealso:: :py:func:`item_selected_get()`

        """
        def __get__(self):
            return bool(elm_gengrid_item_selected_get(self.item))

        def __set__(self, selected):
            elm_gengrid_item_selected_set(self.item, bool(selected))

    def selected_set(self, selected):
        elm_gengrid_item_selected_set(self.item, bool(selected))
    def selected_get(self):
        return bool(elm_gengrid_item_selected_get(self.item))

    def show(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """show(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes gengrid to **redraw** its viewport's contents to the
        region containing the given ``item``, if it is not fully
        visible.

        .. seealso:: :py:func:`bring_in()`

        :param type: Where to position the item in the viewport.

        """
        elm_gengrid_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """bring_in(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes gengrid to jump to the item and show
        it (by scrolling), if it is not fully visible. This will use
        animation to do so and take a period of time to complete.

        .. seealso:: :py:func:`show()`

        :param type: Where to position the item in the viewport.

        """
        elm_gengrid_item_bring_in(self.item, scrollto_type)

    property pos:
        def __get__(self):
            cdef unsigned int x, y
            elm_gengrid_item_pos_get(self.item, &x, &y)
            return (x, y)

    def pos_get(self):
        cdef unsigned int x, y
        elm_gengrid_item_pos_get(self.item, &x, &y)
        return (x, y)

    # XXX TODO elm_gengrid_item_item_class_update

    # XXX TODO elm_gengrid_item_item_class_get

    property tooltip_text:
        """Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed.
        Internally, this method calls :py:func:`tooltip_content_cb_set`

        """
        def __set__(self, text):
            if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
            elm_gengrid_item_tooltip_text_set(self.item,
                <const_char *>text if text is not None else NULL)

    def tooltip_text_set(self, text):
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_gengrid_item_tooltip_text_set(self.item,
            <const_char *>text if text is not None else NULL)

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """tooltip_content_cb_set(func, *args, **kargs)

        Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. ``func(args, kargs)`` will
        be called every time that need show the tooltip and it should return a
        valid Evas_Object. This object is then managed fully by tooltip system
        and is deleted when the tooltip is gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, self, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_gengrid_item_tooltip_content_cb_set(self.item,
                                                _tooltip_item_content_create,
                                                cbdata,
                                                _tooltip_item_data_del_cb)

    def item_tooltip_unset(self):
        """item_tooltip_unset()

        Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set`
        the internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but
        no freed.

        """
        elm_gengrid_item_tooltip_unset(self.item)

    property tooltip_style:
        """Style for this object tooltip.

        .. note::: before you set a style you should define a tooltip with
            elm_gengrid_item_tooltip_content_cb_set() or
            elm_gengrid_item_tooltip_text_set()

        """
        def __get__(self):
            return _ctouni(elm_gengrid_item_tooltip_style_get(self.item))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_gengrid_item_tooltip_style_set(self.item,
                <const_char *>style if style is not None else NULL)

    def tooltip_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_gengrid_item_tooltip_style_set(self.item,
            <const_char *>style if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_gengrid_item_tooltip_style_get(self.item))

    property tooltip_window_mode:
        # TODO: document this
        def __get__(self):
            return bool(elm_gengrid_item_tooltip_window_mode_get(self.item))

        def __set__(self, disable):
            elm_gengrid_item_tooltip_window_mode_set(self.item, bool(disable))

    def tooltip_window_mode_set(self, disable):
        elm_gengrid_item_tooltip_window_mode_set(self.item, bool(disable))
    def tooltip_window_mode_get(self):
        return bool(elm_gengrid_item_tooltip_window_mode_get(self.item))

    property cursor:
        """The cursor that will be displayed when mouse is over the item.
        The item can have only one cursor set to it, so if this property is
        set twice for an item, the previous one will be unset.

        """
        def __get__(self):
            return _ctouni(elm_gengrid_item_cursor_get(self.item))

        def __set__(self, cursor):
            if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
            elm_gengrid_item_cursor_set(self.item,
                <const_char *>cursor if cursor is not None else NULL)

        def __del__(self):
            elm_gengrid_item_cursor_unset(self.item)

    def cursor_set(self, cursor):
        if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
        elm_gengrid_item_cursor_set(self.item,
            <const_char *>cursor if cursor is not None else NULL)
    def cursor_get(self):
        return _ctouni(elm_gengrid_item_cursor_get(self.item))
    def cursor_unset(self):
        elm_gengrid_item_cursor_unset(self.item)

    property cursor_style:
        # TODO: document this
        def __get__(self):
            return _ctouni(elm_gengrid_item_cursor_style_get(self.item))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_gengrid_item_cursor_style_set(self.item,
                <const_char *>style if style is not None else NULL)

    def cursor_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_gengrid_item_cursor_style_set(self.item,
            <const_char *>style if style is not None else NULL)
    def cursor_style_get(self):
        return _ctouni(elm_gengrid_item_cursor_style_get(self.item))

    property cursor_engine_only:
        # TODO: document this
        def __get__(self):
            return elm_gengrid_item_cursor_engine_only_get(self.item)

        def __set__(self, engine_only):
            elm_gengrid_item_cursor_engine_only_set(self.item, bool(engine_only))

    def cursor_engine_only_set(self, engine_only):
        elm_gengrid_item_cursor_engine_only_set(self.item, bool(engine_only))
    def cursor_engine_only_get(self):
        return elm_gengrid_item_cursor_engine_only_get(self.item)

    property select_mode:
        # TODO: document this
        def __get__(self):
            return elm_gengrid_item_select_mode_get(self.item)

        def __set__(self, mode):
            elm_gengrid_item_select_mode_set(self.item, mode)

    def select_mode_set(self, mode):
        elm_gengrid_item_select_mode_set(self.item, mode)
    def select_mode_get(self):
        return elm_gengrid_item_select_mode_get(self.item)

cdef class Gengrid(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_gengrid_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def clear(self):
        """clear()

        Remove all items from a given gengrid widget."""
        elm_gengrid_clear(self.obj)

    property multi_select:
        """Multi-selection is the ability to have **more** than one
        item selected, on a given gengrid, simultaneously. When it is
        enabled, a sequence of clicks on different items will make them
        all selected, progressively. A click on an already selected item
        will unselect it. If interacting via the keyboard,
        multi-selection is enabled while holding the "Shift" key.

        .. note:: By default, multi-selection is **disabled** on gengrids.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_multi_select_get(self.obj))

        def __set__(self, multi):
            elm_gengrid_multi_select_set(self.obj, bool(multi))

    def multi_select_set(self, multi):
        elm_gengrid_multi_select_set(self.obj, bool(multi))
    def multi_select_get(self):
        return bool(elm_gengrid_multi_select_get(self.obj))

    property horizontal:
        """When in "horizontal mode" (``True),`` items will be placed
        in **columns**, from top to bottom and, when the space for a
        column is filled, another one is started on the right, thus
        expanding the grid horizontally. When in "vertical mode"
        (``False),`` though, items will be placed in **rows**, from left
        to right and, when the space for a row is filled, another one is
        started below, thus expanding the grid vertically.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_horizontal_get(self.obj))

        def __set__(self, setting):
            elm_gengrid_horizontal_set(self.obj, bool(setting))

    def horizontal_set(self, setting):
        elm_gengrid_horizontal_set(self.obj, bool(setting))
    def horizontal_get(self):
        return bool(elm_gengrid_horizontal_get(self.obj))

    def item_append(self, GengridItemClass item_class not None,
                    item_data, func=None):
        """item_append(self, GengridItemClass item_class, item_data, func=None) -> GengridItem

        Append a new item (add as last item) to this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .append_to(self)

    def item_prepend(self, GengridItemClass item_class not None,
                     item_data, func=None):
        """item_prepend(self, GengridItemClass item_class, item_data, func=None) -> GengridItem

        Prepend a new item (add as first item) to this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .prepend_to(self)

    def item_insert_before(self, GengridItemClass item_class not None,
                           item_data, GengridItem before_item=None,
                           func=None):
        """item_insert_before(self, GengridItemClass item_class, item_data, GengridItem before_item=None, func=None) -> GengridItem

        Insert a new item before another item in this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param before_item: a reference item to use, the new item
            will be inserted before it.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .insert_before(before_item)

    def item_insert_after(self, GengridItemClass item_class not None,
                          item_data, GengridItem after_item=None,
                          func=None):
        """item_insert_after(self, GengridItemClass item_class, item_data, GengridItem after_item=None, func=None) -> GengridItem

        Insert a new item after another item in this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param after_item: a reference item to use, the new item
            will be inserted after it.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .insert_before(after_item)

    # XXX TODO elm_gengrid_item_sorted_insert()

    property selected_item:
        """This returns the selected item in ``obj``. If multi selection is
        enabled on ``obj`` (.. seealso:: :py:func:`multi_select_set()),` only
        the first item in the list is selected, which might not be very
        useful. For that case, see elm_gengrid_selected_items_get().

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_gengrid_selected_item_get(self.obj))

    property selected_items:
        """This returns a tuple of the selected items, in the order that they
        appear in the grid.

        .. seealso:: :py:attr:`selected_item`

        :type: tuple of :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_gengrid_selected_items_get(self.obj))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_gengrid_selected_items_get(self.obj))

    property realized_items:
        """This returns a tuple of the realized items in the gengrid.

        .. seealso:: :py:func:`realized_items_update()`

        :type: tuple of :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_gengrid_realized_items_get(self.obj))

    def realized_items_get(self):
        return _object_item_list_to_python(elm_gengrid_realized_items_get(self.obj))

    def realized_items_update(self):
        """realized_items_update()

        This updates all realized items by calling all the item class
        functions again to get the contents, texts and states. Use this when
        the original item data has changed and the changes are desired to be
        reflected.

        To update just one item, use elm_gengrid_item_update().

        .. seealso:: :py:attr:`realized_items` :py:func:`GengridItem.update()`

        """
        elm_gengrid_realized_items_update(self.obj)

    property first_item:
        """Get the first item in the gengrid widget.

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_gengrid_first_item_get(self.obj))

    property last_item:
        """Get the last item in the gengrid widget.

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_gengrid_last_item_get(self.obj))

    property items_count:
        """Return how many items are currently in a list.

        :type: int

        """
        def __get__(self):
            return elm_gengrid_items_count(self.obj)

    property item_size:
        """A gengrid, after creation, has still no information on the size
        to give to each of its cells. So, you most probably will end up
        with squares one :ref:`Fingers` "finger" wide, the default
        size. Use this property to force a custom size for you items,
        making them as big as you wish.

        """
        def __get__(self):
            cdef Evas_Coord x, y
            elm_gengrid_item_size_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, value):
            w, h = value
            elm_gengrid_item_size_set(self.obj, w, h)

    def item_size_set(self, w, h):
        elm_gengrid_item_size_set(self.obj, w, h)
    def item_size_get(self):
        cdef Evas_Coord x, y
        elm_gengrid_item_size_get(self.obj, &x, &y)
        return (x, y)

    property group_item_size:
        """A gengrid, after creation, has still no information on the size
        to give to each of its cells. So, you most probably will end up
        with squares one "finger" wide, the default
        size. Use this function to force a custom size for you group items,
        making them as big as you wish.

        """
        def __get__(self):
            cdef Evas_Coord w, h
            elm_gengrid_group_item_size_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, value):
            w, h = value
            elm_gengrid_group_item_size_set(self.obj, w, h)

    def group_item_size_set(self, w, h):
        elm_gengrid_group_item_size_set(self.obj, w, h)
    def group_item_size_get(self):
        cdef Evas_Coord w, h
        elm_gengrid_group_item_size_get(self.obj, &w, &h)
        return (w, h)

    property align:
        """This sets the alignment of the whole grid of items of a gengrid
        within its given viewport. By default, those values are both
        0.5, meaning that the gengrid will have its items grid placed
        exactly in the middle of its viewport.

        .. note:: If given alignment values are out of the cited ranges,
            they'll be changed to the nearest boundary values on the valid
            ranges.

        :type: tuple of floats

        """
        def __get__(self):
            cdef double align_x, align_y
            elm_gengrid_align_get(self.obj, &align_x, &align_y)
            return (align_x, align_y)

        def __set__(self, value):
            align_x, align_y = value
            elm_gengrid_align_set(self.obj, align_x, align_y)

    def align_set(self, align_x, align_y):
        elm_gengrid_align_set(self.obj, align_x, align_y)
    def align_get(self):
        cdef double align_x, align_y
        elm_gengrid_align_get(self.obj, &align_x, &align_y)
        return (align_x, align_y)

    property reorder_mode:
        """If a gengrid is set to allow reordering, a click held for more
        than 0.5 over a given item will highlight it specially,
        signaling the gengrid has entered the reordering state. From
        that time on, the user will be able to, while still holding the
        mouse button down, move the item freely in the gengrid's
        viewport, replacing to said item to the locations it goes to.
        The replacements will be animated and, whenever the user
        releases the mouse button, the item being replaced gets a new
        definitive place in the grid.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_reorder_mode_get(self.obj))

        def __set__(self, mode):
            elm_gengrid_reorder_mode_set(self.obj, bool(mode))

    def reorder_mode_set(self, mode):
        elm_gengrid_reorder_mode_set(self.obj, bool(mode))
    def reorder_mode_get(self, mode):
        return bool(elm_gengrid_reorder_mode_get(self.obj))

    property filled:
        """The fill state of the whole grid of items of a gengrid
        within its given viewport. By default, this value is False, meaning
        that if the first line of items grid's isn't filled, the items are
        centered with the alignment.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_filled_get(self.obj))

        def __set__(self, fill):
            elm_gengrid_filled_set(self.obj, bool(fill))

    def filled_set(self, fill):
        elm_gengrid_filled_set(self.obj, bool(fill))
    def filled_get(self, fill):
        return bool(elm_gengrid_filled_get(self.obj))

    property select_mode:
        """Item select mode in the gengrid widget. Possible values are:

        - ELM_OBJECT_SELECT_MODE_DEFAULT : Items will only call their
            selection func and callback when first becoming selected. Any
            further clicks will do nothing, unless you set always select mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS :  This means that, even if selected,
            every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability to
            select items entirely and they will neither appear selected nor
            call selected callback functions.

        """
        def __get__(self):
            return elm_gengrid_select_mode_get(self.obj)

        def __set__(self, mode):
            elm_gengrid_select_mode_set(self.obj, mode)

    def select_mode_set(self, mode):
        elm_gengrid_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_gengrid_select_mode_get(self.obj)

    property highlight_mode:
        """This will turn on/off the highlight effect when items are
        selected and they will or will not be highlighted. The selected and
        clicked callback functions will still be called.

        Highlight is enabled by default.

        """
        def __get__(self):
            return bool(elm_gengrid_highlight_mode_get(self.obj))

        def __set__(self, highlight):
            elm_gengrid_highlight_mode_set(self.obj, bool(highlight))

    def highlight_mode_set(self, highlight):
        elm_gengrid_highlight_mode_set(self.obj, bool(highlight))
    def highlight_mode_get(self, fill):
        return bool(elm_gengrid_highlight_mode_get(self.obj))

    def nth_item_get(self, unsigned int nth):
        """nth_item_get(int nth) -> :py:class:`GengridItem`

        Get the nth item, in a given gengrid widget, placed at position
        ``nth``, in its internal items list

        :param nth: The number of the item to grab (0 being the first)

        :return: The item stored in the object at position ``nth`` or
            ``None``, if there's no item with that index (and on errors)

        :since: 1.8

        """
        return _object_item_to_python(elm_gengrid_nth_item_get(self.obj, nth))

    def at_xy_item_get(self, int x, int y):
        """at_xy_item_get(int x, int y) -> (GengridItem, int xposret, int yposret)

        Get the item that is at the x, y canvas coords.

        :param x: The input x coordinate
        :param y: The input y coordinate
        :return: (:py:class:`GengridItem`, **int** xposret, **int** yposret)

        This returns the item at the given coordinates (which are canvas
        relative, not object-relative). If an item is at that coordinate,
        that item handle is returned, and if @p xposret is not NULL, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the left portion of that item (-1), on the
        middle section (0) or on the right part (1).
        if @p yposret is not NULL, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the upper portion of that item (-1), on the
        middle section (0) or on the lower part (1). If NULL is returned as
        an item (no item found there), then posret may indicate -1 or 1
        based if the coordinate is above or below all items respectively in
        the gengrid.

        """
        cdef:
            int xposret, yposret
            Elm_Object_Item *ret

        ret = elm_gengrid_at_xy_item_get(self.obj, x, y, &xposret, &yposret)
        return _object_item_to_python(ret), xposret, yposret

    def callback_activated_add(self, func, *args, **kwargs):
        self._callback_add_full("activated", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated", _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double", _cb_object_item_conv, func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del_full("clicked", _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected",  _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected", _cb_object_item_conv, func)

    def callback_realized_add(self, func, *args, **kwargs):
        """This is called when the item in the gengrid
        has its implementing Evas object instantiated, de facto.
        ``event_info`` is the gengrid item that was created. The object
        may be deleted at any time, so it is highly advised to the
        caller **not** to use the object pointer returned from
        elm_gengrid_item_object_get(), because it may point to freed
        objects."""
        self._callback_add_full("realized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_realized_del(self, func):
        self._callback_del_full("realized", _cb_object_item_conv, func)

    def callback_unrealized_add(self, func, *args, **kwargs):
        """This is called when the implementing Evas
        object for this item is deleted. ``event_info`` is the gengrid
        item that was deleted."""
        self._callback_add_full("unrealized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unrealized_del(self, func):
        self._callback_del_full("unrealized", _cb_object_item_conv, func)

    def callback_changed_add(self, func, *args, **kwargs):
        """Called when an item is added, removed, resized
        or moved and when the gengrid is resized or gets "horizontal"
        property changes."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        """This is called when scrolling animation has
        started."""
        self._callback_add("scroll,anim,start", func, *args, **kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        """This is called when scrolling animation has
        stopped."""
        self._callback_add("scroll,anim,stop", func, *args, **kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_drag_start_up_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) up."""
        self._callback_add("drag,start,up", func, *args, **kwargs)

    def callback_drag_start_up_del(self, func):
        self._callback_del("drag,start,up", func)

    def callback_drag_start_down_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) down."""
        self._callback_add("drag,start,down", func, *args, **kwargs)

    def callback_drag_start_down_del(self, func):
        self._callback_del("drag,start,down", func)

    def callback_drag_start_left_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) left."""
        self._callback_add("drag,start,left", func, *args, **kwargs)

    def callback_drag_start_left_del(self, func):
        self._callback_del("drag,start,left", func)

    def callback_drag_start_right_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) right."""
        self._callback_add("drag,start,right", func, *args, **kwargs)

    def callback_drag_start_right_del(self, func):
        self._callback_del("drag,start,right", func)

    def callback_drag_stop_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        stopped being dragged."""
        self._callback_add("drag,stop", func, *args, **kwargs)

    def callback_drag_stop_del(self, func):
        self._callback_del("drag,stop", func)

    def callback_drag_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid is being
        dragged."""
        self._callback_add("drag", func, *args, **kwargs)

    def callback_drag_del(self, func):
        self._callback_del("drag", func)

    def callback_scroll_add(self, func, *args, **kwargs):
        """called when the content has been scrolled
        (moved)."""
        self._callback_add("scroll", func, *args, **kwargs)

    def callback_scroll_del(self, func):
        self._callback_del("scroll", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        """called when dragging the content has
        started."""
        self._callback_add("scroll,drag,start", func, *args, **kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        """called when dragging the content has
        stopped."""
        self._callback_add("scroll,drag,stop", func, *args, **kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled until
        the top edge."""
        self._callback_add("edge,top", func, *args, **kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top", func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the bottom edge."""
        self._callback_add("edge,bottom", func, *args, **kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom", func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the left edge."""
        self._callback_add("edge,left", func, *args, **kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left", func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the right edge."""
        self._callback_add("edge,right", func, *args, **kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right", func)

    def callback_moved_add(self, func, *args, **kwargs):
        """This is called when a gengrid item is moved by a user
        interaction in a reorder mode. The %c event_info parameter is the item that
        was moved."""
        self._callback_add_full("moved", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_del(self, func):
        self._callback_del_full("moved", _cb_object_item_conv, func)

    def callback_index_update_add(self, func, *args, **kwargs):
        """This is called when a gengrid item index is changed.
        Note that this callback is called while each item is being realized."""
        self._callback_add("index,update", func, *args, **kwargs)

    def callback_index_update_del(self, func):
        self._callback_del("index,update", func)

    def callback_highlighted_add(self, func, *args, **kwargs):
        """an item in the list is highlighted. This is called when
        the user presses an item or keyboard selection is done so the item is
        physically highlighted. The %c event_info parameter is the item that was
        highlighted."""
        self._callback_add_full("highlighted", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_highlighted_del(self, func):
        self._callback_del_full("highlighted", _cb_object_item_conv, func)

    def callback_unhighlighted_add(self, func, *args, **kwargs):
        """an item in the list is unhighlighted. This is called
        when the user releases an item or keyboard selection is moved so the item
        is physically unhighlighted. The %c event_info parameter is the item that
        was unhighlighted."""
        self._callback_add_full("unhighlighted", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unhighlighted_del(self, func):
        self._callback_del_full("unhighlighted", _cb_object_item_conv, func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """This is called when the program's language is
        changed. Call the elm_gengrid_realized_items_update() if items text should
        be translated."""
        self.callback_add("language,changed", func, *args, **kwargs)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the gengrid has received focus.

        :since: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the gengrid has lost focus.

        :since: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)


    property scroller_policy:
        def __get__(self):
            return self.scroller_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scroller_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)


_object_mapping_register("Elm_Gengrid", Gengrid)
