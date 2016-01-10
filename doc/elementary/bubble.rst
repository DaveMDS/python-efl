.. currentmodule:: efl.elementary

Bubble
######

.. image:: /images/bubble-preview.png


Widget description
==================

The Bubble is a widget to show text similar to how speech is
represented in comics.

The bubble widget contains 5 important visual elements:

- The frame is a rectangle with rounded edjes and an "arrow".
- The ``icon`` is an image to which the frame's arrow points to.
- The ``label`` is a text which appears to the right of the icon if the
    corner is **top_left** or **bottom_left** and is right aligned to
    the frame otherwise.
- The ``info`` is a text which appears to the right of the label. Info's
    font is of a lighter color than label.
- The ``content`` is an evas object that is shown inside the frame.

The position of the arrow, icon, label and info depends on which corner is
selected. The four available corners are:

- ``top_left`` - Default
- ``top_right``
- ``bottom_left``
- ``bottom_right``


Layout content parts
====================

- ``default`` - A content of the bubble
- ``icon`` - An icon of the bubble


Layout text parts
=================

- ``default`` - Label of the bubble
- ``info`` - info of the bubble


Emitted signals
===============

- ``clicked`` - This is called when a user has clicked the bubble.


Enumerations
============

.. _Elm_Bubble_Pos:

Bubble arrow positions
----------------------

.. data:: ELM_BUBBLE_POS_TOP_LEFT

    Top left position

.. data:: ELM_BUBBLE_POS_TOP_RIGHT

    Top right position

.. data:: ELM_BUBBLE_POS_BOTTOM_LEFT

    Bottom left position

.. data:: ELM_BUBBLE_POS_BOTTOM_RIGHT

    Bottom right position


Inheritance diagram
===================

.. inheritance-diagram:: Bubble
    :parts: 2

.. autoclass:: Bubble
