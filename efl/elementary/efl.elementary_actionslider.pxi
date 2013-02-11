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

cdef class Actionslider(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_actionslider_add(parent.obj))

    def selected_label_get(self):
        return elm_actionslider_selected_label_get(self.obj)

    property selected_label:
        def __get__(self):
            return elm_actionslider_selected_label_get(self.obj)

    def indicator_pos_set(self, pos):
        elm_actionslider_indicator_pos_set(self.obj, pos)

    def indicator_pos_get(self):
        return elm_actionslider_indicator_pos_get(self.obj)

    property indicator_pos:
        def __get__(self):
            return elm_actionslider_indicator_pos_get(self.obj)
        def __set__(self, pos):
            elm_actionslider_indicator_pos_set(self.obj, pos)

    def magnet_pos_set(self, pos):
        elm_actionslider_magnet_pos_set(self.obj, pos)

    def magnet_pos_get(self):
        return elm_actionslider_magnet_pos_get(self.obj)

    property magnet_pos:
        def __get__(self):
            return self.magnet_pos_get()
        def __set__(self, pos):
            self.magnet_pos_set(pos)

    def enabled_pos_set(self, pos):
        elm_actionslider_enabled_pos_set(self.obj, pos)

    def enabled_pos_get(self):
        return elm_actionslider_enabled_pos_get(self.obj)

    property enabled_pos:
        def __get__(self):
            return elm_actionslider_enabled_pos_get(self.obj)
        def __set__(self, pos):
            elm_actionslider_enabled_pos_set(self.obj, pos)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_string_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_string_conv, func)

    def callback_pos_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("pos_changed", _cb_string_conv, func, *args, **kwargs)

    def callback_pos_changed_del(self, func):
        self._callback_del_full("pos_changed", _cb_string_conv, func)


_object_mapping_register("elm_actionslider", Actionslider)
