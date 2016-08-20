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

include "slider_cdef.pxi"

cdef class Slider(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Slider(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_slider_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property span_size:
        """The (exact) length of the bar region of a given slider widget.

        This property reflects the minimum width (when in horizontal mode)
        or height (when in vertical mode) of the actual bar area of the
        slider. This in turn affects the object's minimum size. Use this
        when you're not setting other size hints expanding on the given
        direction (like weight and alignment hints) and you would like it to
        have a specific size.

        .. note:: Icon, end, label, indicator and unit text around the object
            will require their own space, which will make the object to
            require more the ``size``, actually.

        :type: int

        """
        def __get__(self):
            return elm_slider_span_size_get(self.obj)

        def __set__(self, size):
            elm_slider_span_size_set(self.obj, size)

    def span_size_set(self, size):
        elm_slider_span_size_set(self.obj, size)
    def span_size_get(self):
        return elm_slider_span_size_get(self.obj)

    property unit_format:
        """The format string for the unit label.

        Unit label is displayed all the time, if set, after slider's bar.
        In horizontal mode, at right and in vertical mode, at bottom.

        If ``None``, unit label won't be visible. If not it sets the format
        string for the label text. To the label text is provided a floating point
        value, so the label text can display up to 1 floating point value.
        Note that this is optional.

        Use a format string such as ``"%1.2f meters"`` for example, and it will
        display values like: "3.14 meters" for a value equal to 3.14159.

        Default is unit label disabled.

        :type: unicode

        """
        def __get__(self):
            return _ctouni(elm_slider_unit_format_get(self.obj))

        def __set__(self, unit_format):
            if isinstance(unit_format, unicode): unit_format = PyUnicode_AsUTF8String(unit_format)
            elm_slider_unit_format_set(self.obj,
                <const char *>unit_format if unit_format is not None else NULL)

    def unit_format_set(self, unit_format):
        if isinstance(unit_format, unicode): unit_format = PyUnicode_AsUTF8String(unit_format)
        elm_slider_unit_format_set(self.obj,
            <const char *>unit_format if unit_format is not None else NULL)
    def unit_format_get(self):
        return _ctouni(elm_slider_unit_format_get(self.obj))

    property indicator_format:
        """The format string for the indicator label.

        The slider may display its value somewhere else then unit label, for
        example, above the slider knob that is dragged around. This function
        sets the format string used for this.

        If ``None``, indicator label won't be visible. If not it sets the
        format string for the label text. To the label text is provided a
        floating point value, so the label text can display up to 1 floating
        point value. Note that this is optional.

        Use a format string such as ``"%1.2f meters"`` for example, and it will
        display values like: "3.14 meters" for a value equal to 3.14159.

        Default is indicator label disabled.

        :type: unicode

        """
        def __get__(self):
            return _ctouni(elm_slider_indicator_format_get(self.obj))

        def __set__(self, ind_format):
            if isinstance(ind_format, unicode): ind_format = PyUnicode_AsUTF8String(ind_format)
            elm_slider_indicator_format_set(self.obj,
                <const char *>ind_format if ind_format is not None else NULL)

    def indicator_format_set(self, ind_format):
        if isinstance(ind_format, unicode): ind_format = PyUnicode_AsUTF8String(ind_format)
        elm_slider_indicator_format_set(self.obj,
            <const char *>ind_format if ind_format is not None else NULL)
    def indicator_format_get(self):
        return _ctouni(elm_slider_indicator_format_get(self.obj))

    #TODO: def indicator_format_function_set(self, func, free_func)
    #
    # Since we can't use a custom python function in the callback,
    # make a list of common formatting functions and allow to select
    # one of them.
    #
#~         """Set the format function pointer for the indicator label
#~
#~         Set the callback function to format the indicator string.
#~
#~         .. seealso:: :py:attr:`indicator_format_set()` for more info on how this works.
#~
#~         :param func: The indicator format function.
#~         :type func: function
#~         :param free_func: The freeing function for the format string.
#~         :type free_func: function
#~
#~         """
        #elm_slider_indicator_format_function_set(self.obj, char(*func)(double val), void (*free_func)(charstr))

    #TODO: def units_format_function_set(self, func, free_func)
    #
    # Since we can't use a custom python function in the callback,
    # make a list of common formatting functions and allow to select
    # one of them.
    #
#~         """Set the format function pointer for the units label
#~
#~         Set the callback function to format the units string.
#~
#~         .. seealso:: :py:attr:`units_format_set()` for more info on how this works.
#~
#~         :param func: The units format function.
#~         :type func: function
#~         :param free_func: The freeing function for the format string.
#~         :type free_func: function
#~
#~         """
        #elm_slider_units_format_function_set(self.obj, char(*func)(double val), void (*free_func)(charstr))

    property horizontal:
        """The orientation of a given slider widget.

        This property reflects how your slider is to be disposed: vertically
        or horizontally.

        By default it's displayed horizontally.

        :type: bool

        """
        def __get__(self):
            return bool(elm_slider_horizontal_get(self.obj))

        def __set__(self, horizontal):
            elm_slider_horizontal_set(self.obj, horizontal)

    def horizontal_set(self, horizontal):
        elm_slider_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return bool(elm_slider_horizontal_get(self.obj))

    property min_max:
        """The minimum and maximum values for the slider.

        If actual value is less than ``min``, it will be updated to ``min``. If it
        is bigger then ``max``, will be updated to ``max``. Actual value can be
        get with :py:attr:`value`.

        By default, min is equal to 0.0, and max is equal to 1.0.

        .. warning:: Maximum must be greater than minimum, otherwise behavior
            is undefined.

        :type: (float, float)

        """
        def __get__(self):
            cdef double min, max
            elm_slider_min_max_get(self.obj, &min, &max)
            return (min, max)

        def __set__(self, value):
            min, max = value
            elm_slider_min_max_set(self.obj, min, max)

    def min_max_set(self, min, max):
        elm_slider_min_max_set(self.obj, min, max)
    def min_max_get(self):
        cdef double min, max
        elm_slider_min_max_get(self.obj, &min, &max)
        return (min, max)

    property range_enabled:
        """Enables the range ability.

        This enables two indicators in slider, so that the user can select
        a range, not just a single value.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_slider_range_enabled_get(self.obj))
        def __set__(self, bint enabled):
            elm_slider_range_enabled_set(self.obj, enabled)

    def range_enabled_set(self, bint enabled):
        elm_slider_range_enabled_set(self.obj, enabled)
    def range_enabled_get(self):
        return bool(elm_slider_range_enabled_get(self.obj))

    property range:
        """The values of the two indicators.

        :type: (float, float)

        .. versionadded:: 1.18

        """
        def __get__(self):
            cdef double fr, to
            elm_slider_range_get(self.obj, &fr, &to)
            return (fr, to)

        def __set__(self, value):
            fr, to = value
            elm_slider_range_set(self.obj, fr, to)

    def range_set(self, double fr, double to):
        elm_slider_range_set(self.obj, fr, to)
    def range_get(self):
        cdef double fr, to
        elm_slider_range_get(self.obj, &fr, &to)
        return (fr, to)

    property value:
        """The value displayed in the slider.

        Value will be presented on the unit label following format specified
        with :py:attr:`unit_format` and on indicator with
        :py:attr:`indicator_format`.

        .. warning:: The value must to be between min and max values. These
            values are set by :py:attr:`min_max`.

        .. seealso::
            :py:attr:`unit_format`
            :py:attr:`indicator_format`
            :py:attr:`min_max`

        :type: float

        """
        def __get__(self):
            return elm_slider_value_get(self.obj)

        def __set__(self, value):
            elm_slider_value_set(self.obj, value)

    def value_set(self, value):
        elm_slider_value_set(self.obj, value)
    def value_get(self):
        return elm_slider_value_get(self.obj)

    property inverted:
        """Invert a given slider widget's displaying values order

        A slider may be **inverted**, in which state it gets its
        values inverted, with high vales being on the left or top and
        low values on the right or bottom, as opposed to normally have
        the low values on the former and high values on the latter,
        respectively, for horizontal and vertical modes.

        :type: bool

        """
        def __get__(self):
            return bool(elm_slider_inverted_get(self.obj))

        def __set__(self, inverted):
            elm_slider_inverted_set(self.obj, inverted)

    def inverted_set(self, inverted):
        elm_slider_inverted_set(self.obj, inverted)
    def inverted_get(self):
        return bool(elm_slider_inverted_get(self.obj))

    property indicator_show:
        """Whether to enlarge slider indicator (augmented knob) or not.

        By default, indicator will be bigger while dragged by the user.

        .. warning:: It won't display values set
            with :py:attr:`indicator_format` if you disable indicator.

        :type: bool

        """
        def __get__(self):
            return bool(elm_slider_indicator_show_get(self.obj))

        def __set__(self, show):
            elm_slider_indicator_show_set(self.obj, show)

    def indicator_show_set(self, show):
        elm_slider_indicator_show_set(self.obj, show)
    def indicator_show_get(self):
        return bool(elm_slider_indicator_show_get(self.obj))

    property indicator_visible_mode:
        """The visible mode of indicator

        :type: :ref:`Elm_Slider_Indicator_Visible_Mode`

        .. versionadded:: 1.14

        """
        def __set__(self, indicator_visible_mode):
            elm_slider_indicator_visible_mode_set(self.obj, indicator_visible_mode)
        def __get__(self):
            return elm_slider_indicator_visible_mode_get(self.obj)

    def indicator_visible_mode_set(self, indicator_visible_mode):
        elm_slider_indicator_visible_mode_set(self.obj, indicator_visible_mode)
    def indicator_visible_mode_get(self):
        return elm_slider_indicator_visible_mode_get(self.obj)

    property indicator_show_on_focus:
        """Whether to show the indicator of the slider on focus.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_slider_indicator_show_on_focus_get(self.obj))

        def __set__(self, bint show):
            elm_slider_indicator_show_on_focus_set(self.obj, show)

    def indicator_show_on_focus_set(self, bint show):
        elm_slider_indicator_show_on_focus_set(self.obj, show)
    def indicator_show_on_focus_get(self):
        return bool(elm_slider_indicator_show_on_focus_get(self.obj))

    property step:
        """The step by which slider indicator will move.

        This value is used when draggable object is moved automatically i.e., in
        case of key event when up/down/left/right key is pressed or in case when
        accessibility is set and flick event is used to inc/dec slider values.
        By default step value is equal to 0.05.

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double step):
            elm_slider_step_set(self.obj, step)

        def __get__(self):
            return elm_slider_step_get(self.obj)

    def step_set(self, double step):
        elm_slider_step_set(self.obj, step)
    def step_get(self):
        return elm_slider_step_get(self.obj)

    def callback_changed_add(self, func, *args, **kwargs):
        """Whenever the slider value is changed by the user."""
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_slider_drag_start_add(self, func, *args, **kwargs):
        """Dragging the slider indicator around has started."""
        self._callback_add("slider,drag,start", func, args, kwargs)

    def callback_slider_drag_start_del(self, func):
        self._callback_del("slider,drag,start", func)

    def callback_slider_drag_stop_add(self, func, *args, **kwargs):
        """Dragging the slider indicator around has stopped."""
        self._callback_add("slider,drag,stop", func, args, kwargs)

    def callback_slider_drag_stop_del(self, func):
        self._callback_del("slider,drag,stop", func)

    def callback_delay_changed_add(self, func, *args, **kwargs):
        """A short time after the value is changed by the user. This will be
        called only when the user stops dragging for a very short period or
        when they release their finger/mouse, so it avoids possibly
        expensive reactions to the value change.

        """
        self._callback_add("delay,changed", func, args, kwargs)

    def callback_delay_changed_del(self, func):
        self._callback_del("delay,changed", func)


_object_mapping_register("Elm_Slider", Slider)
