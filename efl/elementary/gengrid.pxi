# Copyright (C) 2007-2022 various contributors (see AUTHORS)
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
#

include "gengrid_cdef.pxi"

cdef char *_py_elm_gengrid_item_text_get(void *data, Evas_Object *obj, const char *part) noexcept with gil:
    cdef:
        GengridItem item = <GengridItem>data
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

cdef Evas_Object *_py_elm_gengrid_item_content_get(void *data, Evas_Object *obj, const char *part) noexcept with gil:
    cdef:
        GengridItem item = <GengridItem>data
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

cdef Eina_Bool _py_elm_gengrid_item_state_get(void *data, Evas_Object *obj, const char *part) noexcept with gil:
    cdef:
        GengridItem item = <GengridItem>data
        unicode u = _ctouni(part)

    func = item.item_class._state_get_func
    if func is None:
        return 0

    try:
        o = object_from_instance(obj)
        ret = func(o, part, item.item_data)
    except Exception:
        traceback.print_exc()
        return 0

    return ret if ret is not None else 0

cdef void _py_elm_gengrid_object_item_del(void *data, Evas_Object *obj) noexcept with gil:
    cdef GengridItem item = <GengridItem>data

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

cdef void _py_elm_gengrid_item_func(void *data, Evas_Object *obj, void *event_info) noexcept with gil:
    cdef GengridItem item

    assert data != NULL, "data is NULL in Gengrid select cb"

    item = <GengridItem>data

    if item.cb_func is not None:
        try:
            o = object_from_instance(obj)
            item.cb_func(item, o, item.func_data)
        except Exception:
            traceback.print_exc()

cdef int _gengrid_compare_cb(const void *data1, const void *data2) noexcept with gil:
    cdef:
        Elm_Object_Item *citem1 = <Elm_Object_Item *>data1
        Elm_Object_Item *citem2 = <Elm_Object_Item *>data2
        GengridItem item1 = <GengridItem>elm_object_item_data_get(citem1)
        GengridItem item2 = <GengridItem>elm_object_item_data_get(citem2)
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

include "gengrid_widget.pxi"
include "gengrid_item_class.pxi"
include "gengrid_item.pxi"
