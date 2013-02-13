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

from cpython cimport PyObject, Py_INCREF, Py_DECREF
from cpython cimport PyMem_Malloc, PyMem_Free
from cpython cimport bool

from efl.eo cimport _touni, _fruni, _ctouni, _cfruni, PY_REFCOUNT
from efl.eo cimport object_from_instance, _object_mapping_register
from efl.eo cimport _strings_to_python, _strings_from_python
from efl.eo cimport _object_list_to_python
# from efl.evas cimport Evas_Coord


#import evas.c_evas
# from evas.c_evas import _object_mapping_register
# from evas.c_evas import _object_mapping_unregister
import sys
import traceback
import logging


logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger("elementary")


cdef _METHOD_DEPRECATED(self, replacement=None, message=None):
    stack = traceback.extract_stack()
    caller = stack[-1]
    caller_module, caller_line, caller_name, caller_code = caller
    if caller_code:
        msg = "%s:%s %s (class %s) is deprecated." % \
            (caller_module, caller_line, caller_code,
            self.__class__.__name__ if self else 'None')
    else:
        msg = "%s:%s %s.%s() is deprecated." % \
            (caller_module, caller_line,
            self.__class__.__name__ if self else 'None', caller_name)
    if replacement:
        msg += " Use %s() instead." % (replacement,)
    if message:
        msg += " " + message
    log.warn(msg)



ELM_ACTIONSLIDER_NONE = 0
ELM_ACTIONSLIDER_LEFT = 1 << 0
ELM_ACTIONSLIDER_CENTER = 1 << 1
ELM_ACTIONSLIDER_RIGHT = 1 << 2
ELM_ACTIONSLIDER_ALL = (1 << 3) - 1

ELM_BG_OPTION_CENTER = 0
ELM_BG_OPTION_SCALE = 1
ELM_BG_OPTION_STRETCH = 2
ELM_BG_OPTION_TILE = 3
ELM_BG_OPTION_LAST = 4

ELM_BOX_LAYOUT_HORIZONTAL = 0
ELM_BOX_LAYOUT_VERTICAL = 1
ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL = 2
ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL = 3
ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL = 4
ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL = 5
ELM_BOX_LAYOUT_FLOW_HORIZONTAL = 6
ELM_BOX_LAYOUT_FLOW_VERTICAL = 7
ELM_BOX_LAYOUT_STACK = 8

ELM_BUBBLE_POS_TOP_LEFT = 0
ELM_BUBBLE_POS_TOP_RIGHT = 1
ELM_BUBBLE_POS_BOTTOM_LEFT = 2
ELM_BUBBLE_POS_BOTTOM_RIGHT = 3

ELM_CALENDAR_UNIQUE = 0
ELM_CALENDAR_DAILY = 1
ELM_CALENDAR_WEEKLY = 2
ELM_CALENDAR_MONTHLY = 3
ELM_CALENDAR_ANNUALLY = 4
ELM_CALENDAR_LAST_DAY_OF_MONTH = 5

ELM_CALENDAR_SELECT_MODE_DEFAULT = 0
ELM_CALENDAR_SELECT_MODE_ALWAYS = 1
ELM_CALENDAR_SELECT_MODE_NONE = 2
ELM_CALENDAR_SELECT_MODE_ONDEMAND = 3

ELM_CLOCK_EDIT_DEFAULT = 0
ELM_CLOCK_EDIT_HOUR_DECIMAL = 1 << 0
ELM_CLOCK_EDIT_HOUR_UNIT = 1 << 1
ELM_CLOCK_EDIT_MIN_DECIMAL = 1 << 2
ELM_CLOCK_EDIT_MIN_UNIT = 1 << 3
ELM_CLOCK_EDIT_SEC_DECIMAL = 1 << 4
ELM_CLOCK_EDIT_SEC_UNIT = 1 << 5
ELM_CLOCK_EDIT_ALL = (1 << 6) - 1

