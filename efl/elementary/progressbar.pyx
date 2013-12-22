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
#

"""

Widget description
------------------

.. image:: /images/progressbar-preview.png
    :align: left

The progress bar is a widget for visually representing the progress
status of a given job/task.

A progress bar may be horizontal or vertical. It may display an icon
besides it, as well as primary and **units** labels. The former is meant
to label the widget as a whole, while the latter, which is formatted
with floating point values (and thus accepts a ``printf``-style format
string, like ``"%1.2f units"``), is meant to label the widget's **progress
value**. Label, icon and unit strings/objects are **optional** for
progress bars.

A progress bar may be **inverted**, in which case it gets its values
inverted, i.e., high values being on the left or top and low values on
the right or bottom, for horizontal and vertical modes respectively.

The **span** of the progress, as set by :py:attr:`~Progressbar.span_size`, is
its length (horizontally or vertically), unless one puts size hints on the
widget to expand on desired directions, by any container. That length will be
scaled by the object or applications scaling factor. Applications can query the
progress bar for its value with :py:attr:`~Progressbar.value`.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - when the value is changed
- ``focused`` - When the progressbar has received focus. (since 1.8)
- ``unfocused`` - When the progressbar has lost focus. (since 1.8)

This widget has the following styles:

- ``default``
- ``wheel`` (simple style, no text, no progression, only "pulse"
  effect is available)
- ``double`` (style with two independent progress indicators)

Default text parts of the progressbar widget that you can use for are:

- ``default`` - Label of the progressbar

Default content parts of the progressbar widget that you can use for are:

- ``icon`` - An icon of the progressbar

Default part names for the "recording" style:

- ``elm.cur.progressbar`` - The "main" indicator bar
- ``elm.cur.progressbar1`` - The "secondary" indicator bar

"""

from cpython cimport PyUnicode_AsUTF8String

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass
from object cimport Object


