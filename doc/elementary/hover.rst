.. currentmodule:: efl.elementary

Hover
#####

.. image:: /images/hover-preview.png


Widget description
==================

A Hover object will hover over its ``parent`` object at the ``target``
location.

Anything in the background will be given a darker coloring to indicate
that the hover object is on top (at the default theme). When the hover
is clicked it is dismissed(hidden), if the contents of the hover are
clicked that **doesn't** cause the hover to be dismissed.

A Hover object has two parents. One parent that owns it during creation
and the other parent being the one over which the hover object spans.


Available styles
================

- default
- popout
- menu
- hoversel_vertical


Emitted signals
===============

- ``clicked`` - the user clicked the empty space in the hover to
  dismiss.
- ``dismissed`` - the user clicked the empty space in the hover to dismiss.
  (since 1.8)
- ``smart,changed`` - a content object placed under the "smart"
  policy was replaced to a new slot direction.


Layout content parts
====================

- ``left``
- ``top-left``
- ``top``
- ``top-right``
- ``right``
- ``bottom-right``
- ``bottom``
- ``bottom-left``
- ``middle``
- ``smart``

All directions may have contents at the same time, except for "smart".
This is a special placement hint and its use case depends of the
calculations coming from :py:meth:`~Hover.best_content_location_get`. Its use
is for cases when one desires only one hover content, but with a dynamic
special placement within the hover area. The content's geometry,
whenever it changes, will be used to decide on a best location, not
extrapolating the hover's parent object view to show it in (still being
the hover's target determinant of its medium part -- move and resize it
to simulate finger sizes, for example). If one of the directions other
than "smart" are used, a previously content set using it will be
deleted, and vice-versa.

.. note:: The hover object will take up the entire space of ``target``
    object.

.. note:: The content parts listed indicate the direction that the content
    will be displayed


Enumerations
============

.. _Elm_Hover_Axis:

Hover axis
----------

.. data:: ELM_HOVER_AXIS_NONE

    No preferred orientation

.. data:: ELM_HOVER_AXIS_HORIZONTAL

    Horizontal orientation

.. data:: ELM_HOVER_AXIS_VERTICAL

    Vertical orientation

.. data:: ELM_HOVER_AXIS_BOTH

    Both


Inheritance diagram
===================

.. inheritance-diagram:: Hover
    :parts: 2


.. autoclass:: Hover
