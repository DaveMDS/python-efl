# Copyright (c) 2011 Fabiano Fidêncio
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


cdef class FileselectorEntry(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_fileselector_entry_add(parent.obj))

    def window_title_set(self, title):
        elm_fileselector_entry_window_title_set(self.obj, _cfruni(title))

    def window_title_get(self):
        return _ctouni(elm_fileselector_entry_window_title_get(self.obj))

    property window_title:
        def __get__(self):
            return _ctouni(elm_fileselector_entry_window_title_get(self.obj))

        def __set__(self, title):
            elm_fileselector_entry_window_title_set(self.obj, _cfruni(title))

    def window_size_set(self, width, height):
        elm_fileselector_entry_window_size_set(self.obj, width, height)

    def window_size_get(self):
        cdef Evas_Coord w
        cdef Evas_Coord h
        elm_fileselector_entry_window_size_get(self.obj, &w, &h)
        return (w, h)

    property window_size:
        def __get__(self):
            cdef Evas_Coord w, h
            elm_fileselector_entry_window_size_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_fileselector_entry_window_size_set(self.obj, w, h)

    def path_set(self, path):
        elm_fileselector_entry_path_set(self.obj, _cfruni(path))

    def path_get(self):
        return _ctouni(elm_fileselector_entry_path_get(self.obj))

    property path:
        def __get__(self):
            return _ctouni(elm_fileselector_entry_path_get(self.obj))

        def __set__(self, path):
            elm_fileselector_entry_path_set(self.obj, _cfruni(path))

    def expandable_set(self, expand):
        elm_fileselector_entry_expandable_set(self.obj, expand)

    def expandable_get(self):
        return bool(elm_fileselector_entry_expandable_get(self.obj))

    property expandable:
        def __get__(self):
            return bool(elm_fileselector_entry_expandable_get(self.obj))

        def __set__(self, expand):
            elm_fileselector_entry_expandable_set(self.obj, expand)

    def folder_only_set(self, folder_only):
        elm_fileselector_entry_folder_only_set(self.obj, folder_only)

    def folder_only_get(self):
        return bool(elm_fileselector_entry_folder_only_get(self.obj))

    property folder_only:
        def __get__(self):
            return bool(elm_fileselector_entry_folder_only_get(self.obj))

        def __set__(self, folder_only):
            elm_fileselector_entry_folder_only_set(self.obj, folder_only)

    def is_save_set(self, is_save):
        elm_fileselector_entry_is_save_set(self.obj, is_save)

    def is_save_get(self):
        return bool(elm_fileselector_entry_is_save_get(self.obj))

    property is_save:
        def __get__(self):
            return bool(elm_fileselector_entry_is_save_get(self.obj))

        def __set__(self, is_save):
            elm_fileselector_entry_is_save_set(self.obj, is_save)

    def inwin_mode_set(self, inwin_mode):
        elm_fileselector_entry_inwin_mode_set(self.obj, inwin_mode)

    def inwin_mode_get(self):
        return bool(elm_fileselector_entry_inwin_mode_get(self.obj))

    property inwin_mode:
        def __get__(self):
            return bool(elm_fileselector_entry_inwin_mode_get(self.obj))

        def __set__(self, inwin_mode):
            elm_fileselector_entry_inwin_mode_set(self.obj, inwin_mode)

    def selected_set(self, path):
        elm_fileselector_entry_selected_set(self.obj, _cfruni(path))

    def selected_get(self):
        return _ctouni(elm_fileselector_entry_selected_get(self.obj))

    property selected:
        def __get__(self):
            return _ctouni(elm_fileselector_entry_selected_get(self.obj))

        def __set__(self, path):
            elm_fileselector_entry_selected_set(self.obj, _cfruni(path))

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_activated_add(self, func, *args, **kwargs):
        self._callback_add("activated", func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del("activated", func)

    def callback_press_add(self, func, *args, **kwargs):
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_focused_add(self, func, *args, **kwargs):
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

    def callback_selection_paste_add(self, func, *args, **kwargs):
        self._callback_add("selection,paste", func, *args, **kwargs)

    def callback_selection_paste_del(self, func):
        self._callback_del("selection,paste", func)

    def callback_selection_copy_add(self, func, *args, **kwargs):
        self._callback_add("selection,copy", func, *args, **kwargs)

    def callback_selection_copy_del(self, func):
        self._callback_del("selection,copy", func)

    def callback_selection_cut_add(self, func, *args, **kwargs):
        self._callback_add("selection,cut", func, *args, **kwargs)

    def callback_selection_cut_del(self, func):
        self._callback_del("selection,cut", func)

    def callback_unpressed_add(self, func, *args, **kwargs):
        self._callback_add("unpressed", func, *args, **kwargs)

    def callback_unpressed_del(self, func):
        self._callback_del("unpressed", func)

    def callback_file_chosen_add(self, func, *args, **kwargs):
        self._callback_add_full("file,chosen", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_file_chosen_del(self, func):
        self._callback_del_full("file,chosen", _cb_string_conv, func)


_object_mapping_register("elm_fileselector_entry", FileselectorEntry)
