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

include "transit_cdef.pxi"

cdef class TransitCustomEffect(object):
    """TransitCustomEffect(...)

    A prototype class for a :class:`Transit` widgets custom effect.

    Inherit this class and override methods to create your custom effect.

    """
    cdef Transit transit

    def __cinit__(self):
        Py_INCREF(self)

    def transition_cb(self, transit, progress):
        """A callback method that must be overridden to implement the
        effect.

        Called in a loop until the effect is finished.

        """
        pass

    def end_cb(self, transit):
        """A callback method that can be overridden, called when the effect
        is deleted.

        """
        pass

cdef void elm_transit_effect_transition_cb(Elm_Transit_Effect *effect, Elm_Transit *transit, double progress) with gil:
    cdef:
        TransitCustomEffect fect = <TransitCustomEffect?>effect
        Transit tsit = fect.transit

    try:
        fect.transition_cb(tsit, progress)
    except Exception:
        traceback.print_exc()

cdef void elm_transit_effect_end_cb(Elm_Transit_Effect *effect, Elm_Transit *transit) with gil:
    cdef:
        TransitCustomEffect fect = <TransitCustomEffect?>effect
        Transit tsit = fect.transit

    try:
        fect.end_cb(tsit)
    except Exception:
        traceback.print_exc()

    Py_DECREF(fect)

cdef void elm_transit_del_cb(void *data, Elm_Transit *transit) with gil:
    cdef:
        Transit trans
        tuple args
        dict kwargs

    assert data != NULL, "Failed to call Transit del_cb because data is NULL"

    trans = <Transit?>data
    args = trans.del_cb_args
    kwargs = trans.del_cb_kwargs

    try:
        trans.del_cb(trans, *args, **kwargs)
    except Exception:
        traceback.print_exc()

    trans.obj = NULL
    Py_DECREF(trans)

