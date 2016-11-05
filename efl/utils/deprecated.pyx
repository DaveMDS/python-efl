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


import functools


class DEPRECATED(object):

    def __init__(self, version, message):
        self.version = version
        self.message = message

    def __call__(self, func_or_meth):

        # This wrapper will be called instead of the original one
        def wrapper(*args, **kwargs):

            print("WARNING: Deprecated function '{0}' called. {1}".format(
                  func_or_meth.__name__, self.message))

            return func_or_meth(*args, **kwargs)

        # copy metadata from original func
        assignments = ["__name__", "__doc__"]
        if hasattr(func_or_meth, "__module__"):
            assignments.append("__module__")
        functools.update_wrapper(wrapper, func_or_meth, assigned=assignments)

        # Augment the function doc with the sphinx deprecated tag
        doc = wrapper.__doc__
        if doc is not None:
            lines = doc.expandtabs().splitlines()

            indent = 0
            if len(lines) >= 2:
                for line in lines[1:]:
                    stripped = line.lstrip()
                    if stripped:
                        indent = len(line) - len(stripped)
                        break

            wrapper.__doc__ += \
                "\n\n" \
                "{indent}.. deprecated:: {version}\n" \
                "{indent}    {message}\n".format(
                indent=indent * " ", version=self.version, message=self.message)

        return wrapper

