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

from efl.utils.conversions cimport eina_list_strings_to_python_list
from efl.eina cimport EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, EINA_LOG_DOM_WARN
from efl.utils.logger cimport add_logger

cdef int PY_EFL_EVAS_LOG_DOMAIN = add_logger(__name__).eina_log_domain


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
    # when changing these, also change __init__.py!
#     if evas_object_event_callbacks_len != EVAS_CALLBACK_LAST:
#         raise SystemError("Number of object callbacks changed from %d to %d." %
#                           (evas_object_event_callbacks_len, EVAS_CALLBACK_LAST))
#     if evas_canvas_event_callbacks_len != EVAS_CALLBACK_LAST:
#         raise SystemError("Number of canvas callbacks changed from %d to %d." %
#                           (evas_canvas_event_callbacks_len, EVAS_CALLBACK_LAST))
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
# include "efl.evas_object_smart.pxi"
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
