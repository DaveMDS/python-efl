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
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

cdef class LayoutClass(Object):

    def file_set(self, filename, group):
        return bool(elm_layout_file_set(self.obj, _cfruni(filename), _cfruni(group)))

    property file:
        def __set__(self, value):
            filename, group = value
            # TODO: check return value
            elm_layout_file_set(self.obj, _cfruni(filename), _cfruni(group))

    def theme_set(self, clas, group, style):
        return bool(elm_layout_theme_set(self.obj, _cfruni(clas), _cfruni(group), _cfruni(style)))

    property theme:
        def __set__(self, theme):
            clas, group, style = theme
            # TODO: check return value
            elm_layout_theme_set(self.obj, _cfruni(clas), _cfruni(group), _cfruni(style))

    def signal_emit(self, emission, source):
        elm_layout_signal_emit(self.obj, _cfruni(emission), _cfruni(source))

    #def signal_callback_add(self, emission, source, func, data):
        #elm_layout_signal_callback_add(self.obj, _cfruni(emission), _cfruni(source), Edje_Signal_Cb func, voiddata)

    #def signal_callback_del(self, emission, source, func):
        #elm_layout_signal_callback_del(self.obj, _cfruni(emission), _cfruni(source), Edje_Signal_Cb func)

    def box_append(self, part, evasObject child):
        return bool(elm_layout_box_append(self.obj, _cfruni(part), child.obj))

    def box_prepend(self, part, evasObject child):
        return bool(elm_layout_box_prepend(self.obj, _cfruni(part), child.obj))

    def box_insert_before(self, part, evasObject child, evasObject reference):
        return bool(elm_layout_box_insert_before(self.obj, _cfruni(part), child.obj, reference.obj))

    def box_insert_at(self, part, evasObject child, pos):
        return bool(elm_layout_box_insert_at(self.obj, _cfruni(part), child.obj, pos))

    def box_remove(self, part, evasObject child):
        return object_from_instance(elm_layout_box_remove(self.obj, _cfruni(part), child.obj))

    def box_remove_all(self, part, clear):
        return bool(elm_layout_box_remove_all(self.obj, _cfruni(part), clear))

    def table_pack(self, part, evasObject child_obj, col, row, colspan, rowspan):
        return bool(elm_layout_table_pack(self.obj, _cfruni(part), child_obj.obj, col, row, colspan, rowspan))

    def table_unpack(self, part, evasObject child_obj):
        return object_from_instance(elm_layout_table_unpack(self.obj, _cfruni(part), child_obj.obj))

    def table_clear(self, part, clear):
        return bool(elm_layout_table_clear(self.obj, _cfruni(part), clear))

    def edje_get(self):
        return object_from_instance(elm_layout_edje_get(self.obj))

    property edje:
        def __get__(self):
            return object_from_instance(elm_layout_edje_get(self.obj))

    def data_get(self, key):
        return _ctouni(elm_layout_data_get(self.obj, _cfruni(key)))

    def sizing_eval(self):
        elm_layout_sizing_eval(self.obj)

    def part_cursor_set(self, part_name, cursor):
        return bool(elm_layout_part_cursor_set(self.obj, _cfruni(part_name), _cfruni(cursor)))

    def part_cursor_get(self, part_name):
        return _ctouni(elm_layout_part_cursor_get(self.obj, _cfruni(part_name)))

    def part_cursor_unset(self, part_name):
        return bool(elm_layout_part_cursor_unset(self.obj, _cfruni(part_name)))

    def part_cursor_style_set(self, part_name, style):
        return bool(elm_layout_part_cursor_style_set(self.obj, _cfruni(part_name), _cfruni(style)))

    def part_cursor_style_get(self, part_name):
        return _ctouni(elm_layout_part_cursor_style_get(self.obj, _cfruni(part_name)))

    def part_cursor_engine_only_set(self, part_name, engine_only):
        return bool(elm_layout_part_cursor_engine_only_set(self.obj, _cfruni(part_name), engine_only))

    def part_cursor_engine_only_get(self, part_name):
        return bool(elm_layout_part_cursor_engine_only_get(self.obj, _cfruni(part_name)))

    def icon_set(self, evasObject icon):
        elm_layout_icon_set(self.obj, icon.obj if icon else NULL)

    def icon_get(self):
        return object_from_instance(elm_layout_icon_get(self.obj))

    property icon:
        def __get__(self):
            return object_from_instance(elm_layout_icon_get(self.obj))

        def __set__(self, evasObject icon):
            elm_layout_icon_set(self.obj, icon.obj if icon else NULL)

    def end_set(self, evasObject end):
        elm_layout_end_set(self.obj, end.obj if end else NULL)

    def end_get(self):
        return object_from_instance(elm_layout_end_get(self.obj))

    property end:
        def __get__(self):
            return object_from_instance(elm_layout_end_get(self.obj))

        def __set__(self, evasObject end):
            elm_layout_end_set(self.obj, end.obj if end else NULL)

    def callback_theme_changed_add(self, func, *args, **kwargs):
        self._callback_add("theme,changed", func, *args, **kwargs)

    def callback_theme_changed_del(self, func):
        self._callback_del("theme,changed", func)
