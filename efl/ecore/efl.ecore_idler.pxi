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


cdef class Idler(Eo):
    """

    Add an idler handler.

    This class represents an idler on the event loop that will
    call ``func`` when there is nothing more to do. The function will
    be passed any extra parameters given to constructor.

    When the idler ``func`` is called, it must return a value of either
    **True** or **False** (remember that Python returns **None** if no value
    is explicitly returned and **None** evaluates to False). If it returns
    **True**, it will be called again when system become idle, or if it
    returns **False** it will be deleted automatically making any
    references/handles for it invalid.

    Idlers should be stopped/deleted by means of delete()or
    returning False from ``func``, otherwise they'll continue alive, even
    if the current python context delete it's reference to it.

    Idlers are useful for progressively prossessing data without blocking.

    """
    def __init__(self, func, *args, **kargs):
        """Idler(...)

        :param func: Function to call when system is idle.
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

        # From efl 1.18 idlers are no more Eo objects in C, thus
        # we cannot use Eo.obj and _set_obj() anymore :(
        # self._set_obj(ecore_idler_add(_ecore_task_cb, <void *>self))
        self.obj2 = ecore_idler_add(_ecore_task_cb, <void *>self)
        Py_INCREF(self)

    def __str__(self):
        return "Idler(obj=%#x, func=%s, args=%s, kargs=%s)" % (
                      <uintptr_t>self.obj2, self.func, self.args, self.kargs)

    def __repr__(self):
        return "Idler(obj=%#x, func=%s, args=%s, kargs=%s)" % (
                      <uintptr_t>self.obj2, self.func, self.args, self.kargs)

    cpdef bint _task_exec(self) except *:
        return self.func(*self.args, **self.kargs)

    def is_deleted(self):
        """Check if the object has been deleted thus leaving the object shallow.

        :return: True if the object has been deleted yet, False otherwise.
        :rtype: bool

        """
        return bool(self.obj2 == NULL)

    def delete(self):
        """Stop callback emission and free internal resources."""
        ecore_idler_del(self.obj2)
        self.obj2 = NULL
        Py_DECREF(self)

    def stop(self):
        """Alias for stop()."""
        self.delete()


cdef class IdleEnterer(Idler):
    """

    Add an idle enterer handler.

    This class represents a function that will be called before systems
    enter idle. The function will be passed any extra parameters given
    to constructor.

    When the idle enterer ``func`` is called, it must return a value of
    either **True** or **False** (remember that Python returns **None** if
    no value is explicitly returned and **None** evaluates to **False**). If
    it returns **True**, it will be called again when system become idle, or
    if it returns **False** it will be deleted automatically making any
    references/handles for it invalid.

    Idle enterers should be stopped/deleted by means of delete() or
    returning **False** from ``func``, otherwise they'll continue alive, even
    if the current python context delete it's reference to it.

    Idle enterer are useful for post-work jobs, like garbage collection.



    """
    def __init__(self, func, *args, **kargs):
        """IdleEnterer(...)

        :param func: Function to call when system enters idle.
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

        # From efl 1.18 idlers are no more Eo objects in C, thus
        # we cannot use Eo.obj and _set_obj() anymore :(
        # self._set_obj(ecore_idle_enterer_add(_ecore_task_cb, <void *>self))
        self.obj2 = ecore_idle_enterer_add(_ecore_task_cb, <void *>self)
        Py_INCREF(self)

    def delete(self):
        """Stop callback emission and free internal resources."""
        ecore_idle_enterer_del(self.obj2)
        self.obj2 = NULL
        Py_DECREF(self)


cdef class IdleExiter(Idler):
    """

    Add an idle exiter handler.

    This class represents a function that will be called before systems
    exits idle. The function will be passed any extra parameters given
    to constructor.

    When the idle exiter ``func`` is called, it must return a value of
    either *True* or *False* (remember that Python returns *None* if no value
    is explicitly returned and *None* evaluates to *False*). If it returns
    *True*, it will be called again when system become idle, or if it
    returns *False* it will be deleted automatically making any
    references/handles for it invalid.

    Idle exiters should be stopped/deleted by means of delete() or
    returning *False* from ``func``, otherwise they'll continue alive, even
    if the current python context delete it's reference to it.

    """
    def __init__(self, func, *args, **kargs):
        """ IdleExiter(...)

        :param func: Function to call when system exits idle.
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
        
        # From efl 1.18 idlers are no more Eo objects in C, thus
        # we cannot use Eo.obj and _set_obj() anymore :(
        # self._set_obj(ecore_idle_exiter_add(_ecore_task_cb, <void *>self))
        self.obj2 = ecore_idle_exiter_add(_ecore_task_cb, <void *>self)
        Py_INCREF(self)

    def delete(self):
        """Stop callback emission and free internal resources."""
        ecore_idle_exiter_del(self.obj2)
        self.obj2 = NULL
        Py_DECREF(self)


def idler_add(func, *args, **kargs):
    """efl.ecore.Idler factory, for C-api compatibility.

    :param func:
        function to call when system is idle.
        Expected signature::

            func(*args, **kargs): bool

    :return: a new Idler instance
    :rtype: efl.ecore.Idler

    """
    return Idler(func, *args, **kargs)


def idle_enterer_add(func, *args, **kargs):
    """efl.ecore.IdleEnterer factory, for C-api compatibility.

    :param func:
        Function to call when system enters idle.
        Expected signature::

            func(*args, **kargs): bool

    :return: a new IdleEnterer instance
    :rtype: efl.ecore.IdleEnterer
    """
    return IdleEnterer(func, *args, **kargs)


def idle_exiter_add(func, *args, **kargs):
    """efl.ecore.IdleExiter factory, for C-api compatibility.

    :param func:
        Function to call when system exits idle.
        Expected signature::

            func(*args, **kargs): bool

    :return: a new IdleExiter instance
    :rtype: efl.ecore.IdleExiter
    """
    return IdleExiter(func, *args, **kargs)
