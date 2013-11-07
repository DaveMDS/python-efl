:mod:`efl.evas` Module
======================

.. module:: efl.evas

What is Evas?
-------------

Evas is a clean display canvas API for several target display systems
that can draw anti-aliased text, smooth super and sub-sampled scaled
images, alpha-blend objects and much more.

It abstracts any need to know much about what the characteristics of
your display system are or what graphics calls are used to draw them
and how. It deals on an object level where all you do is create and
manipulate objects in a canvas, set their properties, and the rest is
done for you.

Evas optimises the rendering pipeline to minimise effort in redrawing
changes made to the canvas and so takes this work out of the
programmers hand, saving a lot of time and energy.

It's small and lean, designed to work on embedded systems all the way
to large and powerful multi-cpu workstations. It can be compiled to
only have the features you need for your target platform if you so
wish, thus keeping it small and lean. It has several display
back-ends, letting it display on several display systems, making it
portable for cross-device and cross-platform development.


What Evas is not?
-----------------

Evas is not a widget set or widget toolkit, however it is their base. See
:doc:`Elementary </elementary/elementary>` for a toolkit
based on :doc:`Evas </evas/evas>`, :doc:`Edje </edje/edje>`,
:doc:`Ecore </ecore/ecore>` and other Enlightenment technologies.

It is not dependent or aware of main loops, input or output systems. Input
should be polled from various sources and fed to Evas. Similarly, it will
not create windows or report windows updates to your system, rather just
drawing the pixels and reporting to the user the areas that were changed.


How does Evas work?
-------------------

Evas is a canvas display library. This is markedly different from most
display and windowing systems as a canvas is structural and is also a
state engine, whereas most display and windowing systems are immediate
mode display targets. Evas handles the logic between a structural
display via its state engine, and controls the target windowing system
in order to produce rendered results of the current canvas' state on
the display.

Immediate mode display systems retain very little, or no state. A
program will execute a series of commands, as in the pseudo code::

    draw line from position (0, 0) to position (100, 200);

    draw rectangle from position (10, 30) to position (50, 500);

    bitmap_handle = create_bitmap();
    scale bitmap_handle to size 100 x 100;
    draw image bitmap_handle at position (10, 30);

The series of commands is executed by the windowing system and the
results are displayed on the screen (normally). Once the commands are
executed the display system has little or no idea of how to reproduce
this image again, and so has to be instructed by the application how
to redraw sections of the screen whenever needed. Each successive
command will be executed as instructed by the application and either
emulated by software or sent to the graphics hardware on the device to
be performed.

The advantage of such a system is that it is simple, and gives a
program tight control over how something looks and is drawn. Given the
increasing complexity of displays and demands by users to have better
looking interfaces, more and more work is needing to be done at this
level by the internals of widget sets, custom display widgets and
other programs. This means more and more logic and display rendering
code needs to be written time and time again, each time the
application needs to figure out how to minimise redraws so that
display is fast and interactive, and keep track of redraw logic. The
power comes at a high-price, lots of extra code and work.  Programmers
not very familiar with graphics programming will often make mistakes
at this level and produce code that is sub optimal. Those familiar
with this kind of programming will simply get bored by writing the
same code again and again.

For example, if in the above scene, the windowing system requires the
application to redraw the area from 0, 0 to 50, 50 (also referred as
"expose event"), then the programmer must calculate manually the
updates and repaint it again::

    Redraw from position (0, 0) to position (50, 50):

    // what was in area (0, 0, 50, 50)?

    // 1. intersection part of line (0, 0) to (100, 200)?
      draw line from position (0, 0) to position (25, 50);

    // 2. intersection part of rectangle (10, 30) to (50, 500)?
      draw rectangle from position (10, 30) to position (50, 50)

    // 3. intersection part of image at (10, 30), size 100 x 100?
      bitmap_subimage = subregion from position (0, 0) to position (40, 20)
      draw image bitmap_subimage at position (10, 30);

