.. currentmodule:: efl.elementary

Colorselector
#############

.. image:: /images/colorselector-preview.png


Widget description
==================

A Colorselector is a color selection widget.

It allows application to set a series of colors. It also allows to
load/save colors from/to config with a unique identifier, by default,
the colors are loaded/saved from/to config using "default" identifier.
The colors can be picked by user from the color set by clicking on
individual color item on the palette or by selecting it from selector.


Emitted signals
===============

- ``"changed"`` - When the color value changes on selector
- ``"color,item,selected"`` - When user clicks on color item.
    The event_info parameter of the callback will be the selected
    color item.
- ``"color,item,longpressed"`` - When user long presses on color item.
    The event_info parameter of the callback will be the selected
    color item.


Enumerations
============

.. _Elm_Colorselector_Mode:

Colorselector modes
-------------------

.. data:: ELM_COLORSELECTOR_PALETTE

    Show palette

.. data:: ELM_COLORSELECTOR_COMPONENTS

    Show components

.. data:: ELM_COLORSELECTOR_BOTH

    Show palette and components


Inheritance diagram
===================

.. inheritance-diagram::
    Colorselector
    ColorselectorPaletteItem
    :parts: 2


.. autoclass:: Colorselector
.. autoclass:: ColorselectorPaletteItem
