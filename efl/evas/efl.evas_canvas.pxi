# Copyright (C) 2007-2013 Gustavo Sverzut Barbieri, Ulisses Furquim
#
# This file is part of Python-Ecore.
#
# Python-Ecore is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Ecore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Ecore.  If not, see <http://www.gnu.org/licenses/>.

# This file is included verbatim by efl.evas.pyx


# cdef int _canvas_free_wrapper_resources(Canvas canvas) except 0:
#     cdef int i
#     for i from 0 <= i < evas_canvas_event_callbacks_len:
#         canvas._callbacks[i] = None
#     return 1
# 
# 
cdef int _canvas_unregister_callbacks(Canvas canvas) except 0:
    cdef Evas *e
    cdef Evas_Event_Cb cb
    e = canvas.obj
    if e != NULL:
        for i, lst in enumerate(canvas._callbacks):
            if lst is not None:
                cb = evas_canvas_event_callbacks[i]
                evas_event_callback_del(e, i, cb)
    return 1


cdef _canvas_add_callback_to_list(Canvas canvas, int type, func, args, kargs):
    if type < 0 or type >= evas_canvas_event_callbacks_len:
        raise ValueError("Invalid callback type")

    r = (func, args, kargs)
    lst = canvas._callbacks[type]
    if lst is not None:
        lst.append(r)
        return False
    else:
        canvas._callbacks[type] = [r]
        return True


cdef _canvas_del_callback_from_list(Canvas canvas, int type, func):
    if type < 0 or type >= evas_canvas_event_callbacks_len:
        raise ValueError("Invalid callback type")

    lst = canvas._callbacks[type]
    if not lst:
        raise ValueError("Callback %s was not registered with type %d" %
                         (func, type))

    i = None
    for i, r in enumerate(lst):
        if func == r[0]:
            break
    else:
        raise ValueError("Callback %s was not registered with type %d" %
                         (func, type))

    lst.pop(i)
    if len(lst) == 0:
        canvas._callbacks[type] = None
        return True
    else:
        return False


