# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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

:mod:`need` Module
##################

Description
===========

This functions are used to tell elementary of optionals modules usage.

"""


from efl.utils.deprecated cimport DEPRECATED


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
    return bool(elm_need_systray())

def need_sys_notify():
    """Request that your elementary application needs Elm_Sys_Notify

    This initializes the Elm_Sys_Notify when called and if support exists
    it returns True, otherwise returns False. This must be called
    before any elm_sys_notify calls.

    :return: True if support exists and initialization succeeded.
    :rtype: bool

    .. versionadded:: 1.8

    """
    return bool(elm_need_sys_notify())

@DEPRECATED("1.8", "Use :py:func:`need_eldbus` for eldbus (v2) support. Old API is deprecated.")
def need_e_dbus():
    """Request that your elementary application needs e_dbus

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
    return bool(elm_need_ethumb())

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
