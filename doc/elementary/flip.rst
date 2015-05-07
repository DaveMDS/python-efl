.. currentmodule:: efl.elementary

Flip
####

.. image:: /images/flip-preview.png


Widget description
==================

This widget holds two content :py:class:`efl.evas.Object`: one on
the front and one on the back. It allows you to flip from front to back
and vice-versa using various animations.

If either the front or back contents are not set the flip will treat that
as transparent. So if you were to set the front content but not the back,
and then call :py:meth:`Flip.go` you would see whatever is below the flip.

For a list of supported animations see :py:meth:`Flip.go`.


Emitted signals
===============

- ``animate,begin`` - when a flip animation was started
- ``animate,done`` - when a flip animation is finished


Layout content parts
====================

- ``front`` - A front content of the flip
- ``back`` - A back content of the flip


Enumerations
============

.. _Elm_Flip_Direction:

Flip directions
---------------

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


.. _Elm_Flip_Interaction:

Flip interaction modes
----------------------

.. data:: ELM_FLIP_INTERACTION_NONE

    No interaction is allowed

.. data:: ELM_FLIP_INTERACTION_ROTATE

    Interaction will cause rotate animation

.. data:: ELM_FLIP_INTERACTION_CUBE

    Interaction will cause cube animation

.. data:: ELM_FLIP_INTERACTION_PAGE

    Interaction will cause page animation


.. _Elm_Flip_Mode:

Flip types
----------

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


Inheritance diagram
===================

.. inheritance-diagram:: Flip
    :parts: 2


.. autoclass:: Flip
