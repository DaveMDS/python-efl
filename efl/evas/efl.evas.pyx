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

import traceback
from cpython cimport PyUnicode_AsUTF8String
from libc.stdint cimport uintptr_t
#from efl.eina cimport *
from efl.eo cimport Eo, object_from_instance, _object_mapping_register
from efl.utils.conversions cimport _ctouni, _touni
cimport efl.evas.enums as enums

EVAS_LAYER_MIN = enums.EVAS_LAYER_MIN
EVAS_LAYER_MAX = enums.EVAS_LAYER_MAX

EVAS_HINT_EXPAND = 1.0
EVAS_HINT_FILL = -1.0

EVAS_CALLBACK_MOUSE_IN = enums.EVAS_CALLBACK_MOUSE_IN
EVAS_CALLBACK_MOUSE_OUT = enums.EVAS_CALLBACK_MOUSE_OUT
EVAS_CALLBACK_MOUSE_DOWN = enums.EVAS_CALLBACK_MOUSE_DOWN
EVAS_CALLBACK_MOUSE_UP = enums.EVAS_CALLBACK_MOUSE_UP
EVAS_CALLBACK_MOUSE_MOVE = enums.EVAS_CALLBACK_MOUSE_MOVE
EVAS_CALLBACK_MOUSE_WHEEL = enums.EVAS_CALLBACK_MOUSE_WHEEL
EVAS_CALLBACK_MULTI_DOWN = enums.EVAS_CALLBACK_MULTI_DOWN
EVAS_CALLBACK_MULTI_UP = enums.EVAS_CALLBACK_MULTI_UP
EVAS_CALLBACK_MULTI_MOVE = enums.EVAS_CALLBACK_MULTI_MOVE
EVAS_CALLBACK_FREE = enums.EVAS_CALLBACK_FREE
EVAS_CALLBACK_KEY_DOWN = enums.EVAS_CALLBACK_KEY_DOWN
EVAS_CALLBACK_KEY_UP = enums.EVAS_CALLBACK_KEY_UP
EVAS_CALLBACK_FOCUS_IN = enums.EVAS_CALLBACK_FOCUS_IN
EVAS_CALLBACK_FOCUS_OUT = enums.EVAS_CALLBACK_FOCUS_OUT
EVAS_CALLBACK_SHOW = enums.EVAS_CALLBACK_SHOW
EVAS_CALLBACK_HIDE = enums.EVAS_CALLBACK_HIDE
EVAS_CALLBACK_MOVE = enums.EVAS_CALLBACK_MOVE
EVAS_CALLBACK_RESIZE = enums.EVAS_CALLBACK_RESIZE
EVAS_CALLBACK_RESTACK = enums.EVAS_CALLBACK_RESTACK
EVAS_CALLBACK_DEL = enums.EVAS_CALLBACK_DEL
EVAS_CALLBACK_HOLD = enums.EVAS_CALLBACK_HOLD
EVAS_CALLBACK_CHANGED_SIZE_HINTS = enums.EVAS_CALLBACK_CHANGED_SIZE_HINTS
EVAS_CALLBACK_IMAGE_PRELOADED = enums.EVAS_CALLBACK_IMAGE_PRELOADED
EVAS_CALLBACK_CANVAS_FOCUS_IN = enums.EVAS_CALLBACK_CANVAS_FOCUS_IN
EVAS_CALLBACK_CANVAS_FOCUS_OUT = enums.EVAS_CALLBACK_CANVAS_FOCUS_OUT
EVAS_CALLBACK_RENDER_FLUSH_PRE = enums.EVAS_CALLBACK_RENDER_FLUSH_PRE
EVAS_CALLBACK_RENDER_FLUSH_POST = enums.EVAS_CALLBACK_RENDER_FLUSH_POST
EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN = enums.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN
EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT = enums.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT
EVAS_CALLBACK_IMAGE_UNLOADED = enums.EVAS_CALLBACK_IMAGE_UNLOADED
EVAS_CALLBACK_RENDER_PRE = enums.EVAS_CALLBACK_RENDER_PRE
EVAS_CALLBACK_RENDER_POST = enums.EVAS_CALLBACK_RENDER_POST
EVAS_CALLBACK_IMAGE_RESIZE = enums.EVAS_CALLBACK_IMAGE_RESIZE
EVAS_CALLBACK_DEVICE_CHANGED = enums.EVAS_CALLBACK_DEVICE_CHANGED
EVAS_CALLBACK_LAST = enums.EVAS_CALLBACK_LAST