The clever reader might have noticed that, if all elements in the
above scene are opaque, then the system is doing useless paints: part
of the line is behind the rectangle, and part of the rectangle is
behind the image. These useless paints tend to be very costly, as
pixels tend to be 4 bytes in size, thus an overlapping region of 100 x
100 pixels is around 40000 useless writes! The developer could write
code to calculate the overlapping areas and avoid painting then, but
then it should be mixed with the "expose event" handling mentioned
above and quickly one realizes the initially simpler method became
really complex.

Evas is a structural system in which the programmer creates and
manages display objects and their properties, and as a result of this
higher level state management, the canvas is able to redraw the set of
objects when needed to represent the current state of the canvas.

For example, the pseudo code::

    line_handle = create_line();
    set line_handle from position (0, 0) to position (100, 200);
    show line_handle;

    rectangle_handle = create_rectangle();
    move rectangle_handle to position (10, 30);
    resize rectangle_handle to size 40 x 470;
    show rectangle_handle;

    bitmap_handle = create_bitmap();
    scale bitmap_handle to size 100 x 100;
    move bitmap_handle to position (10, 30);
    show bitmap_handle;

    render scene;

This may look longer, but when the display needs to be refreshed or
updated, the programmer only moves, resizes, shows, hides etc. the
objects that need to change. The programmer simply thinks at the
object logic level, and the canvas software does the rest of the work
for them, figuring out what actually changed in the canvas since it
was last drawn, how to most efficiently redraw the canvas and its
contents to reflect the current state, and then it can go off and do
the actual drawing of the canvas.

This lets the programmer think in a more natural way when dealing with
a display, and saves time and effort of working out how to load and
display images, render given the current display system etc. Since
Evas also is portable across different display systems, this also
gives the programmer the ability to have their code ported and
displayed on different display systems with very little work.

Evas can be seen as a display system that stands somewhere between a
widget set and an immediate mode display system. It retains basic
display logic, but does very little high-level logic such as
scrollbars, sliders, push buttons etc.


Next Steps
----------

After you understood what Evas is and installed it in your system you
should proceed understanding the programming interface for all
objects, then see the specific for the most used elements. We'd
recommend you to take a while to learn
:doc:`Elementary </elementary/elementary>` and :doc:`Edje </edje/edje>` as
they will likely save you tons of work compared to using just Evas directly.

Recommended reading:

- :class:`efl.evas.Canvas`, where you'll get how to handle an Evas canvas,
- :class:`efl.evas.Object`, where you'll get how to basically manipulate generic
  objects lying on an Evas canvas, handle canvas and object events, etc.
- :class:`efl.evas.Rectangle`, to learn about the most basic object type on Evas --
  the rectangle.
- :class:`efl.evas.Polygon`, to learn how to create polygon elements on the canvas.
- :class:`efl.evas.Line`, to learn how to create line elements on the canvas.
- :class:`efl.evas.Image`, to learn about image objects, over which Evas can do a
  plethora of operations.
- :class:`efl.evas.Text`, to learn how to create textual elements on the canvas.
- :class:`efl.evas.Textblock`, to learn how to create multiline textual elements on
  the canvas.
- :class:`efl.evas.Box`, to learn how to pack objects in different layouts.
- :class:`efl.evas.SmartObject`, to define new objects that provide *custom*
  functions to handle clipping, hiding, moving, resizing, color
  setting and more. These could be as simple as a group of objects
  that move together (see :class:`efl.evas.ClippedSmartObject`) up to
  implementations of what ends to be a widget, providing some
  intelligence (thus the name) to Evas objects -- like a button or
  check box, for example.


Reference
---------

.. autofunction:: init
.. autofunction:: shutdown
.. autofunction:: render_method_lookup
.. autofunction:: render_method_list
.. autofunction:: color_parse
.. autofunction:: color_argb_premul
.. autofunction:: color_argb_unpremul
.. autofunction:: color_hsv_to_rgb
.. autofunction:: color_rgb_to_hsv

.. autoexception:: EvasLoadError

.. toctree::
   :maxdepth: 4

   class-rect
   class-canvas
   class-object
   class-object-rectangle
   class-object-image
   class-object-line
   class-object-polygon
   class-object-text
   class-object-textblock
   class-object-box
   class-object-smart
   class-grid
   class-table
   class-textgrid
   class-map

Inheritance diagram
-------------------

.. inheritance-diagram::
    efl.evas
    :parts: 2

