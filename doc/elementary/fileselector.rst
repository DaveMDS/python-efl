.. currentmodule:: efl.elementary

Fileselector
############

.. image:: /images/fileselector-preview.png


Widget description
==================

A file selector is a widget that allows a user to navigate through a
file system, reporting file selections back via its API.

It contains shortcut buttons for home directory (*~*) and to jump one
directory upwards (..), as well as cancel/ok buttons to confirm/cancel a
given selection. After either one of those two former actions, the file
selector will issue its ``"done"`` smart callback.

There's a text entry on it, too, showing the name of the current
selection. There's the possibility of making it editable, so it is
useful on file saving dialogs on applications, where one gives a file
name to save contents to, in a given directory in the system. This
custom file name will be reported on the ``"done"`` smart callback
(explained in sequence).

Finally, it has a view to display file system items into in two possible
forms:

- list
- grid

If Elementary is built with support of the Ethumb thumbnailing library,
the second form of view will display preview thumbnails of files which
it supports.


Emitted signals
===============

- ``activated`` - the user activated a file. This can happen by
  double-clicking or pressing Enter key. (**event_info** is a string with the
  activated file path)
- ``selected`` - the user has clicked on a file (when not in folders-only
  mode) or directory (when in folders-only mode)
- ``directory,open`` - the list has been populated with new content
  (*event_info* is the directory's path)
- ``done`` - the user has clicked on the "ok" or "cancel"
  buttons (*event_info* is the selection's path)


Layout text parts
=================

- ``ok`` - OK button label if the ok button is set. (since 1.8)
- ``cancel`` - Cancel button label if the cancel button is set. (since 1.8)


Enumerations
============

.. _Elm_Fileselector_Mode:

Fileselector modes
------------------

.. data:: ELM_FILESELECTOR_LIST

    Layout as a list

.. data:: ELM_FILESELECTOR_GRID

    Layout as a grid


.. _Elm_Fileselector_Sort:

Fileselector sort method
------------------------

.. data:: ELM_FILESELECTOR_SORT_BY_FILENAME_ASC

    Sort by filename in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_FILENAME_DESC

    Sort by filename in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_TYPE_ASC

    Sort by file type in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_TYPE_DESC

    Sort by file type in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_SIZE_ASC

    Sort by file size in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_SIZE_DESC

    Sort by file size in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC

    Sort by file modification date in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC

    Sort by file modification date in descending order

    .. versionadded:: 1.9


Inheritance diagram
===================

.. inheritance-diagram:: Fileselector
    :parts: 2


.. autoclass:: Fileselector
