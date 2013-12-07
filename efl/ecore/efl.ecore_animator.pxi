# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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


cdef class Animator(Eo):

    """

    Creates an animator to tick off at every animaton tick during main loop
    execution.

    This class represents an animator that will call the given ``func``
    every N seconds where N is the frametime interval set by
    animator_frametime_set(). The function will be passed any extra
    parameters given to constructor.

    When the animator ``func`` is called, it must return a value of either
    *True* or *False* (remember that Python returns *None* if no value is
    explicitly returned and *None* evaluates to *False*). If it returns
    *True*, it will be called again at the next tick, or if it returns
    *False* it will be deleted automatically making any references/handles
    for it invalid.

    Animators should be stopped/deleted by means delete() or
    returning *False* from ``func``, otherwise they'll continue alive, even
    if the current python context delete it's reference to it.

    :param func:
        function to call every frame. Expected signature::

            func(*args, **kargs) -> bool

    """
    def __init__(self, func, *args, **kargs):
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        self.func = func
        self.args = args
        self.kargs = kargs
        self._set_obj(ecore_animator_add(_ecore_task_cb, <void *>self))

    def __str__(self):
        return "%s Animator(func=%s, args=%s, kargs=%s)" % (Eo.__repr__(self),
               self.func, self.args, self.kargs)

    def __repr__(self):
        return "%s Animator(func=%s, args=%s, kargs=%s)" % (Eo.__repr__(self),
                self.func, self.args, self.kargs)

    cpdef bint _task_exec(self) except *:
        return self.func(*self.args, **self.kargs)

    def delete(self):
        "Stop callback emission and free internal resources."
        ecore_animator_del(self.obj)

    def stop(self):
        "Alias for delete()."
        self.delete()

cdef Eina_Bool _ecore_timeline_cb(void *data, double pos) with gil:
    assert data != NULL
    cdef:
        AnimatorTimeline obj = <AnimatorTimeline>data
        bint ret = False

    try:
        ret = obj.func(pos, *obj.args, **obj.kargs)
    except:
        traceback.print_exc()

    if not ret:
        obj.delete()

    return ret

cdef class AnimatorTimeline(Animator):

    """

    Add an animator that runs for a limited time

    :param runtime: The time to run in seconds
    :param func: The function to call when it ticks off

    This is just like a normal :py:class:`Animator` except the animator only
    runs for a limited time specified in seconds by ``runtime``. Once the
    runtime the animator has elapsed (animator finished) it will automatically
    be deleted. The callback function ``func`` can return ECORE_CALLBACK_RENEW
    to keep the animator running or ECORE_CALLBACK_CANCEL ro stop it and have it
    be deleted automatically at any time.

    The ``func`` will ALSO be passed a position parameter that will be in value
    from 0.0 to 1.0 to indicate where along the timeline (0.0 start, 1.0 end)
    the animator run is at. If the callback wishes not to have a linear
    transition it can "map" this value to one of several curves and mappings via
    :py:meth:`Animator.pos_map`.

    .. note:: The default ``frametime`` value is 1/30th of a second.

    .. versionadded:: 1.8

    """

    def __init__(self, func, double runtime, *args, **kargs):
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        self.func = func
        self.args = args
        self.kargs = kargs
        self._set_obj(ecore_animator_timeline_add(runtime, _ecore_timeline_cb, <void *>self))

    cpdef bint _task_exec(self) except *:
        return self.func(*self.args, **self.kargs)

def animator_add(func, *args, **kargs):
    """

    Animator factory, for C-api compatibility.

    func signature::

        func(*args, **kargs): bool

    :param func: function to call every frame.

    :return: a new Animator instance
    :rtype: ``efl.ecore.Animator``

    """
    return Animator(func, *args, **kargs)


def animator_frametime_set(double frametime):
    ecore_animator_frametime_set(frametime)


def animator_frametime_get():
    return ecore_animator_frametime_get()
