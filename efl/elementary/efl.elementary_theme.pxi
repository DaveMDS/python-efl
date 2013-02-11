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

cdef class Theme(object):

    cdef Elm_Theme *th

    def __cinit__(self):
        self.th = NULL

    def __init__(self, default=False):
        cdef Elm_Theme *th
        if default:
            th = elm_theme_default_get()
        else:
            th = elm_theme_new()

        if th != NULL:
            self.th = th
        else:
            Py_DECREF(self)

    def __dealloc__(self):
        if self.th != NULL:
            elm_theme_free(self.th)
            self.th = NULL

    def copy(self, Theme thdst):
        elm_theme_copy(self.th, thdst.th)

    property reference:
        def __set__(self, Theme thref):
            elm_theme_ref_set(self.th, thref.th)

        def __get__(self):
            cdef Theme thref = Theme()
            thref.th = elm_theme_ref_get(self.th)
            return thref

    def overlay_add(self, item):
        elm_theme_overlay_add(self.th, _cfruni(item))

    def overlay_del(self, item):
        elm_theme_overlay_del(self.th, _cfruni(item))

    property overlay_list:
        def __get__(self):
            return tuple(_strings_to_python(elm_theme_overlay_list_get(self.th)))

    def extension_add(self, item):
        elm_theme_extension_add(self.th, _cfruni(item))

    def extension_del(self, item):
        elm_theme_extension_del(self.th, _cfruni(item))

    property extension_list:
        def __get__(self):
            return tuple(_strings_to_python(elm_theme_extension_list_get(self.th)))

    property order:
        def __set__(self, theme):
            elm_theme_set(self.th, _cfruni(theme))

        def __get__(self):
            return _ctouni(elm_theme_get(self.th))

    property elements:
        def __get__(self):
            return tuple(_strings_to_python(elm_theme_list_get(self.th)))

    def flush(self):
        elm_theme_flush(self.th)

    def data_get(self, key):
        return _ctouni(elm_theme_data_get(self.th, _cfruni(key)))

def theme_list_item_path_get(f, in_search_path):
    cdef Eina_Bool path = in_search_path
    return _ctouni(elm_theme_list_item_path_get(_cfruni(f), &path))

def theme_full_flush():
    elm_theme_full_flush()

def theme_name_available_list():
    cdef Eina_List *lst = elm_theme_name_available_list_new()
    elements = tuple(_strings_to_python(lst))
    elm_theme_name_available_list_free(lst)
    return elements

# for compatibility
def theme_overlay_add(item):
    elm_theme_overlay_add(NULL, item)

def theme_extension_add(item):
    elm_theme_extension_add(NULL, item)
