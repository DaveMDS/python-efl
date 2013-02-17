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

include "widget_header.pxi"

from layout_class cimport LayoutClass
from object cimport Object

class ProgressbarPulseState(int):
    def __new__(cls, Object obj, int state):
        return int.__new__(cls, state)

    def __init__(self, Object obj, int state):
        self.obj = obj

    def __call__(self, int state):
        return self.obj._pulse(state)

cdef class Progressbar(LayoutClass):

    """

    The progress bar is a widget for visually representing the progress
    status of a given job/task.

    A progress bar may be horizontal or vertical. It may display an icon
    besides it, as well as primary and **units** labels. The former is meant
    to label the widget as a whole, while the latter, which is formatted
    with floating point values (and thus accepts a ``printf``-style format
    string, like ``"%1.2f units"``), is meant to label the widget's B{progress
    value}. Label, icon and unit strings/objects are **optional** for
    progress bars.

    A progress bar may be **inverted**, in which case it gets its values
    inverted, i.e., high values being on the left or top and low values on
    the right or bottom, for horizontal and vertical modes respectively.

    The **span** of the progress, as set by :py:attr:`span_size`, is its length
    (horizontally or vertically), unless one puts size hints on the widget
    to expand on desired directions, by any container. That length will be
    scaled by the object or applications scaling factor. Applications can
    query the progress bar for its value with :py:attr:`value`.

    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout.Layout`:

        - ``"changed"`` - when the value is changed

    This widget has the following styles:

        - ``"default"``
        - ``"wheel"`` (simple style, no text, no progression, only "pulse"
            effect is available)

    Default text parts of the progressbar widget that you can use for are:

        - "default" - Label of the progressbar

    Default content parts of the progressbar widget that you can use for are:

        - "icon" - An icon of the progressbar

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_progressbar_add(parent.obj))

    property pulse:
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

        :type pulse: bool

        """
        def __set__(self, pulse):
            elm_progressbar_pulse_set(self.obj, pulse)

        def __get__(self):
            return ProgressbarPulseState(elm_progressbar_pulse_get(self.obj))

    def _pulse(self, state):
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

        def __set__(self, format):
            elm_progressbar_unit_format_set(self.obj, _cfruni(format) if format is not None else NULL)

    def unit_format_set(self, format):
        elm_progressbar_unit_format_set(self.obj, _cfruni(format) if format is not None else NULL)
    def unit_format_get(self):
        return _ctouni(elm_progressbar_unit_format_get(self.obj))

    property unit_format_function:
        """Set the callback function to format the unit string.

        @see: L{unit_format} for more info on how this works.

        @type: function

        """
        def __set__(self, func not None):
            pass
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


_object_mapping_register("elm_progressbar", Progressbar)
