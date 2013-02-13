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


cdef class ToolbarItemState(object):

    cdef Elm_Toolbar_Item_State *obj
    cdef object params

    def __init__(self, ObjectItem it, icon = None, label = None, callback = None, *args, **kwargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kwargs)

        self.obj = elm_toolbar_item_state_add(it.item, _cfruni(icon), _cfruni(label), cb, <void*>self)
        if self.obj == NULL:
            Py_DECREF(self)


cdef class ToolbarItem(ObjectItem):

    def __init__(self, evasObject toolbar, icon, label,
                 callback, *args, **kargs):
        cdef Evas_Object *ic = NULL
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        item = elm_toolbar_item_append(toolbar.obj, icon, _cfruni(label), cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def next_get(self):
        return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    def priority_set(self, priority):
        elm_toolbar_item_priority_set(self.item, priority)

    def priority_get(self):
        return elm_toolbar_item_priority_get(self.item)

    property priority:
        def __get__(self):
            return elm_toolbar_item_priority_get(self.item)

        def __set__(self, priority):
            elm_toolbar_item_priority_set(self.item, priority)

    def selected_get(self):
        return elm_toolbar_item_selected_get(self.item)

    def selected_set(self, selected):
        elm_toolbar_item_selected_set(self.item, selected)

    property selected:
        def __set__(self, selected):
            elm_toolbar_item_selected_set(self.item, selected)

        def __get__(self):
            return elm_toolbar_item_selected_get(self.item)

    def icon_set(self, ic):
        elm_toolbar_item_icon_set(self.item, _cfruni(ic))

    def icon_get(self):
        return _ctouni(elm_toolbar_item_icon_get(self.item))

    property icon:
        def __get__(self):
            return _ctouni(elm_toolbar_item_icon_get(self.item))

        def __set__(self, ic):
            elm_toolbar_item_icon_set(self.item, _cfruni(ic))

    def object_get(self):
        return object_from_instance(elm_toolbar_item_object_get(self.item))

    property object:
        def __get__(self):
            return object_from_instance(elm_toolbar_item_object_get(self.item))

    def icon_object_get(self):
        return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    property icon_object:
        def __get__(self):
            return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    def icon_memfile_set(self, img, size, format, key):
        return False
        #TODO: return bool(elm_toolbar_item_icon_memfile_set(self.item, img, size, format, key))

    def icon_file_set(self, file, key):
        return bool(elm_toolbar_item_icon_file_set(self.item, _cfruni(file), _cfruni(key)))

    property icon_file:
        def __set__(self, value):
            if isinstance(value, tuple):
                file, key = value
            else:
                file = value
                key = None
            # TODO: check return status
            elm_toolbar_item_icon_file_set(self.item, _cfruni(file), _cfruni(key))

    def separator_set(self, separator):
        elm_toolbar_item_separator_set(self.item, separator)

    def separator_get(self):
        return elm_toolbar_item_separator_get(self.item)

    property separator:
        def __set__(self, separator):
            elm_toolbar_item_separator_set(self.item, separator)

        def __get__(self):
            return elm_toolbar_item_separator_get(self.item)

    def menu_set(self, menu):
        elm_toolbar_item_menu_set(self.item, menu)

    def menu_get(self):
        cdef Evas_Object *menu
        menu = elm_toolbar_item_menu_get(self.item)
        if menu == NULL:
            return None
        else:
            return Menu(None, <object>menu)

    property menu:
        def __get__(self):
            cdef Evas_Object *menu
            menu = elm_toolbar_item_menu_get(self.item)
            if menu == NULL:
                return None
            else:
                return Menu(None, <object>menu)

        def __set__(self, menu):
            elm_toolbar_item_menu_set(self.item, menu)

    def state_add(self, icon = None, label = None, func = None, *args, **kwargs):
        return ToolbarItemState(self, icon, label, func, *args, **kwargs)

    def state_del(self, ToolbarItemState state):
        return bool(elm_toolbar_item_state_del(self.item, state.obj))

    property state:
        def __set__(self, ToolbarItemState state):
            # TODO: check return value bool for errors
            elm_toolbar_item_state_set(self.item, state.obj)

        def __del__(self):
            elm_toolbar_item_state_unset(self.item)

        def __get__(self):
            return None
            # TODO: C api doesn't have data_get() for states so we can't get
            #       the py object from there. Store it in the item instead?
            #elm_toolbar_item_state_get(self.item)

    property state_next:
        def __get__(self):
            return None
            # TODO: keep a list of the states?
            #return elm_toolbar_item_state_next(self.item)

    property state_prev:
        def __get__(self):
            return None
            # TODO: keep a list of the states?
            #return elm_toolbar_item_state_prev(self.item)


cdef class Toolbar(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_toolbar_add(parent.obj))

    def icon_size_set(self, icon_size):
        elm_toolbar_icon_size_set(self.obj, icon_size)

    def icon_size_get(self):
        return elm_toolbar_icon_size_get(self.obj)

    property icon_size:
        def __set__(self, icon_size):
            elm_toolbar_icon_size_set(self.obj, icon_size)

        def __get__(self):
            return elm_toolbar_icon_size_get(self.obj)

    def icon_order_lookup_set(self, order):
        elm_toolbar_icon_order_lookup_set(self.obj, order)

    def icon_order_lookup_get(self):
        return elm_toolbar_icon_order_lookup_get(self.obj)

    property icon_order_lookup:
        def __set__(self, order):
            elm_toolbar_icon_order_lookup_set(self.obj, order)

        def __get__(self):
            return elm_toolbar_icon_order_lookup_get(self.obj)

    def item_append(self, icon, label, callback = None, *args, **kargs):
        # Everything is done in the ToolbarItem class, because of wrapping the
        # C structures in python classes
        return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_prepend(self, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_before(self, before, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_after(self, after, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    def first_item_get(self):
        return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    def item_find_by_label(self, label):
        return _object_item_to_python(elm_toolbar_item_find_by_label(self.obj, _cfruni(label)))

    def selected_item_get(self):
        return _object_item_to_python(elm_toolbar_selected_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_selected_item_get(self.obj))

    def more_item_get(self):
        return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    property more_item:
        def __get__(self):
            return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    def shrink_mode_set(self, mode):
        elm_toolbar_shrink_mode_set(self.obj, mode)

    def shrink_mode_get(self):
        return elm_toolbar_shrink_mode_get(self.obj)

    property shrink_mode:
        def __get__(self):
            return elm_toolbar_shrink_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_shrink_mode_set(self.obj, mode)

    def homogeneous_set(self, homogeneous):
        elm_toolbar_homogeneous_set(self.obj, homogeneous)

    def homogeneous_get(self):
        return elm_toolbar_homogeneous_get(self.obj)

    property homogeneous:
        def __set__(self, homogeneous):
            elm_toolbar_homogeneous_set(self.obj, homogeneous)

        def __get__(self):
            return elm_toolbar_homogeneous_get(self.obj)

    def menu_parent_set(self, evasObject parent):
        elm_toolbar_menu_parent_set(self.obj, parent.obj)

    def menu_parent_get(self):
        return object_from_instance(elm_toolbar_menu_parent_get(self.obj))

    property menu_parent:
        def __get__(self):
            return object_from_instance(elm_toolbar_menu_parent_get(self.obj))

        def __set__(self, evasObject parent):
            elm_toolbar_menu_parent_set(self.obj, parent.obj)

    def align_set(self, align):
        elm_toolbar_align_set(self.obj, align)

    def align_get(self):
        return elm_toolbar_align_get(self.obj)

    property align:
        def __set__(self, align):
            elm_toolbar_align_set(self.obj, align)

        def __get__(self):
            return elm_toolbar_align_get(self.obj)

    def horizontal_set(self, horizontal):
        elm_toolbar_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return elm_toolbar_horizontal_get(self.obj)

    property horizontal:
        def __set__(self, horizontal):
            elm_toolbar_horizontal_set(self.obj, horizontal)

        def __get__(self):
            return elm_toolbar_horizontal_get(self.obj)

    def items_count(self):
        return elm_toolbar_items_count(self.obj)

    property standard_priority:
        def __set__(self, priority):
            elm_toolbar_standard_priority_set(self.obj, priority)
        def __get__(self):
            return elm_toolbar_standard_priority_get(self.obj)

    def select_mode_set(self, mode):
        elm_toolbar_select_mode_set(self.obj, mode)

    def select_mode_get(self):
        return elm_toolbar_select_mode_get(self.obj)

    property select_mode:
        def __get__(self):
            return elm_toolbar_select_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_select_mode_set(self.obj, mode)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_toolbar", Toolbar)
