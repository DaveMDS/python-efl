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

from efl.elementary.general import *
from efl.elementary.need import *

# XXX: These are deprecated here! Will be removed soon.
from efl.utils.deprecated import DEPRECATED
from efl.elementary.theme import theme_overlay_add, theme_extension_add
from efl.elementary.configuration import preferred_engine_set
theme_overlay_add = DEPRECATED("1.8", "Use theme module instead.")(theme_overlay_add)
theme_extension_add = DEPRECATED("1.8", "Use theme module instead.")(theme_extension_add)
preferred_engine_set = DEPRECATED("1.8", "Use configuration module instead.")(preferred_engine_set)
ELM_WIN_BASIC = 0
ELM_OBJECT_SELECT_MODE_ALWAYS = 1


__all__ = (
    #"access",
    "actionslider",
    "background",
    "box",
    "bubble",
    "button",
    "calendar_elm",
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
    "flipselector",
    "frame",
    "general",
    "gengrid",
    "genlist",
    "gesture_layer",
    #"glview",
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
    #"store",
    "table",
    "theme",
    "thumb",
    "toolbar",
    "transit",
    "video",
    "web",
    "window",
)
