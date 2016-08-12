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

include "mapbuf_cdef.pxi"

cdef class Mapbuf(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Mapbuf(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
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

    def point_color_set(self, int idx, int r, int g, int b, int a):
        """Set the color of a vertex in the mapbuf.

        This sets the color of the vertex in the mapbuf. Colors will be linearly
        interpolated between vertex points through the mapbuf. Color will multiply
        the "texture" pixels (like GL_MODULATE in OpenGL). The default color of
        a vertex in a mapbuf is white solid (255, 255, 255, 255) which means it will
        have no affect on modifying the texture pixels.

        :param idx: index of point to change. Must be smaller than mapbuf size.
        :param r: red (0 - 255)
        :param g: green (0 - 255)
        :param b: blue (0 - 255)
        :param a: alpha (0 - 255)

        .. versionadded:: 1.9

        """
        elm_mapbuf_point_color_set(self.obj, idx, r, g, b, a)

    def point_color_get(self, int idx):
        """Get the color on a vertex in the mapbuf.

        This gets the color set by :py:func:`point_color_set()` on the given vertex
        of the mapbuf.

        :param idx: index of point to query. Must be smaller than mapbuf size.
        :return: the color of the point
        :rtype: tuple (r, g, b, a)

        .. versionadded:: 1.9

        """
        cdef int r, g, b, a

        elm_mapbuf_point_color_get(self.obj, idx, &r, &g, &b, &a)
        return (r, g, b, a)


_object_mapping_register("Elm_Mapbuf", Mapbuf)
