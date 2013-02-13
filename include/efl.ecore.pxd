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

from efl cimport *
from efl.c_eo cimport Eo as cEo
from efl.eo cimport Eo



cdef extern from "Ecore.h":
    ####################################################################
    # Basic Types
    #
    ctypedef cEo Ecore_Timer
    ctypedef cEo Ecore_Animator
    ctypedef cEo Ecore_Idler
    ctypedef cEo Ecore_Idle_Enterer
    ctypedef cEo Ecore_Idle_Exiter

    ctypedef struct Ecore_Event_Handler
    ctypedef struct Ecore_Event

    ctypedef struct Ecore_Event_Signal_User:
        int number

    ctypedef struct Ecore_Event_Signal_Exit:
        unsigned int interrupt
        unsigned int quit
        unsigned int terminate

    ctypedef struct Ecore_Event_Signal_Realtime:
        int num

    ctypedef struct Ecore_Exe_Event_Add:
        Ecore_Exe *exe
        void      *ext_data

    ctypedef struct Ecore_Exe_Event_Del:
        int          pid
        int          exit_code
        Ecore_Exe   *exe
        int          exit_signal
        unsigned int exited
        unsigned int signalled
        void        *ext_data

    ctypedef struct Ecore_Exe_Event_Data:
        Ecore_Exe                 *exe
        void                      *data
        int                        size
        Ecore_Exe_Event_Data_Line *lines

    ctypedef struct Ecore_Exe_Event_Data_Line:
        char *line
        int   size
    
    ctypedef struct Ecore_Fd_Handler
    ctypedef struct Ecore_Exe
    ctypedef Ecore_Exe const_Ecore_Exe "const Ecore_Exe"

    int ECORE_EVENT_SIGNAL_USER
    int ECORE_EVENT_SIGNAL_HUP
    int ECORE_EVENT_SIGNAL_EXIT
    int ECORE_EVENT_SIGNAL_POWER
    int ECORE_EVENT_SIGNAL_REALTIME

    int ECORE_EXE_EVENT_ADD
    int ECORE_EXE_EVENT_DEL
    int ECORE_EXE_EVENT_DATA
    int ECORE_EXE_EVENT_ERROR


    ####################################################################
    # Enumerations
    #
    ctypedef enum Ecore_Fd_Handler_Flags:
        pass

    ctypedef enum Ecore_Exe_Flags:
        pass

    ####################################################################
    # Other typedefs
    #
    ctypedef void (*Ecore_Cb)(void *data)
    ctypedef Eina_Bool (*Ecore_Task_Cb)(void *data)
    ctypedef Eina_Bool (*Ecore_Fd_Cb)(void *data, Ecore_Fd_Handler *fd_handler)
    ctypedef void (*Ecore_Fd_Prep_Cb)(void *data, Ecore_Fd_Handler *fd_handler)
    ctypedef Eina_Bool (*Ecore_Event_Handler_Cb)(void *data, int type, void *event)
    ctypedef void (*Ecore_End_Cb)(void *user_data, void *func_data)
    ctypedef void (*Ecore_Exe_Cb)(void *data, const_Ecore_Exe *exe)

    ####################################################################
    # Functions
    #
    int ecore_init()
    int ecore_shutdown()

    void ecore_main_loop_iterate() nogil
    void ecore_main_loop_begin() nogil
    void ecore_main_loop_quit()

    int ecore_main_loop_glib_integrate()

    double ecore_time_get()
    double ecore_loop_time_get()

    Ecore_Animator *ecore_animator_add(Ecore_Task_Cb func, void *data)
    void           *ecore_animator_del(Ecore_Animator *animator)
    void            ecore_animator_frametime_set(double frametime)
    double          ecore_animator_frametime_get()

    Ecore_Timer *ecore_timer_add(double t, Ecore_Task_Cb func, void *data)
    void        *ecore_timer_del(Ecore_Timer *timer)
    void         ecore_timer_freeze(Ecore_Timer *timer)
    void         ecore_timer_thaw(Ecore_Timer *timer)
    void         ecore_timer_interval_set(Ecore_Timer *timer, double t)
    double       ecore_timer_interval_get(Ecore_Timer *timer)
    void         ecore_timer_delay(Ecore_Timer *timer, double add)
    void         ecore_timer_reset(Ecore_Timer *timer)
    double       ecore_timer_pending_get(Ecore_Timer *timer)
    double       ecore_timer_precision_get()
    double       ecore_timer_precision_set(double value)

    Ecore_Idler *ecore_idler_add(Ecore_Task_Cb func, void *data)
    void        *ecore_idler_del(Ecore_Idler *idler)
    Ecore_Idler *ecore_idle_enterer_add(Ecore_Task_Cb func, void *data)
    void        *ecore_idle_enterer_del(Ecore_Idler *idler)
    Ecore_Idler *ecore_idle_exiter_add(Ecore_Task_Cb func, void *data)
    void        *ecore_idle_exiter_del(Ecore_Idler *idler)

    Ecore_Fd_Handler *ecore_main_fd_handler_add(int fd, Ecore_Fd_Handler_Flags flags, Ecore_Fd_Cb func, void *data, Ecore_Fd_Cb buf_func, void *buf_data)
    void              ecore_main_fd_handler_prepare_callback_set(Ecore_Fd_Handler *fd_handler, Ecore_Fd_Prep_Cb func, void *data)
    void             *ecore_main_fd_handler_del(Ecore_Fd_Handler *fd_handler)
    int               ecore_main_fd_handler_fd_get(Ecore_Fd_Handler *fd_handler)
    int               ecore_main_fd_handler_active_get(Ecore_Fd_Handler *fd_handler, Ecore_Fd_Handler_Flags flags)
    void              ecore_main_fd_handler_active_set(Ecore_Fd_Handler *fd_handler, Ecore_Fd_Handler_Flags flags)

    Ecore_Event_Handler *ecore_event_handler_add(int type, Ecore_Event_Handler_Cb func, void *data)
    void                *ecore_event_handler_del(Ecore_Event_Handler *event_handler)
    int                  ecore_event_type_new()
    Ecore_Event         *ecore_event_add(int type, void *ev, Ecore_End_Cb func_free, void *data)
    void                *ecore_event_del(Ecore_Event *ev)

    void                  ecore_exe_run_priority_set(int pri)
    int                   ecore_exe_run_priority_get()
    Ecore_Exe            *ecore_exe_pipe_run(char *exe_cmd, Ecore_Exe_Flags flags, void *data)
    void                  ecore_exe_callback_pre_free_set(Ecore_Exe *exe, Ecore_Exe_Cb func)
    int                   ecore_exe_send(Ecore_Exe *exe, const_void *data, int size)
    void                  ecore_exe_close_stdin(Ecore_Exe *exe)
    void                  ecore_exe_auto_limits_set(Ecore_Exe *exe, int start_bytes, int end_bytes, int start_lines, int end_lines)
    Ecore_Exe_Event_Data *ecore_exe_event_data_get(Ecore_Exe *exe, Ecore_Exe_Flags flags)
    void                  ecore_exe_event_data_free(Ecore_Exe_Event_Data *data)
    void                 *ecore_exe_free(Ecore_Exe *exe)
    int                   ecore_exe_pid_get(Ecore_Exe *exe)
    void                  ecore_exe_tag_set(Ecore_Exe *exe, char *tag)
    const_char_ptr        ecore_exe_tag_get(Ecore_Exe *exe)
    const_char_ptr        ecore_exe_cmd_get(Ecore_Exe *exe)
    void                 *ecore_exe_data_get(Ecore_Exe *exe)
    Ecore_Exe_Flags       ecore_exe_flags_get(Ecore_Exe *exe)
    void                  ecore_exe_pause(Ecore_Exe *exe)
    void                  ecore_exe_continue(Ecore_Exe *exe)
    void                  ecore_exe_interrupt(Ecore_Exe *exe)
    void                  ecore_exe_quit(Ecore_Exe *exe)
    void                  ecore_exe_terminate(Ecore_Exe *exe)
    void                  ecore_exe_kill(Ecore_Exe *exe)
    void                  ecore_exe_signal(Ecore_Exe *exe, int num)
    void                  ecore_exe_hup(Ecore_Exe *exe)


