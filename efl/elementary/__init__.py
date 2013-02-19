# Copyright (c) 2008 Simon Busch
# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

from efl.elementary.actionslider import Actionslider
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.bubble import Bubble
from efl.elementary.button import Button
from efl.elementary.calendar_elm import Calendar, CalendarMark
from efl.elementary.check import Check
from efl.elementary.clock import Clock
from efl.elementary.colorselector import Colorselector, ColorselectorPaletteItem
from efl.elementary.configuration import Configuration, \
    config_finger_size_get, config_finger_size_set, \
    config_tooltip_delay_get, config_tooltip_delay_set, \
    focus_highlight_animate_get, focus_highlight_animate_set, \
    focus_highlight_enabled_get, focus_highlight_enabled_set, \
    preferred_engine_get, preferred_engine_set, \
    engine_get, engine_set, scale_get, scale_set, \
    cursor_engine_only_get, cursor_engine_only_set
from efl.elementary.conformant import Conformant
from efl.elementary.ctxpopup import Ctxpopup, CtxpopupItem
from efl.elementary.datetime_elm import Datetime
from efl.elementary.dayselector import Dayselector
from efl.elementary.diskselector import Diskselector, DiskselectorItem
from efl.elementary.entry import Entry
from efl.elementary.fileselector import Fileselector
from efl.elementary.fileselector_button import FileselectorButton
from efl.elementary.fileselector_entry import FileselectorEntry
from efl.elementary.flip import Flip
from efl.elementary.flipselector import FlipSelector, FlipSelectorItem
from efl.elementary.frame import Frame
from efl.elementary.general import init, shutdown, run, exit, coords_finger_size_adjust, policy_set, policy_get
from efl.elementary.gengrid import Gengrid, GengridItem, GengridItemClass
from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass
from efl.elementary.gesture_layer import GestureLayer
from efl.elementary.grid import Grid
from efl.elementary.hover import Hover
from efl.elementary.hoversel import Hoversel, HoverselItem
from efl.elementary.icon import Icon
from efl.elementary.image import Image
from efl.elementary.index import Index, IndexItem
from efl.elementary.innerwindow import InnerWindow
from efl.elementary.label import Label
from efl.elementary.layout import Layout
from efl.elementary.layout_class import LayoutClass
from efl.elementary.list import List, ListItem
from efl.elementary.map import Map, MapName, MapOverlay, MapOverlayBubble, MapOverlayCircle, MapOverlayClass, MapOverlayLine, MapOverlayPolygon, MapOverlayRoute, MapOverlayScale
from efl.elementary.mapbuf import Mapbuf
from efl.elementary.menu import Menu, MenuItem, MenuSeparatorItem
from efl.elementary.multibuttonentry import MultiButtonEntry, MultiButtonEntryItem
from efl.elementary.naviframe import Naviframe, NaviframeItem
from efl.elementary.need import *
from efl.elementary.notify import Notify
from efl.elementary.object import Object
from efl.elementary.object_item import ObjectItem
from efl.elementary.panel import Panel
from efl.elementary.panes import Panes
from efl.elementary.photo import Photo
from efl.elementary.photocam import Photocam
from efl.elementary.plug import Plug
from efl.elementary.popup import Popup, PopupItem
from efl.elementary.progressbar import Progressbar
from efl.elementary.radio import Radio
from efl.elementary.scroller import Scroller
from efl.elementary.segment_control import SegmentControl, SegmentControlItem
from efl.elementary.separator import Separator
from efl.elementary.slider import Slider
from efl.elementary.slideshow import Slideshow, SlideshowItem, SlideshowItemClass
from efl.elementary.spinner import Spinner
from efl.elementary.table import Table
from efl.elementary.theme import Theme, theme_overlay_add, theme_extension_add
from efl.elementary.thumb import Thumb
from efl.elementary.toolbar import Toolbar, ToolbarItem
from efl.elementary.transit import Transit
from efl.elementary.video import Video, Player
from efl.elementary.web import Web
from efl.elementary.window import Window, StandardWindow

