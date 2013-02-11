# Copyright (c) 2008-2009 Simon Busch
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


from efl.evas cimport Object as evasObject
from efl.evas cimport EventKeyDown, EventKeyUp
# from efl.evas cimport evas_object_data_get
from efl.evas cimport evas_object_smart_callback_add
from efl.evas cimport evas_object_smart_callback_del
from efl.evas import EVAS_CALLBACK_KEY_DOWN
from efl.evas import EVAS_CALLBACK_KEY_UP
# from evas cimport eina_list_append

# from evas.c_evas import _extended_object_mapping_register

#API XXX: Callbacks!
cdef void _object_callback(void *data,
                           Evas_Object *o, void *event_info) with gil:
    cdef Object obj
    cdef object event, ei
#     obj = <Object>evas_object_data_get(o, "python-evas")
    obj = object_from_instance(o)
    event = <object>data
    lst = tuple(obj._elmcallbacks[event])
    for event_conv, func, args, kargs in lst:
        try:
            if event_conv is None:
                func(obj, *args, **kargs)
            else:
                ei = event_conv(<long>event_info)
                func(obj, ei, *args, **kargs)
        except Exception, e:
            traceback.print_exc()

cdef Evas_Object *_tooltip_content_create(void *data, Evas_Object *o, Evas_Object *t) with gil:
    cdef Object ret, obj, tooltip

#     obj = <Object>evas_object_data_get(o, "python-evas")
#     tooltip = Object_from_instance(t)
    obj = object_from_instance(o)
    tooltip = object_from_instance(t)
    (func, args, kargs) = <object>data
    ret = func(obj, tooltip, *args, **kargs)
    if not ret:
        return NULL
    return ret.obj

cdef void _tooltip_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    Py_DECREF(<object>data)

cdef Eina_Bool _event_dispatcher(o, src, Evas_Callback_Type t, event_info):
    cdef Object obj = o
    cdef object ret
    for func, args, kargs in obj._elm_event_cbs:
        try:
            ret = func(obj, src, t, event_info, *args, **kargs)
        except Exception, e:
            traceback.print_exc()
        else:
            if ret:
                return True
    return False

#TODO: More event types
cdef Eina_Bool _event_callback(void *data, Evas_Object *o, Evas_Object *src, Evas_Callback_Type t, void *event_info) with gil:
    cdef Object obj = object_from_instance(o)
    cdef Object src_obj = object_from_instance(src)
    cdef Eina_Bool ret = False
    cdef EventKeyDown down_event
    cdef EventKeyUp up_event
    if t == EVAS_CALLBACK_KEY_DOWN:
        down_event = EventKeyDown()
        down_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, down_event)
        down_event._unset_obj()
    elif t == EVAS_CALLBACK_KEY_UP:
        up_event = EventKeyUp()
        up_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, up_event)
        up_event._unset_obj()


cdef void _event_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    pass
#     Py_DECREF(<object>data)

# MOVED TO efl.eo.pyx
# cdef _strings_to_python(const_Eina_List *lst):
#     cdef const_char_ptr s
#     ret = []
#     while lst:
#         s = <const_char_ptr>lst.data
#         if s != NULL:
#             ret.append(_ctouni(s))
#         lst = lst.next
#     return ret
# 
# cdef Eina_List * _strings_from_python(strings):
#     cdef Eina_List *lst = NULL
#     for s in strings:
#         lst = eina_list_append(lst, _cfruni(s))
#     return lst

def _cb_string_conv(long addr):
    cdef const_char_ptr s = <const_char_ptr>addr
    if s == NULL:
        return None
    else:
        return s

# MOVED TO efl.eo.pyx
# cdef _object_list_to_python(const_Eina_List *lst):
#     cdef Evas_Object *o
#     ret = []
#     while lst:
#         o = <Evas_Object *>lst.data
#         obj = Object_from_instance(o)
#         ret.append(obj)
#         lst = lst.next
#     return ret

# cdef class Canvas(evas.c_evas.Canvas):
#     def __init__(self):
#         pass

