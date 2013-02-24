:mod:`efl.ecore` Module
=======================


What is Ecore?
--------------

Ecore is a clean and tiny event loop library with many modules to do lots of
convenient things for a programmer, to save time and effort. It's small and
lean, designed to work from embedded systems all the way up to large and
powerful multi-cpu workstations. The main loop has a number of primitives to
be used with its main loop. It serializes all the primitives and allows for
great responsiveness without the need for threads(or any other concurrency).


Timers
------

:py:class:`Timers<efl.ecore.Timer>` serve two main purposes: doing something at a specified time and
repeatedly doing something with a set interval.


Animators
---------

Ecore provides a facility called animators, so named since the intended use
was in animations, that facilitates knowing what percentage of a given
interval has elapsed. This is perfect for performing animations, but is not
limited to that use, it can, for example, also be used to create a progress
bar. see :py:class:`Animator<efl.ecore.Animator>`


Idlers
------

There are three types of idlers, :py:class:`IdleEnterer<efl.ecore.IdleEnterer>`,
:py:class:`Idler<efl.ecore.Idler>` (proper) and
:py:class:`IdleExiter<efl.ecore.IdleExiter>`, they
are called, respectively, when the program is about to enter an idle state,
when the program is idle and when the program is leaving an idle state. Idler
enterers are usually a good place to update the program state. Proper idlers
are the appropriate place to do heavy computational tasks thereby using what
would otherwise be wasted CPU cycles. Exiters are the perfect place to do
anything your program should do just before processing events (also timers,
pollers, file descriptor handlers and animators)


File descriptor handlers
------------------------

File descriptor handlers allow you to monitor when there is data available to
read on file descriptors, when writing will not block or if there was an
error. Any valid file descriptor can be used with this API, regardless of if
was gotten with an OS specific API or from ecore.
see :py:class:`FdHandler<efl.ecore.FdHandler>`


Reference
---------

.. toctree::
   :maxdepth: 4

   class-timer
   class-animator
   class-idler
   class-idleenterer
   class-idleexiter
   class-exe
   class-fdhandler
   class-filedownload


Inheritance diagram
-------------------

.. inheritance-diagram::
    efl.ecore
    :parts: 2

