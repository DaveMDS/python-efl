import traceback
import types
from functools import update_wrapper


class DEPRECATED(object):

    def __init__(self, object f):
        self.f = f

        assignments = ["__name__", "__doc__"]
        if hasattr(f, "__module__"):
            assignments.append("__module__")
        update_wrapper(self, f, assigned=assignments)

        #if hasattr(f, "__objclass__"):
            #print("WARNING: method %s.%s is deprecated" % (f.__objclass__.__name__, f.__name__))
        #else:
            #print("WARNING: function %s is deprecated" % (f.__name__))

    def __get__(self, obj, objtype):
        return types.MethodType(self, obj, objtype)

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
                msg = "WARNING: Deprecated method %s of class %s called in %s:%s %s." % \
                    (self.f.__name__, self.f.__objclass__.__name__, caller_module, caller_line, caller_code)
            else:
                msg = "WARNING: Deprecated function %s called in %s:%s %s." % \
                    (self.f.__name__, caller_module, caller_line, caller_code)
        else:
            msg = "WARNING: Deprecated function %s.%s called in %s:%s." % \
                (self.f.__name__, caller_name, caller_module, caller_line)
        print(msg)

        return self.f(*args, **kwargs)
