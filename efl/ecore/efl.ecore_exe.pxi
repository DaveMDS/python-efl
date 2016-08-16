# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

from cpython cimport PyUnicode_AsUTF8String

cdef extern from "Python.h":
    object PyUnicode_FromStringAndSize(char *s, Py_ssize_t len)
    int PyObject_GetBuffer(obj, Py_buffer *view, int flags)
    void PyBuffer_Release(Py_buffer *view)


cdef exe_flags2str(int value):
    flags = []
    if value & enums.ECORE_EXE_PIPE_READ:
        flags.append("PIPE_READ")
    if value & enums.ECORE_EXE_PIPE_WRITE:
        flags.append("PIPE_WRITE")
    if value & enums.ECORE_EXE_PIPE_ERROR:
        flags.append("PIPE_ERROR")
    if value & enums.ECORE_EXE_PIPE_READ_LINE_BUFFERED:
        flags.append("PIPE_READ_LINE_BUFFERED")
    if value & enums.ECORE_EXE_PIPE_ERROR_LINE_BUFFERED:
        flags.append("PIPE_ERROR_LINE_BUFFERED")
    if value & enums.ECORE_EXE_PIPE_AUTO:
        flags.append("PIPE_AUTO")
    if value & enums.ECORE_EXE_RESPAWN:
        flags.append("RESPAWN")
    if value & enums.ECORE_EXE_USE_SH:
        flags.append("USE_SH")
    if value & enums.ECORE_EXE_NOT_LEADER:
        flags.append("NOT_LEADER")
    if value & enums.ECORE_EXE_TERM_WITH_PARENT:
        flags.append("ECORE_EXE_TERM_WITH_PARENT")
    return ", ".join(flags)


cdef Eina_Bool _exe_event_filter_cb(void *data, int type, void *event) with gil:
    cdef:
        ExeEventFilter self = <ExeEventFilter>data
        Ecore_Exe_Event_Add *e_add
        Ecore_Exe_Event_Del *e_del
        Ecore_Exe_Event_Data *e_data
        Event e
        list cbs
        tuple cb

    try:
        assert self.event_type == type, "event is not what we asked? impossible"
        if type == enums.ECORE_EXE_EVENT_ADD:
            e_add = <Ecore_Exe_Event_Add *>event
            if e_add.exe != self.exe:
                return 1
            e = EventExeAdd()
        elif type == enums.ECORE_EXE_EVENT_DEL:
            e_del = <Ecore_Exe_Event_Del *>event
            if e_del.exe != self.exe:
                return 1
            e = EventExeDel()
        elif type == enums.ECORE_EXE_EVENT_DATA or type == enums.ECORE_EXE_EVENT_ERROR:
            e_data = <Ecore_Exe_Event_Data *>event
            if e_data.exe != self.exe:
                return 1
            e = EventExeData()
        else:
            raise SystemError("unknown event type=%d" % type)

        r = e._set_obj(event)
        assert r != -1, "exe is not known?! impossible!"

        cbs = self.callbacks[:] # copy, so we can change self.callbacks
        for cb in cbs:
            try:
                cb[0](self.owner, e, *cb[1], **cb[2])
            except Exception:
                traceback.print_exc()

    except Exception:
        traceback.print_exc()

    return 1 # always return true, no matter what


cdef class ExeEventFilter:
    def __cinit__(self, *a, **ka):
        self.event_type = -1
        self.callbacks = []

    def __dealloc__(self):
        if self.handler != NULL:
            ecore_event_handler_del(self.handler)
            self.handler = NULL

        self.exe = NULL
        self.owner = None
        self.event_type = -1
        self.callbacks = None

    def __init__(self, Exe exe not None, int event_type):
        self.exe = exe.exe
        self.owner = exe
        self.event_type = event_type
        self.callbacks = []

    def delete(self):
        if self.handler != NULL:
            ecore_event_handler_del(self.handler)
            self.handler = NULL
        self.callbacks = None

    def callback_add(self, func, args, kargs):
        if self.handler == NULL:
            self.handler = ecore_event_handler_add(
                self.event_type, _exe_event_filter_cb, <void *>self)
        self.callbacks.append((func, args, kargs))

    def callback_del(self, func, args, kargs):
        try:
            self.callbacks.remove((func, args, kargs))
        except ValueError:
            raise ValueError(
                "callback is not registered: %s, args=%s, kargs=%s" %
                (func, args, kargs))

        if self.callbacks:
            return

        if self.handler != NULL:
            ecore_event_handler_del(self.handler)
            self.handler = NULL


