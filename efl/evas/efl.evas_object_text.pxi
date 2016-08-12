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


cdef class Text(Object):
    """

    A Text object.

    """

    def __init__(self, Canvas canvas not None, font=None, shadow_color=None,
                 glow_color=None, glow2_color=None, outline_color=None,
                 **kwargs):
        """Text(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword font: Font name
        :type font: string
        :keyword shadow_color: The shadow color
        :type shadow_color: tuple of ints
        :keyword glow_color: The primary glow color
        :type glow_color: tuple of ints
        :keyword glow2_color: The secondary glow color
        :type glow2_color: tuple of ints
        :keyword outline_color: The outline color
        :type outline_color: tuple of ints
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(evas_object_text_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

        if font:
            if not isinstance(font, (tuple, list)):
                font = (font,)
            self.font_set(*font)
        if shadow_color is not None:
            self.shadow_color_set(*color_parse(shadow_color))
        if glow_color is not None:
            self.glow_color_set(*color_parse(glow_color))
        if glow2_color is not None:
            self.glow2_color_set(*color_parse(glow2_color))
        if outline_color is not None:
            self.outline_color_set(*color_parse(outline_color))

    property font_source:
        """Set the font (source) file to be used on a given text object.

        :param font: The font file's path.

        This function allows the font file to be explicitly set for a given
        text object, overriding system lookup, which will first occur in
        the given file's contents.

        :see: :py:attr:`font`

        """
        def __get__(self):
            return self.font_source_get()

        def __set__(self, value):
            self.font_source_set(value)

    def font_source_get(self):
        return _ctouni(evas_object_text_font_source_get(self.obj))

    def font_source_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_object_text_font_source_set(self.obj,
            <const char *>value if value is not None else NULL)

    property font:
        """Set the font family and size on a given text object.

        :param font: The font (family) name.
        :param size: The font size, in points.

        This function allows the font name and size of a text object to be
        set. The ``font`` string has to follow fontconfig's convention on
        naming fonts, as it's the underlying library used to query system
        fonts by Evas (see the ``fc-list`` command's output, on your system,
        to get an idea).

        :see: :py:attr:`font_source`

        """
        def __get__(self):
            return self.font_get()

        def __set__(self, spec):
            if not isinstance(spec, (tuple, list)):
                spec = (spec,)
            self.font_set(*spec)

    def font_get(self):
        cdef const char *f
        cdef int size
        evas_object_text_font_get(self.obj, &f, &size)
        return (_ctouni(f), size)

    def font_set(self, font, int size=10):
        if isinstance(font, unicode): font = PyUnicode_AsUTF8String(font)
        evas_object_text_font_set(self.obj,
            <const char *>font if font is not None else NULL,
            size)

    property text:
        """Sets the text string to be displayed by the given text object.

        :type: unicode

        """
        def __get__(self):
            return self.text_get()

        def __set__(self, value):
            self.text_set(value)

    def text_get(self):
        return _ctouni(evas_object_text_text_get(self.obj))

    def text_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_object_text_text_set(self.obj,
            <const char *>value if value is not None else NULL)

    property ascent:
        """:type: int"""
        def __get__(self):
            return self.ascent_get()

    def ascent_get(self):
        return evas_object_text_ascent_get(self.obj)

    property descent:
        """:type: int"""
        def __get__(self):
            return self.descent_get()

    def descent_get(self):
        return evas_object_text_descent_get(self.obj)

    property max_ascent:
        """:type: int"""
        def __get__(self):
            return self.max_ascent_get()

    def max_ascent_get(self):
        return evas_object_text_max_ascent_get(self.obj)

    property max_descent:
        """:type: int"""
        def __get__(self):
            return self.max_descent_get()

    def max_descent_get(self):
        return evas_object_text_max_descent_get(self.obj)

    property horiz_advance:
        """:type: int"""
        def __get__(self):
            return self.horiz_advance_get()

    def horiz_advance_get(self):
        return evas_object_text_horiz_advance_get(self.obj)

    property vert_advance:
        """:type: int"""
        def __get__(self):
            return self.vert_advance_get()

    def vert_advance_get(self):
        return evas_object_text_vert_advance_get(self.obj)

    property inset:
        """:type: int"""
        def __get__(self):
            return self.inset_get()

    def inset_get(self):
        return evas_object_text_inset_get(self.obj)

    def char_pos_get(self, int char_index):
        """Retrieve position and dimension information of a character.

        This function is used to obtain the **x**, **y**, **width** and **height**
        of a the character located at **char_index** within this object.

        :param char_index: index of desired character.
        :rtype: (int **x**, int **y**, int **w**, int **h**)

        """
        cdef int x, y, w, h, r
        r = evas_object_text_char_pos_get(self.obj, char_index, &x, &y, &w, &h)
        if r == 0:
            return None
        else:
            return (x, y, w, h)

    def char_coords_get(self, int x, int y):
        """Retrieve position and dimension information of a character at
        desired position.

        Like :py:func:`char_pos_get`, but instead of providing the character
        index one can give its position.

        :param x:
        :param y:
        :rtype: (int **x**, int **y**, int **w**, int **h**)

        """
        cdef int cx, cy, cw, ch, c
        c = evas_object_text_char_coords_get(self.obj, x, y,
                                             &cx, &cy, &cw, &ch)
        if c < 0:
            return None
        else:
            return ("%c" % c, cx, cy, cw, ch)

    property style:
        """Text drawing style.

        One of:

        - EVAS_TEXT_STYLE_PLAIN
        - EVAS_TEXT_STYLE_SHADOW
        - EVAS_TEXT_STYLE_OUTLINE
        - EVAS_TEXT_STYLE_SOFT_OUTLINE
        - EVAS_TEXT_STYLE_GLOW
        - EVAS_TEXT_STYLE_OUTLINE_SHADOW
        - EVAS_TEXT_STYLE_FAR_SHADOW
        - EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW
        - EVAS_TEXT_STYLE_SOFT_SHADOW
        - EVAS_TEXT_STYLE_FAR_SOFT_SHADOW

        :type: Evas_Text_Style_Type

        """
        def __get__(self):
            return self.style_get()

        def __set__(self, int value):
            self.style_set(value)

    def style_get(self):
        return evas_object_text_style_get(self.obj)

    def style_set(self, int value):
        evas_object_text_style_set(self.obj, <Evas_Text_Style_Type>value)

    property shadow_color:
        """:type: (int **r**, int **g**, int **b**, int **a**)"""
        def __get__(self):
            return self.shadow_color_get()

        def __set__(self, spec):
            self.shadow_color_set(*spec)

    def shadow_color_get(self):
        cdef int r, g, b, a
        evas_object_text_shadow_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    def shadow_color_set(self, int r, int g, int b, int a):
        evas_object_text_shadow_color_set(self.obj, r, g, b, a)

    property glow_color:
        """:type: (int **r**, int **g**, int **b**, int **a**)"""
        def __get__(self):
            return self.glow_color_get()

        def __set__(self, spec):
            self.glow_color_set(*spec)

    def glow_color_get(self):
        cdef int r, g, b, a
        evas_object_text_glow_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    def glow_color_set(self, int r, int g, int b, int a):
        evas_object_text_glow_color_set(self.obj, r, g, b, a)

    property glow2_color:
        """:type: (int **r**, int **g**, int **b**, int **a**)"""
        def __get__(self):
            return self.glow2_color_get()

        def __set__(self, spec):
            self.glow2_color_set(*spec)

    def glow2_color_get(self):
        cdef int r, g, b, a
        evas_object_text_glow2_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    def glow2_color_set(self, int r, int g, int b, int a):
        evas_object_text_glow2_color_set(self.obj, r, g, b, a)

    property outline_color:
        """:type: (int **r**, int **g**, int **b**, int **a**)"""
        def __get__(self):
            return self.outline_color_get()

        def __set__(self, spec):
            self.outline_color_set(*spec)

    def outline_color_get(self):
        cdef int r, g, b, a
        evas_object_text_outline_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    def outline_color_set(self, int r, int g, int b, int a):
        evas_object_text_outline_color_set(self.obj, r, g, b, a)

    property style_pad:
        """:type: (int **l**, int **r**, int **t**, int **b**)"""
        def __get__(self):
            return self.style_pad_get()

    def style_pad_get(self):
        cdef int l, r, t, b
        evas_object_text_style_pad_get(self.obj, &l, &r, &t, &b)
        return (l, r, t, b)


_object_mapping_register("Evas_Text", Text)
