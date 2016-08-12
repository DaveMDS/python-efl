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

include "plug_cdef.pxi"

cdef class Plug(Object):
    """

    An object that allows one to show an image which other process created.
    It can be used anywhere like any other elementary widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Plug(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_plug_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def connect(self, svcname, int svcnum, bint svcsys):
        """Connect a plug widget to service provided by socket image.

        :param svcname: The service name to connect to set up by the socket.
        :type svcname: string
        :param svcnum: The service number to connect to (set up by socket).
        :type svcnum: int
        :param svcsys: Boolean to set if the service is a system one or not
            (set up by socket).
        :type svcsys: bool

        :raise RuntimeError: on failure

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(svcname, unicode): svcname = PyUnicode_AsUTF8String(svcname)
        if not elm_plug_connect(self.obj,
            <const char *>svcname if svcname is not None else NULL,
            svcnum, svcsys):
            raise RuntimeError

    property image_object:
        """Get the basic Image object from this object (widget).

        This function allows one to get the underlying ``Object`` of type
        Image from this elementary widget. It can be useful to do things
        like get the pixel data, save the image to a file, etc.

        .. note:: Be careful to not manipulate it, as it is under control of
            elementary.

        :type: :py:class:`~efl.evas.Image`

        """
        def __get__(self):
            return object_from_instance(elm_plug_image_object_get(self.obj))


    def callback_clicked_add(self, func, *args, **kwargs):
        """the user clicked the image (press/release)."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_image_deleted_add(self, func, *args, **kwargs):
        """the server side was deleted."""
        self._callback_add("image,deleted", func, args, kwargs)

    def callback_image_deleted_del(self, func):
        self._callback_del("image,deleted", func)

    # TODO: Conv function
    # def callback_image_resized_add(self, func, *args, **kwargs):
    #     """the server side was resized. The ``event_info`` parameter of
    #     the callback will be ``Evas_Coord_Size`` (two integers)."""
    #     self._callback_add("image,resized", func, args, kwargs)

    # def callback_image_resized_del(self, func):
    #     self._callback_del("image,resized", func)


_object_mapping_register("Elm_Plug", Plug)
