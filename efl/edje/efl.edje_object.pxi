# Copyright (C) 2007-2008 Gustavo Sverzut Barbieri, Ulisses Furquim
#
# This file is part of Python-Edje.
#
# Python-Edje is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Edje is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Edje.  If not, see <http://www.gnu.org/licenses/>.


cdef void text_change_cb(void *data,
                         Evas_Object *obj,
                         const_char_ptr part) with gil:
    cdef Edje self
    self = <Edje>data
    if self._text_change_cb is None:
        return
    func, args, kargs = self._text_change_cb
    try:
        func(self, _ctouni(part), *args, **kargs)
    except Exception, e:
        traceback.print_exc()


cdef void message_handler_cb(void *data,
                             Evas_Object *obj,
                             Edje_Message_Type type,
                             int id, void *msg) with gil:
    cdef Edje self
    self = <Edje>data
    if self._message_handler_cb is None:
        return
    func, args, kargs = self._message_handler_cb
    try:
        func(self, Message_from_type(type, id, msg), *args, **kargs)
    except Exception, e:
        traceback.print_exc()


cdef void signal_cb(void *data, Evas_Object *obj,
                    const_char_ptr emission, const_char_ptr source) with gil:
    cdef Edje self
    self = object_from_instance(obj)
    lst = tuple(<object>data)
    for func, args, kargs in lst:
        try:
            func(self, _ctouni(emission), _ctouni(source), *args, **kargs)
        except Exception, e:
            traceback.print_exc()


class EdjeLoadError(Exception):
    def __init__(self, int code, char *file, char *group):
        if code == EDJE_LOAD_ERROR_NONE:
            msg = "No error"
        elif code == EDJE_LOAD_ERROR_GENERIC:
            msg = "Generic error"
        elif code == EDJE_LOAD_ERROR_DOES_NOT_EXIST:
            msg = "Does not exist"
        elif code == EDJE_LOAD_ERROR_PERMISSION_DENIED:
            msg = "Permission denied"
        elif code == EDJE_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED:
            msg = "Resource allocation failed"
        elif code == EDJE_LOAD_ERROR_CORRUPT_FILE:
            msg = "Corrupt file"
        elif code == EDJE_LOAD_ERROR_UNKNOWN_FORMAT:
            msg = "Unknown format"
        elif code == EDJE_LOAD_ERROR_INCOMPATIBLE_FILE:
            msg = "Incompatible file"
        elif code == EDJE_LOAD_ERROR_UNKNOWN_COLLECTION:
            msg = "Unknown collection"

        self.code = code
        self.file = file
        self.group = group
        Exception.__init__(self, "%s (file=%r, group=%r)" % (msg, file, group))


