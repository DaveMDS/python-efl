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

include "label_cdef.pxi"

cdef class Label(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Label(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_label_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property line_wrap:
        """The wrapping behavior of the label

        By default no wrapping is done.

        :type: :ref:`Elm_Wrap_Type`

        """
        def __get__(self):
            return elm_label_line_wrap_get(self.obj)

        def __set__(self, wrap):
            elm_label_line_wrap_set(self.obj, wrap)

    def line_wrap_set(self, Elm_Wrap_Type wrap):
        elm_label_line_wrap_set(self.obj, wrap)
    def line_wrap_get(self):
        return elm_label_line_wrap_get(self.obj)

    property wrap_width:
        """Wrap width of the label

        This is the maximum width size hint of the label.

        .. warning:: This is only relevant if the label is inside a container.

        :type: int

        """
        def __get__(self):
            return elm_label_wrap_width_get(self.obj)

        def __set__(self, w):
            elm_label_wrap_width_set(self.obj, w)

    def wrap_width_set(self, int w):
        elm_label_wrap_width_set(self.obj, w)
    def wrap_width_get(self):
        return elm_label_wrap_width_get(self.obj)

    property ellipsis:
        """The ellipsis behavior of the label

        If set to True and the text doesn't fit in the label an
        ellipsis("...") will be shown at the end of the widget.

        .. warning:: This doesn't work with slide(:py:attr:`slide`) or if the
            chosen wrap method was ELM_WRAP_WORD.

        :type: bool

        """
        def __get__(self):
            return elm_label_ellipsis_get(self.obj)

        def __set__(self, ellipsis):
            elm_label_ellipsis_set(self.obj, ellipsis)

    def ellipsis_set(self, bint ellipsis):
        elm_label_ellipsis_set(self.obj, ellipsis)
    def ellipsis_get(self):
        return elm_label_ellipsis_get(self.obj)

    property slide_duration:
        """The duration time in moving text from slide begin position to
        slide end position

        :type: float

        .. note:: If you set the speed of the slide using :py:attr:`slide_speed`
                  you cannot get the correct duration using this function until
                  the label is actually rendered and resized.

        """
        def __get__(self):
            return elm_label_slide_duration_get(self.obj)

        def __set__(self, duration):
            elm_label_slide_duration_set(self.obj, duration)

    def slide_duration_set(self, duration):
        elm_label_slide_duration_set(self.obj, duration)
    def slide_duration_get(self):
        return elm_label_slide_duration_get(self.obj)

    property slide_speed:
        """The speed of the slide animation in px per seconds

        :type: float

        .. note:: If you set the duration of the slide using :py:attr:`slide_duration`
                  you cannot get the correct speed using this function until
                  the label is actually rendered and resized.

        .. versionadded:: 1.9

        """
        def __get__(self):
            return elm_label_slide_speed_get(self.obj)

        def __set__(self, speed):
            elm_label_slide_speed_set(self.obj, speed)

    def slide_speed_set(self, speed):
        elm_label_slide_speed_set(self.obj, speed)
    def slide_speed_get(self):
        return elm_label_slide_speed_get(self.obj)

    property slide_mode:
        """Change the slide mode of the label widget.

        By default, slide mode is none.

        :type: :ref:`Elm_Label_Slide_Mode`

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_label_slide_mode_get(self.obj)

        def __set__(self, mode):
            elm_label_slide_mode_set(self.obj, mode)

    def slide_mode_set(self, mode):
        elm_label_slide_mode_set(self.obj, mode)
    def slide_mode_get(self):
        return elm_label_slide_mode_get(self.obj)

    def slide_go(self):
        """Start the slide effect.

        .. versionadded:: 1.8

        """
        elm_label_slide_go(self.obj)

    def callback_slide_end_add(self, func, *args, **kwargs):
        """A slide effect has ended."""
        self._callback_add("slide,end", func, args, kwargs)

    def callback_slide_end_del(self, func):
        self._callback_del("slide,end", func)

_object_mapping_register("Elm_Label", Label)
