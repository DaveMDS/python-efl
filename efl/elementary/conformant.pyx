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

include "widget_header.pxi"

from layout_class cimport LayoutClass

cdef class Conformant(LayoutClass):

    """

    The aim is to provide a widget that can be used in elementary apps to
    account for space taken up by the indicator, virtual keypad & softkey
    windows when running the illume2 module of E17.

    So conformant content will be sized and positioned considering the
    space required for such stuff, and when they popup, as a keyboard
    shows when an entry is selected, conformant content won't change.

    This widget emits the signals sent from
    :py:class:`elementary.layout.Layout`.

    Available styles for it:
        - ``"default"``

    Default content parts of the conformant widget that you can use for are:
        - "default" - A content of the conformant

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_conformant_add(parent.obj))


_object_mapping_register("elm_conformant", Conformant)

