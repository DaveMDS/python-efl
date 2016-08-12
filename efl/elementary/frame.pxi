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

include "frame_cdef.pxi"

cdef class Frame(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Frame(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_frame_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property autocollapse:
        """Autocollapsing of a frame

        When this is True, clicking a frame's label will collapse the frame
        vertically, shrinking it to the height of the label. By default,
        this is DISABLED.

        :type: bool

        """
        def __get__(self):
            return elm_frame_autocollapse_get(self.obj)

        def __set__(self, autocollapse):
            elm_frame_autocollapse_set(self.obj, autocollapse)

    def autocollapse_set(self, autocollapse):
        elm_frame_autocollapse_set(self.obj, autocollapse)
    def autocollapse_get(self):
        return elm_frame_autocollapse_get(self.obj)

    property collapse:
        """The collapse state of a frame, bypassing animations

        :type: bool

        """
        def __get__(self):
            return elm_frame_collapse_get(self.obj)

        def __set__(self, autocollapse):
            elm_frame_collapse_set(self.obj, autocollapse)

    def collapse_set(self, autocollapse):
        elm_frame_collapse_set(self.obj, autocollapse)
    def collapse_get(self):
        return elm_frame_collapse_get(self.obj)

    def collapse_go(self, collapse):
        """Manually collapse a frame with animations

        Use this to toggle the collapsed state of a frame, triggering
        animations.

        :param collapse: True to collapse, False to expand
        :type collapse: bool

        """
        elm_frame_collapse_go(self.obj, collapse)


    def callback_clicked_add(self, func, *args, **kwargs):
        """The user has clicked the frame's label."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("Efl_Ui_Frame", Frame)
