.. currentmodule:: efl.elementary

Scroller
########

.. image:: /images/scroller-preview.png


Widget description
==================

A scroller holds a single object and "scrolls it around".

This means that it allows the user to use a scrollbar (or a finger) to
drag the viewable region around, allowing to move through a much larger
object that is contained in the scroller. The scroller will always have
a small minimum size by default as it won't be limited by the contents
of the scroller.

This widget inherits from :py:class:`~efl.elementary.layout_class.LayoutClass`,
so that all the functions acting on it also work for scroller objects.

.. note:: When Elementary is in embedded mode the scrollbars will not be
          draggable, they appear merely as indicators of how much has been
          scrolled.

.. note:: When Elementary is in desktop mode the thumbscroll(a.k.a.
          fingerscroll) won't work.

Emitted signals
===============

- ``edge,left`` - the left edge of the content has been reached
- ``edge,right`` - the right edge of the content has been reached
- ``edge,top`` - the top edge of the content has been reached
- ``edge,bottom`` - the bottom edge of the content has been reached
- ``scroll`` - the content has been scrolled (moved)
- ``scroll,left`` - the content has been scrolled (moved) leftwards
- ``scroll,right``  - the content has been scrolled (moved) rightwards
- ``scroll,up``  - the content has been scrolled (moved) upwards
- ``scroll,down`` - the content has been scrolled (moved) downwards
- ``scroll,anim,start`` - scrolling animation has started
- ``scroll,anim,stop`` - scrolling animation has stopped
- ``scroll,drag,start`` - dragging the contents around has started
- ``scroll,drag,stop`` - dragging the contents around has stopped
- ``vbar,drag`` - the vertical scroll bar has been dragged
- ``vbar,press`` - the vertical scroll bar has been pressed
- ``vbar,unpress`` - the vertical scroll bar has been unpressed
- ``hbar,drag`` - the horizontal scroll bar has been dragged
- ``hbar,press`` - the horizontal scroll bar has been pressed
- ``hbar,unpress`` - the horizontal scroll bar has been unpressed
- ``scroll,page,changed`` - the visible page has changed

.. note:: The "scroll,anim,*" and "scroll,drag,*" signals are only emitted by
    user intervention.


Layout content parts
====================

- ``default`` - A content of the scroller


Enumerations
============

.. _Elm_Scroller_Policy:

Scrollbar visibility
--------------------

.. data:: ELM_SCROLLER_POLICY_AUTO

    Show scrollbars as needed

.. data:: ELM_SCROLLER_POLICY_ON

    Always show scrollbars

.. data:: ELM_SCROLLER_POLICY_OFF

    Never show scrollbars


.. _Elm_Scroller_Single_Direction:

Single direction
----------------

Type that controls how the content is scrolled.

.. data:: ELM_SCROLLER_SINGLE_DIRECTION_NONE

    Scroll every direction

.. data:: ELM_SCROLLER_SINGLE_DIRECTION_SOFT

    Scroll single direction if the direction is certain

.. data:: ELM_SCROLLER_SINGLE_DIRECTION_HARD

    Scroll only single direction


.. _Elm_Scroller_Movement_Block:

Movement block
--------------

Type that blocks the scroll movement in one or more direction.

:since: 1.8

.. data:: ELM_SCROLLER_MOVEMENT_NO_BLOCK

    Do not block movements

.. data:: ELM_SCROLLER_MOVEMENT_BLOCK_VERTICAL

    Block vertical movements

.. data:: ELM_SCROLLER_MOVEMENT_BLOCK_HORIZONTAL

    Block horizontal movements


Inheritance diagram
===================

.. inheritance-diagram:: Scroller
    :parts: 2


.. autoclass:: Scroller
.. autoclass:: Scrollable
