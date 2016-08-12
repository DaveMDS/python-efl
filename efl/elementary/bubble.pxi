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
#

include "bubble_cdef.pxi"

cdef class Bubble(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Bubble(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_bubble_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property pos:
        """The corner of the bubble

        This property reflects the corner of the bubble. The corner will be
        used to determine where the arrow in the frame points to and where
        label, icon and info are shown.

        :type: :ref:`Elm_Bubble_Pos`

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
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)


_object_mapping_register("Elm_Bubble", Bubble)
