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


cdef object _event_type_mapping = dict()

cdef object _event_mapping_register(int type, cls):
    if type in _event_type_mapping:
        raise ValueError("event type '%d' already registered." % type)
    if not issubclass(cls, Event):
        raise TypeError("cls (%s) must be subclass of Event" % cls)
    _event_type_mapping[type] = cls


cdef object _event_mapping_unregister(int type):
    _event_type_mapping.pop(type)

cdef object _event_mapping_get(int type):
    if not type in _event_type_mapping:
        raise ValueError("event type '%d' not registered." % type)
    return _event_type_mapping.get(type)


cdef Eina_Bool event_handler_cb(void *data, int type, void *event) with gil:
    cdef EventHandler handler
    cdef Eina_Bool r

    #assert event != NULL
    assert data != NULL, "data should not be NULL!"
    handler = <EventHandler>data
    assert type == handler.type, "handler type isn't the same as event type!"

    try:
        r = handler._exec(event)
    except Exception:
        traceback.print_exc()
        r = 0

    if not r:
        handler.delete()
    return r


cdef class Event(object):
    def __init__(self):
        if type(self) is Event:
            raise TypeError("Must not instantiate Event, but subclasses")

    def __str__(self):
        attrs = []
        for attr in dir(self):
            if not attr.startswith("_"):
                attrs.append("%s=%r" % (attr, getattr(self, attr)))
        return "%s(%s)" % (self.__class__.__name__, ", ".join(attrs))

    cdef int _set_obj(self, void *obj) except 0:
        raise NotImplementedError("Event._set_obj() not implemented.")

    cdef object _get_obj(self):
        raise NotImplementedError("Event._get_obj() not implemented.")


cdef class EventHandler(object):
    def __init__(self, int type, func, *args, **kargs):
        """:parm type: event type, as registered with ecore_event_type_new()."""
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        event_cls = _event_type_mapping.get(type, None)
        if event_cls is None:
            raise ValueError("Unknown Ecore_Event type %d" % type)
        self.type = type
        self.event_cls = event_cls
        self.func = func
        self.args = args
        self.kargs = kargs
        self._set_obj(ecore_event_handler_add(type, event_handler_cb,
                                              <void *>self))

    def __str__(self):
        return "%s(type=%d, func=%s, args=%s, kargs=%s, event_cls=%s)" % \
               (self.__class__.__name__, self.type,
                self.func, self.args, self.kargs, self.event_cls)

    def __repr__(self):
        return ("%s(%#x, type=%d, func=%s, args=%s, kargs=%s, event_cls=%s, "
                "Ecore_Event_Handler=%#x, refcount=%d)") % \
               (self.__class__.__name__, <uintptr_t><void *>self,
                self.type, self.func, self.args, self.kargs, self.event_cls,
                <uintptr_t>self.obj, PY_REFCOUNT(self))

    def __dealloc__(self):
        if self.obj != NULL:
            ecore_event_handler_del(self.obj)

    cdef int _set_obj(self, Ecore_Event_Handler *obj) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set NULL as object"
        self.obj = obj
        Py_INCREF(self)
        return 1

    cdef int _unset_obj(self) except 0:
        if self.obj != NULL:
            ecore_event_handler_del(self.obj)
            self.obj = NULL
            self.event_cls = None
            self.func = None
            self.args = None
            self.kargs = None
            Py_DECREF(self)
        return 1

    cdef Eina_Bool _exec(self, void *event) except 2:
        cdef Event e
        e = self.event_cls()
        e._set_obj(event)
        return bool(self.func(e, *self.args, **self.kargs))

    def delete(self):
        if self.obj != NULL:
            self._unset_obj()

    def stop(self):
        self.delete()


def event_handler_add(int type, func, *args, **kargs):
    return EventHandler(type, func, *args, **kargs)