cdef class Edje(Object):
    def __cinit__(self, *a, **ka):
        self._signal_callbacks = {}

    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(edje_object_add(canvas.obj))
        self._set_common_params(**kargs)

    def __free_wrapper_resources(self, ed):
        self._signal_callbacks.clear()
        self._text_change_cb = None
        self._message_handler_cb = None

    def _set_common_params(self, file=None, group=None, size=None, pos=None,
                           geometry=None, color=None, name=None):
        if file:
            self.file_set(file, group)
        Object._set_common_params(self, size=size, pos=pos, geometry=geometry,
                                  color=color, name=name)
        if not size and not geometry:
            w, h = self.size_min_get()
            self.size_set(w, h)

    def __str__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        file, group = self.file_get()
        name = self.name_get()
        if name:
            name_str = "name=%r, "
        else:
            name_str = ""
        clip = bool(self.clip_get() is not None)
        return ("%s(%sfile=%r, group=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%s, visible=%s)") % \
               (self.__class__.__name__, name_str, file, group, x, y, w, h,
                r, g, b, a, self.layer_get(), clip, self.visible_get())

    def __repr__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        file, group = self.file_get()
        clip = bool(self.clip_get() is not None)
        return ("%s(name=%r, file=%r, group=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%r, visible=%s)") % \
               (self.__class__.__name__, self.name_get(), file, group,
                x, y, w, h, r, g, b, a,
                self.layer_get(), clip, self.visible_get())

    def data_get(self, key):
        return _ctouni(edje_object_data_get(self.obj, _cfruni(key)))

    def file_set(self, file, group):
        if edje_object_file_set(self.obj, _cfruni(file), _cfruni(group)) == 0:
            raise EdjeLoadError(edje_object_load_error_get(self.obj),
                                _cfruni(file), _cfruni(group))

    def file_get(self):
        cdef const_char_ptr file, group
        edje_object_file_get(self.obj, &file, &group)
        return (_ctouni(file), _ctouni(group))

    def load_error_get(self):
        return edje_object_load_error_get(self.obj)

    def play_get(self):
        return bool(edje_object_play_get(self.obj))

    def play_set(self, int value):
        edje_object_play_set(self.obj, value)

    property play:
        def __get__(self):
            return self.play_get()

        def __set__(self, int value):
            self.play_set(value)

    def animation_get(self):
        return bool(edje_object_animation_get(self.obj))

    def animation_set(self, int value):
        edje_object_animation_set(self.obj, value)

    property animation:
        def __get__(self):
            return self.animation_get()

        def __set__(self, int value):
            self.animation_set(value)

    def freeze(self):
        return edje_object_freeze(self.obj)

    def thaw(self):
        return edje_object_thaw(self.obj)

    def color_class_set(self, color_class,
                        int r, int g, int b, int a,
                        int r2, int g2, int b2, int a2,
                        int r3, int g3, int b3, int a3):
        edje_object_color_class_set(self.obj, _cfruni(color_class),
                                    r, g, b, a,
                                    r2, g2, b2, a2,
                                    r3, g3, b3, a3)

    def color_class_get(self, color_class):
        cdef int r, g, b, a
        cdef int r2, g2, b2, a2
        cdef int r3, g3, b3, a3
        edje_object_color_class_get(self.obj, _cfruni(color_class),
                                    &r, &g, &b, &a,
                                    &r2, &g2, &b2, &a2,
                                    &r3, &g3, &b3, &a3)
        return (r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)

    def color_class_del(self, color_class):
        edje_object_color_class_del(self.obj, _cfruni(color_class))

    def text_class_set(self, text_class, font, int size):
        edje_object_text_class_set(self.obj, _cfruni(text_class),
                                   _cfruni(font), size)

    def size_min_get(self):
        cdef int w, h
        edje_object_size_min_get(self.obj, &w, &h)
        return (w, h)

    property size_min:
        def __get__(self):
            return self.size_min_get()

    def size_max_get(self):
        cdef int w, h
        edje_object_size_max_get(self.obj, &w, &h)
        return (w, h)

    property size_max:
        def __get__(self):
            return self.size_max_get()

    def calc_force(self):
        edje_object_calc_force(self.obj)

    def size_min_calc(self):
        cdef int w, h
        edje_object_size_min_calc(self.obj, &w, &h)
        return (w, h)

    def parts_extends_calc(self):
        cdef int x, y, w, h
        edje_object_parts_extends_calc(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    def part_exists(self, part):
        return bool(edje_object_part_exists(self.obj, _cfruni(part)))

    def part_object_get(self, part):
        return object_from_instance(edje_object_part_object_get(self.obj,
                                                                _cfruni(part)))

    def part_geometry_get(self, part):
        cdef int x, y, w, h
        edje_object_part_geometry_get(self.obj, _cfruni(part), &x, &y, &w, &h)
        return (x, y, w, h)

    def part_size_get(self, part):
        cdef int w, h
        edje_object_part_geometry_get(self.obj, _cfruni(part), NULL, NULL, &w, &h)
        return (w, h)

    def part_pos_get(self, part):
        cdef int x, y
        edje_object_part_geometry_get(self.obj, _cfruni(part), &x, &y, NULL, NULL)
        return (x, y)

    def text_change_cb_set(self, func, *args, **kargs):
        if func is None:
            self._text_change_cb = None
            edje_object_text_change_cb_set(self.obj, NULL, NULL)
        elif callable(func):
            self._text_change_cb = (func, args, kargs)
            edje_object_text_change_cb_set(self.obj, text_change_cb, <void*>self)
        else:
            raise TypeError("func must be callable or None")

    def part_text_set(self, part, text):
        edje_object_part_text_set(self.obj, _cfruni(part), _cfruni(text))

    def part_text_get(self, part):
        cdef const_char_ptr s
        return _ctouni(edje_object_part_text_get(self.obj, _cfruni(part)))
        

    def part_text_select_all(self, part):
        edje_object_part_text_select_all(self.obj, _cfruni(part))

    def part_text_select_none(self, part):
        edje_object_part_text_select_none(self.obj, _cfruni(part))

    def part_text_unescaped_set(self, part, text_to_escape):
        edje_object_part_text_unescaped_set(self.obj, _cfruni(part),
                                            _cfruni(text_to_escape))

    def part_text_unescaped_get(self, part):
        cdef char *s
        s = edje_object_part_text_unescaped_get(self.obj, _cfruni(part))
        if s == NULL:
            return None
        else:
            str = _touni(s)
            libc.stdlib.free(s)
            return str

    def part_swallow(self, part, Object obj):
        edje_object_part_swallow(self.obj, _cfruni(part), obj.obj)

    def part_unswallow(self, Object obj):
        edje_object_part_unswallow(self.obj, obj.obj)

    def part_swallow_get(self, part):
        return object_from_instance(edje_object_part_swallow_get(self.obj,
                                                                 _cfruni(part)))

    def part_external_object_get(self, part):
        return object_from_instance(edje_object_part_external_object_get(self.obj,
                                                                _cfruni(part)))

    def part_external_param_set(self, char *part, char *param, value):
        cdef Edje_External_Param p
        cdef Edje_External_Param_Type t

        p.name = param
        if isinstance(value, bool): # bool is int, so keep it before!
            p.type = EDJE_EXTERNAL_PARAM_TYPE_BOOL
            p.i = value
        elif isinstance(value, int):
            p.type = EDJE_EXTERNAL_PARAM_TYPE_INT
            p.i = value
        elif isinstance(value, float):
            p.type = EDJE_EXTERNAL_PARAM_TYPE_DOUBLE
            p.d = value
        elif isinstance(value, (str, unicode)):
            # may be STRING or CHOICE
            p.type = edje_object_part_external_param_type_get(
                self.obj, part, param)

            if isinstance(value, unicode):
                value = value.encode("utf-8")
            p.s = value
        else:
            raise TypeError("unsupported type %s" % type(value).__name__)
        return bool(edje_object_part_external_param_set(self.obj, part, &p))

    def part_external_param_get(self, char *part, char *param):
        cdef Edje_External_Param p
        cdef Edje_External_Param_Type t

        t = edje_object_part_external_param_type_get(self.obj, part, param)
        if t == EDJE_EXTERNAL_PARAM_TYPE_MAX:
            return None

        p.name = param
        p.type = t
        if not edje_object_part_external_param_get(self.obj, part, &p):
            return None
        if t == EDJE_EXTERNAL_PARAM_TYPE_BOOL:
            return bool(p.i)
        elif t == EDJE_EXTERNAL_PARAM_TYPE_INT:
            return p.i
        elif t == EDJE_EXTERNAL_PARAM_TYPE_DOUBLE:
            return p.d
        elif t == EDJE_EXTERNAL_PARAM_TYPE_STRING:
            if p.s == NULL:
                return ""
            return p.s
        elif t == EDJE_EXTERNAL_PARAM_TYPE_CHOICE:
            if p.s == NULL:
                return ""
            return p.s

    def part_box_append(self, part, Object obj):
        return bool(edje_object_part_box_append(self.obj, _cfruni(part), obj.obj))

    def part_box_prepend(self, part, Object obj):
        return bool(edje_object_part_box_prepend(self.obj, _cfruni(part), obj.obj))

    def part_box_insert_at(self, part, Object obj,
                           unsigned int pos):
        return bool(edje_object_part_box_insert_at(self.obj, _cfruni(part),
                                                   obj.obj, pos))

    def part_box_insert_before(self, part, Object obj, Object reference):
        return bool(edje_object_part_box_insert_before(self.obj, _cfruni(part),
                                                    obj.obj, reference.obj))

    def part_box_remove(self, part, Object obj):
        return object_from_instance(edje_object_part_box_remove(self.obj,
                                                        _cfruni(part), obj.obj))

    def part_box_remove_at(self, part, unsigned int pos):
        return object_from_instance(edje_object_part_box_remove_at(self.obj,
                                                            _cfruni(part), pos))

    def part_box_remove_all(self, part, int clear):
        return bool(edje_object_part_box_remove_all(self.obj,
                                                    _cfruni(part), clear))

    def part_table_pack(self, part, Object child, short col, short row, short colspan, short rowspan):
        return bool(edje_object_part_table_pack(self.obj, _cfruni(part),
                                        child.obj, col, row, colspan, rowspan))

    def part_table_unpack(self, part, Object child):
        return bool(edje_object_part_table_unpack(self.obj, _cfruni(part),
                                                  child.obj))

    def part_table_col_row_size_get(self, part):
        cdef int c, r
        edje_object_part_table_col_row_size_get(self.obj, _cfruni(part), &c, &r)
        return (c, r)

    def part_table_clear(self, part, int clear):
        return bool(edje_object_part_table_clear(self.obj, _cfruni(part), clear))

    def part_table_child_get(self, part, int row, int column):
        return object_from_instance(edje_object_part_table_child_get(self.obj,
                                                    _cfruni(part), row, column))

    def part_state_get(self, part):
        cdef double sv
        cdef const_char_ptr sn
        sn = edje_object_part_state_get(self.obj, _cfruni(part), &sv)
        return (_ctouni(sn), sv)

    def part_drag_dir_get(self, part):
        return edje_object_part_drag_dir_get(self.obj, _cfruni(part))

    def part_drag_value_set(self, part, double dx, double dy):
        edje_object_part_drag_value_set(self.obj, _cfruni(part), dx, dy)

    def part_drag_value_get(self, part):
        cdef double dx, dy
        edje_object_part_drag_value_get(self.obj, _cfruni(part), &dx, &dy)
        return (dx, dy)

    def part_drag_size_set(self, part, double dw, double dh):
        edje_object_part_drag_size_set(self.obj, _cfruni(part), dw, dh)

    def part_drag_size_get(self, part):
        cdef double dw, dh
        edje_object_part_drag_size_get(self.obj, _cfruni(part), &dw, &dh)
        return (dw, dh)

    def part_drag_step_set(self, part, double dx, double dy):
        edje_object_part_drag_step_set(self.obj, _cfruni(part), dx, dy)

    def part_drag_step_get(self, part):
        cdef double dx, dy
        edje_object_part_drag_step_get(self.obj, _cfruni(part), &dx, &dy)
        return (dx, dy)

    def part_drag_step(self, part, double dx, double dy):
        edje_object_part_drag_step(self.obj, _cfruni(part), dx, dy)

    def part_drag_page_set(self, part, double dx, double dy):
        edje_object_part_drag_page_set(self.obj, _cfruni(part), dx, dy)

    def part_drag_page_get(self, part):
        cdef double dx, dy
        edje_object_part_drag_page_get(self.obj, _cfruni(part), &dx, &dy)
        return (dx, dy)

    def part_drag_page(self, part, double dx, double dy):
        edje_object_part_drag_page(self.obj, _cfruni(part), dx, dy)

    cdef void message_send_int(self, int id, int data):
        cdef Edje_Message_Int m
        m.val = data
        edje_object_message_send(self.obj, EDJE_MESSAGE_INT, id, <void*>&m)

    cdef void message_send_float(self, int id, float data):
        cdef Edje_Message_Float m
        m.val = data
        edje_object_message_send(self.obj, EDJE_MESSAGE_FLOAT, id, <void*>&m)

    cdef void message_send_str(self, int id, data):
        cdef Edje_Message_String m
        m.str = _fruni(data)
        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING, id, <void*>&m)

    cdef void message_send_str_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_String_Set *m

        count = len(data)
        m = <Edje_Message_String_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Set) + (count - 1) * sizeof(char *))

        m.count = count
        i = 0
        for s in data:
            m.str[i] = s
            i = i + 1

        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_str_int(self, int id, s, int i):
        cdef Edje_Message_String_Int m
        m.str = _fruni(s)
        m.val = i
        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING_INT, id,
                                 <void*>&m)

    cdef void message_send_str_float(self, int id, s, float f):
        cdef Edje_Message_String_Float m
        m.str = _fruni(s)
        m.val = f
        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING_FLOAT, id,
                                 <void*>&m)

    cdef void message_send_str_int_set(self, int id, s, data):
        cdef int count, i
        cdef Edje_Message_String_Int_Set *m

        count = len(data)
        m = <Edje_Message_String_Int_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Int_Set) + (count - 1) * sizeof(int))

        m.str = _fruni(s)
        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i = i + 1

        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING_INT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_str_float_set(self, int id, s, data):
        cdef int count, i
        cdef Edje_Message_String_Float_Set *m

        count = len(data)
        m = <Edje_Message_String_Float_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Float_Set) +
            (count - 1) * sizeof(double))

        m.str = _fruni(s)
        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i = i + 1

        edje_object_message_send(self.obj, EDJE_MESSAGE_STRING_FLOAT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_int_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_Int_Set *m

        count = len(data)
        m = <Edje_Message_Int_Set*>PyMem_Malloc(
            sizeof(Edje_Message_Int_Set) + (count - 1) * sizeof(int))

        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i = i + 1

        edje_object_message_send(self.obj, EDJE_MESSAGE_INT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_float_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_Float_Set *m

        count = len(data)
        m = <Edje_Message_Float_Set*>PyMem_Malloc(
            sizeof(Edje_Message_Float_Set) + (count - 1) * sizeof(double))

        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i = i + 1

        edje_object_message_send(self.obj, EDJE_MESSAGE_FLOAT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef message_send_set(self, int id, data):
        second_item = data[1]
        item_type = type(second_item)
        for e in data[2:]:
            if type(e) != item_type:
                raise TypeError("every element of data should be the "
                                "same type '%s'" % item_type.__name__)
        head = data[0]
        if isinstance(head, (int, long)):
            self.message_send_int_set(id, data)
        elif isinstance(head, float):
            self.message_send_float_set(id, data)
        elif isinstance(head, str):
            if issubclass(item_type, str):
                self.message_send_str_set(id, data)
            elif item_type == int or item_type == long:
                if len(data) == 2:
                    self.message_send_str_int(id, head, second_item)
                else:
                    self.message_send_str_int_set(id, head, data[2:])
            elif item_type == float:
                if len(data) == 2:
                    self.message_send_str_float(id, head, second_item)
                else:
                    self.message_send_str_float_set(id, head, data[2:])

    def message_send(self, int id, data):
        if isinstance(data, (long, int)):
            self.message_send_int(id, data)
        elif isinstance(data, float):
            self.message_send_float(id, data)
        elif isinstance(data, str):
            self.message_send_str(id, data)
        elif isinstance(data, (tuple, list)):
            if len(data) < 1:
                return
            if len(data) < 2:
                self.message_send(id, data[0])
                return

            if not isinstance(data[0], (long, int, float, str)):
                raise TypeError("invalid message list type '%s'" %
                                type(data[0]).__name__)

            self.message_send_set(id, data)
        else:
            raise TypeError("invalid message type '%s'" % type(data).__name__)

    def message_handler_set(self, func, *args, **kargs):
        if func is None:
            self._message_handler_cb = None
            edje_object_message_handler_set(self.obj, NULL, NULL)
        elif callable(func):
            self._message_handler_cb = (func, args, kargs)
            edje_object_message_handler_set(self.obj, message_handler_cb,
                                           <void*>self)
        else:
            raise TypeError("func must be callable or None")

    def message_signal_process(self):
        edje_object_message_signal_process(self.obj)

    def signal_callback_add(self, emission, source, func,
                            *args, **kargs):
        if not callable(func):
            raise TypeError("func must be callable")

        d = self._signal_callbacks.setdefault(emission, {})
        lst = d.setdefault(source, [])
        if not lst:
            edje_object_signal_callback_add(self.obj, _cfruni(emission),
                                         _cfruni(source), signal_cb, <void*>lst)
        lst.append((func, args, kargs))

    def signal_callback_del(self, emission, source, func):
        try:
            d = self._signal_callbacks[emission]
            lst = d[source]
        except KeyError:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        i = -1
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break
        else:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        lst.pop(i)
        if lst:
            return
        d.pop(source)
        if not d:
            self._signal_callbacks.pop(emission)
        edje_object_signal_callback_del(self.obj, _cfruni(emission),
                                        _cfruni(source), signal_cb)

    def signal_emit(self, emission, source):
        edje_object_signal_emit(self.obj, _cfruni(emission), _cfruni(source))


_object_mapping_register("edje", Edje)