cdef class Canvas(Eo):

    def __cinit__(self, *a, **ka):
        self._callbacks = [None] * evas_canvas_event_callbacks_len

    def __init__(self, method=None, size=None, viewport=None):
        self._set_obj(evas_new())

        if method:
            self.output_method_set(method)
        if size:
            self.size_set(*size)
        if viewport:
            self.viewport_set(*viewport)

    def __dealloc__(self):
        if self.obj != NULL:
            _canvas_unregister_callbacks(self)
        self._callbacks = None

    def __str__(self):
        return ("%s Canvas(size=%s, method=%r)") % (Eo.__repr__(self),
                self.size_get(), self.output_method_get())

    def __repr__(self):
        return ("%s Canvas(size=%s, method=%r)") % (Eo.__repr__(self),
                self.size_get(), self.output_method_get())

    def delete(self):
        evas_free(self.obj)

    def output_method_set(self, method):
        cdef int engine_id

        if isinstance(method, (int, long)):
            engine_id = method
        elif isinstance(method, str):
            engine_id = evas_render_method_lookup(_cfruni(method))
        else:
            raise TypeError("method must be integer or string")

        evas_output_method_set(self.obj, engine_id)

    def output_method_get(self):
        return evas_output_method_get(self.obj)

    property output_method:
        def __set__(self, method):
            self.output_method_set(method)

        def __get__(self):
            return self.output_method_get()

    def engine_info_set(self, unsigned long ptr):
        evas_engine_info_set(self.obj, <void *>ptr)

    def engine_info_get(self):
        return <unsigned long><void *>evas_engine_info_get(self.obj)

    property engine_info:
        def __set__(self, ptr):
            self.engine_info_set(ptr)

        def __get__(self):
            return self.engine_info_get()

    def size_set(self, int w, int h):
        evas_output_size_set(self.obj, w, h)

    def size_get(self):
        cdef int w, h
        evas_output_size_get(self.obj, &w, &h)
        return (w, h)

    property size:
        def __set__(self, spec):
            self.size_set(*spec)

        def __get__(self):
            return self.size_get()

    property rect:
        def __set__(self, spec):
            cdef Rect r
            r = Rect(spec)
            self.size_set(r.w, r.h)

        def __get__(self):
            cdef int w, h
            w, h = self.size_get()
            return Rect(0, 0, w, h)

    def viewport_set(self, int x, int y, int w, int h):
        evas_output_viewport_set(self.obj, x, y, w, h)

    def viewport_get(self):
        cdef int x, y, w, h
        evas_output_viewport_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    property viewport:
        def __set__(self, spec):
            self.viewport_set(*spec)

        def __get__(self):
            return self.viewport_get()

    def coord_screen_x_to_world(self, int x):
        return evas_coord_screen_x_to_world(self.obj, x)

    def coord_screen_y_to_world(self, int y):
        return evas_coord_screen_y_to_world(self.obj, y)

    def coord_world_x_to_screen(self, int x):
        return evas_coord_world_x_to_screen(self.obj, x)

    def coord_world_y_to_screen(self, int y):
        return evas_coord_world_y_to_screen(self.obj, y)

    def pointer_output_xy_get(self):
        cdef int x, y
        evas_pointer_output_xy_get(self.obj, &x, &y)
        return (x, y)

    property pointer_output_xy:
        def __get__(self):
            return self.pointer_output_xy_get()

    def pointer_canvas_xy_get(self):
        cdef int x, y
        evas_pointer_canvas_xy_get(self.obj, &x, &y)
        return (x, y)

    property pointer_canvas_xy:
        def __get__(self):
            return self.pointer_canvas_xy_get()

    def pointer_button_down_mask_get(self):
        return evas_pointer_button_down_mask_get(self.obj)

    property pointer_button_down_mask:
        def __get__(self):
            return self.pointer_button_down_mask_get()

    def pointer_inside_get(self):
        return bool(evas_pointer_inside_get(self.obj))

    property pointer_inside:
        def __get__(self):
            return self.pointer_inside_get()

    def top_at_xy_get(self, int x, int y,
                      include_pass_events_objects=False,
                      include_hidden_objects=False):
        cdef int ip, ih
        cdef Evas_Object *o
        ip = include_pass_events_objects
        ih = include_hidden_objects
        o = evas_object_top_at_xy_get(self.obj, x, y, ip, ih)
        return object_from_instance(o)

    def top_at_pointer_get(self):
        cdef Evas_Object *o
        o = evas_object_top_at_pointer_get(self.obj)
        return object_from_instance(o)

    def top_in_rectangle_get(self, int x, int y, int w, int h,
                             include_pass_events_objects=False,
                             include_hidden_objects=False):
        cdef int ip, ih
        cdef Evas_Object *o
        ip = include_pass_events_objects
        ih = include_hidden_objects
        o = evas_object_top_in_rectangle_get(self.obj, x, y, w, h, ip, ih)
        return object_from_instance(o)

    def objects_at_xy_get(self, int x, int y,
                          include_pass_events_objects=False,
                          include_hidden_objects=False):
        cdef Eina_List *objs, *itr
        cdef int ip, ih
        cdef Evas_Object *o
        ip = include_pass_events_objects
        ih = include_hidden_objects
        objs = evas_objects_at_xy_get(self.obj, x, y, ip, ih)
        lst = []
        itr = objs
        while itr != NULL:
            o = <Evas_Object*>itr.data
            lst.append(object_from_instance(o))
            itr = itr.next
        eina_list_free(objs)
        return lst

    def objects_in_rectangle_get(self, int x, int y, int w, int h,
                                 include_pass_events_objects=False,
                                 include_hidden_objects=False):
        cdef Eina_List *objs, *itr
        cdef int ip, ih
        cdef Evas_Object *o
        ip = include_pass_events_objects
        ih = include_hidden_objects
        objs = evas_objects_in_rectangle_get(self.obj, x, y, w, h, ip, ih)
        lst = []
        itr = objs
        while itr != NULL:
            o = <Evas_Object*>itr.data
            lst.append(object_from_instance(o))
            itr = itr.next
        eina_list_free(objs)
        return lst

    def damage_rectangle_add(self, int x, int y, int w, int h):
        evas_damage_rectangle_add(self.obj, x, y, w, h)

    def obscured_rectangle_add(self, int x, int y, int w, int h):
        evas_obscured_rectangle_add(self.obj, x, y, w, h)

    def obscured_clear(self):
        evas_obscured_clear(self.obj)

    def render_updates(self):
        cdef Eina_List *lst
        lst = evas_render_updates(self.obj)
        evas_render_updates_free(lst)

    def render(self):
        evas_render(self.obj)

    def norender(self):
        evas_norender(self.obj)

    def top_get(self):
        return object_from_instance(evas_object_top_get(self.obj))

    property top:
        def __get__(self):
            return object_from_instance(evas_object_top_get(self.obj))

    def bottom_get(self):
        return object_from_instance(evas_object_bottom_get(self.obj))

    property bottom:
        def __get__(self):
            return object_from_instance(evas_object_bottom_get(self.obj))

    def focus_get(self):
        return object_from_instance(evas_focus_get(self.obj))

    property focus:
        def __get__(self):
            return object_from_instance(evas_focus_get(self.obj))

    def object_name_find(self, name):
        return object_from_instance(evas_object_name_find(self.obj, _cfruni(name)))

    def image_cache_flush(self):
        evas_image_cache_flush(self.obj)

    def image_cache_reload(self):
        evas_image_cache_reload(self.obj)

    def image_cache_set(self, int size):
        evas_image_cache_set(self.obj, size)

    def image_cache_get(self):
        return evas_image_cache_get(self.obj)

    property image_cache:
        def __get__(self):
            return self.image_cache_get()

        def __set__(self, int value):
            self.image_cache_set(value)

    def font_cache_flush(self):
        evas_font_cache_flush(self.obj)

    def font_cache_get(self):
        return evas_font_cache_get(self.obj)

    def font_cache_set(self, int value):
        evas_font_cache_set(self.obj, value)

    property font_cache:
        def __get__(self):
            return self.font_cache_get()

        def __set__(self, int value):
            self.font_cache_set(value)

    def font_path_clear(self):
        evas_font_path_clear(self.obj)

    def font_path_append(self, path):
        evas_font_path_append(self.obj, _cfruni(path))

    def font_path_prepend(self, path):
        evas_font_path_prepend(self.obj, _cfruni(path))

    def font_path_list(self):
        cdef const_Eina_List *itr
        lst = []
        itr = evas_font_path_list(self.obj)
        while itr != NULL:
            lst.append(<char*>itr.data)
            itr = itr.next
        return lst

    def font_available_list(self):
        cdef void *p
        cdef Eina_List *itr, *head
        lst = []
        p = <void*>evas_font_available_list(self.obj) # avoid warning
        head = <Eina_List*>p
        itr = head
        while itr != NULL:
            lst.append(<char*>itr.data)
            itr = itr.next
        evas_font_available_list_free(self.obj, head)
        return lst

    def font_hinting_can_hint(self, int flags):
        return bool(evas_font_hinting_can_hint(self.obj,
                                               <Evas_Font_Hinting_Flags>flags))

    def font_hinting_set(self, int flags):
        evas_font_hinting_set(self.obj, <Evas_Font_Hinting_Flags>flags)

    def font_hinting_get(self):
        return <int>evas_font_hinting_get(self.obj)

    property font_hinting:
        def __get__(self):
            return self.font_hinting_get()

        def __set__(self, int value):
            self.font_hinting_set(value)

    def freeze(self):
        evas_event_freeze(self.obj)

    def thaw(self):
        evas_event_thaw(self.obj)

    def freeze_get(self):
        return evas_event_freeze_get(self.obj)

    def key_modifier_is_set(self, modifier):
        return bool(evas_key_modifier_is_set(evas_key_modifier_get(self.obj),
                                             modifier))

    def event_callback_add(self, Evas_Callback_Type type, func, *args, **kargs):
        cdef Evas_Event_Cb cb

        if not callable(func):
            raise TypeError("func must be callable")

        if _canvas_add_callback_to_list(self, type, func, args, kargs):
            cb = evas_canvas_event_callbacks[<int>type]
            evas_event_callback_add(self.obj, type, cb, <void*>self)

    def event_callback_del(self, Evas_Callback_Type type, func):
        cdef Evas_Event_Cb cb
        if _canvas_del_callback_from_list(self, type, func):
            cb = evas_canvas_event_callbacks[<int>type]
            evas_event_callback_del(self.obj, type, cb)

    def on_canvas_focus_in_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_IN, func, *a, **k)

    def on_canvas_focus_in_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_CANVAS_FOCUS_IN, func)

    def on_canvas_focus_out_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_OUT, func, *a, **k)

    def on_canvas_focus_out_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_CANVAS_FOCUS_OUT, func)

    def on_render_flush_pre_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_PRE, func, *a, **k)

    def on_render_flush_pre_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_RENDER_FLUSH_PRE, func)

    def on_render_flush_post_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_POST, func, *a, **k)

    def on_render_flush_post_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_RENDER_FLUSH_POST, func)

    # Event feeding
