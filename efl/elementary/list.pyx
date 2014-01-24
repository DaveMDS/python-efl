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

.. image:: /images/list-preview.png

Widget description
------------------

A list widget is a container whose children are displayed vertically or
horizontally, in order, and can be selected.
The list can accept only one or multiple items selection. Also has many
modes of items displaying.

A list is a very simple type of list widget.  For more robust
lists, :py:class:`~efl.elementary.genlist.Genlist` should probably be used.

Smart callbacks one can listen to:

- ``activated`` - The user has double-clicked or pressed
    (enter|return|spacebar) on an item. The ``event_info`` parameter
    is the item that was activated.
- ``clicked,double`` - The user has double-clicked an item.
    The ``event_info`` parameter is the item that was double-clicked.
- ``selected`` - when the user selected an item
- ``unselected`` - when the user unselected an item
- ``longpressed`` - an item in the list is long-pressed
- ``edge,top`` - the list is scrolled until the top edge
- ``edge,bottom`` - the list is scrolled until the bottom edge
- ``edge,left`` - the list is scrolled until the left edge
- ``edge,right`` - the list is scrolled until the right edge
- ``highlighted`` - an item in the list is highlighted. This is called when
  the user presses an item or keyboard selection is done so the item is
  physically highlighted. The %c event_info parameter is the item that was
  highlighted.
- ``unhighlighted`` - an item in the list is unhighlighted. This is called
  when the user releases an item or keyboard selection is moved so the item
  is physically unhighlighted. The %c event_info parameter is the item that
  was unhighlighted.
- ``language,changed`` - the program's language changed
- ``focused`` - When the list has received focus. (since 1.8)
- ``unfocused`` - When the list has lost focus. (since 1.8)

Available styles for it:

- ``default``

Default content parts of the list items that you can use for are:

- ``start`` - A start position object in the list item
- ``end`` - A end position object in the list item

Default text parts of the list items that you can use for are:

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
------------

.. _Elm_List_Mode:

List sizing modes
=================

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


.. _Elm_List_Object_Select_Mode:

Selection modes
===============

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Items will only call their selection func and callback when
    first becoming selected. Any further clicks will do nothing,
    unless you set always select mode.

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    This means that, even if selected, every click will make the
    selected callbacks be called.

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    This will turn off the ability to select items entirely and
    they will neither appear selected nor call selected callback
    functions.

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


