:mod:`efl.elementary` Package
=============================

Features
--------

Logging
^^^^^^^

Py-Elm provides `logging <http://docs.python.org/2/library/logging.html>`_
to a Logger called *elementary*. It has a NullHandler by default and
doesn't propagate so you need to add handlers to it to get output::

    import logging
    log_from_an_elm = logging.getLogger("elementary")
    log_from_an_elm.addHandler(logging.StreamHandler())

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

C API compatibility
^^^^^^^^^^^^^^^^^^^

All class properties have their respective _get/_set methods defined, for C
API compatibility.

We do not document them nor encourage their use.

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

Python Elementary Acknowledgements
----------------------------------

:Copyright:
    Python Bindings for EFL Elementary are Copyright (C) 2008-2012 Simon Busch
    and various contributors (see AUTHORS).

:License:
    Python Bindings for EFL Elementary are licensed LGPL-3 (see COPYING).

:Authors:
    - `Simon Busch <mailto:morphis@gravedo.de>`_
    - `Boris 'billiob' Faure <mailto:billiob@gmail.com>`_
    - `Davide 'DaveMDS' Andreoli <mailto:dave@gurumeditation.it>`_
    - `Fabiano Fidêncio <mailto:fidencio@profusion.mobi>`_
    - `Bruno Dilly <mailto:bdilly@profusion.mobi>`_
    - `Tiago Falcão <mailto:tiago@profusion.mobi>`_
    - `Joost Albers <mailto:joost.albers@nomadrail.com>`_
    - `Kai Huuhko <mailto:kai.huuhko@gmail.com>`_

Elementary Acknowledgements
---------------------------

There is a lot that goes into making a widget set, and they don't happen out
of nothing. It's like trying to make everyone everywhere happy, regardless
of age, gender, race or nationality - and that is really tough. So thanks to
people and organizations behind this, as listed below:

:Copyright:
    Elementary is Copyright (C) 2008-2012 Carsten Haitzler and various
    contributors (see AUTHORS).

:License:
    Elementary is licensed LGPL-2.1 (see COPYING)

