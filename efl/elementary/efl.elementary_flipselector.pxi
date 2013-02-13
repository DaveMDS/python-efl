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


cdef class FlipSelectorItem(ObjectItem):

    property selected:
        def __set__(self, selected):
            elm_flipselector_item_selected_set(self.item, selected)

        def __get__(self):
            return bool(elm_flipselector_item_selected_get(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_flipselector_item_prev_get(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_flipselector_item_next_get(self.item))


cdef class FlipSelector(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_flipselector_add(parent.obj))

    def next(self):
        elm_flipselector_flip_next(self.obj)

    def prev(self):
        elm_flipselector_flip_prev(self.obj)

    def item_append(self, label = None, callback = None, *args, **kwargs):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        cdef FlipSelectorItem ret = FlipSelectorItem()

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        ret.params = (callback, args, kwargs)
        item = elm_flipselector_item_append(self.obj,
                                            _cfruni(label),
                                            cb,
                                            <void *>self)

        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return

    def item_prepend(self, label = None, callback = None, *args, **kwargs):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        cdef FlipSelectorItem ret = FlipSelectorItem()

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        ret.params = (callback, args, kwargs)
        item = elm_flipselector_item_append(self.obj,
                                            _cfruni(label),
                                            cb,
                                            <void *>self)

        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return

    property items:
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_flipselector_items_get(self.obj)))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_flipselector_first_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_flipselector_last_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return _object_item_to_python(elm_flipselector_selected_item_get(self.obj))

    property first_interval:
        def __set__(self, interval):
            elm_flipselector_first_interval_set(self.obj, interval)

        def __get__(self):
            return elm_flipselector_first_interval_get(self.obj)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add("selected", func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del("selected", func)

    def callback_overflowed_add(self, func, *args, **kwargs):
        self._callback_add("overflowed", func, *args, **kwargs)

    def callback_overflowed_del(self, func):
        self._callback_del("overflowed", func)

    def callback_underflowed_add(self, func, *args, **kwargs):
        self._callback_add("underflowed", func, *args, **kwargs)

    def callback_underflowed_del(self, func):
        self._callback_del("underflowed", func)


_object_mapping_register("elm_flipselector", FlipSelector)
