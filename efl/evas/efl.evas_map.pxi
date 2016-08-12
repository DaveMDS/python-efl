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


cdef class Map(object):
    """

    Evas allows different transformations to be applied to all kinds of
    objects. These are applied by means of UV mapping.

    With UV mapping, one maps points in the source object to a 3D space
    positioning at target. This allows rotation, perspective, scale and
    lots of other effects, depending on the map that is used.

    Each map point may carry a multiplier color. If properly
    calculated, these can do shading effects on the object, producing
    3D effects.

    As usual, Evas provides both the raw and easy to use methods. The
    raw methods allow developers to create their maps somewhere else,
    possibly loading them from some file format. The easy to use methods
    calculate the points given some high-level parameters such as
    rotation angle, ambient light, and so on.

    .. note: applying mapping will reduce performance, so use with
        care. The impact on performance depends on engine in
        use. Software is quite optimized, but not as fast as OpenGL.

    A map consists of a set of points, currently only four are supported. Each
    of these points contains a set of canvas coordinates *x* and *y* that
    can be used to alter the geometry of the mapped object, and a *z*
    coordinate that indicates the depth of that point. This last coordinate
    does not normally affect the map, but it's used by several of the utility
    functions to calculate the right position of the point given other
    parameters.

    The coordinates for each point are set with evas_map_point_coord_set().
    """
    # In pxd: cdef Evas_Map *map

    def __cinit__(self, *a, **ka):
        self.map = NULL

    def __init__(self, int count):
        self.map = evas_map_new(count)

    def delete(self):
        """delete the map object"""
        evas_map_free(self.map)
        self.map = NULL

    def util_points_populate_from_object_full(self, Object obj, Evas_Coord z):
        """Populate source and destination map points to match exactly object.

        Usually one initialize map of an object to match it's original
        position and size, then transform these with evas_map_util_*
        functions, such as evas_map_util_rotate() or
        evas_map_util_3d_rotate(). The original set is done by this
        function, avoiding code duplication all around.


        :param obj: object to use unmapped geometry to populate map coordinates.
        :param z: Point Z Coordinate hint (pre-perspective transform). This value
                  will be used for all four points.

        """
        evas_map_util_points_populate_from_object_full(self.map, obj.obj, z)

    def util_points_populate_from_object(self, Object obj):
        """Populate source and destination map points to match exactly object.

        Usually one initialize map of an object to match it's original
        position and size, then transform these with evas_map_util_*
        functions, such as evas_map_util_rotate() or
        evas_map_util_3d_rotate(). The original set is done by this
        function, avoiding code duplication all around.

        Z Point coordinate is assumed as 0 (zero).

        :param obj: object to use unmapped geometry to populate map coordinates.

        """
        evas_map_util_points_populate_from_object(self.map, obj.obj)

    def util_points_populate_from_geometry(self, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h, Evas_Coord z):
        """Populate source and destination map points to match given geometry.

        Similar to evas_map_util_points_populate_from_object_full(), this
        call takes raw values instead of querying object's unmapped
        geometry. The given width will be used to calculate destination
        points (evas_map_point_coord_set()) and set the image uv
        (evas_map_point_image_uv_set()).

        :param x: Point X Coordinate
        :param y: Point Y Coordinate
        :param w: width to use to calculate second and third points.
        :param h: height to use to calculate third and fourth points.
        :param z: Point Z Coordinate hint (pre-perspective transform). This value
                will be used for all four points.

        """
        evas_map_util_points_populate_from_geometry(self.map, x, y, w, h, z)

    def util_points_color_set(self, int r, int g, int b, int a):
        """Set color of all points to given color.

        This call is useful to reuse maps after they had 3d lightning or
        any other colorization applied before.

        :param r: red (0 - 255)
        :param g: green (0 - 255)
        :param b: blue (0 - 255)
        :param a: alpha (0 - 255)

        """
        evas_map_util_points_color_set(self.map, r, g, b, a)

    def util_rotate(self, double degrees, Evas_Coord cx, Evas_Coord cy):
        """Change the map to apply the given rotation.

        This rotates the indicated map's coordinates around the center coordinate
        given by *cx* and *cy* as the rotation center. The points will have their
        X and Y coordinates rotated clockwise by *degrees* degrees (360.0 is a
        full rotation). Negative values for degrees will rotate counter-clockwise
        by that amount. All coordinates are canvas global coordinates.

        :param degrees: amount of degrees from 0.0 to 360.0 to rotate.
        :param cx: rotation's center horizontal position.
        :param cy: rotation's center vertical position.

        """
        evas_map_util_rotate(self.map, degrees, cx, cy)

    def util_zoom(self, double zoomx, double zoomy, Evas_Coord cx, Evas_Coord cy):
        """Change the map to apply the given zooming.

        Like evas_map_util_rotate(), this zooms the points of the map from a center
        point. That center is defined by *cx* and *cy*. The *zoomx* and *zoomy*
        parameters specify how much to zoom in the X and Y direction respectively.
        A value of 1.0 means "don't zoom". 2.0 means "double the size". 0.5 is
        "half the size" etc. All coordinates are canvas global coordinates.

        :param zoomx: horizontal zoom to use.
        :param zoomy: vertical zoom to use.
        :param cx: zooming center horizontal position.
        :param cy: zooming center vertical position.

        """
        evas_map_util_zoom(self.map, zoomx, zoomy, cx, cy)

    def util_3d_rotate(self, double dx, double dy, double dz, Evas_Coord cx, Evas_Coord cy, Evas_Coord cz):
        """Rotate the map around 3 axes in 3D

        This will rotate not just around the "Z" axis as in evas_map_util_rotate()
        (which is a convenience call for those only wanting 2D). This will rotate
        around the X, Y and Z axes. The Z axis points "into" the screen with low
        values at the screen and higher values further away. The X axis runs from
        left to right on the screen and the Y axis from top to bottom. Like with
        evas_map_util_rotate() you provide a center point to rotate around (in 3D).

        :param dx: amount of degrees from 0.0 to 360.0 to rotate around X axis.
        :param dy: amount of degrees from 0.0 to 360.0 to rotate around Y axis.
        :param dz: amount of degrees from 0.0 to 360.0 to rotate around Z axis.
        :param cx: rotation's center horizontal position.
        :param cy: rotation's center vertical position.
        :param cz: rotation's center vertical position.

        """
        evas_map_util_3d_rotate(self.map, dx, dy, dz, cx, cy, cz)

    def util_quat_rotate(self, double qx, double qy, double qz, double qw, double cx, double cy, double cz):
        """Rotate the map in 3D using a unit quaternion.

        This will rotate in 3D using a unit quaternion. Like with
        evas_map_util_3d_rotate() you provide a center point
        to rotate around (in 3D).

        :param qx: the x component of the imaginary part of the quaternion.
        :param qy: the y component of the imaginary part of the quaternion.
        :param qz: the z component of the imaginary part of the quaternion.
        :param qw: the w component of the real part of the quaternion.
        :param cx: rotation's center x.
        :param cy: rotation's center y.
        :param cz: rotation's center z.

        .. attention:: Rotations can be done using a unit quaternion. Thus, this
            function expects a unit quaternion (i.e. qx² + qy² + qz² + qw² == 1).
            If this is not the case the behavior is undefined.

        """
        evas_map_util_quat_rotate(self.map, qx, qy, qz, qw, cx, cy, cz)

    def util_3d_lighting(self, Evas_Coord lx, Evas_Coord ly, Evas_Coord lz, int lr, int lg, int lb, int ar, int ag, int ab):
        """Perform lighting calculations on the given Map

        This is used to apply lighting calculations (from a single light source)
        to a given map. The R, G and B values of each vertex will be modified to
        reflect the lighting based on the lixth point coordinates, the light
        color and the ambient color, and at what angle the map is facing the
        light source. A surface should have its points be declared in a
        clockwise fashion if the face is "facing" towards you (as opposed to
        away from you) as faces have a "logical" side for lighting.

        :param lx: X coordinate in space of light point
        :param ly: Y coordinate in space of light point
        :param lz: Z coordinate in space of light point
        :param lr: light red value (0 - 255)
        :param lg: light green value (0 - 255)
        :param lb: light blue value (0 - 255)
        :param ar: ambient color red value (0 - 255)
        :param ag: ambient color green value (0 - 255)
        :param ab: ambient color blue value (0 - 255)

        """
        evas_map_util_3d_lighting(self.map, lx, ly, lz, lr, lg, lb, ar, ag, ab)

    def util_3d_perspective(self, Evas_Coord px, Evas_Coord py, Evas_Coord z0, Evas_Coord foc):
        """Apply a perspective transform to the map

        This applies a given perspective (3D) to the map coordinates. X, Y and Z
        values are used. The px and py points specify the "infinite distance" point
        in the 3D conversion (where all lines converge to like when artists draw
        3D by hand). The ``z0`` value specifies the z value at which there is a 1:1
        mapping between spatial coordinates and screen coordinates. Any points
        on this z value will not have their X and Y values modified in the transform.
        Those further away (Z value higher) will shrink into the distance, and
        those less than this value will expand and become bigger. The ``foc`` value
        determines the "focal length" of the camera. This is in reality the distance
        between the camera lens plane itself (at or closer than this rendering
        results are undefined) and the "z0" z value. This allows for some "depth"
        control and ``foc`` must be greater than 0.

        :param m: map to change.
        :param px: The perspective distance X coordinate
        :param py: The perspective distance Y coordinate
        :param z0: The "0" z plane value
        :param foc: The focal distance

        """
        evas_map_util_3d_perspective(self.map, px, py, z0, foc)

    property util_clockwise:
        """Get the clockwise state of a map

        This determines if the output points (X and Y. Z is not used) are
        clockwise or counter-clockwise. This can be used for "back-face culling". This
        is where you hide objects that "face away" from you. In this case objects
        that are not clockwise.

        :return: 1 if clockwise, 0 otherwise

        """
        def __get__(self):
            return self.util_clockwise_get()

    def util_clockwise_get(self):
        return bool(evas_map_util_clockwise_get(self.map))

    property util_object_move_sync:
        """The flag of the object move synchronization for map rendering

        This sets the flag of the object move synchronization for map
        rendering. If the flag is True, the map will be moved as the object
        of the map is moved. By default, the flag of the object move
        synchronization is not enabled.

        :type: bool

        .. versionadded:: 1.13

        """
        def __get__(self):
            return bool(evas_map_util_object_move_sync_get(self.map))

        def __set__(self, bint value):
            evas_map_util_object_move_sync_set(self.map, value)

    def util_object_move_sync_set(self, bint enabled):
        evas_map_util_object_move_sync_set(self.map, enabled)

    def util_object_move_sync_get(self):
        return bool(evas_map_util_object_move_sync_get(self.map))

    property smooth:
        """The smoothing state for map rendering

        If the object is a type that has its own smoothing settings, then both
        the smooth settings for this object and the map must be turned off. By
        default smooth maps are enabled.

        :type: bool

        """
        def __get__(self):
            return self.smooth_get()

        def __set__(self, value):
            self.smooth_set(value)

    def smooth_set(self, bint smooth):
        evas_map_smooth_set(self.map, smooth)

    def smooth_get(self):
        return bool(evas_map_smooth_get(self.map))

    property alpha:
        """The alpha flag for map rendering

        If the object is a type that has its own alpha settings, then this will
        take precedence. Only image objects have this currently. Setting this
        off stops alpha blending of the map area, and is useful if you know the
        object and/or all sub-objects is 100% solid.

        :type: bool

        """
        def __get__(self):
            return self.alpha_get()

        def __set__(self, value):
            self.alpha_set(value)

    def alpha_set(self, bint alpha):
        evas_map_alpha_set(self.map, alpha)

    def alpha_get(self):
        return bool(evas_map_alpha_get(self.map))

    property count:
        """Get a maps size.

        Returns the number of points in a map.  Should be at least 4.

        :type: int (-1 on error)

        """
        def __get__(self):
            return self.count_get()

    def count_get(self):
        return evas_map_count_get(self.map)

    def point_coord_set(self, int idx, Evas_Coord x, Evas_Coord y, Evas_Coord z):
        """Change the map point's coordinate.

        This sets the fixed point's coordinate in the map. Note that points
        describe the outline of a quadrangle and are ordered either clockwise
        or counter-clockwise. It is suggested to keep your quadrangles concave and
        non-complex, though these polygon modes may work, they may not render
        a desired set of output. The quadrangle will use points 0 and 1 , 1 and 2,
        2 and 3, and 3 and 0 to describe the edges of the quadrangle.

        The X and Y and Z coordinates are in canvas units. Z is optional and may
        or may not be honored in drawing. Z is a hint and does not affect the
        X and Y rendered coordinates. It may be used for calculating fills with
        perspective correct rendering.

        Remember all coordinates are canvas global ones like with move and resize
        in evas.

        :param idx: index of point to change. Must be smaller than map size.
        :param x: Point X Coordinate
        :param y: Point Y Coordinate
        :param z: Point Z Coordinate hint (pre-perspective transform)

        """
        evas_map_point_coord_set(self.map, idx, x, y, z)

    def point_coord_get(self, int idx):
        """Get the map point's coordinate.

        This returns the coordinates of the given point in the map.

        :param idx: index of point to query. Must be smaller than map size.
        :return: the tuple (x, y, z)
        :rtype: tuple of 3 int

        """
        cdef int x, y, z
        evas_map_point_coord_get(self.map, idx, &x, &y, &z)
        return (x, y, z)

    #
    # XXX:  Can't use property here since getter has an argument.
    #
    # property point_coord:
    #     def __get__(self):
    #         return self.point_coord_get()
    #     def __set__(self, value):
    #         self.point_coord_set(*value)

    def point_image_uv_set(self, int idx, double u, double v):
        """Change the map point's U and V texture source point

        This sets the U and V coordinates for the point. This determines which
        coordinate in the source image is mapped to the given point, much like
        OpenGL and textures. Notes that these points do select the pixel, but
        are double floating point values to allow for accuracy and sub-pixel
        selection.

        :param idx: index of point to change. Must be smaller than map size.
        :param u: the X coordinate within the image/texture source
        :param v: the Y coordinate within the image/texture source
        """
        evas_map_point_image_uv_set(self.map, idx, u, v)

    def point_image_uv_get(self, int idx):
        """Get the map point's U and V texture source points

        This returns the texture points set by evas_map_point_image_uv_set().

        :param idx: index of point to query. Must be smaller than map size.
        :return: the tuple (u, v)
        :rtype: tuple of double

        """
        cdef double u, v
        evas_map_point_image_uv_get(self.map, idx, &u, &v)
        return (u, v)

    #
    # XXX:  Can't use property here since getter has an argument.
    #
    # property point_image_uv:
    #     def __get__(self):
    #         return self.point_image_uv_get()
    #     def __set__(self, value):
    #         self.point_image_uv_set(*value)

    def point_color_set(self, int idx, int r, int g, int b, int a):
        """Set the color of a vertex in the map

        This sets the color of the vertex in the map. Colors will be linearly
        interpolated between vertex points through the map. Color will multiply
        the "texture" pixels (like GL_MODULATE in OpenGL). The default color of
        a vertex in a map is white solid (255, 255, 255, 255) which means it will
        have no affect on modifying the texture pixels.

        :param idx: index of point to change. Must be smaller than map size.
        :param r: red (0 - 255)
        :param g: green (0 - 255)
        :param b: blue (0 - 255)
        :param a: alpha (0 - 255)

        """
        evas_map_point_color_set(self.map, idx, r, g, b, a)

    def point_color_get(self, int idx):
        """Get the color set on a vertex in the map

        This gets the color set by point_color_set() on the given vertex
        of the map.

        :param idx: index of point get. Must be smaller than map size.
        :return: the tuple (r, g, b, a)
        :rtype: tuple of int

        """
        cdef int r, g, b, a
        evas_map_point_color_get(self.map, idx, &r, &g, &b, &a)
        return (r, g, b, a)

    #
    # XXX:  Can't use property here since getter has an argument.
    #
    # property point_color:
    #     def __get__(self):
    #         return self.point_color_get()
    #     def __set__(self, value):
    #         self.point_color_set(*value)

