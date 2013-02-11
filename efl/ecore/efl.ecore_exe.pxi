# Copyright (C) 2010 Gustavo Sverzut Barbieri
#
# This file is part of Python-Ecore.
#
# Python-Ecore is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Ecore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Ecore.  If not, see <http://www.gnu.org/licenses/>.

# This file is included verbatim by c_ecore.pyx


# TODO: remove me after usage is update to new buffer api
cdef extern from "Python.h":
    int PyObject_AsReadBuffer(obj, void **buffer, Py_ssize_t *buffer_len) except -1
    object PyUnicode_FromStringAndSize(char *s, Py_ssize_t len)


cdef exe_flags2str(int value):
    flags = []
    if value & ECORE_EXE_PIPE_READ:
        flags.append("PIPE_READ")
    if value & ECORE_EXE_PIPE_WRITE:
        flags.append("PIPE_WRITE")
    if value & ECORE_EXE_PIPE_ERROR:
        flags.append("PIPE_ERROR")
    if value & ECORE_EXE_PIPE_READ_LINE_BUFFERED:
        flags.append("PIPE_READ_LINE_BUFFERED")
    if value & ECORE_EXE_PIPE_ERROR_LINE_BUFFERED:
        flags.append("PIPE_ERROR_LINE_BUFFERED")
    if value & ECORE_EXE_PIPE_AUTO:
        flags.append("PIPE_AUTO")
    if value & ECORE_EXE_RESPAWN:
        flags.append("RESPAWN")
    if value & ECORE_EXE_USE_SH:
        flags.append("USE_SH")
    if value & ECORE_EXE_NOT_LEADER:
        flags.append("NOT_LEADER")
    return ", ".join(flags)


cdef Eina_Bool _exe_event_filter_cb(void *data, int type, void *event) with gil:
    cdef ExeEventFilter self = <ExeEventFilter>data
    cdef Ecore_Exe_Event_Add *e_add
    cdef Ecore_Exe_Event_Del *e_del
    cdef Ecore_Exe_Event_Data *e_data
    cdef Event e

    try:
        assert self.event_type == type, "event is not what we asked? impossible"
        if type == ECORE_EXE_EVENT_ADD:
            e_add = <Ecore_Exe_Event_Add *>event
            if e_add.exe != self.exe:
                return 1
            e = EventExeAdd()
        elif type == ECORE_EXE_EVENT_DEL:
            e_del = <Ecore_Exe_Event_Del *>event
            if e_del.exe != self.exe:
                return 1
            e = EventExeDel()
        elif type == ECORE_EXE_EVENT_DATA or type == ECORE_EXE_EVENT_ERROR:
            e_data = <Ecore_Exe_Event_Data *>event
            if e_data.exe != self.exe:
                return 1
            e = EventExeData()
        else:
            raise SystemError("unknown event type=%d" % type)

        r = e._set_obj(event)
        assert r != -1, "exe is not known?! impossible!"

        cb = tuple(self.callbacks) # copy, so we can change self.callbacks
        for func, args, kargs in cb:
            try:
                func(self.owner, e, *args, **kargs)
            except:
                traceback.print_exc()

    except:
        traceback.print_exc()

    return 1 # always return true, no matter what


cdef class ExeEventFilter:
    def __cinit__(self, *a, **ka):
        self.exe = NULL
        self.handler = NULL
        self.owner = None
        self.event_type = -1
        self.callbacks = []

    def __dealloc__(self):
        if self.handler != NULL:
            ecore_event_handler_del(self.handler)
            self.handler = NULL

        self.exe = NULL
        self.owner = None
        self.event_type = None
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
        except ValueError, e:
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


cdef void _ecore_exe_pre_free_cb(void *data, const_Ecore_Exe *exe) with gil:
    cdef Exe obj
    try:
        if data == NULL:
            raise ValueError("data parameter is NULL")
        else:
            obj = <Exe>data
            obj._unset_obj()
    except Exception, e:
        traceback.print_exc()


