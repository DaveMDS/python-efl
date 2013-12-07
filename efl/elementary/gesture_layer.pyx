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

.. image:: /images/gesturelayer-preview.png

Widget description
------------------

Use the GestureLayer to detect gestures. The advantage is that you don't
have to implement gesture detection, just set callbacks for gesture states.

In order to use Gesture Layer you start with instantiating this class
with a parent object parameter. Next 'activate' gesture layer with a
:py:meth:`GestureLayer.attach` call. Usually with same object as target (2nd
parameter).

Now you need to tell gesture layer what gestures you follow. This is done with
:py:meth:`GestureLayer.cb_set` call. By setting the callback you actually saying
to gesture layer: I would like to know when the gesture ``Elm_Gesture_Type``
switches to state ``Elm_Gesture_State``.

Next, you need to implement the actual action that follows the input in
your callback.

Note that if you like to stop being reported about a gesture, just set
all callbacks referring this gesture to None. (again with
:py:meth:`GestureLayer.cb_set`)

The information reported by gesture layer to your callback is depending
on ``Elm_Gesture_Type``:

- ``Elm_Gesture_Taps_Info`` is the info reported for tap gestures:

    - ``ELM_GESTURE_N_TAPS``
    - ``ELM_GESTURE_N_LONG_TAPS``
    - ``ELM_GESTURE_N_DOUBLE_TAPS``
    - ``ELM_GESTURE_N_TRIPLE_TAPS``

- ``Elm_Gesture_Momentum_Info`` is info reported for momentum gestures:

    - ``ELM_GESTURE_MOMENTUM``

- ``Elm_Gesture_Line_Info`` is the info reported for line gestures
  (this also contains ``Elm_Gesture_Momentum_Info`` internal structure):

    - ``ELM_GESTURE_N_LINES``
    - ``ELM_GESTURE_N_FLICKS``

Note that we consider a flick as a line-gesture that should be completed
in flick-time-limit as defined in
:py:class:`~efl.elementary.configuration.Configuration`.

``Elm_Gesture_Zoom_Info`` is the info reported for ``ELM_GESTURE_ZOOM``
gesture.

``Elm_Gesture_Rotate_Info`` is the info reported for
``ELM_GESTURE_ROTATE`` gesture.

Gesture Layer Tweaks:

Note that line, flick, gestures can start without the need to remove
fingers from surface. When user fingers rests on same-spot gesture is
ended and starts again when fingers moved.

Setting glayer_continues_enable to false in
:py:class:`~efl.elementary.configuration.Configuration` will change this
behavior so gesture starts when user touches (a *DOWN* event)
touch-surface and ends when no fingers touches surface (a *UP* event).


Enumerations
------------

.. _Elm_Gesture_State:

Gesture states
==============

.. data:: ELM_GESTURE_STATE_UNDEFINED

    Gesture not started

.. data:: ELM_GESTURE_STATE_START

    Gesture started

.. data:: ELM_GESTURE_STATE_MOVE

    Gesture is ongoing

.. data:: ELM_GESTURE_STATE_END

    Gesture completed

.. data:: ELM_GESTURE_STATE_ABORT

    Ongoing gesture was aborted


.. _Elm_Gesture_Type:

Gesture types
=============

.. data:: ELM_GESTURE_N_TAPS

    N fingers single taps

.. data:: ELM_GESTURE_N_LONG_TAPS

    N fingers single long-taps

.. data:: ELM_GESTURE_N_DOUBLE_TAPS

    N fingers double-single taps

.. data:: ELM_GESTURE_N_TRIPLE_TAPS

    N fingers triple-single taps

.. data:: ELM_GESTURE_MOMENTUM

    Reports momentum in the direction of move

.. data:: ELM_GESTURE_N_LINES

    N fingers line gesture

.. data:: ELM_GESTURE_N_FLICKS

    N fingers flick gesture

.. data:: ELM_GESTURE_ZOOM

    Zoom

.. data:: ELM_GESTURE_ROTATE

    Rotate

