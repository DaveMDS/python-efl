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

from efl.eina cimport Eina_Iterator
from efl.c_eo cimport Eo as cEo

cdef:
    class Eo(object):
        cdef:
            cEo *obj
            readonly dict data
            dict internal_data

            int _set_obj(self, cEo *obj) except 0
            int _set_properties_from_keyword_args(self, dict kwargs) except 0
            #_add_obj(self, Eo_Class *klass, cEo *parent)

    class EoIterator:
        cdef Eina_Iterator *itr
        @staticmethod
        cdef inline create(Eina_Iterator *itr):
            cdef EoIterator obj = EoIterator.__new__(EoIterator)
            obj.itr = itr
            return obj


    int PY_REFCOUNT(object o)

    void _object_mapping_register(char *name, object cls) except *
    void _object_mapping_unregister(char *name)

    void _register_decorated_callbacks(Eo obj)

cdef api:
    object object_from_instance(cEo *obj)
    cEo *instance_from_object(object o)
