.. currentmodule:: efl.elementary

Check
#####

.. image:: /images/check-preview.png


Widget description
==================

The check widget allows for toggling a value between true and false.

Check objects are a lot like radio objects in layout and functionality,
except they do not work as a group, but independently, and only toggle
the value of a boolean :py:attr:`~Check.state` between false and true.


Emitted signals
===============

- ``changed`` - This is called whenever the user changes the state of
  the check objects.


Layout content parts
====================

- ``icon`` - An icon of the check


Layout text parts
=================

- ``default`` - A label of the check
- ``on`` - On state label of the check
- ``off`` - Off state label of the check


Inheritance diagram
===================

.. inheritance-diagram:: Check
    :parts: 2


.. autoclass:: Check
