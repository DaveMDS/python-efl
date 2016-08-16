# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

cimport efl.edje.enums as enums

EDJE_MESSAGE_NONE = enums.EDJE_MESSAGE_NONE
EDJE_MESSAGE_SIGNAL = enums.EDJE_MESSAGE_SIGNAL
EDJE_MESSAGE_STRING = enums.EDJE_MESSAGE_STRING
EDJE_MESSAGE_INT = enums.EDJE_MESSAGE_INT
EDJE_MESSAGE_FLOAT = enums.EDJE_MESSAGE_FLOAT
EDJE_MESSAGE_STRING_SET = enums.EDJE_MESSAGE_STRING_SET
EDJE_MESSAGE_INT_SET = enums.EDJE_MESSAGE_INT_SET
EDJE_MESSAGE_FLOAT_SET = enums.EDJE_MESSAGE_FLOAT_SET
EDJE_MESSAGE_STRING_INT = enums.EDJE_MESSAGE_STRING_INT
EDJE_MESSAGE_STRING_FLOAT = enums.EDJE_MESSAGE_STRING_FLOAT
EDJE_MESSAGE_STRING_INT_SET = enums.EDJE_MESSAGE_STRING_INT_SET
EDJE_MESSAGE_STRING_FLOAT_SET = enums.EDJE_MESSAGE_STRING_FLOAT_SET

EDJE_ASPECT_CONTROL_NONE = enums.EDJE_ASPECT_CONTROL_NONE
EDJE_ASPECT_CONTROL_NEITHER = enums.EDJE_ASPECT_CONTROL_NEITHER
EDJE_ASPECT_CONTROL_HORIZONTAL = enums.EDJE_ASPECT_CONTROL_HORIZONTAL
EDJE_ASPECT_CONTROL_VERTICAL = enums.EDJE_ASPECT_CONTROL_VERTICAL
EDJE_ASPECT_CONTROL_BOTH = enums.EDJE_ASPECT_CONTROL_BOTH

EDJE_DRAG_DIR_NONE = enums.EDJE_DRAG_DIR_NONE
EDJE_DRAG_DIR_X = enums.EDJE_DRAG_DIR_X
EDJE_DRAG_DIR_Y = enums.EDJE_DRAG_DIR_Y
EDJE_DRAG_DIR_XY = enums.EDJE_DRAG_DIR_XY

EDJE_LOAD_ERROR_NONE = enums.EDJE_LOAD_ERROR_NONE
EDJE_LOAD_ERROR_GENERIC = enums.EDJE_LOAD_ERROR_GENERIC
EDJE_LOAD_ERROR_DOES_NOT_EXIST = enums.EDJE_LOAD_ERROR_DOES_NOT_EXIST
EDJE_LOAD_ERROR_PERMISSION_DENIED = enums.EDJE_LOAD_ERROR_PERMISSION_DENIED
EDJE_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED = enums.EDJE_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED
EDJE_LOAD_ERROR_CORRUPT_FILE = enums.EDJE_LOAD_ERROR_CORRUPT_FILE
EDJE_LOAD_ERROR_UNKNOWN_FORMAT = enums.EDJE_LOAD_ERROR_UNKNOWN_FORMAT
EDJE_LOAD_ERROR_INCOMPATIBLE_FILE = enums.EDJE_LOAD_ERROR_INCOMPATIBLE_FILE
EDJE_LOAD_ERROR_UNKNOWN_COLLECTION = enums.EDJE_LOAD_ERROR_UNKNOWN_COLLECTION
EDJE_LOAD_ERROR_RECURSIVE_REFERENCE = enums.EDJE_LOAD_ERROR_RECURSIVE_REFERENCE

