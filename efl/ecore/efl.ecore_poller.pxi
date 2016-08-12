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


cdef class Poller(Eo):
    """

    Ecore poller provides infrastructure for the creation of pollers. Pollers
    are, in essence, callbacks that share a single timer per type. Because not
    all pollers need to be called at the same frequency the user may specify the
    frequency in ticks(each expiration of the shared timer is called a tick, in
    ecore poller parlance) for each added poller. Ecore pollers should only be
    used when the poller doesn't have specific requirements on the exact times
    to poll.

    This architecture means that the main loop is only woken up once to handle
    all pollers of that type, this will save power as the CPU has more of a
    chance to go into a low power state the longer it is asleep for, so this
    should be used in situations where power usage is a concern.

    For now only 1 core poller type is supported: ECORE_POLLER_CORE, the default
    interval for ECORE_POLLER_CORE is 0.125(or 1/8th) second.

    The `interval` must be between 1 and 32768 inclusive, and must be a power of
    2 (i.e. 1, 2, 4, 8, 16, ... 16384, 32768). The exact tick in which `func`
    will be called is undefined, as only the interval between calls can be
    defined. Ecore will endeavor to keep pollers synchronized and to call as
    many in 1 wakeup event as possible. If `interval` is not a power of two, the
    closest power of 2 greater than `interval` will be used.

    When the poller `func` is called, it must return a value of either
    ECORE_CALLBACK_RENEW(or True) or ECORE_CALLBACK_CANCEL(or False). If it
    returns 1, it will be called again at the next tick, or if it returns
    0 it will be deleted automatically making any references/handles for it
    invalid.

    Example::

        def poller_cb():
            print("Poller")
            return True

        ecore.Poller(4, poller_cb)

    .. versionadded:: 1.8

     """
    def __init__(self, int interval, func, pol_type=0, *args, **kargs):
        """Poller(...)

        :param interval: The poll interval
        :type interval: int
        :param func: The function to call at every interval
        :type func: callable
        :param pol_type: The ticker type to attach the poller to. Must be ECORE_POLLER_CORE
        :type pol_type: Ecore_Poll_Type
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
        self._set_obj(ecore_poller_add(pol_type, interval, _ecore_task_cb, <void *>self))

    def __str__(self):
        return "%s Poller(func=%s, args=%s, kargs=%s)" % (Eo.__str__(self),
               self.func, self.args, self.kargs)

    def __repr__(self):
        return "%s Poller(interval=%d, func=%s, args=%s, kargs=%s)" % (Eo.__repr__(self),
                self.interval if self.obj else -1,
                self.func, self.args, self.kargs)

    cpdef bint _task_exec(self) except *:
        return self.func(*self.args, **self.kargs)

    def delete(self):
        """ Stop callback emission and free internal resources. """
        ecore_poller_del(self.obj)


    property interval:
        """ The interval (in ticks) between each call of the poller

        :type: int

        """
        def __get__(self):
            return ecore_poller_poller_interval_get(self.obj)

        def __set__(self, int t):
            ecore_poller_poller_interval_set(self.obj, t)

    def interval_set(self, int t):
        ecore_poller_poller_interval_set(self.obj, t)
    def interval_get(self):
        return ecore_poller_poller_interval_get(self.obj)


def poller_add(int t, func, *args, **kargs):
    return Poller(t, func, *args, **kargs)

