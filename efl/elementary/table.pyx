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

from object cimport Object

cdef class Table(Object):

    """

    A container widget to arrange other widgets in a table where items can
    span multiple columns or rows - even overlap (and then be raised or
    lowered accordingly to adjust stacking if they do overlap).

    The row and column count is not fixed. The table widget adjusts itself
    when subobjects are added to it dynamically.

    The most common way to use a table is::

        table = Table(win)
        table.show()
        table.padding = (space_between_columns, space_between_rows)
        table.pack(table_content_object, x_coord, y_coord, colspan, rowspan)
        table.pack(table_content_object, next_x_coord, next_y_coord, colspan, rowspan)
        table.pack(table_content_object, other_x_coord, other_y_coord, colspan, rowspan)

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_table_add(parent.obj))

    property homogeneous:
        """The homogeneous layout in the table

        :type: bool

        """
        def __get__(self):
            return elm_table_homogeneous_get(self.obj)

        def __set__(self, homogeneous):
            elm_table_homogeneous_set(self.obj, homogeneous)

    def homogeneous_set(self, homogeneous):
        elm_table_homogeneous_set(self.obj, homogeneous)
    def homogeneous_get(self):
        return elm_table_homogeneous_get(self.obj)

    property padding:
        """Padding between cells.

        Default value is 0.

        :type: (int, int)

        """
        def __get__(self):
            cdef Evas_Coord horizontal, vertical
            elm_table_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            horizontal, vertical = value
            elm_table_padding_set(self.obj, horizontal, vertical)

    def padding_set(self, horizontal, vertical):
        elm_table_padding_set(self.obj, horizontal, vertical)
    def padding_get(self):
        cdef Evas_Coord horizontal, vertical
        elm_table_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def pack(self, evasObject subobj, x, y, w, h):
        """pack(evas.Object subobj, int x, int y, int w, int h)

        Add a subobject on the table with the coordinates passed

        .. note:: All positioning inside the table is relative to rows and
            columns, so a value of 0 for x and y, means the top left cell of
            the table, and a value of 1 for w and h means ``subobj`` only
            takes that 1 cell.

        :param subobj: The subobject to be added to the table
        :type subobj: :py:class:`evas.object.Object`
        :param x: Row number
        :type x: int
        :param y: Column number
        :type y: int
        :param w: colspan
        :type w: int
        :param h: rowspan
        :type h: int

        """
        elm_table_pack(self.obj, subobj.obj, x, y, w, h)

    def unpack(self, evasObject subobj):
        """unpack(evas.Object subobj)

        Remove child from table.

        :param subobj: The subobject
        :type subobj: :py:class:`evas.object.Object`

        """
        elm_table_unpack(self.obj, subobj.obj)

    def clear(self, clear):
        """clear(bool clear)

        Faster way to remove all child objects from a table object.

        :param clear: If True, will delete children, else just remove from table.
        :type clear: bool

        """
        elm_table_clear(self.obj, clear)

def table_pack_set(evasObject subobj, x, y, w, h):
    """table_pack_set(evas.Object subobj, int x, int y, int w, int h)

    Set the packing location of an existing child of the table

    Modifies the position of an object already in the table.

    .. note:: All positioning inside the table is relative to rows and
        columns, so a value of 0 for x and y, means the top left cell of
        the table, and a value of 1 for w and h means ``subobj`` only
        takes that 1 cell.

    :param subobj: The subobject to be modified in the table
    :type subobj: :py:class:`evas.object.Object`
    :param x: Row number
    :type x: int
    :param y: Column number
    :type y: int
    :param w: rowspan
    :type w: int
    :param h: colspan
    :type h: int

    """
    elm_table_pack_set(subobj.obj, x, y, w, h)

def table_pack_get(evasObject subobj):
    """table_pack_get(evas.Object subobj) -> (int x, int y, int w, int h)

    Get the packing location of an existing child of the table

    .. seealso:: :py:func:`table_pack_set`

    :param subobj: The subobject to be modified in the table
    :type subobj: :py:class:`evas.object.Object`
    :return: Row number, Column number, rowspan, colspan
    :rtype: tuple of ints

    """
    cdef int x, y, w, h
    elm_table_pack_get(subobj.obj, &x, &y, &w, &h)
    return (x, y, w, h)


_object_mapping_register("elm_table", Table)
