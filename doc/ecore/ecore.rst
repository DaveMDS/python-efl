
.. _ecore_main_intro:

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

:py:class:`Timers<efl.ecore.Timer>` serve two main purposes: doing something at
a specified time and repeatedly doing something with a set interval.


Animators
---------

Ecore provides a facility called animators, so named since the intended use
was in animations, that facilitates knowing what percentage of a given
interval has elapsed. This is perfect for performing animations, but is not
limited to that use, it can, for example, also be used to create a progress
bar. see :py:class:`Animator<efl.ecore.Animator>`


Pollers
-------

Ecore :py:class:`Poller<efl.ecore.Poller>` provides infrastructure for the
creation of pollers. Pollers are, in essence, callbacks that share a single
timer per type. Because not all pollers need to be called at the same frequency
the user may specify the frequency in ticks(each expiration of the shared
timer is called a tick, in ecore poller parlance) for each added poller.
Ecore pollers should only be used when the poller doesn't have specific
requirements on the exact times to poll.


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


Process Execution
-----------------

The :py:class:`~efl.ecore.Exe` class is used to spawn child processes in a
full async fashion. Standard in/out/error of the child are available for
communication using callbacks.


File descriptor handlers
------------------------

File descriptor handlers allow you to monitor when there is data available to
read on file descriptors, when writing will not block or if there was an
error. Any valid file descriptor can be used with this API, regardless of if
was gotten with an OS specific API or from ecore.
see :py:class:`FdHandler<efl.ecore.FdHandler>`


File monitor
------------

Using the :py:class:`FileMonitor<efl.ecore.FileMonitor>` class you can monitor
a directory for changes, a single calback will be called when events occur.
Events will be generatd everytime a file or directory (that live in the
give path) is created/deleted/modified.


File download
-------------

Ecore provide the :py:class:`FileDownload<efl.ecore.FileDownload>` class
to perform asyncronous download of files from the net. Two callbacks are
used to inform the user while progress occurs and when the download has
finished.


Ecore Con
---------

The ecore_con module provide various utilities to perform different network
related tasks. Everything provided in a fully async way. Most notable are the
:class:`efl.ecore_con.Lookup` class to perform DNS requests, the
:class:`efl.ecore_con.Url` class to perform HTTP requests and the
:class:`efl.ecore_con.Server` class to implement your own server.



API Reference
-------------

.. toctree::
   :titlesonly:

   module-ecore
   module-ecore_input
   module-ecore_con


Inheritance diagram
-------------------

.. inheritance-diagram::
    efl.ecore
    :parts: 2