#     def feed_mouse_down(self, int b, Evas_Button_Flags flags,
#                         unsigned int timestamp):
#         """ Emit a mouse_down event in the canvas """
#         evas_event_feed_mouse_down(self.obj, b, flags, timestamp, NULL)
# 
#     def feed_mouse_up(self, int b, Evas_Button_Flags flags,
#                       unsigned int timestamp):
#         """ Emit a mouse_up event in the canvas """
#         evas_event_feed_mouse_up(self.obj, b, flags, timestamp, NULL)

    def feed_mouse_cancel(self, unsigned int timestamp):
        evas_event_feed_mouse_cancel(self.obj, timestamp, NULL)

    def feed_mouse_wheel(self, int direction, int z, unsigned int timestamp):
        evas_event_feed_mouse_wheel(self.obj, direction, z, timestamp, NULL)

    def feed_mouse_move(self, int x, int y, unsigned int timestamp):
        evas_event_feed_mouse_move(self.obj, x, y, timestamp, NULL)

    def feed_mouse_in(self, unsigned int timestamp):
        evas_event_feed_mouse_in(self.obj, timestamp, NULL)

    def feed_mouse_out(self, unsigned int timestamp):
        evas_event_feed_mouse_out(self.obj, timestamp, NULL)

#     def feed_multi_down(self, int d, int x, int y,
#                         double rad, double radx, double rady,
#                         double pres, double ang,
#                         double fx, double fy,
#                         Evas_Button_Flags flags,
#                         unsigned int timestamp):
#         """ Emit a multi_down event in the canvas """
#         evas_event_feed_multi_down(self.obj, d, x, y, rad, radx, rady, pres,
#                                    ang, fx, fy, flags, timestamp, NULL)