def exe_run_priority_set(int pri):
    ecore_exe_run_priority_set(pri)


def exe_run_priority_get():
    return ecore_exe_run_priority_get()


cdef object _ecore_exe_event_mapping
_ecore_exe_event_mapping = {}


cdef void _ecore_exe_pre_free_cb(void *data, const Ecore_Exe *exe) with gil:
    cdef Exe obj
    try:
        if data == NULL:
            raise ValueError("data parameter is NULL")
        else:
            obj = <Exe>data
            obj._unset_obj()
    except Exception:
        traceback.print_exc()


cdef class Exe(object):
    """

    Spawns a child process with its stdin/out available for communication.

    This function forks and runs the given command using ``/bin/sh``.

    Note that the process handle is only valid until a child process
    terminated event is received.  After all handlers for the child
    process terminated event have been called, the handle will be
    freed by Ecore. In this case the Python wrapper becomes "shallow"
    and all operations will fail or return bogus/dummy values,
    although it should not crash.

    This class behavior is configurable by means of given constructor
    *flags*, that will make Ecore monitor process' stdout and stderr,
    emitting events on main loop.

    To write use :py:meth:`send`.  To read listen to ``ECORE_EXE_EVENT_DATA``
    or ``ECORE_EXE_EVENT_ERROR`` events (see below). Ecore may
    buffer read and error data until a newline character if asked for
    with the *flags*.  All data will be included in the events
    (newlines will be replaced with NULLS if line is buffered).

    ``ECORE_EXE_EVENT_DATA`` events will only happen if the process is
    run with ``ECORE_EXE_PIPE_READ`` enabled in the *flags*.  The same
    with the error version.  Writing will only be allowed with
    ``ECORE_EXE_PIPE_WRITE`` enabled in the *flags*.

    .. rubric:: Instance Event Handling

    To make use easier, there are methods that automatically filter
    events for this instance and deletes them when the ``Exe`` is
    deleted:

    - on_add_event_add()
    - on_add_event_del()
    - on_del_event_add()
    - on_del_event_del()
    - on_data_event_add()
    - on_data_event_del()
    - on_error_event_add()
    - on_error_event_del()

    The callback signatures are::

        func(exe, event, *args, **kargs)

    In contrast with C-api conformant functions. This only receives
    the events from this exact exe instance. The signature is also
    very different, the first parameter is the ``Exe`` reference and
    the return value does **not** removes the event listener!

    Using this method is likely more efficient than the C-api since it
    will not convert from C to Python lots of times, possibly useless.

    However, there are C-api conformat functions as well.

    .. rubric:: Event Handling (C-api conformant)

    Getting data from executed processed is done by means of event
    handling, which is also used to notify whenever this process
    really started or died.

    One should listen to events in the main loop, such as:

    EventExeAdd
        listen with ``on_exe_add_event_add()`` to know when sub processes
        were started and ready to be used.

    EventExeDel
        listen with ``on_exe_del_event_add()`` to know when sub processes died.

    EventExeData
        listen with ``on_exe_data_event_add()`` to know when sub processes
        output data to their stdout.

    EventExeError
        listen with ``on_exe_error_event_add()`` to know when sub processes
        output data to their stderr.

    Events will have the following signature, as explained in
    ``EventHandler``::

       func(event, *args, **kargs): bool

    That mean once registered, your callback ``func`` will be called for all
    known ``Exe`` instances (that were created from Python!). You can query
    which instance created such event with ``event.exe`` property. Thus you
    often need to filter if the event you got is from the instance you need!
    (This is designed to match C-api).

    Once your function returns evaluates to *False* (note: not returning
    means returning *None*, that evaluates to *False*!), your callback
    will not be called anymore and your handler is deleted.

    One may delete handlers explicitly with ``EventHandler.delete()``
    method.


    :param exe_cmd: command to execute as subprocess.
    :type exe_cmd: str
    :param flags:
        if given (!= 0), should be bitwise OR of

        ECORE_EXE_PIPE_READ
            Exe Pipe Read mask

        ECORE_EXE_PIPE_WRITE
            Exe Pipe Write mask

        ECORE_EXE_PIPE_ERROR
            Exe Pipe error mask

        ECORE_EXE_PIPE_READ_LINE_BUFFERED
            Reads are buffered until a newline and delivered 1 event per line.

        ECORE_EXE_PIPE_ERROR_LINE_BUFFERED
            Errors are buffered until a newline and delivered 1 event per line.

        ECORE_EXE_PIPE_AUTO
            stdout and stderr are buffered automatically

        ECORE_EXE_RESPAWN
            Exe is restarted if it dies

        ECORE_EXE_USE_SH
            Use /bin/sh to run the command.

        ECORE_EXE_NOT_LEADER
            Do not use setsid() to have the executed process be its own
            session leader

        ECORE_EXE_TERM_WITH_PARENT
            Makes child receive SIGTERM when parent dies

    :type flags: int
    :param data: extra data to be associated and available with ``data_get()``

    """
    def __cinit__(self, *a, **ka):
        self.exe = NULL
        self.__data = None
        self.__callbacks = {}

    def __init__(self, exe_cmd, int flags=0, data=None):
        if not exe_cmd:
            raise ValueError("exe_cmd must not be empty!")

        if flags is None:
            flags = 0

        if isinstance(exe_cmd, unicode): exe_cmd = PyUnicode_AsUTF8String(exe_cmd)
        self._set_obj(exe_cmd, flags)
        self.__data = data
        self.__callbacks = {}

    cdef int _set_obj(self, char *exe_cmd, int flags) except 0:
        cdef Ecore_Exe *exe

        assert self.exe == NULL, "Exe must be clean, not wrapping any Ecore_Exe"

        exe = ecore_exe_pipe_run(exe_cmd, <Ecore_Exe_Flags>flags, <void *>self)
        if exe == NULL:
            raise SystemError("could not run subprocess %r, flags=%#x" %
                              (exe_cmd, flags))

        Py_INCREF(self)
        self.exe = exe
        ecore_exe_callback_pre_free_set(exe, _ecore_exe_pre_free_cb)
        _ecore_exe_event_mapping[<uintptr_t><void *>exe] = self
        return 1

    cdef int _unset_obj(self) except 0:
        assert self.exe != NULL, "Exe must wrap something"
        for t, filter in self.__callbacks.iteritems():
            filter.delete()
        self.__callbacks = None

        _ecore_exe_event_mapping.pop(<uintptr_t><void *>self.exe)
        self.exe = NULL
        Py_DECREF(self)
        return 1

    def __repr__(self):
        if self.exe == NULL:
            pid = None
            cmd = None
            flags = ""
            data = None
        else:
            pid = self.pid
            cmd = self.cmd
            flags = exe_flags2str(self.flags)
            data = None
        return ("<%s(%#x, Ecore_Exe=%#x, refcount=%d, pid=%s, cmd=%r, "
                "flags=[%s], data=%r)>") % \
                (self.__class__.__name__, <uintptr_t><void *>self,
                 <uintptr_t>self.exe, PY_REFCOUNT(self),
                 pid, cmd, flags, data)

    def is_deleted(self):
        """Check if the object has been deleted thus leaving the object shallow.

        :return: True if the object has been deleted yet, False otherwise.
        :rtype: bool

        .. versionadded:: 1.18

        """
        return bool(self.exe == NULL)

    def delete(self):
        """Forcefully frees the given process handle.

        Note that the process that the handle represents is unaffected
        by this function, this just stops monitoring the stdout/stderr
        and emitting related events.

        To finish the process call :py:meth:`terminate` or :py:meth:`kill`.
        """
        if self.exe == NULL:
            raise ValueError("%s already deleted" % self.__class__.__name__)
        ecore_exe_free(self.exe)

    def free(self):
        """Alias for :py:meth:`delete` to keep compatibility with C-api."""
        self.delete()

    def send(self, buf, long size=0):
        """Sends data to the executed process, which it receives on stdin.

        This function writes to a child processes standard in, with
        unlimited buffering. This call will never block. It may fail
        if the system runs out of memory.

        :param buffer: object that implements buffer interface, such
               as strings (str).
        :param size: if greater than zero, then this will limit the
               size of given buffer. If None, then the exact buffer
               size is used.

        :raise ValueError: if size is larger than buffer size.
        :return: success or failure.
        :rtype: bool
        """
        cdef:
            Py_buffer buf_view
            bint ret

        if isinstance(buf, unicode):
            buf = PyUnicode_AsUTF8String(buf)

        PyObject_GetBuffer(buf, &buf_view, 0)

        if size <= 0:
            size = buf_view.len
        elif size > buf_view.len:
            raise ValueError(
                "given size (%d) is larger than buffer size (%d)." %
                (size, buf_view.len))

        ret = ecore_exe_send(self.exe, <const void *>buf_view.buf, buf_view.len)
        PyBuffer_Release(&buf_view)
        return ret

    def close_stdin(self):
        """Close executed process' stdin.

        The stdin of the given child process will not be closed
        immediately. Instead it will be closed when the write buffer
        is empty.
        """
        ecore_exe_close_stdin(self.exe)

    def auto_limits_set(self, int start_bytes, int end_bytes,
                        int start_lines, int end_lines):
        """Sets the auto pipe limits for the given process handle

        :param start_bytes: limit of bytes at start of output to buffer.
        :param end_bytes: limit of bytes at end of output to buffer.
        :param start_lines: limit of lines at start of output to buffer.
        :param end_lines: limit of lines at end of output to buffer.

        """
        ecore_exe_auto_limits_set(self.exe, start_bytes, end_bytes,
                                  start_lines, end_lines)

    # TODO:
    #def event_data_get(self, int flags):
        #Ecore_Exe_Event_Data *ecore_exe_event_data_get(Ecore_Exe *exe, Ecore_Exe_Flags flags)
        #void ecore_exe_event_data_free(Ecore_Exe_Event_Data *data)

    def cmd_get(self):
        """Retrieves the command of the executed process.

        :return: the command line string if execution succeeded, None otherwise.
        :rtype: str or None

        """
        cdef const char *cmd = ecore_exe_cmd_get(self.exe)
        if cmd != NULL:
            return cmd
        return None

    property cmd:
        def __get__(self):
            return self.cmd_get()

    def pid_get(self):
        """Retrieves the process ID of the executed process.

        :rtype: int

        """
        return ecore_exe_pid_get(self.exe)

    property pid:
        def __get__(self):
            return self.pid_get()

    def tag_set(self, char *tag):
        """Sets the string tag for the given process.


        This is a string that is attached to this handle and may serve
        as further information.

        .. note:: not much useful in Python, but kept for compatibility
                  with C-api.

        """
        cdef char *s
        if tag is None:
            s = NULL
        else:
            s = tag
        ecore_exe_tag_set(self.exe, s)

    def tag_get(self):
        """Retrieves the tag attached to the given process.

        This is a string that is attached to this handle and may serve
        as further information.

        .. note:: not much useful in Python, but kept for compatibility
                  with C-api.

        :rtype: str or None

        """
        cdef const char *tag = ecore_exe_tag_get(self.exe)
        if tag != NULL:
            return tag
        return None

    property tag:
        def __set__(self, char *tag):
            self.tag_set(tag)

        def __get__(self):
            return self.tag_get()

    def data_get(self):
        return self.__data

    property data:
        def __get__(self):
            return self.data_get()

    def flags_get(self):
        """Retrieves the flags attached to the given process handle.

         - ECORE_EXE_PIPE_READ: Exe Pipe Read mask
         - ECORE_EXE_PIPE_WRITE: Exe Pipe Write mask
         - ECORE_EXE_PIPE_ERROR: Exe Pipe error mask
         - ECORE_EXE_PIPE_READ_LINE_BUFFERED: Reads are buffered until
           a newline and delivered 1 event per line.
         - ECORE_EXE_PIPE_ERROR_LINE_BUFFERED: Errors are buffered
           until a newline and delivered 1 event per line
         - ECORE_EXE_PIPE_AUTO: stdout and stderr are buffered automatically
         - ECORE_EXE_RESPAWN: Exe is restarted if it dies
         - ECORE_EXE_USE_SH: Use /bin/sh to run the command.
         - ECORE_EXE_NOT_LEADER Do not use setsid() to have the
           executed process be its own session leader

        :return: set of masks, ORed.

        """
        return ecore_exe_flags_get(self.exe)

    property flags:
        def __get__(self):
            return self.flags_get()

    def signal(self, int num):
        """Send SIGUSR1 or SIGUSR2 to executed process.

        :parm num: user signal number, either 1 or 2.

        :see: POSIX kill(2) and kill(1) man pages.
        :raise ValueError: if num is not 1 or 2.

        """
        if num != 1 or num != 2:
            raise ValueError("num must be either 1 or 2. Got %d." % num)
        ecore_exe_signal(self.exe, num)

    def pause(self):
        """Send pause signal (SIGSTOP) to executed process.

        In order to resume application execution, use :py:meth:`continue_`
        """
        ecore_exe_pause(self.exe)

    def stop(self):
        """Alias for ``pause``"""
        self.pause()

    def continue_(self):
        """Send continue signal (SIGCONT) to executed process.

        This resumes application previously paused with :py:meth:`pause`

        """
        ecore_exe_continue(self.exe)

    def resume(self):
        """Alias for ``continue_()``"""
        self.continue_()

    def interrupt(self):
        """Send interrupt signal (SIGINT) to executed process.

        .. note:: Python usually installs SIGINT handler to generate
                  *KeyboardInterrupt*, however Ecore will *override*
                  this handler with its own that generates
                  *ECORE_EVENT_SIGNAL_EXIT* in its main loop for the
                  application to handle. Pay attention to this detail if
                  your *child* process is also using Ecore.
        """
        ecore_exe_interrupt(self.exe)

    def quit(self):
        """Send quit signal (SIGQUIT) to executed process."""
        ecore_exe_quit(self.exe)

    def terminate(self):
        """Send terminate signal (SIGTERM) to executed process."""
        ecore_exe_terminate(self.exe)

    def kill(self):
        """Send kill signal (SIGKILL) to executed process.

        This signal is fatal and will exit the application as it
        cannot be blocked.

        """
        ecore_exe_kill(self.exe)

    def hup(self):
        """Send hup signal (SIGHUP) to executed process."""
        ecore_exe_hup(self.exe)

    def on_add_event_add(self, func, *args, **kargs):
        """Adds event listener to know when this Exe was actually started.

        The given function will be called with the following signature
        every time this Exe receives an ``ECORE_EXE_EVENT_ADD`` signal::

            func(exe, event, *args, **kargs)

        In contrast with on_exe_add_event_add(), this only receives
        the events from this exact exe instance. The signature is also
        very different, the first parameter is the ``Exe`` reference
        and the return value does **not** removes the event listener!

        :see: on_add_event_del()
        :see: on_exe_add_event_add()

        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_ADD)
        if filter is None:
            filter = ExeEventFilter(self, enums.ECORE_EXE_EVENT_ADD)
            self.__callbacks[enums.ECORE_EXE_EVENT_ADD] = filter
        filter.callback_add(func, args, kargs)

    def on_add_event_del(self, func, *args, **kargs):
        """Removes the event listener registered with ``on_add_event_add()``.

        Parameters must be exactly the same.

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_ADD)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_del_event_add(self, func, *args, **kargs):
        """Adds event listener to know when this Exe was actually started.

        The given function will be called with the following signature
        every time this Exe receives an ``ECORE_EXE_EVENT_DEL`` signal::

            func(exe, event, *args, **kargs)

        In contrast with ``on_exe_del_event_add()``, this only receives
        the events from this exact exe instance. The signature is also
        very different, the first parameter is the ``Exe`` reference
        and the return value does **not** removes the event listener!

        :see: on_del_event_del()
        :see: on_exe_del_event_add()
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_DEL)
        if filter is None:
            filter = ExeEventFilter(self, enums.ECORE_EXE_EVENT_DEL)
            self.__callbacks[enums.ECORE_EXE_EVENT_DEL] = filter
        filter.callback_add(func, args, kargs)

    def on_del_event_del(self, func, *args, **kargs):
        """Removes the event listener registered with :py:func`on_del_event_add`.

        Parameters must be exactly the same.

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_DEL)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_data_event_add(self, func, *args, **kargs):
        """Adds event listener to know when this Exe was actually started.

        The given function will be called with the following signature
        every time this Exe receives an ``ECORE_EXE_EVENT_DATA`` signal::

            func(exe, event, *args, **kargs)

        In contrast with ``on_exe_data_event_add()``, this only receives
        the events from this exact exe instance. The signature is also
        very different, the first parameter is the ``Exe`` reference
        and the return value does **not** removes the event listener!

        :see: on_data_event_del()
        :see: on_exe_data_event_add()
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_DATA)
        if filter is None:
            filter = ExeEventFilter(self, enums.ECORE_EXE_EVENT_DATA)
            self.__callbacks[enums.ECORE_EXE_EVENT_DATA] = filter
        filter.callback_add(func, args, kargs)

    def on_data_event_del(self, func, *args, **kargs):
        """Removes the event listener registered with :py:func:`on_data_event_add()`.

        Parameters must be exactly the same.

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_DATA)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_error_event_add(self, func, *args, **kargs):
        """Adds event listener to know when this Exe was actually started.

        The given function will be called with the following signature
        every time this Exe receives an ``ECORE_EXE_EVENT_ERROR`` signal::

            func(exe, event, *args, **kargs)

        In contrast with ``on_exe_error_event_add()``, this only receives
        the events from this exact exe instance. The signature is also
        very different, the first parameter is the ``Exe`` reference
        and the return value does **not** remove the event listener!

        :see: on_error_event_del()
        :see: on_exe_error_event_add()
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_ERROR)
        if filter is None:
            filter = ExeEventFilter(self, enums.ECORE_EXE_EVENT_ERROR)
            self.__callbacks[enums.ECORE_EXE_EVENT_ERROR] = filter
        filter.callback_add(func, args, kargs)

    def on_error_event_del(self, func, *args, **kargs):
        """Removes the event listener registered with :py:func:`on_error_event_add()`.

        Parameters must be exactly the same.

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        filter = self.__callbacks.get(enums.ECORE_EXE_EVENT_ERROR)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)


