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

Enumerations
============

Size Hints Helper
-----------------

Helper values to be used as :ref:`evas-size-hints` for objects.

.. data:: EVAS_HINT_EXPAND = -1.0

    to be used with **weight** or **expand**

.. data:: EVAS_HINT_FILL = 1.0

    to be used with **align** or **fill**

.. data:: EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND

    Expand in both direction

    .. versionadded:: 1.13

.. data:: EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0

    Expand horizontally

    .. versionadded:: 1.13

.. data:: EXPAND_VERT = 0.0, EVAS_HINT_EXPAND

    Expand vertically

    .. versionadded:: 1.13

.. data:: FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

    Fill both direction

    .. versionadded:: 1.13

.. data:: FILL_HORIZ = EVAS_HINT_FILL, 0.5

    Fill horizontally

    .. versionadded:: 1.13

.. data:: FILL_VERT = 0.5, EVAS_HINT_FILL

    Fill vertically

    .. versionadded:: 1.13


.. _Evas_Button_Flags:

Evas_Button_Flags
-----------------

Flags for Mouse Button events.

.. data:: EVAS_BUTTON_NONE

    No extra mouse button data.

.. data:: EVAS_BUTTON_DOUBLE_CLICK

    This mouse button press was the 2nd press of a double click.

.. data:: EVAS_BUTTON_TRIPLE_CLICK

    This mouse button press was the 3rd press of a triple click.


.. _Evas_BiDi_Direction:

Evas_BiDi_Direction
-------------------

.. data:: EVAS_BIDI_DIRECTION_NATURAL

    Natural direction.

.. data:: EVAS_BIDI_DIRECTION_NEUTRAL

    Neutral direction.

.. data:: EVAS_BIDI_DIRECTION_LTR

    Left to right direction.

.. data:: EVAS_BIDI_DIRECTION_RTL

    Right to left direction.


.. _Evas_Callback_Type:

Evas_Callback_Type
-------------------------------------

.. data:: EVAS_CALLBACK_MOUSE_IN

    Mouse In Event.

.. data:: EVAS_CALLBACK_MOUSE_OUT

    Mouse Out Event.

.. data:: EVAS_CALLBACK_MOUSE_DOWN

    Mouse Button Down Event.

.. data:: EVAS_CALLBACK_MOUSE_UP

    Mouse Button Up Event.

.. data:: EVAS_CALLBACK_MOUSE_MOVE

    Mouse Move Event.

.. data:: EVAS_CALLBACK_MOUSE_WHEEL

    Mouse Wheel Event.

.. data:: EVAS_CALLBACK_MULTI_DOWN

    Multi-touch Down Event.

.. data:: EVAS_CALLBACK_MULTI_UP

    Multi-touch Up Event.

.. data:: EVAS_CALLBACK_MULTI_MOVE

    Multi-touch Move Event.

.. data:: EVAS_CALLBACK_FREE

    Object Being Freed (Called after Del).

.. data:: EVAS_CALLBACK_KEY_DOWN

    Key Press Event.

.. data:: EVAS_CALLBACK_KEY_UP

    Key Release Event.

.. data:: EVAS_CALLBACK_FOCUS_IN

    Focus In Event.

.. data:: EVAS_CALLBACK_FOCUS_OUT

    Focus Out Event.

.. data:: EVAS_CALLBACK_SHOW

    Show Event.

.. data:: EVAS_CALLBACK_HIDE

    Hide Event.

.. data:: EVAS_CALLBACK_MOVE

    Move Event.

.. data:: EVAS_CALLBACK_RESIZE

    Resize Event.

.. data:: EVAS_CALLBACK_RESTACK

    Restack Event.

.. data:: EVAS_CALLBACK_DEL

    Object Being Deleted (called before Free).

.. data:: EVAS_CALLBACK_HOLD

    Events go on/off hold.

.. data:: EVAS_CALLBACK_CHANGED_SIZE_HINTS

    Size hints changed event.

.. data:: EVAS_CALLBACK_IMAGE_PRELOADED

    Image has been preloaded.

.. data:: EVAS_CALLBACK_CANVAS_FOCUS_IN

    Canvas got focus as a whole.

