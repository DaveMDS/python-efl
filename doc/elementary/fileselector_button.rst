.. currentmodule:: efl.elementary

Fileselector Button
###################

.. image:: /images/fileselector-button-preview.png


Widget description
==================

This is a button that, when clicked, creates an Elementary window (or
inner window) with a :py:class:`~efl.elementary.fileselector.Fileselector`
within.

When a file is chosen, the (inner) window is closed and the button emits
a signal having the selected file as it's ``event_info``.

This widget encapsulates operations on its internal file selector on its
own API. There is less control over its file selector than that one
would have instantiating one directly.


Available styles
================

- ``default``
- ``anchor``
- ``hoversel_vertical``
- ``hoversel_vertical_entry``


Emitted signals
===============

- ``file,chosen`` - the user has selected a path which comes as the
  ``event_info`` data


Layout text parts
=================

- ``default`` - Label of the fileselector_button


Layout content parts
====================

- ``icon`` - Icon of the fileselector_button


Fileselector Interface
======================

This widget supports the fileselector interface.

If you wish to control the fileselector part using these functions,
inherit both the widget class and the
:py:class:`~efl.elementary.fileselector.Fileselector` class
using multiple inheritance, for example::

    class CustomFileselectorButton(Fileselector, FileselectorButton):
        def __init__(self, canvas, *args, **kwargs):
            FileselectorButton.__init__(self, canvas)


Inheritance diagram
===================

.. inheritance-diagram:: FileselectorButton
    :parts: 2


.. autoclass:: FileselectorButton
