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
#

"""

Enumerations
------------

.. _Elm_Policy:

Policy types
============

.. data:: ELM_POLICY_QUIT

    Under which circumstances the application should quit automatically.


.. _Elm_Policy_Quit:

Quit policy types
=================

.. data:: ELM_POLICY_QUIT_NONE

    Never quit the application automatically

.. data:: ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

    Quit when the application's last window is closed


"""

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String, \
    PyMem_Malloc, PyMem_Free

from efl.utils.conversions cimport _touni, _ctouni, \
    python_list_strings_to_eina_list, \
    eina_list_strings_to_python_list

import sys
import traceback
import logging

cimport enums

ELM_POLICY_QUIT = enums.ELM_POLICY_QUIT

ELM_POLICY_QUIT_NONE = enums.ELM_POLICY_QUIT_NONE
ELM_POLICY_QUIT_LAST_WINDOW_CLOSED = enums.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

###
# NOTE: Is there reason we have these around?
ELM_CURSOR_X                   = "x"
ELM_CURSOR_ARROW               = "arrow"
ELM_CURSOR_BASED_ARROW_DOWN    = "based_arrow_down"
ELM_CURSOR_BASED_ARROW_UP      = "based_arrow_up"
ELM_CURSOR_BOAT                = "boat"
ELM_CURSOR_BOGOSITY            = "bogosity"
ELM_CURSOR_BOTTOM_LEFT_CORNER  = "bottom_left_corner"
ELM_CURSOR_BOTTOM_RIGHT_CORNER = "bottom_right_corner"
ELM_CURSOR_BOTTOM_SIDE         = "bottom_side"
ELM_CURSOR_BOTTOM_TEE          = "bottom_tee"
ELM_CURSOR_BOX_SPIRAL          = "box_spiral"
ELM_CURSOR_CENTER_PTR          = "center_ptr"
ELM_CURSOR_CIRCLE              = "circle"
ELM_CURSOR_CLOCK               = "clock"
ELM_CURSOR_COFFEE_MUG          = "coffee_mug"
ELM_CURSOR_CROSS               = "cross"
ELM_CURSOR_CROSS_REVERSE       = "cross_reverse"
ELM_CURSOR_CROSSHAIR           = "crosshair"
ELM_CURSOR_DIAMOND_CROSS       = "diamond_cross"
ELM_CURSOR_DOT                 = "dot"
ELM_CURSOR_DOT_BOX_MASK        = "dot_box_mask"
ELM_CURSOR_DOUBLE_ARROW        = "double_arrow"
ELM_CURSOR_DRAFT_LARGE         = "draft_large"
ELM_CURSOR_DRAFT_SMALL         = "draft_small"
ELM_CURSOR_DRAPED_BOX          = "draped_box"
ELM_CURSOR_EXCHANGE            = "exchange"
ELM_CURSOR_FLEUR               = "fleur"
ELM_CURSOR_GOBBLER             = "gobbler"
ELM_CURSOR_GUMBY               = "gumby"
ELM_CURSOR_HAND1               = "hand1"
ELM_CURSOR_HAND2               = "hand2"
ELM_CURSOR_HEART               = "heart"
ELM_CURSOR_ICON                = "icon"
ELM_CURSOR_IRON_CROSS          = "iron_cross"
ELM_CURSOR_LEFT_PTR            = "left_ptr"
ELM_CURSOR_LEFT_SIDE           = "left_side"
ELM_CURSOR_LEFT_TEE            = "left_tee"
ELM_CURSOR_LEFTBUTTON          = "leftbutton"
ELM_CURSOR_LL_ANGLE            = "ll_angle"
ELM_CURSOR_LR_ANGLE            = "lr_angle"
ELM_CURSOR_MAN                 = "man"
ELM_CURSOR_MIDDLEBUTTON        = "middlebutton"
ELM_CURSOR_MOUSE               = "mouse"
ELM_CURSOR_PENCIL              = "pencil"
ELM_CURSOR_PIRATE              = "pirate"
ELM_CURSOR_PLUS                = "plus"
ELM_CURSOR_QUESTION_ARROW      = "question_arrow"
ELM_CURSOR_RIGHT_PTR           = "right_ptr"
ELM_CURSOR_RIGHT_SIDE          = "right_side"
ELM_CURSOR_RIGHT_TEE           = "right_tee"
ELM_CURSOR_RIGHTBUTTON         = "rightbutton"
ELM_CURSOR_RTL_LOGO            = "rtl_logo"
ELM_CURSOR_SAILBOAT            = "sailboat"
ELM_CURSOR_SB_DOWN_ARROW       = "sb_down_arrow"
ELM_CURSOR_SB_H_DOUBLE_ARROW   = "sb_h_double_arrow"
ELM_CURSOR_SB_LEFT_ARROW       = "sb_left_arrow"
ELM_CURSOR_SB_RIGHT_ARROW      = "sb_right_arrow"
ELM_CURSOR_SB_UP_ARROW         = "sb_up_arrow"
ELM_CURSOR_SB_V_DOUBLE_ARROW   = "sb_v_double_arrow"
ELM_CURSOR_SHUTTLE             = "shuttle"
ELM_CURSOR_SIZING              = "sizing"
ELM_CURSOR_SPIDER              = "spider"
ELM_CURSOR_SPRAYCAN            = "spraycan"
ELM_CURSOR_STAR                = "star"
ELM_CURSOR_TARGET              = "target"
ELM_CURSOR_TCROSS              = "tcross"
ELM_CURSOR_TOP_LEFT_ARROW      = "top_left_arrow"
ELM_CURSOR_TOP_LEFT_CORNER     = "top_left_corner"
ELM_CURSOR_TOP_RIGHT_CORNER    = "top_right_corner"
ELM_CURSOR_TOP_SIDE            = "top_side"
ELM_CURSOR_TOP_TEE             = "top_tee"
ELM_CURSOR_TREK                = "trek"
ELM_CURSOR_UL_ANGLE            = "ul_angle"
ELM_CURSOR_UMBRELLA            = "umbrella"
ELM_CURSOR_UR_ANGLE            = "ur_angle"
ELM_CURSOR_WATCH               = "watch"
ELM_CURSOR_XTERM               = "xterm"

