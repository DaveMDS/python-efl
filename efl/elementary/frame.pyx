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

cdef class Frame(LayoutClass):

    """

    Frame is a widget that holds some content and has a title.

    The default look is a frame with a title, but Frame supports multiple
    styles:

    - default
    - pad_small
    - pad_medium
    - pad_large
    - pad_huge
    - outdent_top
    - outdent_bottom

    Of all this styles only default shows the title.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``"clicked"`` - The user has clicked the frame's label

    Default content parts of the frame widget that you can use for are:

    - "default" - A content of the frame

    Default text parts of the frame widget that you can use for are:

    - "default" - Label of the frame

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_frame_add(parent.obj))

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
        """collapse_go(bool collapse)

        Manually collapse a frame with animations

        Use this to toggle the collapsed state of a frame, triggering
        animations.

        :param collapse: True to collapse, False to expand
        :type collapse: bool

        """
        elm_frame_collapse_go(self.obj, collapse)


    def callback_clicked_add(self, func, *args, **kwargs):
        """The user has clicked the frame's label."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("elm_frame", Frame)
