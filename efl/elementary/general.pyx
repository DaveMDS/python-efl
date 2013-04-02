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

.. rubric:: Policy types

.. data:: ELM_POLICY_QUIT

    Under which circumstances the application should quit automatically.


.. rubric:: Quit policy types

.. data:: ELM_POLICY_QUIT_NONE

    Never quit the application automatically

.. data:: ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

    Quit when the application's last window is closed


"""

from cpython cimport PyObject, Py_INCREF, Py_DECREF
from cpython cimport PyMem_Malloc, PyMem_Free
from cpython cimport bool

from efl.eo cimport _touni, _ctouni

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
    for i from 0 <= i < argc:
        arg = sys.argv[i]
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

def policy_set(policy, value):
    """Set new policy value.

    This will emit the ecore event ELM_EVENT_POLICY_CHANGED in the main
    loop giving the event information Elm_Event_Policy_Changed with
    policy identifier, new and old values.

    :param policy: policy identifier as in Elm_Policy.
    :param value: policy value, depends on identifiers, usually there is
        an enumeration with the same prefix as the policy name, for
        example: ELM_POLICY_QUIT and Elm_Policy_Quit
        (ELM_POLICY_QUIT_NONE, ELM_POLICY_QUIT_LAST_WINDOW_CLOSED).

    :return: True on success or False on error (right
        now just invalid policy identifier, but in future policy
        value might be enforced).

    """
    return elm_policy_set(policy, value)

def policy_get(policy):
    """Gets the policy value set for given identifier.

    :param policy: policy identifier as in Elm_Policy.

    :return: policy value. Will be 0 if policy identifier is invalid.

    """
    return elm_policy_get(policy)

def coords_finger_size_adjust(times_w, w, times_h, h):
    cdef Evas_Coord width
    cdef Evas_Coord height
    width = w
    height = h
    elm_coords_finger_size_adjust(times_w, &width, times_h, &height)

def cache_all_flush():
    """cache_all_flush()

    Frees all data that was in cache and is not currently being used to reduce
    memory usage. This frees Edje's, Evas' and Eet's cache.

    .. note:: Evas caches are flushed for every canvas associated with a window.

    """
    elm_cache_all_flush()
