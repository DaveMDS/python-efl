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


cdef class Mapbuf(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_mapbuf_add(parent.obj))

    def enabled_set(self, enabled):
        elm_mapbuf_enabled_set(self.obj, enabled)

    def enabled_get(self):
        return bool(elm_mapbuf_enabled_get(self.obj))

    property enabled:
        def __get__(self):
            return bool(elm_mapbuf_enabled_get(self.obj))
        def __set__(self, enabled):
            elm_mapbuf_enabled_set(self.obj, enabled)

    def smooth_set(self, smooth):
        elm_mapbuf_smooth_set(self.obj, smooth)

    def smooth_get(self):
        return bool(elm_mapbuf_smooth_get(self.obj))

    property smooth:
        def __get__(self):
            return bool(elm_mapbuf_smooth_get(self.obj))
        def __set__(self, smooth):
            elm_mapbuf_smooth_set(self.obj, smooth)

    def alpha_set(self, alpha):
        elm_mapbuf_alpha_set(self.obj, alpha)

    def alpha_get(self):
        return bool(elm_mapbuf_alpha_get(self.obj))

    property alpha:
        def __get__(self):
            return bool(elm_mapbuf_alpha_get(self.obj))
        def __set__(self, alpha):
            elm_mapbuf_alpha_set(self.obj, alpha)


_object_mapping_register("elm_mapbuf", Mapbuf)
