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


from efl.evas cimport evas_object_box_layout_horizontal
from efl.evas cimport evas_object_box_layout_vertical
from efl.evas cimport evas_object_box_layout_homogeneous_vertical
from efl.evas cimport evas_object_box_layout_homogeneous_horizontal
from efl.evas cimport evas_object_box_layout_homogeneous_max_size_horizontal
from efl.evas cimport evas_object_box_layout_homogeneous_max_size_vertical
from efl.evas cimport evas_object_box_layout_flow_horizontal
from efl.evas cimport evas_object_box_layout_flow_vertical
from efl.evas cimport evas_object_box_layout_stack
from efl.evas cimport elm_box_layout_transition

# ctypedef enum Elm_Box_CLayout:
#     ELM_BOX_LAYOUT_HORIZONTAL
#     ELM_BOX_LAYOUT_VERTICAL
#     ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL
#     ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL
#     ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL
#     ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL
#     ELM_BOX_LAYOUT_FLOW_HORIZONTAL
#     ELM_BOX_LAYOUT_FLOW_VERTICAL
#     ELM_BOX_LAYOUT_STACK

cdef Evas_Object_Box_Layout _py_elm_box_layout_resolv(int layout) with gil:
    if layout == ELM_BOX_LAYOUT_HORIZONTAL:
        return evas_object_box_layout_horizontal
    elif layout == ELM_BOX_LAYOUT_VERTICAL:
        return evas_object_box_layout_vertical
    elif layout == ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL:
        return evas_object_box_layout_homogeneous_vertical
    elif layout == ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL:
        return evas_object_box_layout_homogeneous_horizontal
    elif layout == ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL:
        return evas_object_box_layout_homogeneous_max_size_horizontal
    elif layout == ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL:
        return evas_object_box_layout_homogeneous_max_size_vertical
    elif layout == ELM_BOX_LAYOUT_FLOW_HORIZONTAL:
        return evas_object_box_layout_flow_horizontal
    elif layout == ELM_BOX_LAYOUT_FLOW_VERTICAL:
        return evas_object_box_layout_flow_vertical
    elif layout == ELM_BOX_LAYOUT_STACK:
        return evas_object_box_layout_stack
    return evas_object_box_layout_vertical


cdef class Box(Object):

    def __init__(self, evasObject parent):
        self._set_obj(elm_box_add(parent.obj))

    def horizontal_set(self, horizontal):
        elm_box_horizontal_set(self.obj, horizontal)

    def horizontal_get(self):
        return elm_box_horizontal_get(self.obj)

    property horizontal:
        def __get__(self):
            return elm_box_horizontal_get(self.obj)
        def __set__(self, value):
            elm_box_horizontal_set(self.obj, value)

    def homogeneous_set(self, homogeneous):
        elm_box_homogeneous_set(self.obj, homogeneous)

    def homogeneous_get(self):
        return bool(elm_box_homogeneous_get(self.obj))

    property homogeneous:
        def __get__(self):
            return bool(elm_box_homogeneous_get(self.obj))

        def __set__(self, value):
            elm_box_homogeneous_set(self.obj, value)

    def pack_start(self, evasObject obj):
        elm_box_pack_start(self.obj, obj.obj)

    def pack_end(self, evasObject obj):
        elm_box_pack_end(self.obj, obj.obj)

    def pack_before(self, evasObject obj, evasObject before):
        elm_box_pack_before(self.obj, obj.obj, before.obj)

    def pack_after(self, evasObject obj, evasObject after):
        elm_box_pack_after(self.obj, obj.obj, after.obj)

    def clear(self):
        elm_box_clear(self.obj)

    def unpack(self, evasObject obj):
        elm_box_unpack(self.obj, obj.obj)

    def unpack_all(self):
        elm_box_unpack_all(self.obj)

    def children_get(self):
        return _object_list_to_python(elm_box_children_get(self.obj))

    property children:
        def __get__(self):
            return _object_list_to_python(elm_box_children_get(self.obj))
        #def __set__(self, value):
            #TODO: unpack_all() and then get the objects from value and pack_end() them.
        def __del__(self):
            elm_box_clear(self.obj)

    def padding_set(self, horizontal, vertical):
        elm_box_padding_set(self.obj, horizontal, vertical)

    def padding_get(self):
        cdef int horizontal, vertical

        elm_box_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property padding:
        def __get__(self):
            cdef int horizontal, vertical
            elm_box_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            cdef int horizontal, vertical
            horizontal, vertical = value
            elm_box_padding_set(self.obj, horizontal, vertical)

    def align_set(self, horizontal, vertical):
        elm_box_align_set(self.obj, horizontal, vertical)

    def align_get(self):
        cdef double horizontal, vertical

        elm_box_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property align:
        def __get__(self):
            cdef double horizontal, vertical
            elm_box_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            cdef double horizontal, vertical
            horizontal, vertical = value
            elm_box_align_set(self.obj, horizontal, vertical)

    def recalculate(self):
        elm_box_recalculate(self.obj)

    def layout_set(self, layout):
        cdef Evas_Object_Box_Layout ly

        ly = _py_elm_box_layout_resolv(layout)
        elm_box_layout_set(self.obj, ly, NULL, NULL)

    property layout:
        def __set__(self, layout):
            cdef Evas_Object_Box_Layout ly
            ly = _py_elm_box_layout_resolv(layout)
            elm_box_layout_set(self.obj, ly, NULL, NULL)

    def layout_transition(self, duration, from_layout, to_layout):
        cdef Elm_Box_Transition *t
        cdef Evas_Object_Box_Layout ly_from, ly_to

        ly_from = _py_elm_box_layout_resolv(from_layout)
        ly_to = _py_elm_box_layout_resolv(to_layout)
        t = elm_box_transition_new(duration,
                              ly_from, NULL, NULL,
                              ly_to, NULL, NULL,
                              NULL, NULL)
        elm_box_layout_set(self.obj, elm_box_layout_transition, t,
                           elm_box_transition_free)


_object_mapping_register("elm_box", Box)
