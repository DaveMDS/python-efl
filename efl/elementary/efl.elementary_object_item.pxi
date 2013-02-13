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


cdef Evas_Object *_tooltip_item_content_create(void *data, Evas_Object *o, Evas_Object *t, void *it) with gil:
   cdef Object ret, obj, tooltip

#    obj = <Object>evas_object_data_get(o, "python-evas")
   obj = object_from_instance(o)
   tooltip = object_from_instance(t)
   (func, item, args, kargs) = <object>data
   ret = func(obj, item, *args, **kargs)
   if not ret:
       return NULL
   return ret.obj

cdef void _tooltip_item_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
   Py_DECREF(<object>data)

cdef class ObjectItem

def _cb_object_item_conv(long addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef Elm_Object_Item * _object_item_from_python(ObjectItem item) except NULL:
    if item is None or item.item is NULL:
        raise TypeError("Invalid item!")
    return item.item

cdef _object_item_to_python(Elm_Object_Item *it):
    cdef void *data
    cdef object item

    if it == NULL:
        return None

    data = elm_object_item_data_get(it)
    if data == NULL:
        return None

    item = <object>data
    return item

cdef _object_item_list_to_python(const_Eina_List *lst):
    cdef Elm_Object_Item *it
    ret = []
    ret_append = ret.append
    while lst:
        it = <Elm_Object_Item *>lst.data
        lst = lst.next
        o = _object_item_to_python(it)
        if o is not None:
            ret_append(o)
    return ret

cdef void _object_item_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    cdef ObjectItem d = <object>data
    d.item = NULL
    Py_DECREF(d)

cdef void _object_item_callback(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef ObjectItem item = <object>data
    (callback, a, ka) = item.params
    try:
        o = object_from_instance(obj)
        callback(o, item, *a, **ka)
    except Exception as e:
        traceback.print_exc()

cdef class ObjectItem(object):

    # Notes to bindings' developers:
    # ==============================
    #
    # After calling _set_obj, Elm_Object_Item's "data" contains the python item
    # instance pointer, and the attribute "item", that you see below, contains
    # a pointer to Elm_Object_Item.
    #
    # The variable params holds callback data, usually the tuple
    # (callback, args, kwargs). Note that some of the generic object item
    # functions expect this tuple. Use custom functions if you assign the
    # params differently.
    #
    # Gen type widgets MUST set the params BEFORE adding the item as the
    # items need their data immediately when adding them.

    cdef Elm_Object_Item *item
    cdef object params

    def __dealloc__(self):
        if self.item != NULL:
            elm_object_item_del_cb_set(self.item, NULL)
            elm_object_item_del(self.item)
            self.item = NULL

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        elm_object_item_data_set(item, <void*>self)
        elm_object_item_del_cb_set(item, _object_item_del_cb)
        Py_INCREF(self)
        return 1

    def widget_get(self):
        return object_from_instance(elm_object_item_widget_get(self.item))

    def part_content_set(self, part, Object content not None):
        elm_object_item_part_content_set(self.item, _cfruni(part), content.obj)

    def content_set(self, Object content not None):
        elm_object_item_content_set(self.item, content.obj)

    def part_content_get(self, part):
        return object_from_instance(elm_object_item_part_content_get(self.item, _cfruni(part)))

    def content_get(self):
        return object_from_instance(elm_object_item_content_get(self.item))

    def part_content_unset(self, part):
        return object_from_instance(elm_object_item_part_content_unset(self.item, _cfruni(part)))

    def content_unset(self):
        return object_from_instance(elm_object_item_content_unset(self.item))

    def part_text_set(self, part, text):
        elm_object_item_part_text_set(self.item, _cfruni(part), _cfruni(text))

    def text_set(self, text):
        elm_object_item_text_set(self.item, _cfruni(text))

    def part_text_get(self, part):
        return _ctouni(elm_object_item_part_text_get(self.item, _cfruni(part)))

    def text_get(self):
        return _ctouni(elm_object_item_text_get(self.item))

    property text:
        def __get__(self):
            return self.text_get()

        def __set__(self, value):
            self.text_set(value)

    def access_info_set(self, txt):
        elm_object_item_access_info_set(self.item, _cfruni(txt))

    def data_get(self):
        (callback, a, ka) = self.params
        return (a, ka)

    def data_set(self, *args, **kwargs):
        (callback, a, ka) = self.params
        self.params = tuple(callback, *args, **kwargs)

    property data:
        def __get__(self):
            return self.data_get()
        #def __set__(self, data):
            #self.data_set(data)

    def signal_emit(self, emission, source):
        elm_object_item_signal_emit(self.item, _cfruni(emission), _cfruni(source))

    def disabled_set(self, disabled):
        elm_object_item_disabled_set(self.item, disabled)

    def disabled_get(self):
        return bool(elm_object_item_disabled_get(self.item))

    property disabled:
        def __get__(self):
            return self.disabled_get()
        def __set__(self, disabled):
            self.disabled_set(disabled)

    #def delete_cb_set(self, del_cb):
        #elm_object_item_del_cb_set(self.item, del_cb)

    def delete(self):
        if self.item == NULL:
            raise ValueError("Object already deleted")
        elm_object_item_del(self.item)
        Py_DECREF(self)

    def tooltip_text_set(self, char *text):
        elm_object_item_tooltip_text_set(self.item, _cfruni(text))

    def tooltip_window_mode_set(self, disable):
        return bool(elm_object_item_tooltip_window_mode_set(self.item, disable))

    def tooltip_window_mode_get(self):
        return bool(elm_object_item_tooltip_window_mode_get(self.item))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_object_item_tooltip_content_cb_set(self.item, _tooltip_item_content_create,
                                          cbdata, _tooltip_item_data_del_cb)

    def tooltip_unset(self):
        elm_object_item_tooltip_unset(self.item)

    def tooltip_style_set(self, style=None):
        elm_object_item_tooltip_style_set(self.item, _cfruni(style) if style is not None else NULL)

    def tooltip_style_get(self):
        return _ctouni(elm_object_item_tooltip_style_get(self.item))

    def cursor_set(self, char *cursor):
        elm_object_item_cursor_set(self.item, _cfruni(cursor))

    def cursor_get(self):
        return _ctouni(elm_object_item_cursor_get(self.item))

    def cursor_unset(self):
        elm_object_item_cursor_unset(self.item)

    def cursor_style_set(self, style=None):
        elm_object_item_cursor_style_set(self.item, _cfruni(style) if style is not None else NULL)

    def cursor_style_get(self):
        return _ctouni(elm_object_item_cursor_style_get(self.item))

    def cursor_engine_only_set(self, engine_only):
        elm_object_item_cursor_engine_only_set(self.item, bool(engine_only))

    def cursor_engine_only_get(self):
        return elm_object_item_cursor_engine_only_get(self.item)


_object_mapping_register("elm_object_item", ObjectItem)
