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

from libc.stdlib cimport malloc
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


cdef unicode _ctouni(const char *s):
    """

    Converts a const char * to a python string object

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


cdef const char ** python_list_strings_to_array_of_strings(list strings) except NULL:
    """

    Converts a python list to an array of strings.

    Note: Remember to free the array when it's no longer needed.

    """
    cdef:
        const char **array = NULL
        const char *string
        unsigned int str_len, i
        unsigned int arr_len = len(strings)

    # FIXME: Should we just return NULL in this case?
    if arr_len == 0:
        array = <const char **>malloc(sizeof(const char*))
        if not array:
            raise MemoryError()
        array[0] = NULL
        return array

    array = <const char **>malloc(arr_len * sizeof(const char*))
    if not array:
        raise MemoryError()

    for i in range(arr_len):
        s = strings[i]
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        array[i] = <const char *>strdup(s)

    return array

cdef list array_of_ints_to_python_list(int *array, int array_length):
    """

    Converts an array of ints to a python list.

    UNTESTED (used in Win.wm_rotation_available_rotations)

    """
    cdef:
        list ret = list()
        int i

    for i in range(array_length):
        ret.append(array[i])

    return ret

cdef int * python_list_ints_to_array_of_ints(list ints) except NULL:
    """

    Converts a python list to an array of ints.

    UNTESTED (used in Win.wm_rotation_available_rotations)

    Note: Remember to free the array when it's no longer needed.

    """
    cdef:
        int *array = NULL
        unsigned int i
        unsigned int arr_len = len(ints)

    if arr_len == 0:
        return NULL

    array = <int *>malloc(arr_len * sizeof(int))
    if not array:
        raise MemoryError()

    for i in range(arr_len):
        array[i] = ints[i]

    return array

cdef double * python_list_doubles_to_array_of_doubles(list doubles) except NULL:
    """

    Converts a python list to an array of doubles.

    Note: Remember to free the array when it's no longer needed.

    """
    cdef:
        double *array = NULL
        unsigned int i
        unsigned int arr_len = len(doubles)

    if arr_len == 0:
        return NULL

    array = <double *>malloc(arr_len * sizeof(double))
    if not array:
        raise MemoryError()

    for i in range(arr_len):
        array[i] = doubles[i]

    return array

cdef list eina_list_strings_to_python_list(const Eina_List *lst):
    cdef:
        const char *s
        list ret = []
        Eina_List *itr = <Eina_List *>lst
    while itr:
        s = <const char *>itr.data
        ret.append(_ctouni(s))
        itr = itr.next
    return ret


cdef Eina_List *python_list_strings_to_eina_list(list strings):
    cdef Eina_List *lst = NULL
    for s in strings:
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        lst = eina_list_append(lst, eina_stringshare_add(s))
    return lst


cdef list eina_list_objects_to_python_list(const Eina_List *lst):
    cdef list ret = list()
    while lst:
        ret.append(object_from_instance(<cEo *>lst.data))
        lst = lst.next
    return ret


cdef Eina_List *python_list_objects_to_eina_list(list objects):
    cdef:
        Eina_List *lst = NULL
        Eo o

    if objects is None:
        return NULL

    for o in objects:
        lst = eina_list_append(lst, o.obj)

    return lst
