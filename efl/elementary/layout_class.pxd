# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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

from efl.evas cimport Evas_Object, const_Evas_Object, Eina_Bool, Eina_List
from object cimport Object
from libc.string cimport const_char

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const_char *emission, const_char *source)

cdef extern from "Elementary.h":
    Eina_Bool       elm_layout_content_set(Evas_Object *obj, const_char *swallow, Evas_Object *content)
    Evas_Object *   elm_layout_content_get(Evas_Object *obj, const_char *swallow)
    Evas_Object *   elm_layout_content_unset(Evas_Object *obj, const_char *swallow)
    Eina_Bool       elm_layout_text_set(Evas_Object *obj, const_char *part, const_char *text)
    const_char *    elm_layout_text_get(Evas_Object *obj, const_char *part)
    Eina_Bool       elm_layout_file_set(Evas_Object *obj, const_char *file, const_char *group)
    int             elm_layout_freeze(Evas_Object *obj)
    int             elm_layout_thaw(Evas_Object *obj)
    Eina_Bool       elm_layout_theme_set(Evas_Object *obj, const_char *clas, const_char *group, const_char *style)
    void            elm_layout_signal_emit(Evas_Object *obj, const_char *emission, const_char *source)
    void            elm_layout_signal_callback_add(Evas_Object *obj, const_char *emission, const_char *source, Edje_Signal_Cb func, void *data)
    void *          elm_layout_signal_callback_del(Evas_Object *obj, const_char *emission, const_char *source, Edje_Signal_Cb func)
    Eina_Bool       elm_layout_box_append(Evas_Object *obj, const_char *part, Evas_Object *child)
    Eina_Bool       elm_layout_box_prepend(Evas_Object *obj, const_char *part, Evas_Object *child)
    Eina_Bool       elm_layout_box_insert_before(Evas_Object *obj, const_char *part, Evas_Object *child, Evas_Object *reference)
    Eina_Bool       elm_layout_box_insert_at(Evas_Object *obj, const_char *part, Evas_Object *child, unsigned int pos)
    Evas_Object *   elm_layout_box_remove(Evas_Object *obj, const_char *part, Evas_Object *child)
    Eina_Bool       elm_layout_box_remove_all(Evas_Object *obj, const_char *part, Eina_Bool clear)
    Eina_Bool       elm_layout_table_pack(Evas_Object *obj, const_char *part, Evas_Object *child_obj, unsigned short col, unsigned short row, unsigned short colspan, unsigned short rowspan)
    Evas_Object *   elm_layout_table_unpack(Evas_Object *obj, const_char *part, Evas_Object *child_obj)
    Eina_Bool       elm_layout_table_clear(Evas_Object *obj, const_char *part, Eina_Bool clear)
    Evas_Object *   elm_layout_edje_get(Evas_Object *obj)
    const_char *    elm_layout_data_get(Evas_Object *obj, const_char *key)
    void            elm_layout_sizing_eval(Evas_Object *obj)
    Eina_Bool       elm_layout_part_cursor_set(Evas_Object *obj, const_char *part_name, const_char *cursor)
    const_char *    elm_layout_part_cursor_get(Evas_Object *obj, const_char *part_name)
    Eina_Bool       elm_layout_part_cursor_unset(Evas_Object *obj, const_char *part_name)
    Eina_Bool       elm_layout_part_cursor_style_set(Evas_Object *obj, const_char *part_name, const_char *style)
    const_char *    elm_layout_part_cursor_style_get(Evas_Object *obj, const_char *part_name)
    Eina_Bool       elm_layout_part_cursor_engine_only_set(Evas_Object *obj, const_char *part_name, Eina_Bool engine_only)
    Eina_Bool       elm_layout_part_cursor_engine_only_get(Evas_Object *obj, const_char *part_name)
    Eina_Bool       elm_layout_edje_object_can_access_set(Evas_Object *obj, Eina_Bool can_access)
    Eina_Bool       elm_layout_edje_object_can_access_get(Evas_Object *obj)
    Eina_List *     elm_layout_content_swallow_list_get(const_Evas_Object *obj)
    void            elm_layout_icon_set(Evas_Object *obj, Evas_Object *icon)
    Evas_Object *   elm_layout_icon_get(Evas_Object *obj)
    void            elm_layout_end_set(Evas_Object *obj, Evas_Object *end)
    Evas_Object *   elm_layout_end_get(Evas_Object *obj)

cdef class LayoutClass(Object):
    cdef object _elm_layout_signal_cbs
