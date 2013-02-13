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


cdef class Icon(Image):

    def __init__(self, evasObject parent):
        self._set_obj(elm_icon_add(parent.obj))

    def thumb_set(self, filename, group = None):
        if group == None:
            elm_icon_thumb_set(self.obj, _cfruni(filename), NULL)
        else:
            elm_icon_thumb_set(self.obj, _cfruni(filename), _cfruni(group))

    property thumb:
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            # TODO: check return value
            elm_icon_thumb_set(self.obj, _cfruni(filename), _cfruni(group))

    def standard_set(self, name):
        return bool(elm_icon_standard_set(self.obj, _cfruni(name)))

    def standard_get(self):
        return _ctouni(elm_icon_standard_get(self.obj))

    property standard:
        def __get__(self):
            return _ctouni(elm_icon_standard_get(self.obj))
        def __set__(self, name):
            # TODO: check return value
            elm_icon_standard_set(self.obj, _cfruni(name))

    def order_lookup_set(self, order):
        elm_icon_order_lookup_set(self.obj, order)

    def order_lookup_get(self):
        return elm_icon_order_lookup_get(self.obj)

    property order_lookup:
        def __get__(self):
            return elm_icon_order_lookup_get(self.obj)
        def __set__(self, order):
            elm_icon_order_lookup_set(self.obj, order)

    def callback_thumb_done_add(self, func, *args, **kwargs):
        self._callback_add("thumb,done", func, *args, **kwargs)

    def callback_thumb_done_del(self, func):
        self._callback_del("thumb,done", func)

    def callback_thumb_error_add(self, func, *args, **kwargs):
        self._callback_add("thumb,error", func, *args, **kwargs)

    def callback_thumb_error_del(self, func):
        self._callback_del("thumb,error", func)


_object_mapping_register("elm_icon", Icon)