cdef class Transit(object):
    """

    This is the class that actually implement the widget.

    .. note:: It is not necessary to delete the transit object, it will be
              deleted at the end of its operation.

    .. note:: The transit will start playing when the program enters the
              main loop.
    """

    cdef:
        Elm_Transit* obj
        object del_cb
        tuple del_cb_args
        dict del_cb_kwargs

    def __init__(self, *args, **kwargs):
        """Transit(...)

        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self.obj = elm_transit_add()
        self._set_properties_from_keyword_args(kwargs)
        Py_INCREF(self)

    cdef int _set_properties_from_keyword_args(self, dict kwargs) except 0:
        if not kwargs:
            return 1
        cdef list cls_list = dir(self)
        for k, v in kwargs.items():
            assert k in cls_list, "%s has no attribute with the name %s." % (self, k)
            setattr(self, k, v)
        return 1

    def delete(self):
        """Stops the animation and delete the ``transit`` object.

        Call this function if you want to stop the animation before the
        transit time. Make sure the ``transit`` object is still alive with
        :py:func:`del_cb_set()` function. All added effects will be deleted,
        calling its respective data_free_cb functions. The function set by
        :py:func:`del_cb_set()` will be called.

        :py:func:`del_cb_set()`

        """
        elm_transit_del(self.obj)

    def effect_add(self, TransitCustomEffect effect):
        """Add a new effect to the transit.

        Example::

            class MyEffect(TransitCustomEffect):
                # define your methods...

            t = Transit()
            e = MyEffect()
            t.effect_add(e)

        .. warning:: The transit will free the context data at the and of the
            transition with the data_free_cb function. Do not share the
            context data in between different transit objects.

        .. note:: The cb function and the data are the key to the effect. If
            you try to add an existing effect, nothing is done.
        .. note:: After the first addition of an effect to ``transit``, if its
            effect list become empty again, the ``transit`` will be killed by
            :meth:`delete` function.

        :param effect: The context data of the effect.

        """
        effect.transit = self
        elm_transit_effect_add(self.obj,
            elm_transit_effect_transition_cb,
            <void *>effect,
            elm_transit_effect_end_cb)

    def effect_del(self, TransitCustomEffect effect):
        """Delete an added effect.

        This function will remove the effect from the ``transit``, calling the
        data_free_cb to free the ``data``.

        .. seealso:: :py:func:`effect_add()`

        .. note:: If the effect is not found, nothing is done.
        .. note:: If the effect list become empty, this function will call
            elm_transit_del(transit), i.e., it will kill the ``transit``.

        :param effect: The context data of the effect.

        """
        elm_transit_effect_del(self.obj,
            elm_transit_effect_transition_cb,
            <void *>effect)

    def object_add(self, evasObject obj):
        """Add new object to apply the effects.

        .. note:: After the first addition of an object to ``transit``, if its
            object list become empty again, the ``transit`` will be killed by
            elm_transit_del(transit) function.
        .. note:: If the ``obj`` belongs to another transit, the ``obj`` will be
            removed from it and it will only belong to the other ``transit``.
            If the old transit stays without objects, it will die.
        .. note:: When you add an object into the ``transit``, its state from
            evas_object_pass_events_get(obj) is saved, and it is applied
            when the transit ends, if you change this state with
            evas_object_pass_events_set() after add the object, this state
            will change again when ``transit`` stops.

        :param obj: Object to be animated.

        .. warning:: It is not allowed to add a new object after transit begins.

        """
        elm_transit_object_add(self.obj, obj.obj)

    def object_remove(self, evasObject obj):
        """Removes an added object from the transit.

        .. note:: If the ``obj`` is not in the ``transit``, nothing is done.
        .. note:: If the list become empty, this function will call
            transit.delete(), i.e., it will kill the ``transit``.

        :param obj: Object to be removed from ``transit``.

        .. warning:: It is not allowed to remove objects after transit begins.

        """
        elm_transit_object_remove(self.obj, obj.obj)

    property objects:
        """The objects of the transit.

        type: list

        """
        def __get__(self):
            return eina_list_objects_to_python_list(elm_transit_objects_get(self.obj))

    property objects_final_state_keep:
        """Enable/disable keeping up the objects states.

        If it is not kept, the objects states will be reset when transition
        ends.

        .. note:: One state includes geometry, color, map data.

        :type: bool

        """
        def __set__(self, state_keep):
            elm_transit_objects_final_state_keep_set(self.obj, state_keep)

        def __get__(self):
            return bool(elm_transit_objects_final_state_keep_get(self.obj))

    property event_enabled:
        """Set the event enabled when transit is operating.

        If ``enabled`` is True, the objects of the transit will receive
        events from mouse and keyboard during the animation.

        .. note:: When you add an object with :py:func:`object_add()`, its
            state from evas_object_freeze_events_get(obj) is saved, and it is
            applied when the transit ends. If you change this state with
            evas_object_freeze_events_set() after adding the object, this
            state will change again when ``transit`` stops to run.

        :type: bool

        """
        def __set__(self, enabled):
            elm_transit_event_enabled_set(self.obj, enabled)
        def __get__(self):
            return bool(elm_transit_event_enabled_get(self.obj))

    def del_cb_set(self, func, *args, **kwargs):
        """Set the user-callback function when the transit is deleted.

        .. note:: Using this function twice will overwrite the first
            function set.
        .. note:: the ``transit`` object will be deleted after call ``func``
            function.

        :param func: Callback function. This function will be called
            before the deletion of the transit.
        :param data: Callback function user data. It is the ``op`` parameter.

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        self.del_cb = func
        self.del_cb_args = args
        self.del_cb_kwargs = kwargs

        elm_transit_del_cb_set(self.obj, elm_transit_del_cb, <void *>self)

    property auto_reverse:
        """If auto reverse is set, after running the effects with the
        progress parameter from 0 to 1, it will call the effects again with
        the progress from 1 to 0.

        The transit will last for a time equal to (2 * duration * repeat),
        where the duration was set with the function elm_transit_add and
        the repeat with the function :py:attr:`repeat_times`.

        :type: bool

        """
        def __set__(self, reverse):
            elm_transit_auto_reverse_set(self.obj, reverse)
        def __get__(self):
            return bool(elm_transit_auto_reverse_get(self.obj))

    property repeat_times:
        """The transit repeat count. Effect will be repeated by repeat count.

        This property reflects the number of repetition the transit will run
        after the first one, i.e., if ``repeat`` is 1, the transit will run 2
        times. If the ``repeat`` is a negative number, it will repeat
        infinite times.

        .. note:: If this function is called during the transit execution, the
            transit will run ``repeat`` times, ignoring the times it already
            performed.

        :type: int

        """
        def __set__(self, repeat):
            elm_transit_repeat_times_set(self.obj, repeat)
        def __get__(self):
            return elm_transit_repeat_times_get(self.obj)

    property tween_mode:
        """The transit animation acceleration type.

        :type: :ref:`Transit tween mode <Elm_Transit_Tween_Mode>`

        """
        def __set__(self, tween_mode):
            elm_transit_tween_mode_set(self.obj, tween_mode)
        def __get__(self):
            return elm_transit_tween_mode_get(self.obj)

    property tween_mode_factor:
        """Transit animation acceleration factor.

        If you use the below tween modes, you have to set the factor using this API.

        ELM_TRANSIT_TWEEN_MODE_SINUSOIDAL
            Start slow, speed up then slow down at end, v1 being a power factor,
            0.0 being linear, 1.0 being default, 2.0 being much more pronounced
            sinusoidal(squared), 3.0 being cubed, etc.

        ELM_TRANSIT_TWEEN_MODE_DECELERATE
            Start fast then slow down, v1 being a power factor, 0.0 being
            linear, 1.0 being ELM_TRANSIT_TWEEN_MODE_DECELERATE default, 2.0
            being much more pronounced decelerate (squared), 3.0 being cubed,
            etc.

        ELM_TRANSIT_TWEEN_MODE_ACCELERATE
            Start slow then speed up, v1 being a power factor, 0.0 being linear,
            1.0 being ELM_TRANSIT_TWEEN_MODE_ACCELERATE default, 2.0 being much
            more pronounced accelerate (squared), 3.0 being cubed, etc.

        ELM_TRANSIT_TWEEN_MODE_DIVISOR_INTERP
            Start at gradient * v1, interpolated via power of v2 curve

        ELM_TRANSIT_TWEEN_MODE_BOUNCE
            Start at 0.0 then "drop" like a ball bouncing to the ground at 1.0,
            and bounce v2 times, with decay factor of v1

        ELM_TRANSIT_TWEEN_MODE_SPRING
            Start at 0.0 then "wobble" like a spring rest position 1.0, and
            wobble v2 times, with decay factor of v1

        :type: (float **v1**, float **v2**) (defaults are 1.0, 0.0)

        .. seealso:: :py:attr:`tween_mode_factor_n`

        .. versionadded:: 1.8

        """
        def __set__(self, value):
            cdef float v1, v2
            v1, v2 = value
            elm_transit_tween_mode_factor_set(self.obj, v1, v2)

        def __get__(self):
            cdef double v1, v2
            elm_transit_tween_mode_factor_get(self.obj, &v1, &v2)
            return (v1, v2)

    def tween_mode_factor_set(self, float v1, float v2):
        elm_transit_tween_mode_factor_set(self.obj, v1, v2)

    def tween_mode_factor_get(self):
        cdef double v1, v2
        elm_transit_tween_mode_factor_get(self.obj, &v1, &v2)
        return (v1, v2)

    property tween_mode_factor_n:
        """Set the transit animation acceleration factors.

        This is the same as :py:attr:`tween_mode_factor`, but lets you
        specify more than 2 values. Actually only need for the
        ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE mode.

        ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE
            Use an interpolated cubic-bezier curve ajusted with 4 parameters:
            (x1, y1, x2, y2)

        :type: list of doubles

        .. seealso:: :py:attr:`tween_mode_factor`

        .. versionadded:: 1.13

        """
        def __set__(self, values):
            self.tween_mode_factor_n_set(values)

    def tween_mode_factor_n_set(self, list values):
        cdef double *varray = python_list_doubles_to_array_of_doubles(values)
        elm_transit_tween_mode_factor_n_set(self.obj, len(values), varray)
        free(varray)

    property duration:
        """Set the transit animation time

        :type: float

        """
        def __set__(self, float duration):
            elm_transit_duration_set(self.obj, duration)
        def __get__(self):
            return elm_transit_duration_get(self.obj)

    def go(self):
        """Starts the transition. Once this API is called, the transit
        begins to measure the time.

        """
        elm_transit_go(self.obj)

    def go_in(self, seconds):
        """Starts the transition in given seconds.

        :param float seconds: The interval value in seconds

        .. versionadded:: 1.14

        """
        elm_transit_go_in(self.obj, seconds)

    def revert(self):
        """This can be used to reverse play an ongoing transition.

        It shows effect only when an animation is going on.
        If this function is called twice transition will go in forward
        direction as normal one.
        If a repeat count is set, this function call will revert just the
        ongoing cycle and once it is reverted back completely, the transition
        will go in forward direction.
        If an autoreverse is set for the transition and this function is called
        in the midst of the transition the ongoing transition will be reverted
        and once it is done, the transition will begin again and complete a
        full auto reverse cycle.

        :return: ``True`` if the transition is reverted, ``False`` otherwise.
        :rtype: bool

        .. versionadded:: 1.18

        """
        return bool(elm_transit_revert(self.obj))

    property paused:
        """Pause/Resume the transition.

        If you call elm_transit_go again, the transit will be started from the
        beginning, and will be played.

        :type: bool

        """
        def __set__(self, bint paused):
            elm_transit_paused_set(self.obj, paused)
        def __get__(self):
            return bool(elm_transit_paused_get(self.obj))

    property progress_value:
        """Get the time progression of the animation (a double value between
        0.0 and 1.0).

        The value returned is a fraction (current time / total time). It
        represents the progression position relative to the total.

        :type: float

        """
        def __get__(self):
            return elm_transit_progress_value_get(self.obj)

    def chain_transit_add(self, Transit chain_transit):
        """Makes the chain relationship between two transits.

        This function adds ``chain_transit`` transition to a chain after the
        ``transit``, and will be started as soon as ``transit`` ends.

        .. note:: ``chain_transit`` can not be None. Chain transits could be
            chained to the only one transit.

        :param chain_transit: The chain transit object. This transit will be
            operated after transit is done.

        """
        elm_transit_chain_transit_add(self.obj, chain_transit.obj)

    def chain_transit_del(self, Transit chain_transit):
        """Cut off the chain relationship between two transits.

        This function removes the ``chain_transit`` transition from the
        ``transit``.

        .. note:: ``chain_transit`` can not be None. Chain transits should be
            chained to the ``transit``.

        :param chain_transit: The chain transit object.

        """
        elm_transit_chain_transit_del(self.obj, chain_transit.obj)

    property chain_transits:
        """Get the current chain transit list.

        :type: list

        """
        def __get__(self):
            return eina_list_objects_to_python_list(elm_transit_chain_transits_get(self.obj))

    property smooth:
        """Smooth effect for a transit.

        This sets smoothing for transit map rendering. If the object added in a
        transit is a type that has its own smoothing settings, then both the smooth
        settings for this object and the map must be turned off. By default smooth
        maps are enabled.

        :type: bool

        :see: :py:attr:`efl.evas.Map.smooth`

        .. versionadded:: 1.8

        """
        def __set__(self, bint smooth):
            elm_transit_smooth_set(self.obj, smooth)

        def __get__(self):
            return bool(elm_transit_smooth_get(self.obj))

    def smooth_set(self, bint smooth):
        elm_transit_smooth_set(self.obj, smooth)

    def smooth_get(self):
        return bool(elm_transit_smooth_get(self.obj))

    def effect_resizing_add(self, Evas_Coord from_w, Evas_Coord from_h, Evas_Coord to_w, Evas_Coord to_h):
        """Add the Resizing Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates resizing effect
            context and adds its required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param from_w: Object width size when effect begins.
        :type from_w: Evas_Coord (int)
        :param from_h: Object height size when effect begins.
        :type from_h: Evas_Coord (int)
        :param to_w: Object width size when effect ends.
        :type to_w: Evas_Coord (int)
        :param to_h: Object height size when effect ends.
        :type to_h: Evas_Coord (int)
        :return: Resizing effect context data.
        :rtype: Elm_Transit_Effect

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_resizing_add(self.obj, from_w, from_h, to_w, to_h)

    def effect_translation_add(self, Evas_Coord from_dx, Evas_Coord from_dy, Evas_Coord to_dx, Evas_Coord to_dy):
        """Add the Translation Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates translation effect
            context and adds its required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param from_dx: X Position variation when effect begins.
        :param from_dy: Y Position variation when effect begins.
        :param to_dx: X Position variation when effect ends.
        :param to_dy: Y Position variation when effect ends.
        :return: Translation effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_translation_add(self.obj, from_dx, from_dy, to_dx, to_dy)

    def effect_zoom_add(self, float from_rate, float to_rate):
        """Add the Zoom Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates zoom effect context
            and adds its required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param from_rate: Scale rate when effect begins (1 is current rate).
        :param to_rate: Scale rate when effect ends.
        :return: Zoom effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_zoom_add(self.obj, from_rate, to_rate)

    def effect_flip_add(self, Elm_Transit_Effect_Flip_Axis axis, cw):
        """Add the Flip Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates flip effect context
            and add it's required APIs to elm_transit_effect_add.
        .. note:: This effect is applied to each pair of objects in the order
            they are listed in the transit list of objects. The first object
            in the pair will be the "front" object and the second will be the
            "back" object.

        .. seealso:: :py:func:`effect_add()`

        :param axis: Flipping Axis(X or Y).
        :type axis: :ref:`Flip axis <Elm_Transit_Effect_Flip_Axis>`
        :param cw: Flipping Direction. True is clock-wise.
        :type cw: bool
        :return: Flip effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_flip_add(self.obj, axis, cw)

    def effect_resizable_flip_add(self, Elm_Transit_Effect_Flip_Axis axis, cw):
        """Add the Resizeable Flip Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates resizable flip
            effect context and add it's required APIs to
            elm_transit_effect_add.
        .. note:: This effect is applied to each pair of objects in the order
            they are listed in the transit list of objects. The first object
            in the pair will be the "front" object and the second will be the
            "back" object.

        .. seealso:: :py:func:`effect_add()`

        :param axis: Flipping Axis(X or Y).
        :type axis: :ref:`Flip axis <Elm_Transit_Effect_Flip_Axis>`
        :param cw: Flipping Direction. True is clock-wise.
        :type cw: bool
        :return: Resizeable flip effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_resizable_flip_add(self.obj, axis, cw)

    def effect_wipe_add(self, Elm_Transit_Effect_Wipe_Type wipe_type, Elm_Transit_Effect_Wipe_Dir wipe_dir):
        """Add the Wipe Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates wipe effect context
            and add it's required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param wipe_type: Wipe type. Hide or show.
        :type wipe_type: :ref:`Wipe type <Elm_Transit_Effect_Wipe_Type>`
        :param wipe_dir: Wipe Direction.
        :type wipe_dir: :ref:`Wipe direction <Elm_Transit_Effect_Wipe_Dir>`
        :return: Wipe effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_wipe_add(self.obj, wipe_type, wipe_dir)

    def effect_color_add(self, unsigned int from_r, unsigned int from_g, unsigned int from_b, unsigned int from_a, unsigned int to_r, unsigned int to_g, unsigned int to_b, unsigned int to_a):
        """Add the Color Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates color effect
            context and add it's required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param  from_r:        RGB R when effect begins.
        :param  from_g:        RGB G when effect begins.
        :param  from_b:        RGB B when effect begins.
        :param  from_a:        RGB A when effect begins.
        :param  to_r:          RGB R when effect ends.
        :param  to_g:          RGB G when effect ends.
        :param  to_b:          RGB B when effect ends.
        :param  to_a:          RGB A when effect ends.
        :return:               Color effect context data.
        :rtype: Elm_Transit_Effect

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_color_add(self.obj, from_r, from_g, from_b, from_a, to_r, to_g, to_b, to_a)

    def effect_fade_add(self):
        """Add the Fade Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates fade effect context
            and add it's required APIs to elm_transit_effect_add.
        .. note:: This effect is applied to each pair of objects in the order
            they are listed in the transit list of objects. The first object
            in the pair will be the "before" object and the second will be
            the "after" object.

        .. seealso:: :py:func:`effect_add()`

        :return: Fade effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            color information about the objects, and if the window was not
            created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_fade_add(self.obj)

    def effect_blend_add(self):
        """Add the Blend Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates blend effect
            context and add it's required APIs to elm_transit_effect_add.
        .. note:: This effect is applied to each pair of objects in the order
            they are listed in the transit list of objects. The first object
            in the pair will be the "before" object and the second will be
            the "after" object.

        .. seealso:: :py:func:`effect_add()`

        :return: Blend effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            color information about the objects, and if the window was not
            created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_blend_add(self.obj)

    def effect_rotation_add(self, float from_degree, float to_degree):
        """Add the Rotation Effect to Elm_Transit.

        .. note:: This API is one of the facades. It creates rotation effect
            context and add it's required APIs to elm_transit_effect_add.

        .. seealso:: :py:func:`effect_add()`

        :param from_degree: Degree when effect begins.
        :type from_degree: float
        :param to_degree: Degree when effect is ends.
        :type to_degree: float
        :return: Rotation effect context data.
        :rtype: Elm_Transit_Effect

        .. warning:: It is highly recommended just create a transit with this
            effect when the window that the objects of the transit belongs
            has already been created. This is because this effect needs the
            geometry information about the objects, and if the window was
            not created yet, it can get a wrong information.

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_rotation_add(self.obj, from_degree, to_degree)

    def effect_image_animation_add(self, images):
        """Add the ImageAnimation Effect to Elm_Transit.

        Example::

            t = Transit()
            images = []
            images.append("%s/images/icon_11.png" % PACKAGE_DATA_DIR)
            images.append("%s/images/logo_small.png" % PACKAGE_DATA_DIR)
            t.effect_image_animation_add(images)

        .. note:: This API is one of the facades. It creates image animation
            effect context and add it's required APIs to
            elm_transit_effect_add. The ``images`` parameter is a list images
            paths. This list and its contents will be deleted at the end of
            the effect by elm_transit_effect_image_animation_context_free()
            function.

        .. seealso:: :py:func:`effect_add()`

        :param images: A list of images file paths. This list and its
            contents will be deleted at the end of the effect by
            elm_transit_effect_image_animation_context_free() function.
        :type images: list
        :return: Image Animation effect context data.
        :rtype: Elm_Transit_Effect

        """
        #TODO: can the return value Elm_Transit_Effect be used somehow?
        elm_transit_effect_image_animation_add(self.obj, python_list_strings_to_eina_list(images))
