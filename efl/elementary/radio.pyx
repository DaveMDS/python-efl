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

"""

Widget description
------------------

.. image:: /images/radio-preview.png
    :align: left

Radio is a widget that allows for one or more options to be displayed
and have the user choose only one of them.

A radio object contains an indicator, an optional Label and an optional
icon object. While it's possible to have a group of only one radio they,
are normally used in groups of two or more.

Radio objects are grouped in a slightly different, compared to other UI
toolkits. There is no seperate group name/id to remember or manage. The
members represent the group, there are the group. To make a group, use
:py:meth:`Radio.group_add` and pass existing radio object and the new radio
object.

The radio object(s) will select from one of a set of integer values, so
any value they are configuring needs to be mapped to a set of integers.
To configure what value that radio object represents, use
:py:attr:`~Radio.state_value` to set the integer it represents. The
value of the whole group (which one is currently selected) is
represented by the property :py:attr:`~Radio.value` on any group member. For
convenience the radio objects are also able to directly set an
integer(int) to the value that is selected.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - This is called whenever the user changes the state of one of
    the radio objects within the group of radio objects that work together.
- ``focused`` - When the radio has received focus. (since 1.8)
- ``unfocused`` - When the radio has lost focus. (since 1.8)

Default text parts of the radio widget that you can use for are:

- ``default`` - Label of the radio

Default content parts of the radio widget that you can use for are:

- ``icon`` - An icon of the radio

"""

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.utils.deprecated cimport DEPRECATED
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cdef class Radio(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_radio_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def group_add(self, evasObject group):
        """group_add(evas.Object group)

        Add this radio to a group of other radio objects

        Radio objects work in groups. Each member should have a different
        integer value assigned. In order to have them work as a group, they
        need to know about each other. This adds the given radio object to
        the group of which the group object indicated is a member.

        :param group: Any object whose group the object is to join.
        :type group: :py:class:`Radio`

        """
        elm_radio_group_add(self.obj, group.obj)

    property state_value:
        """The integer value that this radio object represents

        :type: int

        """
        def __get__(self):
            return elm_radio_state_value_get(self.obj)
        def __set__(self, value):
            elm_radio_state_value_set(self.obj, value)

    def state_value_set(self, value):
        elm_radio_state_value_set(self.obj, value)
    def state_value_get(self):
        return elm_radio_state_value_get(self.obj)

    property value:
        """The value of the radio group.

        This reflects the value of the radio group and will also set the
        value if pointed to, to the value supplied, but will not call any
        callbacks.

        :type: int

        """
        def __get__(self):
            return elm_radio_value_get(self.obj)

        def __set__(self, value):
            elm_radio_value_set(self.obj, value)

    def value_set(self, value):
        elm_radio_value_set(self.obj, value)
    def value_get(self):
        return elm_radio_value_get(self.obj)

    @DEPRECATED("1.8", "Don't use this, only works in C.")
    def value_pointer_set(self, int value):
        """value_pointer_set(value)

        Set a convenience pointer to a integer to change when radio group
        value changes.

        This sets a pointer to a integer, that, in addition to the radio
        objects state will also be modified directly. To stop setting the
        object pointed to simply use None as the ``valuep`` argument. If
        valuep is not None, then when this is called, the radio objects
        state will also be modified to reflect the value of the integer
        valuep points to, just like calling :py:attr:`value`.

        :param valuep: Pointer to the integer to modify
        :type valuep: int

        """
        cdef int * valuep = <int *>value
        elm_radio_value_pointer_set(self.obj, valuep)

    property selected_object:
        """Get the selected radio object.

        :type: :py:class:`Radio`

        """
        def __get__(self):
            return object_from_instance(elm_radio_selected_object_get(self.obj))

    def selected_object_get(self):
        return object_from_instance(elm_radio_selected_object_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """This is called whenever the user changes the state of one of the
        radio objects within the group of radio objects that work together.

        """
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the radio has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the radio has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Radio", Radio)
