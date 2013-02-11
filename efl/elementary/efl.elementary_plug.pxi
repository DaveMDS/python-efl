# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
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

from efl.evas cimport Image as evasImage

cdef class Plug(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_plug_add(parent.obj))

    def connect(self, svcname, svcnum, svcsys):
        return bool(elm_plug_connect(self.obj, _cfruni(svcname), svcnum, svcsys))

    property image_object:
        def __get__(self):
            cdef evasImage img = evasImage()
            cdef Evas_Object *obj = elm_plug_image_object_get(self.obj)
            img.obj = obj
            return img


_object_mapping_register("elm_plug", Plug)
