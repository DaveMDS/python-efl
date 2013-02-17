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
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

from efl.evas cimport evas_object_data_get

cdef Evas_Object *_tooltip_content_create(void *data, Evas_Object *o, Evas_Object *t) with gil:
    cdef Object ret, obj, tooltip

    obj = <Object>evas_object_data_get(o, "python-evas")
    tooltip = object_from_instance(t)
    (func, args, kargs) = <object>data
    ret = func(obj, tooltip, *args, **kargs)
    if not ret:
        return NULL
    return ret.obj

cdef void _tooltip_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    Py_DECREF(<object>data)

cdef Evas_Object *_tooltip_item_content_create(void *data, Evas_Object *o, Evas_Object *t, void *it) with gil:
   cdef Object ret, obj, tooltip

   obj = <Object>evas_object_data_get(o, "python-evas")
   tooltip = object_from_instance(t)
   (func, item, args, kargs) = <object>data
   ret = func(obj, item, *args, **kargs)
   if not ret:
       return NULL
   return ret.obj

cdef void _tooltip_item_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
   Py_DECREF(<object>data)

