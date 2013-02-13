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

from efl.c_eo cimport Eo as cEo
from efl.c_eo cimport Eo_Class
from efl cimport const_char_ptr, Eina_List, const_Eina_List


cdef class Eo(object):
    cdef cEo *obj
    cdef readonly data

    cdef _set_obj(self, cEo *obj)
#    cdef _unset_obj(self)
#    cdef _add_obj(self, Eo_Class *klass, cEo *parent)


cdef int PY_REFCOUNT(object o)

cdef object object_from_instance(cEo *obj)
cdef _object_mapping_register(char *name, klass)
cdef _object_mapping_unregister(char*name)

cdef inline unicode _touni(char* s)
cdef inline char*   _fruni(s)
cdef inline unicode _ctouni(const_char_ptr s)
cdef inline const_char_ptr _cfruni(s)

cdef inline _strings_to_python(const_Eina_List *lst)
cdef inline Eina_List * _strings_from_python(strings)
cdef inline _object_list_to_python(const_Eina_List *lst)
