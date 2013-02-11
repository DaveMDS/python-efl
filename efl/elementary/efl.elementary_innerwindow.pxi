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


cdef class InnerWindow(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_win_inwin_add(parent.obj))

    def activate(self):
        elm_win_inwin_activate(self.obj)

    def content_set(self, evasObject content):
        cdef Evas_Object *o
        if content is not None:
            o = content.obj
        else:
            o = NULL
        elm_win_inwin_content_set(self.obj, o)

    def content_get(self):
        return object_from_instance(elm_win_inwin_content_get(self.obj))

    def content_unset(self):
        return object_from_instance(elm_win_inwin_content_unset(self.obj))

    property content:
        def __get__(self):
            return object_from_instance(elm_win_inwin_content_get(self.obj))

        def __set__(self, evasObject content):
            cdef Evas_Object *o
            if content is not None:
                o = content.obj
            else:
                o = NULL
            elm_win_inwin_content_set(self.obj, o)

        def __del__(self):
            elm_win_inwin_content_unset(self.obj)


_object_mapping_register("elm_inwin", InnerWindow)
