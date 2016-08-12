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

include "segment_control_cdef.pxi"

cdef class SegmentControlItem(ObjectItem):
    """

    An item for :py:class:`SegmentControl`.

    """

    cdef:
        evasObject icon
        object label

    def __init__(self, evasObject icon = None, label = None, *args, **kwargs):
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.icon = icon
        self.label = label
        self.args = args
        self.kwargs = kwargs

    def add_to(self, SegmentControl sc not None):
        """Append a new item to the segment control object.

        A new item will be created and appended to the segment control,
        i.e., will be set as **last** item.

        If it should be inserted at another position,
        :py:meth:`item_insert_at` should be used instead.

        Items created with this function can be deleted with function
        :py:meth:`efl.elementary.object_item.ObjectItem.delete` or
        :py:meth:`item_del_at`.

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

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type icon: :py:class:`~efl.evas.Object`
        :param label: The label of the item. Note that, None is different
            from empty string "".
        :type label: string
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_add(sc.obj,
            self.icon.obj if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def item_insert_at(self, SegmentControl sc not None, index = 0):
        """Insert a new item to the segment control object at specified position.

        Index values must be between ``0``, when item will be prepended to
        segment control, and items count, that can be get with
        :py:attr:`item_count`, case when item will be appended
        to segment control, just like :py:meth:`item_add`.

        Items created with this function can be deleted with function
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete` or
        :py:meth:`item_del_at`.

        .. note:: ``label`` set to ``None`` is different from empty string "".
            If an item only has icon, it will be displayed bigger and
            centered. If it has icon and label, even that an empty string,
            icon will be smaller and positioned at left.

        .. seealso::
            :py:meth:`item_add`
            :py:attr:`item_count`
            :py:meth:`efl.elementary.object_item.ObjectItem.delete`

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type icon: :py:class:`~efl.evas.Object`
        :param label: The label of the item.
        :type label: string
        :param index: Item position. Value should be between 0 and items count.
        :type index: int
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_insert_at(sc.obj,
            self.icon.obj if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL, index)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

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

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """SegmentControl(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_segment_control_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def item_add(self, evasObject icon = None, label = None):
        """Append a new item to the segment control object.

        A new item will be created and appended to the segment control,
        i.e., will be set as **last** item.

        If it should be inserted at another position,
        :py:meth:`item_insert_at` should be used instead.

        Items created with this function can be deleted with function
        :py:meth:`efl.elementary.object_item.ObjectItem.delete` or
        :py:meth:`item_del_at`.

        Simple example::

            sc = SegmentControl(win)
            ic = Icon(win, file="path/to/image", resizable=(True, True))
            sc.item_add(ic, "label")
            sc.show()

        .. note:: ``label`` set to ``None`` is different from empty string "".
            If an item only has icon, it will be displayed bigger and
            centered. If it has icon and label, even that an empty string,
            icon will be smaller and positioned at left.

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type icon: :py:class:`~efl.evas.Object`
        :param label: The label of the item. Note that, None is different
            from empty string "".
        :type label: string
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        item = elm_segment_control_item_add(self.obj,
            icon.obj if icon is not None else NULL,
            <const char *>label if label is not None else NULL)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_insert_at(self, evasObject icon = None, label = None, index = 0):
        """Insert a new item to the segment control object at specified position.

        Index values must be between ``0``, when item will be prepended to
        segment control, and items count, that can be get with
        :py:attr:`item_count`, case when item will be appended
        to segment control, just like :py:meth:`item_add`.

        Items created with this function can be deleted with function
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete` or
        :py:meth:`item_del_at`.

        .. note:: ``label`` set to ``None`` is different from empty string "".
            If an item only has icon, it will be displayed bigger and
            centered. If it has icon and label, even that an empty string,
            icon will be smaller and positioned at left.

        .. seealso::
            :py:meth:`item_add`
            :py:attr:`item_count`
            :py:meth:`efl.elementary.object_item.ObjectItem.delete`

        :param icon: The icon object to use for the left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type icon: :py:class:`~efl.evas.Object`
        :param label: The label of the item.
        :type label: string
        :param index: Item position. Value should be between 0 and items count.
        :type index: int
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        item = elm_segment_control_item_insert_at(self.obj,
            icon.obj if icon is not None else NULL,
            <const char *>label if label is not None else NULL, index)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_del_at(self, index):
        """Remove a segment control item at given index from its parent,
        deleting it.

        Items can be added with :py:meth:`item_add` or
        :py:meth:`item_insert_at`.

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
        """Get the item placed at specified index.

        Index is the position of an item in segment control widget. Its
        range is from ``0`` to <tt> count - 1 </tt>.
        Count is the number of items, that can be get with
        :py:attr:`item_count`.

        :param index: The index of the segment item.
        :type index: int
        :return: The segment control item or ``None`` on failure.
        :rtype: :py:class:`SegmentControlItem`

        """
        return _object_item_to_python(elm_segment_control_item_get(self.obj, index))

    def item_label_get(self, index):
        """Get the label of item.

        The return value is the label associated to the item when
        it was created, with function :py:meth:`item_add`, or later with
        function :py:attr:`~efl.elementary.object_item.ObjectItem.text`. If no
        label was passed as argument, it will return ``None``.

        :param index: The index of the segment item.
        :type index: int
        :return: The label of the item at ``index``.
        :rtype: string

        """
        return _ctouni(elm_segment_control_item_label_get(self.obj, index))

    def item_icon_get(self, index):
        """Get the icon associated to the item.

        The return value is the icon associated to the item when it
        was created, with function :py:meth:`item_add`, or later with function
        :py:meth:`~efl.elementary.object_item.ObjectItem.part_content_set`. If
        no icon was passed as argument, it will return ``None``.

        :param index: The index of the segment item.
        :type index: int
        :return: The left side icon associated to the item at ``index``.
        :rtype: :py:class:`~efl.evas.Object`

        """
        return object_from_instance(elm_segment_control_item_icon_get(self.obj, index))

    property item_selected:
        """The selected item.

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
                                func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed", _cb_object_item_conv, func)


_object_mapping_register("Elm_Segment_Control", SegmentControl)
