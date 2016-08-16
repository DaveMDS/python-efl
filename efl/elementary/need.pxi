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

include "need_cdef.pxi"


cdef class SysNotifyNotificationClosed(Event):

    cdef Elm_Sys_Notify_Notification_Closed *obj

    cdef int _set_obj(self, void *o) except 0:
        self.obj = <Elm_Sys_Notify_Notification_Closed*>o
        return 1

    def __repr__(self):
        # TODO: int -> string for 'reason'
        return "<%s(id=%d, reason=%s)>" % \
            (type(self).__name__, self.id, self.reason)

    property id:
        """ID of the notification.

        :type: int

        """
        def __get__(self):
            return self.obj.id

    property reason:
        """The Reason the notification was closed.

        :type: :ref:`Elm_Sys_Notify_Closed_Reason`

        """
        def __get__(self):
            return self.obj.reason


cdef class SysNotifyActionInvoked(Event):

    cdef Elm_Sys_Notify_Action_Invoked *obj

    cdef int _set_obj(self, void *o) except 0:
        self.obj = <Elm_Sys_Notify_Action_Invoked*>o
        return 1

    def __repr__(self):
        return "<%s(id=%d, action_key=%s)>" % \
            (type(self).__name__, self.id, self.action_key)

    property id:
        """ID of the notification.

        :type: int

        """
        def __get__(self):
            return self.obj.id

    property action_key:
        """The key of the action invoked. These match the keys sent over in the
        list of actions.

        :type: string

        """
        def __get__(self):
            return _touni(self.obj.action_key)


cdef class EthumbConnect(Event):
    cdef int _set_obj(self, void *o) except 0:
        return 1

    def __repr__(self):
        return "<%s()>" % (self.__class__.__name__,)

cdef class EventSystrayReady(Event):
    cdef int _set_obj(self, void *o) except 0:
        return 1

    def __repr__(self):
        return "<%s()>" % (self.__class__.__name__,)


def need_efreet():
    """Request that your elementary application needs Efreet

    This initializes the Efreet library when called and if support exists
    it returns True, otherwise returns False. This must be called
    before any efreet calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    """
    return bool(elm_need_efreet())

def need_systray():
    """Request that your elementary application needs Elm_Systray

    This initializes the Elm_Systray when called and, if support exists,
    returns True, otherwise returns False. This must be called
    before any elm_systray calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    .. versionadded:: 1.8

    """
    cdef bint ret = elm_need_systray()
    if ret:
        try:
            _event_mapping_register(enums.ELM_EVENT_SYSTRAY_READY, EventSystrayReady)
        except ValueError:
            pass
    return ret

def need_sys_notify():
    """Request that your elementary application needs Elm_Sys_Notify

    This initializes the Elm_Sys_Notify when called and if support exists
    it returns True, otherwise returns False. This must be called
    before any elm_sys_notify calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    .. versionadded:: 1.8

    """
    cdef bint ret = elm_need_sys_notify()
    if ret:
        try:
            _event_mapping_register(
                enums.ELM_EVENT_SYS_NOTIFY_NOTIFICATION_CLOSED,
                SysNotifyNotificationClosed
                )
            _event_mapping_register(
                enums.ELM_EVENT_SYS_NOTIFY_ACTION_INVOKED,
                SysNotifyActionInvoked
                )
        except ValueError:
            pass
    return ret

@DEPRECATED("1.8", "Use :py:func:`need_eldbus` for eldbus (v2) support. Old API is deprecated.")
def need_e_dbus():
    """
    Request that your elementary application needs e_dbus

    This initializes the e_dbus library when called and if support exists
    it returns True, otherwise returns False. This must be called
    before any e_dbus calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    """
    return bool(elm_need_eldbus())

def need_eldbus():
    """Request that your elementary application needs eldbus

    This initializes the edbus (aka v2) library when called and if
    support exists it returns True, otherwise returns
    False. This must be called before any edbus calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    .. versionadded:: 1.8

    """
    return bool(elm_need_eldbus())

def need_elocation():
    """Request that your elementary application needs elocation

    This initializes the elocation library when called and if
    support exists it returns True, otherwise returns
    False. This must be called before any elocation usage.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    .. versionadded:: 1.8

    """
    return bool(elm_need_elocation())

def need_ethumb():
    """Request that your elementary application needs ethumb

    This initializes the Ethumb library when called and if support exists
    it returns True, otherwise returns False.
    This must be called before any other function that deals with
    elm_thumb objects or ethumb_client instances.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    """
    cdef bint ret = elm_need_ethumb()
    try:
        _event_mapping_register(enums.ELM_ECORE_EVENT_ETHUMB_CONNECT, EthumbConnect)
    except ValueError:
        pass
    return ret

def need_web():
    """Request that your elementary application needs web support

    This initializes the Ewebkit library when called and if support exists
    it returns True, otherwise returns False.
    This must be called before any other function that deals with
    elm_web objects or ewk_view instances.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    """
    return bool(elm_need_web())