.. data:: EVAS_CALLBACK_CANVAS_FOCUS_OUT

    Canvas lost focus as a whole.

.. data:: EVAS_CALLBACK_RENDER_FLUSH_PRE

    Called just before rendering is updated on the canvas target.

.. data:: EVAS_CALLBACK_RENDER_FLUSH_POST

    Called just after rendering is updated on the canvas target.

.. data:: EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN

    Canvas object got focus.

.. data:: EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT

    Canvas object lost focus.

.. data:: EVAS_CALLBACK_IMAGE_UNLOADED

    Image data has been unloaded.

.. data:: EVAS_CALLBACK_RENDER_PRE

    Called just before rendering starts on the canvas target.

.. data:: EVAS_CALLBACK_RENDER_POST

    Called just after rendering stops on the canvas target.

.. data:: EVAS_CALLBACK_IMAGE_RESIZE

    Image size is changed.

.. data:: EVAS_CALLBACK_DEVICE_CHANGED

    Devices added, removed or changed on canvas.

.. data:: EVAS_CALLBACK_AXIS_UPDATE

    Input device changed value on some axis. (since 1.13)

.. data:: EVAS_CALLBACK_CANVAS_VIEWPORT_RESIZE

    Canvas viewport resized. (since 1.15)

.. data:: EVAS_CALLBACK_LAST

    kept as last element/sentinel – not really an event.


.. _Evas_Event_Flags:

Evas_Event_Flags
-------------------------------------

.. data:: EVAS_EVENT_FLAG_NONE

    No fancy flags set.

.. data:: EVAS_EVENT_FLAG_ON_HOLD

    This event is being delivered but should be put "on hold" until the on
    hold flag is unset. The event should be used for informational purposes
    and maybe some indications visually, but not actually perform anything

.. data:: EVAS_EVENT_FLAG_ON_SCROLL

    This event flag indicates the event occurs while scrolling; for example,
    DOWN event occurs during scrolling; the event should be used for
    informational purposes and maybe some indications visually, but not
    actually perform anything


.. _Evas_Touch_Point_State:

Evas_Touch_Point_State
-------------------------------------

.. data:: EVAS_TOUCH_POINT_DOWN

    Touch point is pressed down

.. data:: EVAS_TOUCH_POINT_UP

    Touch point is released

.. data:: EVAS_TOUCH_POINT_MOVE

    Touch point is moved

.. data:: EVAS_TOUCH_POINT_STILL

    Touch point is not moved after pressed

.. data:: EVAS_TOUCH_POINT_CANCEL

    Touch point is cancelled


.. _Evas_Font_Hinting_Flags:

Evas_Font_Hinting_Flags
-------------------------------------

.. data:: EVAS_FONT_HINTING_NONE

    No font hinting

.. data:: EVAS_FONT_HINTING_AUTO

    Automatic font hinting

.. data:: EVAS_FONT_HINTING_BYTECODE

    Bytecode font hinting


.. _Evas_Colorspace:

Evas_Colorspace
-------------------------------------

.. data:: EVAS_COLORSPACE_ARGB8888

    ARGB8888

.. data:: EVAS_COLORSPACE_YCBCR422P601_PL

    YCBCR422P601_PL

.. data:: EVAS_COLORSPACE_YCBCR422P709_PL

    YCBCR422P709_PL

.. data:: EVAS_COLORSPACE_RGB565_A5P

    RGB565_A5P

.. data:: EVAS_COLORSPACE_GRY8

    GRY8

.. data:: EVAS_COLORSPACE_YCBCR422601_PL

    YCBCR422601_PL

.. data:: EVAS_COLORSPACE_YCBCR420NV12601_PL

    YCBCR420NV12601_PL

.. data:: EVAS_COLORSPACE_YCBCR420TM12601_PL

    YCBCR420TM12601_PL


.. _Evas_Object_Table_Homogeneous_Mode:

Evas_Object_Table_Homogeneous_Mode
-------------------------------------

How to pack items into cells in a table

.. data:: EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE

    None

.. data:: EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE

    Table

