:mod:`efl.elementary` Package
=============================

Features
--------

Callbacks
^^^^^^^^^

.. rubric:: Widget callbacks

Widget callbacks are set with callback_*_add methods which take a callable,
and optional args, kwargs as data.

The callbacks have a signature of either::

    obj, *args, **kwargs

or::

    obj, event_info, *args, **kwargs

.. rubric:: Event callbacks

Event callbacks have signature of::

    object, source_object, event_type, event_info, *args, **kwargs

Hello Python Elementary
-----------------------

Let's create an interactive "Hello World" gui where you can click the ok
button to exit::

    import efl.elementary as elm

    def on_done(obj):
        # quit the mainloop
        elm.exit()

    class Spam:
        def __init__(self):
            # new window - do the usual and give it a name (hello) and title (Hello)
            win = elm.StandardWindow("hello", "Hello")
            # when the user clicks "close" on a window there is a request to delete
            win.callback_delete_request_add(on_done)

            # add a box object - default is vertical. a box holds children in a row,
            # either horizontally or vertically. nothing more.
            box = elm.Box(win)
            # make the box horizontal
            box.horizontal = True
            # add object as a resize object for the window (controls window minimum
            # size as well as gets resized if window is resized)
            win.resize_object_add(box)
            box.show()

            # add a label widget, set the text and put it in the pad frame
            lab = elm.Label(win)
            # set default text of the label
            lab.text = "Hello out there world!"
            # pack the label at the end of the box
            box.pack_end(lab)
            lab.show()

            # add an ok button
            btn = elm.Button(win)
            # set default text of button to "OK"
            btn.text = "OK"
            # pack the button at the end of the box
            box.pack_end(btn)
            btn.show()
            # call on_done when button is clicked
            btn.callback_clicked_add(on_done)

            # now we are done, show the window
            win.show()

    if __name__ == "__main__":
        elm.init()
        food = Spam()
        # run the mainloop and process events and callbacks
        elm.run()
        elm.shutdown()

What is Elementary?
-------------------

Elementary is a VERY SIMPLE toolkit. It is not meant for writing extensive desktop
applications (yet). Small simple ones with simple needs.

It is meant to make the programmers work almost brainless but give them lots
of flexibility.


Reference
---------

.. toctree::
   :maxdepth: 4

   module-access
   module-actionslider
   module-background
   module-box
   module-bubble
   module-button
   module-calendar
   module-check
   module-clock
   module-colorselector
   module-configuration
   module-conformant
   module-ctxpopup
   module-datetime
   module-dayselector
   module-diskselector
   module-entry
   module-fileselector
   module-fileselector_button
   module-fileselector_entry
   module-flip
   module-flipselector
   module-frame
   module-general
   module-gengrid
   module-genlist
   module-gesture_layer
   module-grid
   module-hover
   module-hoversel
   module-icon
   module-image
   module-index
   module-innerwindow
   module-label
   module-layout
   module-layout_class
   module-list
   module-map
   module-mapbuf
   module-menu
   module-multibuttonentry
   module-naviframe
   module-need
   module-notify
   module-object
   module-object_item
   module-panel
   module-panes
   module-photo
   module-photocam
   module-plug
   module-popup
   module-progressbar
   module-radio
   module-scroller
   module-segment_control
   module-separator
   module-slider
   module-slideshow
   module-spinner
   module-table
   module-theme
   module-thumb
   module-toolbar
   module-transit
   module-video
   module-web
   module-window

Inheritance diagram
-------------------

.. inheritance-diagram::
    efl.elementary.access
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
