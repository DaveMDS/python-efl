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


cdef class Textblock(Object):
    """

    A Textblock.

    """

    def __init__(self, Canvas canvas not None, **kwargs):
        """Textblock(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance
        
        """
        self._set_obj(evas_object_textblock_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

    property style:
        """Style

        :type: unicode

        """
        def __get__(self):
            return self.style_get()

        def __set__(self, value):
            self.style_set(value)

    def style_get(self):
        cdef const Evas_Textblock_Style *style
        style = evas_object_textblock_style_get(self.obj)
        return _ctouni(evas_textblock_style_get(style))

    def style_set(self, value):
        cdef Evas_Textblock_Style *style = evas_textblock_style_new()
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_textblock_style_set(style,
            <const char *>value if value is not None else NULL)
        evas_object_textblock_style_set(self.obj, style)
        evas_textblock_style_free(style)

    property text_markup:
        """Markup text

        :type: unicode

        """
        def __get__(self):
            return self.text_markup_get()

        def __set__(self, value):
            self.text_markup_set(value)

    def text_markup_get(self):
        return _ctouni(evas_object_textblock_text_markup_get(self.obj))

    def text_markup_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_object_textblock_text_markup_set(self.obj,
            <const char *>value if value is not None else NULL)

    property replace_char:
        """Replacement character

        :type: unicode

        """
        def __get__(self):
            return self.replace_char_get()

        def __set__(self, value):
            self.replace_char_set(value)

    def replace_char_get(self):
        return _ctouni(evas_object_textblock_replace_char_get(self.obj))

    def replace_char_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_object_textblock_replace_char_set(self.obj,
            <const char *>value if value is not None else NULL)

    def line_number_geometry_get(self, int index):
        """Retrieve position and dimension information of a specific line.

        This function is used to obtain the **x**, **y**, **width** and **height**
        of a the line located at **index** within this object.

        :param index: index of desired line
        :rtype: (int **x**, int **y**, int **w**, int **h**)
        """
        cdef int x, y, w, h, r
        r = evas_object_textblock_line_number_geometry_get(self.obj, index, &x, &y, &w, &h)
        if r == 0:
            return None
        else:
            return (x, y, w, h)

    def clear(self):
        """Clear the Textblock"""
        evas_object_textblock_clear(self.obj)

    property size_formatted:
        """Get the formatted width and height. This calculates the actual size
        after restricting the textblock to the current size of the object. The
        main difference between this and :py:attr:`size_native` is that the
        "native" function does not wrapping into account it just calculates the
        real width of the object if it was placed on an infinite canvas, while
        this function gives the size after wrapping according to the size
        restrictions of the object.

        For example for a textblock containing the text: "You shall not pass!"
        with no margins or padding and assuming a monospace font and a size of
        7x10 char widths (for simplicity) has a native size of 19x1
        and a formatted size of 5x4.

        :type: (int **w**, int **h**)

        :see: :py:attr:`size_native`

        """
        def __get__(self):
            return self.size_formatted_get()

    def size_formatted_get(self):
        cdef int w, h
        evas_object_textblock_size_formatted_get(self.obj, &w, &h)
        return (w, h)

    property size_native:
        """Get the native width and height. This calculates the actual size without
        taking account the current size of the object. The main difference
        between this and :py:attr:`size_formatted` is that the "native" function
        does not take wrapping into account it just calculates the real width of
        the object if it was placed on an infinite canvas, while the "formatted"
        function gives the size after wrapping text according to the size
        restrictions of the object.

        For example for a textblock containing the text: "You shall not pass!"
        with no margins or padding and assuming a monospace font and a size of
        7x10 char widths (for simplicity) has a native size of 19x1
        and a formatted size of 5x4.

        :type: (int **w**, int **h**)

        """
        def __get__(self):
            return self.size_native_get()

    def size_native_get(self):
        cdef int w, h
        evas_object_textblock_size_native_get(self.obj, &w, &h)
        return (w, h)

    property style_insets:
        """Style insets"""
        def __get__(self):
            return self.style_insets_get()

    def style_insets_get(self):
        cdef int l, r, t, b
        evas_object_textblock_style_insets_get(self.obj, &l, &r, &t, &b)
        return (l, r, t, b)

    def obstacle_add(self, Object obstacle):
        """
        Add obstacle evas object to be observed during layout of text.
        The textblock does the layout of the text according to the position
        of the obstacle.

        :param obstacle: An evas object to be used as an obstacle
        :type obstacle: :class:`Object`

        :return: ``True`` on success or ``False`` on failure
        :rtype: bool

        .. versionadded:: 1.15

        """
        return bool(evas_object_textblock_obstacle_add(self.obj, obstacle.obj))

    def obstacle_del(self, Object obstacle):
        """Removes an object from observation during text layout.

        :param obstacle: An evas object to be removed as an obstacle
        :type obstacle: :class:`Object`

        :return: ``True`` on success or ``False`` on failure
        :rtype: bool

        .. versionadded:: 1.15


        """
        return bool(evas_object_textblock_obstacle_del(self.obj, obstacle.obj))

    def obstacles_update(self):
        """Triggers for relayout due to obstacles' state change. 

        The obstacles alone don't affect the layout, until this is called. Use 
        this after doing changes (moving, positioning etc.) in the obstacles 
        that you would like to be considered in the layout. For example: if you 
        have just repositioned the obstacles to differrent coordinates relative 
        to the textblock, you need to call this so it will consider this new 
        state and will relayout the text.

        .. versionadded:: 1.15

        """
        evas_object_textblock_obstacles_update(self.obj)

_object_mapping_register("Efl_Canvas_Text", Textblock)