:Authors:
    - `Carsten Haitzler <mailto:raster@rasterman.com>`_
    - `Gustavo Sverzut Barbieri <mailto:barbieri@profusion.mobi>`_
    - `Cedric Bail <mailto:cedric.bail@free.fr>`_
    - `Vincent Torri <mailto:vtorri@univ-evry.fr>`_
    - `Daniel Kolesa <mailto:quaker66@gmail.com>`_
    - `Jaime Thomas <mailto:avi.thomas@gmail.com>`_
    - `Swisscom <http://www.swisscom.ch/>`_
    - `Christopher Michael <mailto:devilhorns@comcast.net>`_
    - `Marco Trevisan (Treviño) <mailto:mail@3v1n0.net>`_
    - `Michael Bouchaud <mailto:michael.bouchaud@gmail.com>`_
    - `Jonathan Atton (Watchwolf) <mailto:jonathan.atton@gmail.com>`_
    - `Brian Wang <mailto:brian.wang.0721@gmail.com>`_
    - `Mike Blumenkrantz (discomfitor/zmike) <mailto:michael.blumenkrantz@gmail.com>`_
    - Samsung Electronics tbd
    - Samsung SAIT tbd
    - `Brett Nash <mailto:nash@nash.id.au>`_
    - `Bruno Dilly <mailto:bdilly@profusion.mobi>`_
    - `Rafael Fonseca <mailto:rfonseca@profusion.mobi>`_
    - `Chuneon Park <mailto:hermet@hermet.pe.kr>`_
    - `Woohyun Jung <mailto:wh0705.jung@samsung.com>`_
    - `Jaehwan Kim <mailto:jae.hwan.kim@samsung.com>`_
    - `Wonguk Jeong <mailto:wonguk.jeong@samsung.com>`_
    - `Leandro A. F. Pereira <mailto:leandro@profusion.mobi>`_
    - `Helen Fornazier <mailto:helen.fornazier@profusion.mobi>`_
    - `Gustavo Lima Chaves <mailto:glima@profusion.mobi>`_
    - `Fabiano Fidêncio <mailto:fidencio@profusion.mobi>`_
    - `Tiago Falcão <mailto:tiago@profusion.mobi>`_
    - `Otavio Pontes <mailto:otavio@profusion.mobi>`_
    - `Viktor Kojouharov <mailto:vkojouharov@gmail.com>`_
    - `Daniel Juyung Seo (SeoZ) <mailto:juyung.seo@samsung.com>`_ (`alt <mailto:seojuyung2@gmail.com>`_)
    - `Sangho Park <mailto:sangho.g.park@samsung.com>`_ (`alt <mailto:gouache95@gmail.com>`_)
    - `Rajeev Ranjan (Rajeev) <mailto:rajeev.r@samsung.com>`_ (`alt <mailto:rajeev.jnnce@gmail.com>`_)
    - `Seunggyun Kim <mailto:sgyun.kim@samsung.com>`_ (`alt <mailto:tmdrbs@gmail.com>`_)
    - `Sohyun Kim <mailto:anna1014.kim@samsung.com>`_ (`alt <mailto:sohyun.anna@gmail.com>`_)
    - `Jihoon Kim <mailto:jihoon48.kim@samsung.com>`_
    - `Jeonghyun Yun (arosis) <mailto:jh0506.yun@samsung.com>`_
    - `Tom Hacohen <mailto:tom@stosb.com>`_
    - `Aharon Hillel <mailto:a.hillel@samsung.com>`_
    - `Jonathan Atton (Watchwolf) <mailto:jonathan.atton@gmail.com>`_
    - `Shinwoo Kim <mailto:kimcinoo@gmail.com>`_
    - `Govindaraju SM  <mailto:govi.sm@samsung.com>`_ (`alt <mailto:govism@gmail.com>`_)
    - `Prince Kumar Dubey <mailto:prince.dubey@samsung.com>`_ (`alt <mailto:prince.dubey@gmail.com>`_)
    - `Sung W. Park <mailto:sungwoo@gmail.com>`_
    - `Thierry el Borgi <mailto:thierry@substantiel.fr>`_
    - `Shilpa Singh  <mailto:shilpa.singh@samsung.com>`_ (`alt <mailto:shilpasingh.o@gmail.com>`_)
    - `Chanwook Jung <mailto:joey.jung@samsung.com>`_
    - `Hyoyoung Chang <mailto:hyoyoung.chang@samsung.com>`_
    - `Guillaume "Kuri" Friloux <mailto:guillaume.friloux@asp64.com>`_
    - `Kim Yunhan <mailto:spbear@gmail.com>`_
    - `Bluezery <mailto:ohpowel@gmail.com>`_
    - `Nicolas Aguirre <mailto:aguirre.nicolas@gmail.com>`_
    - `Sanjeev BA <mailto:iamsanjeev@gmail.com>`_
    - `Hyunsil Park <mailto:hyunsil.park@samsung.com>`_
    - `Goun Lee <mailto:gouni.lee@samsung.com>`_
    - `Mikael Sans <mailto:sans.mikael@gmail.com>`_
    - `Doyoun Kang <mailto:doyoun.kang@samsung.com>`_
    - `M.V.K. Sumanth <mailto:sumanth.m@samsung.com>`_ (`alt <mailto:mvksumanth@gmail.com>`_)
    - `Jérôme Pinot <mailto:ngc891@gmail.com>`_
    - `Davide Andreoli (davemds) <mailto:dave@gurumeditation.it>`_
    - `Michal Pakula vel Rutka <mailto:m.pakula@samsung.com>`_

:Contact: `Enlightenment developer mailing list <mailto:enlightenment-devel@lists.sourceforge.net>`_

Reference
---------

.. toctree::
   :maxdepth: 4

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
