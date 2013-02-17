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

.. rubric:: Actionslider positions

.. data:: ELM_ACTIONSLIDER_NONE

    No position

.. data:: ELM_ACTIONSLIDER_LEFT

    Left position

.. data:: ELM_ACTIONSLIDER_CENTER

    Center position
.. data:: ELM_ACTIONSLIDER_RIGHT

    Right position

.. data:: ELM_ACTIONSLIDER_ALL

    All positions

"""

include "widget_header.pxi"
include "callbacks.pxi"

from layout_class cimport LayoutClass

cimport enums

ELM_ACTIONSLIDER_NONE = enums.ELM_ACTIONSLIDER_NONE
ELM_ACTIONSLIDER_LEFT = enums.ELM_ACTIONSLIDER_LEFT
ELM_ACTIONSLIDER_CENTER = enums.ELM_ACTIONSLIDER_CENTER
ELM_ACTIONSLIDER_RIGHT = enums.ELM_ACTIONSLIDER_RIGHT
ELM_ACTIONSLIDER_ALL = enums.ELM_ACTIONSLIDER_ALL

cdef class Actionslider(LayoutClass):

    """

    An actionslider is a switcher for two or three labels with
    customizable magnet properties.

    The user drags and releases the indicator, to choose a label.

    Labels can occupy the following positions.

    - Left
    - Right
    - Center

    Positions can be enabled or disabled.

    Magnets can be set on the above positions.

    When the indicator is released, it will move to its nearest "enabled and
    magnetized" position.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - **selected** - when user selects an enabled position (the label is
        passed as event info)".
    - **pos_changed** - when the indicator reaches any of the
        positions("left", "right" or "center").

    Default text parts of the actionslider widget that you can use for are:

    - **indicator** - An indicator label of the actionslider
    - **left** - A left label of the actionslider
    - **right** - A right label of the actionslider
    - **center** - A center label of the actionslider

    .. note:: By default all positions are set as enabled.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_actionslider_add(parent.obj))

    property selected_label:
        """Selected label.

        :type: string

        """
        def __get__(self):
            return elm_actionslider_selected_label_get(self.obj)

    def selected_label_get(self):
        return elm_actionslider_selected_label_get(self.obj)

    property indicator_pos:
        """Indicator position.

        :type: Elm_Actionslider_Pos

        """
        def __get__(self):
            return elm_actionslider_indicator_pos_get(self.obj)
        def __set__(self, pos):
            elm_actionslider_indicator_pos_set(self.obj, pos)

    def indicator_pos_set(self, pos):
        elm_actionslider_indicator_pos_set(self.obj, pos)
    def indicator_pos_get(self):
        return elm_actionslider_indicator_pos_get(self.obj)

    property magnet_pos:
        """The actionslider magnet position. To make multiple positions
        magnets ``or`` them together(e.g.: ``ELM_ACTIONSLIDER_LEFT |
        ELM_ACTIONSLIDER_RIGHT``)

        :type: Elm_Actionslider_Pos

        """
        def __get__(self):
            return self.magnet_pos_get()
        def __set__(self, pos):
            self.magnet_pos_set(pos)

    def magnet_pos_set(self, pos):
        elm_actionslider_magnet_pos_set(self.obj, pos)
    def magnet_pos_get(self):
        return elm_actionslider_magnet_pos_get(self.obj)

    property enabled_pos:
        """The actionslider enabled position. To set multiple positions as
        enabled ``or`` them together(e.g.: ``ELM_ACTIONSLIDER_LEFT |
        ELM_ACTIONSLIDER_RIGHT``).

        .. note:: All the positions are enabled by default.

        :type: Elm_Actionslider_Pos

        """
        def __get__(self):
            return elm_actionslider_enabled_pos_get(self.obj)
        def __set__(self, pos):
            elm_actionslider_enabled_pos_set(self.obj, pos)

    def enabled_pos_set(self, pos):
        elm_actionslider_enabled_pos_set(self.obj, pos)
    def enabled_pos_get(self):
        return elm_actionslider_enabled_pos_get(self.obj)

    def callback_selected_add(self, func, *args, **kwargs):
        """Called when user selects an enabled position. The label is passed
        as event info."""
        self._callback_add_full("selected", _cb_string_conv, func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_string_conv, func)

    def callback_pos_changed_add(self, func, *args, **kwargs):
        """Called when the indicator reaches any of the positions **left**,
        **right** or **center**. The label is passed as event info."""
        self._callback_add_full("pos_changed", _cb_string_conv, func, *args, **kwargs)

    def callback_pos_changed_del(self, func):
        self._callback_del_full("pos_changed", _cb_string_conv, func)


_object_mapping_register("elm_actionslider", Actionslider)
