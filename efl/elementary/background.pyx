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

"""

.. rubric:: Background tiling modes

.. data:: ELM_BG_OPTION_CENTER

    Center

.. data:: ELM_BG_OPTION_SCALE

    Scale

.. data:: ELM_BG_OPTION_STRETCH

    Stretch

.. data:: ELM_BG_OPTION_TILE

    Tile

"""

include "widget_header.pxi"

from layout_class cimport LayoutClass

cimport enums

ELM_BG_OPTION_CENTER = enums.ELM_BG_OPTION_CENTER
ELM_BG_OPTION_SCALE = enums.ELM_BG_OPTION_SCALE
ELM_BG_OPTION_STRETCH = enums.ELM_BG_OPTION_STRETCH
ELM_BG_OPTION_TILE = enums.ELM_BG_OPTION_TILE
ELM_BG_OPTION_LAST = enums.ELM_BG_OPTION_LAST

cdef class Background(LayoutClass):

    """

    Background widget object

    Used for setting a solid color, image or Edje group as a background to a
    window or any container object.

    The background widget is used for setting (solid) background decorations
    to a window (unless it has transparency enabled) or to any container
    object. It works just like an image, but has some properties useful to a
    background, like setting it to tiled, centered, scaled or stretched.

    Default content parts of the bg widget that you can use for are:

    - **overlay** - overlay of the bg

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_bg_add(parent.obj))

    property file:
        """The file (image or edje collection) giving life for the background.

        This property contains the image file name (and edje group) used in
        the background object. If the image comes from an Edje group, it
        will be stretched to completely fill the background object. If it
        comes from a traditional image file, it will by default be centered
        in this widget's are (thus retaining its aspect), what could lead to
        some parts being not visible. You may change the mode of exhibition
        for a real image file with :py:attr:`option`.

        .. note:: Once the image is set, a previously set one will be deleted,
            even if **file** is *None*.

        .. note:: This will only affect the contents of one of the background's
            swallow spots, namely *"elm.swallow.background"*. If you want to
            achieve the :py:class:`elementary.layout.Layout`'s file setting
            behavior, you'll have to call that method on this object.

        :type: string file, optional string group

        """
        def __get__(self):
            cdef const_char *filename, *group
            elm_bg_file_get(self.obj, &filename, &group)
            if filename == NULL:
                filename = ""
            if group == NULL:
                group = ""
            return (_ctouni(filename), _ctouni(group))

        def __set__(self, value):
            if isinstance(value, tuple) or isinstance(value, list):
                filename, group = value
            else:
                filename = value
                group = ""
            elm_bg_file_set(self.obj, _cfruni(filename), _cfruni(group))

    def file_set(self, filename, group = ""):
        return bool(elm_bg_file_set(self.obj, _cfruni(filename), _cfruni(group)))
    def file_get(self):
        cdef const_char *filename, *group
        elm_bg_file_get(self.obj, &filename, &group)
        if filename == NULL:
            filename = ""
        if group == NULL:
            group = ""
        return (_ctouni(filename), _ctouni(group))

    property option:
        """The mode of display for a given background widget's image.

        This property reflects how the background widget will display its
        image. This will only work if :py:attr:`file` was previously set with an
        image file. The image can be displayed tiled, scaled, centered or
        stretched.

        :type: Elm_Bg_Option

        """
        def __get__(self):
            return elm_bg_option_get(self.obj)

        def __set__(self, value):
            elm_bg_option_set(self.obj, value)

    def option_set(self, option):
        elm_bg_option_set(self.obj, option)
    def option_get(self):
        return elm_bg_option_get(self.obj)

    property color:
        """The color on a given background widget.

        This property reflects the color used for the background rectangle,
        in RGB format. Each color component's range is from 0 to 255.

        .. note:: You probably only want to use this property if you haven't
            previously set :py:attr:`file`, so that you just want a solid color
            background.

        :type: (int r, int g, int b)

        """
        def __get__(self):
            cdef int r, g, b
            elm_bg_color_get(self.obj, &r, &g, &b)
            return (r, g, b)

        def __set__(self, value):
            cdef int r, g, b
            r, g, b = value
            elm_bg_color_set(self.obj, r, g, b)

    def color_set(self, r, g, b):
        elm_bg_color_set(self.obj, r, g, b)
    def color_get(self):
        cdef int r, g, b
        elm_bg_color_get(self.obj, &r, &g, &b)
        return (r, g, b)

    property load_size:
        """The size of the pixmap representation of the image set on a given
        background widget.

        This property sets a new size for pixmap representation of the
        given bg image. It allows for the image to be loaded already in the
        specified size, reducing the memory usage and load time (for
        example, when loading a big image file with its load size set to a
        smaller size)

        .. note:: This is just a hint for the underlying system. The real size
            of the pixmap may differ depending on the type of image being
            loaded, being bigger than requested.

        .. warning:: This function just makes sense if an image file was set
            with :py:attr:`file`.

        :type: (Evas_Coord w, Evas_Coord h)

        """
        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_bg_load_size_set(self.obj, w, h)

    def load_size_set(self, w, h):
        elm_bg_load_size_set(self.obj, w, h)

_object_mapping_register("elm_bg", Background)
