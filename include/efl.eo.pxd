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

from libc.string cimport const_char

from efl.c_eo cimport Eo as cEo

from efl.eina cimport Eina_List, const_Eina_List

cdef class Eo(object):
    cdef cEo *obj
    cdef readonly dict data

    cdef void _set_obj(self, cEo *obj) except *
    cdef void _set_properties_from_keyword_args(self, dict kwargs) except *
#    cdef void *_unset_obj(self)
#    cdef _add_obj(self, Eo_Class *klass, cEo *parent)


cdef int PY_REFCOUNT(object o)

cdef object object_from_instance(cEo *obj)
cdef void _object_mapping_register(char *name, object cls) except *
cdef void _object_mapping_unregister(char *name)

cdef void _register_decorated_callbacks(object obj)
