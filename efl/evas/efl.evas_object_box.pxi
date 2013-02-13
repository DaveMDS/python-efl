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



cdef class Box(Object):

    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(evas_object_box_add(canvas.obj))
        self._set_common_params(**kargs)

    def align_get(self):
        cdef double horizontal, vertical
        evas_object_box_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def align_set(self, double horizontal, double vertical):
        evas_object_box_align_set(self.obj, horizontal, vertical)

    property align:
        def __get__(self):
            return self.align_get()

        def __set__(self, v):
            (horizontal, vertical) = v
            self.align_set(horizontal, vertical)

    def padding_get(self):
        cdef Evas_Coord horizontal, vertical
        evas_object_box_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def padding_set(self, Evas_Coord horizontal, Evas_Coord vertical):
        evas_object_box_padding_set(self.obj, horizontal, vertical)

    property padding:
        def __get__(self):
            return self.padding_get()

        def __set__(self, v):
            (horizontal, vertical) = v
            self.padding_set(horizontal, vertical)

    def append(self, Object child):
        evas_object_box_append(self.obj, child.obj)

    def prepend(self, Object child):
        evas_object_box_prepend(self.obj, child.obj)

    def insert_before(self, Object child, Object reference):
        evas_object_box_insert_before(self.obj, child.obj, reference.obj)

    def insert_after(self, Object child, Object reference):
        evas_object_box_insert_after(self.obj, child.obj, reference.obj)

    def insert_at(self, Object child, unsigned int pos):
        evas_object_box_insert_at(self.obj, child.obj, pos)

    def remove(self, Object child):
        return evas_object_box_remove(self.obj, child.obj)

    def remove_at(self, unsigned int pos):
        return evas_object_box_remove_at(self.obj, pos)

    def remove_all(self, Eina_Bool clear):
        return evas_object_box_remove_all(self.obj, clear)


_object_mapping_register("Evas_Object_Box", Box)
