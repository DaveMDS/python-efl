.. currentmodule:: efl.elementary

Gesture Layer
#############

.. image:: /images/gesturelayer-preview.png


Widget description
==================

Use the GestureLayer to detect gestures. The advantage is that you don't
have to implement gesture detection, just set callbacks for gesture states.

In order to use Gesture Layer you start with instantiating this class
with a parent object parameter. Next 'activate' gesture layer with a
:py:meth:`~GestureLayer.attach` call. Usually with same object as target (2nd
parameter).

Now you need to tell gesture layer what gestures you follow. This is done with
:py:meth:`~GestureLayer.cb_set` call. By setting the callback you actually
saying to gesture layer: I would like to know when the gesture
:ref:`Elm_Gesture_Type` switches to state :ref:`Elm_Gesture_State`.

Next, you need to implement the actual action that follows the input in
your callback.

Note that if you like to stop being reported about a gesture, just set
all callbacks referring this gesture to None. (again with
:py:meth:`~GestureLayer.cb_set`)

The information reported by gesture layer to your callback is depending
on :ref:`Elm_Gesture_Type`:

- :class:`GestureTapsInfo` is the info reported for tap gestures:

    - :attr:`ELM_GESTURE_N_TAPS`
    - :attr:`ELM_GESTURE_N_LONG_TAPS`
    - :attr:`ELM_GESTURE_N_DOUBLE_TAPS`
    - :attr:`ELM_GESTURE_N_TRIPLE_TAPS`

- :class:`GestureMomentumInfo` is info reported for momentum gestures:

    - :attr:`ELM_GESTURE_MOMENTUM`

- :class:`GestureLineInfo` is the info reported for line gestures
  (this also contains :class:`GestureMomentumInfo` internal structure):

    - :attr:`ELM_GESTURE_N_LINES`
    - :attr:`ELM_GESTURE_N_FLICKS`

Note that we consider a flick as a line-gesture that should be completed
in flick-time-limit as defined in
:py:class:`~efl.elementary.configuration.Configuration`.

:class:`GestureZoomInfo` is the info reported for :attr:`ELM_GESTURE_ZOOM`
gesture.

:class:`GestureRotateInfo` is the info reported for
:attr:`ELM_GESTURE_ROTATE` gesture.

Gesture Layer Tweaks:

Note that line, flick, gestures can start without the need to remove
fingers from surface. When user fingers rests on same-spot gesture is
ended and starts again when fingers moved.

Setting glayer_continues_enable to false in
:py:class:`~efl.elementary.configuration.Configuration` will change this
behavior so gesture starts when user touches (a *DOWN* event)
touch-surface and ends when no fingers touches surface (a *UP* event).


Enumerations
============

.. _Elm_Gesture_State:

Gesture states
--------------

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
-------------

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


Inheritance diagram
===================

.. inheritance-diagram:: GestureLayer
    :parts: 2


.. autoclass:: GestureLayer
