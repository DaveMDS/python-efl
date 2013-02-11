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

cdef class PopupItem(ObjectItem):

    def __init__(self, evasObject popup, label = None, evasObject icon = None, func = None, *args, **kwargs):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb

        if func is None:
            cb = NULL
        elif callable(func):
            cb = _object_item_callback
        else:
            raise TypeError("func is not None or callable")

        self.params = (func, args, kwargs)
        item = elm_popup_item_append(popup.obj, _cfruni(label),
                                     icon.obj if icon else NULL,
                                     cb, <void *>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def __str__(self):
        return "%s(func=%s, item_data=%s)" % \
               (self.__class__.__name__,
                self.params[0],
                self.params[1])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)") % \
               (self.__class__.__name__,
                <unsigned long><void*>self,
                PY_REFCOUNT(self),
                <unsigned long>self.item,
                self.params[0],
                self.params[1])


cdef class Popup(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_popup_add(parent.obj))

    def item_append(self, label = None, evasObject icon = None, func = None, *args, **kwargs):
        return PopupItem(self, label, icon, func, *args, **kwargs)

    property content_text_wrap_type:
        def __set__(self, wrap):
            elm_popup_content_text_wrap_type_set(self.obj, wrap)
        def __get__(self):
            return elm_popup_content_text_wrap_type_get(self.obj)

    property orient:
        def __set__(self, orient):
            elm_popup_orient_set(self.obj, orient)
        def __get__(self):
            return elm_popup_orient_get(self.obj)

    property timeout:
        def __set__(self, timeout):
            elm_popup_timeout_set(self.obj, timeout)
        def __get__(self):
            return elm_popup_timeout_get(self.obj)

    property allow_events:
        def __set__(self, allow):
            elm_popup_allow_events_set(self.obj, allow)
        def __get__(self):
            return bool(elm_popup_allow_events_get(self.obj))

    def callback_timeout_add(self, func, *args, **kwargs):
        self._callback_add("timeout", func, *args, **kwargs)

    def callback_timeout_del(self, func):
        self._callback_del("timeout", func)

    def callback_block_clicked_add(self, func, *args, **kwargs):
        self._callback_add("block,clicked", func, *args, **kwargs)

    def callback_block_clicked_del(self, func):
        self._callback_del("block,clicked", func)


_object_mapping_register("elm_popup", Popup)
