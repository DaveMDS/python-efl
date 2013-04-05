# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

EDBus is a wrapper around the
`dbus <http://www.freedesktop.org/wiki/Software/dbus>`_
library, which is a message bus system. It also implements a set of
specifications using dbus as interprocess communication.

"""
cimport enums

EDBUS_CONNECTION_TYPE_UNKNOWN = enums.EDBUS_CONNECTION_TYPE_UNKNOWN
EDBUS_CONNECTION_TYPE_SESSION = enums.EDBUS_CONNECTION_TYPE_SESSION
EDBUS_CONNECTION_TYPE_SYSTEM = enums.EDBUS_CONNECTION_TYPE_SYSTEM
EDBUS_CONNECTION_TYPE_STARTER = enums.EDBUS_CONNECTION_TYPE_STARTER
EDBUS_CONNECTION_TYPE_LAST = enums.EDBUS_CONNECTION_TYPE_LAST

def module_cleanup():
    edbus_shutdown()

edbus_init()
atexit.register(module_cleanup)

