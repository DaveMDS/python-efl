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

.. image:: /images/innerwindow-preview.png
    :align: left

An inwin is a window inside a window that is useful for a quick popup.
It does not hover.

It works by creating an object that will occupy the entire window, so it must be
created using an :py:class:`~efl.elementary.window.Window` as parent only. The
inwin object can be hidden or restacked below every other object if it's needed
to show what's behind it without destroying it. If this is done, the
:py:meth:`~InnerWindow.activate` function can be used to bring it back to full
visibility again.

There are three styles available in the default theme. These are:

- default: The inwin is sized to take over most of the window it's
  placed in.
- minimal: The size of the inwin will be the minimum necessary to show
  its contents.
- minimal_vertical: Horizontally, the inwin takes as much space as
  possible, but it's sized vertically the most it needs to fit its
  contents.

"""

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.evas cimport Object as evasObject

from layout_class cimport LayoutClass

cdef class InnerWindow(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_win_inwin_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def activate(self):
        """activate()

        Activates an inwin object, ensuring its visibility

        This function will make sure that the inwin is completely visible by
        calling :py:meth:`~efl.evas.Object.show` and
        :py:meth:`~efl.evas.Object.raise_` on it, to bring it to
        the front. It also sets the keyboard focus to it, which will be passed
        onto its content.

        The object's theme will also receive the signal "elm,action,show" with
        source "elm".

        """
        elm_win_inwin_activate(self.obj)

    def content_set(self, evasObject content):
        elm_win_inwin_content_set(self.obj,
            content.obj if content is not None else NULL)

    def content_get(self):
        return object_from_instance(elm_win_inwin_content_get(self.obj))

    def content_unset(self):
        return object_from_instance(elm_win_inwin_content_unset(self.obj))

    property content:
        """The content of an inwin object.

        Once the content object is set, a previously set one will be deleted.

        :type: :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_win_inwin_content_get(self.obj))

        def __set__(self, evasObject content):
            elm_win_inwin_content_set(self.obj,
                content.obj if content is not None else NULL)

        def __del__(self):
            elm_win_inwin_content_unset(self.obj)


_object_mapping_register("Elm_Inwin", InnerWindow)
