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


cdef class DiskselectorItem(ObjectItem):

    def __init__(self, evasObject diskselector, label, evasObject icon=None, callback=None, *args, **kargs):
        cdef Evas_Object* icon_obj = NULL
        cdef Evas_Smart_Cb cb = NULL

        if icon is not None:
            icon_obj = icon.obj

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        item = elm_diskselector_item_append(diskselector.obj, _cfruni(label), icon_obj, cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    property selected:
        def __set__(self, selected):
            elm_diskselector_item_selected_set(self.item, selected)
        def __get__(self):
            return bool(elm_diskselector_item_selected_get(self.item))

    property prev:
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_item_prev_get(self.item)
            return _object_item_to_python(it)

    property next:
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_item_next_get(self.item)
            return _object_item_to_python(it)


cdef class Diskselector(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_diskselector_add(parent.obj))

    property round_enabled:
        def __set__(self, enabled):
            elm_diskselector_round_enabled_set(self.obj, enabled)
        def __get__(self):
            return bool(elm_diskselector_round_enabled_get(self.obj))

    property side_text_max_length:
        def __get__(self):
            return elm_diskselector_side_text_max_length_get(self.obj)
        def __set__(self, length):
            elm_diskselector_side_text_max_length_set(self.obj, length)

    property display_item_num:
        def __set__(self, num):
            elm_diskselector_display_item_num_set(self.obj, num)
        def __get__(self):
            return elm_diskselector_display_item_num_get(self.obj)

    property bounce:
        def __set__(self, bounce):
            h_bounce, v_bounce = bounce
            elm_scroller_bounce_set(self.obj, h_bounce, v_bounce)
        def __get__(self):
            cdef Eina_Bool h_bounce, v_bounce
            elm_scroller_bounce_get(self.obj, &h_bounce, &v_bounce)
            return (h_bounce, v_bounce)

    property scroller_policy:
        def __get__(self):
            cdef Elm_Scroller_Policy h_policy, v_policy
            elm_scroller_policy_get(self.obj, &h_policy, &v_policy)
            return (h_policy, v_policy)
        def __set__(self, policy):
            h_policy, v_policy = policy
            elm_scroller_policy_set(self.obj, h_policy, v_policy)

    def clear(self):
        elm_diskselector_clear(self.obj)

    property items:
        def __get__(self):
            cdef Elm_Object_Item *it
            cdef const_Eina_List *lst

            lst = elm_diskselector_items_get(self.obj)
            ret = []
            ret_append = ret.append
            while lst:
                it = <Elm_Object_Item *>lst.data
                lst = lst.next
                o = _object_item_to_python(it)
                if o is not None:
                    ret_append(o)
            return ret

    def item_append(self, label, evasObject icon = None, callback = None, *args, **kwargs):
        return DiskselectorItem(self, label, icon, callback, *args, **kwargs)

    property selected_item:
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_selected_item_get(self.obj)
            return _object_item_to_python(it)

    property first_item:
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_first_item_get(self.obj)
            return _object_item_to_python(it)

    property last_item:
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_last_item_get(self.obj)
            return _object_item_to_python(it)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,start", func, *args, **kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,stop", func, *args, **kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,start", func, *args, **kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,stop", func, *args, **kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)


_object_mapping_register("elm_diskselector", Diskselector)
