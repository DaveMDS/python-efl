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


cdef class HoverselItem(ObjectItem):

    def __init__(self, evasObject hoversel, label, icon_file, icon_type,
                 callback, *args, **kargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)
        item = elm_hoversel_item_add(   hoversel.obj,
                                        _cfruni(label) if label is not None else NULL,
                                        _cfruni(icon_file) if icon_file is not None else NULL,
                                        icon_type,
                                        cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def icon_set(self, icon_file, icon_group, icon_type):
        elm_hoversel_item_icon_set(self.item, _cfruni(icon_file), _cfruni(icon_group), icon_type)

    def icon_get(self):
        cdef const_char_ptr cicon_file, cicon_group
        cdef Elm_Icon_Type cicon_type
        elm_hoversel_item_icon_get(self.item, &cicon_file, &cicon_group, &cicon_type)
        return (_ctouni(cicon_file), _ctouni(cicon_group), cicon_type)

    property icon:
        def __set__(self, value):
            icon_file, icon_group, icon_type = value
            elm_hoversel_item_icon_set(self.item, _cfruni(icon_file), _cfruni(icon_group), icon_type)

        def __get__(self):
            cdef const_char_ptr cicon_file, cicon_group
            cdef Elm_Icon_Type cicon_type
            elm_hoversel_item_icon_get(self.item, &cicon_file, &cicon_group, &cicon_type)
            return (_ctouni(cicon_file), _ctouni(cicon_group), cicon_type)


cdef class Hoversel(Button):

    def __init__(self, evasObject parent):
#         Object.__init__(self, parent.evas)
        self._set_obj(elm_hoversel_add(parent.obj))

    def horizontal_set(self, horizontal):
        elm_hoversel_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return bool(elm_hoversel_horizontal_get(self.obj))

    property horizontal:
        def __set__(self, horizontal):
            elm_hoversel_horizontal_set(self.obj, horizontal)

        def __get__(self):
            return bool(elm_hoversel_horizontal_get(self.obj))

    def hover_parent_set(self, evasObject parent):
        elm_hoversel_hover_parent_set(self.obj, parent.obj)

    def hover_parent_get(self):
        return object_from_instance(elm_hoversel_hover_parent_get(self.obj))

    property hover_parent:
        def __set__(self, evasObject parent):
            elm_hoversel_hover_parent_set(self.obj, parent.obj)

        def __get__(self):
            return object_from_instance(elm_hoversel_hover_parent_get(self.obj))

    def hover_begin(self):
        elm_hoversel_hover_begin(self.obj)

    def hover_end(self):
        elm_hoversel_hover_end(self.obj)

    def expanded_get(self):
        return bool(elm_hoversel_expanded_get(self.obj))

    property expanded:
        def __get__(self):
            return bool(elm_hoversel_expanded_get(self.obj))

    def clear(self):
        elm_hoversel_clear(self.obj)

    def items_get(self):
        return _object_item_list_to_python(elm_hoversel_items_get(self.obj))

    property items:
        def __get__(self):
            return _object_item_list_to_python(elm_hoversel_items_get(self.obj))

    def item_add(self, label = None, icon_file = None, icon_type = ELM_ICON_NONE, callback = None, *args, **kwargs):
        return HoverselItem(self, label, icon_file, icon_type, callback, *args, **kwargs)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_dismissed_add(self, func, *args, **kwargs):
        self._callback_add("dismissed", func, *args, **kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)


_object_mapping_register("elm_hoversel", Hoversel)
