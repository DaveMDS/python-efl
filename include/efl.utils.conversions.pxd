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

from efl.eina cimport Eina_List

cdef unicode _touni(char* s)
cdef unicode _ctouni(const char *s)

cdef list array_of_strings_to_python_list(char **array, int array_length)
cdef const char ** python_list_strings_to_array_of_strings(list strings) except NULL
cdef list eina_list_strings_to_python_list(const Eina_List *lst)
cdef Eina_List * python_list_strings_to_eina_list(list strings)
cdef list eina_list_objects_to_python_list(const Eina_List *lst)
cdef Eina_List *python_list_objects_to_eina_list(list objects)
cdef int * python_list_ints_to_array_of_ints(list ints) except NULL
cdef list array_of_ints_to_python_list(int *array, int array_length)
cdef double * python_list_doubles_to_array_of_doubles(list doubles) except NULL
