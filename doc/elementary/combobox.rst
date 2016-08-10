.. currentmodule:: efl.elementary

Combobox
########

.. warning::
    **THE COMBOBOX IS BROKEN AND DEPRECATED, DO NOT USE IN ANY CASE !!**

    The behaviour and the API of the Combobox will change in future release.

    If you are already using this we really encourage you to switch
    to other widgets.

    We are really sorry about this breakage, but there is nothing we can do
    to avoid this :(

.. image:: /images/combobox-preview.png

Widget description
==================

This is a the classic combobox widget, it is the composition of a
:class:`Button`, an :class:`Entry`, a :class:`Genlist` and an :class:`Hover`.
Thus you can use all the functionality of the base classes on the
:class:`Combobox` itself.


Available styles
================

- ``default`` a normal combobox.


Emitted signals
===============

- ``dismissed``: The combobox hover has been dismissed.
- ``expanded``: The combobox hover has been expanded.
- ``clicked``: The combobox button has been clicked.
- ``item,selected``: An item has been selected (highlighted).
- ``item,pressed``: An item has been pressed (clicked).
- ``filter,done``:  Item filtering on genlist is completed.


Inheritance diagram
===================

.. inheritance-diagram:: Combobox
    :parts: 2


.. autoclass:: _Combobox
.. autoclass:: Combobox