.. data:: EVAS_OBJECT_TABLE_HOMOGENEOUS_ITEM

    Item


.. _Evas_Aspect_Control:

Evas_Aspect_Control
-------------------------------------

.. data:: EVAS_ASPECT_CONTROL_NONE

    Preference on scaling unset

.. data:: EVAS_ASPECT_CONTROL_NEITHER

    Same effect as unset preference on scaling

.. data:: EVAS_ASPECT_CONTROL_HORIZONTAL

    Use all horizontal container space to place an object, using the given
    aspect

.. data:: EVAS_ASPECT_CONTROL_VERTICAL

    Use all vertical container space to place an object, using the given aspect

.. data:: EVAS_ASPECT_CONTROL_BOTH

    Use all horizontal and vertical container spaces to place an object
    (never growing it out of those bounds), using the given aspect


.. _Evas_Display_Mode:

Evas_Display_Mode
-------------------------------------

.. data:: EVAS_DISPLAY_MODE_NONE

    Default mode.

.. data:: EVAS_DISPLAY_MODE_COMPRESS

    Use this mode when you want to give compress display mode hint to an object.

.. data:: EVAS_DISPLAY_MODE_EXPAND

    Use this mode when you want to give expand display mode hint to an object.

.. data:: EVAS_DISPLAY_MODE_DONT_CHANGE

    Use this mode when an object should not change its display mode.


.. _Evas_Load_Error:

Evas_Load_Error
-------------------------------------

.. data:: EVAS_LOAD_ERROR_NONE

    None.

.. data:: EVAS_LOAD_ERROR_GENERIC

    Generic.

.. data:: EVAS_LOAD_ERROR_DOES_NOT_EXIST

    Not exists.

.. data:: EVAS_LOAD_ERROR_PERMISSION_DENIED

    Permission danied.

.. data:: EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED

    Allocation failure.

.. data:: EVAS_LOAD_ERROR_CORRUPT_FILE

    Corrupted file.

.. data:: EVAS_LOAD_ERROR_UNKNOWN_FORMAT

    Unknown format.


.. _Evas_Alloc_Error:

Evas_Alloc_Error
-------------------------------------

.. data:: EVAS_ALLOC_ERROR_NONE

    No allocation error.

.. data:: EVAS_ALLOC_ERROR_FATAL

    Allocation failed despite attempts to free up memory.

.. data:: EVAS_ALLOC_ERROR_RECOVERED

    Allocation succeeded, but extra memory had to be found by freeing up speculative resources.


.. _Evas_Fill_Spread:

XXX
-------------------------------------

.. data:: EVAS_TEXTURE_REFLECT

    Image fill tiling mode - tiling reflects

.. data:: EVAS_TEXTURE_REPEAT

    Image fill tiling mode - tiling reflects

.. data:: EVAS_TEXTURE_RESTRICT

    Tiling clamps - range offset ignored

.. data:: EVAS_TEXTURE_RESTRICT_REFLECT

    Tiling clamps and any range offset reflects

.. data:: EVAS_TEXTURE_RESTRICT_REPEAT

    Tiling clamps and any range offset repeats

.. data:: EVAS_TEXTURE_PAD

    Tiling extends with end values


.. _Evas_Pixel_Import_Pixel_Format:

Evas_Pixel_Import_Pixel_Format
-------------------------------------

.. data:: EVAS_PIXEL_FORMAT_NONE

    No pixel format.

.. data:: EVAS_PIXEL_FORMAT_ARGB32

    ARGB 32bit pixel format with A in the high byte per 32bit pixel word.

.. data:: EVAS_PIXEL_FORMAT_YUV420P_601

    YUV 420 Planar format with CCIR 601 color encoding with contiguous
    planes in the order Y, U and V.


.. _Evas_Native_Surface_Type:

_Evas_Native_Surface_Type
-------------------------------------

.. data:: EVAS_NATIVE_SURFACE_NONE

    No surface type.

.. data:: EVAS_NATIVE_SURFACE_X11

    X Window system based type.

.. data:: EVAS_NATIVE_SURFACE_OPENGL

    OpenGL system based type.

.. data:: EVAS_NATIVE_SURFACE_WL

    Wayland system based type.


