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


cdef class Layout(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_layout_add(parent.obj))

    def content_set(self, swallow, evasObject content):
        cdef Evas_Object *o
        if content is not None:
            o = content.obj
        else:
            o = NULL
        elm_layout_content_set(self.obj, _cfruni(swallow), o)

    def content_get(self, swallow):
        return object_from_instance(elm_layout_content_get(self.obj, _cfruni(swallow)))

    def content_unset(self, swallow):
        return object_from_instance(elm_layout_content_unset(self.obj, _cfruni(swallow)))

    def text_set(self, part, text):
        elm_layout_text_set(self.obj, _cfruni(part), _cfruni(text))

    def text_get(self, part):
        return _ctouni(elm_layout_text_get(self.obj, _cfruni(part)))


_object_mapping_register("elm_layout", Layout)