"""

from cpython cimport PyUnicode_AsUTF8String, Py_INCREF

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object

import traceback

from efl.evas import EVAS_EVENT_FLAG_NONE

cimport enums

ELM_GESTURE_STATE_UNDEFINED = enums.ELM_GESTURE_STATE_UNDEFINED
ELM_GESTURE_STATE_START = enums.ELM_GESTURE_STATE_START
ELM_GESTURE_STATE_MOVE = enums.ELM_GESTURE_STATE_MOVE
ELM_GESTURE_STATE_END = enums.ELM_GESTURE_STATE_END
ELM_GESTURE_STATE_ABORT = enums.ELM_GESTURE_STATE_ABORT

ELM_GESTURE_FIRST = enums.ELM_GESTURE_FIRST
ELM_GESTURE_N_TAPS = enums.ELM_GESTURE_N_TAPS
ELM_GESTURE_N_LONG_TAPS = enums.ELM_GESTURE_N_LONG_TAPS
ELM_GESTURE_N_DOUBLE_TAPS = enums.ELM_GESTURE_N_DOUBLE_TAPS
ELM_GESTURE_N_TRIPLE_TAPS = enums.ELM_GESTURE_N_TRIPLE_TAPS
ELM_GESTURE_MOMENTUM = enums.ELM_GESTURE_MOMENTUM
ELM_GESTURE_N_LINES = enums.ELM_GESTURE_N_LINES
ELM_GESTURE_N_FLICKS = enums.ELM_GESTURE_N_FLICKS
ELM_GESTURE_ZOOM = enums.ELM_GESTURE_ZOOM
ELM_GESTURE_ROTATE = enums.ELM_GESTURE_ROTATE
ELM_GESTURE_LAST = enums.ELM_GESTURE_LAST


cdef class GestureTapsInfo(object):

    """Holds taps info for user"""

    cdef Elm_Gesture_Taps_Info *info

    property x:
        """Holds center point between fingers

        :type: int

        """
        def __get__(self):
            return self.info.x

    property y:
        """Holds center point between fingers

        :type: int

        """
        def __get__(self):
            return self.info.y

    property n:
        """Number of fingers tapped

        :type: int

        """
        def __get__(self):
            return self.info.n

    property timestamp:
        """Event timestamp

        :type: int

        """
        def __get__(self):
            return self.info.timestamp

cdef class GestureMomentumInfo(object):

    """

    Holds momentum info for user
    x1 and y1 are not necessarily in sync
    x1 holds x value of x direction starting point
    and same holds for y1.
    This is noticeable when doing V-shape movement

    """

    cdef Elm_Gesture_Momentum_Info *info

    property x1:
        """Final-swipe direction starting point on X

        :type: int

        """
        def __get__(self):
            return self.info.x1

    property y1:
        """Final-swipe direction starting point on Y

        :type: int

        """
        def __get__(self):
            return self.info.y1

    property x2:
        """Final-swipe direction ending point on X

        :type: int

        """
        def __get__(self):
            return self.info.x2

    property y2:
        """Final-swipe direction ending point on Y

        :type: int

        """
        def __get__(self):
            return self.info.y2

    property tx:
        """Timestamp of start of final x-swipe

        :type: int

        """
        def __get__(self):
            return self.info.tx

    property ty:
        """Timestamp of start of final y-swipe

        :type: int

        """
        def __get__(self):
            return self.info.ty

    property mx:
        """Momentum on X

        :type: int

        """
        def __get__(self):
            return self.info.mx

    property my:
        """Momentum on Y

        :type: int

        """
        def __get__(self):
            return self.info.my

    property n:
        """Number of fingers

        :type: int

        """
        def __get__(self):
            return self.info.n

cdef class GestureLineInfo(object):

    """Holds line info for user"""

    cdef Elm_Gesture_Line_Info *info

    property momentum:
        """Line momentum info

        :type: GestureMomentumInfo

        """
        def __get__(self):
            cdef GestureMomentumInfo ret = GestureMomentumInfo.__new__(GestureMomentumInfo)
            ret.info = &self.info.momentum
            return ret

    property angle:
        """Angle (direction) of lines

        :type: double

        """
        def __get__(self):
            return self.info.angle

cdef class GestureZoomInfo(object):

    """Holds zoom info for user"""

    cdef Elm_Gesture_Zoom_Info *info

    property x:
        """Holds zoom center point reported to user

        :type: int

        """
        def __get__(self):
            return self.info.x

    property y:
        """Holds zoom center point reported to user

        :type: int

        """
        def __get__(self):
            return self.info.y

    property radius:
        """Holds radius between fingers reported to user

        :type: int

        """
        def __get__(self):
            return self.info.radius

    property zoom:
        """Zoom value: 1.0 means no zoom

        :type: double

        """
        def __get__(self):
            return self.info.zoom

    property momentum:
        """Zoom momentum: zoom growth per second (NOT YET SUPPORTED)

        :type: double

        """
        def __get__(self):
            return self.info.momentum

cdef class GestureRotateInfo(object):

    """Holds rotation info for user"""

    cdef Elm_Gesture_Rotate_Info *info

    property x:
        """Holds zoom center point reported to user

        :type: int

        """
        def __get__(self):
            return self.info.x

    property y:
        """Holds zoom center point reported to user

        :type: int

        """
        def __get__(self):
            return self.info.y

    property radius:
        """Holds radius between fingers reported to user

        :type: int

        """
        def __get__(self):
            return self.info.radius

    property base_angle:
        """Holds start-angle

        :type: double

        """
        def __get__(self):
            return self.info.base_angle

    property angle:
        """Rotation value: 0.0 means no rotation

        :type: double

        """
        def __get__(self):
            return self.info.angle

    property momentum:
        """Rotation momentum: rotation done per second (NOT YET SUPPORTED)

        :type: double

        """
        def __get__(self):
            return self.info.momentum

cdef Evas_Event_Flags _gesture_layer_taps_event_cb(void *data, void *event_info) with gil:
    callback, args, kwargs = <object>data
    cdef GestureTapsInfo ei = GestureTapsInfo.__new__(GestureTapsInfo)
    ei.info = <Elm_Gesture_Taps_Info *>event_info
    try:
        ret = callback(ei, *args, **kwargs)
        return <Evas_Event_Flags>ret if ret is not None else EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()

cdef Evas_Event_Flags _gesture_layer_momentum_event_cb(void *data, void *event_info) with gil:
    callback, args, kwargs = <object>data
    cdef GestureMomentumInfo ei = GestureMomentumInfo.__new__(GestureMomentumInfo)
    ei.info = <Elm_Gesture_Momentum_Info *>event_info
    try:
        ret = callback(ei, *args, **kwargs)
        return <Evas_Event_Flags>ret if ret is not None else EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()

cdef Evas_Event_Flags _gesture_layer_line_event_cb(void *data, void *event_info) with gil:
    callback, args, kwargs = <object>data
    cdef GestureLineInfo ei = GestureLineInfo.__new__(GestureLineInfo)
    ei.info = <Elm_Gesture_Line_Info *>event_info
    try:
        ret = callback(ei, *args, **kwargs)
        return <Evas_Event_Flags>ret if ret is not None else EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()

cdef Evas_Event_Flags _gesture_layer_zoom_event_cb(void *data, void *event_info) with gil:
    callback, args, kwargs = <object>data
    cdef GestureZoomInfo ei = GestureZoomInfo.__new__(GestureZoomInfo)
    ei.info = <Elm_Gesture_Zoom_Info *>event_info
    try:
        ret = callback(ei, *args, **kwargs)
        return <Evas_Event_Flags>ret if ret is not None else EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()

cdef Evas_Event_Flags _gesture_layer_rotate_event_cb(void *data, void *event_info) with gil:
    callback, args, kwargs = <object>data
    cdef GestureRotateInfo ei = GestureRotateInfo.__new__(GestureRotateInfo)
    ei.info = <Elm_Gesture_Rotate_Info *>event_info
    try:
        ret = callback(ei, *args, **kwargs)
        return <Evas_Event_Flags>ret if ret is not None else EVAS_EVENT_FLAG_NONE
    except Exception as e:
        traceback.print_exc()

cdef class GestureLayer(Object):

    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Call this function to construct a new gesture-layer object.

        This does not activate the gesture layer. You have to call
        :py:func:`attach()` in order to 'activate' gesture-layer.

        :param parent: The gesture layer's parent widget.
        :type parent: :py:class:`~efl.evas.Object`

        :return: A new gesture layer object.
        :rtype: :py:class:`GestureLayer`

        """
        self._set_obj(elm_gesture_layer_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def cb_set(self, Elm_Gesture_Type idx, Elm_Gesture_State cb_type, callback, *args, **kwargs):
        """cb_set(Elm_Gesture_Type idx, Elm_Gesture_State cb_type, callback, *args, **kwargs)

        Use this function to set callbacks to be notified about change of
        state of gesture. When a user registers a callback with this function
        this means this gesture has to be tested.

        When ALL callbacks for a gesture are set to None it means user isn't
        interested in gesture-state and it will not be tested.

        The signature for the callbacks is::

            func(event_info, *args, **kwargs)

        .. note:: You should return either EVAS_EVENT_FLAG_NONE or
            EVAS_EVENT_FLAG_ON_HOLD from this callback.

        :param idx: The gesture you would like to track its state.
        :type idx: :ref:`Elm_Gesture_Type`
        :param cb_type: what event this callback tracks: START, MOVE, END, ABORT.
        :type cb_type: :ref:`Elm_Gesture_State`
        :param callback: Callback function.
        :type callback: function

        """
        cdef Elm_Gesture_Event_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if  idx == enums.ELM_GESTURE_N_TAPS or \
            idx == enums.ELM_GESTURE_N_LONG_TAPS or \
            idx == enums.ELM_GESTURE_N_DOUBLE_TAPS or \
            idx == enums.ELM_GESTURE_N_TRIPLE_TAPS:
            cb = _gesture_layer_taps_event_cb
        elif idx == enums.ELM_GESTURE_MOMENTUM:
            cb = _gesture_layer_momentum_event_cb
        elif idx == enums.ELM_GESTURE_N_LINES or \
            idx == enums.ELM_GESTURE_N_FLICKS:
            cb = _gesture_layer_line_event_cb
        elif idx == enums.ELM_GESTURE_ZOOM:
            cb = _gesture_layer_zoom_event_cb
        elif idx == enums.ELM_GESTURE_ROTATE:
            cb = _gesture_layer_rotate_event_cb
        else:
            raise TypeError("Unknown gesture type")

        data = (callback, args, kwargs)
        Py_INCREF(data)

        elm_gesture_layer_cb_set(   self.obj,
                                    idx,
                                    cb_type,
                                    cb,
                                    <void *>data)

    property hold_events:
        """Gesture-layer repeat events. Set to True if you like to get the
        raw events only if gestures were not detected. Set to false if you
        like gesture layer to forward events as testing gestures.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gesture_layer_hold_events_get(self.obj))

        def __set__(self, hold_events):
            elm_gesture_layer_hold_events_set(self.obj, hold_events)

    property zoom_step:
        """Step-value for zoom action. Set step to any positive value.
        Cancel step setting by setting to 0.0

        :type: float

        """
        def __set__(self, step):
            elm_gesture_layer_zoom_step_set(self.obj, step)

        def __get__(self):
            return elm_gesture_layer_zoom_step_get(self.obj)

    property rotate_step:
        """This function sets step-value for rotate action. Set step to any
        positive value. Cancel step setting by setting to 0

        :type: float

        """
        def __set__(self, step):
            elm_gesture_layer_rotate_step_set(self.obj, step)

        def __get__(self):
            return elm_gesture_layer_rotate_step_get(self.obj)

    def attach(self, evasObject target):
        """attach(evas.Object target)

        Attach a given gesture layer widget to an Evas object, thus setting
        the widget's **target**.

        A gesture layer target may be whichever Evas object one chooses.
        This will be object ``obj`` will listen all mouse and key events
        from, to report the gestures made upon it back.

        :param target: The target object to attach to this object.
        :type target: :py:class:`~efl.evas.Object`

        .. versionchanged:: 1.8
            Raise RuntimeError on failure, instead of returning a bool

        """
        if not elm_gesture_layer_attach(self.obj, target.obj):
            raise RuntimeError

    property line_min_length:
        """Gesture layer line min length of an object

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int line_min_length):
            elm_gesture_layer_line_min_length_set(self.obj, line_min_length)

        def __get__(self):
            return elm_gesture_layer_line_min_length_get(self.obj)

    property zoom_distance_tolerance:
        """Gesture layer zoom distance tolerance of an object

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int zoom_distance_tolerance):
            elm_gesture_layer_zoom_distance_tolerance_set(self.obj, zoom_distance_tolerance)

        def __get__(self):
            return elm_gesture_layer_zoom_distance_tolerance_get(self.obj)

    property line_distance_tolerance:
        """Gesture layer line distance tolerance of an object

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int line_distance_tolerance):
            elm_gesture_layer_line_distance_tolerance_set(self.obj, line_distance_tolerance)

        def __get__(self):
            return elm_gesture_layer_line_distance_tolerance_get(self.obj)

    property line_angular_tolerance:
        """Gesture layer line angular tolerance of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double line_angular_tolerance):
            elm_gesture_layer_line_angular_tolerance_set(self.obj, line_angular_tolerance)

        def __get__(self):
            return elm_gesture_layer_line_angular_tolerance_get(self.obj)

    property zoom_wheel_factor:
        """Gesture layer zoom wheel factor of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double zoom_wheel_factor):
            elm_gesture_layer_zoom_wheel_factor_set(self.obj, zoom_wheel_factor)

        def __get__(self):
            return elm_gesture_layer_zoom_wheel_factor_get(self.obj)

    property zoom_finger_factor:
        """Gesture layer zoom finger factor of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double zoom_finger_factor):
            elm_gesture_layer_zoom_finger_factor_set(self.obj, zoom_finger_factor)

        def __get__(self):
            return elm_gesture_layer_zoom_finger_factor_get(self.obj)

    property rotate_angular_tolerance:
        """Gesture layer rotate angular tolerance of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double rotate_angular_tolerance):
            elm_gesture_layer_rotate_angular_tolerance_set(self.obj, rotate_angular_tolerance)

        def __get__(self):
            return elm_gesture_layer_rotate_angular_tolerance_get(self.obj)

    property flick_time_limit_ms:
        """Gesture layer flick time limit (in ms) of an object

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, unsigned int flick_time_limit_ms):
            elm_gesture_layer_flick_time_limit_ms_set(self.obj, flick_time_limit_ms)

        def __get__(self):
            return elm_gesture_layer_flick_time_limit_ms_get(self.obj)

    property long_tap_start_timeout:
        """Gesture layer long tap start timeout of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double long_tap_start_timeout):
            elm_gesture_layer_long_tap_start_timeout_set(self.obj, long_tap_start_timeout)

        def __get__(self):
            return elm_gesture_layer_long_tap_start_timeout_get(self.obj)

    property continues_enable:
        """Gesture layer continues enable of an object

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, continues_enable):
            elm_gesture_layer_continues_enable_set(self.obj, continues_enable)

        def __get__(self):
            return bool(elm_gesture_layer_continues_enable_get(self.obj))

    property double_tap_timeout:
        """Gesture layer double tap timeout of an object

        :type: double

        .. versionadded:: 1.8

        """
        def __set__(self, double double_tap_timeout):
            elm_gesture_layer_double_tap_timeout_set(self.obj, double_tap_timeout)

        def __get__(self):
            return elm_gesture_layer_double_tap_timeout_get(self.obj)

    property tap_finger_size:
        """

        The gesture layer finger-size for taps.
        If not set, this size taken from elm_config.
        Set to ZERO if you want GLayer to use system finger size value (default)

        :type: int

        .. versionadded:: 1.8


        """
        def __set__(self, int sz):
            elm_gesture_layer_tap_finger_size_set(self.obj, sz)

        def __get__(self):
            return elm_gesture_layer_tap_finger_size_get(self.obj)

    # TODO:
    # def tap_longpress_cb_add(self, state, cb, *args, **kwargs):
    #     """tap_longpress_cb_add(state, cb, cb_data)

    #     This function adds a callback called during Tap + Long Tap sequence.

    #     :param state: state for the callback to add.
    #     :param cb: callback pointer
    #     :param data: user data for the callback.

    #     The callbacks will be called as followed:
    #     - start cbs on single tap start
    #     - move cbs on long press move
    #     - end cbs on long press end
    #     - abort cbs whenever in the sequence. The event info will be NULL, because it
    #       can be triggered from multiple events (timer expired, abort single/long taps).

    #     You can remove the callbacks by using elm_gesture_layer_tap_longpress_cb_del.

    #     :since: 1.8

    #     """
    #     if not callable(cb):
    #         raise TypeError("cb is not callable.")

    #     cb_data = (cb, args, kwargs)
    #     elm_gesture_layer_tap_longpress_cb_add(self.obj, Elm_Gesture_State state, Elm_Gesture_Event_Cb cb, void *data)

    # def tap_longpress_cb_del(self, state, cb, *args, **kwargs):
    #     """tap_longpress_cb_del(state, cb, cb_data)

    #     This function removes a callback called during Tap + Long Tap sequence.

    #     :param state: state for the callback to add.
    #     :param cb: callback pointer
    #     :param data: user data for the callback.

    #     The internal data used for the sequence will be freed ONLY when all the
    #     callbacks added via elm_gesture_layer_tap_longpress_cb_add are removed by
    #     this function.

    #     :since: 1.8

    #     """
    #     elm_gesture_layer_tap_longpress_cb_del(self.obj, Elm_Gesture_State state, Elm_Gesture_Event_Cb cb, void *data)

_object_mapping_register("Elm_Gesture_Layer", GestureLayer)
