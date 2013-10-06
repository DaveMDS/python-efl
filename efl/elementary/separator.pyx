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

"""

Widget description
------------------

.. image:: /images/separator-preview.png
    :align: left

Separator is a very thin object used to separate other objects.

A separator can be vertical or horizontal.

This widget emits the signals coming from
:py:class:`elementary.layout_class.LayoutClass`.

"""

from efl.evas cimport Evas_Object, const_Evas_Object, \
    Object as evasObject
from efl.eo cimport object_from_instance, _object_mapping_register
from efl.utils.conversions cimport _ctouni, _touni

from object cimport Object

from efl.evas cimport Eina_Bool

cdef extern from "Elementary.h":
    Evas_Object             *elm_separator_add(Evas_Object *parent)
    void                     elm_separator_horizontal_set(Evas_Object *obj, Eina_Bool)
    Eina_Bool                elm_separator_horizontal_get(Evas_Object *obj)

from layout_class cimport LayoutClass

cdef class Separator(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent):
        self._set_obj(elm_separator_add(parent.obj))

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


_object_mapping_register("elm_separator", Separator)
