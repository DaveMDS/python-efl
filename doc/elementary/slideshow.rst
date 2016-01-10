.. currentmodule:: efl.elementary

Slideshow
#########

.. image:: /images/slideshow-preview.png


Widget description
==================

This widget, as the name indicates, is a pre-made image
slideshow panel, with API functions acting on (child) image
items presentation. Between those actions, are:

- advance to next/previous image
- select the style of image transition animation
- set the exhibition time for each image
- start/stop the slideshow

The transition animations are defined in the widget's theme,
consequently new animations can be added without having to
update the widget's code.

Slideshow items
===============

For slideshow items, just like for :py:class:`~efl.elementary.genlist.Genlist`
ones, the user defines a **classes**, specifying functions that will be called
on the item's creation and deletion times.

The :py:class:`SlideshowItemClass` class contains the following
members:

- ``get`` - When an item is displayed, this function is
  called, and it's where one should create the item object, de
  facto. For example, the object can be a pure Evas image object
  or a :py:class:`~efl.elementary.photocam.Photocam` widget.

- ``delete`` - When an item is no more displayed, this function
  is called, where the user must delete any data associated to
  the item.

Slideshow caching
=================

The slideshow provides facilities to have items adjacent to the
one being displayed **already "realized"** (i.e. loaded) for
you, so that the system does not have to decode image data
anymore at the time it has to actually switch images on its
viewport. The user is able to set the numbers of items to be
cached **before** and **after** the current item, in the widget's
item list.


Emitted signals
===============

- ``changed`` - when the slideshow switches its view to a new item.
  event_info parameter in callback contains the current visible item
- ``transition,end`` - when a slide transition ends. event_info
  parameter in callback contains the current visible item


Inheritance diagram
===================

.. inheritance-diagram:: Slideshow
    :parts: 2


.. autoclass:: Slideshow
.. autoclass:: SlideshowItem
.. autoclass:: SlideshowItemClass
