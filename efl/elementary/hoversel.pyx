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

Widget description
------------------

.. image:: /images/hoversel-preview.png
    :align: left

A hoversel is a button that pops up a list of items (automatically
choosing the direction to display) that have a label and, optionally, an
icon to select from.

It is a convenience widget to avoid the need to do all the piecing
together yourself. It is intended for a small number of items in the
hoversel menu (no more than 8), though is capable of many more.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.button.Button`:

- ``clicked`` - the user clicked the hoversel button and popped up
  the sel
- ``selected`` - an item in the hoversel list is selected. event_info
  is the item
- ``dismissed`` - the hover is dismissed
- ``expanded`` - the hover is expanded (since 1.9)

Default content parts of the hoversel widget that you can use for are:

- ``icon`` - An icon of the hoversel

Default text parts of the hoversel widget that you can use for are:

- ``default`` - Label of the hoversel


Enumerations
------------

.. _Elm_Hoversel_Icon_Type:

Icon types
==========

.. data:: ELM_ICON_NONE

    No icon

.. data:: ELM_ICON_FILE

    Icon is a file

.. data:: ELM_ICON_STANDARD

    Icon is set with standards names

"""

from cpython cimport PyUnicode_AsUTF8String, Py_DECREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object_item cimport ObjectItem, _object_item_callback, \
    _object_item_list_to_python, _object_item_to_python, _object_item_callback2
from button cimport Button

cimport enums

ELM_ICON_NONE = enums.ELM_ICON_NONE
ELM_ICON_FILE = enums.ELM_ICON_FILE
ELM_ICON_STANDARD = enums.ELM_ICON_STANDARD

def _cb_object_item_conv(uintptr_t addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef class HoverselItem(ObjectItem):

    """

    An item for the :py:class:`Hoversel` widget.

    """
    cdef:
        object label, icon_file, icon_group
        Elm_Icon_Type icon_type

    def __init__(self, label = None, icon_file = None,
            icon_type = ELM_ICON_NONE, callback = None, cb_data = None,
            *args, **kwargs):
        """For more information on what ``icon_file`` and ``icon_type`` are,
        see :py:class:`~efl.elementary.icon.Icon`.

        :param label: The text label to use for the item (None if not desired)
        :type label: string
        :param icon_file: An image file path on disk to use for the icon or
            standard icon name (None if not desired)
        :type icon_file: string
        :param icon_type: The icon type if relevant
        :type icon_type: :ref:`Elm_Hoversel_Icon_Type`
        :param callback: Convenience function to call when this item is
            selected
        :type callback: function

        """
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        if isinstance(icon_file, unicode): icon_file = PyUnicode_AsUTF8String(icon_file)
        self.label = label
        self.icon_file = icon_file
        self.icon_type = icon_type

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")

        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kwargs

    def add_to(self, Hoversel hoversel):
        """add_to(Hoversel hoversel)

        Add an item to the hoversel button

        This adds an item to the hoversel to show when it is clicked.

        .. note::
            If you need to use an icon from an edje file then
            use :py:attr:`HoverselItem.icon` right after this function.

        :return: The item added.
        :rtype: HoverselItem

        """
        cdef Evas_Smart_Cb cb = NULL
        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_hoversel_item_add(hoversel.obj,
            <const_char *>self.label if self.label is not None else NULL,
            <const_char *>self.icon_file if self.icon_file is not None else NULL,
            self.icon_type,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property icon:
        """This sets the icon for the given hoversel item.

        The icon can be loaded from the standard set, from an image file, or
        from an edje file.

        :type: (string file, string group, :ref:`Elm_Icon_Type` type)

        """
        def __set__(self, value):
            icon_file, icon_group, icon_type = value
            a1, a2, a3 = icon_file, icon_group, icon_type
            if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
            if isinstance(a2, unicode): a2 = PyUnicode_AsUTF8String(a2)
            if self.item == NULL:
                self.icon_file = a1
                self.icon_group = a2
                self.icon_type = a3
            else:
                elm_hoversel_item_icon_set(self.item,
                    <const_char *>a1 if a1 is not None else NULL,
                    <const_char *>a2 if a2 is not None else NULL,
                    a3)

        def __get__(self):
            cdef:
                const_char *icon_file
                const_char *icon_group
                Elm_Icon_Type icon_type

            if self.item == NULL:
                a1 = self.icon_file.decode("UTF-8")
                a2 = self.icon_group.decode("UTF-8")
                a3 = self.icon_type
                return (a1, a2, a3)
            else:
                elm_hoversel_item_icon_get(self.item, &icon_file, &icon_group, &icon_type)
                return (_ctouni(icon_file), _ctouni(icon_group), icon_type)

    def icon_set(self, icon_file, icon_group, icon_type):
        a1, a2, a3 = icon_file, icon_group, icon_type
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if isinstance(a2, unicode): a2 = PyUnicode_AsUTF8String(a2)
        if self.item == NULL:
            self.icon_file = a1
            self.icon_group = a2
            self.icon_type = a3
        else:
            elm_hoversel_item_icon_set(self.item,
                <const_char *>a1 if a1 is not None else NULL,
                <const_char *>a2 if a2 is not None else NULL,
                a3)
    def icon_get(self):
        cdef:
            const_char *icon_file
            const_char *icon_group
            Elm_Icon_Type icon_type

        if self.item == NULL:
            a1 = self.icon_file.decode("UTF-8")
            a2 = self.icon_group.decode("UTF-8")
            a3 = self.icon_type
            return (a1, a2, a3)
        else:
            elm_hoversel_item_icon_get(self.item, &icon_file, &icon_group, &icon_type)
            return (_ctouni(icon_file), _ctouni(icon_group), icon_type)

cdef class Hoversel(Button):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_hoversel_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property horizontal:
        """Whether the hoversel is set to expand horizontally.

        .. note:: The initial button will display horizontally regardless of
            this setting.

        :type: bool

        """
        def __set__(self, horizontal):
            elm_hoversel_horizontal_set(self.obj, horizontal)

        def __get__(self):
            return bool(elm_hoversel_horizontal_get(self.obj))

    def horizontal_set(self, horizontal):
        elm_hoversel_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return bool(elm_hoversel_horizontal_get(self.obj))

    property hover_parent:
        """The Hover parent.

        The hover parent object, the area that will be darkened when the
        hoversel is clicked. Should probably be the window that the hoversel
        is in. See :py:class:`~efl.elementary.hover.Hover` objects for more
        information.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __set__(self, evasObject parent):
            elm_hoversel_hover_parent_set(self.obj, parent.obj)

        def __get__(self):
            return object_from_instance(elm_hoversel_hover_parent_get(self.obj))

    def hover_parent_set(self, evasObject parent):
        elm_hoversel_hover_parent_set(self.obj, parent.obj)
    def hover_parent_get(self):
        return object_from_instance(elm_hoversel_hover_parent_get(self.obj))

    def hover_begin(self):
        """hover_begin()

        This triggers the hoversel popup from code, the same as if the user
        had clicked the button.

        """
        elm_hoversel_hover_begin(self.obj)

    def hover_end(self):
        """hover_end()

        This dismisses the hoversel popup as if the user had clicked outside
        the hover.

        """
        elm_hoversel_hover_end(self.obj)

    property expanded:
        """Returns whether the hoversel is expanded.

        :type: bool

        """
        def __get__(self):
            return bool(elm_hoversel_expanded_get(self.obj))

    def expanded_get(self):
        return bool(elm_hoversel_expanded_get(self.obj))

    def clear(self):
        """clear()

        This will remove all the children items from the hoversel.

        .. warning:: Should **not** be called while the hoversel is active;
            use :py:attr:`expanded` to check first.

        .. seealso:: :py:meth:`~efl.elementary.object_item.ObjectItem.delete`

        """
        elm_hoversel_clear(self.obj)

    property items:
        """Get the list of items within the given hoversel.

        .. seealso:: :py:func:`HoverselItem.add_to()`

        :type: tuple of :py:class:`HoverselItem`'s

        """
        def __get__(self):
            return _object_item_list_to_python(elm_hoversel_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_hoversel_items_get(self.obj))

    def item_add(self, label = None, icon_file = None,
        icon_type = ELM_ICON_NONE, callback = None, *args, **kwargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            HoverselItem ret = HoverselItem.__new__(HoverselItem)

        if callback is not None and callable(callback):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        if isinstance(icon_file, unicode): icon_file = PyUnicode_AsUTF8String(icon_file)

        item = elm_hoversel_item_add(self.obj,
            <const_char *>label if label is not None else NULL,
            <const_char *>icon_file if icon_file is not None else NULL,
            icon_type,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = callback
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    def callback_clicked_add(self, func, *args, **kwargs):
        """The user clicked the hoversel button and popped up the sel."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_selected_add(self, func, *args, **kwargs):
        """An item in the hoversel list is selected. event_info is the item."""
        self._callback_add_full("selected", _cb_object_item_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """The hover is dismissed."""
        self._callback_add("dismissed", func, *args, **kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)

    def callback_expanded_add(self, func, *args, **kwargs):
        """The hover is expanded.
        
        .. versionadded:: 1.9

        """
        self._callback_add("expanded", func, *args, **kwargs)

    def callback_expanded_del(self, func):
        self._callback_del("expanded", func)


_object_mapping_register("Elm_Hoversel", Hoversel)