EVAS_BUTTON_NONE = enums.EVAS_BUTTON_NONE
EVAS_BUTTON_DOUBLE_CLICK = enums.EVAS_BUTTON_DOUBLE_CLICK
EVAS_BUTTON_TRIPLE_CLICK = enums.EVAS_BUTTON_TRIPLE_CLICK

EVAS_EVENT_FLAG_NONE = enums.EVAS_EVENT_FLAG_NONE
EVAS_EVENT_FLAG_ON_HOLD = enums.EVAS_EVENT_FLAG_ON_HOLD

EVAS_RENDER_BLEND = enums.EVAS_RENDER_BLEND
EVAS_RENDER_BLEND_REL = enums.EVAS_RENDER_BLEND_REL
EVAS_RENDER_COPY = enums.EVAS_RENDER_COPY
EVAS_RENDER_COPY_REL = enums.EVAS_RENDER_COPY_REL
EVAS_RENDER_ADD = enums.EVAS_RENDER_ADD
EVAS_RENDER_ADD_REL = enums.EVAS_RENDER_ADD_REL
EVAS_RENDER_SUB = enums.EVAS_RENDER_SUB
EVAS_RENDER_SUB_REL = enums.EVAS_RENDER_SUB_REL
EVAS_RENDER_TINT = enums.EVAS_RENDER_TINT
EVAS_RENDER_TINT_REL = enums.EVAS_RENDER_TINT_REL
EVAS_RENDER_MASK = enums.EVAS_RENDER_MASK
EVAS_RENDER_MUL = enums.EVAS_RENDER_MUL

EVAS_TEXTURE_REFLECT = enums.EVAS_TEXTURE_REFLECT
EVAS_TEXTURE_REPEAT = enums.EVAS_TEXTURE_REPEAT
EVAS_TEXTURE_RESTRICT = enums.EVAS_TEXTURE_RESTRICT
EVAS_TEXTURE_RESTRICT_REFLECT = enums.EVAS_TEXTURE_RESTRICT_REFLECT
EVAS_TEXTURE_RESTRICT_REPEAT = enums.EVAS_TEXTURE_RESTRICT_REPEAT
EVAS_TEXTURE_PAD = enums.EVAS_TEXTURE_PAD

EVAS_ALLOC_ERROR_NONE = enums.EVAS_ALLOC_ERROR_NONE
EVAS_ALLOC_ERROR_FATAL = enums.EVAS_ALLOC_ERROR_FATAL
EVAS_ALLOC_ERROR_RECOVERED = enums.EVAS_ALLOC_ERROR_RECOVERED

EVAS_LOAD_ERROR_NONE = enums.EVAS_LOAD_ERROR_NONE
EVAS_LOAD_ERROR_GENERIC = enums.EVAS_LOAD_ERROR_GENERIC
EVAS_LOAD_ERROR_DOES_NOT_EXIST = enums.EVAS_LOAD_ERROR_DOES_NOT_EXIST
EVAS_LOAD_ERROR_PERMISSION_DENIED = enums.EVAS_LOAD_ERROR_PERMISSION_DENIED
EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED = enums.EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED
EVAS_LOAD_ERROR_CORRUPT_FILE = enums.EVAS_LOAD_ERROR_CORRUPT_FILE
EVAS_LOAD_ERROR_UNKNOWN_FORMAT = enums.EVAS_LOAD_ERROR_UNKNOWN_FORMAT

EVAS_COLOR_SPACE_ARGB = enums.EVAS_COLOR_SPACE_ARGB
EVAS_COLOR_SPACE_AHSV = enums.EVAS_COLOR_SPACE_AHSV

EVAS_COLORSPACE_ARGB8888 = enums.EVAS_COLORSPACE_ARGB8888
EVAS_COLORSPACE_YCBCR422P601_PL = enums.EVAS_COLORSPACE_YCBCR422P601_PL
EVAS_COLORSPACE_YCBCR422P709_PL = enums.EVAS_COLORSPACE_YCBCR422P709_PL
EVAS_COLORSPACE_RGB565_A5P = enums.EVAS_COLORSPACE_RGB565_A5P