cdef extern from "Ecore_File.h":

    ctypedef struct Ecore_File_Download_Job

    ctypedef void (*Ecore_File_Download_Completion_Cb)(void *data, const_char_ptr file, int status)
    ctypedef int  (*Ecore_File_Download_Progress_Cb)(void *data, const_char_ptr file, long int dltotal, long int dlnow, long int ultotal, long int ulnow)

    int       ecore_file_init()
    int       ecore_file_shutdown()
    void      ecore_file_download_abort(Ecore_File_Download_Job *job)
    void      ecore_file_download_abort_all()
    Eina_Bool ecore_file_download_protocol_available(const_char_ptr protocol)
    Eina_Bool ecore_file_download(const_char_ptr url, const_char_ptr dst,
                                  Ecore_File_Download_Completion_Cb completion_cb,
                                  Ecore_File_Download_Progress_Cb progress_cb,
                                  void *data,
                                  Ecore_File_Download_Job **job_ret)


####################################################################
# Python classes
#
cdef class Timer(Eo):
    cdef double _interval
    cdef readonly object func, args, kargs
    cpdef object _task_exec(self)


cdef class Animator(Eo):
    cdef readonly object func, args, kargs
    cpdef object _task_exec(self)


cdef class Idler(Eo):
    cdef readonly object func, args, kargs
    cpdef object _task_exec(self)