ELM_CNP_MODE_MARKUP = 0
ELM_CNP_MODE_NO_IMAGE = 1
ELM_CNP_MODE_PLAINTEXT = 2

ELM_COLORSELECTOR_PALETTE = 0
ELM_COLORSELECTOR_COMPONENTS = 1
ELM_COLORSELECTOR_BOTH = 2

ELM_CTXPOPUP_DIRECTION_DOWN = 0
ELM_CTXPOPUP_DIRECTION_RIGHT = 1
ELM_CTXPOPUP_DIRECTION_LEFT = 2
ELM_CTXPOPUP_DIRECTION_UP = 3
ELM_CTXPOPUP_DIRECTION_UNKNOWN = 4

ELM_DATETIME_YEAR    = 0
ELM_DATETIME_MONTH   = 1
ELM_DATETIME_DATE    = 2
ELM_DATETIME_HOUR    = 3
ELM_DATETIME_MINUTE  = 4
ELM_DATETIME_AMPM    = 5

ELM_DAY_SUNDAY = 0
ELM_DAY_MONDAY = 1
ELM_DAY_TUESDAY = 2
ELM_DAY_WEDNESDAY = 3
ELM_DAY_THURSDAY = 4
ELM_DAY_FRIDAY = 5
ELM_DAY_SATURDAY = 6
ELM_DAY_LAST = 7

ELM_DAYSELECTOR_SUN = 0
ELM_DAYSELECTOR_MON = 1
ELM_DAYSELECTOR_TUE = 2
ELM_DAYSELECTOR_WED = 3
ELM_DAYSELECTOR_THU = 4
ELM_DAYSELECTOR_FRI = 5
ELM_DAYSELECTOR_SAT = 6

ELM_FILESELECTOR_LIST = 0
ELM_FILESELECTOR_GRID = 1

ELM_FLIP_DIRECTION_UP = 0
ELM_FLIP_DIRECTION_DOWN = 1
ELM_FLIP_DIRECTION_LEFT = 2
ELM_FLIP_DIRECTION_RIGHT = 3

ELM_FLIP_INTERACTION_NONE = 0
ELM_FLIP_INTERACTION_ROTATE = 1
ELM_FLIP_INTERACTION_CUBE = 2
ELM_FLIP_INTERACTION_PAGE = 3

ELM_FLIP_ROTATE_Y_CENTER_AXIS = 0
ELM_FLIP_ROTATE_X_CENTER_AXIS = 1
ELM_FLIP_ROTATE_XZ_CENTER_AXIS = 2
ELM_FLIP_ROTATE_YZ_CENTER_AXIS = 3
ELM_FLIP_CUBE_LEFT = 4
ELM_FLIP_CUBE_RIGHT = 5
ELM_FLIP_CUBE_UP = 6
ELM_FLIP_CUBE_DOWN = 7
ELM_FLIP_PAGE_LEFT = 8
ELM_FLIP_PAGE_RIGHT = 9
ELM_FLIP_PAGE_UP = 10
ELM_FLIP_PAGE_DOWN = 11

ELM_FOCUS_PREVIOUS = 0
ELM_FOCUS_NEXT = 1

ELM_GENLIST_ITEM_NONE = 0
ELM_GENLIST_ITEM_TREE = 1
ELM_GENLIST_ITEM_GROUP = 2
ELM_GENLIST_ITEM_MAX = 3

ELM_GENLIST_ITEM_FIELD_ALL = 0
ELM_GENLIST_ITEM_FIELD_TEXT = 1
ELM_GENLIST_ITEM_FIELD_CONTENT = 2
ELM_GENLIST_ITEM_FIELD_STATE = 3

ELM_GENLIST_ITEM_SCROLLTO_NONE = 0
ELM_GENLIST_ITEM_SCROLLTO_IN = 1
ELM_GENLIST_ITEM_SCROLLTO_TOP = 2
ELM_GENLIST_ITEM_SCROLLTO_MIDDLE = 3