EDJE_PART_TYPE_NONE = enums.EDJE_PART_TYPE_NONE
EDJE_PART_TYPE_RECTANGLE = enums.EDJE_PART_TYPE_RECTANGLE
EDJE_PART_TYPE_TEXT = enums.EDJE_PART_TYPE_TEXT
EDJE_PART_TYPE_IMAGE = enums.EDJE_PART_TYPE_IMAGE
EDJE_PART_TYPE_SWALLOW = enums.EDJE_PART_TYPE_SWALLOW
EDJE_PART_TYPE_TEXTBLOCK = enums.EDJE_PART_TYPE_TEXTBLOCK
EDJE_PART_TYPE_GRADIENT = enums.EDJE_PART_TYPE_GRADIENT
EDJE_PART_TYPE_GROUP = enums.EDJE_PART_TYPE_GROUP
EDJE_PART_TYPE_BOX = enums.EDJE_PART_TYPE_BOX
EDJE_PART_TYPE_TABLE = enums.EDJE_PART_TYPE_TABLE
EDJE_PART_TYPE_EXTERNAL = enums.EDJE_PART_TYPE_EXTERNAL
EDJE_PART_TYPE_SPACER = enums.EDJE_PART_TYPE_SPACER
EDJE_PART_TYPE_MESH_NODE = enums.EDJE_PART_TYPE_MESH_NODE
EDJE_PART_TYPE_LIGHT = enums.EDJE_PART_TYPE_LIGHT
EDJE_PART_TYPE_CAMERA = enums.EDJE_PART_TYPE_CAMERA
EDJE_PART_TYPE_LAST = enums.EDJE_PART_TYPE_LAST

EDJE_TEXT_EFFECT_NONE = enums.EDJE_TEXT_EFFECT_NONE
EDJE_TEXT_EFFECT_PLAIN = enums.EDJE_TEXT_EFFECT_PLAIN
EDJE_TEXT_EFFECT_OUTLINE = enums.EDJE_TEXT_EFFECT_OUTLINE
EDJE_TEXT_EFFECT_SOFT_OUTLINE = enums.EDJE_TEXT_EFFECT_SOFT_OUTLINE
EDJE_TEXT_EFFECT_SHADOW = enums.EDJE_TEXT_EFFECT_SHADOW
EDJE_TEXT_EFFECT_SOFT_SHADOW = enums.EDJE_TEXT_EFFECT_SOFT_SHADOW
EDJE_TEXT_EFFECT_OUTLINE_SHADOW = enums.EDJE_TEXT_EFFECT_OUTLINE_SHADOW
EDJE_TEXT_EFFECT_OUTLINE_SOFT_SHADOW = enums.EDJE_TEXT_EFFECT_OUTLINE_SOFT_SHADOW
EDJE_TEXT_EFFECT_FAR_SHADOW = enums.EDJE_TEXT_EFFECT_FAR_SHADOW
EDJE_TEXT_EFFECT_FAR_SOFT_SHADOW = enums.EDJE_TEXT_EFFECT_FAR_SOFT_SHADOW
EDJE_TEXT_EFFECT_GLOW = enums.EDJE_TEXT_EFFECT_GLOW
EDJE_TEXT_EFFECT_LAST = enums.EDJE_TEXT_EFFECT_LAST
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM_RIGHT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM_RIGHT
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM_LEFT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_BOTTOM_LEFT
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_LEFT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_LEFT
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP_LEFT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP_LEFT
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP_RIGHT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_TOP_RIGHT
EDJE_TEXT_EFFECT_SHADOW_DIRECTION_RIGHT = enums.EDJE_TEXT_EFFECT_SHADOW_DIRECTION_RIGHT

