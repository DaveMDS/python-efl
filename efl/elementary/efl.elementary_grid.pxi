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


cdef class Grid(Object):

    def __init__(self, evasObject parent):
#         Object.__init__(self, parent.evas)
        self._set_obj(elm_grid_add(parent.obj))

    def size_set(self, w, h):
        elm_grid_size_set(self.obj, w, h)

    def size_get(self):
        cdef Evas_Coord w, h
        elm_grid_size_get(self.obj, &w, &h)
        return (w, h)

    property size:
        def __set__(self, value):
            w, h = value
            elm_grid_size_set(self.obj, w, h)

        def __get__(self):
            cdef Evas_Coord w, h
            elm_grid_size_get(self.obj, &w, &h)
            return (w, h)

    def pack(self, evasObject subobj, x, y, w, h):
        elm_grid_pack(self.obj, subobj.obj, x, y, w, h)

    def unpack(self, evasObject subobj):
        elm_grid_unpack(self.obj, subobj.obj)

    def clear(self, clear):
        elm_grid_clear(self.obj, clear)

    def pack_set(self, evasObject subobj, x, y, w, h):
        elm_grid_pack_set(subobj.obj, x, y, w, h)

    def pack_get(self, evasObject subobj):
        cdef Evas_Coord x, y, w, h
        elm_grid_pack_get(subobj.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    def children_get(self):
        return _object_list_to_python(elm_box_children_get(self.obj))

    property children:
        def __get__(self):
            return _object_list_to_python(elm_box_children_get(self.obj))


_object_mapping_register("elm_grid", Grid)
