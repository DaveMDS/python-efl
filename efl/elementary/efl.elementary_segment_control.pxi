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


cdef class SegmentControlItem(ObjectItem):

    def index_get(self):
        return elm_segment_control_item_index_get(self.item)

    property index:
        def __get__(self):
            return elm_segment_control_item_index_get(self.item)

    def object_get(self):
        return object_from_instance(elm_segment_control_item_object_get(self.item))

    property object:
        def __get__(self):
            return object_from_instance(elm_segment_control_item_object_get(self.item))

    def selected_set(self, select):
        elm_segment_control_item_selected_set(self.item, select)

    property selected:
        def __set__(self, select):
            elm_segment_control_item_selected_set(self.item, select)


cdef class SegmentControl(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_segment_control_add(parent.obj))

    def item_add(self, evasObject icon, label = None):
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_add(self.obj,
                                            icon.obj if icon else NULL,
                                            _cfruni(label))
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_insert_at(self, evasObject icon, label = None, index = 0):
        cdef SegmentControlItem ret = SegmentControlItem()
        cdef Elm_Object_Item *item

        item = elm_segment_control_item_insert_at(self.obj,
                                                  icon.obj if icon else NULL,
                                                  _cfruni(label), index)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_del_at(self, index):
        elm_segment_control_item_del_at(self.obj, index)

    property item_count:
        def __get__(self):
            return elm_segment_control_item_count_get(self.obj)

    def item_get(self, index):
        return _object_item_to_python(elm_segment_control_item_get(self.obj, index))

    def item_label_get(self, index):
        return _ctouni(elm_segment_control_item_label_get(self.obj, index))

    def item_icon_get(self, index):
        return object_from_instance(elm_segment_control_item_icon_get(self.obj, index))

    property item_selected:
        def __get__(self):
            return _object_item_to_python(elm_segment_control_item_selected_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("changed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed", _cb_object_item_conv, func)


_object_mapping_register("elm_segment_control", SegmentControl)
