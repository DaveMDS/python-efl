.. currentmodule:: efl.elementary

Hoversel
########

.. image:: /images/hoversel-preview.png


Widget description
==================

A hoversel is a button that pops up a list of items (automatically
choosing the direction to display) that have a label and, optionally, an
icon to select from.

It is a convenience widget to avoid the need to do all the piecing
together yourself. It is intended for a small number of items in the
hoversel menu (no more than 8), though is capable of many more.


Emitted signals
===============

- ``clicked`` - the user clicked the hoversel button and popped up
  the sel
- ``selected`` - an item in the hoversel list is selected. event_info
  is the item
- ``dismissed`` - the hover is dismissed
- ``expanded`` - the hover is expanded (since 1.9)
- ``item,focused`` - the hoversel item has received focus. (since 1.10)
- ``item,unfocused`` - the hoversel item has lost focus. (since 1.10)


Layout content parts
====================

- ``icon`` - An icon of the hoversel


Layout text parts
=================

- ``default`` - Label of the hoversel


Inheritance diagram
===================

.. inheritance-diagram::
    Hoversel
    HoverselItem
    :parts: 2


.. autoclass:: Hoversel
.. autoclass:: HoverselItem
