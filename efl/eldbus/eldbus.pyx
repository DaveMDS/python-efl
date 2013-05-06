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

Eldbus is a wrapper around the
`dbus <http://www.freedesktop.org/wiki/Software/dbus>`_
library, which is a message bus system. It also implements a set of
specifications using dbus as interprocess communication.

"""

from cpython cimport PyUnicode_AsUTF8String

def module_cleanup():
    eldbus_shutdown()

eldbus_init()
atexit.register(module_cleanup)

include "connection.pxi"
include "message.pxi"
include "signal_handler.pxi"
include "pending.pxi"
include "object.pxi"
include "proxy.pxi"
include "freedesktop.pxi"
include "service.pxi"
