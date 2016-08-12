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

include "notify_cdef.pxi"

# TODO: move this to cdefs
ELM_NOTIFY_ALIGN_FILL = -1.0

cdef class Notify(Object):
    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Notify(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_notify_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property parent:
        """The notify parent.

        Once the parent object is set, a previously set one will be disconnected
        and replaced.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_notify_parent_get(self.obj))

        def __set__(self, evasObject parent):
            elm_notify_parent_set(self.obj, parent.obj if parent is not None else NULL)

    def parent_set(self, evasObject parent):
        elm_notify_parent_set(self.obj, parent.obj if parent is not None else NULL)
    def parent_get(self):
        return object_from_instance(elm_notify_parent_get(self.obj))

    property timeout:
        """The time interval after which the notify window is going to be
        hidden.

        Setting this starts the timer controlling when the notify is hidden.
        Since calling :py:meth:`efl.evas.Object.show` on a notify restarts the
        timer controlling when the notify is hidden, setting this before the
        notify is shown will in effect mean starting the timer when the notify
        is shown.

        .. note:: Set a value <= 0.0 to disable a running timer.

        .. note:: If the value > 0.0 and the notify is previously visible, the
            timer will be started with this value, canceling any running timer.

        :type: float

        """
        def __get__(self):
            return elm_notify_timeout_get(self.obj)

        def __set__(self, timeout):
            elm_notify_timeout_set(self.obj, timeout)

    def timeout_set(self, double timeout):
        elm_notify_timeout_set(self.obj, timeout)
    def timeout_get(self):
        return elm_notify_timeout_get(self.obj)

    property allow_events:
        """Whether events should be passed to by a click outside its area.

        When True if the user clicks outside the window the events will be
        caught by the others widgets, else the events are blocked.

        .. note:: The default value is True.

        :type: bool

        """
        def __get__(self):
            return bool(elm_notify_allow_events_get(self.obj))

        def __set__(self, allow_events):
            elm_notify_allow_events_set(self.obj, allow_events)

    def allow_events_set(self, repeat):
        elm_notify_allow_events_set(self.obj, repeat)
    def allow_events_get(self):
        return bool(elm_notify_allow_events_get(self.obj))

    def dismiss(self):
        """Dismiss a notify object.

        .. versionadded:: 1.17

        """
        elm_notify_dismiss(self.obj)

    property align:
        """Set the alignment of the notify object

        :type: (float **horizontal**, float **vertical**)

        Sets the alignment in which the notify will appear in its parent.

        .. note:: To fill the notify box in the parent area, please pass
            :ref:`ELM_NOTIFY_ALIGN_FILL` to
            ``horizontal``, ``vertical``.

        .. versionadded:: 1.8

        """
        def __set__(self, value):
            cdef double horizontal, vertical
            horizontal, vertical = value
            elm_notify_align_set(self.obj, horizontal, vertical)

        def __get__(self):
            cdef double horizontal, vertical
            elm_notify_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

    def align_set(self, float horizontal, float vertical):
        elm_notify_align_set(self.obj, horizontal, vertical)

    def align_get(self):
        cdef double horizontal, vertical
        elm_notify_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def callback_timeout_add(self, func, *args, **kwargs):
        """When timeout happens on notify and it's hidden."""
        self._callback_add("timeout", func, args, kwargs)

    def callback_timeout_del(self, func):
        self._callback_del("timeout", func)

    def callback_block_clicked_add(self, func, *args, **kwargs):
        """When a click outside of the notify happens."""
        self._callback_add("block,clicked", func, args, kwargs)

    def callback_block_clicked_del(self, func):
        self._callback_del("block,clicked", func)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """When notify is closed as a result of a dismiss.

        .. versionadded:: 1.17

        """
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)


    property orient:
        def __get__(self):
            return self.orient_get()

        def __set__(self, orient):
            self.orient_set(orient)

    @DEPRECATED("1.8", "Use align instead.")
    def orient_set(self, int orient):
        elm_notify_orient_set(self.obj, orient)
    @DEPRECATED("1.8", "Use align instead.")
    def orient_get(self):
        return elm_notify_orient_get(self.obj)


_object_mapping_register("Elm_Notify", Notify)
