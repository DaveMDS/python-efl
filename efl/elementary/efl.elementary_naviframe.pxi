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


cdef class NaviframeItem(ObjectItem):

    def item_pop_to(self):
        _METHOD_DEPRECATED(self, "pop_to")
        elm_naviframe_item_pop_to(self.item)

    def pop_to(self):
        elm_naviframe_item_pop_to(self.item)

    def item_promote(self):
        _METHOD_DEPRECATED(self, "promote")
        elm_naviframe_item_promote(self.item)

    def promote(self):
        elm_naviframe_item_promote(self.item)

    def style_set(self, style):
        elm_naviframe_item_style_set(self.item, _cfruni(style))

    def style_get(self):
        return _ctouni(elm_naviframe_item_style_get(self.item))

    property style:
        def __get__(self):
            return _ctouni(elm_naviframe_item_style_get(self.item))
        def __set__(self, style):
            elm_naviframe_item_style_set(self.item, _cfruni(style))

    def title_visible_set(self, visible):
        elm_naviframe_item_title_visible_set(self.item, visible)

    def title_visible_get(self):
        return bool(elm_naviframe_item_title_visible_get(self.item))

    property title_visible:
        def __get__(self):
            return bool(elm_naviframe_item_title_visible_get(self.item))
        def __set__(self, visible):
            elm_naviframe_item_title_visible_set(self.item, visible)


cdef class Naviframe(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_naviframe_add(parent.obj))

    def item_push(self, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, const_char_ptr item_style):
        cdef NaviframeItem ret = NaviframeItem()
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_push(self.obj, _cfruni(title_label),
                                       prev_btn.obj if prev_btn else NULL,
                                       next_btn.obj if next_btn else NULL,
                                       content.obj if content else NULL,
                                       _cfruni(item_style) if item_style else NULL)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_insert_before(self, NaviframeItem before, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, const_char_ptr item_style):
        cdef NaviframeItem ret = NaviframeItem()
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_insert_before(self.obj, before.item, _cfruni(title_label), prev_btn.obj, next_btn.obj, content.obj, _cfruni(item_style))
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_insert_after(self, NaviframeItem after, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, const_char_ptr item_style):
        cdef NaviframeItem ret = NaviframeItem()
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_insert_after(self.obj, after.item, _cfruni(title_label), prev_btn.obj, next_btn.obj, content.obj, _cfruni(item_style))
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_pop(self):
        return object_from_instance(elm_naviframe_item_pop(self.obj))

    def content_preserve_on_pop_set(self, preserve):
        elm_naviframe_content_preserve_on_pop_set(self.obj, preserve)

    def content_preserve_on_pop_get(self):
        return bool(elm_naviframe_content_preserve_on_pop_get(self.obj))

    property content_preserve_on_pop:
        def __get__(self):
            return bool(elm_naviframe_content_preserve_on_pop_get(self.obj))
        def __set__(self, preserve):
            elm_naviframe_content_preserve_on_pop_set(self.obj, preserve)

    def top_item_get(self):
        return _object_item_to_python(elm_naviframe_top_item_get(self.obj))

    property top_item:
        def __get__(self):
            return _object_item_to_python(elm_naviframe_top_item_get(self.obj))

    def bottom_item_get(self):
        return _object_item_to_python(elm_naviframe_bottom_item_get(self.obj))

    property bottom_item:
        def __get__(self):
            return _object_item_to_python(elm_naviframe_bottom_item_get(self.obj))

    def prev_btn_auto_pushed_set(self, auto_pushed):
        elm_naviframe_prev_btn_auto_pushed_set(self.obj, auto_pushed)

    def prev_btn_auto_pushed_get(self):
        return bool(elm_naviframe_prev_btn_auto_pushed_get(self.obj))

    property prev_btn_auto_pushed:
        def __get__(self):
            return bool(elm_naviframe_prev_btn_auto_pushed_get(self.obj))
        def __set__(self, auto_pushed):
            elm_naviframe_prev_btn_auto_pushed_set(self.obj, auto_pushed)

    def items_get(self):
        return _object_item_list_to_python(elm_naviframe_items_get(self.obj))

    property items:
        def __get__(self):
            return _object_item_list_to_python(elm_naviframe_items_get(self.obj))

    def event_enabled_set(self, enabled):
        elm_naviframe_event_enabled_set(self.obj, enabled)

    def event_enabled_get(self):
        return bool(elm_naviframe_event_enabled_get(self.obj))

    property event_enabled:
        def __get__(self):
            return bool(elm_naviframe_event_enabled_get(self.obj))
        def __set__(self, enabled):
            elm_naviframe_event_enabled_set(self.obj, enabled)

    def item_simple_push(self, evasObject content):
        cdef NaviframeItem ret = NaviframeItem()
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_simple_push(self.obj, content.obj)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_simple_promote(self, evasObject content):
        elm_naviframe_item_simple_promote(self.obj, content.obj)

    def callback_transition_finished_add(self, func, *args, **kwargs):
        self._callback_add("transition,finished", func, *args, **kwargs)

    def callback_transition_finished_del(self, func):
        self._callback_del("transition,finished", func)

    def callback_title_clicked_add(self, func, *args, **kwargs):
        self._callback_add("title,clicked", func, *args, **kwargs)

    def callback_title_clicked_del(self, func):
        self._callback_del("title,clicked", func)


_object_mapping_register("elm_naviframe", Naviframe)