EVAS_PIXEL_FORMAT_NONE = enums.EVAS_PIXEL_FORMAT_NONE
EVAS_PIXEL_FORMAT_ARGB32 = enums.EVAS_PIXEL_FORMAT_ARGB32
EVAS_PIXEL_FORMAT_YUV420P_601 = enums.EVAS_PIXEL_FORMAT_YUV420P_601

EVAS_FONT_HINTING_NONE = enums.EVAS_FONT_HINTING_NONE
EVAS_FONT_HINTING_AUTO = enums.EVAS_FONT_HINTING_AUTO
EVAS_FONT_HINTING_BYTECODE = enums.EVAS_FONT_HINTING_BYTECODE

EVAS_TEXT_STYLE_PLAIN = enums.EVAS_TEXT_STYLE_PLAIN
EVAS_TEXT_STYLE_SHADOW = enums.EVAS_TEXT_STYLE_SHADOW
EVAS_TEXT_STYLE_OUTLINE = enums.EVAS_TEXT_STYLE_OUTLINE
EVAS_TEXT_STYLE_SOFT_OUTLINE = enums.EVAS_TEXT_STYLE_SOFT_OUTLINE
EVAS_TEXT_STYLE_GLOW = enums.EVAS_TEXT_STYLE_GLOW
EVAS_TEXT_STYLE_OUTLINE_SHADOW = enums.EVAS_TEXT_STYLE_OUTLINE_SHADOW
EVAS_TEXT_STYLE_FAR_SHADOW = enums.EVAS_TEXT_STYLE_FAR_SHADOW
EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW = enums.EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW
EVAS_TEXT_STYLE_SOFT_SHADOW = enums.EVAS_TEXT_STYLE_SOFT_SHADOW
EVAS_TEXT_STYLE_FAR_SOFT_SHADOW = enums.EVAS_TEXT_STYLE_FAR_SOFT_SHADOW

EVAS_TEXT_INVALID = enums.EVAS_TEXT_INVALID
EVAS_TEXT_SPECIAL = enums.EVAS_TEXT_SPECIAL

EVAS_TEXTBLOCK_TEXT_RAW = enums.EVAS_TEXTBLOCK_TEXT_RAW
EVAS_TEXTBLOCK_TEXT_PLAIN = enums.EVAS_TEXTBLOCK_TEXT_PLAIN

EVAS_OBJECT_POINTER_MODE_AUTOGRAB = enums.EVAS_OBJECT_POINTER_MODE_AUTOGRAB
EVAS_OBJECT_POINTER_MODE_NOGRAB = enums.EVAS_OBJECT_POINTER_MODE_NOGRAB

# FIXME: These were used with the image rotation functions removed earlier.
# Are they needed anymore?
#
# EVAS_IMAGE_ROTATE_NONE = 0
# EVAS_IMAGE_ROTATE_90 = 1
# EVAS_IMAGE_ROTATE_180 = 2
# EVAS_IMAGE_ROTATE_270 = 3

EVAS_ASPECT_CONTROL_NONE = enums.EVAS_ASPECT_CONTROL_NONE
EVAS_ASPECT_CONTROL_NEITHER = enums.EVAS_ASPECT_CONTROL_NEITHER
EVAS_ASPECT_CONTROL_HORIZONTAL = enums.EVAS_ASPECT_CONTROL_HORIZONTAL
EVAS_ASPECT_CONTROL_VERTICAL = enums.EVAS_ASPECT_CONTROL_VERTICAL
EVAS_ASPECT_CONTROL_BOTH = enums.EVAS_ASPECT_CONTROL_BOTH

EVAS_SMART_CLASS_VERSION = enums.EVAS_SMART_CLASS_VERSION

def init():
    # when changing these, also change __init__.py!
#     if evas_object_event_callbacks_len != EVAS_CALLBACK_LAST:
#         raise SystemError("Number of object callbacks changed from %d to %d." %
#                           (evas_object_event_callbacks_len, EVAS_CALLBACK_LAST))
#     if evas_canvas_event_callbacks_len != EVAS_CALLBACK_LAST:
#         raise SystemError("Number of canvas callbacks changed from %d to %d." %
#                           (evas_canvas_event_callbacks_len, EVAS_CALLBACK_LAST))
    return evas_init()


def shutdown():
    return evas_shutdown()


def render_method_lookup(name):
    """render_method_lookup(name)

    Lookup render method and return its id (> 0 if found).

    :param name: Render method
    :type name: string
    :return: ID
    :rtype: int

    """
    if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
    return evas_render_method_lookup(
        <const_char *>name if name is not None else NULL)


