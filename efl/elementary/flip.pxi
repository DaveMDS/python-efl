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

include "flip_cdef.pxi"

cdef class Flip(Object):
    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Flip(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_flip_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property front_visible:
        """Front visibility state

        :type: bool

        """
        def __get__(self):
            return elm_flip_front_visible_get(self.obj)

    def front_visible_get(self):
        return elm_flip_front_visible_get(self.obj)

    property perspective:
        """Set flip perspective

        .. warning:: This function currently does nothing.

        :type: tuple of Evas_Coords (int)

        """
        def __set__(self, value):
            foc, x, y = value
            elm_flip_perspective_set(self.obj, foc, x, y)

    def perspective_set(self, foc, x, y):
        elm_flip_perspective_set(self.obj, foc, x, y)

    def go(self, Elm_Flip_Mode flip_mode):
        """Runs the flip animation

        Flips the front and back contents using the ``flip_mode`` animation. This
        effectively hides the currently visible content and shows the hidden one.

        :param flip_mode: The mode type
        :type flip_mode: :ref:`Elm_Flip_Mode`

        """
        elm_flip_go(self.obj, flip_mode)

    def flip_go_to(self, bint front, Elm_Flip_Mode flip_mode):
        """Runs the flip animation to front or back.

        :param front: if True, makes front visible, otherwise makes back.
        :type front: bool
        :param flip_mode: The mode type
        :type flip_mode: :ref:`Elm_Flip_Mode`

        Flips the front and back contents using the ``flip_mode`` animation. This
        effectively hides the currently visible content and shows the hidden one.

        .. versionadded:: 1.8

        """
        elm_flip_go_to(self.obj, front, flip_mode)

    property interaction:
        """The interactive flip mode

        Whether the flip should be interactive (allow user to click and
        drag a side of the flip to reveal the back page and cause it to flip).
        By default a flip is not interactive. You may also need to set which
        sides of the flip are "active" for flipping and how much space they
        use (a minimum of a finger size) with
        :py:func:`interaction_direction_enabled_set()` and
        :py:func:`interaction_direction_hitsize_set()`

        .. note:: ELM_FLIP_INTERACTION_ROTATE won't cause
            ELM_FLIP_ROTATE_XZ_CENTER_AXIS or ELM_FLIP_ROTATE_YZ_CENTER_AXIS to
            happen, those can only be achieved with :py:func:`go()`

        :type: :ref:`Elm_Flip_Interaction`

        """
        def __get__(self):
            return elm_flip_interaction_get(self.obj)

        def __set__(self, mode):
            elm_flip_interaction_set(self.obj, mode)

    def interaction_set(self, mode):
        elm_flip_interaction_set(self.obj, mode)
    def interaction_get(self):
        return elm_flip_interaction_get(self.obj)

    def interaction_direction_enabled_set(self, direction, enable):
        """Set which directions of the flip respond to interactive flip

        By default all directions are disabled, so you may want to enable the
        desired directions for flipping if you need interactive flipping.
        You must call this function once for each direction that should be
        enabled.

        .. seealso:: :py:attr:`interaction`

        :param direction: The direction to change
        :type direction: :ref:`Elm_Flip_Direction`
        :param enabled: If that direction is enabled or not
        :type enabled: bool

        """
        elm_flip_interaction_direction_enabled_set(self.obj, direction, enable)

    def interaction_direction_enabled_get(self, direction):
        """Get the enabled state of that flip direction

        Gets the enabled state set by
        :py:func:`interaction_direction_enabled_set()`

        .. seealso:: :py:attr:`interaction`

        :param dir: The direction to check
        :type dir: :ref:`Elm_Flip_Direction`
        :return: If that direction is enabled or not
        :rtype: bool

        """
        return elm_flip_interaction_direction_enabled_get(self.obj, direction)

    def interaction_direction_hitsize_set(self, direction, hitsize):
        """Set the amount of the flip that is sensitive to interactive flip

        Set the amount of the flip that is sensitive to interactive flip,
        with 0 representing no area in the flip and 1 representing the
        entire flip. There is however a consideration to be made in that the
        area will never be smaller than the finger size set(as set in your
        Elementary configuration).

        .. seealso:: :py:attr:`interaction`

        :param dir: The direction to modify
        :type dir: :ref:`Elm_Flip_Direction`
        :param hitsize: The amount of that dimension (0.0 to 1.0) to use
        :type hitsize: float

        """
        elm_flip_interaction_direction_hitsize_set(self.obj, direction, hitsize)

    def interaction_direction_hitsize_get(self, direction):
        """Get the amount of the flip that is sensitive to interactive flip

        Returns the amount of sensitive area set by
        :py:func:`interaction_direction_hitsize_set()`.

        :param dir: The direction to check
        :type dir: :ref:`Elm_Flip_Direction`
        :return: The size set for that direction
        :rtype: double

        """
        return elm_flip_interaction_direction_hitsize_get(self.obj, direction)

    def callback_animate_begin_add(self, func, *args, **kwargs):
        """When a flip animation was started."""
        self._callback_add("animate,begin", func, args, kwargs)

    def callback_animate_begin_del(self, func):
        self._callback_del("animate,begin", func)

    def callback_animate_done_add(self, func, *args, **kwargs):
        """When a flip animation is finished."""
        self._callback_add("animate,done", func, args, kwargs)

    def callback_animate_done_del(self, func):
        self._callback_del("animate,done", func)


_object_mapping_register("Efl_Ui_Flip", Flip)
