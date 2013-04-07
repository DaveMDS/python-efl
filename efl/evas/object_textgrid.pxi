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

"""

Evas_Textgrid_Palette

The palette to use for the forgraound and background colors.

@since 1.7

EVAS_TEXTGRID_PALETTE_NONE,     /**< No palette is used */
EVAS_TEXTGRID_PALETTE_STANDARD, /**< standard palette (around 16 colors) */
EVAS_TEXTGRID_PALETTE_EXTENDED, /**< extended palette (at max 256 colors) */
EVAS_TEXTGRID_PALETTE_LAST      /**< ignore it */

Evas_Textgrid_Font_Style

The style to give to each character of the grid.

@since 1.7

EVAS_TEXTGRID_FONT_STYLE_NORMAL = (1 << 0), /**< Normal style */
EVAS_TEXTGRID_FONT_STYLE_BOLD   = (1 << 1), /**< Bold style */
EVAS_TEXTGRID_FONT_STYLE_ITALIC = (1 << 2)  /**< Oblique style */

"""

EVAS_TEXTGRID_PALETTE_NONE = enums.EVAS_TEXTGRID_PALETTE_NONE
EVAS_TEXTGRID_PALETTE_STANDARD = enums.EVAS_TEXTGRID_PALETTE_STANDARD
EVAS_TEXTGRID_PALETTE_EXTENDED = enums.EVAS_TEXTGRID_PALETTE_EXTENDED
EVAS_TEXTGRID_PALETTE_LAST = enums.EVAS_TEXTGRID_PALETTE_LAST

EVAS_TEXTGRID_FONT_STYLE_NORMAL = enums.EVAS_TEXTGRID_FONT_STYLE_NORMAL
EVAS_TEXTGRID_FONT_STYLE_BOLD = enums.EVAS_TEXTGRID_FONT_STYLE_BOLD
EVAS_TEXTGRID_FONT_STYLE_ITALIC = enums.EVAS_TEXTGRID_FONT_STYLE_ITALIC


cdef class TextgridCell(object):
    """

    The values that describes each cell.

    @since 1.7

    """

    cdef Evas_Textgrid_Cell cell

    def __cinit__(self, Evas_Textgrid_Cell cell):
        self.cell = cell

    property codepoint:
        """the UNICODE value of the character"""
        def __set__(self, Eina_Unicode value):
            self.cell.codepoint = value

        def __get__(self):
            return self.cell.codepoint

    property fg:
        """the index of the palette for the foreground color"""
        def __set__(self, int value):
            self.cell.fg = value

        def __get__(self):
            return self.cell.fg

    property bg:
        """the index of the palette for the background color"""
        def __set__(self, int value):
            self.cell.bg = value

        def __get__(self):
            return self.cell.bg

    property bold:
        """whether the character is bold"""
        def __set__(self, bint value):
            self.cell.bold = value

        def __get__(self):
            return self.cell.bold

    property italic:
        """whether the character is oblique"""
        def __set__(self, bint value):
            self.cell.italic = value

        def __get__(self):
            return self.cell.italic

    property underline:
        """whether the character is underlined"""
        def __set__(self, bint value):
            self.cell.underline = value

        def __get__(self):
            return self.cell.underline

    property strikethrough:
        """whether the character is strikethrough'ed"""
        def __set__(self, bint value):
            self.cell.strikethrough = value

        def __get__(self):
            return self.cell.strikethrough

    property fg_extended:
        """whether the extended palette is used for the foreground color"""
        def __set__(self, bint value):
            self.cell.fg_extended = value

        def __get__(self):
            return self.cell.fg_extended

    property bg_extended:
        """whether the extended palette is used for the background color"""
        def __set__(self, bint value):
            self.cell.bg_extended = value

        def __get__(self):
            return self.cell.bg_extended

    property double_width:
        """if the codepoint is merged with the following cell to the right visually (cells must be in pairs with 2nd cell being a duplicate in all ways except codepoint is 0)"""
        def __set__(self, bint value):
            self.cell.double_width = value

        def __get__(self):
            return self.cell.double_width



