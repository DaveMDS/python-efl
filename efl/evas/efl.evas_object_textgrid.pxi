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

from libc.stdlib cimport malloc


cdef class TextgridCell(object):
    """

    The values that describe each cell.

    .. versionadded:: 1.8

    """

    cdef Evas_Textgrid_Cell *cell

    def __str__(self):
        return "%s" % (self.codepoint,)

    def __repr__(self):
        return "<%s(codepoint = %s, fg = %s, bg = %s, bold = %s, \
            italic = %s, underline = %s, strikethrough = %s, \
            fg_extended = %s, bg_extended = %s, double_width = %s)>" % (
            type(self).__name__, self.codepoint,
            self.fg, self.bg, self.bold, self.italic,
            self.underline, self.strikethrough,
            self.fg_extended, self.bg_extended,
            self.double_width)

    @staticmethod
    cdef TextgridCell create(Evas_Textgrid_Cell *cell):
        if cell == NULL:
            raise ValueError("Invalid pointer for evas textgrid cell!")
        cdef TextgridCell ret = TextgridCell.__new__(TextgridCell)
        ret.cell = cell
        return ret

    property codepoint:
        """the UNICODE value of the character

        :type: unicode

        """
        def __set__(self, value):
            if not isinstance(value, unicode):
                value = value.decode("UTF-8")

            self.cell.codepoint = <Py_UCS4>value

        def __get__(self):
            return <unicode><Py_UCS4>self.cell.codepoint

    property fg:
        """the index of the palette for the foreground color

        :type: int

        """
        def __set__(self, int value):
            self.cell.fg = value

        def __get__(self):
            return self.cell.fg

    property bg:
        """the index of the palette for the background color

        :type: int

        """
        def __set__(self, int value):
            self.cell.bg = value

        def __get__(self):
            return self.cell.bg

    property bold:
        """whether the character is bold

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.bold = value

        def __get__(self):
            return <bint>self.cell.bold

    property italic:
        """whether the character is oblique

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.italic = value

        def __get__(self):
            return <bint>self.cell.italic

    property underline:
        """whether the character is underlined

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.underline = value

        def __get__(self):
            return <bint>self.cell.underline

    property strikethrough:
        """whether the character is strikethrough'ed

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.strikethrough = value

        def __get__(self):
            return <bint>self.cell.strikethrough

    property fg_extended:
        """whether the extended palette is used for the foreground color

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.fg_extended = value

        def __get__(self):
            return <bint>self.cell.fg_extended

    property bg_extended:
        """whether the extended palette is used for the background color

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.bg_extended = value

        def __get__(self):
            return <bint>self.cell.bg_extended

    property double_width:
        """If the codepoint is merged with the following cell to the right
        visually (cells must be in pairs with 2nd cell being a duplicate in
        all ways except codepoint is 0)

        :type: bool

        """
        def __set__(self, bint value):
            self.cell.double_width = value

        def __get__(self):
            return <bint>self.cell.double_width


cdef class TextgridCellRow:

    cdef:
        Evas_Textgrid_Cell *row
        unsigned int rowsize

    @staticmethod
    cdef TextgridCellRow create(Evas_Textgrid_Cell *row, unsigned int rowsize):
        if row == NULL:
            raise ValueError("Invalid pointer for evas textgrid cell row!")
        cdef TextgridCellRow ret = TextgridCellRow.__new__(TextgridCellRow)
        ret.row = row
        ret.rowsize = rowsize
        return ret

    def __len__(self):
        return self.rowsize

    def __getitem__(self, x):
        if x > self.rowsize - 1:
            raise IndexError
        if x < 0:
            x = self.rowsize - x
        if x < 0:
            raise IndexError
        return TextgridCell.create(&self.row[x])


