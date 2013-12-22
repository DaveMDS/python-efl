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

.. image:: /images/conformant-preview.png

Widget description
------------------

The aim is to provide a widget that can be used in elementary apps to
account for space taken up by the indicator, virtual keypad & softkey
windows when running the illume2 module of E17.

So conformant content will be sized and positioned considering the
space required for such stuff, and when they popup, as a keyboard
shows when an entry is selected, conformant content won't change.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``virtualkeypad,state,on``: if virtualkeypad state is switched to ``on``.
- ``virtualkeypad,state,off``: if virtualkeypad state is switched to ``off``.
- ``clipboard,state,on``: if clipboard state is switched to ``on``.
- ``clipboard,state,off``: if clipboard state is switched to ``off``.

In all cases, the ``event`` parameter of the callback will be None.

Available styles for it:
    - ``default``

Default content parts of the conformant widget that you can use for are:
    - ``default`` - A content of the conformant

"""

from efl.eo cimport _object_mapping_register
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cdef class Conformant(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_conformant_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def callback_virtualkeypad_state_on_add(self, func, *args, **kwargs):
        """if virtualkeypad state is switched to "on".

        .. versionadded:: 1.8

        """
        self._callback_add("virtualkeypad,state,on", func, *args, **kwargs)

    def callback_virtualkeypad_state_on_del(self, func):
        self._callback_del("virtualkeypad,state,on", func)

    def callback_virtualkeypad_state_off_add(self, func, *args, **kwargs):
        """if virtualkeypad state is switched to "off".

        .. versionadded:: 1.8

        """
        self._callback_add("virtualkeypad,state,off", func, *args, **kwargs)

    def callback_virtualkeypad_state_off_del(self, func):
        self._callback_del("virtualkeypad,state,off", func)

    def callback_clipboard_state_on_add(self, func, *args, **kwargs):
        """if clipboard state is switched to "on".

        .. versionadded:: 1.8

        """
        self._callback_add("clipboard,state,on", func, *args, **kwargs)

    def callback_clipboard_state_on_del(self, func):
        self._callback_del("clipboard,state,on", func)

    def callback_clipboard_state_off_add(self, func, *args, **kwargs):
        """if clipboard state is switched to "off".

        .. versionadded:: 1.8

        """
        self._callback_add("clipboard,state,off", func, *args, **kwargs)

    def callback_clipboard_state_off_del(self, func):
        self._callback_del("clipboard,state,off", func)


_object_mapping_register("Elm_Conformant", Conformant)
