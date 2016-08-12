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


cdef class Line(Object):
    """

    A straight line.

    """
    def __init__(self, Canvas canvas not None, start=None, end=None,
                 geometry=None, size=None, pos=None, **kwargs):
        """Line(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword start: Start coordinates (x, y)
        :type start: tuple of ints
        :keyword end: End coordinates (x, y)
        :type end: tuple of ints
        :keyword geometry: Geometry of the line (x, y, w, h)
        :type geometry: tuple of ints
        :keyword size: Size of the line (w, h)
        :type size: tuple of ints
        :keyword pos: Position of the line (x, y)
        :type pos: tuple of ints
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(evas_object_line_add(canvas.obj))

        if start and end:
            x1 = start[0]
            y1 = start[1]
            x2 = end[0]
            y2 = end[1]

            w = x2 - x1
            h = y2 - y1
            if w < 0:
                w = -w
                x = x2
            else:
                x = x1

            if h < 0:
                h = -h
                y = y2
            else:
                y = y1

            self.xy_set(x1, y1, x2, y2)

            if not geometry:
                if not size:
                    self.size_set(w, h)
                if not pos:
                    self.pos_set(x, y)

        elif start:
            self.start_set(*start)
        elif end:
            self.end_set(*end)

        if geometry is not None:
            kwargs["geometry"] = geometry
        if size is not None:
            kwargs["size"] = size
        if pos is not None:
            kwargs["pos"] = pos

        self._set_properties_from_keyword_args(kwargs)

    property xy:
        """Two points of the line.

        :type: (int **x0**, int **y0**, int **x1**, int **y1**)

        """

        def __set__(self, spec):
            cdef int x1, y1, x2, y2
            x1, y1, x2, y2 = spec
            evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

        def __get__(self):
            cdef int x1, y1, x2, y2
            evas_object_line_xy_get(self.obj, &x1, &y1, &x2, &y2)
            return (x1, y1, x2, y2)

    def xy_set(self, int x1, int y1, int x2, int y2):
        evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

    def xy_get(self):
        cdef int x1, y1, x2, y2
        evas_object_line_xy_get(self.obj, &x1, &y1, &x2, &y2)
        return (x1, y1, x2, y2)

    property start:
        """The starting point of the line.

        :type: (int **x**, int **y**)

        """
        def __set__(self, spec):
            cdef int x1, y1, x2, y2
            x1, y1 = spec
            evas_object_line_xy_get(self.obj, NULL, NULL, &x2, &y2)
            evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

        def __get__(self):
            cdef int x1, y1
            evas_object_line_xy_get(self.obj, &x1, &y1, NULL, NULL)
            return (x1, y1)

    def start_set(self, x1, y1):
        cdef int x2, y2
        evas_object_line_xy_get(self.obj, NULL, NULL, &x2, &y2)
        evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

    def start_get(self):
        cdef int x1, y1
        evas_object_line_xy_get(self.obj, &x1, &y1, NULL, NULL)
        return (x1, y1)

    property end:
        """The end point of the line.

        :type: (int **x**, int **y**)

        """
        def __set__(self, spec):
            cdef int x1, y1, x2, y2
            x2, y2 = spec
            evas_object_line_xy_get(self.obj, &x1, &y1, NULL, NULL)
            evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

        def __get__(self):
            cdef int x2, y2
            evas_object_line_xy_get(self.obj, NULL, NULL, &x2, &y2)
            return (x2, y2)

    def end_set(self, x2, y2):
        cdef int x1, y1
        evas_object_line_xy_get(self.obj, &x1, &y1, NULL, NULL)
        evas_object_line_xy_set(self.obj, x1, y1, x2, y2)

    def end_get(self):
        cdef int x2, y2
        evas_object_line_xy_get(self.obj, NULL, NULL, &x2, &y2)
        return (x2, y2)


_object_mapping_register("Evas_Line", Line)