def exe_run(exe_cmd, data=None):
    """`efl.ecore.Exe` factory, for C-api compatibility."""
    return Exe(exe_cmd, data=data)


def exe_pipe_run(exe_cmd, int flags=0, data=None):
    """`efl.ecore.Exe` factory, for C-api compatibility."""
    return Exe(exe_cmd, flags, data)


cdef class EventExeAdd(Event):
    """Represents Ecore_Exe_Event_Add event from C-api.

    This event notifies that the process created with :py:class:`Exe` has been started.

    :ivar Exe exe: Instance of :py:class:`Exe` that created this event.
    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Add *obj
        obj = <Ecore_Exe_Event_Add*>o
        self.exe = _ecore_exe_event_mapping.get(<uintptr_t>obj.exe)
        if self.exe is None:
            return -1
        return 1

    def __repr__(self):
        return "<%s(exe=%r)>" % (self.__class__.__name__, self.exe)


cdef class EventExeDel(Event):
    """Represents Ecore_Exe_Event_Del from C-api.

    This event notifies that the process created with ``Exe`` is now dead.

    :ivar Exe exe: Instance of :py:class:`Exe` that created this event.
    :ivar int pid: Process ID
    :ivar int exit_code: Exit code
    :ivar int exit_signal: Exit signal
    :ivar bool exited: Has process exited
    :ivar bool signalled: Has process been signalled
    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Del *obj
        obj = <Ecore_Exe_Event_Del*>o
        self.exe = _ecore_exe_event_mapping.get(<uintptr_t>obj.exe)
        if self.exe is None:
            return -1
        self.pid = obj.pid
        self.exit_code = obj.exit_code
        self.exit_signal = obj.exit_signal
        self.exited = bool(obj.exited)
        self.signalled = bool(obj.signalled)
        return 1

    def __repr__(self):
        return ("<%s(pid=%s, exit_code=%s, exit_signal=%s, exited=%s, "
                "signalled=%s, exe=%r)>") % \
                (self.__class__.__name__, self.pid, self.exit_code,
                 self.exit_signal, self.exited, self.signalled, self.exe)


