# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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

"""

.. image:: /images/photo-preview.png

Widget description
------------------

An Elementary photo widget is intended for displaying a photo, for
ex., a person's image (contact).

Simple, yet with a very specific purpose. It has a decorative frame
around the inner image itself, on the default theme.

This widget relies on an internal :py:class:`~efl.elementary.icon.Icon`, so
that the APIs of these two widgets are similar (drag and drop is also possible
here, for example).

Signals that you can add callbacks for are:

- ``clicked`` - This is called when a user has clicked the photo
- ``drag,start`` - One has started dragging the inner image out of the photo's
  frame
- ``drag,end`` - One has dropped the dragged image somewhere

"""

from cpython cimport PyUnicode_AsUTF8String

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object

cdef class Photo(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
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
                <const_char *>filename if filename is not None else NULL):
                    raise RuntimeError("Could not set file.")

    def file_set(self, filename):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if not elm_photo_file_set(self.obj,
            <const_char *>filename if filename is not None else NULL):
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
                <const_char *>filename if filename is not None else NULL,
                <const_char *>group if group is not None else NULL)

    def thumb_set(self, filename, group = None):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        elm_photo_thumb_set(self.obj,
            <const_char *>filename if filename is not None else NULL,
            <const_char *>group if group is not None else NULL)

    property size:
        """Set the size that will be used on the photo.

        :type: int

        """
        def __set__(self, size):
            elm_photo_size_set(self.obj, size)

    def size_set(self, size):
        elm_photo_size_set(self.obj, size)

    property fill_inside:
        """Set if the photo should be completely visible or not.

        :type: bool

        """
        def __set__(self, fill):
            elm_photo_fill_inside_set(self.obj, fill)

    def fill_inside_set(self, fill):
        elm_photo_fill_inside_set(self.obj, fill)

    property editable:
        """Set editability of the photo.

        An editable photo can be dragged to or from, and can be cut or
        pasted too.  Note that pasting an image or dropping an item on the
        image will delete the existing content.

        :type: bool

        """
        def __set__(self, fill):
            elm_photo_editable_set(self.obj, fill)

    def editable_set(self, fill):
        elm_photo_editable_set(self.obj, fill)

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
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_drag_start_add(self, func, *args, **kwargs):
        """One has started dragging the inner image out of the photo's
        frame.

        """
        self._callback_add("drag,start", func, *args, **kwargs)

    def callback_drag_start_del(self, func):
        self._callback_del("drag,start", func)

    def callback_drag_end_add(self, func, *args, **kwargs):
        """One has dropped the dragged image somewhere."""
        self._callback_add("drag,end", func, *args, **kwargs)

    def callback_drag_end_del(self, func):
        self._callback_del("drag,end", func)


_object_mapping_register("Elm_Photo", Photo)
