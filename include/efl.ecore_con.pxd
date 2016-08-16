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


from efl.eina cimport *
from efl.c_eo cimport Eo as cEo
from efl.eo cimport Eo, object_from_instance
from efl.ecore cimport Ecore_Event_Handler, Event
from efl.utils.conversions cimport _ctouni, eina_list_strings_to_python_list

from efl.ecore_con.enums cimport Ecore_Con_Type, Ecore_Con_Url_Time, \
    Ecore_Con_Url_Http_Version

cdef extern from "Ecore_Con.h":

    # where is this defined in real ?
    cdef struct sockaddr:
        pass

    # defines
    int ECORE_CON_EVENT_URL_COMPLETE
    int ECORE_CON_EVENT_URL_PROGRESS
    int ECORE_CON_EVENT_URL_DATA

    # typedefs
    ctypedef cEo Ecore_Con_Url

    ctypedef struct Ecore_Con_Event_Url_Progress_SubParam:
        double total
        double now

    ctypedef struct Ecore_Con_Event_Url_Progress:
        Ecore_Con_Url *url_con
        Ecore_Con_Event_Url_Progress_SubParam down
        Ecore_Con_Event_Url_Progress_SubParam up

    ctypedef struct Ecore_Con_Event_Url_Data:
        Ecore_Con_Url *url_con
        int size
        unsigned char *data

    ctypedef struct Ecore_Con_Event_Url_Complete:
        Ecore_Con_Url *url_con
        int status

    ctypedef void (*Ecore_Con_Dns_Cb)(const char *canonname, const char *ip,
                                      sockaddr *addr, int addrlen, void *data)


    # functions
    int               ecore_con_init()
    int               ecore_con_shutdown()
#     Ecore_Con_Server *ecore_con_server_connect(Ecore_Con_Type type, const char *name, int port, const void *data)

    int               ecore_con_url_init()
    int               ecore_con_url_shutdown()
    void              ecore_con_url_pipeline_set(Eina_Bool enable)
    Eina_Bool         ecore_con_url_pipeline_get()
    Eina_Bool         ecore_con_lookup(const char *name, Ecore_Con_Dns_Cb done_cb, const void *data)

    Ecore_Con_Url    *ecore_con_url_new(const char *url)
    void              ecore_con_url_free(Ecore_Con_Url *url_obj)
    Ecore_Con_Url *   ecore_con_url_custom_new(const char *url, const char *custom_request)
    void              ecore_con_url_verbose_set(Ecore_Con_Url *url_con, Eina_Bool verbose)
    Eina_Bool         ecore_con_url_http_version_set(Ecore_Con_Url *url_con, Ecore_Con_Url_Http_Version version)
    void              ecore_con_url_timeout_set(Ecore_Con_Url *url_con, double timeout)
    int               ecore_con_url_status_code_get(Ecore_Con_Url *url_con)
    Eina_Bool         ecore_con_url_get(Ecore_Con_Url *url_con)
    Eina_Bool         ecore_con_url_head(Ecore_Con_Url *url_con)
    Eina_Bool         ecore_con_url_post(Ecore_Con_Url *url_con, const void *data, long length, const char *content_type)
    Eina_Bool         ecore_con_url_ftp_upload(Ecore_Con_Url *url_con, const char *filename, const char *user, const char *passwd, const char *upload_dir)
    void              ecore_con_url_ftp_use_epsv_set(Ecore_Con_Url *url_con, Eina_Bool use_epsv)

    Eina_Bool         ecore_con_url_url_set(Ecore_Con_Url *obj, const char *url)
    const char       *ecore_con_url_url_get(const Ecore_Con_Url *obj)
    void              ecore_con_url_fd_set(Ecore_Con_Url *url_con, int fd)

    void              ecore_con_url_additional_header_add(Ecore_Con_Url *url_con, const char *key, const char *value)
    void              ecore_con_url_additional_headers_clear(Ecore_Con_Url *url_con)
    const Eina_List  *ecore_con_url_response_headers_get(Ecore_Con_Url *url_con)
    int               ecore_con_url_received_bytes_get(Ecore_Con_Url *url_con)
    Eina_Bool         ecore_con_url_httpauth_set(Ecore_Con_Url *url_con, const char *username, const char *password, Eina_Bool safe)
    void              ecore_con_url_time(Ecore_Con_Url *url_con, Ecore_Con_Url_Time time_condition, double timestamp)

    void              ecore_con_url_cookies_init(Ecore_Con_Url *url_con)
    void              ecore_con_url_cookies_clear(Ecore_Con_Url *url_con)
    void              ecore_con_url_cookies_session_clear(Ecore_Con_Url *url_con)
    void              ecore_con_url_cookies_ignore_old_session_set(Ecore_Con_Url *url_con, Eina_Bool ignore)
    void              ecore_con_url_cookies_file_add(Ecore_Con_Url *url_con, const char *file_name)
    Eina_Bool         ecore_con_url_cookies_jar_file_set(Ecore_Con_Url *url_con, const char *cookiejar_file)
    void              ecore_con_url_cookies_jar_write(Ecore_Con_Url *url_con)

    void              ecore_con_url_ssl_verify_peer_set(Ecore_Con_Url *url_con, Eina_Bool verify)
    int               ecore_con_url_ssl_ca_set(Ecore_Con_Url *url_con, const char *ca_path)

    Eina_Bool         ecore_con_url_proxy_set(Ecore_Con_Url *url_con, const char *proxy)
    Eina_Bool         ecore_con_url_proxy_username_set(Ecore_Con_Url *url_con, const char *username)
    Eina_Bool         ecore_con_url_proxy_password_set(Ecore_Con_Url *url_con, const char *password)


cdef class Url(Eo):
    pass

cdef class Lookup(object):
    cdef object done_cb
    cdef tuple args
    cdef dict kargs

cdef class EventUrlComplete(Event):
    cdef readonly Url url
    cdef readonly int status


cdef class EventUrlProgress(Event):
    cdef readonly Url url
    cdef readonly double down_total
    cdef readonly double down_now
    cdef readonly double up_total
    cdef readonly double up_now


cdef class EventUrlData(Event):
    cdef readonly Url url
    cdef readonly int size
    cdef readonly bytes data


cdef class ConEventFilter(object):
    cdef dict callbacks
    cdef dict handlers
    cdef callback_add(self, int ev_type, Eo obj, object func, tuple args, dict kargs)
    cdef callback_del(self, int ev_type, Eo obj, object func, tuple args, dict kargs)
    cdef callback_del_full(self, Eo obj)