cdef class Exe(object):
    def __cinit__(self, *a, **ka):
        self.exe = NULL
        self.__data = None
        self.__callbacks = {}

    def __init__(self, exe_cmd, int flags=0, data=None):
        if not exe_cmd:
            raise ValueError("exe_cmd must not be empty!")

        if flags is None:
            flags = 0

        self._set_obj(_fruni(exe_cmd), flags)
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
        _ecore_exe_event_mapping[<long><void *>exe] = self
        return 1

    cdef int _unset_obj(self) except 0:
        assert self.exe != NULL, "Exe must wrap something"
        for t, filter in self.__callbacks.iteritems():
            filter.delete()
        self.__callbacks = None

        _ecore_exe_event_mapping.pop(<long><void *>self.exe)
        self.exe = NULL
        Py_DECREF(self)
        return 1

    def __str__(self):
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
        return "%s(pid=%s, cmd=%r, flags=[%s], data=%r)" % \
            (self.__class__.__name__, pid, cmd, flags, data)

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
        return ("%s(%#x, Ecore_Exe=%#x, refcount=%d, pid=%s, cmd=%r, "
                "flags=[%s], data=%r)") % \
                (self.__class__.__name__, <unsigned long><void *>self,
                 <unsigned long>self.exe, PY_REFCOUNT(self),
                 pid, cmd, flags, data)

    def delete(self):
        if self.exe == NULL:
            raise ValueError("%s already deleted" % self.__class__.__name__)
        ecore_exe_free(self.exe)

    def free(self):
        self.delete()

    def send(self, buffer, long size=0):
        cdef const_void *b_data
        cdef Py_ssize_t b_size

        # TODO: update to new buffer api
        PyObject_AsReadBuffer(buffer, &b_data, &b_size)
        if size <= 0:
            size = b_size
        elif size > b_size:
            raise ValueError(
                "given size (%d) is larger than buffer size (%d)." %
                (size, b_size))

        return bool(ecore_exe_send(self.exe, b_data, size))

    def close_stdin(self):
        ecore_exe_close_stdin(self.exe)

    def auto_limits_set(self, int start_bytes, int end_bytes,
                        int start_lines, int end_lines):
        ecore_exe_auto_limits_set(self.exe, start_bytes, end_bytes,
                                  start_lines, end_lines)

    def event_data_get(self, int flags):
        pass
        # TODO:
        #Ecore_Exe_Event_Data *ecore_exe_event_data_get(Ecore_Exe *exe, Ecore_Exe_Flags flags)
        #void ecore_exe_event_data_free(Ecore_Exe_Event_Data *data)

    def cmd_get(self):
        cdef const_char_ptr cmd = ecore_exe_cmd_get(self.exe)
        if cmd != NULL:
            return cmd
        return None

    property cmd:
        def __get__(self):
            return self.cmd_get()

    def pid_get(self):
        return ecore_exe_pid_get(self.exe)

    property pid:
        def __get__(self):
            return self.pid_get()

    def tag_set(self, char *tag):
        cdef char *s
        if tag is None:
            s = NULL
        else:
            s = tag
        ecore_exe_tag_set(self.exe, s)

    def tag_get(self):
        cdef const_char_ptr tag = ecore_exe_tag_get(self.exe)
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
        return ecore_exe_flags_get(self.exe)

    property flags:
        def __get__(self):
            return self.flags_get()

    def signal(self, int num):
        if num != 1 or num != 2:
            raise ValueError("num must be either 1 or 2. Got %d." % num)
        ecore_exe_signal(self.exe, num)

    def pause(self):
        ecore_exe_pause(self.exe)

    def stop(self):
        self.pause()

    def continue_(self):
        ecore_exe_continue(self.exe)

    def resume(self):
        self.continue_()

    def interrupt(self):
        ecore_exe_interrupt(self.exe)

    def quit(self):
        ecore_exe_quit(self.exe)

    def terminate(self):
        ecore_exe_terminate(self.exe)

    def kill(self):
        ecore_exe_kill(self.exe)

    def hup(self):
        ecore_exe_hup(self.exe)

    def on_add_event_add(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_ADD)
        if filter is None:
            filter = ExeEventFilter(self, ECORE_EXE_EVENT_ADD)
            self.__callbacks[ECORE_EXE_EVENT_ADD] = filter
        filter.callback_add(func, args, kargs)

    def on_add_event_del(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_ADD)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_del_event_add(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_DEL)
        if filter is None:
            filter = ExeEventFilter(self, ECORE_EXE_EVENT_DEL)
            self.__callbacks[ECORE_EXE_EVENT_DEL] = filter
        filter.callback_add(func, args, kargs)

    def on_del_event_del(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_DEL)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_data_event_add(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_DATA)
        if filter is None:
            filter = ExeEventFilter(self, ECORE_EXE_EVENT_DATA)
            self.__callbacks[ECORE_EXE_EVENT_DATA] = filter
        filter.callback_add(func, args, kargs)

    def on_data_event_del(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_DATA)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)

    def on_error_event_add(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_ERROR)
        if filter is None:
            filter = ExeEventFilter(self, ECORE_EXE_EVENT_ERROR)
            self.__callbacks[ECORE_EXE_EVENT_ERROR] = filter
        filter.callback_add(func, args, kargs)

    def on_error_event_del(self, func, *args, **kargs):
        filter = self.__callbacks.get(ECORE_EXE_EVENT_ERROR)
        if filter is None:
            raise ValueError("callback not registered %s, args=%s, kargs=%s" %
                             (func, args, kargs))
        filter.callback_del(func, args, kargs)


