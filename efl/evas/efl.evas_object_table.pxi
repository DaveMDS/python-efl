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


"""

.. _Evas_Object_Table_Homogeneous_Mode:

.. rubric:: Table homogeneous mode

How to pack items into cells in a table.

EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE = 0,
EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE = 1,
EVAS_OBJECT_TABLE_HOMOGENEOUS_ITEM = 2

"""

from efl.utils.conversions cimport eina_list_objects_to_python_list

cdef class Table(Object):
    """

    TODO: doc this class

    """
    def __init__(self, Canvas canvas not None, **kwargs):
        """Table(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(evas_object_table_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

    @classmethod
    def add_to(cls, Object parent):
        """Create a table that is child of a given parent.

        :param parent:
        :type parent: :class:`~efl.evas.Object`

        """
        Object._set_obj(cls, evas_object_table_add_to(parent.obj))

    property homogeneous:
        """Set how this table should layout children.

        :todo: consider aspect hint and respect it.

        EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE
            If table does not use homogeneous mode then columns and rows will
            be calculated based on hints of individual cells. This operation
            mode is more flexible, but more complex and heavy to calculate as
            well. **Weight** properties are handled as a boolean expand. Negative
            alignment will be considered as 0.5. This is the default.

        :todo: EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE should balance weight.

        EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE
            When homogeneous is relative to table the own table size is divided
            equally among children, filling the whole table area. That is, if
            table has ``WIDTH`` and ``COLUMNS``, each cell will get ``WIDTH /
            COLUMNS`` pixels. If children have minimum size that is larger
            than this amount (including padding), then it will overflow and be
            aligned respecting the alignment hint, possible overlapping sibling
            cells. **Weight** hint is used as a boolean, if greater than zero it
            will make the child expand in that axis, taking as much space as
            possible (bounded to maximum size hint). Negative alignment will be
            considered as 0.5.

        EVAS_OBJECT_TABLE_HOMOGENEOUS_ITEM
            When homogeneous is relative to item it means the greatest minimum
            cell size will be used. That is, if no element is set to expand,
            the table will have its contents to a minimum size, the bounding
            box of all these children will be aligned relatively to the table
            object using evas_object_table_align_get(). If the table area is
            too small to hold this minimum bounding box, then the objects will
            keep their size and the bounding box will overflow the box area,
            still respecting the alignment. **Weight** hint is used as a
            boolean, if greater than zero it will make that cell expand in that
            axis, toggling the **expand mode**, which makes the table behave
            much like **EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE**, except that the
            bounding box will overflow and items will not overlap siblings. If
            no minimum size is provided at all then the table will fallback to
            expand mode as well.

        :type: Evas_Object_Table_Homogeneous_Mode

        """
        def __set__(self, Evas_Object_Table_Homogeneous_Mode homogeneous):
            evas_object_table_homogeneous_set(self.obj, homogeneous)

        def __get__(self):
            return evas_object_table_homogeneous_get(self.obj)

    def homogeneous_set(self, Evas_Object_Table_Homogeneous_Mode homogeneous):
        evas_object_table_homogeneous_set(self.obj, homogeneous)

    def homogeneous_get(self):
        return evas_object_table_homogeneous_get(self.obj)

    property padding:
        """Padding between cells.

        :type: (int **horizontal**, int **vertical**)

        """
        def __set__(self, value):
            cdef Evas_Coord horizontal, vertical
            horizontal, vertical = value
            evas_object_table_padding_set(self.obj, horizontal, vertical)

        def __get__(self):
            cdef Evas_Coord horizontal, vertical
            evas_object_table_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

    def padding_set(self, Evas_Coord horizontal, Evas_Coord vertical):
        evas_object_table_padding_set(self.obj, horizontal, vertical)

    def padding_get(self):
        cdef Evas_Coord horizontal, vertical
        evas_object_table_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property align:
        """Set the alignment of the whole bounding box of contents.

        :type: (double **horizontal**, double **vertical**)

        """
        def __set__(self, value):
            cdef double horizontal, vertical
            horizontal, vertical = value
            evas_object_table_align_set(self.obj, horizontal, vertical)

        def __get__(self):
            cdef double horizontal, vertical
            evas_object_table_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

    def align_set(self, double horizontal, double vertical):
        evas_object_table_align_set(self.obj, horizontal, vertical)

    def align_get(self):
        cdef double horizontal, vertical
        evas_object_table_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property mirrored:
        """Sets the mirrored mode of the table. In mirrored mode the table items go
        from right to left instead of left to right. That is, 1,1 is top right, not
        top left.

        :type: bool

        """
        def __set__(self, bint mirrored):
            evas_object_table_mirrored_set(self.obj, mirrored)

        def __get__(self):
            return bool(evas_object_table_mirrored_get(self.obj))

    def mirrored_set(self, bint mirrored):
        evas_object_table_mirrored_set(self.obj, mirrored)

    def mirrored_get(self):
        return bool(evas_object_table_mirrored_get(self.obj))

    def pack_get(self, Object child):
        """Get packing location of a child of table

        :param child: The child object to add.
        :param col: pointer to store relative-horizontal position to place child.
        :param row: pointer to store relative-vertical position to place child.
        :param colspan: pointer to store how many relative-horizontal position to use for this child.
        :param rowspan: pointer to store how many relative-vertical position to use for this child.

        :raise RuntimeError: when the packing location cannot be fetched.

        """
        cdef unsigned short col, row, colspan, rowspan
        if not evas_object_table_pack_get(self.obj, child.obj, &col, &row, &colspan, &rowspan):
            raise RuntimeError("Could not get packing location.")
        else:
            return (col, row, colspan, rowspan)

    def pack(self, Object child, unsigned short col, unsigned short row, unsigned short colspan, unsigned short rowspan):
        """Add a new child to a table object or set its current packing.

        :param child: The child object to add.
        :param col: relative-horizontal position to place child.
        :param row: relative-vertical position to place child.
        :param colspan: how many relative-horizontal position to use for this child.
        :param rowspan: how many relative-vertical position to use for this child.

        :raise RuntimeError: when the child cannot be packed to the table.

        """
        if not evas_object_table_pack(self.obj, child.obj, col, row, colspan, rowspan):
            raise RuntimeError("Could not pack the child to the table.")

    def unpack(self, Object child):
        """Remove child from table.

        .. note::

            Removing a child will immediately call a walk over children in order
            to recalculate numbers of columns and rows. If you plan to remove
            all children, use evas_object_table_clear() instead.

        :raise RuntimeError: when the child cannot be removed from the table.

        """
        if not evas_object_table_unpack(self.obj, child.obj):
            raise RuntimeError("Could not remove child from the table.")

    def clear(self, clear):
        """Faster way to remove all child objects from a table object.

        :param clear: if True, it will delete just removed children.

        """
        evas_object_table_clear(self.obj, clear)

    property col_row_size:
        """Get the number of columns and rows this table takes.

        .. note::

            columns and rows are virtual entities, one can specify a table
            with a single object that takes 4 columns and 5 rows. The only
            difference for a single cell table is that padding will be
            accounted proportionally.

        """
        def __get__(self):
            cdef int cols, rows
            evas_object_table_col_row_size_get(self.obj, &cols, &rows)
            return (cols, rows)

    def col_row_size_get(self):
        cdef int cols, rows
        evas_object_table_col_row_size_get(self.obj, &cols, &rows)
        return (cols, rows)

    def children_get(self):
        """Get the list of children for the table.

        :type: list of Objects

        """
        cdef:
            Eina_List *lst = evas_object_table_children_get(self.obj)
            list ret = eina_list_objects_to_python_list(lst)
        eina_list_free(lst)
        return ret

    def child_get(self, int col, int row):
        """Get the child of the table at the given coordinates

        :param col:
        :type col: int
        :param row:
        :type row: int

        .. note:: This does not take into account col/row spanning

        """
        return object_from_instance(evas_object_table_child_get(self.obj, col, row))

_object_mapping_register("Evas_Table", Table)