from efl.elementary.actionslider import \
    ELM_ACTIONSLIDER_NONE, \
    ELM_ACTIONSLIDER_LEFT, \
    ELM_ACTIONSLIDER_CENTER, \
    ELM_ACTIONSLIDER_RIGHT, \
    ELM_ACTIONSLIDER_ALL

from efl.elementary.background import \
    ELM_BG_OPTION_CENTER, \
    ELM_BG_OPTION_SCALE, \
    ELM_BG_OPTION_STRETCH, \
    ELM_BG_OPTION_TILE, \
    ELM_BG_OPTION_LAST

from efl.elementary.box import \
    ELM_BOX_LAYOUT_HORIZONTAL, \
    ELM_BOX_LAYOUT_VERTICAL, \
    ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL, \
    ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL, \
    ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL, \
    ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL, \
    ELM_BOX_LAYOUT_FLOW_HORIZONTAL, \
    ELM_BOX_LAYOUT_FLOW_VERTICAL, \
    ELM_BOX_LAYOUT_STACK

from efl.elementary.bubble import \
    ELM_BUBBLE_POS_TOP_LEFT, \
    ELM_BUBBLE_POS_TOP_RIGHT, \
    ELM_BUBBLE_POS_BOTTOM_LEFT, \
    ELM_BUBBLE_POS_BOTTOM_RIGHT

from efl.elementary.calendar_elm import \
    ELM_CALENDAR_UNIQUE, \
    ELM_CALENDAR_DAILY, \
    ELM_CALENDAR_WEEKLY, \
    ELM_CALENDAR_MONTHLY, \
    ELM_CALENDAR_ANNUALLY, \
    ELM_CALENDAR_LAST_DAY_OF_MONTH, \
    ELM_CALENDAR_SELECT_MODE_DEFAULT, \
    ELM_CALENDAR_SELECT_MODE_ALWAYS, \
    ELM_CALENDAR_SELECT_MODE_NONE, \
    ELM_CALENDAR_SELECT_MODE_ONDEMAND

from efl.elementary.clock import \
    ELM_CLOCK_EDIT_DEFAULT, \
    ELM_CLOCK_EDIT_HOUR_DECIMAL, \
    ELM_CLOCK_EDIT_HOUR_UNIT, \
    ELM_CLOCK_EDIT_MIN_DECIMAL, \
    ELM_CLOCK_EDIT_MIN_UNIT, \
    ELM_CLOCK_EDIT_SEC_DECIMAL, \
    ELM_CLOCK_EDIT_SEC_UNIT, \
    ELM_CLOCK_EDIT_ALL

from efl.elementary.entry import \
    ELM_CNP_MODE_MARKUP, \
    ELM_CNP_MODE_NO_IMAGE, \
    ELM_CNP_MODE_PLAINTEXT

from efl.elementary.colorselector import \
    ELM_COLORSELECTOR_PALETTE, \
    ELM_COLORSELECTOR_COMPONENTS, \
    ELM_COLORSELECTOR_BOTH

from efl.elementary.ctxpopup import \
    ELM_CTXPOPUP_DIRECTION_DOWN, \
    ELM_CTXPOPUP_DIRECTION_RIGHT, \
    ELM_CTXPOPUP_DIRECTION_LEFT, \
    ELM_CTXPOPUP_DIRECTION_UP, \
    ELM_CTXPOPUP_DIRECTION_UNKNOWN

from efl.elementary.datetime_elm import \
    ELM_DATETIME_YEAR, \
    ELM_DATETIME_MONTH, \
    ELM_DATETIME_DATE, \
    ELM_DATETIME_HOUR, \
    ELM_DATETIME_MINUTE, \
    ELM_DATETIME_AMPM

