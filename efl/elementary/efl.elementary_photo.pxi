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


cdef class Photo(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_photo_add(parent.obj))

    def file_set(self, filename):
        if filename:
           return bool(elm_photo_file_set(self.obj, _cfruni(filename)))
        else:
           return bool(elm_photo_file_set(self.obj, NULL))

    property file:
        def __set__(self, filename):
            # TODO: check return status
            if filename:
               elm_photo_file_set(self.obj, _cfruni(filename))
            else:
               elm_photo_file_set(self.obj, NULL)

    def thumb_set(self, filename, group = None):
        elm_photo_thumb_set(self.obj, _cfruni(filename), _cfruni(group))

    property thumb:
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            elm_photo_thumb_set(self.obj, _cfruni(filename), _cfruni(group))

    def size_set(self, size):
        elm_photo_size_set(self.obj, size)

    property size:
        def __set__(self, size):
            elm_photo_size_set(self.obj, size)

    def fill_inside_set(self, fill):
        elm_photo_fill_inside_set(self.obj, fill)

    property fill_inside:
        def __set__(self, fill):
            elm_photo_fill_inside_set(self.obj, fill)

    def editable_set(self, fill):
        elm_photo_editable_set(self.obj, fill)

    property editable:
        def __set__(self, fill):
            elm_photo_editable_set(self.obj, fill)

    def aspect_fixed_set(self, fixed):
        elm_photo_aspect_fixed_set(self.obj, fixed)

    def aspect_fixed_get(self):
        return elm_photo_aspect_fixed_get(self.obj)

    property aspect_fixed:
        def __get__(self):
            return elm_photo_aspect_fixed_get(self.obj)

        def __set__(self, fixed):
            elm_photo_aspect_fixed_set(self.obj, fixed)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_drag_start_add(self, func, *args, **kwargs):
        self._callback_add("drag,start", func, *args, **kwargs)

    def callback_drag_start_del(self, func):
        self._callback_del("drag,start", func)

    def callback_drag_end_add(self, func, *args, **kwargs):
        self._callback_add("drag,end", func, *args, **kwargs)

    def callback_drag_end_del(self, func):
        self._callback_del("drag,end", func)


_object_mapping_register("elm_photo", Photo)
