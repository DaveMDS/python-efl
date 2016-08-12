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
#


include "colorselector_cdef.pxi"

cdef class ColorselectorPaletteItem(ObjectItem):
    """

    An item for the :py:class:`Colorselector` widget.

    """

    cdef int r, g, b, a

    def __init__(self, int r, int g, int b, int a, *args, **kwargs):
        """ColorselectorPaletteItem(...)

        :param r: Red value of color
        :type r: int
        :param g: Green value of color
        :type g: int
        :param b: Blue value of color
        :type b: int
        :param a: Alpha value of color
        :type a: int
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self.r, self.g, self.b, self.a = r, g, b, a
        self.args, self.kwargs = args, kwargs

    def add_to(self, evasObject cs):
        cdef Elm_Object_Item *item
        item = elm_colorselector_palette_color_add(
            cs.obj, self.r, self.g, self.b, self.a)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

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

    property selected:
        """Whenever the palette item is selected or not.

        :type: bool

        .. versionadded:: 1.9

        """
        def __get__(self):
            return bool(elm_colorselector_palette_item_selected_get(self.item))

        def __set__(self, bint selected):
            elm_colorselector_palette_item_selected_set(self.item, selected)

    def selected_get(self):
        return bool(elm_colorselector_palette_item_selected_get(self.item))
    def selected_set(self, bint selected):
        elm_colorselector_palette_item_selected_set(self.item, selected)


cdef class Colorselector(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Colorselector(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_colorselector_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

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
        """Add a new color item to palette.

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
        return ColorselectorPaletteItem(r, g, b, a).add_to(self)

    def palette_clear(self):
        """Clear the palette items."""
        elm_colorselector_palette_clear(self.obj)

    property palette_name:
        """The current palette's name

        When colorpalette name is set, colors will be loaded from and saved
        to config using the set name. If no name is set then colors will be
        loaded from or saved to "default" config.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_colorselector_palette_name_get(self.obj))
        def __set__(self, palette_name):
            s = palette_name
            if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
            elm_colorselector_palette_name_set(self.obj,
                <const char *>s if s is not None else NULL)

    def palette_name_set(self, palette_name):
        s = palette_name
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        elm_colorselector_palette_name_set(self.obj,
            <const char *>s if s is not None else NULL)
    def palette_name_get(self):
        return _ctouni(elm_colorselector_palette_name_get(self.obj))

    def palette_items_get(self):
        """Get a list of palette items (colors).

        :return: A list of palette Items.
        :rtype: list of :py:class:`ColorselectorPaletteItem`

        .. versionadded:: 1.9

        """
        cdef:
            list ret = list()
            const Eina_List *lst = elm_colorselector_palette_items_get(self.obj)

        while lst:
            ret.append(_object_item_to_python(<Elm_Object_Item *>lst.data))
            lst = lst.next

        return ret

    def palette_selected_item_get(self):
        """Get the selected item in the palette.

        :return: the selected item.
        :rtype: list of :py:class:`ColorselectorPaletteItem`

        .. versionadded:: 1.9

        """
        cdef Elm_Object_Item *it = elm_colorselector_palette_selected_item_get(self.obj)
        return _object_item_to_python(it)

    def callback_changed_add(self, func, *args, **kwargs):
        """When the color value changes on selector"""
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_changed_user_add(self, func, *args, **kwargs):
        """When the color value is changed by the user

        .. versionadded:: 1.14
        """
        self._callback_add("changed,user", func, args, kwargs)

    def callback_changed_user_del(self, func):
        """
        .. versionadded:: 1.14
        """
        self._callback_del("changed,user", func)

    def callback_color_item_selected_add(self, func, *args, **kwargs):
        """When user clicks on color item. The event_info parameter of the
        callback will be the selected color item."""
        self._callback_add_full("color,item,selected",
                                _cb_object_item_conv,
                                func, args, kwargs)

    def callback_color_item_selected_del(self, func):
        self._callback_del_full("color,item,selected",
                                _cb_object_item_conv, func)

    def callback_color_item_longpressed_add(self, func, *args, **kwargs):
        """When user long presses on color item. The event_info parameter of
        the callback will be the selected color item."""
        self._callback_add_full("color,item,longpressed",
                                _cb_object_item_conv,
                                func, args, kwargs)

    def callback_color_item_longpressed_del(self, func):
        self._callback_del_full("color,item,longpressed",
                                _cb_object_item_conv, func)


_object_mapping_register("Elm_Colorselector", Colorselector)
