.. currentmodule:: efl.elementary

Photo
#####

.. image:: /images/photo-preview.png


Widget description
==================

An Elementary photo widget is intended for displaying a photo, for
ex., a person's image (contact).

Simple, yet with a very specific purpose. It has a decorative frame
around the inner image itself, on the default theme.

This widget relies on an internal :py:class:`~efl.elementary.icon.Icon`, so
that the APIs of these two widgets are similar (drag and drop is also possible
here, for example).


Emitted signals
===============

- ``clicked`` - This is called when a user has clicked the photo
- ``drag,start`` - One has started dragging the inner image out of the photo's
  frame
- ``drag,end`` - One has dropped the dragged image somewhere


Inheritance diagram
===================

.. inheritance-diagram:: Photo
    :parts: 2


.. autoclass:: Photo