EDJE_ACTION_TYPE_NONE = enums.EDJE_ACTION_TYPE_NONE
EDJE_ACTION_TYPE_STATE_SET = enums.EDJE_ACTION_TYPE_STATE_SET
EDJE_ACTION_TYPE_ACTION_STOP = enums.EDJE_ACTION_TYPE_ACTION_STOP
EDJE_ACTION_TYPE_SIGNAL_EMIT = enums.EDJE_ACTION_TYPE_SIGNAL_EMIT
EDJE_ACTION_TYPE_DRAG_VAL_SET = enums.EDJE_ACTION_TYPE_DRAG_VAL_SET
EDJE_ACTION_TYPE_DRAG_VAL_STEP = enums.EDJE_ACTION_TYPE_DRAG_VAL_STEP
EDJE_ACTION_TYPE_DRAG_VAL_PAGE = enums.EDJE_ACTION_TYPE_DRAG_VAL_PAGE
EDJE_ACTION_TYPE_SCRIPT = enums.EDJE_ACTION_TYPE_SCRIPT
EDJE_ACTION_TYPE_FOCUS_SET = enums.EDJE_ACTION_TYPE_FOCUS_SET
EDJE_ACTION_TYPE_RESERVED00 = enums.EDJE_ACTION_TYPE_RESERVED00
EDJE_ACTION_TYPE_FOCUS_OBJECT = enums.EDJE_ACTION_TYPE_FOCUS_OBJECT
EDJE_ACTION_TYPE_PARAM_COPY = enums.EDJE_ACTION_TYPE_PARAM_COPY
EDJE_ACTION_TYPE_PARAM_SET = enums.EDJE_ACTION_TYPE_PARAM_SET
EDJE_ACTION_TYPE_SOUND_SAMPLE = enums.EDJE_ACTION_TYPE_SOUND_SAMPLE
EDJE_ACTION_TYPE_SOUND_TONE = enums.EDJE_ACTION_TYPE_SOUND_TONE
EDJE_ACTION_TYPE_PHYSICS_IMPULSE = enums.EDJE_ACTION_TYPE_PHYSICS_IMPULSE
EDJE_ACTION_TYPE_PHYSICS_TORQUE_IMPULSE = enums.EDJE_ACTION_TYPE_PHYSICS_TORQUE_IMPULSE
EDJE_ACTION_TYPE_PHYSICS_FORCE = enums.EDJE_ACTION_TYPE_PHYSICS_FORCE
EDJE_ACTION_TYPE_PHYSICS_TORQUE = enums.EDJE_ACTION_TYPE_PHYSICS_TORQUE
EDJE_ACTION_TYPE_PHYSICS_FORCES_CLEAR = enums.EDJE_ACTION_TYPE_PHYSICS_FORCES_CLEAR
EDJE_ACTION_TYPE_PHYSICS_VEL_SET = enums.EDJE_ACTION_TYPE_PHYSICS_VEL_SET
EDJE_ACTION_TYPE_PHYSICS_ANG_VEL_SET = enums.EDJE_ACTION_TYPE_PHYSICS_ANG_VEL_SET
EDJE_ACTION_TYPE_PHYSICS_STOP = enums.EDJE_ACTION_TYPE_PHYSICS_STOP
EDJE_ACTION_TYPE_PHYSICS_ROT_SET = enums.EDJE_ACTION_TYPE_PHYSICS_ROT_SET
EDJE_ACTION_TYPE_VIBRATION_SAMPLE = enums.EDJE_ACTION_TYPE_VIBRATION_SAMPLE
EDJE_ACTION_TYPE_LAST = enums.EDJE_ACTION_TYPE_LAST

EDJE_TWEEN_MODE_NONE = enums.EDJE_TWEEN_MODE_NONE
EDJE_TWEEN_MODE_LINEAR = enums.EDJE_TWEEN_MODE_LINEAR
EDJE_TWEEN_MODE_SINUSOIDAL = enums.EDJE_TWEEN_MODE_SINUSOIDAL
EDJE_TWEEN_MODE_ACCELERATE = enums.EDJE_TWEEN_MODE_ACCELERATE
EDJE_TWEEN_MODE_DECELERATE = enums.EDJE_TWEEN_MODE_DECELERATE
EDJE_TWEEN_MODE_ACCELERATE_FACTOR = enums.EDJE_TWEEN_MODE_ACCELERATE_FACTOR
EDJE_TWEEN_MODE_DECELERATE_FACTOR = enums.EDJE_TWEEN_MODE_DECELERATE_FACTOR
EDJE_TWEEN_MODE_SINUSOIDAL_FACTOR = enums.EDJE_TWEEN_MODE_SINUSOIDAL_FACTOR
EDJE_TWEEN_MODE_DIVISOR_INTERP = enums.EDJE_TWEEN_MODE_DIVISOR_INTERP
EDJE_TWEEN_MODE_BOUNCE = enums.EDJE_TWEEN_MODE_BOUNCE
EDJE_TWEEN_MODE_SPRING = enums.EDJE_TWEEN_MODE_SPRING
EDJE_TWEEN_MODE_CUBIC_BEZIER = enums.EDJE_TWEEN_MODE_CUBIC_BEZIER
EDJE_TWEEN_MODE_LAST = enums.EDJE_TWEEN_MODE_LAST
EDJE_TWEEN_MODE_MASK = enums.EDJE_TWEEN_MODE_MASK
EDJE_TWEEN_MODE_OPT_FROM_CURRENT = enums.EDJE_TWEEN_MODE_OPT_FROM_CURRENT