.. _Evas_Render_Op:

Evas_Render_Op
-------------------------------------

.. data:: EVAS_RENDER_BLEND

    default op: d = d*(1-sa) + s

.. data:: EVAS_RENDER_BLEND_REL

    d = d*(1 - sa) + s*da

.. data:: EVAS_RENDER_COPY

    d = s

.. data:: EVAS_RENDER_COPY_REL

    d = s*da

.. data:: EVAS_RENDER_ADD

    Unknown

.. data:: EVAS_RENDER_ADD_REL

    d = d + s*da

.. data:: EVAS_RENDER_SUB

    d = d - s

.. data:: EVAS_RENDER_SUB_REL

    Unknown

.. data:: EVAS_RENDER_TINT

    d = d*s + d*(1 - sa) + s*(1 - da)

.. data:: EVAS_RENDER_TINT_REL

    d = d*(1 - sa + s)

.. data:: EVAS_RENDER_MASK

    d = d*sa

.. data:: EVAS_RENDER_MUL

    d = d*s


.. _Evas_Border_Fill_Mode:

Evas_Border_Fill_Mode
-------------------------------------

.. data:: EVAS_BORDER_FILL_NONE

    None

.. data:: EVAS_BORDER_FILL_DEFAULT

    Default

.. data:: EVAS_BORDER_FILL_SOLID

    Solid


.. _Evas_Image_Scale_Hint:

Evas_Image_Scale_Hint
-------------------------------------

.. data:: EVAS_IMAGE_SCALE_HINT_NONE

    None

.. data:: EVAS_IMAGE_SCALE_HINT_DYNAMIC

    Dynamic

.. data:: EVAS_IMAGE_SCALE_HINT_STATIC

    Static


.. _Evas_Image_Animated_Loop_Hint:

Evas_Image_Animated_Loop_Hint
-------------------------------------

.. data:: EVAS_IMAGE_ANIMATED_HINT_NONE

    None

.. data:: EVAS_IMAGE_ANIMATED_HINT_LOOP

    Loop

.. data:: EVAS_IMAGE_ANIMATED_HINT_PINGPONG

    Pingpong


.. _Evas_Image_Orient:

Evas_Image_Orient
-------------------------------------

.. versionadded:: 1.14

.. data:: EVAS_IMAGE_ORIENT_NONE

    No orientation change

.. data:: EVAS_IMAGE_ORIENT_0

    No orientation change

.. data:: EVAS_IMAGE_ORIENT_90

    Orient 90 degrees clockwise

.. data:: EVAS_IMAGE_ORIENT_180

    Orient 180 degrees clockwise

.. data:: EVAS_IMAGE_ORIENT_270

    Rotate 90 degrees counter-clockwise (i.e. 270 degrees clockwise)

.. data:: EVAS_IMAGE_FLIP_HORIZONTAL

    Flip image horizontally

.. data:: EVAS_IMAGE_FLIP_VERTICAL

    Flip image vertically

.. data:: EVAS_IMAGE_FLIP_TRANSPOSE

    Flip image along the y = (width - x) line (bottom-left to top-right)

.. data:: EVAS_IMAGE_FLIP_TRANSVERSE

    Flip image along the y = x line (top-left to bottom-right)


.. _Evas_Engine_Render_Mode:

Evas_Engine_Render_Mode
-------------------------------------

.. data:: EVAS_RENDER_MODE_BLOCKING

    The rendering is blocking mode.

.. data:: EVAS_RENDER_MODE_NONBLOCKING

    The rendering is non blocking mode.


.. _Evas_Image_Content_Hint:

Evas_Image_Content_Hint
-------------------------------------

.. data:: EVAS_IMAGE_CONTENT_HINT_NONE

    No hint at all.

.. data:: EVAS_IMAGE_CONTENT_HINT_DYNAMIC

    The contents will change over time.

.. data:: EVAS_IMAGE_CONTENT_HINT_STATIC

    The contents won't change over time.


.. _Evas_Device_Class:

Evas_Device_Class
-------------------------------------

.. data:: EVAS_DEVICE_CLASS_NONE

    Not a device.

