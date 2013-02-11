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

cdef _py_elm_slideshow_item_call(func, Evas_Object *obj, data) with gil:
    try:
        o = object_from_instance(obj)
        (args, kwargs) = data
        return func(o, *args, **kwargs)
    except Exception as e:
        traceback.print_exc()
        return None

cdef Evas_Object *_py_elm_slideshow_item_get(void *data, Evas_Object *obj) with gil:
    cdef SlideshowItem item = <object>data
    cdef object params = item.params
    cdef evasObject icon
    cdef SlideshowItemClass itc = params[0]

    func = itc._get_func
    if func is None:
        return NULL

    ret = _py_elm_slideshow_item_call(func, obj, params[1])
    if ret is not None:
        try:
            icon = ret
            return icon.obj
        except Exception as e:
            traceback.print_exc()
            return NULL
    else:
        return NULL

cdef void _py_elm_slideshow_item_del(void *data, Evas_Object *obj) with gil:
    cdef SlideshowItem item = <object>data
    cdef object params = item.params
    cdef SlideshowItemClass itc = params[0]

    func = itc._del_func
    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, params[1])
        except Exception as e:
            traceback.print_exc()
    item._unset_obj()
    Py_DECREF(item)

cdef int _py_elm_slideshow_compare_func(const_void *data1, const_void *data2) with gil:
    cdef SlideshowItem item1    = <object>data1
    cdef SlideshowItem item2    = <object>data2
    cdef object params          = item1.params
    cdef object func            = params[2]

    if func is None:
        return 0

    ret = func(item1, item2)
    if ret is not None:
        try:
            return ret
        except Exception as e:
            traceback.print_exc()
            return 0
    else:
        return 0


cdef class SlideshowItemClass(object):
    cdef Elm_Slideshow_Item_Class obj
    cdef readonly object _get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self._get_func = None
        self._del_func = None

        self.obj.func.get = _py_elm_slideshow_item_get
        self.obj.func.del_ = _py_elm_slideshow_item_del

    def __init__(self, get_func=None, del_func=None):
        if get_func and not callable(get_func):
            raise TypeError("get_func is not callable!")
        elif get_func:
            self._get_func = get_func
        else:
            self._get_func = self.get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

    def __str__(self):
        return ("%s(get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                self._get_func,
                self._del_func)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Slideshow_Item_Class=%#x, "
                "get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                <unsigned long><void *>self,
                PY_REFCOUNT(self),
                <unsigned long>&self.obj,
                self._get_func,
                self._del_func)

    def get(self, evasObject obj, item_data):
        return None


cdef class SlideshowItem(ObjectItem):

    cdef int _set_obj(self, Elm_Object_Item *item, params=None) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef void _unset_obj(self):
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL

    def __str__(self):
        return "%s(item_class=%s, func=%s, item_data=%s)" % \
               (self.__class__.__name__,
                self.params[0].__class__.__name__,
                self.params[3],
                self.params[1])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)") % \
               (self.__class__.__name__,
                <unsigned long><void*>self,
                PY_REFCOUNT(self),
                <unsigned long>self.obj,
                self.params[0].__class__.__name__,
                self.params[3],
                self.params[1])

    property object:
        def __get__(self):
            return object_from_instance(elm_slideshow_item_object_get(self.item))

    def show(self):
        elm_slideshow_item_show(self.item)


cdef class Slideshow(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_slideshow_add(parent.obj))

    def item_add(self, SlideshowItemClass item_class not None, *args, **kwargs):
        cdef SlideshowItem ret = SlideshowItem()
        cdef Elm_Object_Item *item

        item_data = (args, kwargs)
        ret.params = (item_class, item_data)
        item = elm_slideshow_item_add(self.obj, &item_class.obj, <void*>ret)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_sorted_insert(self, SlideshowItemClass item_class not None,
                            func not None, *args, **kwargs):
        cdef SlideshowItem ret = SlideshowItem()
        cdef Elm_Object_Item *item
        cdef Eina_Compare_Cb compare

        if callable(func):
            compare = _py_elm_slideshow_compare_func
        else:
            raise TypeError("func is not None or callable")

        item_data = (args, kwargs)
        ret.params = (item_class, item_data, func)
        item = elm_slideshow_item_sorted_insert(self.obj, &item_class.obj, <void*>ret, compare)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def next(self):
        elm_slideshow_next(self.obj)

    def previous(self):
        elm_slideshow_previous(self.obj)

    property transitions:
        def __get__(self):
            return tuple(_strings_to_python(elm_slideshow_transitions_get(self.obj)))

    property transition:
        def __set__(self, transition):
            elm_slideshow_transition_set(self.obj, _cfruni(transition))
        def __get__(self):
            return _ctouni(elm_slideshow_transition_get(self.obj))

    property timeout:
        def __set__(self, timeout):
            elm_slideshow_timeout_set(self.obj, timeout)
        def __get__(self):
            return elm_slideshow_timeout_get(self.obj)

    property loop:
        def __set__(self, loop):
            elm_slideshow_loop_set(self.obj, loop)
        def __get__(self):
            return bool(elm_slideshow_loop_get(self.obj))

    def clear(self):
        elm_slideshow_clear(self.obj)

    property items:
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_slideshow_items_get(self.obj)))

    property current_item:
        def __get__(self):
            return _object_item_to_python(elm_slideshow_item_current_get(self.obj))

    def nth_item_get(self, nth):
        return _object_item_to_python(elm_slideshow_item_nth_get(self.obj, nth))

    property layout:
        def __set__(self, layout):
            elm_slideshow_layout_set(self.obj, _cfruni(layout))
        def __get__(self):
            return _ctouni(elm_slideshow_layout_get(self.obj))

    property layouts:
        def __get__(self):
            return tuple(_strings_to_python(elm_slideshow_layouts_get(self.obj)))

    property cache_before:
        def __set__(self, count):
            elm_slideshow_cache_before_set(self.obj, count)
        def __get__(self):
            return elm_slideshow_cache_before_get(self.obj)

    property cache_after:
        def __set__(self, count):
            elm_slideshow_cache_after_set(self.obj, count)
        def __get__(self):
            return elm_slideshow_cache_after_get(self.obj)

    property count:
        def __get__(self):
            return elm_slideshow_count_get(self.obj)

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("changed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed", _cb_object_item_conv, func)

    def callback_transition_end_add(self, func, *args, **kwargs):
        self._callback_add_full("transition,end", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_transition_end_del(self, func):
        self._callback_del_full("transition,end", _cb_object_item_conv, func)


_object_mapping_register("elm_slideshow", Slideshow)
