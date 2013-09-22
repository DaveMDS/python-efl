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

.. image:: /images/colorselector-preview.png

Widget description
------------------

A Colorselector is a color selection widget.

It allows application to set a series of colors. It also allows to
load/save colors from/to config with a unique identifier, by default,
the colors are loaded/saved from/to config using "default" identifier.
The colors can be picked by user from the color set by clicking on
individual color item on the palette or by selecting it from selector.

This widget emits the following signals, besides the ones sent from
:py:class:`elementary.layout.Layout`:

- ``"changed"`` - When the color value changes on selector
- ``"color,item,selected"`` - When user clicks on color item.
    The event_info parameter of the callback will be the selected
    color item.
- ``"color,item,longpressed"`` - When user long presses on color item.
    The event_info parameter of the callback will be the selected
    color item.
- ``focused`` - When the colorselector has received focus. (since 1.8)
- ``unfocused`` - When the colorselector has lost focus. (since 1.8)


Enumerations
------------

.. _Elm_Colorselector_Mode:

Colorselector modes
===================

.. data:: ELM_COLORSELECTOR_PALETTE

    Show palette

.. data:: ELM_COLORSELECTOR_COMPONENTS

    Show components

.. data:: ELM_COLORSELECTOR_BOTH

    Show palette and components

"""

include "widget_header.pxi"
include "callback_conversions.pxi"

from object_item cimport ObjectItem
from layout_class cimport LayoutClass

cimport enums

ELM_COLORSELECTOR_PALETTE = enums.ELM_COLORSELECTOR_PALETTE
ELM_COLORSELECTOR_COMPONENTS = enums.ELM_COLORSELECTOR_COMPONENTS
ELM_COLORSELECTOR_BOTH = enums.ELM_COLORSELECTOR_BOTH

cdef class ColorselectorPaletteItem(ObjectItem):

    """An item for the :py:class:`Colorselector` widget."""

    def __init__(self, evasObject cs, r, g, b, a):
        cdef Elm_Object_Item *item = elm_colorselector_palette_color_add(cs.obj, r, g, b, a)
        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    property color:
        """The palette items color.

        :type: (int **r**, int **g**, int **b**, int **a**)

        """
        def __get__(self):
            cdef int r, g, b, a
            elm_colorselector_palette_item_color_get(self.item, &r, &g, &b, &a)
            return (r, g, b, a)
        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            elm_colorselector_palette_item_color_set(self.item, r, g, b, a)

    def color_get(self):
        cdef int r, g, b, a
        elm_colorselector_palette_item_color_get(self.item, &r, &g, &b, &a)
        return (r, g, b, a)
    def color_set(self, r, g, b, a):
        elm_colorselector_palette_item_color_set(self.item, r, g, b, a)

cdef class Colorselector(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent):
        self._set_obj(elm_colorselector_add(parent.obj))

    property color:
        """The current color (r, g, b, a).

        :type: (int **r**, int **g**, int **b**, int **a**)

        """
        def __get__(self):
            cdef int r, g, b, a
            elm_colorselector_color_get(self.obj, &r, &g, &b, &a)
            return (r, g, b, a)
        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            elm_colorselector_color_set(self.obj, r, g, b, a)

    def color_set(self, r, g, b, a):
        elm_colorselector_color_set(self.obj, r, g, b, a)
    def color_get(self):
        cdef int r, g, b, a
        elm_colorselector_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    property mode:
        """Colorselector's mode.

        Colorselector supports three modes palette only, selector only and both.

        :type: :ref:`Elm_Colorselector_Mode`

        """
        def __get__(self):
            return elm_colorselector_mode_get(self.obj)
        def __set__(self, mode):
            elm_colorselector_mode_set(self.obj, mode)

    def mode_set(self, mode):
        elm_colorselector_mode_set(self.obj, mode)
    def mode_get(self):
        return elm_colorselector_mode_get(self.obj)

    def palette_color_add(self, r, g, b, a):
        """palette_color_add(int r, int g, int b, int a) -> ColorselectorPaletteItem

        Add a new color item to palette.

        :param r: r-value of color
        :type r: int
        :param g: g-value of color
        :type g: int
        :param b: b-value of color
        :type b: int
        :param a: a-value of color
        :type a: int
        :return: A new color palette Item.
        :rtype: :py:class:`ColorselectorPaletteItem`

        """
        return ColorselectorPaletteItem(self, r, g, b, a)

    def palette_clear(self):
        """palette_clear()

        Clear the palette items."""
        elm_colorselector_palette_clear(self.obj)

    property palette_name:
        """The current palette's name

        When colorpalette name is set, colors will be loaded from and saved
        to config using the set name. If no name is set then colors will be
        loaded from or saved to "default" config.

        :type: string

        """
        def __get__(self):
            return self.palette_name_get()
        def __set__(self, palette_name):
            self.palette_name_set(palette_name)

    cpdef palette_name_set(self, palette_name):
        s = palette_name
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        elm_colorselector_palette_name_set(self.obj,
            <const_char *>s if s is not None else NULL)
    cpdef palette_name_get(self):
        return _ctouni(elm_colorselector_palette_name_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """When the color value changes on selector"""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_color_item_selected_add(self, func, *args, **kwargs):
        """When user clicks on color item. The event_info parameter of the
        callback will be the selected color item."""
        self._callback_add_full("color,item,selected",
                                _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_color_item_selected_del(self, func):
        self._callback_del_full("color,item,selected",
                                _cb_object_item_conv, func)

    def callback_color_item_longpressed_add(self, func, *args, **kwargs):
        """When user long presses on color item. The event_info parameter of
        the callback will be the selected color item."""
        self._callback_add_full("color,item,longpressed",
                                _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_color_item_longpressed_del(self, func):
        self._callback_del_full("color,item,longpressed",
                                _cb_object_item_conv, func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the check has received focus.

        :since: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the check has lost focus.

        :since: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("elm_colorselector", Colorselector)