from efl.elementary.calendar_elm import \
    ELM_DAY_SUNDAY, \
    ELM_DAY_MONDAY, \
    ELM_DAY_TUESDAY, \
    ELM_DAY_WEDNESDAY, \
    ELM_DAY_THURSDAY, \
    ELM_DAY_FRIDAY, \
    ELM_DAY_SATURDAY, \
    ELM_DAY_LAST

from efl.elementary.dayselector import \
    ELM_DAYSELECTOR_SUN, \
    ELM_DAYSELECTOR_MON, \
    ELM_DAYSELECTOR_TUE, \
    ELM_DAYSELECTOR_WED, \
    ELM_DAYSELECTOR_THU, \
    ELM_DAYSELECTOR_FRI, \
    ELM_DAYSELECTOR_SAT

from efl.elementary.fileselector import \
    ELM_FILESELECTOR_LIST, \
    ELM_FILESELECTOR_GRID

from efl.elementary.flip import \
    ELM_FLIP_DIRECTION_UP, \
    ELM_FLIP_DIRECTION_DOWN, \
    ELM_FLIP_DIRECTION_LEFT, \
    ELM_FLIP_DIRECTION_RIGHT, \
    ELM_FLIP_INTERACTION_NONE, \
    ELM_FLIP_INTERACTION_ROTATE, \
    ELM_FLIP_INTERACTION_CUBE, \
    ELM_FLIP_INTERACTION_PAGE, \
    ELM_FLIP_ROTATE_Y_CENTER_AXIS, \
    ELM_FLIP_ROTATE_X_CENTER_AXIS, \
    ELM_FLIP_ROTATE_XZ_CENTER_AXIS, \
    ELM_FLIP_ROTATE_YZ_CENTER_AXIS, \
    ELM_FLIP_CUBE_LEFT, \
    ELM_FLIP_CUBE_RIGHT, \
    ELM_FLIP_CUBE_UP, \
    ELM_FLIP_CUBE_DOWN, \
    ELM_FLIP_PAGE_LEFT, \
    ELM_FLIP_PAGE_RIGHT, \
    ELM_FLIP_PAGE_UP, \
    ELM_FLIP_PAGE_DOWN

from efl.elementary.object import \
    ELM_FOCUS_PREVIOUS, \
    ELM_FOCUS_NEXT

from efl.elementary.genlist import \
    ELM_GENLIST_ITEM_NONE, \
    ELM_GENLIST_ITEM_TREE, \
    ELM_GENLIST_ITEM_GROUP, \
    ELM_GENLIST_ITEM_MAX, \
    ELM_GENLIST_ITEM_FIELD_ALL, \
    ELM_GENLIST_ITEM_FIELD_TEXT, \
    ELM_GENLIST_ITEM_FIELD_CONTENT, \
    ELM_GENLIST_ITEM_FIELD_STATE

from efl.elementary.gesture_layer import \
    ELM_GESTURE_STATE_UNDEFINED, \
    ELM_GESTURE_STATE_START, \
    ELM_GESTURE_STATE_MOVE, \
    ELM_GESTURE_STATE_END, \
    ELM_GESTURE_STATE_ABORT, \
    ELM_GESTURE_FIRST, \
    ELM_GESTURE_N_TAPS, \
    ELM_GESTURE_N_LONG_TAPS, \
    ELM_GESTURE_N_DOUBLE_TAPS, \
    ELM_GESTURE_N_TRIPLE_TAPS, \
    ELM_GESTURE_MOMENTUM, \
    ELM_GESTURE_N_LINES, \
    ELM_GESTURE_N_FLICKS, \
    ELM_GESTURE_ZOOM, \
    ELM_GESTURE_ROTATE

from efl.elementary.hover import \
    ELM_HOVER_AXIS_NONE, \
    ELM_HOVER_AXIS_HORIZONTAL, \
    ELM_HOVER_AXIS_VERTICAL, \
    ELM_HOVER_AXIS_BOTH

