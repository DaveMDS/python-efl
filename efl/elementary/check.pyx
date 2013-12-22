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

.. image:: /images/check-preview.png
    :align: left

The check widget allows for toggling a value between true and false.

Check objects are a lot like radio objects in layout and functionality,
except they do not work as a group, but independently, and only toggle
the value of a boolean :py:attr:`~Check.state` between false and true.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - This is called whenever the user changes the state of
  the check objects.
- ``focused`` - When the check has received focus. (since 1.8)
- ``unfocused`` - When the check has lost focus. (since 1.8)

Default content parts of the check widget that you can use for are:

- ``icon`` - An icon of the check

Default text parts of the check widget that you can use for are:

- ``default`` - A label of the check
- ``on`` - On state label of the check
- ``off`` - Off state label of the check

"""

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cdef class Check(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_check_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property state:
        """The of/off state of the check object

        This property reflects the state of the check. Setting it **doesn't**
        cause the "changed" signal to be emitted.

        :type: bool

        """
        def __get__(self):
            return bool(elm_check_state_get(self.obj))

        def __set__(self, value):
            elm_check_state_set(self.obj, value)

    def state_set(self, value):
        elm_check_state_set(self.obj, value)
    def state_get(self):
        return bool(elm_check_state_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """This is called whenever the user changes the state of the check
        objects."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the check has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the check has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Check", Check)