cdef class EventSignalUser(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Signal_User *obj
        obj = <Ecore_Event_Signal_User*>o
        self.number = obj.number
        return 1

    def __str__(self):
        return "%s(number=%d)" % (self.__class__.__name__, self.number)

    def __repr__(self):
        return "%s(number=%d)" % (self.__class__.__name__, self.number)


cdef class EventSignalUser1(EventSignalUser):
    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


cdef class EventSignalUser2(EventSignalUser):
    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


cdef class EventHandlerSignalUser(EventHandler):
    def __init__(self, func, *args, **kargs):
        EventHandler.__init__(self, enums.ECORE_EVENT_SIGNAL_USER,
                              func, *args, **kargs)

    cdef Eina_Bool _exec(self, void *event) except 2:
        cdef Ecore_Event_Signal_User *obj = <Ecore_Event_Signal_User *>event
        cdef EventSignalUser e
        if obj.number == 1:
            e = EventSignalUser1()
        elif obj.number == 2:
            e = EventSignalUser2()
        else:
            e = EventSignalUser()
        e._set_obj(event)
        return bool(self.func(e, *self.args, **self.kargs))


def on_signal_user(func, *args, **kargs):
    return EventHandlerSignalUser(func, *args, **kargs)


cdef class EventSignalHup(Event):
    cdef int _set_obj(self, void *o) except 0:
        return 1

    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


def on_signal_hup(func, *args, **kargs):
    return EventHandler(enums.ECORE_EVENT_SIGNAL_HUP, func, *args, **kargs)


cdef class EventSignalExit(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Signal_Exit *obj
        obj = <Ecore_Event_Signal_Exit*>o
        self.interrupt = bool(obj.interrupt)
        self.quit = bool(obj.quit)
        self.terminate = bool(obj.terminate)
        return 1

    def __str__(self):
        return "%s(interrupt=%s, quit=%s, terminate=%s)" % \
            (self.__class__.__name__, self.interrupt, self.quit, self.terminate)

    def __repr__(self):
        return "%s(interrupt=%s, quit=%s, terminate=%s)" % \
            (self.__class__.__name__, self.interrupt, self.quit, self.terminate)


cdef class EventSignalQuit(EventSignalExit):
    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


cdef class EventSignalInterrupt(EventSignalExit):
    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


cdef class EventSignalTerminate(EventSignalExit):
    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


cdef class EventHandlerSignalExit(EventHandler):
    def __init__(self, func, *args, **kargs):
        EventHandler.__init__(self, enums.ECORE_EVENT_SIGNAL_EXIT,
                              func, *args, **kargs)

    cdef Eina_Bool _exec(self, void *event) except 2:
        cdef Ecore_Event_Signal_Exit *obj = <Ecore_Event_Signal_Exit *>event
        cdef EventSignalExit e
        if obj.terminate:
            e = EventSignalTerminate()
        elif obj.interrupt:
            e = EventSignalInterrupt()
        elif obj.quit:
            e = EventSignalQuit()
        else:
            e = EventSignalExit()
        e._set_obj(event)
        return bool(self.func(e, *self.args, **self.kargs))


def on_signal_exit(func, *args, **kargs):
    return EventHandlerSignalExit(func, *args, **kargs)


cdef class EventSignalPower(Event):
    cdef int _set_obj(self, void *o) except 0:
        return 1

    def __str__(self):
        return "%s()" % (self.__class__.__name__,)

    def __repr__(self):
        return "%s()" % (self.__class__.__name__,)


def on_signal_power(func, *args, **kargs):
    return EventHandler(enums.ECORE_EVENT_SIGNAL_POWER, func, *args, **kargs)


cdef class EventSignalRealtime(Event):
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Signal_Realtime *obj
        obj = <Ecore_Event_Signal_Realtime*>o
        self.num = obj.num
        return 1

    def __str__(self):
        return "%s(num=%d)" % (self.__class__.__name__, self.num)

    def __repr__(self):
        return "%s(num=%d)" % (self.__class__.__name__, self.num)


def on_signal_realtime(func, *args, **kargs):
    return EventHandler(enums.ECORE_EVENT_SIGNAL_REALTIME, func, *args, **kargs)


cdef class CustomEvent(Event):
    cdef int _set_obj(self, void *obj) except 0:
        self.obj = <object>obj
        return 1

def event_type_new(cls):
    cdef int type

    type = ecore_event_type_new()

    _event_mapping_register(type, cls)

    return type


cdef void _event_free_cb(void *data, void *event) with gil:
    cdef QueuedEvent ev

    ev = <QueuedEvent>data
    ev._free()


cdef class QueuedEvent(object):
    def __init__(self, int type, *args):
        self.args = args
        self._set_obj(ecore_event_add(type, <void *>self.args, _event_free_cb,
                      <void*>self))

    cdef int _set_obj(self, Ecore_Event *ev) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert ev != NULL, "Cannot set NULL as object"
        self.obj = ev
        Py_INCREF(self)
        return 1

    cdef int _unset_obj(self) except 0:
        if self.obj != NULL:
            self.obj = NULL
            self.args = None
            Py_DECREF(self)
        return 1

    def _free(self):
        self._unset_obj()

    def delete(self):
        ecore_event_del(self.obj)

def event_add(int type, *args):
    return QueuedEvent(type, args)
