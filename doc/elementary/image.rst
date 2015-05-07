.. currentmodule:: efl.elementary

Image
#####

.. image:: /images/image-preview.png


Widget description
==================

An Elementary image object allows one to load and display an image
file on it, be it from a disk file or from a memory region.

Exceptionally, one may also load an Edje group as the contents of the
image. In this case, though, most of the functions of the image API will
act as a no-op.

One can tune various properties of the image, like:

- pre-scaling,
- smooth scaling,
- orientation,
- aspect ratio during resizes, etc.

An image object may also be made valid source and destination for drag
and drop actions by setting :py:attr:`~Image.editable`.


Emitted signals
===============

- ``drop`` - This is called when a user has dropped an image
  typed object onto the object in question -- the
  event info argument is the path to that image file
- ``clicked`` - This is called when a user has clicked the image
- ``download,start`` - remote url download has started
- ``download,progress`` - url download in progress
- ``download,end`` - remote url download has finished
- ``download,error`` - remote url download has finished with errors


Enumerations
============

.. _Elm_Image_Orient:

Image manipulation types
------------------------

.. data:: ELM_IMAGE_ORIENT_NONE

    No orientation change

.. data:: ELM_IMAGE_ORIENT_0

    No orientation change

.. data:: ELM_IMAGE_ROTATE_90

    Rotate 90 degrees clockwise

.. data:: ELM_IMAGE_ROTATE_180

    Rotate 180 degrees clockwise

.. data:: ELM_IMAGE_ROTATE_270

    Rotate 270 degrees clockwise

.. data:: ELM_IMAGE_FLIP_HORIZONTAL

    Flip the image horizontally

.. data:: ELM_IMAGE_FLIP_VERTICAL

    Flip the image vertically

.. data:: ELM_IMAGE_FLIP_TRANSPOSE

    Flip the image along the y = (width - x) line (bottom-left to top-right)

.. data:: ELM_IMAGE_FLIP_TRANSVERSE

    Flip the image along the y = x line (top-left to bottom-right)


Inheritance diagram
===================

.. inheritance-diagram:: Image
    :parts: 2


.. autoclass:: Image
