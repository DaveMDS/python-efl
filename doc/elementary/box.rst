.. currentmodule:: efl.elementary

Box
###

.. image:: /images/box-preview.png


Widget description
==================

A box arranges objects in a linear fashion, governed by a layout function
that defines the details of this arrangement.

By default, the box will use an internal function to set the layout to
a single row, either vertical or horizontal. This layout is affected
by a number of parameters, such as the homogeneous flag set by
:py:attr:`~Box.homogeneous`, the values given by :py:attr:`~Box.padding` and
:py:attr:`~Box.align` and the hints set to each object in the box.

For this default layout, it's possible to change the orientation with
:py:attr:`~Box.horizontal`. The box will start in the vertical orientation,
placing its elements ordered from top to bottom. When horizontal is set,
the order will go from left to right. If the box is set to be
homogeneous, every object in it will be assigned the same space, that
of the largest object. Padding can be used to set some spacing between
the cell given to each object. The alignment of the box, set with
:py:attr:`~Box.align`, determines how the bounding box of all the elements
will be placed within the space given to the box widget itself.

The size hints of each object also affect how they are placed and sized
within the box. :py:attr:`~efl.evas.Object.size_hint_min` will give the minimum
size the object can have, and the box will use it as the basis for all
latter calculations. Elementary widgets set their own minimum size as
needed, so there's rarely any need to use it manually.

:py:attr:`~efl.evas.Object.size_hint_weight`, when not in homogeneous mode, is
used to tell whether the object will be allocated the minimum size it
needs or if the space given to it should be expanded. It's important
to realize that expanding the size given to the object is not the same
thing as resizing the object. It could very well end being a small
widget floating in a much larger empty space. If not set, the weight
for objects will normally be 0.0 for both axis, meaning the widget will
not be expanded. To take as much space possible, set the weight to
``EVAS_HINT_EXPAND`` (defined to 1.0) for the desired axis to expand.

Besides how much space each object is allocated, it's possible to control
how the widget will be placed within that space using
:py:attr:`~efl.evas.Object.size_hint_align`. By default, this value will be 0.5
for both axis, meaning the object will be centered, but any value from
0.0 (left or top, for the ``x`` and ``y`` axis, respectively) to 1.0
(right or bottom) can be used. The special value *EVAS_HINT_FILL*, which
is -1.0, means the object will be resized to fill the entire space it
was allocated.

In addition, customized functions to define the layout can be set, which
allow the application developer to organize the objects within the box
in any number of ways.

The special :py:meth:`Box.layout_transition` function can be used
to switch from one layout to another, animating the motion of the
children of the box.

.. note:: Objects should not be added to box objects using _add() calls.


Enumerations
============

.. _Evas_Object_Box_Layout:

Box layout modes
----------------

.. data:: ELM_BOX_LAYOUT_HORIZONTAL

    Horizontal layout

.. data:: ELM_BOX_LAYOUT_VERTICAL

    Vertical layout

.. data:: ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL

    Homogeneous vertical layout

.. data:: ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL

    Homogeneous horizontal layout

.. data:: ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL

    Homogeneous layout, maximum size on the horizontal axis

.. data:: ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL

    Homogeneous layout, maximum size on the horizontal axis

.. data:: ELM_BOX_LAYOUT_FLOW_HORIZONTAL

    Horizontally flowing layout

.. data:: ELM_BOX_LAYOUT_FLOW_VERTICAL

    Vertically flowing layout

.. data:: ELM_BOX_LAYOUT_STACK

    Stacking layout


Inheritance diagram
===================

.. inheritance-diagram:: Box
    :parts: 2

.. autoclass:: Box
