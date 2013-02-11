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

cdef class ColorselectorPaletteItem(ObjectItem):

    def __init__(self, evasObject cs, r, g, b, a):
        cdef Elm_Object_Item *item = elm_colorselector_palette_color_add(cs.obj, r, g, b, a)
        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def color_get(self):
        cdef int r, g, b, a
        elm_colorselector_palette_item_color_get(self.item, &r, &g, &b, &a)
        return (r, g, b, a)

    def color_set(self, r, g, b, a):
        elm_colorselector_palette_item_color_set(self.item, r, g, b, a)

    property color:
        def __get__(self):
            cdef int r, g, b, a
            elm_colorselector_palette_item_color_get(self.item, &r, &g, &b, &a)
            return (r, g, b, a)
        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            elm_colorselector_palette_item_color_set(self.item, r, g, b, a)


cdef class Colorselector(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_colorselector_add(parent.obj))

    def color_set(self, r, g, b, a):
        elm_colorselector_color_set(self.obj, r, g, b, a)

    def color_get(self):
        cdef int r, g, b, a
        elm_colorselector_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    property color:
        def __get__(self):
            cdef int r, g, b, a
            elm_colorselector_color_get(self.obj, &r, &g, &b, &a)
            return (r, g, b, a)
        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            elm_colorselector_color_set(self.obj, r, g, b, a)

    def mode_set(self, mode):
        elm_colorselector_mode_set(self.obj, mode)

    def mode_get(self):
        return elm_colorselector_mode_get(self.obj)

    property mode:
        def __get__(self):
            return elm_colorselector_mode_get(self.obj)
        def __set__(self, mode):
            elm_colorselector_mode_set(self.obj, mode)

    def palette_color_add(self, r, g, b, a):
        return ColorselectorPaletteItem(self, r, g, b, a)

    def palette_clear(self):
        elm_colorselector_palette_clear(self.obj)

    def palette_name_set(self, palette_name):
        elm_colorselector_palette_name_set(self.obj, _cfruni(palette_name))

    def palette_name_get(self):
        return _ctouni(elm_colorselector_palette_name_get(self.obj))

    property palette_name:
        def __get__(self):
            return _ctouni(elm_colorselector_palette_name_get(self.obj))
        def __set__(self, palette_name):
            elm_colorselector_palette_name_set(self.obj, _cfruni(palette_name))

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_color_item_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("color,item,selected",
                                _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_color_item_selected_del(self, func):
        self._callback_del_full("color,item,selected",
                                _cb_object_item_conv, func)

    def callback_color_item_longpressed_add(self, func, *args, **kwargs):
        self._callback_add_full("color,item,longpressed",
                                _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_color_item_longpressed_del(self, func):
        self._callback_del_full("color,item,longpressed",
                                _cb_object_item_conv, func)


_object_mapping_register("elm_colorselector", Colorselector)
