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

include "table_cdef.pxi"

cdef class Table(Object):
    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Table(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_table_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

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

        Default value is (0, 0).

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

    property align:
        """The alignment of the table

        Default value is (0.5, 0.5)

        :type: (float **horizontal**, float **vertical**)

        .. versionadded:: 1.13

        """
        def __get__(self):
            cdef double horizontal, vertical
            elm_table_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            horizontal, vertical = value
            elm_table_align_set(self.obj, horizontal, vertical)

    def align_set(self, horizontal, vertical):
        elm_table_align_set(self.obj, horizontal, vertical)
    def align_get(self):
        cdef double horizontal, vertical
        elm_table_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def pack(self, evasObject subobj, x, y, w, h):
        """Add a subobject on the table with the coordinates passed

        .. note:: All positioning inside the table is relative to rows and
            columns, so a value of 0 for x and y, means the top left cell of
            the table, and a value of 1 for w and h means ``subobj`` only
            takes that 1 cell.

        :param subobj: The subobject to be added to the table
        :type subobj: :py:class:`~efl.evas.Object`
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
        """Remove child from table.

        :param subobj: The subobject
        :type subobj: :py:class:`~efl.evas.Object`

        """
        elm_table_unpack(self.obj, subobj.obj)

    def clear(self, clear):
        """Faster way to remove all child objects from a table object.

        :param clear: If True, will delete children, else just remove from table.
        :type clear: bool

        """
        elm_table_clear(self.obj, clear)

    def child_get(self, int col, int row):
        """Get child object of table at given coordinates.

        :param int col: Column number of child object
        :param int row: Row number of child object

        :return: Child of object if find if not return None.

        .. versionadded:: 1.8

        """
        return object_from_instance(elm_table_child_get(self.obj, col, row))

def table_pack_set(evasObject subobj, x, y, w, h):
    """Set the packing location of an existing child of the table

    Modifies the position of an object already in the table.

    .. note:: All positioning inside the table is relative to rows and
        columns, so a value of 0 for x and y, means the top left cell of
        the table, and a value of 1 for w and h means ``subobj`` only
        takes that 1 cell.

    :param subobj: The subobject to be modified in the table
    :type subobj: :py:class:`~efl.evas.Object`
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
    """Get the packing location of an existing child of the table

    .. seealso:: :py:func:`table_pack_set`

    :param subobj: The subobject to be modified in the table
    :type subobj: :py:class:`~efl.evas.Object`
    :return: Row number, Column number, rowspan, colspan
    :rtype: tuple of ints

    """
    cdef int x, y, w, h
    elm_table_pack_get(subobj.obj, &x, &y, &w, &h)
    return (x, y, w, h)

_object_mapping_register("Elm_Table", Table)
