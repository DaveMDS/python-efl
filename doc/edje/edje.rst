
.. _edje_main_intro:

What is Edje?
=============

Edje is a complex graphical design & layout library.

It doesn't intend to do containing and regular layout like a widget
set, but it is the base for such components. Based on the requirements
of Enlightenment 0.17, Edje should serve all the purposes of creating
visual elements (borders of windows, buttons, scrollbars, etc.) and
allow the designer the ability to animate, layout and control the look
and feel of any program using Edje as its basic GUI constructor. This
library allows for multiple collections of Layouts in one file,
sharing the same image and font database and thus allowing a whole
theme to be conveniently packaged into 1 file and shipped around.

Edje separates the layout and behavior logic. Edje files ship with an
image and font database, used by all the parts in all the collections
to source graphical data. It has a directory of logical part names
pointing to the part collection entry ID in the file (thus allowing
for multiple logical names to point to the same part collection,
allowing for the sharing of data between display elements). Each part
collection consists of a list of visual parts, as well as a list of
programs. A program is a conditionally run program that if a
particular event occurs (a button is pressed, a mouse enters or leaves
a part) will trigger an action that may affect other parts. In this
way a part collection can be "programmed" via its file as to hilight
buttons when the mouse passes over them or show hidden parts when a
button is clicked somewhere etc. The actions performed in changing
from one state to another are also allowed to transition over a period
of time, allowing animation. Programs and animations can be run in
"parallel".

This separation and simplistic event driven style of programming can produce
almost any look and feel one could want for basic visual elements. Anything
more complex is likely the domain of an application or widget set that may
use Edje as a convenient way of being able to configure parts of the display.


So how does this all work?
==========================

Edje internally holds a geometry state machine and state graph of what is
visible, not, where, at what size, with what colors etc. This is described
to Edje from an Edje .edj file containing this information. These files can
be produced by using edje_cc to take a text file (a .edc file) and "compile"
an output .edj file that contains this information, images and any other
data needed.

The application using Edje will then create an object in its Evas
canvas and set the bundle file to use, specifying the **group** name to
use. Edje will load such information and create all the required
children objects with the specified properties as defined in each
**part** of the given **group**.

Edje is an important EFL component because it makes easy to split logic and
UI, usually used as theme engine but can be much more powerful than just
changing some random images or text fonts.

Edje also provides scripting through Embryo and communication can be
done using messages and signals.

.. seealso::
    Before digging into changing or creating your own Edje source (edc)
    files, read the `Edje Data Collection reference
    <https://build.enlightenment.org/job/nightly_efl_gcc_x86_64/lastSuccessful
    Buil d/artifact/doc/html/edcref.html>`_ .


Signals from the edje object
============================
You can debug signals and messagges by capturing all of them, example::

    def sig_dbg(obj, emission, source):
        print(obj, emission, source)

    def msg_dbg(obj, msg):
        print(obj, msg)

    my_edje.signal_callback_add("*", "*", sig_dbg)
    my_edje.message_handler_set(msg_dbg)


API Reference
=============

.. toctree::
   :titlesonly:

   module-edje.rst

Inheritance diagram
===================

.. inheritance-diagram:: efl.edje
    :parts: 2
