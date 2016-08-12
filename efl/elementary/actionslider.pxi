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

include "actionslider_cdef.pxi"

cdef class Actionslider(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Actionslider(..)

        :param parent: Parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
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
        self._callback_add_full("selected", _cb_string_conv, func, args, kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_string_conv, func)

    def callback_pos_changed_add(self, func, *args, **kwargs):
        """Called when the indicator reaches any of the positions **left**,
        **right** or **center**. The label is passed as event info."""
        self._callback_add_full("pos_changed", _cb_string_conv, func, args, kwargs)

    def callback_pos_changed_del(self, func):
        self._callback_del_full("pos_changed", _cb_string_conv, func)


_object_mapping_register("Elm_Actionslider", Actionslider)
