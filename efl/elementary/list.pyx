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

.. rubric:: List sizing modes

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


.. rubric:: Selection modes

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Default select mode

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    Always select mode

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    No select mode

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


.. rubric:: Scrollbar visibility

.. data:: ELM_SCROLLER_POLICY_AUTO

    Show scrollbars as needed

.. data:: ELM_SCROLLER_POLICY_ON

    Always show scrollbars

.. data:: ELM_SCROLLER_POLICY_OFF

    Never show scrollbars

"""

include "widget_header.pxi"

from object cimport Object
from object_item cimport    _object_item_callback, \
                            _object_item_to_python, \
                            _object_item_list_to_python
from object_item import _cb_object_item_conv
from scroller cimport *

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

cdef class List(Object)

cdef class ListItem(ObjectItem):

    """

    An item for the list widget.

    """

    cdef const_char *label
    cdef Evas_Object *icon_obj
    cdef Evas_Object *end_obj
    cdef Evas_Smart_Cb cb

    def __cinit__(self):
        self.icon_obj = NULL
        self.end_obj = NULL
        self.cb = NULL

    def __init__(self, label = None, evasObject icon = None,
        evasObject end = None, callback = None, *args, **kargs):
        """Create a new ListItem

        :param label: The label of the list item.
        :type  label: string
        :param  icon: The icon object to use for the left side of the item. An
                      icon can be any Evas object, but usually it is an :py:class:`Icon`.
        :type   icon: :py:class:`evas.object.Object`
        :param   end: The icon object to use for the right side of the item. An
                      icon can be any Evas object.
        :type    end: :py:class:`evas.object.Object`
        :param  callback: The function to call when the item is clicked.
        :type   callback: function

        """
        self.label = _cfruni(label) if label is not None else NULL

        if icon is not None:
            self.icon_obj = icon.obj
        if end is not None:
            self.end_obj = end.obj

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            self.cb = _object_item_callback

        self.params = (callback, args, kargs)

    def __str__(self):
        return ("%s(label=%r, icon=%s, end=%s, "
                "callback=%r, args=%r, kargs=%s)") % \
            (self.__class__.__name__, self.text_get(), bool(self.part_content_get("icon")),
             bool(self.part_content_get("end")), self.params[0], self.params[1], self.params[2])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "label=%r, icon=%s, end=%s, "
                "callback=%r, args=%r, kargs=%s)") % \
            (self.__class__.__name__, <unsigned long><void *>self,
             PY_REFCOUNT(self), <unsigned long><void *>self.item,
             self.text_get(), bool(self.part_content_get("icon")),
             bool(self.part_content_get("end")), self.params[0], self.params[1], self.params[2])

    def append_to(self, List list):
        """append_to(List list)

        Append a new item to the list object.

        A new item will be created and appended to the list, i.e., will
        be set as **last** item.

        Items created with this method can be deleted with
        :py:func:`elementary.object_item.ObjectItem.delete()`.

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
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`List.clear()`
            :py:class:`elementary.icon.Icon`

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item

        item = elm_list_item_append(list.obj,
                                    self.label,
                                    self.icon_obj,
                                    self.end_obj,
                                    self.cb,
                                    <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)

    def prepend_to(self, List list):
        """prepend_to(List list)

        Prepend a new item to the list object.

        .. seealso::
            :py:func:`append_to()`
            :py:attr:`List.select_mode`
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`List.clear()`
            :py:class:`elementary.icon.Icon`

        :param list: The list
        :type  list: List

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item

        item = elm_list_item_prepend(   list.obj,
                                        self.label,
                                        self.icon_obj,
                                        self.end_obj,
                                        self.cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)

    def insert_before(self, ListItem before):
        """insert_before(ListItem before)

        Insert a new item into the list object before item *before*.

        .. seealso::
            :py:func:`append_to()`
            :py:attr:`List.select_mode`
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`List.clear()`
            :py:class:`elementary.icon.Icon`

        :param before: The list item to insert before.
        :type  before: :py:class:`ListItem`

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item

        cdef List list = before.widget
        item = elm_list_item_insert_before( list.obj,
                                            before.item,
                                            self.label,
                                            self.icon_obj,
                                            self.end_obj,
                                            self.cb,
                                            <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)

    def insert_after(self, ListItem after):
        """insert_after(ListItem after)

        Insert a new item into the list object after item *after*.

        .. seealso::
            :py:func:`append_to()`
            :py:attr:`List.select_mode`
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`List.clear()`
            :py:class:`elementary.icon.Icon`

        :param after: The list item to insert after.
        :type after: :py:class:`ListItem`

        :return:      The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        cdef Elm_Object_Item *item

        cdef List list = after.widget
        item = elm_list_item_insert_after(  list.obj,
                                            after.item,
                                            self.label,
                                            self.icon_obj,
                                            self.end_obj,
                                            self.cb,
                                            <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)

    #def sorted_insert_to(self, List list, cmp_func=None):
        """Insert a new item into the sorted list object.

        .. seealso::
            :py:func:`append_to()`
            :py:attr:`List.select_mode`
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`List.clear()`
            :py:class:`elementary.icon.Icon`

        .. note:: This function inserts values into a list object assuming
            it was sorted and the result will be sorted.

        :param cmp_func: The comparing function to be used to sort list
                         items **by :py:class:`ListItem` handles**. This
                         function will receive two items and compare them,
                         returning a non-negative integer if the second item
                         should be place after the first, or negative value
                         if should be placed before.
        :type  cmp_func: function

        :return:        The created item or ``None`` upon failure.
        :rtype:         :py:class:`ListItem`

        """
        #cdef Elm_Object_Item *item

        #item = elm_list_item_sorted_insert(list.obj,
                                            #self.label,
                                            #icon_obj,
                                            #end_obj,
                                            #cb,
                                            #<void*>self,
                                            #cmp_f)

        #if item != NULL:
            #self._set_obj(item)
            #return self
        #else:
            #Py_DECREF(self)

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
        wanted, use :py:func:`bring_in()` instead.

        """
        elm_list_item_show(self.item)

    def bring_in(self):
        """bring_in()

        Bring in the given item to list view.

        This causes list to jump to the given item and show it
        (by scrolling), if it is not fully visible.

        This may use animation to do so and take a period of time.

        If animation isn't wanted, :py:func:`show()` can be used.

        """
        elm_list_item_bring_in(self.item)

    property object:
        """Returns the base object set for this list item.

        Base object is the one that visually represents the list item
        row. It must not be changed in a way that breaks the list
        behavior (like deleting the base!), but it might be used to
        feed Edje signals to add more features to row representation.

        :type: :py:class:`edje.Edje`

        """
        def __get__(self):
            return object_from_instance(elm_list_item_object_get(self.item))

    def object_get(self):
        return object_from_instance(elm_list_item_object_get(self.item))

    property prev:
        """The item before this item in the list.

        .. note:: If the item is the first item, ``None`` will be returned.

        .. seealso::
            :py:func:`append_to()`
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

    A list widget is a container whose children are displayed vertically or
    horizontally, in order, and can be selected.
    The list can accept only one or multiple items selection. Also has many
    modes of items displaying.

    A list is a very simple type of list widget.  For more robust
    lists, :py:class:`genlist.Genlist` should probably be used.

    Smart callbacks one can listen to:

    - ``"activated"`` - The user has double-clicked or pressed
        (enter|return|spacebar) on an item. The ``event_info`` parameter
        is the item that was activated.
    - ``"clicked,double"`` - The user has double-clicked an item.
        The ``event_info`` parameter is the item that was double-clicked.
    - "selected" - when the user selected an item
    - "unselected" - when the user unselected an item
    - "longpressed" - an item in the list is long-pressed
    - "edge,top" - the list is scrolled until the top edge
    - "edge,bottom" - the list is scrolled until the bottom edge
    - "edge,left" - the list is scrolled until the left edge
    - "edge,right" - the list is scrolled until the right edge
    - "language,changed" - the program's language changed

    Available styles for it:

    - ``"default"``

    Default content parts of the list items that you can use for are:

    - "start" - A start position object in the list item
    - "end" - A end position object in the list item

    Default text parts of the list items that you can use for are:

    - "default" - label in the list item

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_list_add(parent.obj))

    def go(self):
        """go()

        Starts the list.

        Example::

            li = List(win)
            ListItem("First").append_to(li)
            ListItem("Second").append_to(li)
            li.go()
            li.show()

        .. note:: Call before running show() on the list object.
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

        :type: Elm_List_Mode

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

        Possible modes are:

        ELM_OBJECT_SELECT_MODE_DEFAULT
            Items will only call their selection func and callback when
            first becoming selected. Any further clicks will do nothing,
            unless you set always select mode.
        ELM_OBJECT_SELECT_MODE_ALWAYS
            This means that, even if selected, every click will make the
            selected callbacks be called.
        ELM_OBJECT_SELECT_MODE_NONE
            This will turn off the ability to select items entirely and
            they will neither appear selected nor call selected callback
            functions.

        :type: Elm_Object_Select_Mode

        """
        def __set__(self, mode):
            elm_list_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_list_select_mode_get(self.obj)

    def select_mode_set(self, mode):
        elm_list_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_list_select_mode_get(self.obj)

    property bounce:
        """The bouncing behaviour when the scrolled content reaches an edge.

        Whether the internal scroller object should bounce or not when it
        reaches the respective edges for each axis.

        :type: tuple of bools

        """
        def __set__(self, value):
            h, v = value
            elm_scroller_bounce_set(self.obj, h, v)

        def __get__(self):
            cdef Eina_Bool h, v
            elm_scroller_bounce_get(self.obj, &h, &v)
            return (h, v)

    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

    property scroller_policy:
        """The scrollbar policy.

        This sets the scrollbar visibility policy for the given scroller.
        ELM_SCROLLER_POLICY_AUTO means the scrollbar is made visible if it
        is needed, and otherwise kept hidden. ELM_SCROLLER_POLICY_ON turns
        it on all the time, and ELM_SCROLLER_POLICY_OFF always keeps it off.
        This applies respectively for the horizontal and vertical scrollbars.

        The both are disabled by default, i.e., are set to
        ELM_SCROLLER_POLICY_OFF.

        :type: Elm_Scroller_Policy

        """
        def __set__(self, value):
            policy_h, policy_v = value
            elm_scroller_policy_set(self.obj, policy_h, policy_v)

        def __get__(self):
            cdef Elm_Scroller_Policy policy_h, policy_v
            elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
            return (policy_h, policy_v)

    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)


    def item_append(self, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(label, icon, end, callback, *args, **kargs).append_to(self)

    def item_prepend(self, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(label, icon, end, callback, *args, **kargs).prepend_to(self)

    def item_insert_before(self, ListItem before, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(label, icon, end, callback, *args, **kargs).insert_before(before)

    def item_insert_after(self, ListItem after, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(label, icon, end, callback, *args, **kargs).insert_after(after)

    def clear(self):
        """clear()

        Remove all list's items.

        .. seealso::
            :py:func:`object_item.ObjectItem.delete()`
            :py:func:`ListItem.append()`

        """
        elm_list_clear(self.obj)

    property items:
        """Get a list of all the list items.

        .. seealso::
            :py:func:`ListItem.append_to()`
            :py:func:`elementary.object_item.ObjectItem.delete()`
            :py:func:`clear()`

        :type: tuple of :py:class:`ListItem`

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


_object_mapping_register("elm_list", List)
