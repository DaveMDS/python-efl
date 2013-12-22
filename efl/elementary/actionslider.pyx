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
#

"""

.. image:: /images/actionslider-preview.png

Widget description
------------------

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
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``selected`` - when user selects an enabled position (the label is
  passed as event info)".
- ``pos_changed`` - when the indicator reaches any of the
  positions("left", "right" or "center").

Default text parts of the actionslider widget that you can use for are:

- ``indicator`` - An indicator label of the actionslider
- ``left`` - A left label of the actionslider
- ``right`` - A right label of the actionslider
- ``center`` - A center label of the actionslider


Enumerations
------------

.. _Elm_Actionslider_Pos:

Actionslider positions
======================

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

from cpython cimport PyUnicode_AsUTF8String
from libc.string cimport const_char
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cimport enums

ELM_ACTIONSLIDER_NONE = enums.ELM_ACTIONSLIDER_NONE
ELM_ACTIONSLIDER_LEFT = enums.ELM_ACTIONSLIDER_LEFT
ELM_ACTIONSLIDER_CENTER = enums.ELM_ACTIONSLIDER_CENTER
ELM_ACTIONSLIDER_RIGHT = enums.ELM_ACTIONSLIDER_RIGHT
ELM_ACTIONSLIDER_ALL = enums.ELM_ACTIONSLIDER_ALL

def _cb_string_conv(uintptr_t addr):
    cdef const_char *s = <const_char *>addr
    return _ctouni(s) if s is not NULL else None

cdef class Actionslider(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_actionslider_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property selected_label:
        """Selected label.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_actionslider_selected_label_get(self.obj))

    def selected_label_get(self):
        return _ctouni(elm_actionslider_selected_label_get(self.obj))

    property indicator_pos:
        """Indicator position.

        :type: :ref:`Elm_Actionslider_Pos`

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

        :type: :ref:`Elm_Actionslider_Pos`

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

        .. note:: All positions are enabled by default.

        :type: :ref:`Elm_Actionslider_Pos`

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


_object_mapping_register("Elm_Actionslider", Actionslider)
