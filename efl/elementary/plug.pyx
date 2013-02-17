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
#

include "widget_header.pxi"

from object cimport Object

from efl.evas cimport Image as evasImage

cdef class Plug(Object):

    """

    An object that allows one to show an image which other process created.
    It can be used anywhere like any other elementary widget.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_plug_add(parent.obj))

    def connect(self, svcname, svcnum, svcsys):
        """connect(unicode svcname, int svcnum, bool svcsys) -> bool

        Connect a plug widget to service provided by socket image.

        :param svcname: The service name to connect to set up by the socket.
        :type svcname: string
        :param svcnum: The service number to connect to (set up by socket).
        :type svcnum: int
        :param svcsys: Boolean to set if the service is a system one or not
            (set up by socket).
        :type svcsys: bool

        :return: (``True`` = success, ``False`` = error)
        :rtype: bool

        """
        return bool(elm_plug_connect(self.obj, _cfruni(svcname), svcnum, svcsys))

    property image_object:
        """Get the basic Evas_Image object from this object (widget).

        This function allows one to get the underlying ``Object`` of type
        Image from this elementary widget. It can be useful to do things
        like get the pixel data, save the image to a file, etc.

        .. note:: Be careful to not manipulate it, as it is under control of
            elementary.

        :type: :py:class:`Object`

        """
        def __get__(self):
            cdef evasImage img = evasImage()
            cdef Evas_Object *obj = elm_plug_image_object_get(self.obj)
            img.obj = obj
            return img


_object_mapping_register("elm_plug", Plug)
