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

from libc.stdlib cimport malloc, free
from libc.string cimport strdup
from cpython cimport PyUnicode_AsUTF8String

from efl.c_eo cimport Eo as cEo
from efl.eo cimport Eo, object_from_instance
from efl.eina cimport eina_list_append, eina_stringshare_add

cdef unicode _touni(char* s):
    """

    Converts a char * to a python string object

    """
    return s.decode('UTF-8', 'strict') if s else None


cdef unicode _ctouni(const_char *s):
    """

    Converts a const_char * to a python string object

    """
    return s.decode('UTF-8', 'strict') if s else None


cdef list array_of_strings_to_python_list(char **array, int array_length):
    """

    Converts an array of strings to a python list.

    """
    cdef:
        char *string
        list ret = list()
        int i

    for i in range(array_length):
        string = array[i]
        ret.append(_touni(string))
    return ret


cdef const_char ** python_list_strings_to_array_of_strings(list strings) except NULL:
    """

    Converts a python list to an array of strings.

    Note: Remember to free the array when it's no longer needed.

    """
    cdef:
        const_char **array = NULL
        const_char *string
        unsigned int str_len, i
        unsigned int arr_len = len(strings)

    # TODO: Should we just return NULL in this case?
    if arr_len == 0:
        array = <const_char **>malloc(sizeof(const_char*))
        if not array:
            raise MemoryError()
        array[0] = NULL
        return array

    array = <const_char **>malloc(arr_len * sizeof(const_char*))
    if not array:
        raise MemoryError()

    for i in range(arr_len):
        s = strings[i]
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        array[i] = <const_char *>strdup(s)

    return array


cdef list eina_list_strings_to_python_list(const_Eina_List *lst):
    cdef:
        const_char *s
        list ret = []
        Eina_List *itr = <Eina_List *>lst
    while itr:
        s = <const_char *>itr.data
        ret.append(_ctouni(s))
        itr = itr.next
    return ret


cdef Eina_List *python_list_strings_to_eina_list(list strings):
    cdef Eina_List *lst = NULL
    for s in strings:
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        lst = eina_list_append(lst, eina_stringshare_add(s))
    return lst


cdef list eina_list_objects_to_python_list(const_Eina_List *lst):
    cdef list ret = list()
    while lst:
        ret.append(object_from_instance(<cEo *>lst.data))
        lst = lst.next
    return ret


cdef Eina_List *python_list_objects_to_eina_list(list objects):
    cdef:
        Eina_List *lst = NULL
        Eo o
    for o in objects:
        lst = eina_list_append(lst, o.obj)
    return lst