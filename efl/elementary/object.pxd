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

from efl.evas cimport Object as evasObject

#cdef class Canvas(evasCanvas):
#    pass

cdef class Object(evasObject):
    cdef:
        object _elmcallbacks, _elm_event_cbs, _elm_signal_cbs
        object cnp_drop_cb, cnp_drop_data
        object cnp_selection_loss_cb, cnp_selection_loss_data

    cpdef text_set(self, text)
    cpdef text_get(self)
    cpdef style_set(self, style)
    cpdef style_get(self)
    cpdef cursor_set(self, cursor)
    cpdef cursor_get(self)
    cpdef cursor_unset(self)
    cpdef cursor_style_set(self, style=*)
    cpdef cursor_style_get(self)
    cpdef tooltip_style_set(self, style=*)
    cpdef tooltip_style_get(self)
    cpdef orientation_mode_disabled_set(self, bint disabled)
    cpdef bint orientation_mode_disabled_get(self)
    cpdef focused_object_get(self)
    cpdef int scroll_hold_get(self)
    cpdef int scroll_freeze_get(self)
