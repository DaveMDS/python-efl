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


cdef class Grid(Object):
    """

    TODO: doc this object

    """

    def __init__(self, Canvas canvas not None, **kwargs):
        """Grid(...)

        :param canvas: The evas canvas for this object
        :type canvas: :py:class:`Canvas`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(evas_object_grid_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

    @classmethod
    def add_to(cls, Object parent):
        """Create a grid that is child of a given element ``parent``."""
        Object._set_obj(cls, evas_object_grid_add_to(parent.obj))

    property grid_size:
        """The virtual resolution for the grid

        :type: (int **w**, int **h**)

        """
        def __set__(self, value):
            cdef int w, h
            w, h = value
            evas_object_grid_size_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            evas_object_grid_size_get(self.obj, &w, &h)
            return (w, h)

    def grid_size_set(self, int w, int h):
        evas_object_grid_size_set(self.obj, w, h)

    def grid_size_get(self):
        cdef int w, h
        evas_object_grid_size_get(self.obj, &w, &h)
        return (w, h)

    property mirrored:
        """The mirrored mode of the grid.

        In mirrored mode the grid items go from right to left instead of left to
        right. That is, 0,0 is top right, not top left.

        :type: bool

        """
        def __set__(self, bint mirrored):
            evas_object_grid_mirrored_set(self.obj, mirrored)

        def __get__(self):
            return bool(evas_object_grid_mirrored_get(self.obj))

    def mirrored_set(self, bint mirrored):
        evas_object_grid_mirrored_set(self.obj, mirrored)

    def mirrored_get(self):
        return bool(evas_object_grid_mirrored_get(self.obj))

    def pack(self, Object child not None, int x, int y, int w, int h):
        """Add a new child to a grid object.

        :param child: The child object to add.
        :param x: The virtual x coordinate of the child
        :param y: The virtual y coordinate of the child
        :param w: The virtual width of the child
        :param h: The virtual height of the child
        :raise RuntimeError: if the child could not be packed to the grid.

        """
        if not evas_object_grid_pack(self.obj, child.obj, x, y, w, h):
            raise RuntimeError("Could not pack child to grid.")

    def unpack(self, Object child not None):
        """Remove child from grid.

        :param child:
        :raise RuntimeError: if removing the child fails.

        .. note::

            removing a child will immediately call a walk over children in order
            to recalculate numbers of columns and rows. If you plan to remove
            all children, use evas_object_grid_clear() instead.

        """
        if not evas_object_grid_unpack(self.obj, child.obj):
            raise RuntimeError("Could not remove child from grid.")

    def clear(self, bint clear):
        """Faster way to remove all child objects from a grid object.

        :param clear: if True, it will delete just removed children.

        """
        evas_object_grid_clear(self.obj, clear)

    def pack_get(self, Object child not None):
        """Get the pack options for a grid child

        Get the pack x, y, width and height in virtual coordinates set by
        evas_object_grid_pack()

        :param child: The grid child to query for coordinates
        :return: (int **x**, int **y**, int **w**, int **h**)
        :raise RuntimeError: if packing information could not be fetched.

        """
        cdef int x, y, w, h
        if not evas_object_grid_pack_get(self.obj, child.obj, &x, &y, &w, &h):
            raise RuntimeError("Could not get packing information for child.")
        else:
            return (x, y, w, h)

    property children:
        """Get the list of children for the grid.

        :type: list

        """
        def __get__(self):
            cdef:
                Eina_List *lst = evas_object_grid_children_get(self.obj)
                list ret = eina_list_objects_to_python_list(lst)
            eina_list_free(lst)
            return ret

    def children_get(self):
        cdef:
            Eina_List *lst = evas_object_grid_children_get(self.obj)
            list ret = eina_list_objects_to_python_list(lst)
        eina_list_free(lst)
        return ret

_object_mapping_register("Evas_Grid", Grid)
