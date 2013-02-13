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


cdef class Hover(LayoutClass):

    def __init__(self, evasObject parent, obj = None):
        # TODO is this right ??
        if obj is None:
            self._set_obj(elm_hover_add(parent.obj))
        else:
            self._set_obj(<Evas_Object*>obj)

    def target_set(self, evasObject target):
        elm_hover_target_set(self.obj, target.obj)

    def target_get(self):
        return object_from_instance(elm_hover_target_get(self.obj))

    property target:
        def __get__(self):
            return object_from_instance(elm_hover_target_get(self.obj))
        def __set__(self, evasObject target):
            elm_hover_target_set(self.obj, target.obj)

    def parent_set(self, evasObject parent):
        elm_hover_parent_set(self.obj, parent.obj)

    def parent_get(self):
        return object_from_instance(elm_hover_parent_get(self.obj))

    property parent:
        def __set__(self, evasObject parent):
            elm_hover_parent_set(self.obj, parent.obj)

        def __get__(self):
            return object_from_instance(elm_hover_parent_get(self.obj))

    def best_content_location_get(self, axis):
        return _ctouni(elm_hover_best_content_location_get(self.obj, axis))

    def dismiss(self):
        elm_hover_dismiss(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_smart_changed_add(self, func, *args, **kwargs):
        self._callback_add("smart,changed", func, *args, **kwargs)

    def callback_smart_changed_del(self, func):
        self._callback_del("smart,changed", func)


_object_mapping_register("elm_hover", Hover)