from efl.elementary.icon import \
    ELM_ICON_NONE, \
    ELM_ICON_FILE, \
    ELM_ICON_STANDARD

#~ from object import \
    #~ ELM_ILLUME_COMMAND_FOCUS_BACK, \
    #~ ELM_ILLUME_COMMAND_FOCUS_FORWARD, \
    #~ ELM_ILLUME_COMMAND_FOCUS_HOME, \
    #~ ELM_ILLUME_COMMAND_CLOSE

from efl.elementary.image import \
    ELM_IMAGE_ORIENT_NONE, \
    ELM_IMAGE_ROTATE_90, \
    ELM_IMAGE_ROTATE_180, \
    ELM_IMAGE_ROTATE_270, \
    ELM_IMAGE_FLIP_HORIZONTAL, \
    ELM_IMAGE_FLIP_VERTICAL, \
    ELM_IMAGE_FLIP_TRANSPOSE, \
    ELM_IMAGE_FLIP_TRANSVERSE

from efl.elementary.entry import \
    ELM_INPUT_PANEL_LANG_AUTOMATIC, \
    ELM_INPUT_PANEL_LANG_ALPHABET, \
    ELM_INPUT_PANEL_LAYOUT_NORMAL, \
    ELM_INPUT_PANEL_LAYOUT_NUMBER, \
    ELM_INPUT_PANEL_LAYOUT_EMAIL, \
    ELM_INPUT_PANEL_LAYOUT_URL, \
    ELM_INPUT_PANEL_LAYOUT_PHONENUMBER, \
    ELM_INPUT_PANEL_LAYOUT_IP, \
    ELM_INPUT_PANEL_LAYOUT_MONTH, \
    ELM_INPUT_PANEL_LAYOUT_NUMBERONLY, \
    ELM_INPUT_PANEL_LAYOUT_INVALID, \
    ELM_INPUT_PANEL_LAYOUT_HEX, \
    ELM_INPUT_PANEL_LAYOUT_TERMINAL, \
    ELM_INPUT_PANEL_LAYOUT_PASSWORD, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH, \
    ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND

from efl.elementary.label import \
    ELM_LABEL_SLIDE_MODE_NONE, \
    ELM_LABEL_SLIDE_MODE_AUTO, \
    ELM_LABEL_SLIDE_MODE_ALWAYS

from efl.elementary.list import \
    ELM_LIST_COMPRESS, \
    ELM_LIST_SCROLL, \
    ELM_LIST_LIMIT

from efl.elementary.map import \
    ELM_MAP_OVERLAY_TYPE_NONE, \
    ELM_MAP_OVERLAY_TYPE_DEFAULT, \
    ELM_MAP_OVERLAY_TYPE_CLASS, \
    ELM_MAP_OVERLAY_TYPE_GROUP, \
    ELM_MAP_OVERLAY_TYPE_BUBBLE, \
    ELM_MAP_OVERLAY_TYPE_ROUTE, \
    ELM_MAP_OVERLAY_TYPE_LINE, \
    ELM_MAP_OVERLAY_TYPE_POLYGON, \
    ELM_MAP_OVERLAY_TYPE_CIRCLE, \
    ELM_MAP_OVERLAY_TYPE_SCALE, \
    ELM_MAP_ROUTE_METHOD_FASTEST, \
    ELM_MAP_ROUTE_METHOD_SHORTEST, \
    ELM_MAP_ROUTE_METHOD_LAST, \
    ELM_MAP_ROUTE_TYPE_MOTOCAR, \
    ELM_MAP_ROUTE_TYPE_BICYCLE, \
    ELM_MAP_ROUTE_TYPE_FOOT, \
    ELM_MAP_ROUTE_TYPE_LAST, \
    ELM_MAP_SOURCE_TYPE_TILE, \
    ELM_MAP_SOURCE_TYPE_ROUTE, \
    ELM_MAP_SOURCE_TYPE_NAME, \
    ELM_MAP_SOURCE_TYPE_LAST, \
    ELM_MAP_ZOOM_MODE_MANUAL, \
    ELM_MAP_ZOOM_MODE_AUTO_FIT, \
    ELM_MAP_ZOOM_MODE_AUTO_FILL, \
    ELM_MAP_ZOOM_MODE_LAST

