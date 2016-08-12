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

include "icon_cdef.pxi"

cdef class Icon(Image):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Icon(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_icon_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property thumb:
        """Set the file (and edje group) that will be used, but use a
        generated thumbnail.

        This functions like :py:attr:`~efl.elementary.image.Image.file` but
        requires the Ethumb library support to be enabled successfully with
        :py:func:`efl.elementary.need.need_ethumb`. When set the file indicated
        has a thumbnail generated and cached on disk for future use or will
        directly use an existing cached thumbnail if it is valid.

        :type: string ``file`` or tuple(string ``file``, string ``group``)

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            elm_icon_thumb_set(self.obj,
                <const char *>filename if filename is not None else NULL,
                <const char *>group if group is not None else NULL)

    def thumb_set(self, filename, group = None):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        elm_icon_thumb_set(self.obj,
            <const char *>filename if filename is not None else NULL,
            <const char *>group if group is not None else NULL)

    property standard:
        """The icon standards name.

        For example, freedesktop.org defines standard icon names such as
        "home", "network", etc. There can be different icon sets to match
        those icon keys. The ``name`` given as parameter is one of these
        "keys", and will be used to look in the freedesktop.org paths and
        elementary theme. One can change the lookup order with
        :py:attr:`order_lookup`.

        If name is not found in any of the expected locations and it is the
        absolute path of an image file, this image will be used.

        .. note::
            The icon image set can be changed by
            :py:attr:`~efl.elementary.image.Image.file`.

        .. seealso:: :py:attr:`~efl.elementary.image.Image.file`

        :type: string
        :raise RuntimeWarning: when setting the standard name fails.

        :return bool: For 1.7 compatibility standard_set() returns a bool value
            that tells whether setting the standard name was successful or not.

        .. versionchanged:: 1.8
            Raises RuntimeWarning when setting the standard name fails,
            instead of returning a bool.

        """
        def __get__(self):
            return _ctouni(elm_icon_standard_get(self.obj))

        def __set__(self, name):
            if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
            if not elm_icon_standard_set(self.obj,
                <const char *>name if name is not None else NULL):
                    raise RuntimeWarning("Setting standard icon failed")

    def standard_set(self, name):
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        return elm_icon_standard_set(self.obj,
            <const char *>name if name is not None else NULL)
    def standard_get(self):
        return _ctouni(elm_icon_standard_get(self.obj))

    property order_lookup:
        """The icon lookup order used by :py:attr:`standard`.

        :type: :ref:`Elm_Icon_Lookup_Order`

        """
        def __get__(self):
            return elm_icon_order_lookup_get(self.obj)

        def __set__(self, order):
            elm_icon_order_lookup_set(self.obj, order)

    def order_lookup_set(self, order):
        elm_icon_order_lookup_set(self.obj, order)
    def order_lookup_get(self):
        return elm_icon_order_lookup_get(self.obj)

    def callback_thumb_done_add(self, func, *args, **kwargs):
        """Setting :py:attr:`thumb` has completed with success."""
        self._callback_add("thumb,done", func, args, kwargs)

    def callback_thumb_done_del(self, func):
        self._callback_del("thumb,done", func)

    def callback_thumb_error_add(self, func, *args, **kwargs):
        """Setting :py:attr:`thumb` has failed."""
        self._callback_add("thumb,error", func, args, kwargs)

    def callback_thumb_error_del(self, func):
        self._callback_del("thumb,error", func)


_object_mapping_register("Elm_Icon", Icon)
