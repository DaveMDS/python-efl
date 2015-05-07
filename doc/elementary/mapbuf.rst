.. currentmodule:: efl.elementary

Mapbuf
######

.. image:: /images/mapbuf-preview.png


Widget description
==================

This holds one content object and uses an Evas Map of transformation
points to be later used with this content. So the content will be
moved, resized, etc as a single image. So it will improve performance
when you have a complex interface, with a lot of elements, and will
need to resize or move it frequently (the content object and its
children).


Layout content parts
====================

- ``default`` - The main content of the mapbuf


Inheritance diagram
===================

.. inheritance-diagram:: Mapbuf
    :parts: 2


.. autoclass:: Mapbuf
