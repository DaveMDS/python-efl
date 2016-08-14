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


cdef class Timer(Eo):
    """

    Creates a timer to call the given function in the given period of time.

    This class represents a timer that will call the given ``func`` every
    ``interval`` seconds. The function will be passed any extra
    parameters given to constructor.

    When the timer ``func`` is called, it must return a value of either
    **True** or **False** (remember that Python returns **None** if no value is
    explicitly returned and **None** evaluates to **False**). If it returns
    **True**, it will be called again at the next interval, or if it returns
    **False** it will be deleted automatically making any references/handles
    for it invalid.

    Timers should be stopped/deleted by means of ``delete()`` or
    returning *False* from ``func``, otherwise they'll continue alive, even
    if the current python context delete it's reference to it.

    For convenience and readability callback can also return one of the
    :ref:`Ecore_Callback_Returns`. That is ``ECORE_CALLBACK_RENEW`` (like
    returning True) or ``ECORE_CALLBACK_CANCEL`` (like returning False).

    """
    def __init__(self, double interval, func, *args, **kargs):
        """Timer(...)

        :param interval: interval in seconds.
        :type interval: float
        :param func: function to callback when timer expires.
        :type func: callable
        :param \*args: All the remaining arguments will be passed
                       back in the callback function.
        :param \**kwargs: All the remaining keyword arguments will be passed
                          back in the callback function.

        Expected **func** signature::

            func(*args, **kargs): bool

        """
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

    cpdef bint _task_exec(self) except *:
        return self.func(*self.args, **self.kargs)

    def delete(self):
        """Stop callback emission and free internal resources."""
        ecore_timer_del(self.obj)

    def stop(self):
        """Alias for ``delete()``"""
        self.delete()

    def freeze(self):
        """Pauses a running timer."""
        ecore_timer_freeze(self.obj)

    def thaw(self):
        """Resumes a frozen (paused) timer."""
        ecore_timer_thaw(self.obj)

    def delay(self, double add):
        """Delay the execution of the timer by the given amount

        :param add: seconds to add to the timer
        :type add: double

        .. versionadded:: 1.8

        """
        ecore_timer_delay(self.obj, add)

    def reset(self):
        """Reset the counter of the timer

        .. versionadded:: 1.8

        """
        ecore_timer_reset(self.obj)

    property interval:
        """The interval (in seconds) between each call of the timer

        :type: double

        """
        def __get__(self):
            return ecore_timer_interval_get(self.obj)

        def __set__(self, double t):
            ecore_timer_interval_set(self.obj, t)

    def interval_set(self, double t):
        ecore_timer_interval_set(self.obj, t)
    def interval_get(self):
        return ecore_timer_interval_get(self.obj)

    property pending:
        """The pending time for the timer to expire

        :type: double

        .. versionadded:: 1.8

        """

        def __get__(self):
            return ecore_timer_pending_get(self.obj)

    def pending_get(self):
        ecore_timer_pending_get(self.obj)


def timer_add(double t, func, *args, **kargs):
    return Timer(t, func, *args, **kargs)


def timer_precision_get():
    return ecore_timer_precision_get()


def timer_precision_set(double value):
    ecore_timer_precision_set(value)

