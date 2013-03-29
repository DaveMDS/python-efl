from libc.stdlib cimport malloc, free
from libc.string cimport strdup
from efl cimport eina_list_free

cdef class Uri(object):
    """

    Contains the methods used to support the FDO URI specification.

    """

    def __cinit__(self):
        self.uri = <Efreet_Uri *>malloc(3 * sizeof(const_char *))
        self.uri.protocol = NULL
        self.uri.hostname = NULL
        self.uri.path = NULL

    def __init__(self, protocol = None, hostname = None, path = None):
        if protocol is not None:
            self.protocol = protocol
        if hostname is not None:
            self.hostname = hostname
        if path is not None:
            self.path = path

    def __dealloc__(self):
        efreet_uri_free(self.uri)

    @classmethod
    def decode(cls, val):
        """decode(unicode val)

        Read a single uri and return an EfreetUri. If there's no
        hostname in the uri then the hostname parameter will be None. All
        the uri escaped chars will be converted to normal.

        """
        cdef Uri ret
        ret = cls.__new__(cls)
        ret.uri = efreet_uri_decode(_cfruni(val))
        return ret

    def encode(self):
        """encode() -> unicode

        Get the string representation of the given uri struct escaping
        illegal characters.

        .. note::

            The resulting string will contain the protocol and the path but not
            the hostname, as many apps can't handle it.

        :param uri: Create an URI string from an Efreet_Uri struct
        :return: The string representation of uri ``(ex: 'file:///home/my%20name')``

        """
        cdef const_char *s = efreet_uri_encode(self.uri)
        ret = _ctouni(s)
        eina_stringshare_del(s)
        return ret

    property protocol:
        """The protocol used (usually 'file')"""
        def __set__(self, value):
            if self.uri.protocol != NULL:
                eina_stringshare_del(self.uri.protocol)
            self.uri.protocol = eina_stringshare_add(_cfruni(value))

        def __get__(self):
            return _ctouni(self.uri.protocol)

    property hostname:
        """The name of the host, if any"""
        def __set__(self, value):
            if self.uri.hostname != NULL:
                eina_stringshare_del(self.uri.hostname)
            self.uri.hostname = eina_stringshare_add(_cfruni(value))

        def __get__(self):
            return _ctouni(self.uri.hostname)

    property path:
        """The full file path without protocol nor host"""
        def __set__(self, value):
            if self.uri.path != NULL:
                eina_stringshare_del(self.uri.path)
            self.uri.path = eina_stringshare_add(_cfruni(value))

        def __get__(self):
            return _ctouni(self.uri.path)
