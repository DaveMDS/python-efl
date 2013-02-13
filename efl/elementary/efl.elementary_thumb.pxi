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


cdef class Thumb(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_thumb_add(parent.obj))

    def reload(self):
        elm_thumb_reload(self.obj)

    property file:
        def __set__(self, value):
            if isinstance(value, tuple) or isinstance(value, list):
                file, key = value
            else:
                file = value
                key = None
            elm_thumb_file_set( self.obj,
                                _cfruni(file) if file is not None else NULL,
                                _cfruni(key) if key is not None else NULL)
        def __get__(self):
            cdef const_char_ptr file, key
            elm_thumb_file_get(self.obj, &file, &key)
            return(_ctouni(file), _ctouni(key))

    property path:
        def __get__(self):
            cdef const_char_ptr path, key
            elm_thumb_path_get(self.obj, &path, &key)
            return(_ctouni(path), _ctouni(key))

    property animate:
        def __set__(self, s):
            elm_thumb_animate_set(self.obj, s)
        def __get__(self):
            return elm_thumb_animate_get(self.obj)

    def ethumb_client_get(self):
        return None
        #return elm_thumb_ethumb_client_get(void)

    def ethumb_client_connected_get(self):
        return bool(elm_thumb_ethumb_client_connected_get())

    property editable:
        def __set__(self, edit):
            elm_thumb_editable_set(self.obj, edit)
        def __get__(self):
            return bool(elm_thumb_editable_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_press_add(self, func, *args, **kwargs):
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_generate_start_add(self, func, *args, **kwargs):
        self._callback_add("generate,start", func, *args, **kwargs)

    def callback_generate_start_del(self, func):
        self._callback_del("generate,start", func)

    def callback_generate_stop_add(self, func, *args, **kwargs):
        self._callback_add("generate,stop", func, *args, **kwargs)

    def callback_generate_stop_del(self, func):
        self._callback_del("generate,stop", func)

    def callback_generate_error_add(self, func, *args, **kwargs):
        self._callback_add("generate,error", func, *args, **kwargs)

    def callback_generate_error_del(self, func):
        self._callback_del("generate,error", func)

    def callback_load_error_add(self, func, *args, **kwargs):
        self._callback_add("load,error", func, *args, **kwargs)

    def callback_load_error_del(self, func):
        self._callback_del("load,error", func)


_object_mapping_register("elm_thumb", Thumb)