EDJE_EXTERNAL_PARAM_TYPE_INT = enums.EDJE_EXTERNAL_PARAM_TYPE_INT
EDJE_EXTERNAL_PARAM_TYPE_DOUBLE = enums.EDJE_EXTERNAL_PARAM_TYPE_DOUBLE
EDJE_EXTERNAL_PARAM_TYPE_STRING = enums.EDJE_EXTERNAL_PARAM_TYPE_STRING
EDJE_EXTERNAL_PARAM_TYPE_BOOL = enums.EDJE_EXTERNAL_PARAM_TYPE_BOOL
EDJE_EXTERNAL_PARAM_TYPE_CHOICE = enums.EDJE_EXTERNAL_PARAM_TYPE_CHOICE
EDJE_EXTERNAL_PARAM_TYPE_MAX = enums.EDJE_EXTERNAL_PARAM_TYPE_MAX

EDJE_INPUT_HINT_NONE = enums.EDJE_INPUT_HINT_NONE
EDJE_INPUT_HINT_AUTO_COMPLETE = enums.EDJE_INPUT_HINT_AUTO_COMPLETE
EDJE_INPUT_HINT_SENSITIVE_DATA = enums.EDJE_INPUT_HINT_SENSITIVE_DATA


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


def size_class_set(size_class, int minw, int minh, int maxw, int maxh):
    """Set the Edje size class.

    :param str size_class: The size class name
    :param int minw: The min width
    :param int minh: The min height
    :param int maxw: The max width
    :param int maxh: The max height

    :return: True on success or False on error
    :rtype: bool

    .. versionadded:: 1.17

    """
    if isinstance(size_class, unicode):
        size_class = PyUnicode_AsUTF8String(size_class)
    return bool(edje_size_class_set(
                    <const char *>size_class if size_class is not None else NULL,
                    minw, minh, maxw, maxh))

def size_class_get(size_class):
    """Get the Edje size class.

    :param str size_class: The size class name

    :return: (minw, minh, maxw, maxh)
    :rtype: 4 int's tuple

    .. versionadded:: 1.17

    """
    cdef int minw, minh, maxw, maxh, ret
    if isinstance(size_class, unicode):
        size_class = PyUnicode_AsUTF8String(size_class)

    ret = edje_size_class_get(
                <const char *>size_class if size_class is not None else NULL,
                &minw, &minh, &maxw, &maxh)
    if ret == 0:
        return None
    else:
        return (minw, minh, maxw, maxh)

def size_class_del(size_class):
    """Delete the size class.

    This function deletes any values at the process level for the specified
    size class.

    :param str size_class: The size class name

    .. versionadded:: 1.17

    """
    if isinstance(size_class, unicode):
        size_class = PyUnicode_AsUTF8String(size_class)
    edje_color_class_del(
        <const char *>size_class if size_class is not None else NULL)

def size_class_list():
    """List size classes.

    This function lists all size classes known about by the current process.

    :return: A list of size class names.
    :rtype: list of strings

    .. versionadded:: 1.17

    """
    cdef:
        Eina_List *lst
        Eina_List *itr
    ret = []
    lst = edje_size_class_list()
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
