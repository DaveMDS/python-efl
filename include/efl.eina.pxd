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

from cpython cimport va_list

cdef extern from "time.h":
    struct tm:
        int tm_sec
        int tm_min
        int tm_hour
        int tm_mday
        int tm_mon
        int tm_year
        int tm_wday
        int tm_yday
        int tm_isdst

        long int tm_gmtoff
        const char *tm_zone


cdef extern from "Eina.h":
    ####################################################################
    # Enumerations
    #
    ctypedef enum Eina_Log_Level:
        EINA_LOG_LEVEL_CRITICAL # Critical log level
        EINA_LOG_LEVEL_ERR # Error log level
        EINA_LOG_LEVEL_WARN # Warning log level
        EINA_LOG_LEVEL_INFO # Information log level
        EINA_LOG_LEVEL_DBG # Debug log level
        EINA_LOG_LEVELS # Count of default log levels
        EINA_LOG_LEVEL_UNKNOWN = (-2147483647 - 1) # Unknown level

    ctypedef enum Eina_Log_State:
        EINA_LOG_STATE_START
        EINA_LOG_STATE_STOP

    ####################################################################
    # Basic Types
    #
    ctypedef unsigned char Eina_Bool
    ctypedef int Eina_Error
    ctypedef const char Eina_Stringshare
    # This is actually either wchar_t or uint32_t, Cython
    # should use an appropriate integer automatically
    ctypedef Py_UCS4 Eina_Unicode

    ####################################################################
    # Structures
    #
    ctypedef struct Eina_Rectangle:
        int x
        int y
        int w
        int h

    ctypedef struct Eina_List:
        void      *data
        Eina_List *next
        Eina_List *prev
        void      *accounting

    ctypedef struct Eina_Hash

    ctypedef struct Eina_Hash_Tuple:
        void *key
        void *data
        unsigned int key_length

    ctypedef struct Eina_Iterator:
        Eina_Bool (*next)(Eina_Iterator *it, void **data)
        void *(*get_container)(Eina_Iterator *it)
        void (*free)(Eina_Iterator *it)

    ctypedef struct Eina_Log_Domain:
        int         level # Max level to log
        const char *domain_str # Formatted string with color to print
        const char *name # Domain name
        size_t      namelen # strlen(name)

    ####################################################################
    # Other typedefs
    #
    ctypedef int (*Eina_Compare_Cb)(const void *data1, const void *data2)
    ctypedef void (*Eina_Free_Cb)(void *data)
    ctypedef void (*Eina_Log_Print_Cb)(const Eina_Log_Domain *d,
                                  Eina_Log_Level level,
                                  const char *file, const char *fnc, int line,
                                  const char *fmt, void *data, va_list args)

    ####################################################################
    # Functions
    #
    Eina_Error eina_error_get()
    void eina_error_set(Eina_Error err)
    const char *eina_error_msg_get(Eina_Error error)

    Eina_Bool eina_iterator_next(Eina_Iterator *iterator, void **data)
    void eina_iterator_free(Eina_Iterator *iterator)

    Eina_Stringshare *eina_stringshare_add_length(const char *str, unsigned int slen)
    Eina_Stringshare *eina_stringshare_add(const char *str)
    void              eina_stringshare_del(Eina_Stringshare *str)
    Eina_Stringshare *eina_stringshare_ref(Eina_Stringshare *str)
    int               eina_stringshare_strlen(Eina_Stringshare *str)
    Eina_Bool         eina_stringshare_replace(Eina_Stringshare **p_str, const char *news)

    Eina_List *eina_list_free(Eina_List *list)
    Eina_List *eina_list_append(Eina_List *list, void *data)
    Eina_List *eina_list_prepend(Eina_List *list, void *data)
    Eina_List *eina_list_append(Eina_List *list, void *data)
    Eina_List *eina_list_prepend(Eina_List *list, void *data)
    Eina_List *eina_list_append_relative(Eina_List *list, void *data, void *relative)
    Eina_List *eina_list_append_relative_list(Eina_List *list, void *data, Eina_List *relative)
    Eina_List *eina_list_prepend_relative(Eina_List *list, void *data, void *relative)
    Eina_List *eina_list_prepend_relative_list(Eina_List *list, void *data, Eina_List *relative)
    Eina_List *eina_list_sorted_insert(Eina_List *list, Eina_Compare_Cb func, void *data)
    Eina_List *eina_list_remove(Eina_List *list, void *data)
    Eina_List *eina_list_remove_list(Eina_List *list, Eina_List *remove_list)
    Eina_List *eina_list_promote_list(Eina_List *list, Eina_List *move_list)
    Eina_List *eina_list_demote_list(Eina_List *list, Eina_List *move_list)
    void *eina_list_data_find(Eina_List *list, void *data)
    Eina_List *eina_list_data_find_list(Eina_List *list, void *data)
    Eina_List *eina_list_free(Eina_List *list)
    void *eina_list_nth(Eina_List *list, unsigned int n)
    Eina_List *eina_list_nth_list(Eina_List *list, unsigned int n)
    Eina_List *eina_list_reverse(Eina_List *list)
    Eina_List *eina_list_reverse_clone(Eina_List *list)
    Eina_List *eina_list_clone(Eina_List *list)
    Eina_List *eina_list_sort(Eina_List *list, unsigned int size, Eina_Compare_Cb func)
    Eina_List *eina_list_merge(Eina_List *left, Eina_List *right)
    Eina_List *eina_list_sorted_merge(Eina_List *left, Eina_List *right, Eina_Compare_Cb func)
    Eina_List *eina_list_split_list(Eina_List *list, Eina_List *relative, Eina_List **right)
    Eina_List *eina_list_search_sorted_near_list(Eina_List *list, Eina_Compare_Cb func, void *data, int *result_cmp)
    Eina_List *eina_list_search_sorted_list(Eina_List *list, Eina_Compare_Cb func, void *data)
    void *eina_list_search_sorted(Eina_List *list, Eina_Compare_Cb func, void *data)
    Eina_List *eina_list_search_unsorted_list(Eina_List *list, Eina_Compare_Cb func, void *data)
    void *eina_list_search_unsorted(Eina_List *list, Eina_Compare_Cb func, void *data)
    Eina_List *eina_list_last(Eina_List *list)
    Eina_List *eina_list_next(Eina_List *list)
    Eina_List *eina_list_prev(Eina_List *list)
    void *eina_list_data_get(Eina_List *list)
    unsigned int eina_list_count(Eina_List *list)

    Eina_Hash *eina_hash_string_superfast_new(Eina_Free_Cb data_free_cb)
    Eina_Bool  eina_hash_add(Eina_Hash *hash, const void *key, const void *data)
    Eina_Bool eina_hash_del(Eina_Hash  *hash, const void *key, const void *data)
    void *eina_hash_find(Eina_Hash *hash, const void *key)

    void eina_log_threads_enable()
    void eina_log_print_cb_set(Eina_Log_Print_Cb cb, void *data)
    void eina_log_level_set(int level)
    int  eina_log_level_get()
    Eina_Bool          eina_log_main_thread_check()
    void               eina_log_function_disable_set(Eina_Bool disabled)
    Eina_Bool          eina_log_function_disable_get()
    void               eina_log_domain_level_set(const char *domain_name, int level)
    int                eina_log_domain_level_get(const char *domain_name)
    int                eina_log_domain_registered_level_get(int domain)
    int  eina_log_domain_register(const char *name, const char *color)
    void eina_log_domain_unregister(int domain)
    void eina_log_print(int            domain,
                        Eina_Log_Level level,
                        const char    *file,
                        const char    *fnc,
                        int            line,
                        const char    *fmt,
                        ...)

    void EINA_LOG_DOM_CRIT(int DOM, const char *fmt, ...)
    void EINA_LOG_DOM_ERR(int DOM, const char *fmt, ...)
    void EINA_LOG_DOM_WARN(int DOM, const char *fmt, ...)
    void EINA_LOG_DOM_INFO(int DOM, const char *fmt, ...)
    void EINA_LOG_DOM_DBG(int DOM, const char *fmt, ...)
