.. currentmodule:: efl.elementary

Plug
####


Widget Description
==================

An object that allows one to show an image which other process created.
It can be used anywhere like any other elementary widget.


Emitted signals
===============

- ``clicked`` - the user clicked the image (press/release).
- ``image,deleted`` - the server side was deleted.
- ``image,resized`` - the server side was resized. The ``event_info`` parameter
  of the callback will be ``Evas_Coord_Size`` (two integers).

.. note::
    the event "image,resized" will be sent whenever the server
    resized its image and this **always** happen on the first
    time. Then it can be used to track when the server-side image
    is fully known (client connected to server, retrieved its
    image buffer through shared memory and resized the evas
    object).


Inheritance diagram
===================

.. inheritance-diagram:: Plug
    :parts: 2


.. autoclass:: Plug
