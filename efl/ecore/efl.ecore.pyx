# Copyright (C) 2007-2015 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

:mod:`efl.ecore` Module
#######################


Classes
=======

.. toctree::

   class-timer.rst
   class-animator.rst
   class-animator_timeline.rst
   class-poller.rst
   class-idler.rst
   class-idleenterer.rst
   class-idleexiter.rst
   class-exe.rst
   class-filemonitor.rst
   class-filedownload.rst
   class-fdhandler.rst


Enumerations
============

.. _Ecore_Fd_Handler_Flags:

Fd handler flags
----------------

What to monitor the file descriptor for: reading, writing or error.

.. data:: ECORE_FD_READ

    Fd Read mask

.. data:: ECORE_FD_WRITE

    Fd Write mask

.. data:: ECORE_FD_ERROR

    Fd Error mask


.. _Ecore_Exe_Flags:

Exe flags
---------

Flags for executing a child with its stdin and/or stdout piped back.

.. data:: ECORE_EXE_NONE

    No exe flags at all

.. data:: ECORE_EXE_PIPE_READ

    Exe Pipe Read mask

.. data:: ECORE_EXE_PIPE_WRITE

    Exe Pipe Write mask

.. data:: ECORE_EXE_PIPE_ERROR

    Exe Pipe error mask

.. data:: ECORE_EXE_PIPE_READ_LINE_BUFFERED

    Reads are buffered until a newline and split 1 line per Ecore_Exe_Event_Data_Line

.. data:: ECORE_EXE_PIPE_ERROR_LINE_BUFFERED

    Errors are buffered until a newline and split 1 line per Ecore_Exe_Event_Data_Line

.. data:: ECORE_EXE_PIPE_AUTO

    stdout and stderr are buffered automatically

.. data:: ECORE_EXE_RESPAWN

    FIXME: Exe is restarted if it dies

.. data:: ECORE_EXE_USE_SH

    Use /bin/sh to run the command

.. data:: ECORE_EXE_NOT_LEADER

    Do not use setsid() to have the executed process be its own session leader

.. data:: ECORE_EXE_TERM_WITH_PARENT

    Makes child receive SIGTERM when parent dies


Callback return values
----------------------

.. data:: ECORE_CALLBACK_CANCEL

    Return value to remove a callback, it will not be called again

.. data:: ECORE_CALLBACK_RENEW

    Return value to keep a callback


Event return values
-------------------

.. data:: ECORE_CALLBACK_PASS_ON

    Return value to pass event to next handler

.. data:: ECORE_CALLBACK_DONE

    Return value to stop event handling


.. _Ecore_Pos_Map:

Position mappings for the animation
-----------------------------------

.. data:: ECORE_POS_MAP_LINEAR

    Linear 0.0 -> 1.0

.. data:: ECORE_POS_MAP_ACCELERATE

    Start slow then speed up

.. data:: ECORE_POS_MAP_DECELERATE

    Start fast then slow down

.. data:: ECORE_POS_MAP_SINUSOIDAL

    Start slow, speed up then slow down at end

.. data:: ECORE_POS_MAP_ACCELERATE_FACTOR

    Start slow then speed up, v1 being a power factor, 0.0 being linear, 1.0 being normal accelerate, 2.0 being much more pronounced accelerate (squared), 3.0 being cubed, etc.

.. data:: ECORE_POS_MAP_DECELERATE_FACTOR

    Start fast then slow down, v1 being a power factor, 0.0 being linear, 1.0 being normal decelerate, 2.0 being much more pronounced decelerate (squared), 3.0 being cubed, etc.

.. data:: ECORE_POS_MAP_SINUSOIDAL_FACTOR

    Start slow, speed up then slow down at end, v1 being a power factor, 0.0 being linear, 1.0 being normal sinusoidal, 2.0 being much more pronounced sinusoidal (squared), 3.0 being cubed, etc.

.. data:: ECORE_POS_MAP_DIVISOR_INTERP

    Start at gradient * v1, interpolated via power of v2 curve

.. data:: ECORE_POS_MAP_BOUNCE

    Start at 0.0 then "drop" like a ball bouncing to the ground at 1.0, and bounce v2 times, with decay factor of v1

.. data:: ECORE_POS_MAP_SPRING

    Start at 0.0 then "wobble" like a spring rest position 1.0, and wobble v2 times, with decay factor of v1

.. data:: ECORE_POS_MAP_CUBIC_BEZIER

    TODO: Follow the cubic-bezier curve calculated with the control points (x1, y1), (x2, y2)


.. _Ecore_Animator_Source:

Timing sources for animators
----------------------------

.. data:: ECORE_ANIMATOR_SOURCE_TIMER

    The default system clock/timer based animator that ticks every "frametime" seconds

.. data:: ECORE_ANIMATOR_SOURCE_CUSTOM

    A custom animator trigger that you need to call ecore_animator_trigger() to make it tick


.. Ecore_File_Event:

File monitor events
-------------------