ELM_GESTURE_STATE_UNDEFINED = -1
ELM_GESTURE_STATE_START = 0
ELM_GESTURE_STATE_MOVE = 1
ELM_GESTURE_STATE_END = 2
ELM_GESTURE_STATE_ABORT = 3

ELM_GESTURE_FIRST = 0
ELM_GESTURE_N_TAPS = 1
ELM_GESTURE_N_LONG_TAPS = 2
ELM_GESTURE_N_DOUBLE_TAPS = 3
ELM_GESTURE_N_TRIPLE_TAPS = 4
ELM_GESTURE_MOMENTUM = 5
ELM_GESTURE_N_LINES = 6
ELM_GESTURE_N_FLICKS = 7
ELM_GESTURE_ZOOM = 8
ELM_GESTURE_ROTATE = 9

ELM_HOVER_AXIS_NONE = 0
ELM_HOVER_AXIS_HORIZONTAL = 1
ELM_HOVER_AXIS_VERTICAL = 2
ELM_HOVER_AXIS_BOTH = 3

ELM_ICON_NONE = 0
ELM_ICON_FILE = 1
ELM_ICON_STANDARD = 2

ELM_ILLUME_COMMAND_FOCUS_BACK = 0
ELM_ILLUME_COMMAND_FOCUS_FORWARD = 1
ELM_ILLUME_COMMAND_FOCUS_HOME = 2
ELM_ILLUME_COMMAND_CLOSE = 3

ELM_IMAGE_ORIENT_NONE = 0
ELM_IMAGE_ORIENT_0 = 0
ELM_IMAGE_ROTATE_90 = 1
ELM_IMAGE_ROTATE_180 = 2
ELM_IMAGE_ROTATE_270 = 3
ELM_IMAGE_FLIP_HORIZONTAL = 4
ELM_IMAGE_FLIP_VERTICAL = 5
ELM_IMAGE_FLIP_TRANSPOSE = 6
ELM_IMAGE_FLIP_TRANSVERSE = 7

ELM_INPUT_PANEL_LANG_AUTOMATIC = 0
ELM_INPUT_PANEL_LANG_ALPHABET = 1

ELM_INPUT_PANEL_LAYOUT_NORMAL = 0
ELM_INPUT_PANEL_LAYOUT_NUMBER = 1
ELM_INPUT_PANEL_LAYOUT_EMAIL = 2
ELM_INPUT_PANEL_LAYOUT_URL = 3
ELM_INPUT_PANEL_LAYOUT_PHONENUMBER = 4
ELM_INPUT_PANEL_LAYOUT_IP = 5
ELM_INPUT_PANEL_LAYOUT_MONTH = 6
ELM_INPUT_PANEL_LAYOUT_NUMBERONLY = 7
ELM_INPUT_PANEL_LAYOUT_INVALID = 8
ELM_INPUT_PANEL_LAYOUT_HEX = 9
ELM_INPUT_PANEL_LAYOUT_TERMINAL = 10
ELM_INPUT_PANEL_LAYOUT_PASSWORD = 11

ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT = 0
ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE = 1
ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO = 2
ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN = 3
ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN = 4
ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT = 5
ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH = 6
ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND = 7

ELM_LIST_COMPRESS = 0
ELM_LIST_SCROLL = 1
ELM_LIST_LIMIT = 2

ELM_MAP_OVERLAY_TYPE_NONE = 0
ELM_MAP_OVERLAY_TYPE_DEFAULT = 1
ELM_MAP_OVERLAY_TYPE_CLASS = 2
ELM_MAP_OVERLAY_TYPE_GROUP = 3
ELM_MAP_OVERLAY_TYPE_BUBBLE = 4
ELM_MAP_OVERLAY_TYPE_ROUTE = 5
ELM_MAP_OVERLAY_TYPE_LINE = 6
ELM_MAP_OVERLAY_TYPE_POLYGON = 7
ELM_MAP_OVERLAY_TYPE_CIRCLE = 8
ELM_MAP_OVERLAY_TYPE_SCALE = 9

