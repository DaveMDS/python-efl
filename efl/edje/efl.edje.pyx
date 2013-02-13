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

import traceback
import warnings

from cpython cimport PyMem_Malloc, PyMem_Free
cimport libc.stdlib

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.eo cimport _ctouni, _cfruni, _touni, _fruni, _strings_to_python


# Edje_Message_Type:
EDJE_MESSAGE_NONE             = 0
EDJE_MESSAGE_SIGNAL           = 1
EDJE_MESSAGE_STRING           = 2
EDJE_MESSAGE_INT              = 3
EDJE_MESSAGE_FLOAT            = 4
EDJE_MESSAGE_STRING_SET       = 5
EDJE_MESSAGE_INT_SET          = 6
EDJE_MESSAGE_FLOAT_SET        = 7
EDJE_MESSAGE_STRING_INT       = 8
EDJE_MESSAGE_STRING_FLOAT     = 9
EDJE_MESSAGE_STRING_INT_SET   = 10
EDJE_MESSAGE_STRING_FLOAT_SET = 11

# Edje_Aspect_Control:
EDJE_ASPECT_CONTROL_NONE       = 0
EDJE_ASPECT_CONTROL_NEITHER    = 1
EDJE_ASPECT_CONTROL_HORIZONTAL = 2
EDJE_ASPECT_CONTROL_VERTICAL   = 3
EDJE_ASPECT_CONTROL_BOTH       = 4

# Edje_Drag_Dir:
EDJE_DRAG_DIR_NONE = 0
EDJE_DRAG_DIR_X    = 1
EDJE_DRAG_DIR_Y    = 2
EDJE_DRAG_DIR_XY   = 3

# Edje_Load_Error:
EDJE_LOAD_ERROR_NONE                       = 0
EDJE_LOAD_ERROR_GENERIC                    = 1
EDJE_LOAD_ERROR_DOES_NOT_EXIST             = 2
EDJE_LOAD_ERROR_PERMISSION_DENIED          = 3
EDJE_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED = 4
EDJE_LOAD_ERROR_CORRUPT_FILE               = 5
EDJE_LOAD_ERROR_UNKNOWN_FORMAT             = 6
EDJE_LOAD_ERROR_INCOMPATIBLE_FILE          = 7
EDJE_LOAD_ERROR_UNKNOWN_COLLECTION         = 8

# Edje_Part_Type:
EDJE_PART_TYPE_NONE      = 0
EDJE_PART_TYPE_RECTANGLE = 1
EDJE_PART_TYPE_TEXT      = 2
EDJE_PART_TYPE_IMAGE     = 3
EDJE_PART_TYPE_SWALLOW   = 4
EDJE_PART_TYPE_TEXTBLOCK = 5
EDJE_PART_TYPE_GRADIENT  = 6
EDJE_PART_TYPE_GROUP     = 7
EDJE_PART_TYPE_BOX       = 8
EDJE_PART_TYPE_TABLE     = 9
EDJE_PART_TYPE_EXTERNAL  = 10
EDJE_PART_TYPE_LAST      = 11

# Edje_Text_Effect:
EDJE_TEXT_EFFECT_NONE                = 0
EDJE_TEXT_EFFECT_PLAIN               = 1
EDJE_TEXT_EFFECT_OUTLINE             = 2
EDJE_TEXT_EFFECT_SOFT_OUTLINE        = 3
EDJE_TEXT_EFFECT_SHADOW              = 4
EDJE_TEXT_EFFECT_SOFT_SHADOW         = 5
EDJE_TEXT_EFFECT_OUTLINE_SHADOW      = 6
EDJE_TEXT_EFFECT_OUTLINE_SOFT_SHADOW = 7
EDJE_TEXT_EFFECT_FAR_SHADOW          = 8
EDJE_TEXT_EFFECT_FAR_SOFT_SHADOW     = 9
EDJE_TEXT_EFFECT_GLOW                = 10
EDJE_TEXT_EFFECT_LAST                = 11

# Edje_Action_Type:
EDJE_ACTION_TYPE_NONE          = 0
EDJE_ACTION_TYPE_STATE_SET     = 1
EDJE_ACTION_TYPE_ACTION_STOP   = 2
EDJE_ACTION_TYPE_SIGNAL_EMIT   = 3
EDJE_ACTION_TYPE_DRAG_VAL_SET  = 4
EDJE_ACTION_TYPE_DRAG_VAL_STEP = 5
EDJE_ACTION_TYPE_DRAG_VAL_PAGE = 6
EDJE_ACTION_TYPE_SCRIPT        = 7
EDJE_ACTION_TYPE_FOCUS_SET     = 8
EDJE_ACTION_TYPE_LUA_SCRIPT    = 9
EDJE_ACTION_TYPE_LAST          = 10

