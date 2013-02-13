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



# cdef int _object_free_wrapper_resources(Object obj) except 0:
#     cdef int i
#     for i from 0 <= i < evas_object_event_callbacks_len:
#         obj._callbacks[i] = None
#     obj.data.clear()
#     return 1


cdef int _object_unregister_callbacks(Object obj) except 0:
    cdef Evas_Object *o
    cdef Evas_Object_Event_Cb cb
    o = obj.obj
    if o != NULL:
        for i, lst in enumerate(obj._callbacks):
            if lst is not None:
                cb = evas_object_event_callbacks[i]
                evas_object_event_callback_del(o, i, cb)

#     evas_object_event_callback_del(o, EVAS_CALLBACK_FREE, obj_free_cb)
    return 1


# cdef void obj_free_cb(void *data, Evas *e,
#                       Evas_Object *obj, void *event_info) with gil:
#     cdef Object self
#     self = <Object>data
# 
#     self.obj = NULL
#     self.evas = <Canvas>None
# 
#     lst = self._callbacks[EVAS_CALLBACK_FREE]
#     if lst is not None:
#         for func, args, kargs in lst:
#             try:
#                 func(self, *args, **kargs)
#             except:
#                 traceback.print_exc()
# 
#     _object_free_wrapper_resources(self)
#     Py_DECREF(self)


# cdef _object_register_decorated_callbacks(obj):
#     if not hasattr(obj, "__evas_event_callbacks__"):
#         return
# 
#     for attr_name, evt in obj.__evas_event_callbacks__:
#         attr_value = getattr(obj, attr_name)
#         obj.event_callback_add(evt, attr_value)


cdef _object_add_callback_to_list(Object obj, int type, func, args, kargs):
    if type < 0 or type >= evas_object_event_callbacks_len:
        raise ValueError("Invalid callback type")

    r = (func, args, kargs)
    lst = obj._callbacks[type]
    if lst is not None:
        lst.append(r)
        return False
    else:
        obj._callbacks[type] = [r]
        return True


cdef _object_del_callback_from_list(Object obj, int type, func):
    if type < 0 or type >= evas_object_event_callbacks_len:
        raise ValueError("Invalid callback type")

    lst = obj._callbacks[type]
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
        obj._callbacks[type] = None
        return True
    else:
        return False


cdef class Object(Eo):

    def __cinit__(self):
        self._callbacks = [None] * evas_object_event_callbacks_len


    def __str__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        name = self.name_get()
        if name:
            name_str = "name=%s, " % name
        else:
            name_str = ""
        clip = bool(self.clip_get() is not None)
        return ("%s(%sgeometry=(%d, %d, %d, %d), color=(%d, %d, %d, %d), "
                "layer=%s, clip=%s, visible=%s)") % \
                (self.__class__.__name__, name_str, x, y, w, h,
                 r, g, b, a, self.layer_get(), clip, self.visible_get())

    def __repr__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        name = self.name_get()
        if name:
            name_str = "name=%s, " % name
        else:
            name_str = ""
        clip = bool(self.clip_get() is not None)
        return ("%s %s(%sgeometry=(%d, %d, %d, %d), color=(%d, %d, %d, %d), "
                "layer=%s, clip=%s, visible=%s)") % (Eo.__str__(self),
                 self.__class__.__name__, name_str, x, y, w, h,
                 r, g, b, a, self.layer_get(), clip, self.visible_get())

#     cdef int _unset_obj(self) except 0:
#         assert self.obj != NULL, "Object must wrap something"
#         _object_unregister_callbacks(self)
#         _object_free_wrapper_resources(self)
#         assert evas_object_data_del(self.obj, _cfruni("python-evas")) == <void*>self, \
#                "Evas_Object has incorrect python-evas data"
#         self.obj = NULL
#         self.evas = <Canvas>None
#         Py_DECREF(self)
#         return 1
# 
#     cdef int _set_obj(self, Evas_Object *obj) except 0:
#         assert self.obj == NULL, "Object must be clean"
#         assert evas_object_data_get(obj, _cfruni("python-evas")) == NULL, \
#                "Evas_Object must not wrapped by something else!"
#         self.obj = obj
#         Py_INCREF(self)
#         evas_object_data_set(obj, _cfruni("python-evas"), <void *>self)
#         evas_object_event_callback_add(obj, EVAS_CALLBACK_FREE, obj_free_cb,
#                                        <void *>self)
#         _object_register_decorated_callbacks(self)
#         self.name_set(self.__class__.__name__)
#         return 1


