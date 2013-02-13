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


cdef class Bubble(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_bubble_add(parent.obj))

    def pos_set(self, pos):
        elm_bubble_pos_set(self.obj, pos)

    def pos_get(self):
        return elm_bubble_pos_get(self.obj)

    property pos:
        def __get__(self):
            return elm_bubble_pos_get(self.obj)

        def __set__(self, value):
            elm_bubble_pos_set(self.obj, value)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("elm_bubble", Bubble)