cdef class Object(evasObject):

    def part_text_set(self, part, text):
        elm_object_part_text_set(self.obj, _cfruni(part) if part is not None else NULL, _cfruni(text))

    def text_set(self, text):
        elm_object_text_set(self.obj, _cfruni(text))

    def part_text_get(self, part):
        return _ctouni(elm_object_part_text_get(self.obj, _cfruni(part) if part is not None else NULL))

    def text_get(self):
        return _ctouni(elm_object_text_get(self.obj))

    property text:
        def __get__(self):
            return self.text_get()

        def __set__(self, value):
            self.text_set(value)

    def part_content_set(self, part, evasObject content):
        elm_object_part_content_set(self.obj, _cfruni(part), content.obj)

    def content_set(self, evasObject obj):
        elm_object_part_content_set(self.obj, NULL, obj.obj)

    def part_content_get(self, part):
        return object_from_instance(elm_object_part_content_get(self.obj, _cfruni(part)))

    def content_get(self):
        return object_from_instance(elm_object_content_get(self.obj))

    def part_content_unset(self, part):
        return object_from_instance(elm_object_part_content_unset(self.obj, _cfruni(part)))

    def content_unset(self):
        return object_from_instance(elm_object_content_unset(self.obj))

    property content:
        def __get__(self):
            return self.content_get()
        def __set__(self, content):
            self.content_set(content)
        def __del__(self):
            self.content_unset()

    def access_info_set(self, txt):
        elm_object_access_info_set(self.obj, _cfruni(txt))

    def name_find(self, name not None, int recurse = 0):
        return object_from_instance(elm_object_name_find(self.obj, _cfruni(name), recurse))

    def style_set(self, style):
        elm_object_style_set(self.obj, _cfruni(style))

    def style_get(self):
        return _ctouni(elm_object_style_get(self.obj))

    property style:
        def __get__(self):
            return self.style_get()
        def __set__(self, value):
            self.style_set(value)

    def disabled_set(self, disabled):
        elm_object_disabled_set(self.obj, disabled)

    def disabled_get(self):
        return bool(elm_object_disabled_get(self.obj))

    property disabled:
        def __get__(self):
            return self.disabled_get()
        def __set__(self, disabled):
            self.disabled_set(disabled)

    def widget_check(self):
        return bool(elm_object_widget_check(self.obj))

    def parent_widget_get(self):
        return object_from_instance(elm_object_parent_widget_get(self.obj))

    property parent_widget:
        def __get__(self):
            return self.parent_widget_get()

    def top_widget_get(self):
        return object_from_instance(elm_object_top_widget_get(self.obj))

    property top_widget:
        def __get__(self):
            return self.top_widget_get()

    def widget_type_get(self):
        return elm_object_widget_type_get(self.obj)

    property widget_type:
        def __get__(self):
            return elm_object_widget_type_get(self.obj)

    def signal_emit(self, emission, source):
        elm_object_signal_emit(self.obj, _cfruni(emission), _cfruni(source))

    #def signal_callback_add(self, emission, source, func, data):
        #elm_object_signal_callback_add(self.obj, emission, source, func, data)

    #def signal_callback_del(self, emission, source, func):
        #elm_object_signal_callback_del(self.obj, emission, source, func)

    # XXX: Clashes badly with evas event_callback_*
    def elm_event_callback_add(self, func, *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")

        if self._elm_event_cbs is None:
            self._elm_event_cbs = []

        if not self._elm_event_cbs:
            elm_object_event_callback_add(self.obj, _event_callback, NULL)

        data = (func, args, kargs)
        self._elm_event_cbs.append(data)

    def elm_event_callback_del(self, func, *args, **kargs):
        data = (func, args, kargs)
        self._elm_event_cbs.remove(data)

        if not self._elm_event_cbs:
            elm_object_event_callback_del(self.obj, _event_callback, NULL)

    # Cursors
    def cursor_set(self, cursor):
        elm_object_cursor_set(self.obj, _cfruni(cursor))

    def cursor_get(self):
        return _ctouni(elm_object_cursor_get(self.obj))

    def cursor_unset(self):
        elm_object_cursor_unset(self.obj)

    property cursor:
        def __get__(self):
            return self.cursor_get()
        def __set__(self, value):
            self.cursor_set(value)
        def __del__(self):
            self.cursor_unset()

    def cursor_style_set(self, style=None):
        elm_object_cursor_style_set(self.obj, _cfruni(style) if style is not None else NULL)

    def cursor_style_get(self):
        return _ctouni(elm_object_cursor_style_get(self.obj))

    property cursor_style:
        def __get__(self):
            return self.cursor_style_get()
        def __set__(self, value):
            self.cursor_style_set(value)

    def cursor_theme_search_enabled_set(self, engine_only):
        elm_object_cursor_theme_search_enabled_set(self.obj, bool(engine_only))

    def cursor_theme_search_enabled_get(self):
        return elm_object_cursor_theme_search_enabled_get(self.obj)

    property cursor_theme_search_enabled:
        def __get__(self):
            return self.cursor_theme_search_enabled_get()
        def __set__(self, value):
            self.cursor_theme_search_enabled_set(value)

    # Focus
    def focus_get(self):
        return bool(elm_object_focus_get(self.obj))

    def focus_set(self, focus):
        elm_object_focus_set(self.obj, focus)

    def focus_allow_set(self, allow):
        elm_object_focus_allow_set(self.obj, allow)

    def focus_allow_get(self):
        return elm_object_focus_allow_get(self.obj)

    property focus_allow:
        def __get__(self):
            return self.focus_allow_get()
        def __set__(self, value):
            self.focus_allow_set(value)

    def focus_custom_chain_set(self, objs):
        elm_object_focus_custom_chain_unset(self.obj)
        cdef Object obj
        for obj in objs:
            elm_object_focus_custom_chain_append(self.obj, obj.obj, NULL)

    def focus_custom_chain_unset(self):
        elm_object_focus_custom_chain_unset(self.obj)

    def focus_custom_chain_get(self):
        return _object_list_to_python(elm_object_focus_custom_chain_get(self.obj))

    property focus_custom_chain:
        def __get__(self):
            return self.focus_custom_chain_get()
        def __set__(self, value):
            self.focus_custom_chain_set(value)
        def __del__(self):
            self.focus_custom_chain_unset()

    def focus_custom_chain_append(self, Object child, Object relative_child=None):
        cdef Evas_Object *rel = NULL
        if relative_child:
            rel = relative_child.obj
        elm_object_focus_custom_chain_append(self.obj, child.obj, rel)

    def focus_custom_chain_prepend(self, Object child, Object relative_child=None):
        cdef Evas_Object *rel = NULL
        if relative_child:
            rel = relative_child.obj
        elm_object_focus_custom_chain_prepend(self.obj, child.obj, rel)

    #def focus_next(self, direction):
        #elm_object_focus_next(self.obj, direction)

    def tree_focus_allow_set(self, focusable):
        elm_object_tree_focus_allow_set(self.obj, focusable)

    def tree_focus_allow_get(self):
        return bool(elm_object_tree_focus_allow_get(self.obj))

    property tree_focus_allow:
        def __get__(self):
            return self.tree_focus_allow_get()
        def __set__(self, value):
            self.tree_focus_allow_set(value)

    # Mirroring
    def mirrored_get(self):
        return bool(elm_object_mirrored_get(self.obj))

    def mirrored_set(self, mirrored):
        elm_object_mirrored_set(self.obj, mirrored)

    property mirrored:
        def __get__(self):
            return self.mirrored_get()
        def __set__(self, value):
            self.mirrored_set(value)

    def mirrored_automatic_get(self):
        return bool(elm_object_mirrored_automatic_get(self.obj))

    def mirrored_automatic_set(self, automatic):
        elm_object_mirrored_automatic_set(self.obj, automatic)

    property mirrored_automatic:
        def __get__(self):
            return self.mirrored_automatic_get()
        def __set__(self, value):
            self.mirrored_automatic_set(value)

    # Scaling
    def scale_set(self, scale):
        elm_object_scale_set(self.obj, scale)

    def scale_get(self):
        return elm_object_scale_get(self.obj)

    property scale:
        def __get__(self):
            return self.scale_get()
        def __set__(self, value):
            self.scale_set(value)

    # Scrollhints
    def scroll_hold_push(self):
        elm_object_scroll_hold_push(self.obj)

    def scroll_hold_pop(self):
        elm_object_scroll_hold_pop(self.obj)

    def scroll_freeze_push(self):
        elm_object_scroll_freeze_push(self.obj)

    def scroll_freeze_pop(self):
        elm_object_scroll_freeze_pop(self.obj)

    def scroll_lock_x_set(self, lock):
        elm_object_scroll_lock_x_set(self.obj, lock)

    def scroll_lock_y_set(self, lock):
        elm_object_scroll_lock_y_set(self.obj, lock)

    def scroll_lock_x_get(self):
        return bool(elm_object_scroll_lock_x_get(self.obj))

    def scroll_lock_y_get(self):
        return bool(elm_object_scroll_lock_y_get(self.obj))

    property scroll_lock_x:
        def __get__(self):
            return self.scroll_lock_x_get()
        def __set__(self, value):
            self.scroll_lock_x_set(value)

    property scroll_lock_y:
        def __get__(self):
            return self.scroll_lock_y_get()
        def __set__(self, value):
            self.scroll_lock_y_set(value)

    # Theme
#     property theme:
#         """A theme to be used for this object and its children.
# 
#         This sets a specific theme that will be used for the given object and any
#         child objects it has. If @p th is NULL then the theme to be used is
#         cleared and the object will inherit its theme from its parent (which
#         ultimately will use the default theme if no specific themes are set).
# 
#         Use special themes with great care as this will annoy users and make
#         configuration difficult. Avoid any custom themes at all if it can be
#         helped.
# 
#         @type: L{Theme}
# 
#         """
#         def __set__(self, Theme th):
#             elm_object_theme_set(self.obj, th.th)
#         def __get__(self):
#             cdef Theme th = Theme()
#             th.th = elm_object_theme_get(self.obj)
#             return th

    # Tooltips
    def tooltip_show(self):
        elm_object_tooltip_show(self.obj)

    def tooltip_hide(self):
        elm_object_tooltip_hide(self.obj)

    def tooltip_text_set(self, text):
        elm_object_tooltip_text_set(self.obj, _cfruni(text))

    def tooltip_domain_translatable_text_set(self, domain, text):
        elm_object_tooltip_domain_translatable_text_set(self.obj, _cfruni(domain), _cfruni(text))

    def tooltip_translatable_text_set(self, text):
        elm_object_tooltip_translatable_text_set(self.obj, _cfruni(text))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_object_tooltip_content_cb_set(self.obj, _tooltip_content_create,
                                          cbdata, _tooltip_data_del_cb)

    def tooltip_unset(self):
        elm_object_tooltip_unset(self.obj)

    def tooltip_style_set(self, style=None):
        elm_object_tooltip_style_set(self.obj, _cfruni(style) if style is not None else NULL)

    def tooltip_style_get(self):
        return _ctouni(elm_object_tooltip_style_get(self.obj))

    property tooltip_style:
        def __get__(self):
            return self.tooltip_style_get()
        def __set__(self, value):
            self.tooltip_style_set(value)

    def tooltip_window_mode_set(self, disable):
        return bool(elm_object_tooltip_window_mode_set(self.obj, disable))

    def tooltip_window_mode_get(self):
        return bool(elm_object_tooltip_window_mode_get(self.obj))

    property tooltip_window_mode:
        def __get__(self):
            return self.tooltip_window_mode_get()
        def __set__(self, value):
            self.tooltip_window_mode_set(value)

    #Translatable text
    def domain_translatable_text_part_set(self, part, domain, text):
        elm_object_domain_translatable_text_part_set(self.obj, _cfruni(part), _cfruni(domain), _cfruni(text))

    def domain_translatable_text_set(self, domain, text):
        elm_object_domain_translatable_text_set(self.obj, _cfruni(domain), _cfruni(text))

    def translatable_text_set(self, text):
        elm_object_translatable_text_set(self.obj, _cfruni(text))

    def translatable_text_part_get(self, part):
        return _ctouni(elm_object_translatable_text_part_get(self.obj, _cfruni(part)))

    def translatable_text_get(self):
        return _ctouni(elm_object_translatable_text_get(self.obj))

    property translatable_text:
        def __get__(self):
            return self.translatable_text_get()
        def __set__(self, value):
            self.translatable_text_set(value)

    # Callbacks
    def _callback_add_full(self, event, event_conv, func, *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")
        if event_conv is not None and not callable(event_conv):
            raise TypeError("event_conv must be None or callable")

        if self._elmcallbacks is None:
            self._elmcallbacks = {}

        e = intern(event)
        lst = self._elmcallbacks.setdefault(e, [])
        if not lst:
            evas_object_smart_callback_add(self.obj, _fruni(event),
                                           _object_callback, <void *>e)
        lst.append((event_conv, func, args, kargs))

    def _callback_del_full(self, event, event_conv, func):
        try:
            lst = self._elmcallbacks[event]
        except KeyError as e:
            raise ValueError("Unknown event %r" % event)

        i = -1
        ec = None
        f = None
        for i, (ec, f, a, k) in enumerate(lst):
            if event_conv == ec and func == f:
                break

        if f != func or ec != event_conv:
            raise ValueError("Callback %s was not registered with event %r" %
                             (func, event))

        lst.pop(i)
        if lst:
            return
        self._elmcallbacks.pop(event)
        evas_object_smart_callback_del(self.obj, _fruni(event), _object_callback)

    def _callback_add(self, event, func, *args, **kargs):
        return self._callback_add_full(event, None, func, *args, **kargs)

    def _callback_del(self, event, func):
        return self._callback_del_full(event, None, func)

    def _get_obj_addr(self):
        return <long>self.obj

