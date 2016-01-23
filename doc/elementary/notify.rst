.. currentmodule:: efl.elementary

Notify
######

.. image:: /images/notify-preview.png


Widget description
==================

Display a container in a particular region of the parent.

A timeout can be set to automatically hide the notify. This is so that, after
an :py:meth:`~efl.evas.Object.show` on a notify object, if a timeout was set on
it, it will **automatically** get hidden after that time.


Emitted signals
===============

- ``timeout`` - when timeout happens on notify and it's hidden
- ``block,clicked`` - when a click outside of the notify happens
- ``dismissed`` - When notify is closed as a result of a dismiss (since 1.17)


Layout content parts
====================

- ``default`` - The main content of the notify


Enumerations
============

.. _ELM_NOTIFY_ALIGN_FILL:

ELM_NOTIFY_ALIGN_FILL
---------------------

.. data:: ELM_NOTIFY_ALIGN_FILL

    Use with :py:attr:`Notify.align`

    .. versionadded:: 1.8


Inheritance diagram
===================

.. inheritance-diagram:: Notify
    :parts: 2


.. autoclass:: Notify
