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

# from efl.ecore cimport EventHandler
# from efl.utils.conversions cimport _ctouni as _charp_to_str



cdef class EventUrlProgress(Event):
    """Represents Ecore_Con_Event_Url_Progress event from C-api.

    This event notifies the progress of the current operation.

    attributes:
        * url (:class:`Url`): the object that generate the event
        * down_total(double): total size of the downloading data (in bytes)
        * down_now(double): current size of the downloading data (in bytes) 
        * up_total(double): total size of the uploading data (in bytes)
        * up_now(double): current size of the uploading data (in bytes) 

    """
    cdef int _set_obj(self, void *ev) except 0:
        cdef Ecore_Con_Event_Url_Progress *event
        event = <Ecore_Con_Event_Url_Progress*>ev

        self.url = object_from_instance(event.url_con)
        self.down_total = event.down.total
        self.down_now = event.down.now
        self.up_total = event.up.total
        self.up_now = event.up.now
        return 1

    cdef object _get_obj(self):
        return self.url

cdef class EventUrlComplete(Event):
    """Represents Ecore_Con_Event_Url_Complete event from C-api.

    This event notifies the operation is completed.

    attributes:
        * url (:class:`Url`): the object that generate the event
        * status(int): HTTP status code of the operation (200, 404, 401, etc.)

    """
    cdef int _set_obj(self, void *ev) except 0:
        cdef Ecore_Con_Event_Url_Complete *event
        event = <Ecore_Con_Event_Url_Complete*>ev

        self.url = object_from_instance(event.url_con)
        self.status = event.status
        return 1

    cdef object _get_obj(self):
        return self.url

cdef class EventUrlData(Event):
    """Represents Ecore_Con_Event_Url_Data event from C-api.

    This event hold the data while the are received.

    .. note::
        The data attribute is a raw series of bytes, map to ``str`` in python2
        and ``bytes`` in python3.

    attributes:
        * url (:class:`Url`): the object that generate the event
        * size(int): the size of the current received data (in bytes)
        * data(bytes): the data received on this event

    """
    cdef int _set_obj(self, void *ev) except 0:
        cdef Ecore_Con_Event_Url_Data *event
        event = <Ecore_Con_Event_Url_Data*>ev

        self.url = object_from_instance(event.url_con)
        self.size = event.size
        self.data = event.data[:event.size] #raw string copy
        return 1
    
    cdef object _get_obj(self):
        return self.url


