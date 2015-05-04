# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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

"""

:mod:`efl.edje` Module
######################

Classes
=======

.. toctree::

   class-edje.rst


"""

from cpython cimport PyMem_Malloc, PyMem_Free, PyUnicode_AsUTF8String
cimport libc.stdlib
from libc.stdint cimport uintptr_t

from efl.eina cimport eina_list_free, eina_stringshare_del, Eina_Stringshare
from efl.eo cimport _object_mapping_register, object_from_instance, \
    _register_decorated_callbacks

from efl.utils.conversions cimport _ctouni, _touni, \
    eina_list_strings_to_python_list

import traceback
import warnings
import atexit


def init():
    cdef int r = edje_init()

    if edje_external_type_abi_version_get() != EDJE_EXTERNAL_TYPE_ABI_VERSION:
        raise TypeError("python-edje Edje_External_Type abi_version differs "
                        "from libedje.so. Recompile python-edje!")
    return r


def shutdown():
    return edje_shutdown()


def frametime_set(double t):
    edje_frametime_set(t)


def frametime_get():
    return edje_frametime_get()


def freeze():
    edje_freeze()


def thaw():
    edje_thaw()


def fontset_append_set(fonts):
    if isinstance(fonts, unicode): fonts = PyUnicode_AsUTF8String(fonts)
    edje_fontset_append_set(<const char *>fonts if fonts is not None else NULL)


def fontset_append_get():
    return _ctouni(edje_fontset_append_get())


def file_collection_list(file):
    cdef Eina_List *lst
    if isinstance(file, unicode): file = PyUnicode_AsUTF8String(file)
    lst = edje_file_collection_list(
                <const char *>file if file is not None else NULL)
    ret = eina_list_strings_to_python_list(lst)
    edje_file_collection_list_free(lst)
    return ret


def file_group_exists(file, group):
    if isinstance(file, unicode): file = PyUnicode_AsUTF8String(file)
    if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
    return bool(edje_file_group_exists(
            <const char *>file if file is not None else NULL,
            <const char *>group if group is not None else NULL))


def file_data_get(file, key):
    cdef char *s
    if isinstance(file, unicode): file = PyUnicode_AsUTF8String(file)
    if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
    s = edje_file_data_get(
                <const char *>file if file is not None else NULL,
                <const char *>key if key is not None else NULL)
    ret = _touni(s)
    libc.stdlib.free(s)
    return ret


def file_cache_set(int count):
    edje_file_cache_set(count)


def file_cache_get():
    return edje_file_cache_get()


def file_cache_flush():
    edje_file_cache_flush()


def collection_cache_set(int count):
    edje_collection_cache_set(count)


def collection_cache_get():
    return edje_collection_cache_get()


def collection_cache_flush():
    edje_collection_cache_flush()

def scale_set(double scale):
    edje_scale_set(scale)

def scale_get():
    return edje_scale_get()

def password_show_last_set(int show_last):
    edje_password_show_last_set(show_last)

def password_show_last_timeout_set(double timeout):
    edje_password_show_last_timeout_set(timeout)

def color_class_set(color_class,
                    int r, int g, int b, int a,
                    int r2, int g2, int b2, int a2,
                    int r3, int g3, int b3, int a3):
    if isinstance(color_class, unicode):
        color_class = PyUnicode_AsUTF8String(color_class)
    edje_color_class_set(
            <const char *>color_class if color_class is not None else NULL,
            r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)


def color_class_get(color_class):
    cdef int r, g, b, a
    cdef int r2, g2, b2, a2
    cdef int r3, g3, b3, a3
    if isinstance(color_class, unicode):
        color_class = PyUnicode_AsUTF8String(color_class)
    edje_color_class_get(
            <const char *>color_class if color_class is not None else NULL,
            &r, &g, &b, &a, &r2, &g2, &b2, &a2, &r3, &g3, &b3, &a3)
    return (r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)


def color_class_del(color_class):
    if isinstance(color_class, unicode):
        color_class = PyUnicode_AsUTF8String(color_class)
    edje_color_class_del(
        <const char *>color_class if color_class is not None else NULL)


def color_class_list():
    cdef:
        Eina_List *lst
        Eina_List *itr
    ret = []
    lst = edje_color_class_list()
    itr = lst
    while itr:
        ret.append(_touni(<char*>itr.data))
        libc.stdlib.free(itr.data)
        itr = itr.next
    eina_list_free(lst)
    return ret


def text_class_set(text_class, font, int size):
    if isinstance(text_class, unicode):
        text_class = PyUnicode_AsUTF8String(text_class)
    if isinstance(font, unicode):
        font = PyUnicode_AsUTF8String(font)
    edje_text_class_set(
        <const char *>text_class if text_class is not None else NULL,
        <const char *>font if font is not None else NULL,
        size)


def text_class_get(text_class):
    """ Get the font and the font size from Edje text class.

    This function gets the font and the font name from the specified Edje
    text class.

    :param string text_class: The text class name to query

    :return: The font name and the font size
    :rtype: (font_name, font_size)

    .. versionadded:: 1.14

    """
    cdef:
        const char *font
        int size
    if isinstance(text_class, unicode): text_class = PyUnicode_AsUTF8String(text_class)
    edje_text_class_get(
        <const char *>text_class if text_class is not None else NULL,
        &font, &size)
    return (_ctouni(font), size)

def text_class_del(text_class):
    if isinstance(text_class, unicode): text_class = PyUnicode_AsUTF8String(text_class)
    edje_text_class_del(
        <const char *>text_class if text_class is not None else NULL)


def text_class_list():
    cdef:
        Eina_List *lst
        Eina_List *itr
    ret = []
    lst = edje_text_class_list()
    itr = lst
    while itr:
        ret.append(_touni(<char*>itr.data))
        eina_stringshare_del(<Eina_Stringshare*>itr.data)
        itr = itr.next
    eina_list_free(lst)
    return ret


def message_signal_process():
    edje_message_signal_process()


def extern_object_min_size_set(Object obj, int w, int h):
    edje_extern_object_min_size_set(obj.obj, w, h)


def extern_object_max_size_set(Object obj, int w, int h):
    edje_extern_object_max_size_set(obj.obj, w, h)


def extern_object_aspect_set(Object obj, int aspect, int w, int h):
    edje_extern_object_aspect_set(obj.obj, <Edje_Aspect_Control>aspect, w, h)


def available_modules_get():
    cdef const Eina_List *lst
    lst = edje_available_modules_get()
    ret = []
    while lst:
        ret.append(<char*>lst.data)
        lst = lst.next
    return ret


def module_load(name):
    if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
    return bool(edje_module_load(
                    <const char *>name if name is not None else NULL))


include "efl.edje_message.pxi"
include "efl.edje_external.pxi"
include "efl.edje_object.pxi"


init()
atexit.register(shutdown)
