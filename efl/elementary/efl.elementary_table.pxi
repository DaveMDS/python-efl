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


cdef class Table(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_table_add(parent.obj))

    def homogeneous_set(self, homogeneous):
        elm_table_homogeneous_set(self.obj, homogeneous)

    def homogeneous_get(self):
        return elm_table_homogeneous_get(self.obj)

    property homogeneous:
        def __get__(self):
            return elm_table_homogeneous_get(self.obj)

        def __set__(self, homogeneous):
            elm_table_homogeneous_set(self.obj, homogeneous)

    def padding_set(self, horizontal, vertical):
        elm_table_padding_set(self.obj, horizontal, vertical)

    def padding_get(self):
        cdef Evas_Coord horizontal, vertical
        elm_table_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property padding:
        def __get__(self):
            cdef Evas_Coord horizontal, vertical
            elm_table_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            horizontal, vertical = value
            elm_table_padding_set(self.obj, horizontal, vertical)

    def pack(self, evasObject subobj, x, y, w, h):
        elm_table_pack(self.obj, subobj.obj, x, y, w, h)

    def unpack(self, evasObject subobj):
        elm_table_unpack(self.obj, subobj.obj)

    def clear(self, clear):
        elm_table_clear(self.obj, clear)

    def pack_set(evasObject subobj, x, y, w, h):
        elm_table_pack_set(subobj.obj, x, y, w, h)

    def pack_get(evasObject subobj):
        cdef int x, y, w, h
        elm_table_pack_get(subobj.obj, &x, &y, &w, &h)
        return (x, y, w, h)


_object_mapping_register("elm_table", Table)
