.. currentmodule:: efl.elementary

Menu
####

.. image:: /images/menu-preview.png


Widget description
==================

A menu is a list of items displayed above its parent.

When the menu is showing its parent is darkened. Each item can have a
sub-menu. The menu object can be used to display a menu on a right click
event, in a toolbar, anywhere.


Emitted signals
===============

- ``clicked`` - the user clicked the empty space in the menu to dismiss.
- ``dismissed`` - the user clicked the empty space in the menu to dismiss (since 1.8)


Layout content parts
====================

- ``default`` - A main content of the menu item


Layout text parts
=================

- ``default`` - label in the menu item


Inheritance diagram
===================

.. inheritance-diagram::
    Menu
    MenuItem
    :parts: 2


.. autoclass:: Menu
.. autoclass:: MenuItem
