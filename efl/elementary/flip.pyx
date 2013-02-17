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

.. rubric:: Flip directions

.. data:: ELM_FLIP_DIRECTION_UP

    Allows interaction with the top of the widget.

.. data:: ELM_FLIP_DIRECTION_DOWN

    Allows interaction with the bottom of the widget.

.. data:: ELM_FLIP_DIRECTION_LEFT

    Allows interaction with the left portion of

    the widget.
.. data:: ELM_FLIP_DIRECTION_RIGHT

    Allows interaction with the right portion of

    the widget.


.. rubric:: Flip interaction modes

.. data:: ELM_FLIP_INTERACTION_NONE

    No interaction is allowed

.. data:: ELM_FLIP_INTERACTION_ROTATE

    Interaction will cause rotate animation

.. data:: ELM_FLIP_INTERACTION_CUBE

    Interaction will cause cube animation

.. data:: ELM_FLIP_INTERACTION_PAGE

    Interaction will cause page animation


.. rubric:: Flip rotation modes

.. data:: ELM_FLIP_ROTATE_Y_CENTER_AXIS

    Rotate the currently visible content around a vertical axis in the
    middle of its width, the other content is shown as the other side of the
    flip.

.. data:: ELM_FLIP_ROTATE_X_CENTER_AXIS

    Rotate the currently visible content around a horizontal axis in the
    middle of its height, the other content is shown as the other side of
    the flip.

.. data:: ELM_FLIP_ROTATE_XZ_CENTER_AXIS

    Rotate the currently visible content around a diagonal axis in the
    middle of its width, the other content is shown as the other side of the
    flip.

.. data:: ELM_FLIP_ROTATE_YZ_CENTER_AXIS

    Rotate the currently visible content around a diagonal axis in the
    middle of its height, the other content is shown as the other side of
    the flip.


.. rubric:: Flip cube modes

.. data:: ELM_FLIP_CUBE_LEFT

    Rotate the currently visible content to the left as if the flip was a
    cube, the other content is show as the right face of the cube.

.. data:: ELM_FLIP_CUBE_RIGHT

    Rotate the currently visible content to the right as if the flip was a
    cube, the other content is show as the left face of the cube.

.. data:: ELM_FLIP_CUBE_UP

    Rotate the currently visible content up as if the flip was a cube, the
    other content is show as the bottom face of the cube.

.. data:: ELM_FLIP_CUBE_DOWN

    Rotate the currently visible content down as if the flip was a cube, the
    other content is show as the upper face of the cube.


.. rubric:: Flip page modes

.. data:: ELM_FLIP_PAGE_LEFT

    Move the currently visible content to the left as if the flip was a
    book, the other content is shown as the page below that.

.. data:: ELM_FLIP_PAGE_RIGHT

    Move the currently visible content to the right as if the flip was a
    book, the other content is shown as the page below that.

.. data:: ELM_FLIP_PAGE_UP

    Move the currently visible content up as if the flip was a book, the
    other content is shown as the page below that.

.. data:: ELM_FLIP_PAGE_DOWN

    Move the currently visible content down as if the flip was a book, the
    other content is shown as the page below that.

