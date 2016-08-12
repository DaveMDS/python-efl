# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

include "panel_cdef.pxi"

cdef class Panel(LayoutClass):
    """

    This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Panel(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
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

    property scrollable:
        """ The scrollability of the panel.

        :type: bool

        .. versionadded:: 1.12

        """
        def __set__(self, bint scrollable):
            elm_panel_scrollable_set(self.obj, scrollable)
        def __get__(self):
            return bool(elm_panel_scrollable_get(self.obj))

    def scrollable_set(self, bint scrollable):
        elm_panel_scrollable_set(self.obj, scrollable)
    def scrollable_get(self):
        return bool(elm_panel_scrollable_get(self.obj))

    property scrollable_content_size:
        """ The size of the scrollable panel.

        :type: double

        .. versionadded:: 1.12

        """
        def __set__(self, double ratio):
            elm_panel_scrollable_content_size_set(self.obj, ratio)

    def scrollable_content_size_set(self, double ratio):
        elm_panel_scrollable_content_size_set(self.obj, ratio)

    def toggle(self):
        """Toggle the hidden state of the panel from code."""
        elm_panel_toggle(self.obj)


_object_mapping_register("Elm_Panel", Panel)
