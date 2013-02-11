# Copyright (c) 2008-2009 Simon Busch
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

cdef class Fileselector(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_fileselector_add(parent.obj))

    def is_save_set(self, is_save):
        elm_fileselector_is_save_set(self.obj, is_save)

    def is_save_get(self):
        return elm_fileselector_is_save_get(self.obj)

    property is_save:
        def __get__(self):
            return elm_fileselector_is_save_get(self.obj)

        def __set__(self, is_save):
            elm_fileselector_is_save_set(self.obj, is_save)

    def folder_only_set(self, folder_only):
        elm_fileselector_folder_only_set(self.obj, folder_only)

    def folder_only_get(self):
        return elm_fileselector_folder_only_get(self.obj)

    property folder_only:
        def __get__(self):
            return elm_fileselector_folder_only_get(self.obj)

        def __set__(self, folder_only):
            elm_fileselector_folder_only_set(self.obj, folder_only)

    def buttons_ok_cancel_set(self, buttons):
        elm_fileselector_buttons_ok_cancel_set(self.obj, buttons)

    def buttons_ok_cancel_get(self):
        return elm_fileselector_buttons_ok_cancel_get(self.obj)

    property buttons_ok_cancel:
        def __get__(self):
            return elm_fileselector_buttons_ok_cancel_get(self.obj)

        def __set__(self, buttons):
            elm_fileselector_buttons_ok_cancel_set(self.obj, buttons)

    def expandable_set(self, expand):
        elm_fileselector_expandable_set(self.obj, expand)

    def expandable_get(self):
        return elm_fileselector_expandable_get(self.obj)

    property expandable:
        def __get__(self):
            return elm_fileselector_expandable_get(self.obj)

        def __set__(self, expand):
            elm_fileselector_expandable_set(self.obj, expand)

    def path_set(self, path):
        elm_fileselector_path_set(self.obj, _cfruni(path))

    def path_get(self):
        return _ctouni(elm_fileselector_path_get(self.obj))

    property path:
        def __get__(self):
            return _ctouni(elm_fileselector_path_get(self.obj))

        def __set__(self, path):
            elm_fileselector_path_set(self.obj, _cfruni(path))

    def selected_set(self, path):
        return elm_fileselector_selected_set(self.obj, _cfruni(path))

    def selected_get(self):
        return _ctouni(elm_fileselector_selected_get(self.obj))

    property selected:
        def __get__(self):
            return _ctouni(elm_fileselector_selected_get(self.obj))

        def __set__(self, path):
            #TODO: Check return value for success
            elm_fileselector_selected_set(self.obj, _cfruni(path))

    def mode_set(self, mode):
        elm_fileselector_mode_set(self.obj, mode)

    def mode_get(self):
        return elm_fileselector_mode_get(self.obj)

    property mode:
        def __get__(self):
            return elm_fileselector_mode_get(self.obj)

        def __set__(self, mode):
            elm_fileselector_mode_set(self.obj, mode)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_string_conv, func)

    def callback_directory_open_add(self, func, *args, **kwargs):
        self._callback_add_full("directory,open", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_directory_open_del(self, func):
        self._callback_del_full("directory,open", _cb_string_conv, func)

    def callback_done_add(self, func, *args, **kwargs):
        self._callback_add_full("done", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_done_del(self, func):
        self._callback_del_full("done", _cb_string_conv, func)


_object_mapping_register("elm_fileselector", Fileselector)