def render_method_list():
    """render_method_list()

    Returns a list of render method names.

    :rtype: list of str

    """
    cdef Eina_List *lst

    ret = []
    lst = evas_render_method_list()
    while lst != NULL:
        ret.append(<char*> lst.data)
        lst = lst.next

    evas_render_method_list_free(lst)
    return ret


def color_parse(desc, is_premul=None):
    cdef unsigned long c, desc_len
    cdef int r, g, b, a

    r = 0
    g = 0
    b = 0
    a = 0

    # TODO: Unicode/py3
    if isinstance(desc, str):
        if not desc or desc[0] != "#":
            raise ValueError("Invalid color description")
        desc_len = len(desc)
        c = int(desc[1:], 16)
        r = (c >> 16) & 0xff
        g = (c >> 8) & 0xff
        b = c & 0xff

        if is_premul is None:
            is_premul = False

        if desc_len == 9:
            a = (c >> 24) & 0xff
        elif desc_len == 7:
            a = 255
        else:
            raise ValueError("Invalid color description")

    elif isinstance(desc, (int, long)):
        c = desc
        a = (c >> 24) & 0xff
        r = (c >> 16) & 0xff
        g = (c >> 8) & 0xff
        b = c & 0xff

        if is_premul is None:
            is_premul = False

    elif isinstance(desc, (list, tuple)):
        if is_premul is None:
            is_premul = True

        if len(desc) == 3:
            a = 255
            r, g, b = desc
        else:
            r, g, b, a = desc
    else:
        raise TypeError("Unsupported type %s for color description." %
                        type(desc))

    if is_premul is False:
        evas_color_argb_premul(a, &r, &g, &b)

    return (r, g, b, a)


def color_argb_premul(int r, int g, int b, int a):
    evas_color_argb_premul(a, &r, &g, &b)
    return (r, g, b, a)


def color_argb_unpremul(int r, int g, int b, int a):
    evas_color_argb_unpremul(a, &r, &g, &b)
    return (r, g, b, a)


def color_hsv_to_rgb(float h, float s, float v):
    cdef int r, g, b
    evas_color_hsv_to_rgb(h, s, v, &r, &g, &b)
    return (r, g, b)


def color_rgb_to_hsv(int r, int g, int b):
    cdef float h, s, v
    evas_color_rgb_to_hsv(r, g, b, &h, &s, &v)
    return (h, s, v)


class EvasLoadError(Exception):
    def __init__(self, int code, filename, key):
        if code == enums.EVAS_LOAD_ERROR_NONE:
            msg = "No error on load"
        elif code == enums.EVAS_LOAD_ERROR_GENERIC:
            msg = "A non-specific error occurred"
        elif code == enums.EVAS_LOAD_ERROR_DOES_NOT_EXIST:
            msg = "File (or file path) does not exist"
        elif code == enums.EVAS_LOAD_ERROR_PERMISSION_DENIED:
            msg = "Permission deinied to an existing file (or path)"
        elif code == enums.EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED:
            msg = "Allocation of resources failure prevented load"
        elif code == enums.EVAS_LOAD_ERROR_CORRUPT_FILE:
            msg = "File corrupt (but was detected as a known format)"
        elif code == enums.EVAS_LOAD_ERROR_UNKNOWN_FORMAT:
            msg = "File is not a known format"
        self.code = code
        self.file = filename
        self.key = key
        Exception.__init__(self, "%s (file=%s, key=%s)" % (msg, filename, key))


include "efl.evas_rect.pxi"
include "efl.evas_map.pxi"
include "efl.evas_canvas_callbacks.pxi"
include "efl.evas_canvas.pxi"
include "efl.evas_object_events.pxi"
include "efl.evas_object_callbacks.pxi"
include "efl.evas_object.pxi"
include "efl.evas_object_smart.pxi"
include "efl.evas_object_image.pxi"
include "efl.evas_object_line.pxi"
include "efl.evas_object_rectangle.pxi"
include "efl.evas_object_polygon.pxi"
include "efl.evas_object_text.pxi"
include "efl.evas_object_textblock.pxi"
include "efl.evas_object_box.pxi"
include "efl.evas_object_textgrid.pxi"
include "efl.evas_object_table.pxi"
include "efl.evas_object_grid.pxi"


init()
