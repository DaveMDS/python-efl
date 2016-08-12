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


cdef void _file_monitor_cb(void *data, Ecore_File_Monitor *em, Ecore_File_Event event, const char *path) with gil:
    obj = <FileMonitor>data
    try:
        obj._exec_monitor(event, path)
    except Exception:
        traceback.print_exc()


cdef class FileMonitor(object):
    """

    Monitor the given path for changes.

    The callback signatures is::

        monitor_cb(event, path, *args, **kargs)

    Example::

        def monitor_cb(event, path, tmp_path):
            if event == ecore.ECORE_FILE_EVENT_MODIFIED:
                print("EVENT_MODIFIED: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_CLOSED:
                print("EVENT_CLOSED: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_CREATED_FILE:
                print("ECORE_FILE_EVENT_CREATED_FILE: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_CREATED_DIRECTORY:
                print("ECORE_FILE_EVENT_CREATED_DIRECTORY: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_DELETED_FILE:
                print("ECORE_FILE_EVENT_DELETED_FILE: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_DELETED_DIRECTORY:
                print("ECORE_FILE_EVENT_DELETED_DIRECTORY: '%s'" % path)
            elif event == ecore.ECORE_FILE_EVENT_DELETED_SELF:
                print("ECORE_FILE_EVENT_DELETED_SELF: '%s'" % path)

        ecore.FileMonitor("/tmp", monitor_cb)
        ecore.main_loop_begin()

    .. versionadded:: 1.8

    """
    def __init__(self, path, monitor_cb, *args, **kargs):
        """FileMonitor(...)

        :param path: The complete path of the folder you want to monitor.
        :type path: str
        :param monitor_cb: A callback called when something change in `path`
        :type monitor_cb: callable
        
        """

        if not callable(monitor_cb):
            raise TypeError("Parameter 'monitor_cb' must be callable")

        self.monitor_cb = monitor_cb
        self.args = args
        self.kargs = kargs

        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        self.mon = ecore_file_monitor_add(
                            <const char *>path if path is not None else NULL,
                            _file_monitor_cb, <void *>self)
        if not self.mon:
            raise SystemError("could not monitor '%s'" % (path))

        Py_INCREF(self)

    def __dealloc__(self):
        if self.mon != NULL:
            ecore_file_monitor_del(self.mon)
            self.mon = NULL
        self.monitor_cb = None
        self.args = None
        self.kargs = None

    def __str__(self):
        return "%s(monitor_cb=%s, args=%s, kargs=%s)" % \
               (self.__class__.__name__, self.monitor_cb, self.args, self.kargs)

    def __repr__(self):
        return ("%s(%#x, monitor_cb=%s, args=%s, kargs=%s, refcount=%d)") % \
               (self.__class__.__name__, <uintptr_t><void *>self,
                self.monitor_cb, self.args, self.kargs, PY_REFCOUNT(self))

    cdef object _exec_monitor(self, Ecore_File_Event event, const char *path):
        if self.monitor_cb:
            return self.monitor_cb(event, _ctouni(path), *self.args, **self.kargs)
        return 0

    def delete(self):
        """ Delete the monitor

        Stop the monitoring process, all the internal resource will be freed
        and no more callbacks will be called.

         """
        if self.mon != NULL:
            ecore_file_monitor_del(self.mon)
            self.mon = NULL
            Py_DECREF(self)

    property path:
        """ The path actully monitored.

        :type: str (readonly)

        """
        def __get__(self):
            return _ctouni(ecore_file_monitor_path_get(self.mon))
