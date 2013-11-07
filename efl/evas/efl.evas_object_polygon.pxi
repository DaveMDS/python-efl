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


cdef class Polygon(Object):
    """

    A polygon.

    :param canvas: Evas canvas for this object
    :type canvas: Canvas
    :keyword size: Width and height
    :type size: tuple of ints
    :keyword pos: X and Y
    :type pos: tuple of ints
    :keyword geometry: X, Y, width, height
    :type geometry: tuple of ints
    :keyword color: R, G, B, A
    :type color: tuple of ints
    :keyword name: Object name
    :type name: string
    :keyword points: Points of the polygon
    :type points: tuple of x, y int pairs

    """
    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(evas_object_polygon_add(canvas.obj))
        self._set_common_params(**kargs)

    def _set_common_params(self, points=None, **kargs):
        Object._set_common_params(self, **kargs)
        if points:
            for x, y in points:
                self.point_add(x, y)

    def point_add(self, int x, int y):
        """Add a new point to the polygon

        :param x:
        :param y:

        """
        evas_object_polygon_point_add(self.obj, x, y)

    def points_clear(self):
        "Remove all the points from the polygon"
        evas_object_polygon_points_clear(self.obj)


_object_mapping_register("Evas_Polygon", Polygon)
