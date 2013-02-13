# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

import traceback
from efl.eo cimport Eo
from efl.eo cimport _fruni, _cfruni
from efl.eo cimport PY_REFCOUNT
from cpython cimport Py_INCREF, Py_DECREF


ECORE_CALLBACK_CANCEL = 0
ECORE_CALLBACK_RENEW = 1

# Ecore_Fd_Handler_Flags:
ECORE_FD_READ = 1
ECORE_FD_WRITE = 2
ECORE_FD_ERROR = 4
ECORE_FD_ALL = 7


# Ecore_Exe_Flags:
ECORE_EXE_PIPE_READ = 1
ECORE_EXE_PIPE_WRITE = 2
ECORE_EXE_PIPE_ERROR = 4
ECORE_EXE_PIPE_READ_LINE_BUFFERED = 8
ECORE_EXE_PIPE_ERROR_LINE_BUFFERED = 16
ECORE_EXE_PIPE_AUTO = 32
ECORE_EXE_RESPAWN = 64
ECORE_EXE_USE_SH = 128
ECORE_EXE_NOT_LEADER = 256
ECORE_EXE_TERM_WITH_PARENT = 512

ECORE_EXE_PRIORITY_INHERIT = 9999


# Ecore_File_Progress_Return:
ECORE_FILE_PROGRESS_CONTINUE = 0
ECORE_FILE_PROGRESS_ABORT = 1


cdef Eina_Bool _ecore_task_cb(void *data) with gil:
    cdef Eo obj = <Eo>data
    cdef Eina_Bool ret

    try:
        ret = bool(obj._task_exec())
    except Exception, e:
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


def time_get():
    return ecore_time_get()


def loop_time_get():
    return ecore_loop_time_get()


include "efl.ecore_animator.pxi"
include "efl.ecore_timer.pxi"
include "efl.ecore_idler.pxi"
include "efl.ecore_fd_handler.pxi"
include "efl.ecore_events.pxi"
include "efl.ecore_exe.pxi"
include "efl.ecore_file_download.pxi"

init()
