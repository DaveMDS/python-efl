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


cdef class Group(object):
    cdef EdjeEdit edje

    def __init__(self, EdjeEdit e):
        self.edje = e

    def delete(self):
        return False

    property w_min: # TODO rename to min_w !!
        def __get__(self):
            return edje_edit_group_min_w_get(self.edje.obj)
        def __set__(self, value):
            edje_edit_group_min_w_set(self.edje.obj, value)

    property w_max: # TODO rename to max_w !!
        def __get__(self):
            return edje_edit_group_max_w_get(self.edje.obj)
        def __set__(self, value):
            edje_edit_group_max_w_set(self.edje.obj, value)

    property h_min: # TODO rename to min_h !!
        def __get__(self):
            return edje_edit_group_min_h_get(self.edje.obj)
        def __set__(self, value):
            edje_edit_group_min_h_set(self.edje.obj, value)

    property h_max: # TODO rename to max_h !!
        def __get__(self):
            return edje_edit_group_max_h_get(self.edje.obj)
        def __set__(self, value):
            edje_edit_group_max_h_set(self.edje.obj, value)

    def rename(self, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_group_name_set(self.edje.obj, <const char *>name))