#     def __dealloc__(self):
#         cdef void *data
#         cdef Evas_Object *obj
#
#         if self.obj != NULL:
#             _object_unregister_callbacks(self)
#         self.data = None
#         self._callbacks = None
#         obj = self.obj
#         if obj == NULL:
#             return
#         self.obj = NULL
#         self.evas = <Canvas>None
# 
#         data = evas_object_data_get(obj, _cfruni("python-evas"))
#         assert data == NULL, "Object must not be wrapped!"
#         evas_object_del(obj)


    def _set_common_params(self, size=None, pos=None, geometry=None,
                           color=None, name=None):
        if size:
            self.size_set(*size)
        if pos:
            self.pos_set(*pos)
        if geometry:
            self.geometry_set(*geometry)
        if color:
            self.color_set(*color_parse(color))
        if name:
            self.name_set(name)

    def delete(self):
        evas_object_del(self.obj)

    def evas_get(self):
        return object_from_instance(evas_object_evas_get(self.obj))

    property evas:
        def __get__(self):
            return object_from_instance(evas_object_evas_get(self.obj))

#     def type_get(self):
#         """type_get()
# 
#         Get the Evas object's type
# 
#         @rtype: string
#         """
#         if self.obj:
#             return _ctouni(evas_object_type_get(self.obj))

