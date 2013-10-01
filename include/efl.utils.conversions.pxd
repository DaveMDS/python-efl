from libc.string cimport const_char
from efl.eina cimport Eina_List, const_Eina_List

cdef unicode _touni(char* s)
cdef unicode _ctouni(const_char *s)

cdef list array_of_strings_to_python_list(char **array, int array_length)
cdef const_char ** python_list_strings_to_array_of_strings(list strings) except NULL
cdef list eina_list_strings_to_python_list(const_Eina_List *lst)
cdef Eina_List * python_list_strings_to_eina_list(list strings)
cdef list eina_list_objects_to_python_list(const_Eina_List *lst)
cdef Eina_List *python_list_objects_to_eina_list(list objects)
