# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

include "index_cdef.pxi"

cdef int _index_compare_func(const void *data1, const void *data2) with gil:
    """Comparison by IndexItem objects"""
    cdef:
        Elm_Object_Item *citem1 = <Elm_Object_Item *>data1
        Elm_Object_Item *citem2 = <Elm_Object_Item *>data2
        IndexItem item1 = <IndexItem>elm_object_item_data_get(citem1)
        IndexItem item2 = <IndexItem>elm_object_item_data_get(citem2)
        object func

    if item1.compare_func is not None:
        func = item1.compare_func
    elif item2.compare_func is not None:
        func = item2.compare_func
    else:
        return 0

    ret = func(item1, item2)
    if ret is not None:
        try:
            return ret
        except Exception:
            traceback.print_exc()
            return 0
    else:
        return 0

cdef int _index_data_compare_func(const void *data1, const void *data2) with gil:
    """Comparison by IndexItem data"""
    cdef:
        IndexItem item1 = <object>data1
        IndexItem item2 = <object>data2
        object func

    if item1.data_compare_func is not None:
        func = item1.data_compare_func
    elif item2.data_compare_func is not None:
        func = item2.data_compare_func
    else:
        return 0

    ret = func(item1.data, item2.data)
    if ret is not None:
        try:
            return ret
        except Exception:
            traceback.print_exc()
            return 0
    else:
        return 0