cdef class Textgrid(Object):

    def __init__(self, Canvas canvas not None):
        """

        Add a textgrid to the given Evas.

        :param e: The given evas.
        :return: The new textgrid object.

        This function adds a new textgrid object to the Evas @p e and returns the object.

        @since 1.7

        """
        self._set_obj(evas_object_textgrid_add(canvas.obj))

    property size:
        """

        The size of the textgrid object.

        The number of lines @p h and the number
        of columns @p w of the textgrid object. Values
        less than or equal to 0 are ignored.

        :type: (int w, int h)

        @since 1.7

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
        """

        The font (source) file used on a given textgrid object.

        This allows the font file to be explicitly
        set for the textgrid object, overriding system lookup, which
        will first occur in the given file's contents. If
        None or an empty string is assigned, or the same font_source has already
        been set, or on error, this does nothing.

        :type: unicode

        .. seealso:: font

        @since 1.7

        """
        def __set__(self, font_source):
            a1 = font_source
            if isinstance(a1, unicode): a1 = a1.encode("UTF-8")
            evas_object_textgrid_font_source_set(self.obj,
                <const_char *>a1 if a1 is not None else NULL)

        def __get__(self):
            return _ctouni(evas_object_textgrid_font_source_get(self.obj))

    property font:
        """

        The font family and size on a given textgrid object.

        :param font_name: The font (family) name.
        :param font_size: The font size, in points.

        This function allows the font name @p font_name and size
        @p font_size of the textgrid object @p obj to be set. The @p font_name
        string has to follow fontconfig's convention on naming fonts, as
        it's the underlying library used to query system fonts by Evas (see
        the @c fc-list command's output, on your system, to get an
        idea). It also has to be a monospace font. If @p font_name is
        @c NULL, or if it is an empty string, or if @p font_size is less or
        equal than 0, or on error, this function does nothing.

        @see evas_object_textgrid_font_get()
        @see evas_object_textgrid_font_source_set()
        @see evas_object_textgrid_font_source_get()

        @since 1.7

        """
        def __set__(self, value):
            cdef Evas_Font_Size font_size
            font_name, font_size = value
            a1 = font_name
            if isinstance(a1, unicode): a1 = a1.encode("UTF-8")
            evas_object_textgrid_font_set(self.obj,
                <const_char *>a1 if a1 is not None else NULL,
                font_size)

        def __get__(self):
            cdef:
                const_char *font_name
                Evas_Font_Size font_size
            evas_object_textgrid_font_get(self.obj, &font_name, &font_size)
            # font_name is owned by Evas, don't free it
            return (_ctouni(font_name), font_size)

    property cell_size:
        """

        The size of a cell of the given textgrid object in pixels.

        :param width: A pointer to the location to store the width in pixels of a cell.
        :param height: A pointer to the location to store the height in
        pixels of a cell.

        This functions retrieves the width and height, in pixels, of a cell
        of the textgrid object @p obj and store them respectively in the
        buffers @p width and @p height. Their value depends on the
        monospace font used for the textgrid object, as well as the
        style. @p width and @p height can be @c NULL. On error, they are
        set to 0.

        @see evas_object_textgrid_font_set()
        @see evas_object_textgrid_supported_font_styles_set()

        @since 1.7

        """
        def __get__(self):
            cdef:
                Evas_Coord w, h
            evas_object_textgrid_cell_size_get(self.obj, &w, &h)
            return (w, h)

    def palette_set(self, Evas_Textgrid_Palette pal, int idx, int r, int g, int b, int a):
        """

        The set color to the given palette at the given index of the given textgrid object.

        :param pal: The type of the palette to set the color.
        :param idx: The index of the paletter to wich the color is stored.
        :param r: The red component of the color.
        :param g: The green component of the color.
        :param b: The blue component of the color.
        :param a: The alpha component of the color.

        This function sets the color for the palette of type @p pal at the
        index @p idx of the textgrid object @p obj. The ARGB components are
        given by @p r, @p g, @p b and @p a. This color can be used when
        setting the #Evas_Textgrid_Cell structure. The components must set
        a pre-multiplied color. If pal is #EVAS_TEXTGRID_PALETTE_NONE or
        #EVAS_TEXTGRID_PALETTE_LAST, or if @p idx is not between 0 and 255,
        or on error, this function does nothing. The color components are
        clamped between 0 and 255. If @p idx is greater than the latest set
        color, the colors between this last index and @p idx - 1 are set to
        black (0, 0, 0, 0).

        @see evas_object_textgrid_palette_get()

        @since 1.7

        """
        evas_object_textgrid_palette_set(self.obj, pal, idx, r, g, b, a)

    def palette_get(self, Evas_Textgrid_Palette pal, int idx):
        """

        The retrieve color to the given palette at the given index of the given textgrid object.

        :param pal: The type of the palette to set the color.
        :param idx: The index of the paletter to wich the color is stored.
        :param r: A pointer to the red component of the color.
        :param g: A pointer to the green component of the color.
        :param b: A pointer to the blue component of the color.
        :param a: A pointer to the alpha component of the color.

        This function retrieves the color for the palette of type @p pal at the
        index @p idx of the textgrid object @p obj. The ARGB components are
        stored in the buffers @p r, @p g, @p b and @p a. If @p idx is not
        between 0 and the index of the latest set color, or if @p pal is
        #EVAS_TEXTGRID_PALETTE_NONE or #EVAS_TEXTGRID_PALETTE_LAST, the
        values of the components are 0. @p r, @p g, @pb and @p a can be
        @c NULL.

        @see evas_object_textgrid_palette_set()

        @since 1.7

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

    def cellrow_set(self, int y, list row not None):
        """

        Set the string at the given row of the given textgrid object.

        :param y: The row index of the grid.
        :param row: The string as a sequence of #Evas_Textgrid_Cell.

        This function returns cells to the textgrid taken by
        evas_object_textgrid_cellrow_get(). The row pointer @p row should be the
        same row pointer returned by evas_object_textgrid_cellrow_get() for the
        same row @p y.

        @see evas_object_textgrid_cellrow_get()
        @see evas_object_textgrid_size_set()
        @see evas_object_textgrid_update_add()

        @since 1.7

        """
        cdef TextgridCell cell = row[0]
        evas_object_textgrid_cellrow_set(self.obj, y, &cell.cell)

    def cellrow_get(self, int y, int w):
        """

        Get the string at the given row of the given textgrid object.

        :param y: The row index of the grid.
        :return: A pointer to the first cell of the given row.

        This function returns a pointer to the first cell of the line @p y
        of the textgrid object @p obj. If @p y is not between 0 and the
        number of lines of the grid - 1, or on error, this function return @c NULL.

        @see evas_object_textgrid_cellrow_set()
        @see evas_object_textgrid_size_set()
        @see evas_object_textgrid_update_add()

        @since 1.7

        """
        cdef:
            Evas_Textgrid_Cell *row = evas_object_textgrid_cellrow_get(self.obj, y)
            int i
            list ret = []

        for i in range(w):
            cell = TextgridCell.__new__(TextgridCell)
            cell.cell = row[i]
            ret.append(cell)

        return ret

    def update_add(self, int x, int y, int w, int h):
        """

        Indicate for evas that part of a textgrid region (cells) has been updated.

        :param x: The rect region of cells top-left x (column)
        :param y: The rect region of cells top-left y (row)
        :param w: The rect region size in number of cells (columns)
        :param h: The rect region size in number of cells (rows)

        This function declares to evas that a region of cells was updated by
        code and needs refreshing. An application should modify cells like this
        as an example::

            cells = tg.cellrow_get(row)
            for i in range(0, width):
                cells[i].codepoint = 'E'
            tg.cellrow_set(row, cells)
            tg.update_add(0, row, width, 1)

        @see evas_object_textgrid_cellrow_set()
        @see evas_object_textgrid_cellrow_get()
        @see evas_object_textgrid_size_set()

        @since 1.7

        """
        evas_object_textgrid_update_add(self.obj, x, y, w, h)
