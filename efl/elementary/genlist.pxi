# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

include "genlist_cdef.pxi"

cdef char *_py_elm_genlist_item_text_get(void *data, Evas_Object *obj, const char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)

    func = item.item_class._text_get_func
    if func is None:
        return NULL

    try:
        o = object_from_instance(obj)
        ret = func(o, u, item.item_data)
    except Exception:
        traceback.print_exc()
        return NULL

    if ret is not None:
        if isinstance(ret, unicode): ret = PyUnicode_AsUTF8String(ret)
        return strdup(ret)
    else:
        return NULL

cdef Evas_Object *_py_elm_genlist_item_content_get(void *data, Evas_Object *obj, const char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)
        evasObject icon

    func = item.item_class._content_get_func
    if func is None:
        return NULL

    o = object_from_instance(obj)

    try:
        icon = func(o, u, item.item_data)
    except Exception:
        traceback.print_exc()
        return NULL

    if icon is not None:
        return icon.obj
    else:
        return NULL

cdef Evas_Object *_py_elm_genlist_item_reusable_content_get(void *data, Evas_Object *obj, const char *part, Evas_Object *old) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)
        evasObject icon

    func = item.item_class._reusable_content_get_func
    if func is None:
        return NULL

    o = object_from_instance(obj)
    old_content = object_from_instance(old)

    try:
        icon = func(o, u, item.item_data, old_content)
    except Exception:
        traceback.print_exc()
        return NULL

    if icon is not None:
        return icon.obj
    else:
        return NULL

cdef Eina_Bool _py_elm_genlist_item_state_get(void *data, Evas_Object *obj, const char *part) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        unicode u = _ctouni(part)
        bint ret
        Genlist o

    func = item.item_class._state_get_func
    if func is None:
        return 0

    try:
        o = object_from_instance(obj)
        ret = func(o, u, item.item_data)
    except Exception:
        traceback.print_exc()
        return 0

    return ret

cdef Eina_Bool _py_elm_genlist_item_filter_get(void *data, Evas_Object *obj, void *key) with gil:
    cdef:
        GenlistItem item = <GenlistItem>data
        object pykey = <object>key
        bint ret
        Genlist o

    func = item.item_class._filter_get_func
    if func is None:
        return 1

    try:
        o = object_from_instance(obj)
        ret = func(o, pykey, item.item_data)
    except Exception:
        traceback.print_exc()
        return 0

    return ret

cdef void _py_elm_genlist_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GenlistItem item = <GenlistItem>data

    if item is None:
        return

    func = item.item_class._del_func

    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, item.item_data)
        except Exception:
            traceback.print_exc()

    item._unset_obj()

cdef void _py_elm_genlist_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GenlistItem item

    assert data != NULL, "data is NULL in Genlist select cb"

    item = <GenlistItem>data

    if item.cb_func is not None:
        try:
            o = object_from_instance(obj)
            item.cb_func(item, o, item.func_data)
        except Exception:
            traceback.print_exc()

cdef int _py_elm_genlist_compare_func(const void *data1, const void *data2) with gil:
    cdef:
        Elm_Object_Item *citem1 = <Elm_Object_Item *>data1
        Elm_Object_Item *citem2 = <Elm_Object_Item *>data2
        GenlistItem item1 = <GenlistItem>elm_object_item_data_get(citem1)
        GenlistItem item2 = <GenlistItem>elm_object_item_data_get(citem2)
        object func

    if item1.comparison_func is not None:
        func = item1.comparison_func
    elif item2.comparison_func is not None:
        func = item2.comparison_func
    else:
        return 0

    ret = func(item1, item2)
    if ret is not None:
        try:
            return ret
        except Exception:
            traceback.print_exc()
            return 0
    else:
        return 0

cdef class GenlistIterator(object):
    cdef:
        Elm_Object_Item *current_item
        GenlistItem ret

    def __cinit__(self, Genlist gl):
        self.current_item = elm_genlist_first_item_get(gl.obj)

    def __next__(self):
        if self.current_item == NULL:
            raise StopIteration
        ret = _object_item_to_python(self.current_item)
        self.current_item = elm_genlist_item_next_get(self.current_item)
        return ret

class GenlistItemsCount(int):
    def __new__(cls, Object obj, int count):
        return int.__new__(cls, count)

    def __init__(self, Object obj, int count):
        self.obj = obj

    @DEPRECATED("1.8", "Use items_count instead.")
    def __call__(self):
        return self.obj._items_count()

include "genlist_item_class.pxi"
include "genlist_item.pxi"
include "genlist_widget.pxi"
