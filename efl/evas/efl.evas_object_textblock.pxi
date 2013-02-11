# Copyright (C) 2007-2008 Gustavo Sverzut Barbieri, Ulisses Furquim
#
# This file is part of Python-Evas.
#
# Python-Evas is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Evas is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Evas.  If not, see <http://www.gnu.org/licenses/>.

# This file is included verbatim by c_evas.pyx


cdef class Textblock(Object):

    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(evas_object_textblock_add(canvas.obj))
        self._set_common_params(**kargs)

    def _set_common_params(self, text_markup=None, style=None, **kargs):
        Object._set_common_params(self, **kargs)

        if style is not None:
            self.style_set(style)
        if text_markup is not None:
            self.text_markup_set(text_markup)

    def style_get(self):
        cdef const_Evas_Textblock_Style *style
        style = evas_object_textblock_style_get(self.obj)
        return _ctouni(evas_textblock_style_get(style))

    def style_set(self, value):
        cdef Evas_Textblock_Style *style = evas_textblock_style_new()
        evas_textblock_style_set(style, _cfruni(value))
        evas_object_textblock_style_set(self.obj, style)
        evas_textblock_style_free(style)

    property style:
        def __get__(self):
            return self.style_get()

        def __set__(self, value):
            self.style_set(value)

    def text_markup_get(self):
        return _ctouni(evas_object_textblock_text_markup_get(self.obj))

    def text_markup_set(self, value):
        evas_object_textblock_text_markup_set(self.obj, _cfruni(value))

    property text_markup:
        def __get__(self):
            return self.text_markup_get()

        def __set__(self, value):
            self.text_markup_set(value)

    def replace_char_get(self):
        return _ctouni(evas_object_textblock_replace_char_get(self.obj))

    def replace_char_set(self, value):
        evas_object_textblock_replace_char_set(self.obj, _cfruni(value))

    property replace_char:
        def __get__(self):
            return self.replace_char_get()

        def __set__(self, value):
            self.replace_char_set(value)

    def line_number_geometry_get(self, int index):
        cdef int cx, cy, cw, ch, r
        r = evas_object_textblock_line_number_geometry_get(self.obj, index, &cx, &cy, &cw, &ch)
        if r == 0:
            return None
        else:
            return (cx, cy, cw, ch)

    def clear(self):
        evas_object_textblock_clear(self.obj)

    def size_formatted_get(self):
        cdef int w, h
        evas_object_textblock_size_formatted_get(self.obj, &w, &h)
        return (w, h)

    property size_formatted:
        def __get__(self):
            return self.size_formatted_get()

    def size_native_get(self):
        cdef int w, h
        evas_object_textblock_size_native_get(self.obj, &w, &h)
        return (w, h)

    property size_native:
        def __get__(self):
            return self.size_native_get()

    def style_insets_get(self):
        cdef int l, r, t, b
        evas_object_textblock_style_insets_get(self.obj, &l, &r, &t, &b)
        return (l, r, t, b)

    property style_insets:
        def __get__(self):
            return self.style_insets_get()


_object_mapping_register("Evas_Object_Textblock", Textblock)