def exe_run(char *exe_cmd, data=None):
    return Exe(exe_cmd, data=data)


def exe_pipe_run(char *exe_cmd, int flags=0, data=None):
    return Exe(exe_cmd, flags, data)


cdef class EventExeAdd(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Add *obj
        obj = <Ecore_Exe_Event_Add*>o
        self.exe = _ecore_exe_event_mapping.get(<long>obj.exe)
        if self.exe is None:
            return -1
        return 1

    def __str__(self):
        return "%s(exe=%s)" % (self.__class__.__name__, self.exe)

    def __repr__(self):
        return "%s(exe=%r)" % (self.__class__.__name__, self.exe)


cdef class EventExeDel(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Del *obj
        obj = <Ecore_Exe_Event_Del*>o
        self.exe = _ecore_exe_event_mapping.get(<long>obj.exe)
        if self.exe is None:
            return -1
        self.pid = obj.pid
        self.exit_code = obj.exit_code
        self.exit_signal = obj.exit_signal
        self.exited = bool(obj.exited)
        self.signalled = bool(obj.signalled)
        return 1

    def __str__(self):
        return ("%s(pid=%s, exit_code=%s, exit_signal=%s, exited=%s, "
                "signalled=%s, exe=%s)") % \
                (self.__class__.__name__, self.pid, self.exit_code,
                 self.exit_signal, self.exited, self.signalled, self.exe)

    def __repr__(self):
        return ("%s(pid=%s, exit_code=%s, exit_signal=%s, exited=%s, "
                "signalled=%s, exe=%r)") % \
                (self.__class__.__name__, self.pid, self.exit_code,
                 self.exit_signal, self.exited, self.signalled, self.exe)


cdef class EventExeData(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Exe_Event_Data *obj
        cdef int i
        obj = <Ecore_Exe_Event_Data*>o
        self.exe = _ecore_exe_event_mapping.get(<long>obj.exe)
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

    def __str__(self):
        if self.lines is None:
            count = None
        else:
            count = len(self.lines)
        return "%s(size=%d, lines=#%d, exe=%s)" % \
            (self.__class__.__name__, self.size, count, self.exe)

    def __repr__(self):
        if self.lines is None:
            count = None
        else:
            count = len(self.lines)
        return "%s(size=%d, lines=#%d, exe=%r)" % \
            (self.__class__.__name__, self.size, count, self.exe)


cdef class EventHandlerExe(EventHandler):
    cdef Eina_Bool _exec(self, void *event) except 2:
        cdef Event e
        e = self.event_cls()
        if e._set_obj(event) == -1: # no exe
            return True
        return bool(self.func(e, *self.args, **self.kargs))


def on_exe_add_event_add(func, *args, **kargs):
    return EventHandlerExe(ECORE_EXE_EVENT_ADD, func, *args, **kargs)


def on_exe_del_event_add(func, *args, **kargs):
    return EventHandlerExe(ECORE_EXE_EVENT_DEL, func, *args, **kargs)


def on_exe_data_event_add(func, *args, **kargs):
    return EventHandlerExe(ECORE_EXE_EVENT_DATA, func, *args, **kargs)


def on_exe_error_event_add(func, *args, **kargs):
    return EventHandlerExe(ECORE_EXE_EVENT_ERROR, func, *args, **kargs)
