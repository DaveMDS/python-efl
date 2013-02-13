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


cdef class FileselectorButton(Button):

    def __init__(self, evasObject parent):
        self._set_obj(elm_fileselector_button_add(parent.obj))

    def window_title_set(self, title):
        elm_fileselector_button_window_title_set(self.obj, _cfruni(title))

    def window_title_get(self):
        return _ctouni(elm_fileselector_button_window_title_get(self.obj))

    property window_title:
        def __get__(self):
            return _ctouni(elm_fileselector_button_window_title_get(self.obj))

        def __set__(self, title):
            elm_fileselector_button_window_title_set(self.obj, _cfruni(title))

    def window_size_set(self, width, height):
        elm_fileselector_button_window_size_set(self.obj, width, height)

    def window_size_get(self):
        cdef Evas_Coord w, h
        elm_fileselector_button_window_size_get(self.obj, &w, &h)
        return (w, h)

    property window_size:
        def __get__(self):
            cdef Evas_Coord w, h
            elm_fileselector_button_window_size_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_fileselector_button_window_size_set(self.obj, w, h)

    def path_set(self, path):
        elm_fileselector_button_path_set(self.obj, _cfruni(path))

    def path_get(self):
        return _ctouni(elm_fileselector_button_path_get(self.obj))

    property path:
        def __get__(self):
            return _ctouni(elm_fileselector_button_path_get(self.obj))

        def __set__(self, path):
            elm_fileselector_button_path_set(self.obj, _cfruni(path))

    def expandable_set(self, expand):
        elm_fileselector_button_expandable_set(self.obj, expand)

    def expandable_get(self):
        return bool(elm_fileselector_button_expandable_get(self.obj))

    property expandable:
        def __get__(self):
            return bool(elm_fileselector_button_expandable_get(self.obj))

        def __set__(self, expand):
            elm_fileselector_button_expandable_set(self.obj, expand)

    def folder_only_set(self, folder_only):
        elm_fileselector_button_folder_only_set(self.obj, folder_only)

    def folder_only_get(self):
        return bool(elm_fileselector_button_folder_only_get(self.obj))

    property folder_only:
        def __get__(self):
            return bool(elm_fileselector_button_folder_only_get(self.obj))

        def __set__(self, folder_only):
            elm_fileselector_button_folder_only_set(self.obj, folder_only)

    def is_save_set(self, is_save):
        elm_fileselector_button_is_save_set(self.obj, is_save)

    def is_save_get(self):
        return bool(elm_fileselector_button_is_save_get(self.obj))

    property is_save:
        def __get__(self):
            return bool(elm_fileselector_button_is_save_get(self.obj))

        def __set__(self, is_save):
            elm_fileselector_button_is_save_set(self.obj, is_save)

    def inwin_mode_set(self, inwin_mode):
        elm_fileselector_button_inwin_mode_set(self.obj, inwin_mode)

    def inwin_mode_get(self):
        return bool(elm_fileselector_button_inwin_mode_get(self.obj))

    property inwin_mode:
        def __get__(self):
            return bool(elm_fileselector_button_inwin_mode_get(self.obj))

        def __set__(self, inwin_mode):
            elm_fileselector_button_inwin_mode_set(self.obj, inwin_mode)

    def callback_file_chosen_add(self, func, *args, **kwargs):
        self._callback_add_full("file,chosen", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_file_chosen_del(self, func):
        self._callback_del_full("file,chosen", _cb_string_conv, func)


_object_mapping_register("elm_fileselector_button", FileselectorButton)
