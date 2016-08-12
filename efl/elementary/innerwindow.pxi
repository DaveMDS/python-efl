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

include "innerwindow_cdef.pxi"

cdef class InnerWindow(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """InnerWindow(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_win_inwin_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def activate(self):
        """Activates an inwin object, ensuring its visibility

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