#     def feed_multi_up(self, int d, int x, int y,
#                       double rad, double radx, double rady,
#                       double pres, double ang,
#                       double fx, double fy,
#                       Evas_Button_Flags flags,
#                       unsigned int timestamp):
#         """ Emit a multi_up event in the canvas """
#         evas_event_feed_multi_up(self.obj, d, x, y, rad, radx, rady, pres,
#                                  ang, fx, fy, flags, timestamp, NULL)

    def feed_multi_move(self, int d, int x, int y,
                        double rad, double radx, double rady,
                        double pres, double ang,
                        double fx, double fy,
                        unsigned int timestamp):
        evas_event_feed_multi_move(self.obj, d, x, y, rad, radx, rady, pres,
                                   ang, fx, fy, timestamp, NULL)

    def feed_key_down(self, char *keyname, char *key, char *string,
                      char *compose, int timestamp):
        evas_event_feed_key_down(self.obj, keyname, key, string,
                                 compose, timestamp, NULL)

    def feed_key_up(self, char *keyname, char *key, char *string,
                    char *compose, int timestamp):
        evas_event_feed_key_up(self.obj, keyname, key, string,
                              compose, timestamp, NULL)

    def feed_hold(self, int hold, unsigned int timestamp):
        evas_event_feed_hold(self.obj, hold, timestamp, NULL)

    # Factory
    def Rectangle(self, **kargs):
        return Rectangle(self, **kargs)

    def Line(self, **kargs):
        return Line(self, **kargs)

    def Image(self, **kargs):
        return Image(self, **kargs)

    def FilledImage(self, **kargs):
        return FilledImage(self, **kargs)

    def Polygon(self, **kargs):
        return Polygon(self, **kargs)

    def Text(self, **kargs):
        return Text(self, **kargs)

    def Textblock(self, **kargs):
        return Textblock(self, **kargs)

    def Box(self, **kargs):
        return Box(self, **kargs)


_object_mapping_register("Evas", Canvas)
