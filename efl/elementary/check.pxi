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

include "check_cdef.pxi"

cdef class Check(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Check(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
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
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)


_object_mapping_register("Elm_Check", Check)
