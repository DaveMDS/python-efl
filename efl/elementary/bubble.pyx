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
#

"""

.. rubric:: Bubble arrow positions

.. data:: ELM_BUBBLE_POS_TOP_LEFT

    Top left position

.. data:: ELM_BUBBLE_POS_TOP_RIGHT

    Top right position

.. data:: ELM_BUBBLE_POS_BOTTOM_LEFT

    Bottom left position

.. data:: ELM_BUBBLE_POS_BOTTOM_RIGHT

    Bottom right position

"""

include "widget_header.pxi"

from layout_class cimport LayoutClass

cimport enums

ELM_BUBBLE_POS_TOP_LEFT = enums.ELM_BUBBLE_POS_TOP_LEFT
ELM_BUBBLE_POS_TOP_RIGHT = enums.ELM_BUBBLE_POS_TOP_RIGHT
ELM_BUBBLE_POS_BOTTOM_LEFT = enums.ELM_BUBBLE_POS_BOTTOM_LEFT
ELM_BUBBLE_POS_BOTTOM_RIGHT = enums.ELM_BUBBLE_POS_BOTTOM_RIGHT

cdef class Bubble(LayoutClass):

    """

    The Bubble is a widget to show text similar to how speech is
    represented in comics.

    The bubble widget contains 5 important visual elements:

    - The frame is a rectangle with rounded edjes and an "arrow".
    - The ``icon`` is an image to which the frame's arrow points to.
    - The ``label`` is a text which appears to the right of the icon if the
        corner is **top_left** or **bottom_left** and is right aligned to
        the frame otherwise.
    - The ``info`` is a text which appears to the right of the label. Info's
        font is of a lighter color than label.
    - The ``content`` is an evas object that is shown inside the frame.

    The position of the arrow, icon, label and info depends on which corner is
    selected. The four available corners are:

    - **top_left** - Default
    - **top_right**
    - **bottom_left**
    - **bottom_right**

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - ``clicked`` - This is called when a user has clicked the bubble.

    Default content parts of the bubble that you can use for are:

    - **default** - A content of the bubble
    - **icon** - An icon of the bubble

    Default text parts of the button widget that you can use for are:

    - **default** - Label of the bubble
    - **info** - info of the bubble

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_bubble_add(parent.obj))

    property pos:
        """The corner of the bubble

        This property reflects the corner of the bubble. The corner will be
        used to determine where the arrow in the frame points to and where
        label, icon and info are shown.

        :type: Elm_Bubble_Pos

        """
        def __get__(self):
            return elm_bubble_pos_get(self.obj)

        def __set__(self, value):
            elm_bubble_pos_set(self.obj, value)

    def pos_set(self, pos):
        elm_bubble_pos_set(self.obj, pos)
    def pos_get(self):
        return elm_bubble_pos_get(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        """This is called when a user has clicked the bubble."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("elm_bubble", Bubble)