cdef class IndexItem(ObjectItem):
    """

    An item on an :py:class:`Index` widget.

    Despite the most common usage of the ``letter`` argument is for
    single char strings, one could use arbitrary strings as index
    entries.

    ``item`` will be the item returned back on ``"changed"``,
    ``"delay,changed"`` and ``"selected"`` smart events.

    :param letter: Letter under which the item should be indexed
    :type letter: string
    :param callback: The function to call when the item is selected.
    :type callback: callable
    :param cb_data: User data for the callback function
    :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance
    """
    cdef:
        bytes letter
        object compare_func, data_compare_func

    def __init__(self, letter, callback = None, cb_data = None, *args, **kwargs):
        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(letter, unicode): letter = PyUnicode_AsUTF8String(letter)
        self.letter = letter

        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kwargs

    def append_to(self, Index index not None):
        """

        Append this item to the ``index``.

        :param index: The index object to append to.
        :type index: :py:class:`Index`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_index_item_append(index.obj,
            <const char *>self.letter if self.letter is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, Index index not None):
        """

        Prepend this item to the ``index``.

        :param index: The index object to prepend to.
        :type index: :py:class:`Index`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_index_item_prepend(index.obj,
            <const char *>self.letter if self.letter is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, IndexItem after not None):
        """

        Insert this item after the item ``after``.

        :param after: The index item to insert after.
        :type after: :py:class:`IndexItem`

        """
        cdef Elm_Object_Item *item
        cdef Index index = after.widget
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_index_item_insert_after(index.obj, after.item,
            <const char *>self.letter if self.letter is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, IndexItem before not None):
        """

        Insert this item before the item ``before``.

        :param before: The index item to insert before.
        :type before: :py:class:`IndexItem`

        """
        cdef Elm_Object_Item *item
        cdef Index index = before.widget
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_index_item_insert_before(index.obj, before.item,
            <const char *>self.letter if self.letter is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_sorted(self, Index index not None, compare_func, data_compare_func = None):
        """

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
            replaced by the given ``item``. If the previous data need
            to be freed, it should be done by the ``cmp_data_func``
            function, because all references to it will be lost. If this
            function is not provided (``None`` is given), index items will
            be **duplicated**, if ``cmp_func`` returns ``0``.
        :type cmp_data_func: function

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        self.compare_func = compare_func
        self.data_compare_func = data_compare_func
        item = elm_index_item_sorted_insert(index.obj,
            <const char *>self.letter if self.letter is not None else NULL,
            cb, <void*>self,
            _index_compare_func, _index_data_compare_func)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

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

    property priority:
        """The priority of an item.

        The priority is -1 by default, which means that the item doesn't belong
        to a group. The value of the priority starts from 0.
        In elm_index_level_go, the items are sorted in ascending order according
        to priority. Items of the same priority make a group and the primary
        group is shown by default.

        :type: int

        ..versionadded:: 1.16

        """
        def __set__(self, int value):
            elm_index_item_priority_set(self.item, value)

    def priority_set(self, int value):
        elm_index_item_priority_set(self.item, value)


cdef class Index(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Index(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_index_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

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
        """Returns the last selected item, for a given index widget.

        :param level: ``0`` or ``1``, the currently implemented levels.
        :type level: int

        :return: The last item **selected** (or ``None``, on errors).
        :rtype: :py:class:`IndexItem`

        """
        return _object_item_to_python(elm_index_selected_item_get(self.obj, level))

    def item_append(self, letter, callback = None, *args, **kargs):
        """A constructor for :py:class:`IndexItem`

        :see: :py:func:`IndexItem.append_to`

        """
        return IndexItem(letter, callback, *args, **kargs).append_to(self)

    def item_prepend(self, letter, callback = None, *args, **kargs):
        """A constructor for :py:class:`IndexItem`

        :see: :py:func:`IndexItem.prepend_to`

        """
        return IndexItem(letter, callback, *args, **kargs).prepend_to(self)

    def item_insert_after(self, IndexItem after, letter, callback = None, *args, **kargs):
        """A constructor for :py:class:`IndexItem`

        :see: :py:func:`IndexItem.insert_after`

        """
        return IndexItem(letter, callback, *args, **kargs).insert_after(after)

    def item_insert_before(self, IndexItem before, letter, callback = None, *args, **kargs):
        """A constructor for :py:class:`IndexItem`

        :see: :py:func:`IndexItem.insert_before`

        """
        return IndexItem(letter, callback, *args, **kargs).insert_before(before)

    # TODO:
    # def item_sorted_insert(self, letter, callback = None, *args, **kargs):
    #     """Insert a new item into the given index widget, using ``cmp_func``
    #     function to sort items (by item handles).

    #     A constructor for :py:class:`IndexItem`

    #     :see: :py:func:`IndexItem.insert_sorted`

    #     """
    #     return IndexItem(ELM_INDEX_ITEM_INSERT_SORTED, self, letter,
    #                     None, callback, *args, **kargs)

    @DEPRECATED("1.8", "Broken, don't use.")
    def item_find(self, data):
        """Find a given index widget's item, **using item data**.

        :param data: The item data pointed to by the desired index item
        :return: The index item handle, if found, or ``None`` otherwise
        :rtype: :py:class:`IndexItem`

        """
        return None
        # XXX: This doesn't seem right.
        # return _object_item_to_python(elm_index_item_find(self.obj, <void*>data))

    def item_clear(self):
        """Removes **all** items from a given index widget.

        If deletion callbacks are set, via
        :py:meth:`efl.elementary.object_item.ObjectItem.delete_cb_set`, that
        callback function will be called for each item.

        """
        elm_index_item_clear(self.obj)

    def level_go(self, level):
        """Go to a given items level on a index widget

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

    property standard_priority:
        """Control standard_priority group of index.

        Priority group will be shown as many items as it can, and other group
        will be shown one character only.

        :type: int

        ..versionadded:: 1.16

        """
        def __get__(self):
            return elm_index_standard_priority_get(self.obj)
        def __set__(self, int value):
            elm_index_standard_priority_set(self.obj, value)

    def standard_priority_set(self, int value):
        elm_index_standard_priority_set(self.obj, value)
    def standard_priority_get(self):
        return elm_index_standard_priority_get(self.obj)

    property delay_change_time:
        """Delay change time for index object.

        :type: double

        .. note:: Delay time is 0.2 sec by default.

        .. versionadded:: 1.8

        """
        def __set__(self, double delay_change_time):
            elm_index_delay_change_time_set(self.obj, delay_change_time)

        def __get__(self):
            return elm_index_delay_change_time_get(self.obj)

    def delay_change_time_set(self, double delay_change_time):
        elm_index_delay_change_time_set(self.obj, delay_change_time)

    def delay_change_time_get(self):
        return elm_index_delay_change_time_get(self.obj)

    property omit_enabled:
        """Enable or disable omit feature for a given index widget.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint enabled):
            elm_index_omit_enabled_set(self.obj, enabled)

        def __get__(self):
            return bool(elm_index_omit_enabled_get(self.obj))

    def omit_enabled_set(self, bint enabled):
        elm_index_omit_enabled_set(self.obj, enabled)

    def omit_enabled_get(self):
        return bool(elm_index_omit_enabled_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """When the selected index item changes. ``event_info`` is the selected
        item's data."""
        self._callback_add_full("changed", _cb_object_item_conv, func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed",  _cb_object_item_conv, func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        """When the selected index item changes, but after a small idling
        period. ``event_info`` is the selected item's data."""
        self._callback_add_full("delay,changed", _cb_object_item_conv, func, args, kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del_full("delay,changed",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        """When the user releases a mouse button and selects an item.
        ``event_info`` is the selected item's data ."""
        self._callback_add_full("selected", _cb_object_item_conv, func, args, kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected",  _cb_object_item_conv, func)

    def callback_level_up_add(self, func, *args, **kwargs):
        """When the user moves a finger from the first level to the second
        level."""
        self._callback_add("level,up", func, args, kwargs)

    def callback_level_up_del(self, func):
        self._callback_del("level,up", func)

    def callback_level_down_add(self, func, *args, **kwargs):
        """When the user moves a finger from the second level to the first
        level."""
        self._callback_add("level,down", func, args, kwargs)

    def callback_level_down_del(self, func):
        self._callback_del("level,down", func)


_object_mapping_register("Elm_Index", Index)
