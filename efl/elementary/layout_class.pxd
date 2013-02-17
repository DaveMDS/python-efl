# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

from efl.evas cimport Evas_Object, Eina_Bool
from object cimport Object

cdef extern from *:
    ctypedef char * const_char_ptr "const char *"

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const_char_ptr emission, const_char_ptr source)

cdef extern from "Elementary.h":

    # Layout                (api:TODO  cb:DONE  test:DONE  doc:DONE  py3:DONE)
    Eina_Bool                elm_layout_file_set(Evas_Object *obj, const_char_ptr file, const_char_ptr group)
    Eina_Bool                elm_layout_theme_set(Evas_Object *obj, const_char_ptr clas, const_char_ptr group, const_char_ptr style)
    void                     elm_layout_signal_emit(Evas_Object *obj, const_char_ptr emission, const_char_ptr source)
    void                     elm_layout_signal_callback_add(Evas_Object *obj, const_char_ptr emission, const_char_ptr source, Edje_Signal_Cb func, void *data)
    void                    *elm_layout_signal_callback_del(Evas_Object *obj, const_char_ptr emission, const_char_ptr source, Edje_Signal_Cb func)
    Eina_Bool                elm_layout_box_append(Evas_Object *obj, const_char_ptr part, Evas_Object *child)
    Eina_Bool                elm_layout_box_prepend(Evas_Object *obj, const_char_ptr part, Evas_Object *child)
    Eina_Bool                elm_layout_box_insert_before(Evas_Object *obj, const_char_ptr part, Evas_Object *child, Evas_Object *reference)
    Eina_Bool                elm_layout_box_insert_at(Evas_Object *obj, const_char_ptr part, Evas_Object *child, unsigned int pos)
    Evas_Object             *elm_layout_box_remove(Evas_Object *obj, const_char_ptr part, Evas_Object *child)
    Eina_Bool                elm_layout_box_remove_all(Evas_Object *obj, const_char_ptr part, Eina_Bool clear)
    Eina_Bool                elm_layout_table_pack(Evas_Object *obj, const_char_ptr part, Evas_Object *child_obj, unsigned short col, unsigned short row, unsigned short colspan, unsigned short rowspan)
    Evas_Object             *elm_layout_table_unpack(Evas_Object *obj, const_char_ptr part, Evas_Object *child_obj)
    Eina_Bool                elm_layout_table_clear(Evas_Object *obj, const_char_ptr part, Eina_Bool clear)
    Evas_Object             *elm_layout_edje_get(Evas_Object *obj)
    const_char_ptr           elm_layout_data_get(Evas_Object *obj, const_char_ptr key)
    void                     elm_layout_sizing_eval(Evas_Object *obj)
    Eina_Bool                elm_layout_part_cursor_set(Evas_Object *obj, const_char_ptr part_name, const_char_ptr cursor)
    const_char_ptr           elm_layout_part_cursor_get(Evas_Object *obj, const_char_ptr part_name)
    Eina_Bool                elm_layout_part_cursor_unset(Evas_Object *obj, const_char_ptr part_name)
    Eina_Bool                elm_layout_part_cursor_style_set(Evas_Object *obj, const_char_ptr part_name, const_char_ptr style)
    const_char_ptr           elm_layout_part_cursor_style_get(Evas_Object *obj, const_char_ptr part_name)
    Eina_Bool                elm_layout_part_cursor_engine_only_set(Evas_Object *obj, const_char_ptr part_name, Eina_Bool engine_only)
    Eina_Bool                elm_layout_part_cursor_engine_only_get(Evas_Object *obj, const_char_ptr part_name)
    void                     elm_layout_icon_set(Evas_Object *obj, Evas_Object *icon)
    Evas_Object             *elm_layout_icon_get(Evas_Object *obj)
    void                     elm_layout_end_set(Evas_Object *obj, Evas_Object *end)
    Evas_Object             *elm_layout_end_get(Evas_Object *obj)

cdef class LayoutClass(Object):
    pass
