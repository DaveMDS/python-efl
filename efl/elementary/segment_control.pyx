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

from object_item cimport _object_item_to_python
from object_item import _cb_object_item_conv

cdef class SegmentControlItem(ObjectItem):

    """

    An item for :py:class:`SegmentControl`.

    """

    property index:
        """Get the index of an item.

        Index is the position of an item in segment control widget. Its
        range is from ``0`` to <tt> count - 1 </tt>.
        Count is the number of items, that can be get with
        elm_segment_control_item_count_get().

        :type: int

        """
        def __get__(self):
            return elm_segment_control_item_index_get(self.item)

    property object:
        """Get the base object of the item.

        :type: :py:class:`SegmentControl`

        """
        def __get__(self):
            return object_from_instance(elm_segment_control_item_object_get(self.item))

    property selected:
        """Set the selected state of an item.

        This sets the selected state of the given item ``it``.
        ``True`` for selected, ``False`` for not selected.

        If a new item is selected the previously selected will be unselected.

        The selected item always will be highlighted on segment control.

        .. seealso:: :py:attr:`SegmentControl.item_selected`

        :type: bool

        """
        def __set__(self, select):
            elm_segment_control_item_selected_set(self.item, select)

cdef class SegmentControl(LayoutClass):

    """

    Segment control widget is a horizontal control made of multiple
    segment items, each segment item functioning similar to discrete two
    state button. A segment control groups the items together and provides
    compact single button with multiple equal size segments.

    Segment item size is determined by base widget size and the number of
    items added. Only one segment item can be at selected state. A segment
    item can display combination of Text and any Evas_Object like Images or
    other widget.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``"changed"`` - When the user clicks on a segment item which is not
      previously selected and get selected. The event_info parameter is the
      segment item pointer.

    Available styles for it:

    - ``"default"``

    Default content parts of the segment control items that you can use for are:

    - "icon" - An icon in a segment control item

    Default text parts of the segment control items that you can use for are:

    - "default" - Title label in a segment control item

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_segment_control_add(parent.obj))

    def item_add(self, evasObject icon, label = None):
        """item_add(self, evas.Object icon, unicode label = None) -> SegmentControlItem

        Append a new item to the segment control object.

        A new item will be created and appended to the segment control,
        i.e., will be set as **last** item.

        If it should be inserted at another position,
        elm_segment_control_item_insert_at() should be used instead.

        Items created with this function can be deleted with function
        :py:func:`ObjectItem.delete()` or :py:func:`item_del_at()`.

        Simple example::

            sc = SegmentControl(win)
            ic = Icon(win)
            ic.file_set("path/to/image")
            ic.resizable_set(True, True)
            sc.item_add(ic, "label")
            sc.show()

        .. note:: ``label`` set to ``None`` is different from empty string "".
            If an item only has icon, it will be displayed bigger and
            centered. If it has icon and label, even that an empty string,
            icon will be smaller and positioned at left.

        .. seealso::
            :py:func:`SegmentControl.item_insert_at()`
            :py:func:`ObjectItem.delete()`

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an icon created
            with elm_icon_add().
        :type icon: :py:class:`Object`
        :param label: The label of the item. Note that, None is different
            from empty string "".
        :type label: string
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_add(self.obj, icon.obj, _cfruni(label) if label is not None else NULL)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_insert_at(self, evasObject icon, label = None, index = 0):
        """item_insert_at(self, evas.Object icon, unicode label = None, int index = 0) -> SegmentControlItem

        Insert a new item to the segment control object at specified position.

        Index values must be between ``0``, when item will be prepended to
        segment control, and items count, that can be get with
        elm_segment_control_item_count_get(), case when item will be appended
        to segment control, just like elm_segment_control_item_add().

        Items created with this function can be deleted with function
        elm_object_item_del() or elm_segment_control_item_del_at().

        .. note:: ``label`` set to ``None`` is different from empty string "".
            If an item only has icon, it will be displayed bigger and
            centered. If it has icon and label, even that an empty string,
            icon will be smaller and positioned at left.

        .. seealso::
            :py:func:`SegmentControl.item_add()`
            :py:func:`SegmentControl.item_count_get()`
            :py:func:`ObjectItem.delete()`

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an icon created
            with elm_icon_add().
        :type icon: :py:class:`Object`
        :param label: The label of the item.
        :type label: string
        :param index: Item position. Value should be between 0 and items count.
        :type index: int
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_insert_at(self.obj, icon.obj, _cfruni(label) if label is not None else NULL, index)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_del_at(self, index):
        """item_del_at(int index)

        Remove a segment control item at given index from its parent,
        deleting it.

        Items can be added with elm_segment_control_item_add() or
        elm_segment_control_item_insert_at().

        :param index: The position of the segment control item to be deleted.
        :type index: int

        """
        elm_segment_control_item_del_at(self.obj, index)

    property item_count:
        """Get the Segment items count from segment control.

        It will just return the number of items added to the segment control.

        :type: int

        """
        def __get__(self):
            return elm_segment_control_item_count_get(self.obj)

    def item_get(self, index):
        """item_get(int index) -> SegmentControlItem

        Get the item placed at specified index.

        Index is the position of an item in segment control widget. Its
        range is from ``0`` to <tt> count - 1 </tt>.
        Count is the number of items, that can be get with
        elm_segment_control_item_count_get().

        :param index: The index of the segment item.
        :type index: int
        :return: The segment control item or ``None`` on failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        return _object_item_to_python(elm_segment_control_item_get(self.obj, index))

    def item_label_get(self, index):
        """item_label_get(int index) -> unicode

        Get the label of item.

        The return value is a pointer to the label associated to the item when
        it was created, with function elm_segment_control_item_add(), or later
        with function elm_object_item_text_set. If no label
        was passed as argument, it will return ``None``.

        .. seealso::
            :py:func:`ObjectItem.text_set()` for more details.
            :py:func:`SegmentControl.item_add()`

        :param index: The index of the segment item.
        :type index: int
        :return: The label of the item at ``index``.
        :rtype: string

        """
        return _ctouni(elm_segment_control_item_label_get(self.obj, index))

    def item_icon_get(self, index):
        """item_icon_get(int index) -> evas.Object

        Get the icon associated to the item.

        The return value is a pointer to the icon associated to the item when
        it was created, with function elm_segment_control_item_add(), or later
        with function elm_object_item_part_content_set(). If no icon
        was passed as argument, it will return ``None``.

        .. seealso::
            :py:func:`SegmentControl.item_add()`
            :py:func:`ObjectItem.part_content_set()`

        :param index: The index of the segment item.
        :type index: int
        :return: The left side icon associated to the item at ``index``.
        :rtype: :py:class:`Object`

        """
        return object_from_instance(elm_segment_control_item_icon_get(self.obj, index))

    property item_selected:
        """Get the selected item.

        The selected item can be unselected with function
        elm_segment_control_item_selected_set().

        The selected item always will be highlighted on segment control.

        :type: :py:class:`SegmentControlItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_segment_control_item_selected_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """When the user clicks on a segment item which is not previously
        selected and get selected. The event_info parameter is the segment
        item."""
        self._callback_add_full("changed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed", _cb_object_item_conv, func)


_object_mapping_register("elm_segment_control", SegmentControl)