#     property type:
#         """Type name, ie: "rectangle".
# 
#         @type: string
# 
#         """
#         def __get__(self):
#             return self.type_get()

    def layer_set(self, int layer):
        evas_object_layer_set(self.obj, layer)

    def layer_get(self):
        return evas_object_layer_get(self.obj)

    property layer:
        def __set__(self, int l):
            evas_object_layer_set(self.obj, l)

        def __get__(self):
            return evas_object_layer_get(self.obj)

    def raise_(self):
        evas_object_raise(self.obj)

    def lower(self):
        evas_object_lower(self.obj)

    def stack_above(self, Object above):
        evas_object_stack_above(self.obj, above.obj)

    def stack_below(self, Object below):
        evas_object_stack_below(self.obj, below.obj)

    def above_get(self):
        cdef Evas_Object *other
        other = evas_object_above_get(self.obj)
        return object_from_instance(other)

    property above:
        def __get__(self):
            return self.above_get()

    def below_get(self):
        cdef Evas_Object *other
        other = evas_object_below_get(self.obj)
        return object_from_instance(other)

    property below:
        def __get__(self):
            return self.below_get()

    def top_get(self):
        return self.evas.top_get()

    property top:
        def __get__(self):
            return self.top_get()

    def bottom_get(self):
        return self.evas.bottom_get()

    property bottom:
        def __get__(self):
            return self.bottom_get()

    def geometry_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    def geometry_set(self, int x, int y, int w, int h):
        evas_object_move(self.obj, x, y)
        evas_object_resize(self.obj, w, h)

    property geometry:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y, w, h = spec
            evas_object_move(self.obj, x, y)
            evas_object_resize(self.obj, w, h)

    def size_get(self):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        return (w, h)

    def size_set(self, int w, int h):
        evas_object_resize(self.obj, w, h)

    property size:
        def __get__(self): # replicated to avoid performance hit
            cdef int w, h
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            return (w, h)

        def __set__(self, spec):
            cdef int w, h
            w, h = spec
            evas_object_resize(self.obj, w, h)

    def resize(self, int w, int h):
        evas_object_resize(self.obj, w, h)

    def pos_get(self):
        cdef int x, y
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        return (x, y)

    def pos_set(self, int x, int y):
        evas_object_move(self.obj, x, y)

    property pos:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y
            evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
            return (x, y)

        def __set__(self, spec):
            cdef int x, y
            x, y = spec
            evas_object_move(self.obj, x, y)

    def top_left_get(self):
        cdef int x, y
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        return (x, y)

    def top_left_set(self, int x, int y):
        evas_object_move(self.obj, x, y)

    property top_left:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y
            evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
            return (x, y)

        def __set__(self, spec):
            cdef int x, y
            x, y = spec
            evas_object_move(self.obj, x, y)

    def top_center_get(self):
        cdef int x, y, w
        evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
        return (x + w/2, y)

    def top_center_set(self, int x, int y):
        cdef int w
        evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
        evas_object_move(self.obj, x - w/2, y)

    property top_center:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w
            evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
            return (x + w/2, y)

        def __set__(self, spec):
            cdef int x, y, w
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
            evas_object_move(self.obj, x - w/2, y)

    def top_right_get(self):
        cdef int x, y, w
        evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
        return (x + w, y)

    def top_right_set(self, int x, int y):
        cdef int w
        evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
        evas_object_move(self.obj, x - w, y)

    property top_right:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w
            evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
            return (x + w, y)

        def __set__(self, spec):
            cdef int x, y, w
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
            evas_object_move(self.obj, x - w, y)

    def left_center_get(self):
        cdef int x, y, h
        evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
        return (x, y + h/2)

    def left_center_set(self, int x, int y):
        cdef int h
        evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
        evas_object_move(self.obj, x, y - h/2)

    property left_center:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, h
            evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
            return (x, y + h/2)

        def __set__(self, spec):
            cdef int x, y, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
            evas_object_move(self.obj, x, y - h/2)

    def right_center_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w, y + h/2)

    def right_center_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w, y - h/2)

    property right_center:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w, y + h/2)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w, y - h/2)

    def bottom_left_get(self):
        cdef int x, y, h
        evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
        return (x, y + h)

    def bottom_left_set(self, int x, int y):
        cdef int h
        evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
        evas_object_move(self.obj, x, y - h)

    property bottom_left:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, h
            evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
            return (x, y + h)

        def __set__(self, spec):
            cdef int x, y, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
            evas_object_move(self.obj, x, y - h)

    def bottom_center_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w/2, y + h)

    def bottom_center_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w/2, y - h)

    property bottom_center:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w/2, y + h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w/2, y - h)

    def bottom_right_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w, y + h)

    def bottom_right_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w, y - h)

    property bottom_right:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w, y + h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w, y - h)

    def center_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w/2, y + h/2)

    def center_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w/2, y - h/2)

    property center:
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w/2, y + h/2)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w/2, y - h/2)

    property rect:
        def __get__(self):
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return Rect(x, y, w, h)

        def __set__(self, spec):
            cdef Rect r
            if isinstance(spec, Rect):
                r = spec
            else:
                r = Rect(spec)
            evas_object_move(self.obj, r.x0, r.y0)
            evas_object_resize(self.obj, r._w, r._h)

    def size_hint_min_get(self):
        cdef int w, h
        evas_object_size_hint_min_get(self.obj, &w, &h)
        return (w, h)

    def size_hint_min_set(self, int w, int h):
        evas_object_size_hint_min_set(self.obj, w, h)

    property size_hint_min:
        def __get__(self):
            return self.size_hint_min_get()

        def __set__(self, spec):
            self.size_hint_min_set(*spec)

    def size_hint_max_get(self):
        cdef int w, h
        evas_object_size_hint_max_get(self.obj, &w, &h)
        return (w, h)

    def size_hint_max_set(self, int w, int h):
        evas_object_size_hint_max_set(self.obj, w, h)

    property size_hint_max:
        def __get__(self):
            return self.size_hint_max_get()

        def __set__(self, spec):
            self.size_hint_max_set(*spec)

    def size_hint_request_get(self):
        cdef int w, h
        evas_object_size_hint_request_get(self.obj, &w, &h)
        return (w, h)

    def size_hint_request_set(self, int w, int h):
        evas_object_size_hint_request_set(self.obj, w, h)

    property size_hint_request:
        def __get__(self):
            return self.size_hint_request_get()

        def __set__(self, spec):
            self.size_hint_request_set(*spec)

    def size_hint_aspect_get(self):
        cdef int w, h
        cdef Evas_Aspect_Control aspect
        evas_object_size_hint_aspect_get(self.obj, &aspect, &w, &h)
        return (<int>aspect, w, h)

    def size_hint_aspect_set(self, int aspect, int w, int h):
        evas_object_size_hint_aspect_set(self.obj, <Evas_Aspect_Control>aspect,
                                         w, h)

    property size_hint_aspect:
        def __get__(self):
            return self.size_hint_aspect_get()

        def __set__(self, spec):
            self.size_hint_aspect_set(*spec)

    def size_hint_align_get(self):
        cdef double x, y
        evas_object_size_hint_align_get(self.obj, &x, &y)
        return (x, y)

    def size_hint_align_set(self, float x, float y):
        evas_object_size_hint_align_set(self.obj, x, y)

    property size_hint_align:
        def __get__(self):
            return self.size_hint_align_get()

        def __set__(self, spec):
            self.size_hint_align_set(*spec)

    def size_hint_weight_get(self):
        cdef double x, y
        evas_object_size_hint_weight_get(self.obj, &x, &y)
        return (x, y)

    def size_hint_weight_set(self, float x, float y):
        evas_object_size_hint_weight_set(self.obj, x, y)

    property size_hint_weight:
        def __get__(self):
            return self.size_hint_weight_get()

        def __set__(self, spec):
            self.size_hint_weight_set(*spec)

    def size_hint_padding_get(self):
        cdef int l, r, t, b
        evas_object_size_hint_padding_get(self.obj, &l, &r, &t, &b)
        return (l, r, t, b)

    def size_hint_padding_set(self, int l, int r, int t, int b):
        evas_object_size_hint_padding_set(self.obj, l, r, t, b)

    property size_hint_padding:
        def __get__(self):
            return self.size_hint_padding_get()

        def __set__(self, spec):
            self.size_hint_padding_set(*spec)

    def move(self, int x, int y):
        evas_object_move(self.obj, x, y)

    def move_relative(self, int dx, int dy):
        cdef int x, y
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        evas_object_move(self.obj, x + dx, y + dy)

    def show(self):
        evas_object_show(self.obj)

    def hide(self):
        evas_object_hide(self.obj)

    def visible_get(self):
        return bool(evas_object_visible_get(self.obj))

    def visible_set(self, spec):
        if spec:
            self.show()
        else:
            self.hide()

    property visible:
        def __get__(self):
            return self.visible_get()

        def __set__(self, spec):
            self.visible_set(spec)

    def static_clip_get(self):
        return bool(evas_object_static_clip_get(self.obj))

    def static_clip_set(self, int value):
        evas_object_static_clip_set(self.obj, value)

    property static_clip:
        def __get__(self):
            return self.static_clip_get()

        def __set__(self, value):
            self.static_clip_set(value)

    def render_op_get(self):
        return evas_object_render_op_get(self.obj)

    def render_op_set(self, int value):
        evas_object_render_op_set(self.obj, <Evas_Render_Op>value)

    property render_op:
        def __get__(self):
            return self.render_op_get()

        def __set__(self, int value):
            self.render_op_set(value)

    def anti_alias_get(self):
        return bool(evas_object_anti_alias_get(self.obj))

    def anti_alias_set(self, int value):
        evas_object_anti_alias_set(self.obj, value)

    property anti_alias:
        def __get__(self):
            return self.anti_alias_get()

        def __set__(self, int value):
            self.anti_alias_set(value)

    def color_set(self, int r, int g, int b, int a):
        evas_object_color_set(self.obj, r, g, b, a)

    def color_get(self):
        cdef int r, g, b, a
        evas_object_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    property color:
        def __get__(self):
            return self.color_get()

        def __set__(self, color):
            self.color_set(*color)

    def clip_get(self):
        return object_from_instance(evas_object_clip_get(self.obj))

    def clip_set(self, value):
        cdef Evas_Object *clip
        cdef Object o
        if value is None:
            evas_object_clip_unset(self.obj)
        elif isinstance(value, Object):
            o = <Object>value
            clip = o.obj
            evas_object_clip_set(self.obj, clip)
        else:
            raise ValueError("clip must be evas.Object or None")

    def clip_unset(self):
        evas_object_clip_unset(self.obj)

    property clip:
        def __get__(self):
            return self.clip_get()

        def __set__(self, value):
            self.clip_set(value)

        def __del__(self):
            self.clip_unset()

    def clipees_get(self):
        cdef const_Eina_List *itr
        cdef Object o
        ret = []
        itr = evas_object_clipees_get(self.obj)
        while itr:
            o = object_from_instance(<Evas_Object*>itr.data)
            ret.append(o)
            itr = itr.next
        return tuple(ret)

    property clipees:
        def __get__(self):
            return self.clipees_get()

    def name_get(self):
        return _ctouni(evas_object_name_get(self.obj))

    def name_set(self, value):
        evas_object_name_set(self.obj, _cfruni(value))

    property name:
        def __get__(self):
            return _ctouni(evas_object_name_get(self.obj))

        def __set__(self, value):
            evas_object_name_set(self.obj, _cfruni(value))

    def focus_get(self):
        return bool(evas_object_focus_get(self.obj))

    def focus_set(self, value):
        evas_object_focus_set(self.obj, value)

    property focus:
        def __get__(self):
            return self.focus_get()

        def __set__(self, int value):
            self.focus_set(value)

    def event_callback_add(self, Evas_Callback_Type type, func, *args, **kargs):
        cdef Evas_Object_Event_Cb cb

        if not callable(func):
            raise TypeError("func must be callable")

        if _object_add_callback_to_list(self, type, func, args, kargs):
            if type != EVAS_CALLBACK_FREE:
                cb = evas_object_event_callbacks[<int>type]
                evas_object_event_callback_add(self.obj, type, cb, <void*>self)

    def event_callback_del(self, Evas_Callback_Type type, func):
        cdef Evas_Object_Event_Cb cb
        if _object_del_callback_from_list(self, type, func):
            if type != EVAS_CALLBACK_FREE:
                cb = evas_object_event_callbacks[<int>type]
                evas_object_event_callback_del(self.obj, type, cb)

    def on_mouse_in_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_IN, func, *a, **k)

    def on_mouse_in_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_IN, func)

    def on_mouse_out_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_OUT, func, *a, **k)

    def on_mouse_out_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_OUT, func)

    def on_mouse_down_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, func, *a, **k)

    def on_mouse_down_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_DOWN, func)

    def on_mouse_up_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_UP, func, *a, **k)

    def on_mouse_up_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_UP, func)

    def on_mouse_move_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, func, *a, **k)

    def on_mouse_move_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_MOVE, func)

    def on_mouse_wheel_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOUSE_WHEEL, func, *a, **k)

    def on_mouse_wheel_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOUSE_WHEEL, func)

    def on_free_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_FREE, func, *a, **k)

    def on_free_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_FREE, func)

    def on_key_down_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_KEY_DOWN, func, *a, **k)

    def on_key_down_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_KEY_DOWN, func)

    def on_key_up_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_KEY_UP, func, *a, **k)

    def on_key_up_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_KEY_UP, func)

    def on_focus_in_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_FOCUS_IN, func, *a, **k)

    def on_focus_in_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_FOCUS_IN, func)

    def on_focus_out_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_FOCUS_OUT, func, *a, **k)

    def on_focus_out_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_FOCUS_OUT, func)

    def on_show_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_SHOW, func, *a, **k)

    def on_show_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_SHOW, func)

    def on_hide_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_HIDE, func, *a, **k)

    def on_hide_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_HIDE, func)

    def on_move_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_MOVE, func, *a, **k)

    def on_move_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_MOVE, func)

    def on_resize_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_RESIZE, func, *a, **k)

    def on_resize_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_RESIZE, func)

    def on_restack_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_RESTACK, func, *a, **k)

    def on_restack_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_RESTACK, func)

    def on_del_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_DEL, func, *a, **k)

    def on_del_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_DEL, func)

    def on_hold_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_HOLD, func, *a, **k)

    def on_hold_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_HOLD, func)

    def on_changed_size_hints_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_CHANGED_SIZE_HINTS, func, *a, **k)

    def on_changed_size_hints_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_CHANGED_SIZE_HINTS, func)

    def pass_events_get(self):
        return bool(evas_object_pass_events_get(self.obj))

    def pass_events_set(self, value):
        evas_object_pass_events_set(self.obj, value)

    property pass_events:
        def __get__(self):
            return self.pass_events_get()

        def __set__(self, int value):
            self.pass_events_set(value)

    def repeat_events_get(self):
        return bool(evas_object_repeat_events_get(self.obj))

    def repeat_events_set(self, value):
        evas_object_repeat_events_set(self.obj, value)

    property repeat_events:
        def __get__(self):
            return self.repeat_events_get()

        def __set__(self, int value):
            self.repeat_events_set(value)

    def propagate_events_get(self):
        return bool(evas_object_propagate_events_get(self.obj))

    def propagate_events_set(self, value):
        evas_object_propagate_events_set(self.obj, value)

    property propagate_events:
        def __get__(self):
            return self.propagate_events_get()

        def __set__(self, int value):
            self.propagate_events_set(value)

    def pointer_mode_get(self):
        return <int>evas_object_pointer_mode_get(self.obj)

    def pointer_mode_set(self, int value):
        evas_object_pointer_mode_set(self.obj, <Evas_Object_Pointer_Mode>value)

    property pointer_mode:
        def __get__(self):
            return self.pointer_mode_get()

        def __set__(self, int value):
            self.pointer_mode_set(value)

    def parent_get(self):
        cdef Evas_Object *obj
        obj = evas_object_smart_parent_get(self.obj)
        return object_from_instance(obj)

    property parent:
        def __get__(self):
            return self.parent_get()

    def map_enabled_set(self, enabled):
        evas_object_map_enable_set(self.obj, bool(enabled))
    
    def map_enabled_get(self):
        return bool(evas_object_map_enable_get(self.obj))

    property map_enabled:
        def __get__(self):
            return bool(evas_object_map_enable_get(self.obj))
        def __set__(self, value):
            evas_object_map_enable_set(self.obj, bool(value))
    
    def map_set(self, Map map):
        evas_object_map_set(self.obj, map.map)

    def map_get(self):
#         TODO dunno how to do this in a sane way
#         #return evas_object_map_get(self.obj)
        return None

    property map:
        def __get__(self):
            return None # TODO
        def __set__(self, Map map):
            evas_object_map_set(self.obj, map.map)
    
