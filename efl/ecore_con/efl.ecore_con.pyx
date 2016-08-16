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

"""

:mod:`efl.ecore_con` Module
###########################

The ecore_con module provide various utilities to perform different network
related tasks. Everything in a full async ecore way. Most notable are the
:class:`Lookup` class to perform DNS requests, the :class:`Url` class to
perform HTTP requests and the :class:`Server` class to implement your own
server.

Don't forget about the :class:`efl.ecore.FileDownload` class if what you need
is just to fetch some data to file.


Classes
=======

.. toctree::

   class-lookup.rst
   class-url.rst



Enumerations
============

.. _Ecore_Con_Type:

Ecore Con Type
--------------

Types for an ecore_con client/server object.

A correct way to set this type is with an ECORE_CON_$TYPE, optionally OR'ed
with an ECORE_CON_$USE if encryption is desired, and LOAD_CERT if the
previously loaded certificate should be used.

.. data:: ECORE_CON_LOCAL_USER

    Socket in ~/.ecore.

.. data:: ECORE_CON_LOCAL_SYSTEM

   Socket in /tmp.

.. data:: ECORE_CON_LOCAL_ABSTRACT

    Abstract socket.

.. data:: ECORE_CON_REMOTE_TCP

    Remote server using TCP.


.. data:: ECORE_CON_REMOTE_MCAST

    Remote multicast server.


.. data:: ECORE_CON_REMOTE_UDP

    Remote server using UDP.

.. data:: ECORE_CON_REMOTE_BROADCAST

    Remote broadcast using UDP.

.. data:: ECORE_CON_REMOTE_NODELAY

    Remote connection sending packets immediately.

.. data:: ECORE_CON_REMOTE_CORK

    Remote connection sending data in large chunks. (only on linux)

.. data:: ECORE_CON_USE_SSL2

    Use SSL2: UNSUPPORTED.

.. data:: ECORE_CON_USE_SSL3

    Use SSL3: UNSUPPORTED.

.. data:: ECORE_CON_USE_TLS

    Use TLS.

.. data:: ECORE_CON_USE_MIXED

    Use both TLS and SSL3.

.. data:: ECORE_CON_LOAD_CERT

    Attempt to use the loaded certificate.

.. data:: ECORE_CON_NO_PROXY

    Disable all types of proxy on the server.


.. _Ecore_Con_Url_Time:

Ecore Con Url Time
------------------

The type of condition to use when making an HTTP request dependent on time, so
that headers such as "If-Modified-Since" are used.

.. data:: ECORE_CON_URL_TIME_NONE

    Do not place time restrictions on the HTTP requests.

.. data:: ECORE_CON_URL_TIME_IFMODSINCE

   Add the "If-Modified-Since" HTTP header, so that the request is performed by
   the server only if the target has been modified since the time value passed
   to it in the request.

.. data:: ECORE_CON_URL_TIME_IFUNMODSINCE

    Add the "If-Unmodified-Since" HTTP header, so that the request is performed
    by the server only if the target has NOT been modified since the time value
    passed to it in the request.


.. _Ecore_Con_Url_Http_Version:

Ecore Con Url Http Version
--------------------------

The http version to use.

.. data:: ECORE_CON_URL_HTTP_VERSION_1_0

    HTTP version 1.0.

.. data:: ECORE_CON_URL_HTTP_VERSION_1_1

   HTTP version 1.1 (default)


Module level functions
======================

"""

from libc.stdint cimport uintptr_t
from cpython cimport PyUnicode_AsUTF8String, Py_INCREF, Py_DECREF

import traceback
import atexit


from efl.ecore cimport _event_mapping_register, _event_mapping_get, \
    ecore_event_handler_add, ecore_event_handler_del

cimport efl.ecore_con.enums as enums

ECORE_CON_LOCAL_USER = enums.ECORE_CON_LOCAL_USER
ECORE_CON_LOCAL_SYSTEM = enums.ECORE_CON_LOCAL_SYSTEM
ECORE_CON_LOCAL_ABSTRACT = enums.ECORE_CON_LOCAL_ABSTRACT
ECORE_CON_REMOTE_TCP = enums.ECORE_CON_REMOTE_TCP
ECORE_CON_REMOTE_MCAST = enums.ECORE_CON_REMOTE_MCAST
ECORE_CON_REMOTE_UDP = enums.ECORE_CON_REMOTE_UDP
ECORE_CON_REMOTE_BROADCAST = enums.ECORE_CON_REMOTE_BROADCAST
ECORE_CON_REMOTE_NODELAY = enums.ECORE_CON_REMOTE_NODELAY
ECORE_CON_REMOTE_CORK = enums.ECORE_CON_REMOTE_CORK
ECORE_CON_USE_SSL2 = enums.ECORE_CON_USE_SSL2
ECORE_CON_USE_SSL3 = enums.ECORE_CON_USE_SSL3
ECORE_CON_USE_TLS = enums.ECORE_CON_USE_TLS
ECORE_CON_USE_MIXED = enums.ECORE_CON_USE_MIXED
ECORE_CON_LOAD_CERT = enums.ECORE_CON_LOAD_CERT
ECORE_CON_NO_PROXY = enums.ECORE_CON_NO_PROXY
ECORE_CON_SOCKET_ACTIVATE = enums.ECORE_CON_SOCKET_ACTIVATE