"""

from cpython cimport PyUnicode_AsUTF8String, Py_DECREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, object_from_instance, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object
from object_item cimport _object_item_callback, _object_item_callback2, \
    _object_item_to_python, _object_item_list_to_python

from efl.utils.deprecated cimport DEPRECATED
from scroller cimport elm_scroller_policy_get, elm_scroller_policy_set, \
    elm_scroller_bounce_get, elm_scroller_bounce_set, Elm_Scroller_Policy

cimport enums

ELM_LIST_COMPRESS = enums.ELM_LIST_COMPRESS
ELM_LIST_SCROLL = enums.ELM_LIST_SCROLL
ELM_LIST_LIMIT = enums.ELM_LIST_LIMIT
ELM_LIST_EXPAND = enums.ELM_LIST_EXPAND

ELM_OBJECT_SELECT_MODE_DEFAULT = enums.ELM_OBJECT_SELECT_MODE_DEFAULT
ELM_OBJECT_SELECT_MODE_ALWAYS = enums.ELM_OBJECT_SELECT_MODE_ALWAYS
ELM_OBJECT_SELECT_MODE_NONE = enums.ELM_OBJECT_SELECT_MODE_NONE
ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY = enums.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
ELM_OBJECT_SELECT_MODE_MAX = enums.ELM_OBJECT_SELECT_MODE_MAX

ELM_SCROLLER_POLICY_AUTO = enums.ELM_SCROLLER_POLICY_AUTO
ELM_SCROLLER_POLICY_ON = enums.ELM_SCROLLER_POLICY_ON
ELM_SCROLLER_POLICY_OFF = enums.ELM_SCROLLER_POLICY_OFF

def _cb_object_item_conv(uintptr_t addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef class ListItem(ObjectItem):

    """An item for the list widget."""
    cdef:
        object label
        Evas_Object *icon_obj
        Evas_Object *end_obj

    def __init__(self, label = None, evasObject icon = None,
        evasObject end = None, callback = None, cb_data = None, *args, **kargs):
        """Create a new ListItem

        :param string label: The label of the list item.
        :param  icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type   icon: :py:class:`~efl.evas.Object`
        :param   end: The icon object to use for the right side of the item. An
            icon can be any Evas object.
        :type    end: :py:class:`~efl.evas.Object`
        :param callable callback: The function to call when the item is clicked.
        :param cb_data: An object associated with the callback.

        """
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label

        if icon is not None:
            self.icon_obj = icon.obj
        if end is not None:
            self.end_obj = end.obj

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kargs

    def __repr__(self):
        return ("<%s at %#x (refcount=%d, item=%#x, "
                "label=%r, icon=%s, end=%s, "
                "callback=%r, cb_data=%r, "
                "args=%r, kargs=%r)>") % (
        type(self).__name__,
        <uintptr_t><void *>self,
        PY_REFCOUNT(self),
        <uintptr_t><void *>self.item,
        self.text,
        getattr(self.part_content_get("icon"), "file", None),
        getattr(self.part_content_get("end"), "file", None),
        self.cb_func, self.cb_data,
        self.args, self.kwargs)

    def append_to(self, List list):
        """append_to(List list)

        Append a new item to the list object.

        A new item will be created and appended to the list, i.e., will
        be set as **last** item.

        Items created with this method can be deleted with
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`.

        If a function is passed as argument, it will be called every time this item
        is selected, i.e., the user clicks over an unselected item.
        If always select is enabled it will call this function every time
        user clicks over an item (already selected or not).

        Simple example (with no function callback or data associated)::

            li = List(win)
            ic = Icon(win)
            ic.file = "path/to/image"
            ic.resizable = (True, True)
            ListItem("label", ic).append_to(li)
            li.go()
            li.show()

        .. seealso::
            :py:attr:`List.select_mode`
            :py:meth:`~efl.elementary.object_item.ObjectItem.delete`
            :py:func:`List.clear()`
            :py:class:`~efl.elementary.icon.Icon`

        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_list_item_append(list.obj,
            <const_char *>self.label if self.label is not None else NULL,
            self.icon_obj, self.end_obj,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, List list):
        """prepend_to(List list)

        Prepend a new item to the list object.

        .. seealso::
            :py:meth:`append_to`
            :py:attr:`List.select_mode`
            :py:meth:`efl.elementary.object_item.ObjectItem.delete`
            :py:meth:`List.clear`
            :py:class:`~efl.elementary.icon.Icon`

        :param list: The list
        :type  list: List

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_list_item_prepend(   list.obj,
            <const_char *>self.label if self.label is not None else NULL,
            self.icon_obj, self.end_obj,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, ListItem before):
        """insert_before(ListItem before)

        Insert a new item into the list object before item *before*.

        .. seealso::
            :py:meth:`append_to`
            :py:attr:`List.select_mode`
            :py:meth:`efl.elementary.object_item.ObjectItem.delete`
            :py:meth:`List.clear`
            :py:class:`~efl.elementary.icon.Icon`

        :param before: The list item to insert before.
        :type  before: :py:class:`ListItem`

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        cdef List list = before.widget
        item = elm_list_item_insert_before( list.obj,
            before.item,
            <const_char *>self.label if self.label is not None else NULL,
            self.icon_obj, self.end_obj,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, ListItem after):
        """insert_after(ListItem after)

        Insert a new item into the list object after item *after*.

        .. seealso::
            :py:meth:`append_to`
            :py:attr:`List.select_mode`
            :py:meth:`efl.elementary.object_item.ObjectItem.delete`
            :py:meth:`List.clear`
            :py:class:`~efl.elementary.icon.Icon`

        :param after: The list item to insert after.
        :type after: :py:class:`ListItem`

        :return:      The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        cdef List list = after.widget
        item = elm_list_item_insert_after(  list.obj,
            after.item,
            <const_char *>self.label if self.label is not None else NULL,
            self.icon_obj, self.end_obj,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    # TODO:
    # def sorted_insert_to(self, List list, cmp_func=None):
    #     """Insert a new item into the sorted list object.

    #     .. seealso::
    #         :py:func:`append_to()`
    #         :py:attr:`List.select_mode`
    #         :py:func:`efl.elementary.object_item.ObjectItem.delete()`
    #         :py:func:`List.clear()`
    #         :py:class:`Icon <efl.elementary.icon.Icon>`

    #     .. note:: This function inserts values into a list object assuming
    #         it was sorted and the result will be sorted.

    #     :param cmp_func: The comparing function to be used to sort list
    #                      items **by :py:class:`ListItem` handles**. This
    #                      function will receive two items and compare them,
    #                      returning a non-negative integer if the second item
    #                      should be place after the first, or negative value
    #                      if should be placed before.
    #     :type  cmp_func: function

    #     :return:        The created item or ``None`` upon failure.
    #     :rtype:         :py:class:`ListItem`

    #     """
    #     cdef Elm_Object_Item *item

    #     item = elm_list_item_sorted_insert(list.obj,
    #         <const_char *>self.label if self.label is not None else NULL,
    #         icon_obj,
    #         end_obj,
    #         cb,
    #         <void*>self,
    #         cmp_f)

    #     if item != NULL:
    #         self._set_obj(item)
    #         return self
    #     else:
    #         Py_DECREF(self)

    property selected:
        """The selected state of an item.

        This property is the selected state of the given item.
        ``True`` for selected, ``False`` for not selected.

        If a new item is selected the previously selected will be unselected,
        unless multiple selection is enabled with
        :py:attr:`List.multi_select`. Previously selected item can be get
        with :py:func:`List.selected_item`.

        Selected items will be highlighted.

        .. seealso::
            :py:attr:`List.selected_item`
            :py:attr:`List.multi_select`

        :type: bool

        """
        def __get__(self):
            return bool(elm_list_item_selected_get(self.item))

        def __set__(self, selected):
            elm_list_item_selected_set(self.item, selected)

    def selected_get(self):
        return bool(elm_list_item_selected_get(self.item))
    def selected_set(self, selected):
        elm_list_item_selected_set(self.item, selected)

    property separator:
        """Set or unset item as a separator.

        Items aren't set as separator by default.

        If set as separator it will display separator theme, so won't display
        icons or label.

        :type: bool

        """
        def __get__(self):
            return bool(elm_list_item_separator_get(self.item))

        def __set__(self, separator):
            elm_list_item_separator_set(self.item, separator)

    def separator_set(self, separator):
        elm_list_item_separator_set(self.item, separator)
    def separator_get(self):
        return bool(elm_list_item_separator_get(self.item))

    def show(self):
        """show()

        Show the item in the list view.

        It won't animate list until item is visible. If such behavior is
        wanted, use :py:meth:`bring_in` instead.

        """
        elm_list_item_show(self.item)

    def bring_in(self):
        """bring_in()

        Bring in the given item to list view.

        This causes list to jump to the given item and show it
        (by scrolling), if it is not fully visible.

        This may use animation to do so and take a period of time.

        If animation isn't wanted, :py:meth:`show` can be used.

        """
        elm_list_item_bring_in(self.item)

    property object:
        """Returns the base object set for this list item.

        Base object is the one that visually represents the list item
        row. It must not be changed in a way that breaks the list
        behavior (like deleting the base!), but it might be used to
        feed Edje signals to add more features to row representation.

        :type: :py:class:`efl.edje.Edje`

        """
        def __get__(self):
            return object_from_instance(elm_list_item_object_get(self.item))

    def object_get(self):
        return object_from_instance(elm_list_item_object_get(self.item))

    property prev:
        """The item before this item in the list.

        .. note:: If the item is the first item, ``None`` will be returned.

        .. seealso::
            :py:meth:`append_to`
            :py:attr:`List.items`

        :type: :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_list_item_prev(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_list_item_prev(self.item))

    property next:
        """The item after this item in the list.

        .. note:: If the item is the last item, ``None`` will be returned.

        .. seealso::
            :py:func:`append_to()`
            :py:attr:`List.items`

        :type: :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_list_item_next(self.item))

    def next_get(self):
        return _object_item_to_python(elm_list_item_next(self.item))


cdef class List(Object):

    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_list_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def go(self):
        """go()

        Starts the list.

        Example::

            li = List(win)
            ListItem("First").append_to(li)
            ListItem("Second").append_to(li)
            li.go()
            li.show()

        .. note:: Call before running :py:meth:`~efl.evas.Object.show` on the list object.
        .. warning:: If not called, it won't display the list properly.

        """
        elm_list_go(self.obj)

    property multi_select:
        """Enable or disable multiple items selection on the list object.

        Disabled by default. If disabled, the user can select a single item of
        the list each time. Selected items are highlighted on list.
        If enabled, many items can be selected.

        If a selected item is selected again, it will be unselected.

        :type: bool

        """
        def __get__(self):
            return elm_list_multi_select_get(self.obj)

        def __set__(self, multi):
            elm_list_multi_select_set(self.obj, multi)

    def multi_select_set(self, multi):
        elm_list_multi_select_set(self.obj, multi)
    def multi_select_get(self):
        return bool(elm_list_multi_select_get(self.obj))

    property mode:
        """Which mode to use for the list object.

        The list's resize behavior, transverse axis scroll and
        items cropping. See each mode's description for more details.

        Only one can be set, if a previous one was set, it will be changed
        by the new mode set. Bitmask won't work as well.

        .. note:: Default value is ELM_LIST_SCROLL.

        :type: :ref:`Elm_List_Mode`

        """
        def __get__(self):
            return elm_list_mode_get(self.obj)

        def __set__(self, Elm_List_Mode mode):
            elm_list_mode_set(self.obj, mode)

    def mode_set(self, Elm_List_Mode mode):
        elm_list_mode_set(self.obj, mode)
    def mode_get(self):
        return elm_list_mode_get(self.obj)

    property horizontal:
        """Enable or disable horizontal mode on the list object.

        .. note:: Vertical mode is set by default.

        On horizontal mode items are displayed on list from left to right,
        instead of from top to bottom. Also, the list will scroll horizontally.
        Each item will presents left icon on top and right icon, or end, at
        the bottom.

        :type: bool

        """
        def __get__(self):
            return elm_list_horizontal_get(self.obj)

        def __set__(self, horizontal):
            elm_list_horizontal_set(self.obj, horizontal)

    property select_mode:
        """The list select mode.

        :type: :ref:`Elm_List_Object_Select_Mode`

        """
        def __set__(self, mode):
            elm_list_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_list_select_mode_get(self.obj)

    def select_mode_set(self, mode):
        elm_list_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_list_select_mode_get(self.obj)

    def item_append(self, label = None, evasObject icon = None,
        evasObject end = None, callback = None, *args, **kargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            ListItem ret = ListItem.__new__(ListItem)

        if callback is not None:
            if not callable(callback):
                raise TypeError
            ret.cb_func = callback

            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_list_item_append(self.obj,
            <const_char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            end.obj if end is not None else NULL,
            cb, <void*>self)

        if item != NULL:
            ret._set_obj(item)
            ret.args = args
            ret.kwargs = kargs
            return ret
        else:
            return None

    def item_prepend(self, label = None, evasObject icon = None,
        evasObject end = None, callback = None, *args, **kargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            ListItem ret = ListItem.__new__(ListItem)

        if callback is not None:
            if not callable(callback):
                raise TypeError
            ret.cb_func = callback

            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_list_item_prepend(self.obj,
            <const_char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            end.obj if end is not None else NULL,
            cb, <void*>self)

        if item != NULL:
            ret._set_obj(item)
            ret.args = args
            ret.kwargs = kargs
            return ret
        else:
            return None

    def item_insert_before(self, ListItem before not None, label = None,
        evasObject icon = None, evasObject end = None, callback = None,
        *args, **kargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            ListItem ret = ListItem.__new__(ListItem)

        if callback is not None:
            if not callable(callback):
                raise TypeError
            ret.cb_func = callback

            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_list_item_insert_before(self.obj,
            before.item,
            <const_char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            end.obj if end is not None else NULL,
            cb, <void*>self)

        if item != NULL:
            ret._set_obj(item)
            ret.args = args
            ret.kwargs = kargs
            return ret
        else:
            return None

    def item_insert_after(self, ListItem after not None, label = None,
        evasObject icon = None, evasObject end = None, callback = None,
        *args, **kargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            ListItem ret = ListItem.__new__(ListItem)

        if callback is not None:
            if not callable(callback):
                raise TypeError
            ret.cb_func = callback

            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_list_item_insert_after(self.obj,
            after.item,
            <const_char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            end.obj if end is not None else NULL,
            cb, <void*>self)

        if item != NULL:
            ret._set_obj(item)
            ret.args = args
            ret.kwargs = kargs
            return ret
        else:
            return None

    def clear(self):
        """clear()

        Remove all list's items.

        .. seealso::
            :py:meth:`~efl.elementary.object_item.ObjectItem.delete`
            :py:meth:`ListItem.append_to`

        """
        elm_list_clear(self.obj)

    property items:
        """Get a list of all the list items.

        .. seealso::
            :py:meth:`ListItem.append_to`
            :py:meth:`~efl.elementary.object_item.ObjectItem.delete`
            :py:meth:`clear`

        :type: tuple of :py:class:`List items <ListItem>`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_list_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_list_items_get(self.obj))

    property selected_item:
        """Get the selected item.

        The selected item can be unselected with :py:attr:`ListItem.selected`.

        The selected item always will be highlighted on list.

        .. seealso:: :py:attr:`selected_items`

        :type: :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_list_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_list_selected_item_get(self.obj))

    property selected_items:
        """Return a list of the currently selected list items.

        Multiple items can be selected if :py:attr:`multi_select` is enabled.

        .. seealso::
            :py:attr:`selected_item`
            :py:attr:`multi_select`

        :type: tuple of :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_list_selected_items_get(self.obj))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_list_selected_items_get(self.obj))

    property first_item:
        """The first item in the list

        :type: :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_list_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_list_first_item_get(self.obj))

    property last_item:
        """The last item in the list

        :type: :py:class:`ListItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_list_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_list_last_item_get(self.obj))

    def at_xy_item_get(self, int x, int y):
        """

        Get the item that is at the x, y canvas coords.

        :param x: The input x coordinate
        :param y: The input y coordinate
        :return: (:py:class:`ListItem`, int posret)

        This returns the item at the given coordinates (which are canvas
        relative, not object-relative). If an item is at that coordinate,
        that item handle is returned, and if @p posret is not NULL, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the upper portion of that item (-1), on the
        middle section (0) or on the lower part (1). If NULL is returned as
        an item (no item found there), then posret may indicate -1 or 1
        based if the coordinate is above or below all items respectively in
        the list.

        .. versionadded:: 1.8

        """
        cdef:
            int posret
            Elm_Object_Item *ret

        ret = elm_list_at_xy_item_get(self.obj, x, y, &posret)
        return _object_item_to_python(ret), posret

    property focus_on_selection:
        """

        Focus upon items selection mode

        :type: bool

        When enabled, every selection of an item inside the genlist will automatically set focus to
        its first focusable widget from the left. This is true of course if the selection was made by
        clicking an unfocusable area in an item or selecting it with a key movement. Clicking on a
        focusable widget inside an item will couse this particular item to get focus as usual.

        .. versionadded:: 1.8

        """
        def __set__(self, bint enabled):
            elm_list_focus_on_selection_set(self.obj, enabled)

        def __get__(self):
            return bool(elm_list_focus_on_selection_get(self.obj))

    def callback_activated_add(self, func, *args, **kwargs):
        """The user has double-clicked or pressed (enter|return|spacebar) on
        an item. The ``event_info`` parameter is the item that was activated."""
        self._callback_add_full("activated", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated",  _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        """The user has double-clicked an item. The ``event_info`` parameter
        is the item that was double-clicked."""
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        """When the user selected an item."""
        self._callback_add_full("selected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        """When the user unselected an item."""
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected", _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """An item in the list is long-pressed."""
        self._callback_add_full("longpressed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        """The list is scrolled until the top edge."""
        self._callback_add("edge,top", func, *args, **kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top",  func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        """The list is scrolled until the bottom edge."""
        self._callback_add("edge,bottom", func, *args, **kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom",  func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        """The list is scrolled until the left edge."""
        self._callback_add("edge,left", func, *args, **kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left",  func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        """The list is scrolled until the right edge."""
        self._callback_add("edge,right", func, *args, **kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right",  func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """The program's language changed."""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed",  func)

    def callback_highlighted_add(self, func, *args, **kwargs):
        """an item in the list is highlighted. This is called when
        the user presses an item or keyboard selection is done so the item is
        physically highlighted. The %c event_info parameter is the item that was
        highlighted."""
        self._callback_add("highlighted", func, *args, **kwargs)

    def callback_highlighted_del(self, func):
        self._callback_del("highlighted", func)

    def callback_unhighlighted_add(self, func, *args, **kwargs):
        """an item in the list is unhighlighted. This is called
        when the user releases an item or keyboard selection is moved so the item
        is physically unhighlighted. The %c event_info parameter is the item that
        was unhighlighted."""
        self._callback_add("unhighlighted", func, *args, **kwargs)

    def callback_unhighlighted_del(self, func):
        self._callback_del("unhighlighted", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """the program's language changed"""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the list has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the list has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)


    property scroller_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
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
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
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

_object_mapping_register("Elm_List", List)
