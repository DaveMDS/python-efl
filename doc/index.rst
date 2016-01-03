
Python Bindings for Enlightenment Foundation Libraries' documentation
#####################################################################

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
are numbers that can be argued over as to what constitutes an equivalent
measurement. EFL is low on actual memory usage at runtime with memory
footprints a fraction the size of those in the GTK+ and Qt worlds. In
addition EFL is fast. For what it does. Some libraries claim to be very
fast - but then they also don't "do much". It's easy to be fast when you
don't tackle the more complex rendering problems involving alpha blending,
interpolated scaling and transforms with dithering etc. EFL tackles these,
and more.

.. seealso::

   - `EFL Overview <http://trac.enlightenment.org/e/wiki/EFLOverview>`_
   - `EFL Documentation <http://web.enlightenment.org/p.php?p=docs>`_
   - `EDC Reference <https://build.enlightenment.org/job/nightly_efl_gcc_x86_64/lastSuccessful Buil d/artifact/doc/html/edcref.html>`_
   - `EFL Big Picture <http://docs.enlightenment.org/books/efl-big-picture/efl_big_picture.pdf>`_


EFL
===

.. toctree:: efl.rst


EO
==

.. toctree:: eo/eo.rst
   :titlesonly:


Ecore
=====

.. toctree:: ecore/ecore.rst
   :titlesonly:

Evas
====

.. toctree:: evas/evas.rst
   :titlesonly:


Ethumb
======

.. toctree:: ethumb/ethumb.rst
   :titlesonly:


Edje
====

.. toctree:: edje/edje.rst
   :titlesonly:


Emotion
=======

.. toctree:: emotion/emotion.rst
   :titlesonly:


Elementary
==========

.. toctree:: elementary/elementary.rst
   :maxdepth: 3


DBus integration
================

.. toctree:: dbus/dbus


Acknowledgements
================

:Copyright:
    Python Bindings for EFL are Copyright (C) 2008-2015 Simon Busch
    and various contributors (see AUTHORS).

:License:
    Python Bindings for EFL are licensed LGPL-3 (see COPYING).

:Authors:
    - `Gustavo Sverzut Barbieri <mailto:barbieri@gmail.com>`_
    - `Simon Busch <mailto:morphis@gravedo.de>`_
    - `Boris 'billiob' Faure <mailto:billiob@gmail.com>`_
    - `Davide 'davemds' Andreoli <mailto:dave@gurumeditation.it>`_
    - `Fabiano Fidêncio <mailto:fidencio@profusion.mobi>`_
    - `Bruno Dilly <mailto:bdilly@profusion.mobi>`_
    - `Tiago Falcão <mailto:tiago@profusion.mobi>`_
    - `Joost Albers <mailto:joost.albers@nomadrail.com>`_
    - `Kai Huuhko <mailto:kai.huuhko@gmail.com>`_
    - `Ulisses Furquim <ulissesf@gmail.com>`_

:Contact: `Enlightenment developer mailing list <mailto:enlightenment-devel@lists.sourceforge.net>`_


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

