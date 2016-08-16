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

:mod:`efl.ecore_input` Module
#############################

.. versionadded:: 1.17

This module provide access to the low-level input events, you usually
don't need to use this stuff, unless you need some sort of custom event
handling.

To be informed about specific events just use one of the
on_*_add(func, \*args, \**kargs) functions, the callback given will be fired
when events occur.

Callback signature is::

    func(event, *args, **kargs) → int

Where ``event`` will be a class relative to the specific event (such as
:class:`EventKey`) All the additional arguments and keyword arguments passed
in the \*_add function will be passed back in the callback.

In some events (EventKey at least) the callback function may return
ecore.ECORE_CALLBACK_DONE or ecore.ECORE_CALLBACK_PASS_ON to block the
event propagation down the chain or not.

To stop receiving event use :func:`efl.ecore.EventHandler.delete`


Enumerations
============

.. _Ecore_Event_Modifier:

Ecore_Event_Modifier
--------------------

.. data:: ECORE_EVENT_MODIFIER_SHIFT

.. data:: ECORE_EVENT_MODIFIER_CTRL

.. data:: ECORE_EVENT_MODIFIER_ALT

.. data:: ECORE_EVENT_MODIFIER_WIN

.. data:: ECORE_EVENT_MODIFIER_SCROLL

.. data:: ECORE_EVENT_MODIFIER_NUM

.. data:: ECORE_EVENT_MODIFIER_CAPS

.. data:: ECORE_EVENT_LOCK_SCROLL

.. data:: ECORE_EVENT_LOCK_NUM

.. data:: ECORE_EVENT_LOCK_CAPS

.. data:: ECORE_EVENT_LOCK_SHIFT

.. data:: ECORE_EVENT_MODIFIER_ALTGR


Classes and Functions
=====================

"""


import atexit
import traceback

cimport efl.ecore_input.enums as enums

def init():
    """ Initialize the Ecore Input library

    .. note:: You never need to call this, it is automatically called at module
              import
    """
    ecore_event_init()
    _ecore_input_events_register()

def shutdown():
    """ Shutdown the Ecore Input library.

    .. note:: You never need to call this, it is automatically called at exit

    """
    ecore_event_shutdown()


include "efl.ecore_input_events.pxi"

init()
atexit.register(shutdown)
