# Copyright (c) 2008-2009 Simon Busch
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

cdef class Background(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_bg_add(parent.obj))

    def file_set(self, filename, group = ""):
        return bool(elm_bg_file_set(self.obj, _cfruni(filename), _cfruni(group)))

    def file_get(self):
        cdef const_char_ptr filename, group

        elm_bg_file_get(self.obj, &filename, &group)
        if filename == NULL:
            filename = ""
        if group == NULL:
            group = ""
        return (_ctouni(filename), _ctouni(group))

    property file:
        def __get__(self):
            cdef const_char_ptr filename, group
            elm_bg_file_get(self.obj, &filename, &group)
            if filename == NULL:
                filename = ""
            if group == NULL:
                group = ""
            return (_ctouni(filename), _ctouni(group))

        def __set__(self, value):
            if isinstance(value, tuple) or isinstance(value, list):
                filename, group = value
            else:
                filename = value
                group = ""
            elm_bg_file_set(self.obj, _cfruni(filename), _cfruni(group))

    def option_set(self, option):
        elm_bg_option_set(self.obj, option)

    def option_get(self):
        return elm_bg_option_get(self.obj)

    property option:
        def __get__(self):
            return elm_bg_option_get(self.obj)

        def __set__(self, value):
            elm_bg_option_set(self.obj, value)

    def color_set(self, r, g, b):
        elm_bg_color_set(self.obj, r, g, b)

    def color_get(self):
        cdef int r, g, b

        elm_bg_color_get(self.obj, &r, &g, &b)
        return (r, g, b)

    property color:
        def __get__(self):
            cdef int r, g, b
            elm_bg_color_get(self.obj, &r, &g, &b)
            return (r, g, b)

        def __set__(self, value):
            cdef int r, g, b
            r, g, b = value
            elm_bg_color_set(self.obj, r, g, b)

    def load_size_set(self, w, h):
        elm_bg_load_size_set(self.obj, w, h)

    property load_size:
        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_bg_load_size_set(self.obj, w, h)


_object_mapping_register("elm_bg", Background)
