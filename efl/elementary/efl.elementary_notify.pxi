# Copyright (c) 2008-2009 ProFUSION embedded systems
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary. If not, see <http://www.gnu.org/licenses/>.


cdef class Notify(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_notify_add(parent.obj))

    def parent_set(self, evasObject parent):
        cdef Evas_Object *o
        if parent is not None:
            o = parent.obj
        else:
            o = NULL
        elm_notify_parent_set(self.obj, o)

    def parent_get(self):
        return object_from_instance(elm_notify_parent_get(self.obj))

    property parent:
        def __get__(self):
            return object_from_instance(elm_notify_parent_get(self.obj))
        def __set__(self, evasObject parent):
            cdef Evas_Object *o
            if parent is not None:
                o = parent.obj
            else:
                o = NULL
            elm_notify_parent_set(self.obj, o)

    def orient_set(self, int orient):
        elm_notify_orient_set(self.obj, orient)

    def orient_get(self):
        return elm_notify_orient_get(self.obj)

    property orient:
        def __get__(self):
            return elm_notify_orient_get(self.obj)
        def __set__(self, orient):
            elm_notify_orient_set(self.obj, orient)

    def timeout_set(self, double timeout):
        elm_notify_timeout_set(self.obj, timeout)

    def timeout_get(self):
        return elm_notify_timeout_get(self.obj)

    property timeout:
        def __get__(self):
            return elm_notify_timeout_get(self.obj)
        def __set__(self, timeout):
            elm_notify_timeout_set(self.obj, timeout)

    def allow_events_set(self, repeat):
        elm_notify_allow_events_set(self.obj, repeat)

    def allow_events_get(self):
        return bool(elm_notify_allow_events_get(self.obj))

    property allow_events:
        def __get__(self):
            return bool(elm_notify_allow_events_get(self.obj))
        def __set__(self, allow_events):
            elm_notify_allow_events_set(self.obj, allow_events)

    def callback_timeout_add(self, func, *args, **kwargs):
        self._callback_add("timeout", func, *args, **kwargs)

    def callback_timeout_del(self, func):
        self._callback_del("timeout", func)

    def callback_block_clicked_add(self, func, *args, **kwargs):
        self._callback_add("block,clicked", func, *args, **kwargs)

    def callback_block_clicked_del(self, func):
        self._callback_del("block,clicked", func)


_object_mapping_register("elm_notify", Notify)