cdef class IdleEnterer(Idler):
    pass


cdef class IdleExiter(Idler):
    pass


cdef class FdHandler(object):
    cdef Ecore_Fd_Handler *obj
    cdef readonly object func
    cdef readonly object args
    cdef readonly object kargs
    cdef readonly object _prepare_callback

    cdef object _exec(self)


cdef class Exe(object):
    cdef Ecore_Exe *exe
    cdef readonly object __data
    cdef object __callbacks

    cdef int _set_obj(self, char *exe_cmd, int flags) except 0
    cdef int _unset_obj(self) except 0


cdef class ExeEventFilter(object):
    cdef Ecore_Exe *exe
    cdef Ecore_Event_Handler *handler
    cdef readonly object owner
    cdef readonly object event_type
    cdef object callbacks


cdef class EventHandler(object):
    cdef Ecore_Event_Handler *obj
    cdef readonly int type
    cdef readonly object event_cls
    cdef readonly object func
    cdef readonly object args
    cdef readonly object kargs

    cdef int _set_obj(self, Ecore_Event_Handler *obj) except 0
    cdef int _unset_obj(self) except 0
    cdef Eina_Bool _exec(self, void *event) except 2


cdef class Event(object):
    cdef int _set_obj(self, void *obj) except 0


cdef class EventSignalUser(Event):
    cdef readonly object number


cdef class EventSignalHup(Event):
    pass


cdef class EventSignalExit(Event):
    cdef readonly object interrupt
    cdef readonly object quit
    cdef readonly object terminate


cdef class EventSignalPower(Event):
    pass


cdef class CustomEvent(Event):
    cdef readonly object obj


cdef class QueuedEvent:
    cdef Ecore_Event *obj
    cdef readonly object args

    cdef int _set_obj(self, Ecore_Event *ev) except 0
    cdef int _unset_obj(self) except 0


cdef class EventExeAdd(Event):
    cdef readonly object exe


cdef class EventExeDel(Event):
    cdef readonly object exe
    cdef readonly object pid
    cdef readonly object exit_code
    cdef readonly object exit_signal
    cdef readonly object exited
    cdef readonly object signalled


cdef class EventExeData(Event):
    cdef readonly object exe
    cdef readonly object data
    cdef readonly object size
    cdef readonly object lines


cdef class FileDownload:
    cdef Ecore_File_Download_Job *job
    cdef readonly object completion_cb
    cdef readonly object progress_cb
    cdef readonly object args
    cdef readonly object kargs

    cdef object _exec_completion(self, const_char_ptr file, int status)
    cdef object _exec_progress(self, const_char_ptr file,
                               long int dltotal, long int dlnow,
                               long int ultotal, long int ulnow)

