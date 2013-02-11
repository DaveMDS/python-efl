# Copyright (c) 2010 Boris Faure
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

cdef class MenuItem(ObjectItem):

    def __init__(   self,
                    evasObject menu,
                    MenuItem parent = None,
                    label = None,
                    icon = None,
                    callback = None,
                    *args, **kargs):

        cdef Elm_Object_Item *item, *parent_obj = NULL
        cdef Evas_Smart_Cb cb = NULL

        parent_obj = parent.item if parent is not None else NULL

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)
        item = elm_menu_item_add(   menu.obj,
                                    parent_obj,
                                    _cfruni(icon) if icon is not None else NULL,
                                    _cfruni(label) if label is not None else NULL,
                                    cb,
                                    <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def object_get(self):
        return object_from_instance(elm_menu_item_object_get(self.item))

    def icon_name_set(self, icon):
        elm_menu_item_icon_name_set(self.item, _cfruni(icon))

    def icon_name_get(self):
        return _ctouni(elm_menu_item_icon_name_get(self.item))

    property icon_name:
        def __get__(self):
            return _ctouni(elm_menu_item_icon_name_get(self.item))
        def __set__(self, icon):
            elm_menu_item_icon_name_set(self.item, _cfruni(icon))

    def selected_set(self, selected):
        elm_menu_item_selected_set(self.item, selected)

    def selected_get(self):
        return elm_menu_item_selected_get(self.item)

    property selected:
        def __get__(self):
            return elm_menu_item_selected_get(self.item)
        def __set__(self, selected):
            elm_menu_item_selected_set(self.item, selected)

    def is_separator(self):
        return False

    def subitems_get(self):
        return _object_item_list_to_python(elm_menu_item_subitems_get(self.item))

    property subitems:
        def __get__(self):
            return _object_item_list_to_python(elm_menu_item_subitems_get(self.item))

    def index_get(self):
        return elm_menu_item_index_get(self.item)

    property index:
        def __get__(self):
            return elm_menu_item_index_get(self.item)

    def next_get(self):
        return _object_item_to_python(elm_menu_item_next_get(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_menu_item_next_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_menu_item_prev_get(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_menu_item_prev_get(self.item))


cdef class MenuSeparatorItem(ObjectItem):
    def __init__(self, evasObject menu, MenuItem parent):
        cdef Elm_Object_Item *parent_obj = NULL

        if parent:
            parent_obj = parent.item
        item = elm_menu_item_separator_add(menu.obj, parent_obj)
        if not item:
            raise RuntimeError("Error creating separator")

        self._set_obj(item)

    def is_separator(self):
        return True

    def next_get(self):
        return _object_item_to_python(elm_menu_item_next_get(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_menu_item_next_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_menu_item_prev_get(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_menu_item_prev_get(self.item))


cdef class Menu(Object):

    def __init__(self, evasObject parent, obj = None):
        if obj is None:
            self._set_obj(elm_menu_add(parent.obj))
        else:
            self._set_obj(<Evas_Object*>obj)

    def parent_set(self, evasObject parent):
        elm_menu_parent_set(self.obj, parent.obj)

    def parent_get(self):
        return object_from_instance(elm_menu_parent_get(self.obj))

    property parent:
        def __get__(self):
            return object_from_instance(elm_menu_parent_get(self.obj))
        def __set__(self, evasObject parent):
            elm_menu_parent_set(self.obj, parent.obj)

    def move(self, x, y):
        elm_menu_move(self.obj, x, y)

    def close(self):
        elm_menu_close(self.obj)

    def items_get(self):
        return _object_item_list_to_python(elm_menu_items_get(self.obj))

    property items:
        def __get__(self):
            return _object_item_list_to_python(elm_menu_items_get(self.obj))

    def item_add(self, parent = None, label = None, icon = None, callback = None, *args, **kwargs):
        return MenuItem(self, parent, label, icon, callback, *args, **kwargs)

    def item_separator_add(self, parent = None):
        return MenuSeparatorItem(self, parent)

    def selected_item_get(self):
        return _object_item_to_python(elm_menu_selected_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return _object_item_to_python(elm_menu_selected_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_menu_last_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_menu_last_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_menu_first_item_get(self.obj))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_menu_first_item_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("elm_menu", Menu)
