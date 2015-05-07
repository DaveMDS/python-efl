.. currentmodule:: efl.elementary

Actionslider
############

.. image:: /images/actionslider-preview.png


Widget description
==================

An actionslider is a switcher for two or three labels with
customizable magnet properties.

The user drags and releases the indicator, to choose a label.

Labels can occupy the following positions.

- Left
- Right
- Center

Positions can be enabled or disabled.

Magnets can be set on the above positions.

When the indicator is released, it will move to its nearest "enabled and
magnetized" position.


Emitted signals
===============

- ``selected`` - when user selects an enabled position (the label is
  passed as event info)".
- ``pos_changed`` - when the indicator reaches any of the
  positions("left", "right" or "center").


Layout text parts
=================

- ``indicator`` - An indicator label of the actionslider
- ``left`` - A left label of the actionslider
- ``right`` - A right label of the actionslider
- ``center`` - A center label of the actionslider


Enumerations
============

.. _Elm_Actionslider_Pos:

Actionslider positions
----------------------

.. data:: ELM_ACTIONSLIDER_NONE

    No position

.. data:: ELM_ACTIONSLIDER_LEFT

    Left position

.. data:: ELM_ACTIONSLIDER_CENTER

    Center position

.. data:: ELM_ACTIONSLIDER_RIGHT

    Right position

.. data:: ELM_ACTIONSLIDER_ALL

    All positions


Inheritance diagram
===================

.. inheritance-diagram:: Actionslider
    :parts: 2


.. autoclass:: Actionslider
