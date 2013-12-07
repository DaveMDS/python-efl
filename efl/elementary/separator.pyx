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

.. image:: /images/separator-preview.png
    :align: left

Separator is a very thin object used to separate other objects.

A separator can be vertical or horizontal.

This widget emits the signals coming from
:py:class:`~efl.elementary.layout_class.LayoutClass`.

"""

from efl.eo cimport _object_mapping_register
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cdef class Separator(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_separator_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property horizontal:
        """The horizontal mode of a separator object

        :type: bool

        """
        def __get__(self):
            return elm_separator_horizontal_get(self.obj)

        def __set__(self, b):
            elm_separator_horizontal_set(self.obj, b)

    def horizontal_set(self, b):
        elm_separator_horizontal_set(self.obj, b)
    def horizontal_get(self):
        return elm_separator_horizontal_get(self.obj)


_object_mapping_register("Elm_Separator", Separator)
