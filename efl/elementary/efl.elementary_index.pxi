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


cdef enum Elm_Index_Item_Insert_Kind:
    ELM_INDEX_ITEM_INSERT_APPEND
    ELM_INDEX_ITEM_INSERT_PREPEND
    ELM_INDEX_ITEM_INSERT_BEFORE
    ELM_INDEX_ITEM_INSERT_AFTER
    ELM_INDEX_ITEM_INSERT_SORTED


cdef class IndexItem(ObjectItem):
    def __init__(self, kind, evasObject index, letter, IndexItem before_after = None,
                 callback = None, *args, **kargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        if kind == ELM_INDEX_ITEM_INSERT_APPEND:
            item = elm_index_item_append(index.obj, _cfruni(letter), cb, <void*>self)
        elif kind == ELM_INDEX_ITEM_INSERT_PREPEND:
            item = elm_index_item_prepend(index.obj, _cfruni(letter), cb, <void*>self)
        #elif kind == ELM_INDEX_ITEM_INSERT_SORTED:
            #item = elm_index_item_sorted_insert(index.obj, _cfruni(letter), cb, <void*>self, cmp_f, cmp_data_f)
        else:
            if before_after == None:
                raise ValueError("need a valid after object to add an item before/after another item")
            if kind == ELM_INDEX_ITEM_INSERT_BEFORE:
                item = elm_index_item_insert_before(index.obj, before_after.item, _cfruni(letter), cb, <void*>self)
            else:
                item = elm_index_item_insert_after(index.obj, before_after.item, _cfruni(letter), cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    def selected_set(self, selected):
        elm_index_item_selected_set(self.item, selected)

    property selected:
        def __set__(self, selected):
            elm_index_item_selected_set(self.item, selected)

    def letter_get(self):
        return _ctouni(elm_index_item_letter_get(self.item))

    property letter:
        def __get__(self):
            return _ctouni(elm_index_item_letter_get(self.item))

cdef Elm_Object_Item *_elm_index_item_from_python(IndexItem item):
    if item is None:
        return NULL
    else:
        return item.item


cdef class Index(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_index_add(parent.obj))

    def autohide_disabled_set(self, disabled):
        elm_index_autohide_disabled_set(self.obj, disabled)

    def autohide_disabled_get(self):
        return bool(elm_index_autohide_disabled_get(self.obj))

    property autohide_disabled:
        def __get__(self):
            return bool(elm_index_autohide_disabled_get(self.obj))

        def __set__(self, disabled):
            elm_index_autohide_disabled_set(self.obj, disabled)

    def item_level_set(self, level):
        elm_index_item_level_set(self.obj, level)

    def item_level_get(self):
        return elm_index_item_level_get(self.obj)

    property item_level:
        def __get__(self):
            return elm_index_item_level_get(self.obj)
        def __set__(self, level):
            elm_index_item_level_set(self.obj, level)

    def selected_item_get(self, level):
        return _object_item_to_python(elm_index_selected_item_get(self.obj, level))

    def item_append(self, letter, callback = None, *args, **kargs):
        return IndexItem(ELM_INDEX_ITEM_INSERT_APPEND, self, letter,
                        None, callback, *args, **kargs)

    def item_prepend(self, letter, callback = None, *args, **kargs):
        return IndexItem(ELM_INDEX_ITEM_INSERT_PREPEND, self, letter,
                        None, callback, *args, **kargs)

    def item_insert_after(self, IndexItem after, letter, callback = None, *args, **kargs):
        return IndexItem(ELM_INDEX_ITEM_INSERT_AFTER, self, letter,
                        after, callback, *args, **kargs)

    def item_insert_before(self, IndexItem before, letter, callback = None, *args, **kargs):
        return IndexItem(ELM_INDEX_ITEM_INSERT_BEFORE, self, letter,
                        before, callback, *args, **kargs)

    #def item_sorted_insert(self, letter, callback = None, *args, **kargs):
        #return IndexItem(ELM_INDEX_ITEM_INSERT_SORTED, self, letter,
                        #None, callback, *args, **kargs)

    def item_find(self, data):
        # XXX: This doesn't seem right.
        # return _object_item_to_python(elm_index_item_find(self.obj, <void*>data))
        pass

    def item_clear(self):
        elm_index_item_clear(self.obj)

    def level_go(self, level):
        elm_index_level_go(self.obj, level)

    def indicator_disabled_set(self, disabled):
        elm_index_indicator_disabled_set(self.obj, disabled)

    def indicator_disabled_get(self):
        return bool(elm_index_indicator_disabled_get(self.obj))

    property indicator_disabled:
        def __get__(self):
            return bool(elm_index_indicator_disabled_get(self.obj))
        def __set__(self, disabled):
            elm_index_indicator_disabled_set(self.obj, disabled)

    def horizontal_set(self, horizontal):
        elm_index_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return bool(elm_index_horizontal_get(self.obj))

    property horizontal:
        def __get__(self):
            return bool(elm_index_horizontal_get(self.obj))
        def __set__(self, horizontal):
            elm_index_horizontal_set(self.obj, horizontal)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("changed", _cb_object_item_conv, func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed",  _cb_object_item_conv, func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("delay,changed", _cb_object_item_conv, func, *args, **kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del_full("delay,changed",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected",  _cb_object_item_conv, func)

    def callback_level_up_add(self, func, *args, **kwargs):
        self._callback_add("level,up", func, *args, **kwargs)

    def callback_level_up_del(self, func):
        self._callback_del("level,up", func)

    def callback_level_down_add(self, func, *args, **kwargs):
        self._callback_add("level,down", func, *args, **kwargs)

    def callback_level_down_del(self, func):
        self._callback_del("level,down", func)


_object_mapping_register("elm_index", Index)