cdef class Textgrid(Object):
    """

    A textgrid object.

    .. versionadded:: 1.8

    """
    def __init__(self, Canvas canvas not None, **kwargs):
        """Textgrid(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(evas_object_textgrid_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

    property size:
        """The size of the textgrid object.

        The number of lines **h** and the number of columns **w** of the
        textgrid object. Values less than or equal to 0 are ignored.

        :type: (int **w**, int **h**)

        """
        def __set__(self, value):
            cdef int w, h
            w, h = value
            evas_object_textgrid_size_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            evas_object_textgrid_size_get(self.obj, &w, &h)
            return (w, h)

    property font_source:
        """The font (source) file used on a given textgrid object.

        This allows the font file to be explicitly set for the textgrid object,
        overriding system lookup, which will first occur in the given file's
        contents. If None or an empty string is assigned, or the same
        font_source has already been set, or on error, this does nothing.

        :type: string

        .. seealso:: :py:attr:`font`

        """
        def __set__(self, font_source):
            a1 = font_source
            if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
            evas_object_textgrid_font_source_set(self.obj,
                <const char *>a1 if a1 is not None else NULL)

        def __get__(self):
            return _ctouni(evas_object_textgrid_font_source_get(self.obj))

    property font:
        """The font family and size on a given textgrid object.

        This property allows the **font_name** and
        **font_size** of the textgrid object to be set. The **font_name**
        string has to follow fontconfig's convention on naming fonts, as
        it's the underlying library used to query system fonts by Evas (see
        the ``fc``-list command's output, on your system, to get an
        idea). It also has to be a monospace font. If **font_name** is
        ``None``, or if it is an empty string, or if **font_size** is less or
        equal than 0, or on error, this function does nothing.

        :type: (string **font_name**, int **font_size**)

        :see: :py:attr:`font_source`

        """
        def __set__(self, value):
            cdef int font_size
            font_name, font_size = value
            a1 = font_name
            if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
            evas_object_textgrid_font_set(self.obj,
                <const char *>a1 if a1 is not None else NULL,
                font_size)

        def __get__(self):
            cdef:
                const char *font_name
                Evas_Font_Size font_size
            evas_object_textgrid_font_get(self.obj, &font_name, &font_size)
            # font_name is owned by Evas, don't free it
            return (_ctouni(font_name), font_size)

    property cell_size:
        """The width and height of a cell in pixels.

        This read-only property has the width and height, in pixels, of a cell
        of the textgrid object. Their value depends on the monospace font used
        for the textgrid object, as well as the style. On error, they are set
        to 0.

        :type: (int **width**, int **height**)

        .. seealso::

            :py:attr:`font`
            :py:attr:`supported_font_styles`

        """
        def __get__(self):
            cdef:
                Evas_Coord w, h
            evas_object_textgrid_cell_size_get(self.obj, &w, &h)
            return (w, h)

    def palette_set(self, Evas_Textgrid_Palette pal, int idx, int r, int g, int b, int a):
        """Set color to the given palette at the given index.

        :param pal: The type of the palette to set the color.
        :type pal: :ref:`Evas_Textgrid_Palette`
        :param int idx: The index of the paletter to which the color is stored.
        :param int r: The red component of the color.
        :param int g: The green component of the color.
        :param int b: The blue component of the color.
        :param int a: The alpha component of the color.

        This function sets the color for the palette of type **pal** at the
        index **idx** of the textgrid object. The ARGB components are given by
        **r**, **g**, **b** and **a**. This color can be used when setting the
        :py:class:`TextgridCell` object. The components must set a pre-
        multiplied color. If pal is EVAS_TEXTGRID_PALETTE_NONE or
        EVAS_TEXTGRID_PALETTE_LAST, or if **idx** is not between 0 and 255, or
        on error, this function does nothing. The color components are clamped
        between 0 and 255. If **idx** is greater than the latest set color, the
        colors between this last index and **idx** - 1 are set to black (0, 0,
        0, 0).

        :see: :py:func:`palette_get`

        """
        evas_object_textgrid_palette_set(self.obj, pal, idx, r, g, b, a)

    def palette_get(self, Evas_Textgrid_Palette pal, int idx):
        """Retrieve color from the given palette at the given index.

        :param pal: The type of the palette to set the color.
        :type pal: :ref:`Evas_Textgrid_Palette`
        :param int idx: The index of the palette to which the color is stored.
        :rtype: (int **r**, int **g**, int **b**, int **a**)

        This method retrieves the color for the palette of type **pal** at
        the index **idx** of the textgrid object. The ARGB components are
        stored in the buffers **r**, **g**, **b** and **a**. If **idx** is not
        between 0 and the index of the latest set color, or if **pal** is
        EVAS_TEXTGRID_PALETTE_NONE or EVAS_TEXTGRID_PALETTE_LAST, the values of
        the components are 0.

        :see: :py:meth:`palette_set`

        """
        cdef:
            int r, g, b, a
        evas_object_textgrid_palette_get(self.obj, pal, idx, &r, &g, &b, &a)
        return (r, g, b, a)


    property supported_font_styles:
        """ TODO: document this """
        def __set__(self, Evas_Textgrid_Font_Style styles):
            evas_object_textgrid_supported_font_styles_set(self.obj, styles)

        def __get__(self):
            return evas_object_textgrid_supported_font_styles_get(self.obj)

    def cellrow_set(self, int y, TextgridCellRow row not None):
        """Set the string at the given row.

        :param y: The row index of the grid.
        :type y: int
        :param row: The string as a sequence of :class:`TextgridCell`.
        :type row: :class:`TextgridCellRow`

        This method allows returning cells to the textgrid, retrieved with
        :py:meth:`cellrow_get`.

        .. seealso::

            :py:meth:`cellrow_get`
            :py:attr:`size`
            :py:meth:`update_add`

        """
        evas_object_textgrid_cellrow_set(self.obj, y, row.row)

    def cellrow_get(self, int y):
        """Get the string at the given row.

        :param int y: The row index of the grid.
        :return: A list of :class:`TextgridCell`
        :rtype: :class:`TextgridCellRow`

        This method returns a list of cells in the line **y** of
        the textgrid object. If **y** is not between 0 and the number
        of lines of the grid - 1, or on error, this function return ``None``.

        .. seealso::

            :py:meth:`cellrow_set`
            :py:attr:`size`
            :py:meth:`update_add`

        """
        return TextgridCellRow.create(
            evas_object_textgrid_cellrow_get(self.obj, y), self.size[0])

    def update_add(self, int x, int y, int w, int h):
        """Indicate for evas that part of a textgrid region (cells) has been updated.

        :param int x: The rect region of cells top-left x (column)
        :param int y: The rect region of cells top-left y (row)
        :param int w: The rect region size in number of cells (columns)
        :param int h: The rect region size in number of cells (rows)

        This method declares to evas that a region of cells was updated by
        code and needs refreshing. An application should modify cells like this
        as an example::

            cells = tg.cellrow_get(row)
            for i in range(width):
                cells[i].codepoint = 'E'
            tg.cellrow_set(row, cells)
            tg.update_add(0, row, width, 1)

        .. seealso::

            :py:meth:`cellrow_set`
            :py:meth:`cellrow_get`
            :py:attr:`size`

        """
        evas_object_textgrid_update_add(self.obj, x, y, w, h)

_object_mapping_register("Evas_Textgrid", Textgrid)
