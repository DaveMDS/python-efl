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

import traceback
import types
from functools import update_wrapper

from cpython cimport PY_VERSION_HEX, PyUnicode_AsUTF8String

from efl.eina cimport EINA_LOG_DOM_WARN
from efl.utils.logger cimport PY_EFL_LOG_DOMAIN

cdef class DEPRECATED(object):

    def __init__(self, version=None, message=None):
        self.version = version
        self.message = message

    def __call__(self, f):
        wrapper = WRAPPER(f, self.version, self.message)

        assignments = ["__name__", "__doc__"]
        if hasattr(f, "__module__"):
            assignments.append("__module__")
        update_wrapper(wrapper, f, assigned=assignments)

        # Version is required for the deprecated directive

        doc = wrapper.__doc__

        if doc is not None and self.version is not None:
            lines = doc.expandtabs().splitlines()

            indent = 0
            if len(lines) >= 2:
                for line in lines[1:]:
                    stripped = line.lstrip()
                    if stripped:
                        indent = len(line) - len(stripped)
                        break

            wrapper.__doc__ += "\n\n"

            wrapper.__doc__ += indent * " " + ".. deprecated:: %s\n" % (self.version,)

            wrapper.__doc__ += (indent + 4) * " " + "%s\n" % (self.message,)

        return wrapper


class WRAPPER(object):
    def __init__(self, f, version, message):
        self.f = f
        self.version = version
        self.message = message

    def __get__(self, obj, objtype):
        if PY_VERSION_HEX < 0x03000000:
            return types.MethodType(self, obj, objtype)
        else:
            return types.MethodType(self, obj)

    def __call__(self, *args, **kwargs):
        cdef:
            list stack
            tuple caller
            str msg

        stack = list(traceback.extract_stack())
        caller = tuple(stack[-1])
        caller_module, caller_line, caller_name, caller_code = caller
        if caller_code is not None:
            if hasattr(self.f, "__objclass__"):
                msg = "Deprecated method %s of class %s called in %s:%s %s." % \
                    (self.f.__name__, self.f.__objclass__.__name__, caller_module, caller_line, caller_code)
            else:
                msg = "Deprecated function %s called in %s:%s %s." % \
                    (self.f.__name__, caller_module, caller_line, caller_code)
        else:
            msg = "Deprecated function %s called in %s:%s." % \
                (self.f.__name__, caller_module, caller_line)

        if self.message is not None:
            msg += " " + self.message

        msg2 = msg
        if isinstance(msg2, unicode): msg2 = PyUnicode_AsUTF8String(msg2)

        EINA_LOG_DOM_WARN(PY_EFL_LOG_DOMAIN, msg2, NULL)

        return self.f(*args, **kwargs)
