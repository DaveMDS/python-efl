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


cdef class Polygon(Object):
    """

    A polygon.

    """
    def __init__(self, Canvas canvas not None, points=None, **kwargs):
        """Polygon(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword points: Points of the polygon
        :type points: list of tuple of x, y int pairs
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(evas_object_polygon_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)
        if points:
            for x, y in points:
                self.point_add(x, y)

    def point_add(self, int x, int y):
        """Add a new point to the polygon

        :param x: X coordinate
        :type x: int
        :param y: Y Coordinate
        :type y: int

        """
        evas_object_polygon_point_add(self.obj, x, y)

    def points_clear(self):
        """Remove all the points from the polygon"""
        evas_object_polygon_points_clear(self.obj)


_object_mapping_register("Efl_Canvas_Polygon", Polygon)
