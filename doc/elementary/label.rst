.. currentmodule:: efl.elementary

Label
#####

.. image:: /images/label-preview.png


Widget description
==================

Widget to display text, with simple html-like markup.

The Label widget **doesn't** allow text to overflow its boundaries, if the
text doesn't fit the geometry of the label it will be ellipsized or be
cut.


Available styles
================

``default``
    No animation
``marker``
    Centers the text in the label and makes it bold by default
``slide_long``
    The entire text appears from the right of the screen and
    slides until it disappears in the left of the screen(reappearing on
    the right again).
``slide_short``
    The text appears in the left of the label and slides to
    the right to show the overflow. When all of the text has been shown
    the position is reset.
``slide_bounce``
    The text appears in the left of the label and slides to
    the right to show the overflow. When all of the text has been shown
    the animation reverses, moving the text to the left.

Custom themes can of course invent new markup tags and style them any way
they like.


Emitted signals
===============

- ``language,changed`` - The program's language changed.
- ``slide,end`` - The slide is end.


Enumerations
============

.. _Elm_Label_Slide_Mode:

Slide modes
-----------

.. data:: ELM_LABEL_SLIDE_MODE_NONE

    The label will never slide.

.. data:: ELM_LABEL_SLIDE_MODE_AUTO

    The label slide if the content is bigger than it's container.

.. data:: ELM_LABEL_SLIDE_MODE_ALWAYS

    The label will always slide.


Inheritance diagram
===================

.. inheritance-diagram:: Label
    :parts: 2


.. autoclass:: Label