"""

include "widget_header.pxi"

from object cimport Object

cimport enums

ELM_FLIP_DIRECTION_UP = enums.ELM_FLIP_DIRECTION_UP
ELM_FLIP_DIRECTION_DOWN = enums.ELM_FLIP_DIRECTION_DOWN
ELM_FLIP_DIRECTION_LEFT = enums.ELM_FLIP_DIRECTION_LEFT
ELM_FLIP_DIRECTION_RIGHT = enums.ELM_FLIP_DIRECTION_RIGHT

ELM_FLIP_INTERACTION_NONE = enums.ELM_FLIP_INTERACTION_NONE
ELM_FLIP_INTERACTION_ROTATE = enums.ELM_FLIP_INTERACTION_ROTATE
ELM_FLIP_INTERACTION_CUBE = enums.ELM_FLIP_INTERACTION_CUBE
ELM_FLIP_INTERACTION_PAGE = enums.ELM_FLIP_INTERACTION_PAGE

ELM_FLIP_ROTATE_Y_CENTER_AXIS = enums.ELM_FLIP_ROTATE_Y_CENTER_AXIS
ELM_FLIP_ROTATE_X_CENTER_AXIS = enums.ELM_FLIP_ROTATE_X_CENTER_AXIS
ELM_FLIP_ROTATE_XZ_CENTER_AXIS = enums.ELM_FLIP_ROTATE_XZ_CENTER_AXIS
ELM_FLIP_ROTATE_YZ_CENTER_AXIS = enums.ELM_FLIP_ROTATE_YZ_CENTER_AXIS
ELM_FLIP_CUBE_LEFT = enums.ELM_FLIP_CUBE_LEFT
ELM_FLIP_CUBE_RIGHT = enums.ELM_FLIP_CUBE_RIGHT
ELM_FLIP_CUBE_UP = enums.ELM_FLIP_CUBE_UP
ELM_FLIP_CUBE_DOWN = enums.ELM_FLIP_CUBE_DOWN
ELM_FLIP_PAGE_LEFT = enums.ELM_FLIP_PAGE_LEFT
ELM_FLIP_PAGE_RIGHT = enums.ELM_FLIP_PAGE_RIGHT
ELM_FLIP_PAGE_UP = enums.ELM_FLIP_PAGE_UP
ELM_FLIP_PAGE_DOWN = enums.ELM_FLIP_PAGE_DOWN

cdef class Flip(Object):

    """

    This widget holds two content :py:class:`evas.object.Object` s: one on
    the front and one on the back. It allows you to flip from front to back
    and vice-versa using various animations.

    If either the front or back contents are not set the flip will treat that
    as transparent. So if you were to set the front content but not the back,
    and then call :py:func:`go()` you would see whatever is below the flip.

    For a list of supported animations see :py:func:`go()`.

    Signals that you can add callbacks for are:

    - "animate,begin" - when a flip animation was started
    - "animate,done" - when a flip animation is finished

    Default content parts of the flip widget that you can use for are:

    - "front" - A front content of the flip
    - "back" - A back content of the flip

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_flip_add(parent.obj))


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

    def go(self, flip_mode):
        """go(int flip_mode)

        Runs the flip animation

        Flips the front and back contents using the ``mode`` animation. This
        effectively hides the currently visible content and shows the hidden one.

        There a number of possible animations to use for the flipping:

        - ELM_FLIP_ROTATE_X_CENTER_AXIS - Rotate the currently visible content
          around a horizontal axis in the middle of its height, the other
          content is shown as the other side of the flip.
        - ELM_FLIP_ROTATE_Y_CENTER_AXIS - Rotate the currently visible content
          around a vertical axis in the middle of its width, the other
          content is shown as the other side of the flip.
        - ELM_FLIP_ROTATE_XZ_CENTER_AXIS - Rotate the currently visible content
          around a diagonal axis in the middle of its width, the other
          content is shown as the other side of the flip.
        - ELM_FLIP_ROTATE_YZ_CENTER_AXIS - Rotate the currently visible content
          around a diagonal axis in the middle of its height, the other
          content is shown as the other side of the flip.
        - ELM_FLIP_CUBE_LEFT - Rotate the currently visible content to the left
          as if the flip was a cube, the other content is show as the right
          face of the cube.
        - ELM_FLIP_CUBE_RIGHT - Rotate the currently visible content to the
          right as if the flip was a cube, the other content is show as the
          left face of the cube.
        - ELM_FLIP_CUBE_UP - Rotate the currently visible content up as if the
          flip was a cube, the other content is show as the bottom face of
          the cube.
        - ELM_FLIP_CUBE_DOWN - Rotate the currently visible content down as if
          the flip was a cube, the other content is show as the upper face
          of the cube.
        - ELM_FLIP_PAGE_LEFT - Move the currently visible content to the
          left as if the flip was a book, the other content is shown as the
          page below that.
        - ELM_FLIP_PAGE_RIGHT - Move the currently visible content to the right
          as if the flip was a book, the other content is shown as the page
          below that.
        - ELM_FLIP_PAGE_UP - Move the currently visible content up as if the
          flip was a book, the other content is shown as the page below that.
        - ELM_FLIP_PAGE_DOWN - Move the currently visible content down as if
          the flip was a book, the other content is shown as the page below
          that.

        :param mode: The mode type
        :type mode: Elm_Flip_Mode

        """
        elm_flip_go(self.obj, flip_mode)

    property interaction:
        """The interactive flip mode

        Whether the flip should be interactive (allow user to click and
        drag a side of the flip to reveal the back page and cause it to flip).
        By default a flip is not interactive. You may also need to set which
        sides of the flip are "active" for flipping and how much space they
        use (a minimum of a finger size) with
        :py:func:`interaction_direction_enabled_set()` and
        :py:func:`interaction_direction_hitsize_set()`

        The four available mode of interaction are:

        - ELM_FLIP_INTERACTION_NONE - No interaction is allowed
        - ELM_FLIP_INTERACTION_ROTATE - Interaction will cause rotate animation
        - ELM_FLIP_INTERACTION_CUBE - Interaction will cause cube animation
        - ELM_FLIP_INTERACTION_PAGE - Interaction will cause page animation

        .. note:: ELM_FLIP_INTERACTION_ROTATE won't cause
            ELM_FLIP_ROTATE_XZ_CENTER_AXIS or ELM_FLIP_ROTATE_YZ_CENTER_AXIS to
            happen, those can only be achieved with :py:func:`go()`

        :type: Elm_Flip_Interaction

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
        """interaction_direction_enabled_set(int direction, bool enable)

        Set which directions of the flip respond to interactive flip

        By default all directions are disabled, so you may want to enable the
        desired directions for flipping if you need interactive flipping.
        You must call this function once for each direction that should be
        enabled.

        .. seealso:: :py:attr:`interaction`

        :param direction: The direction to change
        :type direction: Elm_Flip_Direction
        :param enabled: If that direction is enabled or not
        :type enabled: bool

        """
        elm_flip_interaction_direction_enabled_set(self.obj, direction, enable)

    def interaction_direction_enabled_get(self, direction):
        """interaction_direction_enabled_get(int direction) -> bool

        Get the enabled state of that flip direction

        Gets the enabled state set by
        :py:func:`interaction_direction_enabled_set()`

        .. seealso:: :py:attr:`interaction`

        :param dir: The direction to check
        :type dir: Elm_Flip_Direction
        :return: If that direction is enabled or not
        :rtype: bool

        """
        return elm_flip_interaction_direction_enabled_get(self.obj, direction)

    def interaction_direction_hitsize_set(self, direction, hitsize):
        """interaction_direction_hitsize_set(int direction, float hitsize)

        Set the amount of the flip that is sensitive to interactive flip

        Set the amount of the flip that is sensitive to interactive flip,
        with 0 representing no area in the flip and 1 representing the
        entire flip. There is however a consideration to be made in that the
        area will never be smaller than the finger size set(as set in your
        Elementary configuration).

        .. seealso:: :py:attr:`interaction`

        :param dir: The direction to modify
        :type dir: Elm_Flip_Direction
        :param hitsize: The amount of that dimension (0.0 to 1.0) to use
        :type hitsize: float

        """
        elm_flip_interaction_direction_hitsize_set(self.obj, direction, hitsize)

    def interaction_direction_hitsize_get(self, direction):
        """interaction_direction_hitsize_get(int direction) -> float

        Get the amount of the flip that is sensitive to interactive flip

        Returns the amount of sensitive area set by
        :py:func:`interaction_direction_hitsize_set()`.

        :param dir: The direction to check
        :type dir: Elm_Flip_Direction
        :return: The size set for that direction
        :rtype: double

        """
        return elm_flip_interaction_direction_hitsize_get(self.obj, direction)

    def callback_animate_begin_add(self, func, *args, **kwargs):
        """When a flip animation was started."""
        self._callback_add("animate,begin", func, *args, **kwargs)

    def callback_animate_begin_del(self, func):
        self._callback_del("animate,begin", func)

    def callback_animate_done_add(self, func, *args, **kwargs):
        """When a flip animation is finished."""
        self._callback_add("animate,done", func, *args, **kwargs)

    def callback_animate_done_del(self, func):
        self._callback_del("animate,done", func)


_object_mapping_register("elm_flip", Flip)