ELM_MAP_ROUTE_METHOD_FASTEST = 0
ELM_MAP_ROUTE_METHOD_SHORTEST = 1
ELM_MAP_ROUTE_METHOD_LAST = 2

ELM_MAP_ROUTE_TYPE_MOTOCAR = 0
ELM_MAP_ROUTE_TYPE_BICYCLE = 1
ELM_MAP_ROUTE_TYPE_FOOT = 2
ELM_MAP_ROUTE_TYPE_LAST = 3

ELM_MAP_SOURCE_TYPE_TILE = 0
ELM_MAP_SOURCE_TYPE_ROUTE = 1
ELM_MAP_SOURCE_TYPE_NAME = 2
ELM_MAP_SOURCE_TYPE_LAST = 3

ELM_MAP_ZOOM_MODE_MANUAL = 0
ELM_MAP_ZOOM_MODE_AUTO_FIT = 1
ELM_MAP_ZOOM_MODE_AUTO_FILL = 2
ELM_MAP_ZOOM_MODE_LAST = 3

ELM_NOTIFY_ORIENT_TOP = 0
ELM_NOTIFY_ORIENT_CENTER = 1
ELM_NOTIFY_ORIENT_BOTTOM = 2
ELM_NOTIFY_ORIENT_LEFT = 3
ELM_NOTIFY_ORIENT_RIGHT = 4
ELM_NOTIFY_ORIENT_TOP_LEFT = 5
ELM_NOTIFY_ORIENT_TOP_RIGHT = 6
ELM_NOTIFY_ORIENT_BOTTOM_LEFT = 7
ELM_NOTIFY_ORIENT_BOTTOM_RIGHT = 8

ELM_OBJECT_SELECT_MODE_DEFAULT = 0
ELM_OBJECT_SELECT_MODE_ALWAYS = 1
ELM_OBJECT_SELECT_MODE_NONE = 2
ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY = 3
ELM_OBJECT_SELECT_MODE_MAX = 4

ELM_PANEL_ORIENT_TOP = 0
ELM_PANEL_ORIENT_BOTTOM = 1
ELM_PANEL_ORIENT_LEFT = 2
ELM_PANEL_ORIENT_RIGHT = 3

ELM_PHOTOCAM_ZOOM_MODE_MANUAL = 0
ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT = 1
ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL = 2
ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT_IN = 3

ELM_POLICY_QUIT = 0
ELM_POLICY_LAST = 1

ELM_POLICY_QUIT_NONE = 0
ELM_POLICY_QUIT_LAST_WINDOW_CLOSED = 1

ELM_POPUP_ORIENT_TOP = 0
ELM_POPUP_ORIENT_CENTER = 1
ELM_POPUP_ORIENT_BOTTOM = 2
ELM_POPUP_ORIENT_LEFT = 3
ELM_POPUP_ORIENT_RIGHT = 4
ELM_POPUP_ORIENT_TOP_LEFT = 5
ELM_POPUP_ORIENT_TOP_RIGHT = 6
ELM_POPUP_ORIENT_BOTTOM_LEFT = 7
ELM_POPUP_ORIENT_BOTTOM_RIGHT = 8

ELM_SCROLLER_POLICY_AUTO = 0
ELM_SCROLLER_POLICY_ON = 1
ELM_SCROLLER_POLICY_OFF = 2

ELM_TEXT_FORMAT_PLAIN_UTF8 = 0
ELM_TEXT_FORMAT_MARKUP_UTF8 = 1

ELM_TOOLBAR_SHRINK_NONE = 0
ELM_TOOLBAR_SHRINK_HIDE = 1
ELM_TOOLBAR_SHRINK_SCROLL = 2
ELM_TOOLBAR_SHRINK_MENU = 3
ELM_TOOLBAR_SHRINK_EXPAND = 4
ELM_TOOLBAR_SHRINK_LAST = 5

