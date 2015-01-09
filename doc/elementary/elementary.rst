

What is Elementary?
-------------------

Elementary is a  the high level toolkit based on the underlying efl
technologies (:doc:`Evas </evas/evas>`, :doc:`Edje </edje/edje>`,
:doc:`Ecore </ecore/ecore>`, etc...). It provide all the
widget you need to build a full application.

It is meant to make the programmers work almost brainless but give them lots
of flexibility.


Callbacks
---------

Widget callbacks
^^^^^^^^^^^^^^^^

Widget callbacks are set with callback_*_add methods which take a callable,
and optional args, kwargs as data.

The callbacks have a signature of either::

    obj, *args, **kwargs

or::

    obj, event_info, *args, **kwargs


Event callbacks
^^^^^^^^^^^^^^^

Event callbacks have signature of::

    object, source_object, event_type, event_info, *args, **kwargs


A sample Python Elementary program
----------------------------------

.. literalinclude:: ../../examples/elementary/test_win_dialog.py
    :language: python



API Reference
-------------

.. toctree::
   :maxdepth: 1

   elementary_module
   actionslider
   background
   box
   bubble
   button
   calendar
   check
   clock
   colorselector
   configuration
   conformant
   ctxpopup
   datetime
   dayselector
   diskselector
   entry
   fileselector
   fileselector_button
   fileselector_entry
   flip
   flipselector
   frame
   general
   gengrid
   genlist
   gesture_layer
   grid
   hover
   hoversel
   icon
   image
   index
   innerwindow
   label
   layout
   layout_class
   list
   map
   mapbuf
   menu
   multibuttonentry
   naviframe
   need
   notify
   object
   object_item
   panel
   panes
   photo
   photocam
   plug
   popup
   progressbar
   radio
   scroller
   segment_control
   separator
   slider
   slideshow
   spinner
   table
   theme
   thumb
   toolbar
   transit
   video
   web
   window


Inheritance diagram
-------------------

.. inheritance-diagram::
    efl.elementary.actionslider
    efl.elementary.background
    efl.elementary.box
    efl.elementary.bubble
    efl.elementary.button
    efl.elementary.calendar_elm
    efl.elementary.check
    efl.elementary.clock
    efl.elementary.colorselector
    efl.elementary.configuration
    efl.elementary.conformant
    efl.elementary.ctxpopup
    efl.elementary.datetime_elm
    efl.elementary.dayselector
    efl.elementary.diskselector
    efl.elementary.entry
    efl.elementary.fileselector
    efl.elementary.fileselector_button
    efl.elementary.fileselector_entry
    efl.elementary.flip
    efl.elementary.flipselector
    efl.elementary.frame
    efl.elementary.general
    efl.elementary.gengrid
    efl.elementary.genlist
    efl.elementary.gesture_layer
    efl.elementary.grid
    efl.elementary.hover
    efl.elementary.hoversel
    efl.elementary.icon
    efl.elementary.image
    efl.elementary.index
    efl.elementary.innerwindow
    efl.elementary.label
    efl.elementary.layout
    efl.elementary.layout_class
    efl.elementary.list
    efl.elementary.map
    efl.elementary.mapbuf
    efl.elementary.menu
    efl.elementary.multibuttonentry
    efl.elementary.naviframe
    efl.elementary.need
    efl.elementary.notify
    efl.elementary.object
    efl.elementary.object_item
    efl.elementary.panel
    efl.elementary.panes
    efl.elementary.photo
    efl.elementary.photocam
    efl.elementary.plug
    efl.elementary.popup
    efl.elementary.progressbar
    efl.elementary.radio
    efl.elementary.scroller
    efl.elementary.segment_control
    efl.elementary.separator
    efl.elementary.slider
    efl.elementary.slideshow
    efl.elementary.spinner
    efl.elementary.table
    efl.elementary.theme
    efl.elementary.thumb
    efl.elementary.toolbar
    efl.elementary.transit
    efl.elementary.video
    efl.elementary.web
    efl.elementary.window
    :parts: 2