cdef class FontProperties(object):

    """Elementary font properties"""

    cdef Elm_Font_Properties *efp

    property name:
        """:type: unicode"""
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.efp.name = value

        def __get__(self):
            return _ctouni(self.efp.name)

    property styles:
        """:type: list of strings"""
        def __set__(self, value):
            self.efp.styles = python_list_strings_to_eina_list(value)

        def __get__(self):
            return eina_list_strings_to_python_list(self.efp.styles)


def init():
    """Initialize Elementary"""
    logging.basicConfig(level=logging.DEBUG)
    log = logging.getLogger("elementary")
    log.propagate = False
    log.addHandler(logging.NullHandler())

    # FIXME: Why pass the cl args to elm_init?
    cdef int argc, i, arg_len
    cdef char **argv, *arg

    argc = len(sys.argv)
    argv = <char **>PyMem_Malloc(argc * sizeof(char *))
    for i in range(argc):
        t = sys.argv[i]
        if isinstance(t, unicode): t = PyUnicode_AsUTF8String(t)
        arg = t
        arg_len = len(arg)
        argv[i] = <char *>PyMem_Malloc(arg_len + 1)
        memcpy(argv[i], arg, arg_len + 1)

    elm_init(argc, argv)

def shutdown():
    """Shutdown Elementary"""
    elm_shutdown()

def run():
    """Begin main loop"""
    with nogil:
        elm_run()

def exit():
    """Exit main loop"""
    elm_exit()

def policy_set(Elm_Policy policy, value):
    """policy_set(Elm_Policy policy, value) -> bool

    Set new policy value.

    This will emit the ecore event ELM_EVENT_POLICY_CHANGED in the main
    loop giving the event information Elm_Event_Policy_Changed with
    policy identifier, new and old values.

    :param policy: policy identifier as in Elm_Policy.
    :type policy: :ref:`Elm_Policy`
    :param value: policy value, depends on identifiers, usually there is
        an enumeration with the same prefix as the policy name, for
        example: ELM_POLICY_QUIT and Elm_Policy_Quit
        (ELM_POLICY_QUIT_NONE, ELM_POLICY_QUIT_LAST_WINDOW_CLOSED).
    :type value: :ref:`Elm_Policy_Quit`

    :return: True on success or False on error (right
        now just invalid policy identifier, but in future policy
        value might be enforced).

    """
    return bool(elm_policy_set(policy, value))