cdef class Url(Eo):
    """

    Utility class to make it easy to perform http requests (POST, GET, etc).

    .. versionadded:: 1.17

    Brief usage:
        1. Create an :class:`Url` object with ecore_con.Url('myurl')
        2. Register object callbacks using :func:`on_complete_event_add`,
           :func:`on_progress_event_add` and :func:`on_data_event_add` to
           receive the response, e.g. for HTTP/FTP downloads.
        3. Perform the operation with :func:`get`, :func:`head` and :func:`post`

    If it's necessary use the :attr:`url` property. to change the object url. 

    .. note::
        It is good practice to reuse :class:`Url` objects wherever possible,
        but bear in mind that each one can only perform one operation at a
        time. You need to wait for the complete event before re-using or
        destroying the object.

    .. warning::
        It is **really important** to call the :func:`delete()` method as soon
        as you have finished with your object, as it automatically remove all
        the registered events for you, that will otherwise continue to use
        resources.

    Basic usage examples::

        # HTTP GET
        u = ecore.Url("http://www.google.com")
        u.get()

        # HTTP POST
        u = ecore.Url('https://httpbin.org/post')
        u.post(b'my data to post', 'text/txt')

        # FTP download
        u = ecore.Url("ftp://ftp.example.com/pub/myfile")
        u.get()

        # FTP upload as ftp://ftp.example.com/file
        u = ecore.Url("ftp://ftp.example.com")
        u.ftp_upload("/tmp/file", "user", "pass", None)

        # FTP upload as ftp://ftp.example.com/dir/file
        u = ecore.Url("ftp://ftp.example.com")
        u.ftp_upload("/tmp/file", "user", "pass", "dir")

    To actually make something usefull with your request you will need to
    connect the :class:`EventUrlComplete`, :class:`EventUrlProgress` and
    :class:`EventUrlData` events using the :func:`on_complete_event_add` and
    friends functions.

    A more complete example::

        from efl import ecore

        def on_data(event):
            print("data: " + str(event.data[:80]))
            # do something here with the received data

        def on_progress(event):
            # print(event)
            print("received %d on a total of %d bytes" % (
                   event.down_now, event.down_total))

        def on_complete(event):
            # print(event)
            print("http result: %d" % event.status)
            print("Total received bytes: %d" % event.url.received_bytes)

            u.delete() # don't forget to delete !!

        u = ecore.Url('http://www.google.com', verbose=False)
        u.on_data_event_add(on_data)
        u.on_progress_event_add(on_progress)
        u.on_complete_event_add(on_complete)
        u.get()

        ecore.main_loop_begin()

    If you need  to save the received data to a file use the :attr:`fd`
    property, as::

        fd = open('/tmp/tmpMxBtta', 'w')
        u = ecore.Url('http://example.com', fd=fd.fileno())
        u.get()

    .. seealso::
        If you just need to download a file please consider using the
        simpler :class:`efl.ecore.FileDownload` class instead.

    .. seealso::
        The ecore module level functions :func:`url_pipeline_set` and
        :func:`url_pipeline_get` to enable HTTP 1.1 pipelining.

    """
    def __init__(self, url, custom_request=None, **kargs):
        """Url(...)

        :param url: URL that will receive requests.
        :type url: string
        :param custom_request: Custom request (e.g. GET, POST, HEAD, PUT, HEAD,
                               SUBSCRIBE and other obscure HTTP requests)
        :type custom_request: string
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        .. versionadded:: 1.17

        """
        if isinstance(url, unicode): url = PyUnicode_AsUTF8String(url)
        if custom_request is None:
            self._set_obj(ecore_con_url_new(
                <const char *>url if url is not None else NULL))
        else:
            if isinstance(custom_request, unicode):
                custom_request = PyUnicode_AsUTF8String(custom_request)
            self._set_obj(ecore_con_url_custom_new(
                <const char *>url if url is not None else NULL,
                <const char *>custom_request if custom_request is not None else NULL))
    
        self._set_properties_from_keyword_args(kargs)

    def __repr__(self):
        return "%s(url=%s)" % (self.__class__.__name__, self.url)

    def delete(self):
        """Delete the :class:`Url` object and free all used resources.

        .. note::
            This is **really important** to call as soon as you have finished
            with your object, as it automatically remove all the registered
            events. That will otherwise continue to use resources.

        """
        GEF.callback_del_full(self)
        ecore_con_url_free(self.obj)

    property fd:
        """Set up a file to have response data written into.

        This attr can be used to easily setup a file where the downloaded data
        will be saved.

        Note that :class:`EventUrlData` events will not be emitted if a file
        has been set to receive the response data.

        .. seealso::
            If you just need to download a file please consider using the
            simpler :class:`efl.ecore.FileDownload` class instead.

        :type: int (**writeonly**)

        """
        def __set__(self, int fd):
            ecore_con_url_fd_set(self.obj, fd)

    def get(self):
        """Send a GET request.

        The request is performed immediately, but you need to setup event
        handlers with :func:`on_complete_event_add` or
        :func:`on_complete_event_add` to get more information about its result.

        :return: ``True`` on success, ``False`` on error.
        
        """
        return bool(ecore_con_url_get(self.obj))

    def head(self):
        """Send a HEAD request.

        The request is performed immediately, but you need to setup event
        handlers with :func:`on_complete_event_add` or
        :func:`on_complete_event_add` to get more information about its result.

        :return: ``True`` on success, ``False`` on error.
        
        """
        return bool(ecore_con_url_head(self.obj))

    def post(self, bytes data, content_type):
        """Send a post request.
        
        The request is performed immediately, but you need to setup event
        handlers with :func:`on_complete_event_add` or
        :func:`on_complete_event_add` to get more information about its result.

        :param data: Payload (data sent on the request). Can be ``None``.
        :type data: bytes
        :param content_type: Content type of the payload (e.g. `text/xml`).
                             Can be ``None``.
        :type content_type: string

        :return: ``True`` on success, ``False`` on error.

        """
        if isinstance(content_type, unicode):
            content_type = PyUnicode_AsUTF8String(content_type)
        return bool(ecore_con_url_post(self.obj,
            <const void*><const char *>data if data is not None else NULL,
            len(data),
            <const char *>content_type if content_type is not None else NULL))

    def time(self, Ecore_Con_Url_Time time_condition, double timestamp):
        """Whether HTTP requests should be conditional, dependent on
        modification time.

        This function may set the header `If-Modified-Since` or
        `If-Unmodified-Since`, depending on the value of time_condition, with
        the value timestamp.

        :param time_condition: Condition to use for HTTP requests.
        :type time_condition: :ref:`Ecore_Con_Url_Time`
        :param timestamp: Time since 1 Jan 1970 to use in the condition.
        :type timestamp: double

        """
        ecore_con_url_time(self.obj, time_condition, timestamp)

    def ftp_upload(self, filename, user, passwd, upload_dir):
        """Upload a file to an ftp site.

        :param string filename: The path to the file to send
        :param string user: The username to log in with 
        :param string passwd: The password to log in with 
        :param string upload_dir: The directory to which the file will upload

        :return: ``True`` on success, ``False`` otherwise.
        :rtype: bool

        """
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(user, unicode): user = PyUnicode_AsUTF8String(user)
        if isinstance(passwd, unicode): passwd = PyUnicode_AsUTF8String(passwd)
        if isinstance(upload_dir, unicode): upload_dir = PyUnicode_AsUTF8String(upload_dir)
        return bool(ecore_con_url_ftp_upload(self.obj,
                <const char *>filename if filename is not None else NULL,
                <const char *>user if user is not None else NULL,
                <const char *>passwd if passwd is not None else NULL,
                <const char *>upload_dir if upload_dir is not None else NULL))

    property ftp_use_epsv:
        """Enable or disable EPSV extension.

        :type: bool (**writeonly**)

        """
        def __set__(self, bint use_epsv):
            ecore_con_url_ftp_use_epsv_set(self.obj, use_epsv)

    def cookies_init(self):
        """Enable the cookie engine for subsequent HTTP requests. 

        After this function is called, cookies set by the server in HTTP
        responses will be parsed and stored, as well as sent back to the server
        in new HTTP requests.

        """
        ecore_con_url_cookies_init(self.obj)

    def cookies_clear(self):
        """Clear currently loaded cookies.
        
        The cleared cookies are removed and will not be sent in subsequent HTTP
        requests, nor will they be written to the cookiejar file set via
        :attr:`cookies_jar_file`.

        .. note::
            This function will initialize the cookie engine if it has not been
            initialized yet. The cookie files set by
            :func:`cookies_file_add` aren't loaded immediately, just
            when the request is started. Thus, if you ask to clear the cookies,
            but has a file already set by that function, the cookies will then
            be loaded and you will have old cookies set. In order to don't have
            any old cookie set, you need to don't call
            :func:`cookies_file_add` ever on the :class:`Url` class, and
            call this function to clear any cookie set by a previous request on
            this handler.

        """
        ecore_con_url_cookies_clear(self.obj)

    def cookies_session_clear(self):
        """Clear currently loaded session cookies.
        
        Session cookies are cookies with no expire date set, which usually
        means they are removed after the current session is closed.

        The cleared cookies are removed and will not be sent in subsequent HTTP
        requests, nor will they be written to the cookiejar file set via
        :attr:`cookies_jar_file`.

        .. note::
            This function will initialize the cookie engine if it has not been
            initialized yet. The cookie files set by
            :func:`cookies_file_add` aren't loaded immediately, just
            when the request is started. Thus, if you ask to clear the session
            cookies, but has a file already set by that function, the session
            cookies will then be loaded and you will have old cookies set. In
            order to don't have any old session cookie set, you need to don't
            call :func:`cookies_file_add` ever on the :class:`Url` class, and
            call this function to clear any session cookie set by a previous
            request on this handler. An easier way to don't use old session
            cookies is by using the function
            :attr:`cookies_ignore_old_session`.

        """
        ecore_con_url_cookies_session_clear(self.obj)

    def cookies_file_add(self, file_name):
        """Add a file to the list of files from which to load cookies.

        Files must contain cookies defined according to two possible formats:
            * HTTP-style header ("Set-Cookie: ...").
            * Netscape/Mozilla cookie data format.

        Cookies will only be read from this file. If you want to save cookies
        to a file, use :attr:`cookies_jar_file`. Also notice that
        this function supports the both types of cookie file cited above, while
        :attr:`cookies_jar_file` will save only in the Netscape/Mozilla's
        format.

        Please notice that the file will not be read immediately, but rather
        added to a list of files that will be loaded and parsed at a later
        time.

        .. note::
            This function will initialize the cookie engine if it has not been
            initialized yet.

        :param string file_name: Name of the file that will be added to the list.

        """
        if isinstance(file_name, unicode):
            file_name = PyUnicode_AsUTF8String(file_name)
        ecore_con_url_cookies_file_add(self.obj,
                    <const char *>file_name if file_name is not None else NULL)

    property cookies_jar_file:
        """The name of the file to which all current cookies will be written
        when either cookies are flushed or Ecore_Con is shut down.

        Cookies are written following Netscape/Mozilla's data format, also
        known as cookie-jar.

        Cookies will only be saved to this file. If you need to read cookies
        from a file, use ecore_con_url_cookies_file_add() instead.

        .. note::
            This function will initialize the cookie engine if it has not been
            initialized yet.

        .. seealso:: :func:`cookies_jar_write`

        :type: string (**writeonly**)

        """
        def __set__(self, cookiejar_file):
            if isinstance(cookiejar_file, unicode):
                cookiejar_file = PyUnicode_AsUTF8String(cookiejar_file)
            ecore_con_url_cookies_jar_file_set(self.obj,
                <const char *>cookiejar_file if cookiejar_file is not None else NULL)
            if isinstance(cookiejar_file, unicode):
                cookiejar_file = PyUnicode_AsUTF8String(cookiejar_file)
            ecore_con_url_cookies_jar_file_set(self.obj,
                <const char *>cookiejar_file if cookiejar_file is not None else NULL)

    def cookies_jar_write(self):
        """Write all current cookies to the cookie jar immediately.
        
        A cookie-jar file must have been previously set by
        :attr:`cookies_jar_file`, otherwise nothing will be done.

        .. note::
            This function will initialize the cookie engine if it has not been
            initialized yet.

        .. seealso:: :attr:`cookies_jar_file`

        """
        ecore_con_url_cookies_jar_write(self.obj)
    
    property cookies_ignore_old_session:
        """Control whether session cookies from previous sessions shall be loaded. 

        Session cookies are cookies with no expire date set, which usually
        means they are removed after the current session is closed.

        By default, when Ecore_Con_Url loads cookies from a file, all cookies
        are loaded, including session cookies, which, most of the time, were
        supposed to be loaded and valid only for that session.

        If ignore is set to ``True``, when Ecore_Con_Url loads cookies from
        the files passed to :func:`cookies_file_add`, session cookies
        will not be loaded.

        :type: bool (**writeonly**)

        """
        def __set__(self, bint ignore):
            ecore_con_url_cookies_ignore_old_session_set(self.obj, ignore)

    property ssl_verify_peer:
        """Toggle libcurl's verify peer's certificate option. 

        If this is ``True``, libcurl will verify the authenticity of the
        peer's certificate, otherwise it will not. Default behavior of libcurl
        is to check peer's certificate.

        :type: bool (**writeonly**)

        """
        def __set__(self, bint verify):
            ecore_con_url_ssl_verify_peer_set(self.obj, verify)

    property ssl_ca:
        """Set a custom CA to trust for SSL/TLS connections. 

        Specify the path of a file (in PEM format) containing one or more CA
        certificate(s) to use for the validation of the server certificate.

        This can also disable CA validation if set to ``None``.
        However, the server certificate still needs to be valid for the
        connection to succeed (i.e., the certificate must concern the server
        the connection is made to).

        :type: string (**writeonly**)

        """
        def __set__(self, ca_path):
            if isinstance(ca_path, unicode):
                ca_path = PyUnicode_AsUTF8String(ca_path)
            ecore_con_url_ssl_ca_set(self.obj,
                <const char *>ca_path if ca_path is not None else NULL)

    property proxy:
        """Set the HTTP proxy to use.

        The parameter is the host name or dotted IP address. To specify port
        number in this string, append :[port] to the end of the host name. The
        proxy string may be prefixed with [protocol]:// since any such prefix
        will be ignored. The proxy's port number may optionally be specified
        with the separate option. If not specified, libcurl will default to
        using port 1080 for proxies.

        Set this to ``None`` to disable the usage of proxy.

        :type: string (**writeonly**)

        """
        def __set__(self, proxy):
            if isinstance(proxy, unicode): proxy = PyUnicode_AsUTF8String(proxy)
            ecore_con_url_proxy_set(self.obj,
                            <const char *>proxy if proxy is not None else NULL)

    property proxy_username:
        """Username to use for proxy.

        If socks protocol is used for proxy, protocol should be socks5 and
        above.
        
        :type: string (**writeonly**)

        """
        def __set__(self, user):
            if isinstance(user, unicode): user = PyUnicode_AsUTF8String(user)
            ecore_con_url_proxy_username_set(self.obj,
                            <const char *>user if user is not None else NULL)

    property proxy_password:
        """Password to use for proxy. 

        If socks protocol is used for proxy, protocol should be socks5 and
        above.

        :type: string (**writeonly**)

        """
        def __set__(self, passwd):
            if isinstance(passwd, unicode): passwd = PyUnicode_AsUTF8String(passwd)
            ecore_con_url_proxy_username_set(self.obj,
                            <const char *>passwd if passwd is not None else NULL)

    property timeout:
        """transfer timeout in seconds.

        The maximum time in seconds that you allow the :class:`Url` class
        transfer operation to take. Normally, name lookups can take a
        considerable time and limiting operations to less than a few minutes
        risk aborting perfectly normal operations.

        :type: double (**writeonly**)

        """
        def __set__(self, double timeout):
            ecore_con_url_timeout_set(self.obj, timeout)

    property http_version:
        """The HTTP version used for the request.

        Can be :data:`ECORE_CON_URL_HTTP_VERSION_1_0` or
        :data:`ECORE_CON_URL_HTTP_VERSION_1_1`
        
        :type: :ref:`Ecore_Con_Url_Http_Version` (**writeonly**)

        """
        def __set__(self, Ecore_Con_Url_Http_Version version):
            ecore_con_url_http_version_set(self.obj, version)

    property status_code:
        """The returned HTTP STATUS code. 

        This is used to, at any time, try to return the status code for a
        transmission.

        :type: int  (**readonly**)

        """
        def __get__(self):
            return ecore_con_url_status_code_get(self.obj)

    property url:
        """Controls the URL to send the request to.

        :type: string

        """
        def __get__(self):
            return _ctouni(ecore_con_url_url_get(self.obj))

        def __set__(self, url):
            if isinstance(url, unicode): url = PyUnicode_AsUTF8String(url)
            ecore_con_url_url_set(self.obj, <const char *>url if url is not None else NULL)

    property verbose:
        """Toggle libcurl's verbose output. 

        If set to ``True``, libcurl will output a lot of verbose
        information about its operations, which is useful for debugging. The
        verbose information will be sent to stderr.

        :type: bool (**writeonly**)

        """
        def __set__(self, bint verbose):
            ecore_con_url_verbose_set(self.obj, verbose)

    def additional_header_add(self, key, value):
        """Add an additional header to the request connection object. 

        Add an additional header (User-Agent, Content-Type, etc.) to the
        request connection object. This addition will be valid for only one
        :func:`get` or :func:`post` call.

        :param string key: Header key 
        :param string value: Header value

        Some functions like :func:`time` also add headers to the request. 
        
        """
        if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        ecore_con_url_additional_header_add(self.obj,
                           <const char *>key if key is not None else NULL,
                           <const char *>value if value is not None else NULL)

    def additional_headers_clear(self):
        """Clean additional headers.
        
        Clean additional headers associated with a connection object
        (previously added with :func:additional_header_add`).

        """
        ecore_con_url_additional_headers_clear(self.obj)

    property response_headers:
        """The headers from last request sent. 

        Retrieve a list containing the response headers. This function should
        be used after an :class:`EventUrlComplete` event (headers should
        normally be ready at that time).

        :type: list of strings (**readonly**)

        """
        def __get__(self):
            return eina_list_strings_to_python_list(
                        ecore_con_url_response_headers_get(self.obj))

    property received_bytes:
        """The number of bytes received. 

        Retrieve the number of bytes received on the last request of the
        :class:`Url` object.

        :type: int (**readonly**)

        """
        def __get__(self):
            return ecore_con_url_received_bytes_get(self.obj)

    def httpauth_set(self, username, password, bint safe):
        """Set to use http auth, with given username and password
        
        :param string username: Username to use in authentication 
        :param string password: Password to use in authentication
        :param bool safe: Whether to use "safer" methods (eg, NOT http basic auth)

        :return: ``True`` on success, ``False`` on error.
        :rtype: bool

        .. warning:: Require libcurl >= 7.19.1 to work, otherwise will
                     always return ``False``.
        
        """
        if isinstance(username, unicode):
            username = PyUnicode_AsUTF8String(username)
        if isinstance(password, unicode):
            password = PyUnicode_AsUTF8String(password)
        return bool(ecore_con_url_httpauth_set(self.obj,
                    <const char *>username if username is not None else NULL,
                    <const char *>password if password is not None else NULL,
                    safe))

    def on_complete_event_add(self, func, *args, **kargs):
        """Adds event listener to know when the Url operation is completed.

        The given function will be called with the following signature::

            func(event, *args, **kargs)

        The ``event`` parameter is an :class:`EventUrlComplete` instance.

        :see: :func:`on_complete_event_del`

        """
        GEF.callback_add(ECORE_CON_EVENT_URL_COMPLETE, self, func, args, kargs)

    def on_complete_event_del(self, func, *args, **kargs):
        """Removes an event listener previously registered 

        Parameters must match exactly the ones given in the
        :func:`on_complete_event_add` call

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        GEF.callback_del(ECORE_CON_EVENT_URL_COMPLETE, self, func, args, kargs)
        
    def on_progress_event_add(self, func, *args, **kargs):
        """Adds event listener to know the operation status progress.

        The given function will be called with the following signature::

            func(event, *args, **kargs)

        The ``event`` parameter is an :class:`EventUrlProgress` instance.

        :see: :func:`on_progress_event_del`

        """
        GEF.callback_add(ECORE_CON_EVENT_URL_PROGRESS, self, func, args, kargs)

    def on_progress_event_del(self, func, *args, **kargs):
        """Removes an event listener previously registered 

        Parameters must match exactly the ones given in the
        :func:`on_progress_event_add` call

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        GEF.callback_del(ECORE_CON_EVENT_URL_PROGRESS, self, func, args, kargs)
        
    def on_data_event_add(self, func, *args, **kargs):
        """Adds event listener to collect the data while they are received.

        The given function will be called with the following signature::

            func(event, *args, **kargs)

        The ``event`` parameter is an :class:`EventUrlData` instance.

        :see: :func:`on_data_event_del`

        """
        GEF.callback_add(ECORE_CON_EVENT_URL_DATA, self, func, args, kargs)

    def on_data_event_del(self, func, *args, **kargs):
        """Removes an event listener previously registered 

        Parameters must match exactly the ones given in the
        :func:`on_data_event_add` call

        :raise ValueError: if parameters don't match an already
                           registered callback.
        """
        GEF.callback_del(ECORE_CON_EVENT_URL_DATA, self, func, args, kargs)


def url_pipeline_set(bint enable):
    """Enable or disable HTTP 1.1 pipelining.

    Pipelining allows to send one request after another one, without having to
    wait for the reply of the first request. The respective replies are
    received in the order that the requests were sent.

    .. warning:: Enabling this feature will be valid for all requests done
                 using ecore_con_url.

    .. versionadded:: 1.17

    """
    ecore_con_url_pipeline_set(enable)

def url_pipeline_get():
    """Is HTTP 1.1 pipelining enable ? 

    :return: ``True`` if enable

    .. versionadded:: 1.17

    """
    return bool(ecore_con_url_pipeline_get())

