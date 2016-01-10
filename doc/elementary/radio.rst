.. currentmodule:: efl.elementary

Radio
#####

.. image:: /images/radio-preview.png


Widget description
==================

Radio is a widget that allows for one or more options to be displayed
and have the user choose only one of them.

A radio object contains an indicator, an optional Label and an optional
icon object. While it's possible to have a group of only one radio they,
are normally used in groups of two or more.

Radio objects are grouped in a slightly different, compared to other UI
toolkits. There is no separate group name/id to remember or manage. The
members represent the group, there are the group. To make a group, use
:py:meth:`Radio.group_add` and pass existing radio object and the new radio
object.

The radio object(s) will select from one of a set of integer values, so
any value they are configuring needs to be mapped to a set of integers.
To configure what value that radio object represents, use
:py:attr:`~Radio.state_value` to set the integer it represents. The
value of the whole group (which one is currently selected) is
represented by the property :py:attr:`~Radio.value` on any group member. For
convenience the radio objects are also able to directly set an
integer(int) to the value that is selected.


Emitted signals
===============

- ``changed`` - This is called whenever the user changes the state of one of
    the radio objects within the group of radio objects that work together.


Layout text parts
=================

- ``default`` - Label of the radio


Layout content parts
====================

- ``icon`` - An icon of the radio


Inheritance diagram
===================

.. inheritance-diagram:: Radio
    :parts: 2


.. autoclass:: Radio