.. data:: EVAS_DEVICE_CLASS_SEAT

    The user/seat (the user themselves)

.. data:: EVAS_DEVICE_CLASS_KEYBOARD

    A regular keyboard, numberpad or attached buttons.

.. data:: EVAS_DEVICE_CLASS_MOUSE

    A mouse, trackball or touchpad relative motion device.

.. data:: EVAS_DEVICE_CLASS_TOUCH

    A touchscreen with fingers or stylus.

.. data:: EVAS_DEVICE_CLASS_PEN

    A special pen device.

.. data:: EVAS_DEVICE_CLASS_POINTER

    A laser pointer, wii-style or "minority report" pointing device.

.. data:: EVAS_DEVICE_CLASS_GAMEPAD

    A gamepad controller or joystick.


.. _Evas_Object_Pointer_Mode:

Evas_Object_Pointer_Mode
-------------------------------------

.. data:: EVAS_OBJECT_POINTER_MODE_AUTOGRAB

    default, X11-like

.. data:: EVAS_OBJECT_POINTER_MODE_NOGRAB

    pointer always bound to the object right below it

.. data:: EVAS_OBJECT_POINTER_MODE_NOGRAB_NO_REPEAT_UPDOWN

    useful on object with "repeat events" enabled, where mouse/touch up and
    down events WONT be repeated to objects and these objects wont be
    auto-grabbed.


.. _Evas_Text_Style_Type:

Evas_Text_Style_Type
-------------------------------------

.. data:: EVAS_TEXT_STYLE_PLAIN

    plain

.. data:: EVAS_TEXT_STYLE_SHADOW

    shadow

.. data:: EVAS_TEXT_STYLE_OUTLINE

    outline

.. data:: EVAS_TEXT_STYLE_SOFT_OUTLINE

    soft outline

.. data:: EVAS_TEXT_STYLE_GLOW

    glow

.. data:: EVAS_TEXT_STYLE_OUTLINE_SHADOW

    outline shadow

.. data:: EVAS_TEXT_STYLE_FAR_SHADOW

    far shadow

.. data:: EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW

    outline soft shadow

.. data:: EVAS_TEXT_STYLE_SOFT_SHADOW

    soft shadow

.. data:: EVAS_TEXT_STYLE_FAR_SOFT_SHADOW

    far soft shadow

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM_RIGHT

    shadow direction bottom right

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM

    shadow direction bottom

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_BOTTOM_LEFT

    shadow direction bottom left

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_LEFT

    shadow direction left

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP_LEFT

    shadow direction top left

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP

    shadow direction top

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_TOP_RIGHT

    shadow direction top right

.. data:: EVAS_TEXT_STYLE_SHADOW_DIRECTION_RIGHT

    shadow direction right


.. _Evas_Textblock_Text_Type:

Evas_Textblock_Text_Type
-------------------------------------

.. data:: EVAS_TEXTBLOCK_TEXT_RAW

    Textblock text of type raw.

.. data:: EVAS_TEXTBLOCK_TEXT_PLAIN

    Textblock text of type plain.

.. data:: EVAS_TEXTBLOCK_TEXT_MARKUP

    Textblock text of type markup.


.. _Evas_Textblock_Cursor_Type:

Evas_Textblock_Cursor_Type
-------------------------------------

.. data:: EVAS_TEXTBLOCK_CURSOR_UNDER

    Cursor type is under.

.. data:: EVAS_TEXTBLOCK_CURSOR_BEFORE

    Cursor type is before.


.. _Evas_Textgrid_Palette:

Textgrid Palette
----------------

The palette to use for the foreground and background colors.

.. data:: EVAS_TEXTGRID_PALETTE_NONE

    No palette is used.

.. data:: EVAS_TEXTGRID_PALETTE_STANDARD

    Standard palette (around 16 colors).

.. data:: EVAS_TEXTGRID_PALETTE_EXTENDED

    Extended palette (at max 256 colors).

.. data:: EVAS_TEXTGRID_PALETTE_LAST

    Ignore it.


.. _Evas_Textgrid_Font_Style:

Textgrid Font Style
-------------------