from efl.elementary.notify import \
    ELM_NOTIFY_ORIENT_TOP, \
    ELM_NOTIFY_ORIENT_CENTER, \
    ELM_NOTIFY_ORIENT_BOTTOM, \
    ELM_NOTIFY_ORIENT_LEFT, \
    ELM_NOTIFY_ORIENT_RIGHT, \
    ELM_NOTIFY_ORIENT_TOP_LEFT, \
    ELM_NOTIFY_ORIENT_TOP_RIGHT, \
    ELM_NOTIFY_ORIENT_BOTTOM_LEFT, \
    ELM_NOTIFY_ORIENT_BOTTOM_RIGHT

from efl.elementary.list import \
    ELM_OBJECT_SELECT_MODE_DEFAULT, \
    ELM_OBJECT_SELECT_MODE_ALWAYS, \
    ELM_OBJECT_SELECT_MODE_NONE, \
    ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY, \
    ELM_OBJECT_SELECT_MODE_MAX

from efl.elementary.panel import \
    ELM_PANEL_ORIENT_TOP, \
    ELM_PANEL_ORIENT_BOTTOM, \
    ELM_PANEL_ORIENT_LEFT, \
    ELM_PANEL_ORIENT_RIGHT

from efl.elementary.photocam import \
    ELM_PHOTOCAM_ZOOM_MODE_MANUAL, \
    ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT, \
    ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL, \
    ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT_IN

from efl.elementary.general import \
    ELM_POLICY_QUIT, \
    ELM_POLICY_QUIT_NONE, \
    ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

from efl.elementary.popup import \
    ELM_POPUP_ORIENT_TOP, \
    ELM_POPUP_ORIENT_CENTER, \
    ELM_POPUP_ORIENT_BOTTOM, \
    ELM_POPUP_ORIENT_LEFT, \
    ELM_POPUP_ORIENT_RIGHT, \
    ELM_POPUP_ORIENT_TOP_LEFT, \
    ELM_POPUP_ORIENT_TOP_RIGHT, \
    ELM_POPUP_ORIENT_BOTTOM_LEFT, \
    ELM_POPUP_ORIENT_BOTTOM_RIGHT

from efl.elementary.scroller import \
    ELM_SCROLLER_POLICY_AUTO, \
    ELM_SCROLLER_POLICY_ON, \
    ELM_SCROLLER_POLICY_OFF

from efl.elementary.entry import \
    ELM_TEXT_FORMAT_PLAIN_UTF8, \
    ELM_TEXT_FORMAT_MARKUP_UTF8

from efl.elementary.toolbar import \
    ELM_TOOLBAR_SHRINK_NONE, \
    ELM_TOOLBAR_SHRINK_HIDE, \
    ELM_TOOLBAR_SHRINK_SCROLL, \
    ELM_TOOLBAR_SHRINK_MENU, \
    ELM_TOOLBAR_SHRINK_EXPAND, \
    ELM_TOOLBAR_SHRINK_LAST

from efl.elementary.web import \
    ELM_WEB_WINDOW_FEATURE_TOOLBAR, \
    ELM_WEB_WINDOW_FEATURE_STATUSBAR, \
    ELM_WEB_WINDOW_FEATURE_SCROLLBARS, \
    ELM_WEB_WINDOW_FEATURE_MENUBAR, \
    ELM_WEB_WINDOW_FEATURE_LOCATIONBAR, \
    ELM_WEB_WINDOW_FEATURE_FULLSCREEN, \
    ELM_WEB_ZOOM_MODE_MANUAL, \
    ELM_WEB_ZOOM_MODE_AUTO_FIT, \
    ELM_WEB_ZOOM_MODE_AUTO_FILL

