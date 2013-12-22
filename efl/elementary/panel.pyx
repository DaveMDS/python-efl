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

.. image:: /images/panel-preview.png

Widget description
------------------

A panel is a type of animated container that contains subobjects.

It can be expanded or contracted by clicking the button on it's edge.

Orientations are as follows:

- ELM_PANEL_ORIENT_TOP
- ELM_PANEL_ORIENT_LEFT
- ELM_PANEL_ORIENT_RIGHT
- ELM_PANEL_ORIENT_BOTTOM

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``focused`` - When the panel has received focus. (since 1.8)
- ``unfocused`` - When the panel has lost focus. (since 1.8)

Default content parts of the panel widget that you can use for are:

- ``default`` - A content of the panel


Enumerations
------------

.. _Elm_Panel_Orient:

Panel orientation types
=======================

.. data:: ELM_PANEL_ORIENT_TOP

    Panel (dis)appears from the top

.. data:: ELM_PANEL_ORIENT_BOTTOM

    Panel (dis)appears from the bottom

.. data:: ELM_PANEL_ORIENT_LEFT

    Panel (dis)appears from the left

.. data:: ELM_PANEL_ORIENT_RIGHT

    Panel (dis)appears from the right

"""

from efl.eo cimport _object_mapping_register
from efl.evas cimport Object as evasObject
from object cimport Object
from layout_class cimport LayoutClass

cimport enums

ELM_PANEL_ORIENT_TOP = enums.ELM_PANEL_ORIENT_TOP
ELM_PANEL_ORIENT_BOTTOM = enums.ELM_PANEL_ORIENT_BOTTOM
ELM_PANEL_ORIENT_LEFT = enums.ELM_PANEL_ORIENT_LEFT
ELM_PANEL_ORIENT_RIGHT = enums.ELM_PANEL_ORIENT_RIGHT

cdef class Panel(LayoutClass):

    """This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_panel_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property orient:
        """The orientation of the panel.

        Tells from where the panel will (dis)appear.

        This has value ELM_PANEL_ORIENT_LEFT on failure

        :type: :ref:`Elm_Panel_Orient`

        """
        def __set__(self, orient):
            elm_panel_orient_set(self.obj, orient)
        def __get__(self):
            return elm_panel_orient_get(self.obj)

    def orient_set(self, orient):
        elm_panel_orient_set(self.obj, orient)
    def orient_get(self):
        return elm_panel_orient_get(self.obj)

    property hidden:
        """The hidden state of the panel.

        :type: bool

        """
        def __set__(self, hidden):
            elm_panel_hidden_set(self.obj, hidden)
        def __get__(self):
            return elm_panel_hidden_get(self.obj)

    def hidden_set(self, hidden):
        elm_panel_orient_set(self.obj, hidden)
    def hidden_get(self):
        return elm_panel_hidden_get(self.obj)

    def toggle(self):
        """toggle()

        Toggle the hidden state of the panel from code."""
        elm_panel_toggle(self.obj)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the panel has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the panel has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Panel", Panel)