cdef class EventExeData(Event):
    """Represents Ecore_Exe_Event_Data from C-api.

    This event is issued by :py:class:`Exe` instances created with flags that
    allow reading from either stdout or stderr.

    :ivar Exe exe: Instance of :py:class:`Exe` that created this event.
    :ivar string ~EventExeData.data: The raw string buffer with binary data from child process.
    :ivar int ~EventExeData.size: The size of **data** (same as ``len(data)``)
    :ivar list lines: List of strings with all text lines
    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Data *obj
        cdef int i
        obj = <Ecore_Exe_Event_Data*>o
        self.exe = _ecore_exe_event_mapping.get(<uintptr_t>obj.exe)
        if self.exe is None:
            return -1
        self.data = PyUnicode_FromStringAndSize(<char*>obj.data, obj.size)
        self.size = obj.size
        self.lines = []

        line_append = self.lines.append
        if obj.lines:
            i = 0
            while obj.lines[i].line != NULL:
                line_append(PyUnicode_FromStringAndSize(
                        obj.lines[i].line, obj.lines[i].size))
                i += 1

        return 1

    def __repr__(self):
        if self.lines is None:
            count = None
        else:
            count = len(self.lines)
        return "<%s(size=%d, lines=#%d, exe=%r)>" % \
            (self.__class__.__name__, self.size, count, self.exe)


cdef class EventHandlerExe(EventHandler):
    """Specialized event handler that creates specialized event instances.

    This class is responsible by filtering out the events created from
    C without associated Python wrappers.
    """
    cdef Eina_Bool _exec(self, void *event) except 2:
        cdef Event e
        e = self.event_cls()
        if e._set_obj(event) == -1: # no exe
            return True
        return bool(self.func(e, *self.args, **self.kargs))


def on_exe_add_event_add(func, *args, **kargs):
    """Create an ecore event handler for ECORE_EXE_EVENT_ADD

       :see: EventHandler
       :see: EventHandlerExe
    """
    return EventHandlerExe(enums.ECORE_EXE_EVENT_ADD, func, *args, **kargs)


def on_exe_del_event_add(func, *args, **kargs):
    """Create an ecore event handler for ECORE_EXE_EVENT_DEL

       :see: EventHandler
       :see: EventHandlerExe
    """
    return EventHandlerExe(enums.ECORE_EXE_EVENT_DEL, func, *args, **kargs)


def on_exe_data_event_add(func, *args, **kargs):
    """Create an ecore event handler for ECORE_EXE_EVENT_DATA

       :see: EventHandler
       :see: EventHandlerExe
    """
    return EventHandlerExe(enums.ECORE_EXE_EVENT_DATA, func, *args, **kargs)


def on_exe_error_event_add(func, *args, **kargs):
    """Create an ecore event handler for ECORE_EXE_EVENT_ERROR

       :see: :py:class:`EventHandler`
       :see: :py:class:`EventHandlerExe`
    """
    return EventHandlerExe(enums.ECORE_EXE_EVENT_ERROR, func, *args, **kargs)
