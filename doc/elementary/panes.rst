.. currentmodule:: efl.elementary

Panes
#####

.. image:: /images/panes-preview.png


Widget description
==================

The panes widget adds a draggable bar between two contents. When
dragged this bar will resize contents' size.

Panes can be displayed vertically or horizontally, and contents size
proportion can be customized (homogeneous by default).


Emitted signals
===============

- ``press`` - The panes has been pressed (button wasn't released yet).
- ``unpressed`` - The panes was released after being pressed.
- ``clicked`` - The panes has been clicked.
- ``clicked,double`` - The panes has been double clicked.


Layout content parts
====================

- ``left`` - A leftside content of the panes
- ``right`` - A rightside content of the panes
- ``top`` - A top content of the vertical panes
- ``bottom`` - A bottom content of the vertical panes

If panes are displayed vertically, left content will be displayed on top.


Inheritance diagram
===================

.. inheritance-diagram:: Panes
    :parts: 2


.. autoclass:: Panes
