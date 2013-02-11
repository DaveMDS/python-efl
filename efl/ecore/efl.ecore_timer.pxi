# Copyright (C) 2007-2013 Gustavo Sverzut Barbieri, Ulisses Furquim
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

# This file is included verbatim by efl.ecore.pyx


cdef class Timer(Eo):
    def __init__(self, double interval, func, *args, **kargs):
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        self.func = func
        self.args = args
        self.kargs = kargs
        self._set_obj(ecore_timer_add(interval, _ecore_task_cb, <void *>self))

    def __str__(self):
        return "%s Timer(func=%s, args=%s, kargs=%s)" % (Eo.__str__(self),
               self.func, self.args, self.kargs)

    def __repr__(self):
        return "%s Timer(interval=%f, func=%s, args=%s, kargs=%s)" % (Eo.__repr__(self),
                self.interval if self.obj else -1.0,
                self.func, self.args, self.kargs)

    cpdef object _task_exec(self):
        return self.func(*self.args, **self.kargs)

    def delete(self):
        ecore_timer_del(self.obj)
    
    def stop(self):
        self.delete()

    def freeze(self):
        ecore_timer_freeze(self.obj)

    def thaw(self):
        ecore_timer_thaw(self.obj)

    def interval_set(self, double t):
        ecore_timer_interval_set(self.obj, t)

    def interval_get(self):
        return ecore_timer_interval_get(self.obj)

    property interval:
        def __get__(self):
            return ecore_timer_interval_get(self.obj)

        def __set__(self, double t):
            ecore_timer_interval_set(self.obj, t)

    def delay(self, double add):
        ecore_timer_delay(self.obj, add)

    def reset(self):
        ecore_timer_reset(self.obj)

    def ecore_timer_pending_get(self):
        ecore_timer_pending_get(self.obj)

    property pending:
        def __get__(self):
            return ecore_timer_pending_get(self.obj)


def timer_add(double t, func, *args, **kargs):
    return Timer(t, func, *args, **kargs)


def timer_precision_get():
    return ecore_timer_precision_get()


def timer_precision_set(double value):
    ecore_timer_precision_set(value)

