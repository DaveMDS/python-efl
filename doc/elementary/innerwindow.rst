.. currentmodule:: efl.elementary

Innerwindow
###########

.. image:: /images/innerwindow-preview.png


Widget description
==================

An inwin is a window inside a window that is useful for a quick popup.
It does not hover.

It works by creating an object that will occupy the entire window, so it must be
created using an :py:class:`~efl.elementary.window.Window` as parent only. The
inwin object can be hidden or restacked below every other object if it's needed
to show what's behind it without destroying it. If this is done, the
:py:meth:`~InnerWindow.activate` function can be used to bring it back to full
visibility again.


Available styles
================

- ``default`` The inwin is sized to take over most of the window it's
  placed in.
- ``minimal`` The size of the inwin will be the minimum necessary to show
  its contents.
- ``minimal_vertical`` Horizontally, the inwin takes as much space as
  possible, but it's sized vertically the most it needs to fit its
  contents.


Inheritance diagram
===================

.. inheritance-diagram:: InnerWindow
    :parts: 2


.. autoclass:: InnerWindow
