
EFL is a collection of libraries that are independent or may build on top of
each-other to provide useful features that complement an OS's existing
environment, rather than wrap and abstract it, trying to be their own
environment and OS in its entirety. This means that it expects you to use
other system libraries and API's in conjunction with EFL libraries, to provide
a whole working application or library, simply using EFL as a set of
convenient pre-made libraries to accomplish a whole host of complex
or painful tasks for you.

One thing that has been important to EFL is efficiency. That is in both
speed and size. The core EFL libraries even with Elementary are about half
the size of the equivalent "small stack" of GTK+ that things like GNOME
use. It is in the realm of one quarter the size of Qt. Of course these
are numbers that can be argued over as to what constitutes and equivalent
measurement. EFL is low on actual memory usage at runtime with memory
footprints a fraction the size of those in the GTK+ and Qt worlds. In
addition EFL is fast. For what it does. Some libraries claim to be very
fast - but then they also don't "do much". It's easy to be fast when you
don't tackle the more complex rendering problems involving alpha blending,
interpolated scaling and transforms with dithering etc. EFL tackles these,
and more. 

:see also:
    - `EFL Overview <http://trac.enlightenment.org/e/wiki/EFLOverview>`_
    - `EFL Documentation <http://web.enlightenment.org/p.php?p=docs>`_


