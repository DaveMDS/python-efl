.. currentmodule:: efl.elementary

Transit
#######


Widget description
==================

Transit is designed to apply various animated transition effects to
``Evas_Object``, such like translation, rotation, etc. For using these
effects, create a :py:class:`Transit` and add the desired transition effects.

Once the effects are added into transit, they will be automatically managed
(their callback will be called for the set duration and they will be deleted
upon completion).

Example::

    from efl.elementary.transit import Transit, ELM_TRANSIT_TWEEN_MODE_DECELERATE

    t = Transit()
    t.object_add(obj)
    t.effect_translation_add(0, 0, 280, 280)
    t.duration = 1
    t.auto_reverse = True
    t.tween_mode = ELM_TRANSIT_TWEEN_MODE_DECELERATE
    t.repeat_times = 3

Some transition effects are used to change the properties of objects. They
are:

- :py:func:`~Transit.effect_translation_add`
- :py:func:`~Transit.effect_color_add`
- :py:func:`~Transit.effect_rotation_add`
- :py:func:`~Transit.effect_wipe_add`
- :py:func:`~Transit.effect_zoom_add`
- :py:func:`~Transit.effect_resizing_add`

Other transition effects are used to make one object disappear and another
object appear on its place. These effects are:

- :py:func:`~Transit.effect_flip_add`
- :py:func:`~Transit.effect_resizable_flip_add`
- :py:func:`~Transit.effect_fade_add`
- :py:func:`~Transit.effect_blend_add`

It's also possible to make a transition chain with
:py:func:`~Transit.chain_transit_add`.

.. warning:: We strongly recommend to use elm_transit just when edje can
    not do the trick. Edje is better at handling transitions than
    Elm_Transit. Edje has more flexibility and animations can be
    manipulated inside the theme.


Enumerations
============

.. _Elm_Transit_Effect_Flip_Axis:

Flip effects
------------

.. data:: ELM_TRANSIT_EFFECT_FLIP_AXIS_X

    Flip on X axis

.. data:: ELM_TRANSIT_EFFECT_FLIP_AXIS_Y

    Flip on Y axis


.. _Elm_Transit_Effect_Wipe_Dir:

Wipe effects
------------

.. data:: ELM_TRANSIT_EFFECT_WIPE_DIR_LEFT

    Wipe to the left

.. data:: ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT

    Wipe to the right

.. data:: ELM_TRANSIT_EFFECT_WIPE_DIR_UP

    Wipe up

.. data:: ELM_TRANSIT_EFFECT_WIPE_DIR_DOWN

    Wipe down


.. _Elm_Transit_Effect_Wipe_Type:

Wipe types
----------

.. data:: ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE

    Hide the object during the animation.

.. data:: ELM_TRANSIT_EFFECT_WIPE_TYPE_SHOW

    Show the object during the animation.


.. _Elm_Transit_Tween_Mode:

Tween modes
-----------

.. data:: ELM_TRANSIT_TWEEN_MODE_LINEAR

    Constant speed

.. data:: ELM_TRANSIT_TWEEN_MODE_SINUSOIDAL

    Starts slow, increase speed over time, then decrease again and stop slowly

.. data:: ELM_TRANSIT_TWEEN_MODE_DECELERATE

    Starts fast and decrease speed over time

.. data:: ELM_TRANSIT_TWEEN_MODE_ACCELERATE

    Starts slow and increase speed over time

.. data:: ELM_TRANSIT_TWEEN_MODE_DIVISOR_INTERP

    Start at gradient v1, interpolated via power of v2 curve

    .. versionadded:: 1.13

.. data:: ELM_TRANSIT_TWEEN_MODE_BOUNCE

    Start at 0.0 then "drop" like a ball bouncing to the ground at 1.0, and
    bounce v2 times, with decay factor of v1

    .. versionadded:: 1.13

.. data:: ELM_TRANSIT_TWEEN_MODE_SPRING

    Start at 0.0 then "wobble" like a spring rest position 1.0, and wobble
    v2 times, with decay factor of v1

    .. versionadded:: 1.13

.. data:: ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE

    Follow the cubic-bezier curve calculated with the control points (x1,
    y1), (x2, y2)

    .. versionadded:: 1.13


Inheritance diagram
===================

.. inheritance-diagram:: Transit
    :parts: 2


.. autoclass:: Transit
