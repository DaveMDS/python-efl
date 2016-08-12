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
#

include "box_cdef.pxi"


ELM_BOX_LAYOUT_HORIZONTAL = 0
ELM_BOX_LAYOUT_VERTICAL = 1
ELM_BOX_LAYOUT_HOMOGENEOUS_VERTICAL = 2
ELM_BOX_LAYOUT_HOMOGENEOUS_HORIZONTAL = 3
ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_HORIZONTAL = 4
ELM_BOX_LAYOUT_HOMOGENEOUS_MAX_SIZE_VERTICAL = 5
ELM_BOX_LAYOUT_FLOW_HORIZONTAL = 6
ELM_BOX_LAYOUT_FLOW_VERTICAL = 7
ELM_BOX_LAYOUT_STACK = 8

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

cdef class BoxIterator(object):
    cdef const Eina_List *lst
    def __cinit__(self, Box box):
        self.lst = elm_box_children_get(box.obj)

    def __iter__(self):
        return self

    def __next__(self):
        if self.lst == NULL:
            raise StopIteration
        cdef cEo *ret = <cEo *>self.lst.data
        self.lst = self.lst.next
        return object_from_instance(ret)

cdef class Box(Object):
    """

    This is the class that actually implements the widget.

    By default, the box will be in vertical mode and non-homogeneous.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Box(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_box_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def __iter__(self):
        return BoxIterator(self)

    property horizontal:
        """The horizontal orientation.

        By default, box object arranges their contents vertically from top to
        bottom. By setting this property as *True*, the box will become
        horizontal, arranging contents from left to right.

        .. note:: This flag is ignored if a custom layout function is set.

        :type: bool

        """
        def __get__(self):
            return elm_box_horizontal_get(self.obj)
        def __set__(self, value):
            elm_box_horizontal_set(self.obj, value)

    def horizontal_set(self, horizontal):
        elm_box_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return elm_box_horizontal_get(self.obj)

    property homogeneous:
        """Whether the box is using homogeneous mode or not

        If enabled, homogeneous layout makes all items the same size, according
        to the size of the largest of its children.

        .. note:: This flag is ignored if a custom layout function is set.

        :type: bool

        """
        def __get__(self):
            return bool(elm_box_homogeneous_get(self.obj))

        def __set__(self, value):
            elm_box_homogeneous_set(self.obj, value)

    def homogeneous_set(self, homogeneous):
        elm_box_homogeneous_set(self.obj, homogeneous)
    def homogeneous_get(self):
        return bool(elm_box_homogeneous_get(self.obj))

    def pack_start(self, evasObject obj):
        """Add an object to the beginning of the pack list.

        Pack ``subobj`` into the box, placing it first in the list of
        children objects. The actual position the object will get on screen
        depends on the layout used. If no custom layout is set, it will be at
        the top or left, depending if the box is vertical or horizontal,
        respectively.

        :param subobj: The object to add to the box
        :type subobj: :py:class:`~efl.evas.Object`

        """
        elm_box_pack_start(self.obj, obj.obj)

    def pack_end(self, evasObject obj):
        """Add an object at the end of the pack list.

        Pack ``subobj`` into the box, placing it last in the list of
        children objects. The actual position the object will get on screen
        depends on the layout used. If no custom layout is set, it will be at
        the bottom or right, depending if the box is vertical or horizontal,
        respectively.

        :param subobj: The object to add to the box
        :type subobj: :py:class:`~efl.evas.Object`

        """
        elm_box_pack_end(self.obj, obj.obj)

    def pack_before(self, evasObject obj, evasObject before):
        """Adds an object to the box before the indicated object.

        This will add the ``subobj`` to the box indicated before the object
        indicated with ``before``. If ``before`` is not already in the box, results
        are undefined. Before means either to the left of the indicated object or
        above it depending on orientation.

        :param subobj: The object to add to the box
        :type subobj: :py:class:`~efl.evas.Object`
        :param before: The object before which to add it
        :type before: :py:class:`~efl.evas.Object`

        """
        elm_box_pack_before(self.obj, obj.obj, before.obj)

    def pack_after(self, evasObject obj, evasObject after):
        """Adds an object to the box after the indicated object.

        This will add the ``subobj`` to the box indicated after the object
        indicated with *after*. If ``after`` is not already in the box, results
        are undefined. After means either to the right of the indicated object or
        below it depending on orientation.

        :param subobj: The object to add to the box
        :type subobj: :py:class:`~efl.evas.Object`
        :param after: The object after which to add it
        :type after: :py:class:`~efl.evas.Object`

        """
        elm_box_pack_after(self.obj, obj.obj, after.obj)

    def clear(self):
        """Clear the box of all children

        Remove all the elements contained by the box, deleting the respective
        objects.

        """
        elm_box_clear(self.obj)

    def unpack(self, evasObject obj):
        """Unpack a box item.

        Remove the object given by ``subobj`` from the box without
        deleting it.

        :param subobj: The object to unpack
        :type subobj: :py:class:`~efl.evas.Object`

        """
        elm_box_unpack(self.obj, obj.obj)

    def unpack_all(self):
        """Remove all items from the box, without deleting them.

        Clear the box from all children, but don't delete the respective objects.
        If no other references of the box children exist, the objects will never
        be deleted, and thus the application will leak the memory. Make sure
        when using this function that you hold a reference to all the objects
        in the box.

        """
        elm_box_unpack_all(self.obj)

    property children:
        """Retrieve a list of the objects packed into the box

        Returns a ``list`` with the child :py:class:`Objects
        <efl.evas.Object>`. The order of the list corresponds to the
        packing order the box uses.

        :type: list of :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return eina_list_objects_to_python_list(elm_box_children_get(self.obj))

        #def __set__(self, value):
            #TODO: unpack_all() and then get the objects from value and pack_end() them.

        def __del__(self):
            elm_box_clear(self.obj)

    def children_get(self):
        return eina_list_objects_to_python_list(elm_box_children_get(self.obj))

    property padding:
        """The space (padding) between the box's elements.

        Extra space in pixels that will be added between a box child and its
        neighbors after its containing cell has been calculated. This padding
        is set for all elements in the box, besides any possible padding that
        individual elements may have through their size hints.

        :type: (int **h**, int **v**)

        """
        def __get__(self):
            cdef int horizontal, vertical
            elm_box_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            cdef int horizontal, vertical
            horizontal, vertical = value
            elm_box_padding_set(self.obj, horizontal, vertical)

    def padding_set(self, horizontal, vertical):
        elm_box_padding_set(self.obj, horizontal, vertical)
    def padding_get(self):
        cdef int horizontal, vertical
        elm_box_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    property align:
        """Set the alignment of the whole bounding box of contents.

        Sets how the bounding box containing all the elements of the box, after
        their sizes and position has been calculated, will be aligned within
        the space given for the whole box widget.

        :rtype: (float **h**, float **v**)

        """
        def __get__(self):
            cdef double horizontal, vertical
            elm_box_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, value):
            cdef double horizontal, vertical
            horizontal, vertical = value
            elm_box_align_set(self.obj, horizontal, vertical)

    def align_set(self, horizontal, vertical):
        elm_box_align_set(self.obj, horizontal, vertical)
    def align_get(self):
        cdef double horizontal, vertical
        elm_box_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def recalculate(self):
        """Force the box to recalculate its children packing.

        If any children was added or removed, box will not calculate the
        values immediately rather leaving it to the next main loop
        iteration. While this is great as it would save lots of
        recalculation, whenever you need to get the position of a just
        added item you must force recalculate before doing so.

        """
        elm_box_recalculate(self.obj)

    property layout:
        """Set the layout function for the box.

        A box layout function affects how a box object displays child
        elements within its area.

        Note that you cannot set a custom layout function.

        :type: :ref:`Evas_Object_Box_Layout`

        """
        def __set__(self, layout):
            cdef Evas_Object_Box_Layout ly
            ly = _py_elm_box_layout_resolv(layout)
            elm_box_layout_set(self.obj, ly, NULL, NULL)

    def layout_set(self, layout):
        cdef Evas_Object_Box_Layout ly
        ly = _py_elm_box_layout_resolv(layout)
        elm_box_layout_set(self.obj, ly, NULL, NULL)

    def layout_transition(self, duration, from_layout, to_layout):
        """Perform an animation between two given different layout.

        If you want to animate the change from one layout to another, you
        just need to call this function with the starting layout and
        the final one.

        :param duration: the animation duration in seconds
        :type duration: float
        :param from_layout: one of elementary.ELM_BOX_LAYOUT
        :type from_layout: :ref:`Evas_Object_Box_Layout`
        :param to_layout: one of elementary.ELM_BOX_LAYOUT
        :type to_layout: :ref:`Evas_Object_Box_Layout`

        """
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


_object_mapping_register("Elm_Box", Box)
