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


cdef void _con_dns_lookup_cb(const char *canonname, const char *ip, sockaddr *sockaddr, int addrlen, void *data) with gil:
    cdef Lookup self = <Lookup>data

    try:
        # TODO read sockaddr and replace the placeholder None with something
        #      more usefull from the sockaddr struct.
        self.done_cb(_ctouni(canonname), _ctouni(ip), None, *self.args, **self.kargs)
    except Exception:
        traceback.print_exc()

    Py_DECREF(self)


cdef class Lookup(object):
    def __init__(self, name, done_cb, *args, **kargs):
        """Lookup()

        A simple class to perform asynchronous DNS lookups.

        :param string name: The hostname to query
        :param callable done_cb: The function to call when done
        :param \*args: Any other arguments will be passed back in ``done_cb``
        :param \**kargs: Any other keywords arguments will be passed back in ``done_cb``

        .. versionadded:: 1.17

        Just create an instance and give a callback function to be called
        when the operation is complete.

        This class performs a DNS lookup on the hostname specified by
        `name`, then calls `done_cb` with the result and the data given as
        parameter. The result will be given to the done_cb as follows:

        **expected `done_cb` signature**::

            func(canonname, ip, sockaddr)

        where:
            * **canonname** (string) is the canonical domain name
            * **ip** (string) is the recolved ip address
            * **sockaddr** (None) is a placeholder for future expansion



        **Usage example**::

            import ecore_con

            def done_cb(canonname, ip, sockaddr):
                print(canonname)
                print(ip)

            ecore_con.Lookup('example.com', done_cb)

        
        """

        if not callable(done_cb):
            raise TypeError("Parameter 'done_cb' must be callable")

        self.done_cb = done_cb
        self.args = args
        self.kargs = kargs

        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        ecore_con_lookup(<const char *>name if name is not None else NULL,
                         _con_dns_lookup_cb, <void*>self)

        Py_INCREF(self)

