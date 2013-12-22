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

Widget description
------------------

.. image:: /images/mapbuf-preview.png
    :align: left

This holds one content object and uses an Evas Map of transformation
points to be later used with this content. So the content will be
moved, resized, etc as a single image. So it will improve performance
when you have a complex interface, with a lot of elements, and will
need to resize or move it frequently (the content object and its
children).

Default content parts of the mapbuf widget that you can use are:

- ``default`` - The main content of the mapbuf

"""

from efl.eo cimport _object_mapping_register
from efl.evas cimport Object as evasObject
from object cimport Object

cdef class Mapbuf(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_mapbuf_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property enabled:
        """The enabled state of the map.

        :type: bool

        """
        def __get__(self):
            return bool(elm_mapbuf_enabled_get(self.obj))

        def __set__(self, enabled):
            elm_mapbuf_enabled_set(self.obj, enabled)

    def enabled_set(self, enabled):
        elm_mapbuf_enabled_set(self.obj, enabled)
    def enabled_get(self):
        return bool(elm_mapbuf_enabled_get(self.obj))

    property smooth:
        """Smooth map rendering.

        This sets smoothing for map rendering. If the object is a type that
        has its own smoothing settings, then both the smooth settings for
        this object and the map must be turned off.

        By default smooth maps are enabled.

        :type: bool

        """
        def __get__(self):
            return bool(elm_mapbuf_smooth_get(self.obj))

        def __set__(self, smooth):
            elm_mapbuf_smooth_set(self.obj, smooth)

    def smooth_set(self, smooth):
        elm_mapbuf_smooth_set(self.obj, smooth)
    def smooth_get(self):
        return bool(elm_mapbuf_smooth_get(self.obj))

    property alpha:
        """The alpha state of the map.

        :type: bool

        """
        def __get__(self):
            return bool(elm_mapbuf_alpha_get(self.obj))

        def __set__(self, alpha):
            elm_mapbuf_alpha_set(self.obj, alpha)

    def alpha_set(self, alpha):
        elm_mapbuf_alpha_set(self.obj, alpha)
    def alpha_get(self):
        return bool(elm_mapbuf_alpha_get(self.obj))

    property auto:
        """When a mapbuf object has "auto mode" enabled, then it will enable and
        disable map mode based on current visibility. Mapbuf will track if you show
        or hide it AND if the object is inside the canvas viewport or not when it
        is moved or resized. Note that if you turn automode off, then map mode
        will be in a disabled state at this point. When you turn it on for the
        first time, the current state will be evaluated base on current properties
        of the mapbuf object.

        Auto mode is disabled by default.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint on):
            elm_mapbuf_auto_set(self.obj, on)

        def __get__(self):
            return bool(elm_mapbuf_auto_get(self.obj))

    def auto_set(self, bint on):
        elm_mapbuf_auto_set(self.obj, on)

    def auto_get(self):
        return bool(elm_mapbuf_auto_get(self.obj))


_object_mapping_register("Elm_Mapbuf", Mapbuf)
