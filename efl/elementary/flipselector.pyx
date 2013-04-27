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

Widget description
------------------

.. image:: /images/flipselector-preview.png
    :align: left

A flip selector is a widget to show a set of *text* items, one
at a time, with the same sheet switching style as the :py:class:`Clock`
widget, when one changes the current displaying sheet
(thus, the "flip" in the name).

User clicks to flip sheets which are *held* for some time will
make the flip selector to flip continuously and automatically for
the user. The interval between flips will keep growing in time,
so that it helps the user to reach an item which is distant from
the current selection.

This widget inherits from the :py:class:`Layout` one, so that all the
functions acting on it also work for flip selector objects.

This widget emits the following signals, besides the ones sent from
:py:class:`Layout`:

- ``"selected"`` - when the widget's selected text item is changed
- ``"overflowed"`` - when the widget's current selection is changed
  from the first item in its list to the last
- ``"underflowed"`` - when the widget's current selection is changed
  from the last item in its list to the first

Available styles for it:

- ``"default"``

Default text parts of the flipselector items that you can use for are:

- "default" - label of the flipselector item

"""

include "widget_header.pxi"
include "callback_conversions.pxi"

from object cimport Object
from object_item cimport _object_item_to_python, _object_item_callback, _object_item_list_to_python

cdef class FlipSelectorItem(ObjectItem):

    """

    An item for the :py:class:`FlipSelector` widget.

    .. note:: The current selection *won't* be modified by appending an
        element to the list.

    .. note:: The maximum length of the text label is going to be
        determined *by the widget's theme*. Strings larger than
        that value are going to be *truncated*.

    """

    cdef:
        bytes label

    def __init__(self, label = None, callback = None, *args, **kwargs):
        """

        The widget's list of labels to show will be appended with the
        given value. If the user wishes so, a callback function pointer
        can be passed, which will get called when this same item is
        selected.

        :param label: The (text) label of the new item
        :type label: string
        :param func: Convenience callback function to take place when item
            is selected
        :type func: function

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`FlipSelectorItem`

        """

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label
        self.cb_func = callback
        self.args = args
        self.kwargs = kwargs

    def append_to(self, FlipSelector flipselector not None):
        """append_to(FlipSelector flipselector) -> FlipSelectorItem

        Append a (text) item to a flip selector widget

        :param flipselector: The widget to append this item to
        :type flipselector: :py:class:`FlipSelector`

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`FlipSelectorItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback

        item = elm_flipselector_item_append(flipselector.obj,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void *>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            return

    def prepend_to(self, FlipSelector flipselector not None):
        """prepend_to(FlipSelector flipselector) -> FlipSelectorItem

        Append a (text) item to a flip selector widget

        :param flipselector: The widget to prepend this item to
        :type flipselector: :py:class:`FlipSelector`

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`FlipSelectorItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback

        item = elm_flipselector_item_prepend(flipselector.obj,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void *>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            return

    property label:
        """The label of this item

        :type: string

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.label = value

        def __get__(self):
            return self.label.decode("UTF-8")

    property selected:
        """Set whether a given flip selector widget's item should be the
        currently selected one.

        This sets whether ``item`` is or not the selected (thus, under
        display) one. If ``item`` is different than the one under display,
        the latter will be unselected. If the ``item`` is set to be
        unselected, on the other hand, the B{first} item in the widget's
        internal members list will be the new selected one.

        :type: bool

        """
        def __set__(self, selected):
            elm_flipselector_item_selected_set(self.item, selected)

        def __get__(self):
            return bool(elm_flipselector_item_selected_get(self.item))

    property prev:
        """Gets the item before ``item`` in a flip selector widget's internal list of
        items.

        :type: :py:class:`FlipSelectorItem`

        .. seealso:: :py:func:`item_next_get`

        """
        def __get__(self):
            return _object_item_to_python(elm_flipselector_item_prev_get(self.item))

    property next:
        """Gets the item after ``item`` in a flip selector widget's
        internal list of items.

        :type: :py:class:`FlipSelectorItem`

        .. seealso:: :py:func:`item_prev_get`

        """
        def __get__(self):
            return _object_item_to_python(elm_flipselector_item_next_get(self.item))

cdef class FlipSelector(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent):
        self._set_obj(elm_flipselector_add(parent.obj))

    def next(self):
        """next()

        Programmatically select the next item of a flip selector widget

        .. note:: The selection will be animated. Also, if it reaches the
            end of its list of member items, it will continue with the first
            one onwards.

        """
        elm_flipselector_flip_next(self.obj)

    def prev(self):
        """prev()

        Programmatically select the previous item of a flip selector
        widget

        .. note:: The selection will be animated.  Also, if it reaches the
            beginning of its list of member items, it will continue with the
            last one backwards.

        """
        elm_flipselector_flip_prev(self.obj)

    def item_append(self, label = None, callback = None, *args, **kwargs):
        """item_append(unicode label = None, callback = None, *args, **kwargs) -> FlipSelectorItem

        A constructor for a :py:class:`FlipSelectorItem`

        :see: :py:func:`FlipSelectorItem.append_to`

        """
        return FlipSelectorItem(label, callback, *args, **kwargs).append_to(self)

    def item_prepend(self, label = None, callback = None, *args, **kwargs):
        """item_prepend(unicode label = None, callback = None, *args, **kwargs) -> FlipSelectorItem

        A constructor for a :py:class:`FlipSelectorItem`

        :see: :py:func:`FlipSelectorItem.prepend_to`

        """
        return FlipSelectorItem(label, callback, *args, **kwargs).prepend_to(self)

    property items:
        """Get the internal list of items in a given flip selector widget.

        This list is *not* to be modified in any way and must not be
        freed. Use the list members with functions like
        elm_object_item_text_set(),
        elm_object_item_text_get(),
        elm_object_item_del(),
        elm_flipselector_item_selected_get(),
        elm_flipselector_item_selected_set().

        .. warning:: This list is only valid until ``obj`` object's internal
            items list is changed. It should be fetched again with another
            call to this function when changes happen.

        :type: tuple of :py:class:`FlipSelectorItem`

        """
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_flipselector_items_get(self.obj)))

    property first_item:
        """Get the first item in the given flip selector widget's list of
        items.

        .. seealso:: :py:func:`item_append`
        .. seealso:: :py:attr:`last_item`

        :type: :py:class:`FlipSelectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_flipselector_first_item_get(self.obj))

    property last_item:
        """Get the last item in the given flip selector widget's list of
        items.

        .. seealso:: :py:func:`item_prepend`
        .. seealso:: :py:attr:`first_item`

        :type: :py:class:`FlipSelectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_flipselector_last_item_get(self.obj))

    property selected_item:
        """Get the currently selected item in a flip selector widget.

        :type: :py:class:`FlipSelectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_flipselector_selected_item_get(self.obj))

    property first_interval:
        """The interval on time updates for a user mouse button hold on a
        flip selector widget.

        This interval value is *decreased* while the user holds the
        mouse pointer either flipping up or flipping down a given flip
        selector.

        This helps the user to get to a given item distant from the
        current one easier/faster, as it will start to flip quicker and
        quicker on mouse button holds.

        The calculation for the next flip interval value, starting from
        the one set with this call, is the previous interval divided by
        1.05, so it decreases a little bit.

        The default starting interval value for automatic flips is
        *0.85 seconds*.

        :type: float

        """
        def __set__(self, interval):
            elm_flipselector_first_interval_set(self.obj, interval)

        def __get__(self):
            return elm_flipselector_first_interval_get(self.obj)

    def callback_selected_add(self, func, *args, **kwargs):
        """When the widget's selected text item is changed."""
        self._callback_add("selected", func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del("selected", func)

    def callback_overflowed_add(self, func, *args, **kwargs):
        """When the widget's current selection is changed from the first
        item in its list to the last."""
        self._callback_add("overflowed", func, *args, **kwargs)

    def callback_overflowed_del(self, func):
        self._callback_del("overflowed", func)

    def callback_underflowed_add(self, func, *args, **kwargs):
        """When the widget's current selection is changed from the last item
        in its list to the first."""
        self._callback_add("underflowed", func, *args, **kwargs)

    def callback_underflowed_del(self, func):
        self._callback_del("underflowed", func)


_object_mapping_register("elm_flipselector", FlipSelector)
