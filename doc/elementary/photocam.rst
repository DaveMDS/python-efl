.. currentmodule:: efl.elementary

Photocam
########

Widget description
==================

This is a widget specifically for displaying high-resolution digital
camera photos giving speedy feedback (fast load), low memory footprint
and zooming and panning as well as fitting logic. It is entirely focused
on jpeg images, and takes advantage of properties of the jpeg format (via
evas loader features in the jpeg loader).


Emitted signals
===============

- ``clicked`` - This is called when a user has clicked the photo without
  dragging around.
- ``press`` - This is called when a user has pressed down on the photo.
- ``longpressed`` - This is called when a user has pressed down on the
  photo for a long time without dragging around.
- ``clicked,double`` - This is called when a user has double-clicked the
  photo.
- ``load`` - Photo load begins.
- ``loaded`` - This is called when the image file load is complete for
  the first view (low resolution blurry version).
- ``load,detail`` - Photo detailed data load begins.
- ``loaded,detail`` - This is called when the image file load is
  complete for the detailed image data (full resolution needed).
- ``zoom,start`` - Zoom animation started.
- ``zoom,stop`` - Zoom animation stopped.
- ``zoom,change`` - Zoom changed when using an auto zoom mode.
- ``scroll`` - the content has been scrolled (moved)
- ``scroll,anim,start`` - scrolling animation has started
- ``scroll,anim,stop`` - scrolling animation has stopped
- ``scroll,drag,start`` - dragging the contents around has started
- ``scroll,drag,stop`` - dragging the contents around has stopped
- ``download,start`` - remote url download has started
- ``download,progress`` - url download in progress
- ``download,end`` - remote url download has finished
- ``download,error`` - remote url download has finished with errors


Scrollable Interface
====================

This widget supports the scrollable interface.

If you wish to control the scrolling behaviour using these functions,
inherit both the widget class and the
:py:class:`~efl.elementary.scroller.Scrollable` class
using multiple inheritance, for example::

    class ScrollableGenlist(Genlist, Scrollable):
        def __init__(self, canvas, *args, **kwargs):
            Genlist.__init__(self, canvas)


Enumerations
============

.. _Elm_Photocam_Zoom_Mode:

Photocam zoom modes
-------------------

.. data:: ELM_PHOTOCAM_ZOOM_MODE_MANUAL

    Zoom controlled normally by :py:attr:`~Photocam.zoom`

.. data:: ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT

    Zoom until photo fits in photocam

.. data:: ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL

    Zoom until photo fills photocam

.. data:: ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT_IN

    Zoom in until photo fits in photocam


Inheritance diagram
===================

.. inheritance-diagram:: Photocam
    :parts: 2


.. autoclass:: Photocam