def policy_get(Elm_Policy policy):
    """policy_get(Elm_Policy policy) -> value

    Gets the policy value set for given identifier.

    :param policy: policy identifier as in Elm_Policy.
    :type policy: :ref:`Elm_Policy`

    :return: policy value. Will be 0 if policy identifier is invalid.
    :rtype: :ref:`Elm_Policy_Quit`

    """
    return elm_policy_get(policy)

def coords_finger_size_adjust(int times_w, int w, int times_h, int h):
    """coords_finger_size_adjust(int times_w, int w, int times_h, int h) -> tuple

    Adjust size of an element for finger usage.

    :param times_w: How many fingers should fit horizontally
    :type times_w: int
    :param w: Width size to adjust
    :type w: int
    :param times_h: How many fingers should fit vertically
    :type times_h: int
    :param h: Height size to adjust
    :type h: int

    :return: The adjusted width and height
    :rtype: (int **w**, int **h**)

    This takes width and height sizes (in pixels) as input and a
    size multiple (which is how many fingers you want to place
    within the area, being "finger" the size set by
    elm_config_finger_size_set()), and adjusts the size to be large enough
    to accommodate the resulting size -- if it doesn't already
    accommodate it.

    .. note:: This is kind of low level Elementary call, most useful
        on size evaluation times for widgets. An external user wouldn't
        be calling, most of the time.

    """
    cdef Evas_Coord width = w, height = h
    elm_coords_finger_size_adjust(times_w, &width, times_h, &height)
    return (width, height)

def cache_all_flush():
    """cache_all_flush()

    Frees all data that was in cache and is not currently being used to reduce
    memory usage. This frees Edje's, Evas' and Eet's cache.

    .. note:: Evas caches are flushed for every canvas associated with a window.

    """
    elm_cache_all_flush()

# XXX: These create some weird parsing error in Cython
# def font_properties_get(font):
#     """Translate a font (family) name string in fontconfig's font names
#     syntax into a FontProperties object.

#     :param font: The font name and styles string
#     :return: the font properties object

#     .. note:: The reverse translation can be achieved with
#         :py:func:`font_fontconfig_name_get`, for one style only (single font
#         instance, not family).

#     """
#     if isinstance(font, unicode): font = PyUnicode_AsUTF8String(font)
#     cdef:
#         Elm_Font_Properties *efp
#         FontProperties ret = FontProperties.__new__()

    #ret.efp = elm_font_properties_get(<const char *>font if font is not None else NULL)

    # elm_font_properties_free(efp)
    # return ret

# def font_fontconfig_name_get(font_name, style = None):
#     """font_fontconfig_name_get(unicode font_name, unicode style = None) -> unicode

#     Translate a font name, bound to a style, into fontconfig's font names
#     syntax.

#     :param font_name: The font (family) name
#     :param style: The given style (may be None)

#     :return: the font name and style string

#     .. note:: The reverse translation can be achieved with
#         :py:func:`font_properties_get`, for one style only (single font
#         instance, not family).

#     """
#     cdef:
#         unicode ret
#         char *fc_name
#     if isinstance(font_name, unicode): font_name = PyUnicode_AsUTF8String(font_name)
#     if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
#     fc_name = elm_font_fontconfig_name_get(<const char *>font_name,
#         <const char *>style if style is not None else NULL))

#     ret = _touni(fc_name)
#     elm_font_fontconfig_name_free(fc_name)
#     return ret

# TODO: Create an Eina_Hash -> dict conversion function for this
# def font_available_hash_add(list):
#     """Create a font hash table of available system fonts.

#     One must call it with ``list`` being the return value of
#     evas_font_available_list(). The hash will be indexed by font
#     (family) names, being its values ``Elm_Font_Properties`` blobs.

#     :param list: The list of available system fonts, as returned by
#     evas_font_available_list().
#     :return: the font hash.

#     .. note:: The user is supposed to get it populated at least with 3
#     default font families (Sans, Serif, Monospace), which should be
#     present on most systems.

#     """
#     EAPI Eina_Hash *elm_font_available_hash_add(Eina_List *list)


#     """Free the hash returned by elm_font_available_hash_add().

#     :param hash: the hash to be freed.

#     """
#     elm_font_available_hash_del(Eina_Hash *hash)

