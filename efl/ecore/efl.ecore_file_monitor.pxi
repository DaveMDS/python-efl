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

from cpython cimport PyUnicode_AsUTF8String


cdef void _file_monitor_cb(void *data, Ecore_File_Monitor *em, Ecore_File_Event event, const_char *path) with gil:
    obj = <FileMonitor>data
    try:
        obj._exec_monitor(event, path)
    except Exception, e:
        traceback.print_exc()


cdef class FileMonitor(object):
    """ TODOC """
    def __init__(self, path, monitor_cb, *args, **kargs):

        if not callable(monitor_cb):
            raise TypeError("Parameter 'monitor_cb' must be callable")

        self.monitor_cb = monitor_cb
        self.args = args
        self.kargs = kargs

        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        self.mon = ecore_file_monitor_add(
                            <const_char *>path if path is not None else NULL,
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
               (self.__class__.__name__, <unsigned long><void *>self,
                self.monitor_cb, self.args, self.kargs, PY_REFCOUNT(self))

    cdef object _exec_monitor(self, Ecore_File_Event event, const_char *path):
        if self.monitor_cb:
            return self.monitor_cb(event, _ctouni(path), *self.args, **self.kargs)
        return 0

    def delete(self):
        """ TODOC """
        if self.mon != NULL:
            ecore_file_monitor_del(self.mon)
            self.mon = NULL
            Py_DECREF(self)

    property path:
        """ TODOC """
        def __get__(self):
            return _ctouni(ecore_file_monitor_path_get(self.mon))
