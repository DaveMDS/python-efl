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


cdef void fd_handler_prepare_cb(void *data, Ecore_Fd_Handler *fdh) with gil:
    cdef FdHandler obj = <FdHandler>data
    cdef int r

    if obj._prepare_callback is None:
        return
    func, args, kargs = obj._prepare_callback
    try:
        func(obj, *args, **kargs)
    except Exception:
        traceback.print_exc()


cdef flags2str(int value):
    flags = []
    if value & <int>enums.ECORE_FD_READ:
        flags.append("READ")
    if value & <int>enums.ECORE_FD_WRITE:
        flags.append("WRITE")
    if value & <int>enums.ECORE_FD_ERROR:
        flags.append("ERROR")
    return ", ".join(flags)


cdef Eina_Bool fd_handler_cb(void *data, Ecore_Fd_Handler *fdh) with gil:
    cdef FdHandler obj = <FdHandler>data
    cdef Eina_Bool r

    try:
        r = bool(obj._exec())
    except Exception:
        traceback.print_exc()
        r = 0

    if not r:
        obj.delete()
    return r


cdef class FdHandler(object):
    """

    Adds a callback for activity on the given file descriptor.

    ``func`` will be called during the execution of ``main_loop_begin()``
    when the file descriptor is available for reading, or writing, or both.

    When the handler ``func`` is called, it must return a value of
    either *True* or *False* (remember that Python returns *None* if no value
    is explicitly returned and *None* evaluates to *False*). If it returns
    *True*, it will continue to monitor the given file descriptor, or if
    it returns *False* it will be deleted automatically making any
    references/handles for it invalid.

    FdHandler use includes:

    - handle multiple socket connections using a single process;
    - thread wake-up and synchronization;
    - non-blocking file description operations.

    """
    def __init__(self, fd, int flags, func, *args, **kargs):
        """FdHandler(...)

        :param fd: file descriptor or object with fileno() method.
        :param flags: bitwise OR of ECORE_FD_READ, ECORE_FD_WRITE...
        :param func: function to call when file descriptor state changes.

        Expected **func** signature::

                func(fd_handler, *args, **kargs): bool

        """
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        self.func = func
        self.args = args
        self.kargs = kargs
        self._prepare_callback = None
        if self.obj == NULL:
            if not isinstance(fd, (int, long)):
                try:
                    fd = fd.fileno()
                except AttributeError:
                    raise ValueError("fd must be integer or have fileno()")

            self.obj = ecore_main_fd_handler_add(fd,
                                                 <Ecore_Fd_Handler_Flags>flags,
                                                 fd_handler_cb, <void *>self,
                                                 NULL, NULL)
            if self.obj != NULL:
                Py_INCREF(self)

    def __str__(self):
        if self.obj == NULL:
            fd = None
            flags = ""
        else:
            fd = self.fd_get()
            flags = flags2str(self.active_get(7))
        return "%s(func=%s, args=%s, kargs=%s, fd=%s, flags=[%s])" % \
               (self.__class__.__name__, self.func, self.args, self.kargs,
                fd, flags)

    def __repr__(self):
        if self.obj == NULL:
            fd = None
            flags = ""
        else:
            fd = self.fd_get()
            flags = flags2str(self.active_get(7))
        return ("%s(%#x, func=%s, args=%s, kargs=%s, fd=%s, flags=[%s], "
                "Ecore_Fd_Handler=%#x, refcount=%d)") % \
               (self.__class__.__name__, <uintptr_t><void *>self,
                self.func, self.args, self.kargs, fd, flags,
                <uintptr_t>self.obj, PY_REFCOUNT(self))

    def __dealloc__(self):
        if self.obj != NULL:
            ecore_main_fd_handler_del(self.obj)
            self.obj = NULL
        self.func = None
        self.args = None
        self.kargs = None

    cdef object _exec(self):
        return self.func(self, *self.args, **self.kargs)

    def is_deleted(self):
        """Check if the object has been deleted thus leaving the object shallow.

        :return: True if the object has been deleted yet, False otherwise.
        :rtype: bool

        .. versionadded:: 1.18

        """
        return bool(self.obj == NULL)

    def delete(self):
        """Stop callback emission and free internal resources."""
        if self.obj != NULL:
            ecore_main_fd_handler_del(self.obj)
            self.obj = NULL
            Py_DECREF(self)

    def stop(self):
        """Alias for ``delete``."""
        self.delete()

    def fd_get(self):
        """ Get the file descriptor number

        :rtype: int

        """
        return ecore_main_fd_handler_fd_get(self.obj)

    property fd:
        def __get__(self):
            return self.fd_get()

    def active_get(self, int flags):
        """Return if read, write or error, or a combination thereof, is
        active on the file descriptor of the given FD handler.

        :rtype: bool
        """
        cdef Ecore_Fd_Handler_Flags v = <Ecore_Fd_Handler_Flags>flags
        return bool(ecore_main_fd_handler_active_get(self.obj, v))

    def active_set(self, int flags):
        """Set what active streams the given FdHandler should be monitoring.

        :param flags:
            one of
            - ECORE_FD_NONE
            - ECORE_FD_READ
            - ECORE_FD_WRITE
            - ECORE_FD_ERROR
            - ECORE_FD_ALL

        """
        cdef Ecore_Fd_Handler_Flags v = <Ecore_Fd_Handler_Flags>flags
        ecore_main_fd_handler_active_set(self.obj, v)

    def can_read(self):
        """:rtype: bool"""
        return bool(ecore_main_fd_handler_active_get(self.obj, enums.ECORE_FD_READ))

    def can_write(self):
        """:rtype: bool"""
        return bool(ecore_main_fd_handler_active_get(self.obj, enums.ECORE_FD_WRITE))

    def has_error(self):
        """:rtype: bool"""
        return bool(ecore_main_fd_handler_active_get(self.obj, enums.ECORE_FD_ERROR))

    def prepare_callback_set(self, func, *args, **kargs):
        """Set a function to call before doing the select() on the fd.

        Expected signature::

            function(object, *args, **kargs)

        """
        if func is None:
            self._prepare_callback = None
            ecore_main_fd_handler_prepare_callback_set(self.obj, NULL, NULL)
        elif callable(func):
            self._prepare_callback = (func, args, kargs)
            ecore_main_fd_handler_prepare_callback_set(self.obj,
                                                       fd_handler_prepare_cb,
                                                       <void *>self)
        else:
            raise TypeError("Parameter 'func' must be callable")


def fd_handler_add(fd, int flags, func, *args, **kargs):
    """:py:class:`FdHandler` factory, for C-api compatibility.

    ``func`` signature::

        func(fd_handler, *args, **kargs): bool

    :param fd: file descriptor or object with ``fileno()`` method.
    :param flags: bitwise OR of ECORE_FD_READ, ECORE_FD_WRITE...
    :param func: function to call when file descriptor state changes.

    :rtype: `efl.ecore.FdHandler`

    """
    return FdHandler(fd, flags, func, *args, **kargs)
