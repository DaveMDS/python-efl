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

import traceback


cdef _py_elm_genlist_item_call(func, Evas_Object *obj, part, data) with gil:
    try:
        o = object_from_instance(obj)
        return func(o, _ctouni(part), data)
    except Exception as e:
        traceback.print_exc()
        return None

cdef char *_py_elm_genlist_item_text_get(void *data, Evas_Object *obj, const_char_ptr part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef GenlistItemClass itc = params[0]

    func = itc._text_get_func
    if func is None:
        return NULL

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        return strdup(_fruni(ret))
    else:
        return NULL

cdef Evas_Object *_py_elm_genlist_item_content_get(void *data, Evas_Object *obj, const_char_ptr part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef evasObject icon
    cdef GenlistItemClass itc = params[0]

    func = itc._content_get_func
    if func is None:
        return NULL

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        try:
            icon = ret
            return icon.obj
        except Exception as e:
            traceback.print_exc()
            return NULL
    else:
        return NULL

cdef Eina_Bool _py_elm_genlist_item_state_get(void *data, Evas_Object *obj, const_char_ptr part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef GenlistItemClass itc = params[0]

    func = itc._state_get_func
    if func is None:
        return False

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        return bool(ret)
    else:
        return False

cdef void _py_elm_genlist_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GenlistItem item = <object>data
    cdef object params
    cdef GenlistItemClass itc

    if item is None:
        return

    params = item.params
    itc = params[0]

    func = itc._del_func
    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, params[1])
        except Exception as e:
            traceback.print_exc()
    item._unset_obj()
    Py_DECREF(item)

cdef void _py_elm_genlist_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GenlistItem item = <object>data
    cdef object func = item.params[2]

    if func is not None:
        try:
            o = object_from_instance(obj)
            func(item, o, item.params[1])
        except Exception as e:
            traceback.print_exc()


cdef class GenlistItemClass:
    cdef Elm_Genlist_Item_Class obj
    cdef readonly object _item_style
    cdef readonly object _text_get_func
    cdef readonly object _content_get_func
    cdef readonly object _state_get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self._item_style = "default"
        self._text_get_func = None
        self._content_get_func = None
        self._state_get_func = None
        self._del_func = None

        self.obj.item_style = NULL
        self.obj.func.text_get = _py_elm_genlist_item_text_get
        self.obj.func.content_get = _py_elm_genlist_item_content_get
        self.obj.func.state_get = _py_elm_genlist_item_state_get
        self.obj.func.del_ = _py_elm_genlist_object_item_del

    def __init__(self, item_style=None, text_get_func=None,
                 content_get_func=None, state_get_func=None, del_func=None):
        if item_style:
            self._item_style = item_style

        if text_get_func and not callable(text_get_func):
            raise TypeError("text_get_func is not callable!")
        elif text_get_func:
            self._text_get_func = text_get_func
        else:
            self._text_get_func = self.text_get

        if content_get_func and not callable(content_get_func):
            raise TypeError("content_get_func is not callable!")
        elif content_get_func:
            self._content_get_func = content_get_func
        else:
            self._content_get_func = self.content_get

        if state_get_func and not callable(state_get_func):
            raise TypeError("state_get_func is not callable!")
        elif state_get_func:
            self._state_get_func = state_get_func
        else:
            self._state_get_func = self.state_get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

        self.obj.item_style = _fruni(self._item_style)

    def __str__(self):
        return ("%s(item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Genlist_Item_Class=%#x, "
                "item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                <unsigned long><void *>self,
                PY_REFCOUNT(self),
                <unsigned long>&self.obj,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    property item_style:
        def __get__(self):
            return self._item_style

    def text_get(self, evasObject obj, part, item_data):
        return None

    def content_get(self, evasObject obj, part, item_data):
        return None

    def state_get(self, evasObject obj, part, item_data):
        return False


cdef class GenlistItem(ObjectItem):

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
                self.params[2],
                self.params[1])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)") % \
               (self.__class__.__name__,
                <unsigned long><void*>self,
                PY_REFCOUNT(self),
                <unsigned long>self.item,
                self.params[0].__class__.__name__,
                self.params[2],
                self.params[1])

    def data_get(self):
        return self.params[1]

    property data:
        def __get__(self):
            return self.data_get()

    def next_get(self):
        return _object_item_to_python(elm_genlist_item_next_get(self.item))

    property next:
        def __get__(self):
            return self.next_get()

    def prev_get(self):
        return _object_item_to_python(elm_genlist_item_prev_get(self.item))

    property prev:
        def __get__(self):
            return self.prev_get()

    def selected_set(self, selected):
        elm_genlist_item_selected_set(self.item, bool(selected))

    def selected_get(self):
        return bool(elm_genlist_item_selected_get(self.item))

    property selected:
        def __get__(self):
            return self.selected_get()

        def __set__(self, selected):
            self.selected_set(selected)

    def show(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        elm_genlist_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        elm_genlist_item_bring_in(self.item, scrollto_type)

    def update(self):
        elm_genlist_item_update(self.item)

    #def item_class_update(self, Elm_Genlist_Item_Class itc):
        #elm_genlist_item_item_class_update(self.item, itc)

    #def item_class_get(self):
        #return elm_genlist_item_item_class_get(self.item)

    def index_get(self):
        return elm_genlist_item_index_get(self.item)

    def tooltip_text_set(self, char *text):
        elm_genlist_item_tooltip_text_set(self.item, _cfruni(text))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, self, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_genlist_item_tooltip_content_cb_set(self.item,
                                                _tooltip_item_content_create,
                                                cbdata,
                                                _tooltip_item_data_del_cb)

    def tooltip_unset(self):
        elm_genlist_item_tooltip_unset(self.item)

    def tooltip_style_set(self, style=None):
        if style:
            elm_genlist_item_tooltip_style_set(self.item, _cfruni(style))
        else:
            elm_genlist_item_tooltip_style_set(self.item, NULL)

    def tooltip_style_get(self):
        return _ctouni(elm_genlist_item_tooltip_style_get(self.item))

    def tooltip_window_mode_set(self, disable):
        return bool(elm_genlist_item_tooltip_window_mode_set(self.item, disable))

    def tooltip_window_mode_get(self):
        return bool(elm_genlist_item_tooltip_window_mode_get(self.item))

    def cursor_set(self, cursor):
        elm_genlist_item_cursor_set(self.item, _cfruni(cursor))

    def cursor_get(self):
        return _ctouni(elm_genlist_item_cursor_get(self.item))

    def cursor_unset(self):
        elm_genlist_item_cursor_unset(self.item)

    def cursor_style_set(self, style=None):
        if style:
            elm_genlist_item_cursor_style_set(self.item, _cfruni(style))
        else:
            elm_genlist_item_cursor_style_set(self.item, NULL)

    def cursor_style_get(self):
        return _ctouni(elm_genlist_item_cursor_style_get(self.item))

    def cursor_engine_only_set(self, engine_only):
        elm_genlist_item_cursor_engine_only_set(self.item, bool(engine_only))

    def cursor_engine_only_get(self):
        return elm_genlist_item_cursor_engine_only_get(self.item)

    def parent_get(self):
        return _object_item_to_python(elm_genlist_item_parent_get(self.item))

    property parent:
        def __get__(self):
            return self.parent_get()

    def subitems_clear(self):
        elm_genlist_item_subitems_clear(self.item)

    def expanded_set(self, expanded):
        elm_genlist_item_expanded_set(self.item, bool(expanded))

    def expanded_get(self, ):
        return bool(elm_genlist_item_expanded_get(self.item))

    property expanded:
        def __get__(self):
            return self.expanded_get()

        def __set__(self, expanded):
            self.expanded_set(expanded)

    def expanded_depth_get(self):
        return elm_genlist_item_expanded_depth_get(self.item)

    def all_contents_unset(self):
        cdef Eina_List *lst
        elm_genlist_item_all_contents_unset(self.item, &lst)
        return _object_item_list_to_python(lst)

    def promote(self):
        elm_genlist_item_promote(self.item)

    def demote(self):
        elm_genlist_item_demote(self.item)

    def fields_update(self, parts, itf):
        elm_genlist_item_fields_update(self.item, _cfruni(parts), itf)

    def decorate_mode_set(self, decorate_it_type, decorate_it_set):
        elm_genlist_item_decorate_mode_set(self.item, _cfruni(decorate_it_type), decorate_it_set)

    def decorate_mode_get(self):
        return _ctouni(elm_genlist_item_decorate_mode_get(self.item))

    def type_get(self):
        cdef Elm_Genlist_Item_Type ittype = elm_genlist_item_type_get(self.item)
        return <Elm_Genlist_Item_Type>ittype

    def flip_set(self, flip):
        elm_genlist_item_flip_set(self.item, flip)

    def flip_get(self):
        return bool(elm_genlist_item_flip_get(self.item))

    def select_mode_set(self, mode):
        elm_genlist_item_select_mode_set(self.item, mode)

    def select_mode_get(self):
        return elm_genlist_item_select_mode_get(self.item)


cdef class Genlist(Object):
    def __init__(self, evasObject parent):
        self._set_obj(elm_genlist_add(parent.obj))

    def clear(self):
        elm_genlist_clear(self.obj)

    def multi_select_set(self, multi):
        elm_genlist_multi_select_set(self.obj, bool(multi))

    def multi_select_get(self):
        return bool(elm_genlist_multi_select_get(self.obj))

    def mode_set(self, mode = ELM_LIST_COMPRESS):
        elm_genlist_mode_set(self.obj, mode)

    def mode_get(self):
        return elm_genlist_mode_get(self.obj)

    def bounce_set(self, h_bounce, v_bounce):
        elm_scroller_bounce_set(self.obj, bool(h_bounce), bool(v_bounce))

    def bounce_get(self):
        cdef Eina_Bool h_bounce, v_bounce
        elm_scroller_bounce_get(self.obj, &h_bounce, &v_bounce)
        return (h_bounce, v_bounce)

    def item_append(self,
                    GenlistItemClass item_class not None,
                    item_data,
                    GenlistItem parent_item=None,
                    int flags=ELM_GENLIST_ITEM_NONE,
                    func=None):
        cdef GenlistItem ret = GenlistItem()
        cdef Elm_Object_Item *item, *parent
        cdef Evas_Smart_Cb cb

        parent = _object_item_from_python(parent_item) if parent_item is not None else NULL

        if func is None:
            cb = NULL
        elif callable(func):
            cb = _py_elm_genlist_item_func
        else:
            raise TypeError("func is not None or callable")

        ret.params = (item_class, item_data, func)
        item = elm_genlist_item_append( self.obj,
                                        &item_class.obj,
                                        <void*>ret,
                                        parent,
                                        <Elm_Genlist_Item_Type>flags,
                                        cb,
                                        <void*>ret)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            Py_DECREF(ret)
            return None

    def item_prepend(   self,
                        GenlistItemClass item_class not None,
                        item_data,
                        GenlistItem parent_item=None,
                        int flags=ELM_GENLIST_ITEM_NONE,
                        func=None):
        cdef GenlistItem ret = GenlistItem()
        cdef Elm_Object_Item *item, *parent
        cdef Evas_Smart_Cb cb

        parent = _object_item_from_python(parent_item) if parent_item is not None else NULL

        if func is None:
            cb = NULL
        elif callable(func):
            cb = _py_elm_genlist_item_func
        else:
            raise TypeError("func is not None or callable")

        ret.params = (item_class, item_data, func)
        item = elm_genlist_item_prepend(self.obj,
                                        &item_class.obj,
                                        <void*>ret,
                                        parent,
                                        <Elm_Genlist_Item_Type>flags,
                                        cb,
                                        <void*>ret)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            Py_DECREF(ret)
            return None

    def item_insert_before( self,
                            GenlistItemClass item_class not None,
                            item_data,
                            #API XXX: parent
                            GenlistItem before_item=None,
                            int flags=ELM_GENLIST_ITEM_NONE,
                            func=None
                            #API XXX: *args, **kwargs
                            ):
        cdef GenlistItem ret = GenlistItem()
        cdef Elm_Object_Item *item, *before
        cdef Evas_Smart_Cb cb

        before = _object_item_from_python(before_item)

        if func is None:
            cb = NULL
        elif callable(func):
            cb = _py_elm_genlist_item_func
        else:
            raise TypeError("func is not None or callable")

        ret.params = (item_class, item_data, func)
        item = elm_genlist_item_insert_before(  self.obj,
                                                &item_class.obj,
                                                <void*>ret,
                                                NULL,
                                                before,
                                                <Elm_Genlist_Item_Type>flags, cb,
                                                <void*>ret)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            Py_DECREF(ret)
            return None

    def item_insert_after(  self,
                            GenlistItemClass item_class not None,
                            item_data,
                            #API XXX: parent
                            GenlistItem after_item=None,
                            int flags=ELM_GENLIST_ITEM_NONE,
                            func=None
                            #API XXX: *args, **kwargs
                            ):
        cdef GenlistItem ret = GenlistItem()
        cdef Elm_Object_Item *item, *after
        cdef Evas_Smart_Cb cb

        after = _object_item_from_python(after_item)

        if func is None:
            cb = NULL
        elif callable(func):
            cb = _py_elm_genlist_item_func
        else:
            raise TypeError("func is not None or callable")

        ret.params = (item_class, item_data, func)
        item = elm_genlist_item_insert_after(self.obj, &item_class.obj,
                                             <void*>ret,
                                             NULL,
                                             after,
                                             <Elm_Genlist_Item_Type>flags, cb,
                                             <void*>ret)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            Py_DECREF(ret)
            return None

    #Elm_Object_Item         *elm_genlist_item_sorted_insert(self.obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Eina_Compare_Cb comp, Evas_Smart_Cb func, void *func_data)

    def selected_item_get(self):
        return _object_item_to_python(elm_genlist_selected_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return self.selected_item_get()

    def selected_items_get(self):
        return _object_item_list_to_python(elm_genlist_selected_items_get(self.obj))

    def realized_items_get(self):
        return _object_item_list_to_python(elm_genlist_realized_items_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_genlist_last_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_genlist_last_item_get(self.obj))

    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)

    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    def realized_items_update(self):
        elm_genlist_realized_items_update(self.obj)

    def items_count(self):
        return elm_genlist_items_count(self.obj)

    def homogeneous_set(self, homogeneous):
        elm_genlist_homogeneous_set(self.obj, bool(homogeneous))

    def homogeneous_get(self):
        return bool(elm_genlist_homogeneous_get(self.obj))

    def block_count_set(self, int n):
        elm_genlist_block_count_set(self.obj, n)

    def block_count_get(self):
        return elm_genlist_block_count_get(self.obj)

    def longpress_timeout_set(self, timeout):
        elm_genlist_longpress_timeout_set(self.obj, timeout)

    def longpress_timeout_get(self):
        return elm_genlist_longpress_timeout_get(self.obj)

    def at_xy_item_get(self, int x, int y):
        return _object_item_to_python(elm_genlist_at_xy_item_get(self.obj, x, y, NULL))

    def decorated_item_get(self):
        return _object_item_to_python(elm_genlist_decorated_item_get(self.obj))

    def reorder_mode_set(self, reorder_mode):
        elm_genlist_reorder_mode_set(self.obj, reorder_mode)

    def reorder_mode_get(self):
        return bool(elm_genlist_reorder_mode_get(self.obj))

    def decorate_mode_set(self, decorated):
        elm_genlist_decorate_mode_set(self.obj, decorated)

    def decorate_mode_get(self):
        return bool(elm_genlist_decorate_mode_get(self.obj))

    def tree_effect_enabled_set(self, enabled):
        elm_genlist_tree_effect_enabled_set(self.obj, enabled)

    def tree_effect_enabled_get(self):
        return bool(elm_genlist_tree_effect_enabled_get(self.obj))

    def highlight_mode_set(self, highlight):
        elm_genlist_highlight_mode_set(self.obj, highlight)

    def highlight_mode_get(self):
        return bool(elm_genlist_highlight_mode_get(self.obj))

    def select_mode_set(self, mode):
        elm_genlist_select_mode_set(self.obj, mode)

    def select_mode_get(self):
        return elm_genlist_select_mode_get(self.obj)

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
        self._callback_del_full("unselected",  _cb_object_item_conv, func)

    def callback_expanded_add(self, func, *args, **kwargs):
        self._callback_add_full("expanded", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_expanded_del(self, func):
        self._callback_del_full("expanded",  _cb_object_item_conv, func)

    def callback_contracted_add(self, func, *args, **kwargs):
        self._callback_add_full("contracted", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_contracted_del(self, func):
        self._callback_del_full("contracted",  _cb_object_item_conv, func)

    def callback_expand_request_add(self, func, *args, **kwargs):
        self._callback_add_full("expand,request", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_expand_request_del(self, func):
        self._callback_del_full("expand,request",  _cb_object_item_conv, func)

    def callback_contract_request_add(self, func, *args, **kwargs):
        self._callback_add_full("contract,request", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_contract_request_del(self, func):
        self._callback_del_full("contract,request",  _cb_object_item_conv, func)

    def callback_realized_add(self, func, *args, **kwargs):
        self._callback_add_full("realized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_realized_del(self, func):
        self._callback_del_full("realized",  _cb_object_item_conv, func)

    def callback_unrealized_add(self, func, *args, **kwargs):
        self._callback_add_full("unrealized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unrealized_del(self, func):
        self._callback_del_full("unrealized",  _cb_object_item_conv, func)

    def callback_drag_start_up_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,up", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_up_del(self, func):
        self._callback_del_full("drag,start,up",  _cb_object_item_conv, func)

    def callback_drag_start_down_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,down", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_down_del(self, func):
        self._callback_del_full("drag,start,down",  _cb_object_item_conv, func)

    def callback_drag_start_left_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,left", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_left_del(self, func):
        self._callback_del_full("drag,start,left",  _cb_object_item_conv, func)

    def callback_drag_start_right_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,right", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_right_del(self, func):
        self._callback_del_full("drag,start,right",  _cb_object_item_conv, func)

    def callback_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,stop", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_stop_del(self, func):
        self._callback_del_full("drag,stop",  _cb_object_item_conv, func)

    def callback_drag_add(self, func, *args, **kwargs):
        self._callback_add_full("drag", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_del(self, func):
        self._callback_del_full("drag",  _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add_full("longpressed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)

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

    def callback_edge_top_add(self, func, *args, **kwargs):
        self._callback_add("edge,top", func, *args, **kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top", func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        self._callback_add("edge,bottom", func, *args, **kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom", func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        self._callback_add("edge,left", func, *args, **kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left", func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        self._callback_add("edge,right", func, *args, **kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right", func)

    def callback_multi_swipe_left_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,left", func, *args, **kwargs)

    def callback_multi_swipe_left_del(self, func):
        self._callback_del("multi,swipe,left", func)

    def callback_multi_swipe_right_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,right", func, *args, **kwargs)

    def callback_multi_swipe_right_del(self, func):
        self._callback_del("multi,swipe,right", func)

    def callback_multi_swipe_up_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,up", func, *args, **kwargs)

    def callback_multi_swipe_up_del(self, func):
        self._callback_del("multi,swipe,up", func)

    def callback_multi_swipe_down_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,down", func, *args, **kwargs)

    def callback_multi_swipe_down_del(self, func):
        self._callback_del("multi,swipe,down", func)

    def callback_multi_pinch_out_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,out", func, *args, **kwargs)

    def callback_multi_pinch_out_del(self, func):
        self._callback_del("multi,pinch,out", func)

    def callback_multi_pinch_in_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,in", func, *args, **kwargs)

    def callback_multi_pinch_in_del(self, func):
        self._callback_del("multi,pinch,in", func)

    def callback_swipe_add(self, func, *args, **kwargs):
        self._callback_add("swipe", func, *args, **kwargs)

    def callback_swipe_del(self, func):
        self._callback_del("swipe", func)

    def callback_moved_add(self, func, *args, **kwargs):
        self._callback_add_full("moved", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_del(self, func):
        self._callback_del_full("moved",  _cb_object_item_conv, func)

    def callback_moved_after_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,after", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_after_del(self, func):
        self._callback_del_full("moved,after",  _cb_object_item_conv, func)

    def callback_moved_before_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,before", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_before_del(self, func):
        self._callback_del_full("moved,before",  _cb_object_item_conv, func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)

    def callback_tree_effect_finished_add(self, func, *args, **kwargs):
        self._callback_add("tree,effect,finished", func, *args, **kwargs)

    def callback_tree_effect_finished_del(self, func):
        self._callback_del("tree,effect,finished", func)


_object_mapping_register("elm_genlist", Genlist)
