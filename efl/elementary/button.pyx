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

cdef class Button(LayoutClass):

    """

    This is a push-button. Press it and run some function. It can contain
    a simple label and icon object and it also has an autorepeat feature.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

    - "clicked": the user clicked the button (press/release).
    - "repeated": the user pressed the button without releasing it.
    - "pressed": button was pressed.
    - "unpressed": button was released after being pressed.

    Also, defined in the default theme, the button has the following styles
    available:

    - default: a normal button.
    - anchor: Like default, but the button fades away when the mouse is not
          over it, leaving only the text or icon.
    - hoversel_vertical: Internally used by
        :py:class:`elementary.hoversel.Hoversel` to give a continuous look
        across its options.
    - hoversel_vertical_entry: Another internal for
        :py:class:`elementary.hoversel.Hoversel`.
    - naviframe: Internally used by
        :py:class:`elementary.naviframe.Naviframe` for its back button.
    - colorselector: Internally used by
        :py:class:`elementary.colorselector.Colorselector` for its left and
        right buttons.

    Default content parts of the button widget that you can use for are:

    - "icon" - An icon of the button

    Default text parts of the button widget that you can use for are:

    - "default" - Label of the button

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_button_add(parent.obj))

    property autorepeat:
        """Turn on/off the autorepeat event generated when the button is
        kept pressed

        When off, no autorepeat is performed and buttons emit a normal
        ``clicked`` signal when they are clicked.

        When on, keeping a button pressed will continuously emit a
        ``repeated`` signal until the button is released. The time it takes
        until it starts emitting the signal is given by
        :py:attr:`autorepeat_initial_timeout`, and the time between each new
        emission by :py:attr:`autorepeat_gap_timeout`.

        :type: bool

        """
        def __get__(self):
            return bool(elm_button_autorepeat_get(self.obj))
        def __set__(self, on):
            elm_button_autorepeat_set(self.obj, on)

    def autorepeat_set(self, on):
        elm_button_autorepeat_set(self.obj, on)
    def autorepeat_get(self):
        return bool(elm_button_autorepeat_get(self.obj))

    property autorepeat_initial_timeout:
        """The initial timeout before the autorepeat event is generated

        Reflects the timeout, in seconds, since the button is pressed until
        the first ``repeated`` signal is emitted. If ``t`` is 0.0 or less,
        there won't be any delay and the event will be fired the moment the
        button is pressed.

        .. seealso:: :py:attr:`autorepeat`, :py:attr:`autorepeat_gap_timeout`

        :type: float

        """
        def __get__(self):
            return elm_button_autorepeat_initial_timeout_get(self.obj)
        def __set__(self, t):
            elm_button_autorepeat_initial_timeout_set(self.obj, t)

    def autorepeat_initial_timeout_set(self, t):
        elm_button_autorepeat_initial_timeout_set(self.obj, t)
    def autorepeat_initial_timeout_get(self):
        return elm_button_autorepeat_initial_timeout_get(self.obj)

    property autorepeat_gap_timeout:
        """The interval between each generated autorepeat event

        After the first ``repeated`` event is fired, all subsequent ones will
        follow after a delay of ``t`` seconds for each.

        .. seealso:: :py:attr:`autorepeat_initial_timeout`

        :type: float

        """
        def __get__(self):
            return elm_button_autorepeat_gap_timeout_get(self.obj)
        def __set__(self, t):
            elm_button_autorepeat_gap_timeout_set(self.obj, t)

    def autorepeat_gap_timeout_set(self, t):
        elm_button_autorepeat_gap_timeout_set(self.obj, t)
    def autorepeat_gap_timeout_get(self):
        return elm_button_autorepeat_gap_timeout_get(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        """The user clicked the button (press/release)."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_repeated_add(self, func, *args, **kwargs):
        """The user pressed the button without releasing it."""
        self._callback_add("repeated", func, *args, **kwargs)

    def callback_repeated_del(self, func):
        self._callback_del("repeated", func)

    def callback_pressed_add(self, func, *args, **kwargs):
        """The button was pressed."""
        self._callback_add("pressed", func, *args, **kwargs)

    def callback_pressed_del(self, func):
        self._callback_del("pressed", func)

    def callback_unpressed_add(self, func, *args, **kwargs):
        """The button was released after being pressed."""
        self._callback_add("unpressed", func, *args, **kwargs)

    def callback_unpressed_del(self, func):
        self._callback_del("unpressed", func)


_object_mapping_register("elm_button", Button)