ELM_WEB_WINDOW_FEATURE_TOOLBAR = 0
ELM_WEB_WINDOW_FEATURE_STATUSBAR = 1
ELM_WEB_WINDOW_FEATURE_SCROLLBARS = 2
ELM_WEB_WINDOW_FEATURE_MENUBAR = 3
ELM_WEB_WINDOW_FEATURE_LOCATIONBAR = 4
ELM_WEB_WINDOW_FEATURE_FULLSCREEN = 5

ELM_WEB_ZOOM_MODE_MANUAL = 0
ELM_WEB_ZOOM_MODE_AUTO_FIT = 1
ELM_WEB_ZOOM_MODE_AUTO_FILL = 2

ELM_WIN_BASIC = 0
ELM_WIN_DIALOG_BASIC = 1
ELM_WIN_DESKTOP = 2
ELM_WIN_DOCK = 3
ELM_WIN_TOOLBAR = 4
ELM_WIN_MENU = 5
ELM_WIN_UTILITY = 6
ELM_WIN_SPLASH = 7
ELM_WIN_DROPDOWN_MENU = 8
ELM_WIN_POPUP_MENU = 9
ELM_WIN_TOOLTIP = 10
ELM_WIN_NOTIFICATION = 11
ELM_WIN_COMBO = 12
ELM_WIN_DND = 13
ELM_WIN_INLINED_IMAGE = 14
ELM_WIN_SOCKET_IMAGE = 15

ELM_WIN_INDICATOR_UNKNOWN = 0
ELM_WIN_INDICATOR_HIDE = 1
ELM_WIN_INDICATOR_SHOW = 2

ELM_WIN_INDICATOR_OPACITY_UNKNOWN = 0
ELM_WIN_INDICATOR_OPAQUE = 1
ELM_WIN_INDICATOR_TRANSLUCENT = 2
ELM_WIN_INDICATOR_TRANSPARENT = 3

ELM_WIN_KEYBOARD_UNKNOWN = 0
ELM_WIN_KEYBOARD_OFF = 1
ELM_WIN_KEYBOARD_ON = 2
ELM_WIN_KEYBOARD_ALPHA = 3
ELM_WIN_KEYBOARD_NUMERIC = 4
ELM_WIN_KEYBOARD_PIN = 5
ELM_WIN_KEYBOARD_PHONE_NUMBER = 6
ELM_WIN_KEYBOARD_HEX = 7
ELM_WIN_KEYBOARD_TERMINAL = 8
ELM_WIN_KEYBOARD_PASSWORD = 9
ELM_WIN_KEYBOARD_IP = 10
ELM_WIN_KEYBOARD_HOST = 11
ELM_WIN_KEYBOARD_FILE = 12
ELM_WIN_KEYBOARD_URL = 13
ELM_WIN_KEYBOARD_KEYPAD = 14
ELM_WIN_KEYBOARD_J2ME = 15

ELM_WRAP_NONE = 0
ELM_WRAP_CHAR = 1
ELM_WRAP_WORD = 2
ELM_WRAP_MIXED = 3

###

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
    cdef int argc, i, arg_len
    cdef char **argv, *arg
    argc = len(sys.argv)
    argv = <char **>PyMem_Malloc(argc * sizeof(char *))
    for i from 0 <= i < argc:
        arg = _fruni(sys.argv[i])
        arg_len = len(arg)
        argv[i] = <char *>PyMem_Malloc(arg_len + 1)
        memcpy(argv[i], arg, arg_len + 1)

    elm_init(argc, argv)

def shutdown():
    elm_shutdown()

def run():
    with nogil:
        elm_run()

def exit():
    elm_exit()

def policy_set(policy, value):
    return elm_policy_set(policy, value)

def policy_get(policy):
    return elm_policy_get(policy)