.. data:: ECORE_FILE_EVENT_NONE

    No event

.. data:: ECORE_FILE_EVENT_CREATED_FILE

    A file has been created

.. data:: ECORE_FILE_EVENT_CREATED_DIRECTORY

    A directory has been created

.. data:: ECORE_FILE_EVENT_DELETED_FILE

    A file has been deleted

.. data:: ECORE_FILE_EVENT_DELETED_DIRECTORY

    A directory has been deleted

.. data:: ECORE_FILE_EVENT_DELETED_SELF

    The monitored path itself has been deleted

.. data:: ECORE_FILE_EVENT_MODIFIED

    A file has changed

.. data:: ECORE_FILE_EVENT_CLOSED

    A file has been closed


Classes
=======

"""

from libc.stdint cimport uintptr_t
from efl.eo cimport Eo, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from cpython cimport Py_INCREF, Py_DECREF

import traceback
import atexit


cdef Eina_Bool _ecore_task_cb(void *data) with gil:
    cdef Eo obj = <Eo>data
    cdef Eina_Bool ret

    try:
        ret = obj._task_exec()
    except Exception:
        traceback.print_exc()
        ret = 0

    if not ret:
        obj.delete()

    return ret


cdef int _ecore_events_registered = 0


def init():
    global _ecore_events_registered

    r = ecore_init()

    if r > 0 and _ecore_events_registered == 0:
        _ecore_events_registered = 1

        global _event_type_mapping
        _event_type_mapping = {
            ECORE_EVENT_SIGNAL_USER: EventSignalUser,
            ECORE_EVENT_SIGNAL_HUP: EventSignalHup,
            ECORE_EVENT_SIGNAL_EXIT: EventSignalExit,
            ECORE_EVENT_SIGNAL_POWER: EventSignalPower,
            ECORE_EVENT_SIGNAL_REALTIME: EventSignalRealtime,
            ECORE_EXE_EVENT_ADD: EventExeAdd,
            ECORE_EXE_EVENT_DEL: EventExeDel,
            ECORE_EXE_EVENT_DATA: EventExeData,
            ECORE_EXE_EVENT_ERROR: EventExeData,
        }

    ecore_file_init()
    return r


def shutdown():
    ecore_file_shutdown()
    return ecore_shutdown()


def main_loop_quit():
    ecore_main_loop_quit()


def main_loop_begin():
    with nogil:
        ecore_main_loop_begin()


def main_loop_iterate():
    with nogil:
        ecore_main_loop_iterate()


def main_loop_glib_integrate():
    if not ecore_main_loop_glib_integrate():
        raise SystemError("failed to integrate GLib main loop into ecore.")

def main_loop_glib_always_integrate_disable():
    ecore_main_loop_glib_always_integrate_disable()

def time_get():
    return ecore_time_get()


def loop_time_get():
    return ecore_loop_time_get()


include "efl.ecore_animator.pxi"
include "efl.ecore_timer.pxi"
include "efl.ecore_poller.pxi"
include "efl.ecore_idler.pxi"
include "efl.ecore_fd_handler.pxi"
include "efl.ecore_events.pxi"
include "efl.ecore_exe.pxi"
include "efl.ecore_file_download.pxi"
include "efl.ecore_file_monitor.pxi"

init()
atexit.register(shutdown)


#---------------------------------------------------------------------------
# let's try to warn users that ecore conflicts with subprocess module
import subprocess

_orig_subprocess = None

def subprocess_warning(*a, **ka):
    print("""    DEVELOPER WARNING:
        Using subprocess (Popen and derivatives) with Ecore is a bad idea.

        Ecore will set some signal handlers subprocess module depends and this
        may cause this module to operate unexpectedly.

        Instead of using subprocess.Popen(), please consider using Ecore's
        Exe() class.
        """)
    return _orig_subprocess(*a, **ka)

if subprocess.Popen is not subprocess_warning:
    _orig_subprocess = subprocess.Popen
    subprocess.Popen = subprocess_warning


#---------------------------------------------------------------------------
# also try to warn that ecore conflicts with signal module
import signal

_orig_signal = None

def signal_warning(sig, action):
    if sig in (signal.SIGPIPE, signal.SIGALRM, signal.SIGCHLD, signal.SIGUSR1,
               signal.SIGUSR2, signal.SIGHUP,  signal.SIGQUIT, signal.SIGINT,
               signal.SIGTERM, signal.SIGPWR):
        print("""    DEVELOPER WARNING:
        Ecore already defines signal handlers for:

        SIGPIPE, SIGALRM, SIGCHLD, SIGUSR1, SIGUSR2
        SIGHUP, SIGQUIT, SIGINT, SIGTERM, SIGPWR, SIGRT*

        Since you're defining a new signal handler, you might collide with
        Ecore and bad things may happen!
        """)
    return _orig_signal(sig, action)

if signal.signal is not signal_warning:
    _orig_signal = signal.signal
    signal.signal = signal_warning
