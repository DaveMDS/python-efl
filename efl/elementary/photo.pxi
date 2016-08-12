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

include "photo_cdef.pxi"

cdef class Photo(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Photo(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_photo_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property file:
        """Set the file that will be used as photo

        :type: string
        :raise RuntimeError: when setting the file fails

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the file fails

        """
        def __set__(self, filename):
            if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
            if not elm_photo_file_set(self.obj,
                <const char *>filename if filename is not None else NULL):
                    raise RuntimeError("Could not set file.")

    def file_set(self, filename):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if not elm_photo_file_set(self.obj,
            <const char *>filename if filename is not None else NULL):
                raise RuntimeError("Could not set file.")

    property thumb:
        """Set the file that will be used as thumbnail in the photo.

        :type: string or tuple of strings

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            elm_photo_thumb_set(self.obj,
                <const char *>filename if filename is not None else NULL,
                <const char *>group if group is not None else NULL)

    def thumb_set(self, filename, group = None):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        elm_photo_thumb_set(self.obj,
            <const char *>filename if filename is not None else NULL,
            <const char *>group if group is not None else NULL)

    property size:
        """The size that will be used on the photo.

        :type: int

        .. versionchanged:: 1.18
            This property is now also readable

        """
        def __set__(self, int size):
            elm_photo_size_set(self.obj, size)
        def __get__(self):
            return elm_photo_size_get(self.obj)

    def size_set(self, size):
        elm_photo_size_set(self.obj, size)
    def size_get(self):
        return elm_photo_size_get(self.obj)

    property fill_inside:
        """If the photo should be completely visible or not.

        :type: bool

        .. versionchanged:: 1.18
            This property is now also readable

        """
        def __set__(self, bint fill):
            elm_photo_fill_inside_set(self.obj, fill)
        def __get__(self):
            return bool(elm_photo_fill_inside_get(self.obj))

    def fill_inside_set(self, bint fill):
        elm_photo_fill_inside_set(self.obj, fill)
    def fill_inside_set(self):
        return bool(elm_photo_fill_inside_get(self.obj))

    property editable:
        """Editability of the photo.

        An editable photo can be dragged to or from, and can be cut or
        pasted too.  Note that pasting an image or dropping an item on the
        image will delete the existing content.

        :type: bool

        .. versionchanged:: 1.18
            This property is now also readable

        """
        def __set__(self, bint editable):
            elm_photo_editable_set(self.obj, editable)
        def __get__(self):
            return bool(elm_photo_editable_get(self.obj))

    def editable_set(self, bint editable):
        elm_photo_editable_set(self.obj, editable)
    def editable_get(self):
       return bool(elm_photo_editable_get(self.obj))

    property aspect_fixed:
        """Whether the original aspect ratio of the photo should be kept on
        resize.

        The original aspect ratio (width / height) of the photo is usually
        distorted to match the object's size. Enabling this option will fix
        this original aspect, and the way that the photo is fit into the
        object's area

        :type: bool

        """
        def __get__(self):
            return elm_photo_aspect_fixed_get(self.obj)

        def __set__(self, fixed):
            elm_photo_aspect_fixed_set(self.obj, fixed)

    def aspect_fixed_set(self, fixed):
        elm_photo_aspect_fixed_set(self.obj, fixed)
    def aspect_fixed_get(self):
        return elm_photo_aspect_fixed_get(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        """This is called when a user has clicked the photo."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_drag_start_add(self, func, *args, **kwargs):
        """One has started dragging the inner image out of the photo's
        frame.

        """
        self._callback_add("drag,start", func, args, kwargs)

    def callback_drag_start_del(self, func):
        self._callback_del("drag,start", func)

    def callback_drag_end_add(self, func, *args, **kwargs):
        """One has dropped the dragged image somewhere."""
        self._callback_add("drag,end", func, args, kwargs)

    def callback_drag_end_del(self, func):
        self._callback_del("drag,end", func)


_object_mapping_register("Elm_Photo", Photo)
