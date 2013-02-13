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


cdef class Radio(LayoutClass):

    def __init__(self, evasObject parent, obj=None):
        if obj is None:
            self._set_obj(elm_radio_add(parent.obj))
        else:
            self._set_obj(<Evas_Object*>obj)

    def group_add(self, evasObject group):
        elm_radio_group_add(self.obj, group.obj)

    def state_value_set(self, value):
        elm_radio_state_value_set(self.obj, value)

    def state_value_get(self):
        return elm_radio_state_value_get(self.obj)

    property state_value:
        def __get__(self):
            return elm_radio_state_value_get(self.obj)
        def __set__(self, value):
            elm_radio_state_value_set(self.obj, value)

    def value_set(self, value):
        elm_radio_value_set(self.obj, value)

    def value_get(self):
        return elm_radio_value_get(self.obj)

    property value:
        def __get__(self):
            return elm_radio_value_get(self.obj)
        def __set__(self, value):
            elm_radio_value_set(self.obj, value)

    #TODO: Check whether this actually works
    def value_pointer_set(self, value):
        cdef int valuep = value
        elm_radio_value_pointer_set(self.obj, &valuep)

    def selected_object_get(self):
        cdef Radio r = Radio()
        cdef Evas_Object *selected = elm_radio_selected_object_get(self.obj)
        if selected == NULL:
            return None
        else:
            r.obj = selected
            return r

    property selected_object:
        def __get__(self):
            cdef Radio r = Radio()
            cdef Evas_Object *selected = elm_radio_selected_object_get(self.obj)
            if selected == NULL:
                return None
            else:
                r.obj = selected
                return r

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("elm_radio", Radio)
