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
from cpython cimport bool
from efl cimport *
from efl.eo cimport Eo, object_from_instance, _object_mapping_register
from efl.eo cimport _ctouni, _cfruni, _touni, _fruni


EVAS_LAYER_MIN = -32768
EVAS_LAYER_MAX =  32767

EVAS_HINT_EXPAND = 1.0
EVAS_HINT_FILL = -1.0

EVAS_CALLBACK_MOUSE_IN = 0
EVAS_CALLBACK_MOUSE_OUT = 1
EVAS_CALLBACK_MOUSE_DOWN = 2
EVAS_CALLBACK_MOUSE_UP = 3
EVAS_CALLBACK_MOUSE_MOVE = 4
EVAS_CALLBACK_MOUSE_WHEEL = 5
EVAS_CALLBACK_MULTI_DOWN = 6
EVAS_CALLBACK_MULTI_UP = 7
EVAS_CALLBACK_MULTI_MOVE = 8
EVAS_CALLBACK_FREE = 9
EVAS_CALLBACK_KEY_DOWN = 10
EVAS_CALLBACK_KEY_UP = 11
EVAS_CALLBACK_FOCUS_IN = 12
EVAS_CALLBACK_FOCUS_OUT = 13
EVAS_CALLBACK_SHOW = 14
EVAS_CALLBACK_HIDE = 15
EVAS_CALLBACK_MOVE = 16
EVAS_CALLBACK_RESIZE = 17
EVAS_CALLBACK_RESTACK = 18
EVAS_CALLBACK_DEL = 19
EVAS_CALLBACK_HOLD = 20
EVAS_CALLBACK_CHANGED_SIZE_HINTS = 21
EVAS_CALLBACK_IMAGE_PRELOADED = 22
EVAS_CALLBACK_CANVAS_FOCUS_IN = 23
EVAS_CALLBACK_CANVAS_FOCUS_OUT = 24
EVAS_CALLBACK_RENDER_FLUSH_PRE = 25
EVAS_CALLBACK_RENDER_FLUSH_POST = 26
EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN = 27
EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT = 28
EVAS_CALLBACK_IMAGE_UNLOADED = 29
EVAS_CALLBACK_RENDER_PRE = 30
EVAS_CALLBACK_RENDER_POST = 31
EVAS_CALLBACK_IMAGE_RESIZE = 32
EVAS_CALLBACK_DEVICE_CHANGED = 33
EVAS_CALLBACK_LAST = 34

EVAS_BUTTON_NONE = 0
EVAS_BUTTON_DOUBLE_CLICK = 1
EVAS_BUTTON_TRIPLE_CLICK = 2

EVAS_EVENT_FLAG_NONE = 0
EVAS_EVENT_FLAG_ON_HOLD = 1 << 0

EVAS_RENDER_BLEND = 0
EVAS_RENDER_BLEND_REL = 1
EVAS_RENDER_COPY = 2
EVAS_RENDER_COPY_REL = 3
EVAS_RENDER_ADD = 4
EVAS_RENDER_ADD_REL = 5
EVAS_RENDER_SUB = 6
EVAS_RENDER_SUB_REL = 7
EVAS_RENDER_TINT = 8
EVAS_RENDER_TINT_REL = 9
EVAS_RENDER_MASK = 10
EVAS_RENDER_MUL = 11

EVAS_TEXTURE_REFLECT = 0
EVAS_TEXTURE_REPEAT = 1
EVAS_TEXTURE_RESTRICT = 2
EVAS_TEXTURE_RESTRICT_REFLECT = 3
EVAS_TEXTURE_RESTRICT_REPEAT = 4
EVAS_TEXTURE_PAD = 5

EVAS_ALLOC_ERROR_NONE      = 0
EVAS_ALLOC_ERROR_FATAL     = 1
EVAS_ALLOC_ERROR_RECOVERED = 2

EVAS_LOAD_ERROR_NONE = 0
EVAS_LOAD_ERROR_GENERIC = 1
EVAS_LOAD_ERROR_DOES_NOT_EXIST = 2
EVAS_LOAD_ERROR_PERMISSION_DENIED = 3
EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED = 4
EVAS_LOAD_ERROR_CORRUPT_FILE = 5
EVAS_LOAD_ERROR_UNKNOWN_FORMAT = 6

EVAS_COLOR_SPACE_ARGB = 0
EVAS_COLOR_SPACE_AHSV = 1

EVAS_COLORSPACE_ARGB8888 = 0
EVAS_COLORSPACE_YCBCR422P601_PL = 1
EVAS_COLORSPACE_YCBCR422P709_PL = 2
EVAS_COLORSPACE_RGB565_A5P = 3

EVAS_PIXEL_FORMAT_NONE        = 0
EVAS_PIXEL_FORMAT_ARGB32      = 1
EVAS_PIXEL_FORMAT_YUV420P_601 = 2
        
EVAS_FONT_HINTING_NONE = 0
EVAS_FONT_HINTING_AUTO = 1
EVAS_FONT_HINTING_BYTECODE = 2

EVAS_TEXT_STYLE_PLAIN = 0
EVAS_TEXT_STYLE_SHADOW = 1
EVAS_TEXT_STYLE_OUTLINE = 2
EVAS_TEXT_STYLE_SOFT_OUTLINE = 3
EVAS_TEXT_STYLE_GLOW = 4
EVAS_TEXT_STYLE_OUTLINE_SHADOW = 5
EVAS_TEXT_STYLE_FAR_SHADOW = 6
EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW = 7
EVAS_TEXT_STYLE_SOFT_SHADOW = 8
EVAS_TEXT_STYLE_FAR_SOFT_SHADOW = 9

EVAS_TEXT_INVALID = -1
EVAS_TEXT_SPECIAL = -2

EVAS_TEXTBLOCK_TEXT_RAW = 0
EVAS_TEXTBLOCK_TEXT_PLAIN = 1

EVAS_OBJECT_POINTER_MODE_AUTOGRAB = 0
EVAS_OBJECT_POINTER_MODE_NOGRAB = 1

EVAS_IMAGE_ROTATE_NONE = 0
EVAS_IMAGE_ROTATE_90 = 1
EVAS_IMAGE_ROTATE_180 = 2
EVAS_IMAGE_ROTATE_270 = 3

EVAS_ASPECT_CONTROL_NONE = 0
EVAS_ASPECT_CONTROL_NEITHER = 1
EVAS_ASPECT_CONTROL_HORIZONTAL = 2
EVAS_ASPECT_CONTROL_VERTICAL = 3
EVAS_ASPECT_CONTROL_BOTH = 4


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
    return evas_render_method_lookup(_cfruni(name))


def render_method_list():
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
        if code == EVAS_LOAD_ERROR_NONE:
            msg = "No error on load"
        elif code == EVAS_LOAD_ERROR_GENERIC:
            msg = "A non-specific error occurred"
        elif code == EVAS_LOAD_ERROR_DOES_NOT_EXIST:
            msg = "File (or file path) does not exist"
        elif code == EVAS_LOAD_ERROR_PERMISSION_DENIED:
            msg = "Permission deinied to an existing file (or path)"
        elif code == EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED:
            msg = "Allocation of resources failure prevented load"
        elif code == EVAS_LOAD_ERROR_CORRUPT_FILE:
            msg = "File corrupt (but was detected as a known format)"
        elif code == EVAS_LOAD_ERROR_UNKNOWN_FORMAT:
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


init()
