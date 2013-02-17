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

include "widget_header.pxi"

from layout_class cimport LayoutClass

from object_item cimport _object_item_callback, _object_item_to_python
from object_item import _cb_object_item_conv

cdef enum Elm_Index_Item_Insert_Kind:
    ELM_INDEX_ITEM_INSERT_APPEND
    ELM_INDEX_ITEM_INSERT_PREPEND
    ELM_INDEX_ITEM_INSERT_BEFORE
    ELM_INDEX_ITEM_INSERT_AFTER
    ELM_INDEX_ITEM_INSERT_SORTED

cdef class IndexItem(ObjectItem):
    def __init__(self, kind, evasObject index, letter, IndexItem before_after = None,
                 callback = None, *args, **kargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        if kind == ELM_INDEX_ITEM_INSERT_APPEND:
            item = elm_index_item_append(index.obj, _cfruni(letter), cb, <void*>self)
        elif kind == ELM_INDEX_ITEM_INSERT_PREPEND:
            item = elm_index_item_prepend(index.obj, _cfruni(letter), cb, <void*>self)
        #elif kind == ELM_INDEX_ITEM_INSERT_SORTED:
            #item = elm_index_item_sorted_insert(index.obj, _cfruni(letter), cb, <void*>self, cmp_f, cmp_data_f)
        else:
            if before_after == None:
                raise ValueError("need a valid after object to add an item before/after another item")
            if kind == ELM_INDEX_ITEM_INSERT_BEFORE:
                item = elm_index_item_insert_before(index.obj, before_after.item, _cfruni(letter), cb, <void*>self)
            else:
                item = elm_index_item_insert_after(index.obj, before_after.item, _cfruni(letter), cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    property selected:
        """Set the selected state of an item.

        This sets the selected state of the given item.
        ``True`` for selected, ``False`` for not selected.

        If a new item is selected the previously selected will be unselected.
        Previously selected item can be get with function
        :py:func:`Index.selected_item_get()`.

        Selected items will be highlighted.

        .. seealso:: :py:func:`Index.selected_item_get()`

        :type: bool

        """
        def __set__(self, selected):
            elm_index_item_selected_set(self.item, selected)

    def selected_set(self, selected):
        elm_index_item_selected_set(self.item, selected)

    property letter:
        """Get the letter (string) set on a given index widget item.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_index_item_letter_get(self.item))

    def letter_get(self):
        return _ctouni(elm_index_item_letter_get(self.item))

cdef Elm_Object_Item *_elm_index_item_from_python(IndexItem item):
    if item is None:
        return NULL
    else:
        return item.item

cdef class Index(LayoutClass):

    """

    An index widget gives you an index for fast access to whichever
    group of other UI items one might have.

    It's a list of text items (usually letters, for alphabetically ordered
    access).

    Index widgets are by default hidden and just appear when the
    user clicks over it's reserved area in the canvas. In its
    default theme, it's an area one ``finger`` wide on
    the right side of the index widget's container.

    When items on the index are selected, smart callbacks get
    called, so that its user can make other container objects to
    show a given area or child object depending on the index item
    selected. You'd probably be using an index together with :py:class:`List`,
    :py:class:`Genlist` or :py:class:`Gengrid`.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``"changed"`` - When the selected index item changes. ``event_info``
      is the selected item's data pointer.
    - ``"delay,changed"`` - When the selected index item changes, but
      after a small idling period. ``event_info`` is the selected
      item's data pointer.
    - ``"selected"`` - When the user releases a mouse button and
      selects an item. ``event_info`` is the selected item's data
      pointer.
    - ``"level,up"`` - when the user moves a finger from the first
      level to the second level
    - ``"level,down"`` - when the user moves a finger from the second
      level to the first level

    The ``"delay,changed"`` event is so that it'll wait a small time
    before actually reporting those events and, moreover, just the
    last event happening on those time frames will actually be
    reported.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_index_add(parent.obj))

    property autohide_disabled:
        """Enable or disable auto hiding feature for a given index widget.

        :type: bool

        """
        def __get__(self):
            return bool(elm_index_autohide_disabled_get(self.obj))

        def __set__(self, disabled):
            elm_index_autohide_disabled_set(self.obj, disabled)

    def autohide_disabled_set(self, disabled):
        elm_index_autohide_disabled_set(self.obj, disabled)
    def autohide_disabled_get(self):
        return bool(elm_index_autohide_disabled_get(self.obj))

    property item_level:
        """The items level for a given index widget.

        ``0`` or ``1``, the currently implemented levels.

        :type: int

        """
        def __get__(self):
            return elm_index_item_level_get(self.obj)
        def __set__(self, level):
            elm_index_item_level_set(self.obj, level)

    def item_level_set(self, level):
        elm_index_item_level_set(self.obj, level)
    def item_level_get(self):
        return elm_index_item_level_get(self.obj)

    def selected_item_get(self, level):
        """selected_item_get(int level) -> IndexItem

        Returns the last selected item, for a given index widget.

        :param level: ``0`` or ``1``, the currently implemented levels.
        :type level: int

        :return: The last item **selected** (or ``None``, on errors).
        :rtype: :py:class:`IndexItem`

        """
        return _object_item_to_python(elm_index_selected_item_get(self.obj, level))

    def item_append(self, letter, callback = None, *args, **kargs):
        """item_append(unicode letter, callback = None, *args, **kargs) -> IndexItem

        Append a new item on a given index widget.

        Despite the most common usage of the ``letter`` argument is for
        single char strings, one could use arbitrary strings as index
        entries.

        ``item`` will be the item returned back on ``"changed"``,
        ``"delay,changed"`` and ``"selected"`` smart events.

        :param letter: Letter under which the item should be indexed
        :type letter: string
        :param callback: The function to call when the item is selected.
        :type callback: function

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`IndexItem`

        """
        return IndexItem(ELM_INDEX_ITEM_INSERT_APPEND, self, letter,
                        None, callback, *args, **kargs)

    def item_prepend(self, letter, callback = None, *args, **kargs):
        """item_prepend(unicode letter, callback = None, *args, **kargs) -> IndexItem

        Prepend a new item on a given index widget.

        Despite the most common usage of the ``letter`` argument is for
        single char strings, one could use arbitrary strings as index
        entries.

        ``item`` will be the item returned back on ``"changed"``,
        ``"delay,changed"`` and ``"selected"`` smart events.

        :param letter: Letter under which the item should be indexed
        :type letter: string
        :param callback: The function to call when the item is selected.
        :type callback: function
        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`IndexItem`

        """
        return IndexItem(ELM_INDEX_ITEM_INSERT_PREPEND, self, letter,
                        None, callback, *args, **kargs)

    def item_insert_after(self, IndexItem after, letter, callback = None, *args, **kargs):
        """item_insert_after(IndexItem after, unicode letter, callback = None, *args, **kargs) -> IndexItem

        Insert a new item into the index object after item ``after``.

        Despite the most common usage of the ``letter`` argument is for
        single char strings, one could use arbitrary strings as index
        entries.

        ``item`` will be the pointer returned back on ``"changed"``,
        ``"delay,changed"`` and ``"selected"`` smart events.

        .. note:: If ``relative`` is ``None`` this function will behave
            as :py:func:`item_append()`.

        :param after: The index item to insert after.
        :type after: :py:class:`IndexItem`
        :param letter: Letter under which the item should be indexed
        :type letter: string
        :param callback: The function to call when the item is clicked.
        :type callback: function
        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`IndexItem`

        """
        return IndexItem(ELM_INDEX_ITEM_INSERT_AFTER, self, letter,
                        after, callback, *args, **kargs)

    def item_insert_before(self, IndexItem before, letter, callback = None, *args, **kargs):
        """item_insert_before(IndexItem before, unicode letter, callback = None, *args, **kargs) -> IndexItem

        Insert a new item into the index object before item ``before``.

        Despite the most common usage of the ``letter`` argument is for
        single char strings, one could use arbitrary strings as index
        entries.

        ``item`` will be the pointer returned back on ``"changed"``,
        ``"delay,changed"`` and ``"selected"`` smart events.

        .. note:: If ``relative`` is ``None`` this function will behave
            as :py:func:`item_prepend()`.

        :param before: The index item to insert before.
        :type before: :py:class:`IndexItem`
        :param letter: Letter under which the item should be indexed
        :type letter: string
        :param callback: The function to call when the item is clicked.
        :type callback: function
        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`IndexItem`

        """
        return IndexItem(ELM_INDEX_ITEM_INSERT_BEFORE, self, letter,
                        before, callback, *args, **kargs)

    #def item_sorted_insert(self, letter, callback = None, *args, **kargs):
        """Insert a new item into the given index widget, using ``cmp_func``
        function to sort items (by item handles).

        Despite the most common usage of the ``letter`` argument is for
        single char strings, one could use arbitrary strings as index
        entries.

        ``item`` will be the pointer returned back on ``"changed"``,
        ``"delay,changed"`` and ``"selected"`` smart events.

        :param letter: Letter under which the item should be indexed
        :type letter: string
        :param func: The function to call when the item is clicked.
        :type func: function
        :param cmp_func: The comparing function to be used to sort index
            items **by index item handles**
        :type cmp_func: function
        :param cmp_data_func: A **fallback** function to be called for the
            sorting of index items **by item data**). It will be used
            when ``cmp_func`` returns ``0`` (equality), which means an index
            item with provided item data already exists. To decide which
            data item should be pointed to by the index item in question,
            ``cmp_data_func`` will be used. If ``cmp_data_func`` returns a
            non-negative value, the previous index item data will be
            replaced by the given ``item`` pointer. If the previous data need
            to be freed, it should be done by the ``cmp_data_func``
            function, because all references to it will be lost. If this
            function is not provided (``None`` is given), index items will
            be **duplicated**, if ``cmp_func`` returns ``0``.
        :type cmp_data_func: function

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`IndexItem`

        """
        #return IndexItem(ELM_INDEX_ITEM_INSERT_SORTED, self, letter,
                        #None, callback, *args, **kargs)

    def item_find(self, data):
        """item_find(data) -> IndexItem

        Find a given index widget's item, **using item data**.

        :param data: The item data pointed to by the desired index item
        :return: The index item handle, if found, or ``None`` otherwise
        :rtype: :py:class:`IndexItem`

        """
        return None
        # XXX: This doesn't seem right.
        # return _object_item_to_python(elm_index_item_find(self.obj, <void*>data))

    def item_clear(self):
        """item_clear()

        Removes **all** items from a given index widget.

        If deletion callbacks are set, via :py:func:`delete_cb_set()`,
        that callback function will be called for each item.

        """
        elm_index_item_clear(self.obj)

    def level_go(self, level):
        """level_go(int level)

        Go to a given items level on a index widget

        :param level: The index level (one of ``0`` or ``1``)
        :type level: int

        """
        elm_index_level_go(self.obj, level)

    property indicator_disabled:
        """Whether the indicator is disabled or not.

        In Index widget, Indicator notes popup text, which shows a letter has been selecting.

        :type: bool

        """
        def __get__(self):
            return bool(elm_index_indicator_disabled_get(self.obj))
        def __set__(self, disabled):
            elm_index_indicator_disabled_set(self.obj, disabled)

    def indicator_disabled_set(self, disabled):
        elm_index_indicator_disabled_set(self.obj, disabled)
    def indicator_disabled_get(self):
        return bool(elm_index_indicator_disabled_get(self.obj))

    property horizontal:
        """Enable or disable horizontal mode on the index object

        In horizontal mode items are displayed on index from left to right,
        instead of from top to bottom. Also, the index will scroll
        horizontally. It's an area one ``finger`` wide on the bottom side of
        the index widget's container.

        .. note:: Vertical mode is set by default.

        :type: bool

        """
        def __get__(self):
            return bool(elm_index_horizontal_get(self.obj))
        def __set__(self, horizontal):
            elm_index_horizontal_set(self.obj, horizontal)

    def horizontal_set(self, horizontal):
        elm_index_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return bool(elm_index_horizontal_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """When the selected index item changes. ``event_info`` is the selected
        item's data."""
        self._callback_add_full("changed", _cb_object_item_conv, func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed",  _cb_object_item_conv, func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        """When the selected index item changes, but after a small idling
        period. ``event_info`` is the selected item's data."""
        self._callback_add_full("delay,changed", _cb_object_item_conv, func, *args, **kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del_full("delay,changed",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        """When the user releases a mouse button and selects an item.
        ``event_info`` is the selected item's data ."""
        self._callback_add_full("selected", _cb_object_item_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected",  _cb_object_item_conv, func)

    def callback_level_up_add(self, func, *args, **kwargs):
        """When the user moves a finger from the first level to the second
        level."""
        self._callback_add("level,up", func, *args, **kwargs)

    def callback_level_up_del(self, func):
        self._callback_del("level,up", func)

    def callback_level_down_add(self, func, *args, **kwargs):
        """When the user moves a finger from the second level to the first
        level."""
        self._callback_add("level,down", func, *args, **kwargs)

    def callback_level_down_del(self, func):
        self._callback_del("level,down", func)


_object_mapping_register("elm_index", Index)
