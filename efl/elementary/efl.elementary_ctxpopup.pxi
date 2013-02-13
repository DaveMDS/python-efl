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


cdef class CtxpopupItem(ObjectItem):
    def __init__(self, evasObject ctxpopup, label = None, evasObject icon = None, callback = None, *args, **kargs):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)
        item = elm_ctxpopup_item_append(ctxpopup.obj,
                                        _cfruni(label) if label is not None else NULL,
                                        icon.obj if icon is not None else NULL,
                                        cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)


cdef class Ctxpopup(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_ctxpopup_add(parent.obj))

    def hover_parent_set(self, evasObject parent):
        elm_ctxpopup_hover_parent_set(self.obj, parent.obj)

    def hover_parent_get(self):
        return object_from_instance(elm_ctxpopup_hover_parent_get(self.obj))

    property parent:
        def __get__(self):
            return object_from_instance(elm_ctxpopup_hover_parent_get(self.obj))

        def __set__(self, evasObject parent):
            elm_ctxpopup_hover_parent_set(self.obj, parent.obj)

    def clear(self):
        elm_ctxpopup_clear(self.obj)

    def horizontal_set(self, horizontal):
        elm_ctxpopup_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return bool(elm_ctxpopup_horizontal_get(self.obj))

    property horizontal:
        def __get__(self):
            return bool(elm_ctxpopup_horizontal_get(self.obj))

        def __set__(self, horizontal):
            elm_ctxpopup_horizontal_set(self.obj, horizontal)

    def item_append(self, label, evasObject icon = None, func = None, *args, **kwargs):
        return CtxpopupItem(self, label, icon, func, *args, **kwargs)

    def direction_priority_set(self, first, second, third, fourth):
        elm_ctxpopup_direction_priority_set(self.obj, first, second, third, fourth)

    def direction_priority_get(self):
        cdef Elm_Ctxpopup_Direction first, second, third, fourth
        elm_ctxpopup_direction_priority_get(self.obj, &first, &second, &third, &fourth)
        return (first, second, third, fourth)

    property direction_priority:
        def __get__(self):
            cdef Elm_Ctxpopup_Direction first, second, third, fourth
            elm_ctxpopup_direction_priority_get(self.obj, &first, &second, &third, &fourth)
            return (first, second, third, fourth)

        def __set__(self, priority):
            cdef Elm_Ctxpopup_Direction first, second, third, fourth
            first, second, third, fourth = priority
            elm_ctxpopup_direction_priority_set(self.obj, first, second, third, fourth)

    def direction_get(self):
        return elm_ctxpopup_direction_get(self.obj)

    property direction:
        def __get__(self):
            return elm_ctxpopup_direction_get(self.obj)

    def dismiss(self):
        elm_ctxpopup_dismiss(self.obj)

    def callback_dismissed_add(self, func, *args, **kwargs):
        self._callback_add("dismissed", func, *args, **kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)


_object_mapping_register("elm_ctxpopup", Ctxpopup)