ECORE_CON_URL_TIME_NONE = enums.ECORE_CON_URL_TIME_NONE
ECORE_CON_URL_TIME_IFMODSINCE = enums.ECORE_CON_URL_TIME_IFMODSINCE
ECORE_CON_URL_TIME_IFUNMODSINCE = enums.ECORE_CON_URL_TIME_IFUNMODSINCE

ECORE_CON_URL_HTTP_VERSION_1_0 = enums.ECORE_CON_URL_HTTP_VERSION_1_0
ECORE_CON_URL_HTTP_VERSION_1_1 = enums.ECORE_CON_URL_HTTP_VERSION_1_1


cdef int _con_events_registered = 0


def init():
    """Initialize the Ecore Con library

    .. note::
        You never need to call this function, it is automatically called when
        the module is imported.

    .. versionadded:: 1.17

    """

    ecore_con_init()
    ecore_con_url_init()

    global _con_events_registered
    if _con_events_registered == 0:
        _event_mapping_register(ECORE_CON_EVENT_URL_COMPLETE, EventUrlComplete)
        _event_mapping_register(ECORE_CON_EVENT_URL_PROGRESS, EventUrlProgress)
        _event_mapping_register(ECORE_CON_EVENT_URL_DATA, EventUrlData)
        _con_events_registered = 1


def shutdown():
    """Shuts down the Ecore Con library.

    .. note::
        You never need to call this function, it is automatically called atexit.

    .. versionadded:: 1.17

    """
    ecore_con_url_shutdown()
    ecore_con_shutdown()


cdef Eina_Bool _con_event_filter_cb(void *data, int ev_type, void *ev) with gil:
    cdef:
        ConEventFilter filter = <ConEventFilter>data
        object event_cls
        Event py_event
        list cbs
        Eo obj
        object func
        tuple args
        dict kargs

    # create correct "EventAbc" python object, using the global mapping
    event_cls = _event_mapping_get(ev_type)
    if event_cls:
        py_event = event_cls()

        # object_from_instance can fail in _set_obj if the event is
        # generated from an object not managed by us, so just ignore it.
        try:
            py_event._set_obj(ev)
        except:
            return 1

        # do we have callbacks for this object/event ?
        try:
            obj = py_event._get_obj()
            cbs = filter.callbacks.get(ev_type).get(obj)
        except:
            cbs = None

        if cbs:
            cbs = cbs[:] # copy, so we can change filter.callbacks
            for func, args, kargs in cbs:
                try:
                    func(py_event, *args, **kargs)
                except Exception:
                    traceback.print_exc()

    return 1 # always return true, no matter what

cdef class ConEventFilter(object):

    """
    self.callbacks = {
        EV_TYPE: {
            objX: [(cb,args,kargs), ... ]
            objY: [(cb,args,kargs), ... ]
        },
        ...
    }
    """

    def __cinit__(self):
        self.callbacks = {}
        self.handlers = {}

    cdef callback_add(self, int ev_type, Eo obj, object func, tuple args, dict kargs):
        # store the function in the callbacks dict
        if not ev_type in self.callbacks:
            self.callbacks[ev_type] = {}
        if not obj in self.callbacks[ev_type]:
            self.callbacks[ev_type][obj] = []
        self.callbacks[ev_type][obj].append((func,args,kargs))

        # connect a single ecore signal, one per event_type
        cdef Ecore_Event_Handler* ee
        if not ev_type in self.handlers:
            ee = ecore_event_handler_add(ev_type, _con_event_filter_cb,
                                         <void *>self)
            self.handlers[ev_type] = <uintptr_t><void *>ee

    cdef callback_del(self, int ev_type, Eo obj, object func, tuple args, dict kargs):
        try:
            self.callbacks[ev_type][obj].remove((func, args, kargs))
        except ValueError:
            raise ValueError(
                "callback is not registered: %s, args=%s, kargs=%s" %
                (func, args, kargs))

        # can delete the ecore handler?
        if self.callbacks.get(ev_type) and self.callbacks.get(ev_type).get(obj):
            return
        if ev_type in self.handlers:
            handler = self.handlers.pop(ev_type)
            ecore_event_handler_del(<Ecore_Event_Handler *><uintptr_t>handler)

    cdef callback_del_full(self, Eo obj):
        for ev_type in self.callbacks:
            if obj in self.callbacks[ev_type]:
                # remove all the cbs for the obj
                self.callbacks[ev_type].pop(obj, None)

                # can delete the ecore handler?
                if len(self.callbacks[ev_type]) < 1 and ev_type in self.handlers:
                    handler = self.handlers.pop(ev_type)
                    ecore_event_handler_del(<Ecore_Event_Handler *><uintptr_t>handler)

# name suggestions are welcome for this unusual "singleton" instance
cdef ConEventFilter GEF = ConEventFilter()


include "efl.ecore_con_lookup.pxi"
include "efl.ecore_con_url.pxi"


init()
atexit.register(shutdown)
