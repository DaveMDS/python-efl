.. currentmodule:: efl.elementary

Conformant
##########

.. image:: /images/conformant-preview.png


Widget description
==================

The aim is to provide a widget that can be used in elementary apps to
account for space taken up by the indicator, virtual keypad & softkey
windows when running the illume2 module of E17.

So conformant content will be sized and positioned considering the
space required for such stuff, and when they popup, as a keyboard
shows when an entry is selected, conformant content won't change.


Emitted signals
===============

- ``virtualkeypad,state,on``: if virtualkeypad state is switched to ``on``.
- ``virtualkeypad,state,off``: if virtualkeypad state is switched to ``off``.
- ``clipboard,state,on``: if clipboard state is switched to ``on``.
- ``clipboard,state,off``: if clipboard state is switched to ``off``.


Layout content parts
====================

- ``default`` - A content of the conformant


Inheritance diagram
===================

.. inheritance-diagram:: Conformant
    :parts: 2


.. autoclass:: Conformant
