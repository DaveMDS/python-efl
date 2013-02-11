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

cdef enum Elm_List_Item_Insert_Kind:
    ELM_LIST_ITEM_INSERT_APPEND
    ELM_LIST_ITEM_INSERT_PREPEND
    ELM_LIST_ITEM_INSERT_BEFORE
    ELM_LIST_ITEM_INSERT_AFTER
    ELM_LIST_ITEM_INSERT_SORTED

cdef class ListItem(ObjectItem):

    def __init__(self, kind, evasObject list, label, evasObject icon = None,
                 evasObject end = None, ListItem before_after = None,
                 callback = None, *args, **kargs):

        cdef Evas_Object* icon_obj = NULL
        cdef Evas_Object* end_obj = NULL
        cdef Evas_Smart_Cb cb = NULL

        if icon is not None:
            icon_obj = icon.obj
        if end is not None:
            end_obj = end.obj

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        if kind == ELM_LIST_ITEM_INSERT_APPEND:
            item = elm_list_item_append(   list.obj,
                                            _cfruni(label),
                                            icon_obj,
                                            end_obj,
                                            cb,
                                            <void*>self)

        elif kind == ELM_LIST_ITEM_INSERT_PREPEND:
            item = elm_list_item_prepend(  list.obj,
                                            _cfruni(label),
                                            icon_obj,
                                            end_obj,
                                            cb,
                                            <void*>self)

        #elif kind == ELM_LIST_ITEM_INSERT_SORTED:
            #item = elm_list_item_sorted_insert(   list.obj,
                                                    #_cfruni(label),
                                                    #icon_obj,
                                                    #end_obj,
                                                    #cb,
                                                    #<void*>self,
                                                    #cmp_f)

        else:
            if before_after == None:
                raise ValueError("need a valid after object to add an item before/after another item")

            if kind == ELM_LIST_ITEM_INSERT_BEFORE:
                item = elm_list_item_insert_before(list.obj,
                                                    before_after.item,
                                                    _cfruni(label),
                                                    icon_obj,
                                                    end_obj,
                                                    cb,
                                                    <void*>self)

            else:
                item = elm_list_item_insert_after( list.obj,
                                                    before_after.item,
                                                    _cfruni(label),
                                                    icon_obj,
                                                    end_obj,
                                                    cb,
                                                    <void*>self)
        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def __str__(self):
        return ("%s(label=%r, icon=%s, end=%s, "
                "callback=%r, args=%r, kargs=%s)") % \
            (self.__class__.__name__, self.text_get(), bool(self.part_content_get("icon")),
             bool(self.part_content_get("end")), self.params[0], self.params[1], self.params[2])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "label=%r, icon=%s, end=%s, "
                "callback=%r, args=%r, kargs=%s)") % \
            (self.__class__.__name__, <unsigned long><void *>self,
             PY_REFCOUNT(self), <unsigned long><void *>self.item,
             self.text_get(), bool(self.part_content_get("icon")),
             bool(self.part_content_get("end")), self.params[0], self.params[1], self.params[2])

    def selected_set(self, selected):
        elm_list_item_selected_set(self.item, selected)

    def selected_get(self):
        return bool(elm_list_item_selected_get(self.item))

    property selected:
        def __get__(self):
            return bool(elm_list_item_selected_get(self.item))

        def __set__(self, selected):
            elm_list_item_selected_set(self.item, selected)

    def separator_set(self, separator):
        elm_list_item_separator_set(self.item, separator)

    def separator_get(self):
        return bool(elm_list_item_separator_get(self.item))

    property separator:
        def __get__(self):
            return bool(elm_list_item_separator_get(self.item))

        def __set__(self, separator):
            elm_list_item_separator_set(self.item, separator)

    def show(self):
        elm_list_item_show(self.item)

    def bring_in(self):
        elm_list_item_bring_in(self.item)

    def object_get(self):
        return object_from_instance(elm_list_item_object_get(self.item))

    property object:
        def __get__(self):
            return object_from_instance(elm_list_item_object_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_list_item_prev(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_list_item_prev(self.item))

    def next_get(self):
        return _object_item_to_python(elm_list_item_next(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_list_item_next(self.item))

cdef class List(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_list_add(parent.obj))

    def go(self):
        elm_list_go(self.obj)

    def multi_select_set(self, multi):
        elm_list_multi_select_set(self.obj, multi)

    def multi_select_get(self):
        return bool(elm_list_multi_select_get(self.obj))

    property multi_select:
        def __get__(self):
            return elm_list_multi_select_get(self.obj)

        def __set__(self, multi):
            elm_list_multi_select_set(self.obj, multi)

    def mode_set(self, Elm_List_Mode mode):
        elm_list_mode_set(self.obj, mode)

    def mode_get(self):
        return elm_list_mode_get(self.obj)

    property mode:
        def __get__(self):
            return elm_list_mode_get(self.obj)

        def __set__(self, Elm_List_Mode mode):
            elm_list_mode_set(self.obj, mode)

    property horizontal:
        def __get__(self):
            return elm_list_horizontal_get(self.obj)

        def __set__(self, horizontal):
            elm_list_horizontal_set(self.obj, horizontal)

    def select_mode_set(self, mode):
        elm_list_select_mode_set(self.obj, mode)

    def select_mode_get(self):
        return elm_list_select_mode_get(self.obj)

    property select_mode:
        def __set__(self, mode):
            elm_list_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_list_select_mode_get(self.obj)

    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)

    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

    property bounce:
        def __set__(self, value):
            h, v = value
            elm_scroller_bounce_set(self.obj, h, v)

    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)

    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property scroller_policy:
        def __set__(self, value):
            policy_h, policy_v = value
            elm_scroller_policy_set(self.obj, policy_h, policy_v)

        def __get__(self):
            cdef Elm_Scroller_Policy policy_h, policy_v
            elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
            return (policy_h, policy_v)

    def item_append(self, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(ELM_LIST_ITEM_INSERT_APPEND, self, label, icon, end,
                        None, callback, *args, **kargs)

    def item_prepend(self, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(ELM_LIST_ITEM_INSERT_PREPEND, self, label, icon, end,
                        None, callback, *args, **kargs)

    def item_insert_before(self, ListItem before, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(ELM_LIST_ITEM_INSERT_BEFORE, self, label, icon, end,
                        before, callback, *args, **kargs)

    def item_insert_after(self, ListItem after, label, evasObject icon = None,
                    evasObject end = None, callback = None, *args, **kargs):
        return ListItem(ELM_LIST_ITEM_INSERT_AFTER, self, label, icon, end,
                        after, callback, *args, **kargs)

    #def item_sorted_insert(self, label, evasObject icon = None,
                    #evasObject end = None, callback = None, cmp_func=None, *args, **kargs):
        #return ListItem(ELM_LIST_ITEM_INSERT_SORTED, self, label, icon, end,
                        #None, callback, *args, **kargs)

    def clear(self):
        elm_list_clear(self.obj)

    def items_get(self):
        return _object_item_list_to_python(elm_list_items_get(self.obj))

    property items:
        def __get__(self):
            return _object_item_list_to_python(elm_list_items_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_list_selected_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return _object_item_to_python(elm_list_selected_item_get(self.obj))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_list_selected_items_get(self.obj))

    property selected_items:
        def __get__(self):
            return _object_item_list_to_python(elm_list_selected_items_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_list_first_item_get(self.obj))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_list_first_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_list_last_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_list_last_item_get(self.obj))

    def callback_activated_add(self, func, *args, **kwargs):
        self._callback_add_full("activated", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated",  _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected", _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add_full("longpressed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        self._callback_add("edge,top", func, *args, **kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top",  func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        self._callback_add("edge,bottom", func, *args, **kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom",  func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        self._callback_add("edge,left", func, *args, **kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left",  func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        self._callback_add("edge,right", func, *args, **kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right",  func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed",  func)


_object_mapping_register("elm_list", List)