from efl.elementary.window import \
    ELM_WIN_BASIC, \
    ELM_WIN_DIALOG_BASIC, \
    ELM_WIN_DESKTOP, \
    ELM_WIN_DOCK, \
    ELM_WIN_TOOLBAR, \
    ELM_WIN_MENU, \
    ELM_WIN_UTILITY, \
    ELM_WIN_SPLASH, \
    ELM_WIN_DROPDOWN_MENU, \
    ELM_WIN_POPUP_MENU, \
    ELM_WIN_TOOLTIP, \
    ELM_WIN_NOTIFICATION, \
    ELM_WIN_COMBO, \
    ELM_WIN_DND, \
    ELM_WIN_INLINED_IMAGE, \
    ELM_WIN_SOCKET_IMAGE, \
    ELM_WIN_INDICATOR_UNKNOWN, \
    ELM_WIN_INDICATOR_HIDE, \
    ELM_WIN_INDICATOR_SHOW, \
    ELM_WIN_INDICATOR_OPACITY_UNKNOWN, \
    ELM_WIN_INDICATOR_OPAQUE, \
    ELM_WIN_INDICATOR_TRANSLUCENT, \
    ELM_WIN_INDICATOR_TRANSPARENT, \
    ELM_WIN_KEYBOARD_UNKNOWN, \
    ELM_WIN_KEYBOARD_OFF, \
    ELM_WIN_KEYBOARD_ON, \
    ELM_WIN_KEYBOARD_ALPHA, \
    ELM_WIN_KEYBOARD_NUMERIC, \
    ELM_WIN_KEYBOARD_PIN, \
    ELM_WIN_KEYBOARD_PHONE_NUMBER, \
    ELM_WIN_KEYBOARD_HEX, \
    ELM_WIN_KEYBOARD_TERMINAL, \
    ELM_WIN_KEYBOARD_PASSWORD, \
    ELM_WIN_KEYBOARD_IP, \
    ELM_WIN_KEYBOARD_HOST, \
    ELM_WIN_KEYBOARD_FILE, \
    ELM_WIN_KEYBOARD_URL, \
    ELM_WIN_KEYBOARD_KEYPAD, \
    ELM_WIN_KEYBOARD_J2ME

from efl.elementary.label import \
    ELM_WRAP_NONE, \
    ELM_WRAP_CHAR, \
    ELM_WRAP_WORD, \
    ELM_WRAP_MIXED

#init()

"""
__all__ = [
    "actionslider",
    "background",
    "box",
    "bubble",
    "button",
    "calendar",
    "check",
    "clock",
    "colorselector",
    "configuration",
    "conformant",
    "ctxpopup",
    "datetime_elm",
    "dayselector",
    "diskselector",
    "entry",
    "fileselector",
    "fileselector_button",
    "fileselector_entry",
    "flip",
    "frame",
    "general",
    "gengrid",
    "genlist",
    "gesture_layer",
    "grid",
    "hover",
    "hoversel",
    "icon",
    "image",
    "index",
    "innerwindow",
    "label",
    "layout_class",
    "layout",
    "list",
    "map",
    "mapbuf",
    "menu",
    "multibuttonentry",
    "naviframe",
    "need",
    "notify",
    "object",
    "object_item",
    "panel",
    "panes",
    "photo",
    "photocam",
    "plug",
    "popup",
    "progressbar",
    "radio",
    "scroller",
    "segment_control",
    "separator",
    "slider",
    "slideshow",
    "spinner",
    "table",
    "theme",
    "thumb",
    "toolbar",
    "transit",
    "video",
    "web",
    "window",
]
"""