The style to give to each character of the grid.

.. data:: EVAS_TEXTGRID_FONT_STYLE_NORMAL

    Normal style.

.. data:: EVAS_TEXTGRID_FONT_STYLE_BOLD

    Bold style.

.. data:: EVAS_TEXTGRID_FONT_STYLE_ITALIC

    Oblique style.


Module level functions
======================

"""


from efl.utils.conversions cimport eina_list_strings_to_python_list
from efl.eina cimport EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, EINA_LOG_DOM_WARN, \
    EINA_LOG_DOM_ERR, EINA_LOG_DOM_CRIT
from efl.utils.logger cimport add_logger

cdef int PY_EFL_EVAS_LOG_DOMAIN = add_logger(__name__).eina_log_domain

import atexit


# TODO doc
EVAS_HINT_FILL = -1.0
EVAS_HINT_EXPAND = 1.0

EXPAND_BOTH  = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
EXPAND_VERT  = 0.0, EVAS_HINT_EXPAND
FILL_BOTH  = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_HORIZ = EVAS_HINT_FILL, 0.5
FILL_VERT  = 0.5, EVAS_HINT_FILL


def init():
    EINA_LOG_DOM_INFO(PY_EFL_EVAS_LOG_DOMAIN, "Initializing efl.evas", NULL)

    if evas_object_event_callbacks_len != EVAS_CALLBACK_LAST:
        raise SystemError("Number of object callbacks changed from %d to %d." %
                          (evas_object_event_callbacks_len, EVAS_CALLBACK_LAST))
    if evas_canvas_event_callbacks_len != EVAS_CALLBACK_LAST:
        raise SystemError("Number of canvas callbacks changed from %d to %d." %
                          (evas_canvas_event_callbacks_len, EVAS_CALLBACK_LAST))
    return evas_init()


def shutdown():
    EINA_LOG_DOM_INFO(PY_EFL_EVAS_LOG_DOMAIN, "Shutting down efl.evas", NULL)
    return evas_shutdown()


def render_method_lookup(name):
    """Lookup render method and return its id (> 0 if found).

    :param name: Render method
    :type name: string
    :return: ID
    :rtype: int

    """
    if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
    return evas_render_method_lookup(
        <const char *>name if name is not None else NULL)


def render_method_list():
    """Returns a list of render method names.

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

def font_path_global_clear():
    """Removes all font paths loaded

    .. versionadded: 1.10

    """
    evas_font_path_global_clear()

def font_path_global_append(path):
    """Appends a font path to the list of font paths used by the application

    .. versionadded: 1.10

    """
    if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
    evas_font_path_global_append(
        <const char *>path if path is not None else NULL)

def font_path_global_prepend(path):
    """Prepends a font path to the list of font paths used by the application

    .. versionadded: 1.10

    """
    if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
    evas_font_path_global_prepend(
        <const char *>path if path is not None else NULL)

def font_path_global_list():
    """Retrieves the list of font paths used by the application

    .. versionadded: 1.10

    """
    return eina_list_strings_to_python_list(evas_font_path_global_list())



class EvasLoadError(Exception):
    def __init__(self, int code, filename, key):
        if code == EVAS_LOAD_ERROR_NONE:
            msg = "No error on load"
        elif code == EVAS_LOAD_ERROR_GENERIC:
            msg = "A non-specific error occurred"
        elif code == EVAS_LOAD_ERROR_DOES_NOT_EXIST:
            msg = "File (or file path) does not exist"
        elif code == EVAS_LOAD_ERROR_PERMISSION_DENIED:
            msg = "Permission denied to an existing file (or path)"
        elif code == EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED:
            msg = "Allocation of resources failure prevented load"
        elif code == EVAS_LOAD_ERROR_CORRUPT_FILE:
            msg = "File corrupt (but was detected as a known format)"
        elif code == EVAS_LOAD_ERROR_UNKNOWN_FORMAT:
            msg = "File is not in a known format"
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
# Disable evas smart object for the moment, because PyMethod_New is broken
# in recent Cython versions, at least in Cython 0.21.1/2 using py3.
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
atexit.register(shutdown)
