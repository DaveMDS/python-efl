.. currentmodule:: efl.elementary

MultiButtonEntry
################

.. image:: /images/multibuttonentry-preview.png


Widget description
==================

A Multibuttonentry is a widget to allow a user enter text and manage
it as a number of buttons. Each text button is inserted by pressing the
"return" key. If there is no space in the current row, a new button is
added to the next row. When a text button is pressed, it will become
focused. Backspace removes the focus. When the Multibuttonentry loses
focus items longer than one line are shrunk to one line.

Typical use case of multibuttonentry is, composing emails/messages to a
group of addresses, each of which is an item that can be clicked for
further actions.


Emitted signals
===============

- ``item,selected`` - this is called when an item is selected by
  api, user interaction, and etc. this is also called when a
  user press back space while cursor is on the first field of
  entry. event_info contains the item.
- ``item,added`` - when a new multi-button entry item is added.
  event_info contains the item.
- ``item,deleted`` - when a multi-button entry item is deleted.
  event_info contains the item.
- ``item,clicked`` - this is called when an item is clicked by user
  interaction. Both "item,selected" and "item,clicked" are needed.
  event_info contains the item.
- ``clicked`` - when multi-button entry is clicked.
- ``expanded`` - when multi-button entry is expanded.
- ``contracted`` - when multi-button entry is contracted.
- ``expand,state,changed`` - when shrink mode state of
  multi-button entry is changed.


Layout text parts
=================

- ``default`` - A label of the multibuttonentry
- ``default`` - A label of the multibuttonentry item


Inheritance diagram
===================

.. inheritance-diagram:: MultiButtonEntry
    :parts: 2


.. autoclass:: MultiButtonEntry
.. autoclass:: MultiButtonEntryItem