cdef class Progressbar(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_progressbar_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property pulse_mode:
        """Whether a given progress bar widget is at "pulsing mode" or not.

        By default, progress bars will display values from the low to high
        value boundaries. There are, though, contexts in which the progress
        of a given task is **unknown**.  For such cases, one can set a
        progress bar widget to a "pulsing state", to give the user an idea
        that some computation is being held, but without exact progress
        values. In the default theme, it will animate its bar with the
        contents filling in constantly and back to non-filled, in a loop. To
        start and stop this pulsing animation, one has to explicitly call
        pulse(True) or pulse(False).

        :type: bool

        """
        def __set__(self, pulse):
            elm_progressbar_pulse_set(self.obj, pulse)

        def __get__(self):
            return bool(elm_progressbar_pulse_get(self.obj))

    def pulse_mode_set(self, state):
        elm_progressbar_pulse_set(self.obj, state)
    def pulse_mode_get(self):
        return bool(elm_progressbar_pulse_get(self.obj))

    def pulse(self, state):
        """Start (state=True) or stop (state=False) the pulsing animation.

        Note that :py:attr:`pulse_mode` must be enabled for this to work.

        :param state: Whenever to start or stop the pulse animation.
        :type state: bool

        """
        elm_progressbar_pulse(self.obj, state)

    property value:
        """The progress value (in percentage) on a given progress bar widget.

        The progress value (**must** be between ``0.0`` and ``1.0``)

        .. note:: If you set a value out of the specified range for ``val``,
            it will be interpreted as the **closest** of the **boundary**
            values in the range.

        :type: float

        """
        def __get__(self):
            return elm_progressbar_value_get(self.obj)

        def __set__(self, value):
            elm_progressbar_value_set(self.obj, value)

    def value_set(self, value):
        elm_progressbar_value_set(self.obj, value)
    def value_get(self):
        return elm_progressbar_value_get(self.obj)

    def part_value_get(self, part not None):
        """part_value_get(part) -> int

        Get the progress status (in percentage) for the given part.

        This can be used with a progressbar of style: "recording". The recording
        style have two different part that can represent two different progress
        operation on the same progressbar at the same time.
        The default theme provide two parts by default:
        "elm.cur.progressbar" and "elm.cur.progressbar1"

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return elm_progressbar_part_value_get(self.obj, <const_char *>part)

    def part_value_set(self, part not None, double value):
        """part_value_set(part, int value)

        Set the progress status (in percentage) for the given part.

        :see: :py:func:`part_value_get` for more info.

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        elm_progressbar_part_value_set(self.obj, <const_char *>part, value)

    property span_size:
        """The (exact) length of the bar region of a given progress bar widget.

        This property is the minimum width (when in horizontal mode) or height
        (when in vertical mode) of the actual bar area of the progress bar.
        This in turn affects the object's minimum size. Use this when you're
        not setting other size hints expanding on the given direction (like
        weight and alignment hints) and you would like it to have a specific
        size.

        .. note:: Icon, label and unit text around the object will require their
            own space, which will make the object to actually require more size.

        :type: Evas_Coord (int)

        """
        def __get__(self):
            return elm_progressbar_span_size_get(self.obj)

        def __set__(self, size):
            elm_progressbar_span_size_set(self.obj, size)

    def span_size_set(self, size):
        elm_progressbar_span_size_set(self.obj, size)
    def span_size_get(self):
        return elm_progressbar_span_size_get(self.obj)

    property unit_format:
        """The format string for a given progress bar widget's units label.

        If this is set to ``None``, it will make the objects units area to be
        hidden completely. If not, it'll set the **format string** for the
        units label's **text**. The units label is provided a floating point
        value, so the units text is up display at most one floating point
        value. Note that the units label is optional. Use a format string
        such as "%1.2f meters" for example.

        .. note:: The default format string for a progress bar is an integer
            percentage, as in ``"%.0f %%"``.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_progressbar_unit_format_get(self.obj))

        def __set__(self, unit_format):
            if isinstance(unit_format, unicode): unit_format = PyUnicode_AsUTF8String(unit_format)
            elm_progressbar_unit_format_set(self.obj,
                <const_char *>unit_format if unit_format is not None else NULL)

    def unit_format_set(self, unit_format):
        if isinstance(unit_format, unicode): unit_format = PyUnicode_AsUTF8String(unit_format)
        elm_progressbar_unit_format_set(self.obj,
            <const_char *>unit_format if unit_format is not None else NULL)
    def unit_format_get(self):
        return _ctouni(elm_progressbar_unit_format_get(self.obj))

    # property unit_format_function:
    #     """Set the callback function to format the unit string.

    #     :see: :py:attr:`unit_format` for more info on how this works.

    #     :type: function

    #     """
    #     def __set__(self, func not None):
    #         pass
            #if not callable(func):
                #raise TypeError("func is not callable")
            #TODO: char * func(double value)
            #elm_progressbar_unit_format_function_set(self.obj, func, NULL)

    property horizontal:
        """The orientation of a given progress bar widget.

        This property reflects how your progress bar is to be disposed:
        vertically or horizontally.

        :type: bool

        """
        def __get__(self):
            return bool(elm_progressbar_horizontal_get(self.obj))

        def __set__(self, horizontal):
            elm_progressbar_horizontal_set(self.obj, horizontal)

    def horizontal_set(self, horizontal):
        elm_progressbar_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return bool(elm_progressbar_horizontal_get(self.obj))

    property inverted:
        """Whether a given progress bar widget's displaying values are
        inverted or not.

        A progress bar may be **inverted**, in which state it gets its values
        inverted, with high values being on the left or top and low values
        on the right or bottom, as opposed to normally have the low values
        on the former and high values on the latter, respectively, for
        horizontal and vertical modes.

        :type: bool

        """
        def __get__(self):
            return bool(elm_progressbar_inverted_get(self.obj))

        def __set__(self, inverted):
            elm_progressbar_inverted_set(self.obj, inverted)

    def inverted_set(self, inverted):
        elm_progressbar_inverted_set(self.obj, inverted)
    def inverted_get(self):
        return bool(elm_progressbar_inverted_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """When the value is changed."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the progressbar has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the progressbar has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Progressbar", Progressbar)
