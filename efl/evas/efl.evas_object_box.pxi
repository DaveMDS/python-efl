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



cdef class Box(Object):
    """

    A box is a convenience smart object that packs children inside it in
    **sequence**, using a layouting function specified by the user.

    There are a couple of pre-made layouting functions **built-in in Evas**,
    all of them using children size hints to define their size and alignment
    inside their cell space.


    """
    def __init__(self, Canvas canvas not None, **kwargs):
        """Box(...)

        :param canvas: The evas canvas for this object
        :type canvas: :py:class:`Canvas`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(evas_object_box_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)

    property align:
        """Alignment of the whole bounding box of contents

        :type: (double **h**, double **v**)

        This will influence how a box object is to align its bounding box
        of contents within its own area. The values **must** be in the range
        ``0.0 - 1.0``, or undefined behavior is expected. For horizontal
        alignment, ``0.0`` means to the left, with ``1.0`` meaning to the
        right. For vertical alignment, ``0.0`` means to the top, with ``1.0``
        meaning to the bottom.

        .. note:: The default values for both alignments is ``0.5``.

        """
        def __get__(self):
            cdef double horizontal, vertical
            evas_object_box_align_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, v):
            cdef double horizontal, vertical
            horizontal, vertical = v
            evas_object_box_align_set(self.obj, horizontal, vertical)

    def align_get(self):
        cdef double horizontal, vertical
        evas_object_box_align_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def align_set(self, double horizontal, double vertical):
        evas_object_box_align_set(self.obj, horizontal, vertical)

    property padding:
        """Set the (space) padding between cells set for a given box object.

        :type: (int **h**, int **v**)

        .. note:: The default values for both padding components is ``0``.

        """
        def __get__(self):
            cdef Evas_Coord horizontal, vertical
            evas_object_box_padding_get(self.obj, &horizontal, &vertical)
            return (horizontal, vertical)

        def __set__(self, v):
            cdef Evas_Coord horizontal, vertical
            horizontal, vertical = v
            evas_object_box_padding_set(self.obj, horizontal, vertical)

    def padding_get(self):
        cdef Evas_Coord horizontal, vertical
        evas_object_box_padding_get(self.obj, &horizontal, &vertical)
        return (horizontal, vertical)

    def padding_set(self, Evas_Coord horizontal, Evas_Coord vertical):
        evas_object_box_padding_set(self.obj, horizontal, vertical)

    def append(self, Object child):
        """Append a new child object to the box object.

        :param child: A child Evas object to be made a member of this object
        :return: A box option bound to the recently added box item or None,
            on errors

        On success, the ``"child,added"`` smart event will take place.

        .. note::

            The actual placing of the item relative to objects area will
            depend on the layout set to it. For example, on horizontal layouts
            an item in the end of the box's list of children will appear on its
            right.

        .. note::

            This call will trigger the box's _Evas_Object_Box_Api::append
            smart function.

        """
        evas_object_box_append(self.obj, child.obj)

    def prepend(self, Object child):
        """Prepend a new child object to the box object.

        :param child: A child Evas object to be made a member of this object
        :return: A box option bound to the recently added box item or None,
            on errors

        On success, the ``"child,added"`` smart event will take place.

        .. note::

            The actual placing of the item relative to objects area will depend
            on the layout set to it. For example, on horizontal layouts an item
            in the beginning of the box's list of children will appear on its
            left.

        .. note::

            This call will trigger the box's _Evas_Object_Box_Api::prepend
            smart function.

        """
        evas_object_box_prepend(self.obj, child.obj)

    def insert_before(self, Object child, Object reference):
        """Insert a new ``child`` object **before another existing one**, in
        a given box object.

        :param child: A child Evas object to be made a member of this object
        :param reference: The child object to place this new one before
        :return: A box option bound to the recently added box item or ``None``, on errors

        On success, the ``"child,added"`` smart event will take place.

        .. note::

            This function will fail if **reference** is not a member of this object.

        .. note::

            The actual placing of the item relative to **o**'s area will
            depend on the layout set to it.

        .. note::

            This call will trigger the box's
            _Evas_Object_Box_Api::insert_before smart function.

        """
        # TODO: raise exception if unsuccessful
        evas_object_box_insert_before(self.obj, child.obj, reference.obj)

    def insert_after(self, Object child, Object reference):
        """Insert a new ``child`` object **after another existing one**, in
        this box object.

        :param child: A child Evas object to be made a member of this object
        :param reference: The child object to place this new one after
        :return: A box option bound to the recently added box item or ``None``, on errors

        On success, the ``"child,added"`` smart event will take place.

        .. note::

            This function will fail if **reference** is not a member of this object.

        .. note::

            The actual placing of the item relative to this objects area will
            depend on the layout set to it.

        .. note::

            This call will trigger the box's
            _Evas_Object_Box_Api::insert_after smart function.

        """
        # TODO: raise exception if unsuccessful
        evas_object_box_insert_after(self.obj, child.obj, reference.obj)

    def insert_at(self, Object child, unsigned int pos):
        """Insert a new ``child`` object **at a given position**, in this
        box object.

        :param child: A child Evas object to be made a member of this object
        :param pos: The numeric position (starting from ``0``) to place the
            new child object at
        :return: A box option bound to the recently added box item or ``None``, on errors

        On success, the ``"child,added"`` smart event will take place.

        .. note::

            This function will fail if the given position is invalid,
            given this objects internal list of elements.

        .. note::

            The actual placing of the item relative to this objects area will
            depend on the layout set to it.

        .. note::

            This call will trigger the box's
            _Evas_Object_Box_Api::insert_at smart function.

        """
        evas_object_box_insert_at(self.obj, child.obj, pos)

    def remove(self, Object child):
        """Remove a given object from a box object, unparenting it again.

        :param child: The handle to the child object to be removed
        :return: ``True``, on success, ``False`` otherwise

        On removal, you'll get an unparented object again, just as it was
        before you inserted it in the box. The
        _Evas_Object_Box_Api::option_free box smart callback will be called
        automatically for you and, also, the ``"child,removed"`` smart event
        will take place.

        .. note::

            This call will trigger the box's _Evas_Object_Box_Api::remove
            smart function.

        """
        return evas_object_box_remove(self.obj, child.obj)

    def remove_at(self, unsigned int pos):
        """Remove an object, **bound to a given position** in a box object,
        unparenting it again.

        :param pos: The numeric position (starting from ``0``) of the child
            object to be removed
        :return: ``True``, on success, ``False`` otherwise

        On removal, you'll get an unparented object again, just as it was
        before you inserted it in the box. The ``option_free`` box smart
        callback will be called automatically for you and, also, the
        ``"child,removed"`` smart event will take place.

        .. note::

            This function will fail if the given position is invalid,
            given **o**'s internal list of elements.

        .. note::

            This call will trigger the box's
            _Evas_Object_Box_Api::remove_at smart function.

        """
        return evas_object_box_remove_at(self.obj, pos)

    def remove_all(self, Eina_Bool clear):
        """Remove **all** child objects from a box object, unparenting them
        again.

        :param clear: if true, it will delete just removed children.
        :return: ``True``, on success, ``False`` otherwise

        This has the same effect of calling evas_object_box_remove() on
        each of **o**'s child objects, in sequence. If, and only if, all
        those calls succeed, so does this one.

        """
        return evas_object_box_remove_all(self.obj, clear)


_object_mapping_register("Evas_Box", Box)
