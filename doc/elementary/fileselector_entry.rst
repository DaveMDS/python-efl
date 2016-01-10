.. currentmodule:: efl.elementary

Fileselector Entry
##################

.. image:: /images/fileselector-entry-preview.png


Widget description
==================

This is an entry made to be filled with or display a file
system path string.

Besides the entry itself, the widget has a
:py:class:`~efl.elementary.fileselector_button.FileselectorButton` on its side,
which will raise an internal
:py:class:`~efl.elementary.fileselector.Fileselector`, when clicked, for path
selection aided by file system navigation.

This file selector may appear in an Elementary window or in an
inner window. When a file is chosen from it, the (inner) window
is closed and the selected file's path string is exposed both as
a smart event and as the new text on the entry.

This widget encapsulates operations on its internal file
selector on its own API. There is less control over its file
selector than that one would have instantiating one directly.


Emitted signals
===============

- ``changed`` - The text within the entry was changed
- ``activated`` - The entry has had editing finished and
  changes are to be "committed"
- ``press`` - The entry has been clicked
- ``longpressed`` - The entry has been clicked (and held) for a
  couple seconds
- ``clicked`` - The entry has been clicked
- ``clicked,double`` - The entry has been double clicked
- ``selection,paste`` - A paste action has occurred on the
  entry
- ``selection,copy`` - A copy action has occurred on the entry
- ``selection,cut`` - A cut action has occurred on the entry
- ``unpressed`` - The file selector entry's button was released
  after being pressed.
- ``file,chosen`` - The user has selected a path via the file
  selector entry's internal file selector, whose string
  comes as the ``event_info`` data.


Layout text parts
=================

- ``default`` - Label of the fileselector_button


Layout content parts
====================

- ``button icon`` - Button icon of the fileselector_entry


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

.. inheritance-diagram:: FileselectorEntry
    :parts: 2


.. autoclass:: FileselectorEntry