def coords_finger_size_adjust(times_w, w, times_h, h):
    cdef Evas_Coord width
    cdef Evas_Coord height
    width = w
    height = h
    elm_coords_finger_size_adjust(times_w, &width, times_h, &height)

# class ElementaryObjectMeta(type):
#     def __init__(cls, name, bases, dict_):
#         type.__init__(cls, name, bases, dict_)
#         cls._fetch_evt_callbacks()
# 
#     def _fetch_evt_callbacks(cls):
#         if "__evas_event_callbacks__" in cls.__dict__:
#             return
# 
#         cls.__evas_event_callbacks__ = []
#         append = cls.__evas_event_callbacks__.append
# 
#         for name in dir(cls):
#             val = getattr(cls, name)
#             if not callable(val) or not hasattr(val, "evas_event_callback"):
#                 continue
#             evt = getattr(val, "evas_event_callback")
#             append((name, evt))

include "efl.elementary_configuration.pxi"
include "efl.elementary_need.pxi"
include "efl.elementary_theme.pxi"
include "efl.elementary_object.pxi"
include "efl.elementary_object_item.pxi"
include "efl.elementary_gesture_layer.pxi"
include "efl.elementary_layout_class.pxi"
include "efl.elementary_layout.pxi"
include "efl.elementary_image.pxi"
include "efl.elementary_button.pxi"
include "efl.elementary_window.pxi"
include "efl.elementary_innerwindow.pxi"
include "efl.elementary_background.pxi"
include "efl.elementary_icon.pxi"
include "efl.elementary_box.pxi"
include "efl.elementary_frame.pxi"
include "efl.elementary_flip.pxi"
include "efl.elementary_scroller.pxi"
include "efl.elementary_label.pxi"
include "efl.elementary_table.pxi"
include "efl.elementary_clock.pxi"
include "efl.elementary_hover.pxi"
include "efl.elementary_entry.pxi"
include "efl.elementary_bubble.pxi"
include "efl.elementary_photo.pxi"
include "efl.elementary_hoversel.pxi"
include "efl.elementary_toolbar.pxi"
include "efl.elementary_list.pxi"
include "efl.elementary_slider.pxi"
include "efl.elementary_naviframe.pxi"
include "efl.elementary_radio.pxi"
include "efl.elementary_check.pxi"
include "efl.elementary_genlist.pxi"
include "efl.elementary_gengrid.pxi"
include "efl.elementary_spinner.pxi"
include "efl.elementary_notify.pxi"
include "efl.elementary_fileselector.pxi"
include "efl.elementary_fileselector_entry.pxi"
include "efl.elementary_fileselector_button.pxi"
include "efl.elementary_separator.pxi"
include "efl.elementary_progressbar.pxi"
include "efl.elementary_menu.pxi"
include "efl.elementary_panel.pxi"
include "efl.elementary_web.pxi"
include "efl.elementary_actionslider.pxi"
include "efl.elementary_calendar.pxi"
include "efl.elementary_colorselector.pxi"
include "efl.elementary_index.pxi"
include "efl.elementary_ctxpopup.pxi"
include "efl.elementary_grid.pxi"
include "efl.elementary_video.pxi"
include "efl.elementary_conformant.pxi"
include "efl.elementary_dayselector.pxi"
include "efl.elementary_panes.pxi"
include "efl.elementary_thumb.pxi"
include "efl.elementary_diskselector.pxi"
include "efl.elementary_datetime.pxi"
include "efl.elementary_map.pxi"
include "efl.elementary_mapbuf.pxi"
include "efl.elementary_multibuttonentry.pxi"
include "efl.elementary_transit.pxi"
include "efl.elementary_slideshow.pxi"
include "efl.elementary_segment_control.pxi"
include "efl.elementary_popup.pxi"
include "efl.elementary_plug.pxi"
include "efl.elementary_photocam.pxi"
include "efl.elementary_flipselector.pxi"
