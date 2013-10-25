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
        if wrapper.__doc__ is not None and self.version is not None:
            wrapper.__doc__ += "\n\n.. deprecated:: %s\n    %s\n" % (self.version, self.message)

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
            object stack
            tuple caller
            str msg

        stack = traceback.extract_stack()
        caller = stack[-1]
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