# Edje_Tween_Mode:
EDJE_TWEEN_MODE_NONE       = 0
EDJE_TWEEN_MODE_LINEAR     = 1
EDJE_TWEEN_MODE_SINUSOIDAL = 2
EDJE_TWEEN_MODE_ACCELERATE = 3
EDJE_TWEEN_MODE_DECELERATE = 4
EDJE_TWEEN_MODE_LAST       = 5

# Edje_External_Param_Type:
EDJE_EXTERNAL_PARAM_TYPE_INT    = 0
EDJE_EXTERNAL_PARAM_TYPE_DOUBLE = 1
EDJE_EXTERNAL_PARAM_TYPE_STRING = 2
EDJE_EXTERNAL_PARAM_TYPE_BOOL   = 3
EDJE_EXTERNAL_PARAM_TYPE_CHOICE = 4
EDJE_EXTERNAL_PARAM_TYPE_MAX    = 5



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
    edje_fontset_append_set(_cfruni(fonts))


def fontset_append_get():
    return _ctouni(edje_fontset_append_get())


def file_collection_list(file):
    cdef Eina_List *lst
    lst = edje_file_collection_list(_cfruni(file))
    ret = _strings_to_python(lst)
    edje_file_collection_list_free(lst)
    return ret


def file_group_exists(file, group):
    return bool(edje_file_group_exists(_cfruni(file), _cfruni(group)))


def file_data_get(file, key):
    cdef char *s
    return _ctouni(edje_file_data_get(_cfruni(file), _cfruni(key)))


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


def color_class_set(color_class,
                    int r, int g, int b, int a,
                    int r2, int g2, int b2, int a2,
                    int r3, int g3, int b3, int a3):
    edje_color_class_set(_cfruni(color_class),
                         r, g, b, a,
                         r2, g2, b2, a2,
                         r3, g3, b3, a3)


def color_class_get(color_class):
    cdef int r, g, b, a
    cdef int r2, g2, b2, a2
    cdef int r3, g3, b3, a3
    edje_color_class_get(_cfruni(color_class),
                         &r, &g, &b, &a,
                         &r2, &g2, &b2, &a2,
                         &r3, &g3, &b3, &a3)
    return (r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)


def color_class_del(color_class):
    edje_color_class_del(_cfruni(color_class))


def color_class_list():
    cdef Eina_List *lst, *itr
    ret = []
    lst = edje_color_class_list()
    itr = lst
    while itr:
        ret.append(<char*>itr.data)
        libc.stdlib.free(itr.data)
        itr = itr.next
    eina_list_free(lst)
    return ret


def text_class_set(text_class, font, int size):
    edje_text_class_set(_cfruni(text_class), _cfruni(font), size)


def text_class_del(text_class):
    edje_text_class_del(_cfruni(text_class))


def text_class_list():
    cdef Eina_List *lst, *itr
    ret = []
    lst = edje_text_class_list()
    itr = lst
    while itr:
        ret.append(<char*>itr.data)
        libc.stdlib.free(itr.data)
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
    cdef const_Eina_List *lst
    lst = edje_available_modules_get()
    ret = []
    while lst:
        ret.append(<char*>lst.data)
        lst = lst.next
    return ret


def module_load(name):
    return bool(edje_module_load(_cfruni(name)))

# class EdjeObjectMeta(evas.c_evas.EvasObjectMeta):
#     def __init__(cls, name, bases, dict_):
#         evas.c_evas.EvasObjectMeta.__init__(cls, name, bases, dict_)
#         cls._fetch_callbacks()
# 
#     def _fetch_callbacks(cls):
#         if "__edje_signal_callbacks__" in cls.__dict__:
#             return
# 
#         cls.__edje_signal_callbacks__ = []
#         cls.__edje_message_callbacks__ = []
#         cls.__edje_text_callbacks__ = []
# 
#         sig_append = cls.__edje_signal_callbacks__.append
#         msg_append = cls.__edje_message_callbacks__.append
#         txt_append = cls.__edje_text_callbacks__.append
# 
#         for name in dir(cls):
#             val = getattr(cls, name)
#             if not callable(val):
#                 continue
# 
#             if hasattr(val, "edje_signal_callback"):
#                 sig_data = getattr(val, "edje_signal_callback")
#                 sig_append((name, sig_data))
#             elif hasattr(val, "edje_message_handler"):
#                 msg_append(name)
#             elif hasattr(val, "edje_text_change_callback"):
#                 txt_append(name)


include "efl.edje_message.pxi"
include "efl.edje_external.pxi"
include "efl.edje_object.pxi"


init()
