# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

from efl.evas cimport Eina_List, const_Eina_List, eina_list_append, Evas_Object
from efl.eo cimport object_from_instance
from libc.string cimport const_char

cdef _strings_to_python(const_Eina_List *lst):
    cdef const_char *s
    ret = []
    while lst:
        s = <const_char *>lst.data
        if s != NULL:
            ret.append(_ctouni(s))
        lst = lst.next
    return ret

cdef Eina_List * _strings_from_python(strings):
    cdef Eina_List *lst = NULL
    for s in strings:
        lst = eina_list_append(lst, _cfruni(s))
    return lst

cdef _object_list_to_python(const_Eina_List *lst):
    cdef Evas_Object *o
    ret = []
    while lst:
        o = <Evas_Object *>lst.data
        obj = object_from_instance(o)
        ret.append(obj)
        lst = lst.next
    return ret
