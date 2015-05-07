.. currentmodule:: efl.elementary

Thumb
#####

.. image:: /images/thumb-preview.png


Widget description
==================

A thumbnail object is used for displaying the thumbnail of an image
or video. You must have compiled Elementary with ``Ethumb_Client``
support. Also, Ethumb's DBus service must be present and
auto-activated in order to have thumbnails generated. You must also
have a **session** bus, not a **system** one.

Once the thumbnail object becomes visible, it will check if there
is a previously generated thumbnail image for the file set on
it. If not, it will start generating this thumbnail.

Different configuration settings will cause different thumbnails to
be generated even on the same file.

Generated thumbnails are stored under ``$HOME/.thumbnails/``. Check
Ethumb's documentation to change this path, and to see other
configuration options.


Emitted signals
===============

- ``clicked`` - This is called when a user has clicked the
  thumbnail object without dragging it around.
- ``clicked,double`` - This is called when a user has double-clicked
  the thumbnail object.
- ``press`` - This is called when a user has pressed down over the
  thumbnail object.
- ``generate,start`` - The thumbnail generation has started.
- ``generate,stop`` - The generation process has stopped.
- ``generate,error`` - The thumbnail generation failed.
- ``load,error`` - The thumbnail image loading failed.


Available styles
================

- ``default``
- ``noframe``


Enumerations
============

.. _Elm_Thumb_Animation_Setting:

Thumb animation mode
--------------------

.. data:: ELM_THUMB_ANIMATION_START

    Play animation once

.. data:: ELM_THUMB_ANIMATION_LOOP

    Keep playing animation until stop is requested

.. data:: ELM_THUMB_ANIMATION_STOP

    Stop playing the animation


.. _Ethumb_Thumb_FDO_Size:

Thumb FDO size
--------------

.. data:: ETHUMB_THUMB_NORMAL

    128x128 as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_LARGE

    256x256 as defined by FreeDesktop.Org standard


.. _Ethumb_Thumb_Format:

Thumb format
------------

.. data:: ETHUMB_THUMB_FDO

    PNG as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_JPEG

    JPEGs are often smaller and faster to read/write

.. data:: ETHUMB_THUMB_EET

    EFL's own storage system, supports key parameter


.. _Ethumb_Thumb_Aspect:

Thumb aspect
------------

.. data:: ETHUMB_THUMB_KEEP_ASPECT

    keep original proportion between width and height

.. data:: ETHUMB_THUMB_IGNORE_ASPECT

    ignore aspect and foce it to match thumbnail's width and height

.. data:: ETHUMB_THUMB_CROP

    keep aspect but crop (cut) the largest dimension


.. _Ethumb_Thumb_Orientation:

Thumb orientation
-----------------

.. data:: ETHUMB_THUMB_ORIENT_NONE

    keep orientation as pixel data is

.. data:: ETHUMB_THUMB_ROTATE_90_CW

    rotate 90° clockwise

.. data:: ETHUMB_THUMB_ROTATE_180

    rotate 180°

.. data:: ETHUMB_THUMB_ROTATE_90_CCW

    rotate 90° counter-clockwise

.. data:: ETHUMB_THUMB_FLIP_HORIZONTAL

    flip horizontally

.. data:: ETHUMB_THUMB_FLIP_VERTICAL

    flip vertically

.. data:: ETHUMB_THUMB_FLIP_TRANSPOSE

    transpose

.. data:: ETHUMB_THUMB_FLIP_TRANSVERSE

    transverse

.. data:: ETHUMB_THUMB_ORIENT_ORIGINAL

    use orientation from metadata (EXIF-only currently)


Inheritance diagram
===================

.. inheritance-diagram:: Thumb
    :parts: 2


.. autoclass:: Thumb
