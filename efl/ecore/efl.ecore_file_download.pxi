# Copyright (C) 2007-2008 Gustavo Sverzut Barbieri
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

# This file is included verbatim by c_ecore_file.pyx


cdef void _completion_cb(void *data, const_char_ptr file, int status) with gil:
    obj = <FileDownload>data
    try:
        obj._exec_completion(file, status)
    except Exception, e:
        traceback.print_exc()

cdef int _progress_cb(void *data, const_char_ptr file, long int dltotal,
                    long int dlnow, long int ultotal, long int ulnow) with gil:
    obj = <FileDownload>data
    try:
        return obj._exec_progress(file, dltotal, dlnow, ultotal, ulnow)
    except Exception, e:
        traceback.print_exc()


cdef class FileDownload(object):
    def __init__(self, url, dst, completion_cb, progress_cb, *args, **kargs):
        cdef Ecore_File_Download_Job *job

        if completion_cb is not None and not callable(completion_cb):
            raise TypeError("Parameter 'completion_cb' must be callable, or None")

        if progress_cb is not None and not callable(progress_cb):
            raise TypeError("Parameter 'progress_cb' must be callable, or None")

        self.completion_cb = completion_cb
        self.progress_cb = progress_cb
        self.args = args
        self.kargs = kargs

        if not ecore_file_download(_cfruni(url), _cfruni(dst),
                                   _completion_cb, _progress_cb,
                                   <void *>self, &job):
            raise SystemError("could not download '%s' to %s" % (url, dst))
            
        self.job = job
        Py_INCREF(self)

    def __str__(self):
        return "%s(completion_cb=%s, progress_cb=%s args=%s, kargs=%s)" % \
               (self.__class__.__name__, self.completion_cb,
                self.progress_cb, self.args, self.kargs)

    def __repr__(self):
        return ("%s(%#x, completion_cb=%s, progress_cb=%s, args=%s, kargs=%s, "
                "Ecore_File_Download_Job=%#x, refcount=%d)") % \
               (self.__class__.__name__, <unsigned long><void *>self,
                self.completion_cb, self.progress_cb, self.args, self.kargs,
                <unsigned long>self.job, PY_REFCOUNT(self))

    def __dealloc__(self):
        if self.job != NULL:
            ecore_file_download_abort(self.job)
            self.job = NULL
        self.completion_cb = None
        self.progress_cb = None
        self.args = None
        self.kargs = None

    cdef object _exec_completion(self, const_char_ptr file, int status):
        if self.completion_cb:
            self.completion_cb(file, status, *self.args, **self.kargs)

    cdef object _exec_progress(self, const_char_ptr file, long int dltotal,
                            long int dlnow, long int ultotal, long int ulnow):
        if self.progress_cb:
            return self.progress_cb(file, dltotal, dlnow, ultotal, ulnow,
                                    *self.args, **self.kargs)
        return 0

    def abort(self):
        if self.job != NULL:
            ecore_file_download_abort(self.job)
            self.job = NULL
            Py_DECREF(self)


def file_download(url, dst, completion_cb, progress_cb, *args, **kargs):
    return FileDownload(url, dst, completion_cb, progress_cb, *args, **kargs)

def file_download_abort(instance):
    instance.abort()

def file_download_abort_all():
    ecore_file_download_abort_all()

def file_download_protocol_available(protocol):
    return bool(ecore_file_download_protocol_available(protocol))
