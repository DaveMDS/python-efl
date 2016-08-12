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

include "map_cdef.pxi"

cdef object _elm_map_overlay_to_python(Elm_Map_Overlay *ov):
    cdef void *data

    if ov == NULL:
        return None
    data = elm_map_overlay_data_get(ov)
    if data == NULL:
        return None
    return <object>data

cdef void _map_overlay_get_callback(void *data, Evas_Object *map, Elm_Map_Overlay *overlay) with gil:
    cdef Object obj

    obj = object_from_instance(map)
    try:
        (func, args, kwargs) = <object>data
        func(obj, _elm_map_overlay_to_python(overlay), *args, **kwargs)
    except Exception:
        traceback.print_exc()

cdef void _map_overlay_del_cb(void *data, Evas_Object *map, Elm_Map_Overlay *overlay) with gil:
    ov = <object>data
    ov.__del_cb()

cdef void _map_route_callback(void *data, Evas_Object *map, Elm_Map_Route *route) with gil:
    cdef Object obj

    obj = object_from_instance(map)
    (proute, func, args, kwargs) = <object>data
    try:
        func(obj, proute, *args, **kwargs)
    except Exception:
        traceback.print_exc()

    Py_DECREF(<object>data)

cdef void _map_name_callback(void *data, Evas_Object *map, Elm_Map_Name *name) with gil:
    cdef Object obj

    obj = object_from_instance(map)
    (pname, func, args, kwargs) = <object>data
    try:
        func(obj, pname, *args, **kwargs)
    except Exception:
        traceback.print_exc()

    Py_DECREF(<object>data)


cdef class MapRoute(object):
    """

    This class represents a calculated route.

    A route will be traced by point on coordinates to point on coordinates
    , using the route service set with :py:func:`Map.source_set()`.

    .. seealso:: :py:func:`Map.route_add`

    """
    cdef Elm_Map_Route *route

    def __cinit__(self):
        self.route = NULL

    def __init__(self, evasObject map,
                       Elm_Map_Route_Type type, Elm_Map_Route_Method method,
                       double flon, double flat, double tlon, double tlat,
                       func, *args, **kwargs):

        if not callable(func):
            raise TypeError("func must be callable")

        data = (self, func, args, kwargs)
        self.route = elm_map_route_add(map.obj, type, method,
                                       flon, flat, tlon, tlat,
                                       _map_route_callback, <void *>data)
        Py_INCREF(data)
        Py_INCREF(self)

    def delete(self):
        """ Remove a route from the map. """
        elm_map_route_del(self.route)
        self.route = NULL
        Py_DECREF(self)

    property distance:
        """ The route distance in kilometers.

        :type: float

        """
        def __get__(self):
            return elm_map_route_distance_get(self.route)

    def distance_get(self):
        return elm_map_route_distance_get(self.route)

    property node:
        """ Get the informational text of the route nodes.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_map_route_node_get(self.route))

    def node_get(self):
        return _ctouni(elm_map_route_node_get(self.route))

    property waypoint:
        """ Get the informational text of the route waypoints.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_map_route_waypoint_get(self.route))

    def waypoint_get(self):
        return _ctouni(elm_map_route_waypoint_get(self.route))


cdef class MapName(object):
    """

    This class represent the result of a name/coordinates query and can
    be used to extract the needed information from the results.

    """
    cdef Elm_Map_Name *name

    def __cinit__(self):
        self.name = NULL

    def __init__(self, evasObject map, address, double lon, double lat,
                       func, *args, **kwargs):
        if not callable(func):
            raise TypeError("func must be callable")

        data = (self, func, args, kwargs)
        if isinstance(address, unicode): address = PyUnicode_AsUTF8String(address)
        self.name = elm_map_name_add(map.obj,
            <const char *>address if address is not None else NULL,
            lon, lat, _map_name_callback, <void *>data)
        Py_INCREF(data)
        Py_INCREF(self)

    def delete(self):
        """ Remove a name from the map. """
        elm_map_name_del(self.name)
        self.name = NULL
        Py_DECREF(self)

    property address:
        """ The address of the name object.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_map_name_address_get(self.name))

    def address_get(self):
        return _ctouni(elm_map_name_address_get(self.name))

    property region:
        """ Get the coordinates of the name.

        :type: tuple of float (lon, lat)

        """
        def __get__(self):
            cdef double lon, lat

            elm_map_name_region_get(self.name, &lon, &lat)
            return (lon, lat)

    def region_get(self):
        cdef double lon, lat
        elm_map_name_region_get(self.name, &lon, &lat)
        return (lon, lat)


cdef class MapOverlay(object):
    """

    Base class for all the MapOverlay objects

    .. seealso:: :py:func:`Map.overlay_add`

    """
    cdef Elm_Map_Overlay *overlay
    cdef void* cb_get_data

    def __cinit__(self):
        self.overlay = NULL
        self.cb_get_data = NULL

    def __init__(self, evasObject Map, double lon, double lat):
        self.overlay = elm_map_overlay_add(Map.obj, lon, lat)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)

    def __del_cb(self):
        self.overlay = NULL
        Py_DECREF(self)

    def delete(self):
        """ Delete the overlay and remove it from the map """
        if self.overlay == NULL:
            raise ValueError("Object already deleted")
        elm_map_overlay_del(self.overlay)

    property type:
        """Get the type of the overlay

        :type: :ref:`Elm_Map_Overlay_Type`

        """
        def __get__(self):
            return elm_map_overlay_type_get(self.overlay)

    def type_get(self):
        return elm_map_overlay_type_get(self.overlay)

    property hide:
        """ If the overlay is hidden or not.

        :type: bool

        """
        def __get__(self):
            return bool(elm_map_overlay_hide_get(self.overlay))

        def __set__(self, hide):
            elm_map_overlay_hide_set(self.overlay, bool(hide))

    def hide_set(self, hide):
        elm_map_overlay_hide_set(self.overlay, bool(hide))
    def hide_get(self):
        return bool(elm_map_overlay_hide_get(self.overlay))

    property displayed_zoom_min:
        """ The minimum zoom from where the overlay is displayed.

        The overlay only will be displayed when the map is displayed at
        this value or bigger.

        :type: int

        """
        def __get__(self):
            return elm_map_overlay_displayed_zoom_min_get(self.overlay)

        def __set__(self, zoom):
            elm_map_overlay_displayed_zoom_min_set(self.overlay, zoom)

    def displayed_zoom_min_set(self, zoom):
        elm_map_overlay_displayed_zoom_min_set(self.overlay, zoom)
    def displayed_zoom_min_get(self):
        return elm_map_overlay_displayed_zoom_min_get(self.overlay)

    property paused:
        """ Pause or unpause the overlay.

        This sets the paused state to on (*True*) or off (*False*)
        for the overlay.

        The default is off.

        This will stop moving the overlay coordinates instantly.
        even if map being scrolled or zoomed.

        :type: bool

        """
        def __get__(self):
            return elm_map_overlay_paused_get(self.overlay)

        def __set__(self, paused):
            elm_map_overlay_paused_set(self.overlay, paused)

    def paused_set(self, paused):
        elm_map_overlay_paused_set(self.overlay, paused)
    def paused_get(self):
        return elm_map_overlay_paused_get(self.overlay)

    property visible:
        """ Whether the overlay is visible or not.

        The visible of the overlay can not be set. This value can only change
        dynamically while zooming and panning.

        :type: bool

        """
        def __get__(self):
            return bool(elm_map_overlay_visible_get(self.overlay))

    def visible_get(self):
        return bool(elm_map_overlay_visible_get(self.overlay))

    property content:
        """ The content object of the overlay.

        The content should be resized or set size hints before set to the overlay.

        This content is what will be inside the overlay that will be displayed.
        If a content is set, icon and default style layout are no more used before
        the content is deleted.

        :type: :py:class:`efl.evas.Object`

        .. note:: Only `default` and `class` type overlay support this function.
        .. warning:: Do not modify this object (move, show, hide, del, etc.)
                     after set.

        """
        def __get__(self):
            cdef Evas_Object *obj = <Evas_Object *>elm_map_overlay_content_get(self.overlay)
            return object_from_instance(obj)

        def __set__(self, Object content):
            elm_map_overlay_content_set(self.overlay, content.obj)

    def content_set(self, Object content):
        elm_map_overlay_content_set(self.overlay, content.obj)
    def content_get(self):
        cdef Evas_Object *obj = <Evas_Object *>elm_map_overlay_content_get(self.overlay)
        return object_from_instance(obj)

    property icon:
        """ The icon that is used to display the overlay.

        :type: :py:class:`efl.evas.Object`

        .. note:: Only `default` and `class` type overlay support this function.
        .. warning:: Do not modify this object (move, show, hide, del, etc.)
                     after set.
        """
        def __get__(self):
            cdef Evas_Object *obj = <Evas_Object *>elm_map_overlay_icon_get(self.overlay)
            return object_from_instance(obj)

        def __set__(self, Object icon):
            elm_map_overlay_icon_set(self.overlay, icon.obj)

    def icon_set(self, Object icon):
        elm_map_overlay_icon_set(self.overlay, icon.obj)
    def icon_get(self):
        cdef Evas_Object *obj = <Evas_Object *>elm_map_overlay_icon_get(self.overlay)
        return object_from_instance(obj)

    property region:
        """ The geographic coordinates of the overlay.

        This represent  the center coordinates of the overlay.

        :type: tuple of float (lon, lat)

        .. note:: Only `default` and `bubble` type overlay support this function.

        """
        def __get__(self):
            cdef double lon, lat
            elm_map_overlay_region_get(self.overlay, &lon, &lat)
            return (lon, lat)

        def __set__(self, value):
            lon, lat = value
            elm_map_overlay_region_set(self.overlay, lon, lat)

    def region_set(self, lon, lat):
        elm_map_overlay_region_set(self.overlay, lon, lat)
    def region_get(self):
        cdef double lon, lat
        elm_map_overlay_region_get(self.overlay, &lon, &lat)
        return (lon, lat)

    property color:
        """ The color of the overlay.

        It uses an additive color model, so each color channel represents
        how much of each primary colors must to be used. 0 represents
        absence of this color, so if all of the three are set to 0,
        the color will be black.

        These component values should be integers in the range 0 to 255,
        (single 8-bit byte).

        By default is set to solid red (r = 255, g = 0, b = 0, a = 255).

        For alpha channel, 0 represents completely transparent, and 255, opaque.

        :type: tuple of 4 int (red, green, blue, alpha)

        .. note:: Only `default`, `class` and `route` type overlay support
                  this function.

        """
        def __get__(self):
            cdef int r, g, b, a
            elm_map_overlay_color_get(self.overlay, &r, &g, &b, &a)
            return (r, g, b, a)

        def __set__(self, value):
            r, g, b, a = value
            elm_map_overlay_color_set(self.overlay, r, g, b, a)

    def color_set(self, r, g, b, a):
        elm_map_overlay_color_set(self.overlay, r, g, b, a)
    def color_get(self):
        cdef int r, g, b, a
        elm_map_overlay_color_get(self.overlay, &r, &g, &b, &a)
        return (r, g, b, a)

    def show(self):
        """ Center the map on this overlay, immediately.

        This causes the map to redraw its viewport's contents to the
        region containing the given overlay's coordinates, that will be
        moved to the center of the map.

        .. seealso:: :py:func:`Map.overlays_show` if more than one overlay need
                     to be displayed

        """
        elm_map_overlay_show(self.overlay)

    def callback_clicked_set(self, func, *args, **kwargs):
        """ Set a callback to be called when the overlay is clicked.

        If the overlay is clicked, the callback `func` will be called.
        The clicked overlay is returned by callback.

        You can add callback to the `class` overlay. If one of the group
        overlays in this class is clicked, `func` will be called and
        return a virtual group overlays.

        :param func: the callback to be called
        :type func: callable

        .. note:: Any extra argument (positional or named) passed to this
                  function will be passed back in the callback.

        """
        if not callable(func):
            raise TypeError("func must be callable")
        cb_data = (func, args, kwargs)
        elm_map_overlay_get_cb_set(self.overlay, _map_overlay_get_callback,
                                                 <void *>cb_data)
        Py_INCREF(cb_data)

    def callback_clicked_unset(self, func):
        """ Unset the callback previously attached to this overlay. """
        elm_map_overlay_get_cb_set(self.overlay, NULL, NULL)
        cb_data = <object>self.cb_get_data
        self.cb_get_data = NULL
        Py_DECREF(cb_data)


cdef class MapOverlayClass(MapOverlay):
    """

    This is a *virtual* overlay type that rapreset a set of different overlays
    grouped together.

    .. seealso:: :py:func:`Map.overlay_class_add`

    """
    def __init__(self, evasObject Map):
        self.overlay = elm_map_overlay_class_add(Map.obj)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)

    def append(self, MapOverlay overlay):
        """ Add a new overlay member to the `class` overlay.

        :param overlay: the overlay to be added as a member.
        :type overlay: :py:class:`MapOverlay`

        """
        elm_map_overlay_class_append(self.overlay, overlay.overlay)

    def remove(self, MapOverlay overlay):
        """ Remove the given overlay to the overlay class.

        :param overlay: the overlay to add as member
        :type overlay: :py:class:`MapOverlay`

        """
        elm_map_overlay_class_remove(self.overlay, overlay.overlay)

    property zoom_max:
        """ the maximum zoom from where the overlay members in the class can be
        grouped.

        Overlay members in the class only will be grouped when the map
        is displayed at less than `zoom_max`.

        :type: int

        """
        def __get__(self):
            return elm_map_overlay_class_zoom_max_get(self.overlay)

        def __set__(self, zoom):
            elm_map_overlay_class_zoom_max_set(self.overlay, zoom)

    def zoom_max_set(self, zoom):
        elm_map_overlay_class_zoom_max_set(self.overlay, zoom)
    def zoom_max_get(self):
        return elm_map_overlay_class_zoom_max_get(self.overlay)

    property members:
        """ The overlay members of the class overlay.

        The group overlays are virtually overlays. Those are shown and hidden
        dynamically. You can add callback to the class overlay. If one of the
        group overlays in this class is clicked, callback will be called and
        return a virtual group overlays.

        You can change the state (hidden, paused, etc.) or set the content
        or icon of the group overlays by changing the state of the class overlay.

        :type: list of :py:class:`MapOverlay`

        .. warning:: Do not modify the group overlay itself.

        """
        def __get__(self):
            cdef Eina_List *lst
            cdef Elm_Map_Overlay *ov
            lst = elm_map_overlay_group_members_get(self.overlay)# TODO this is somehow wrong... group <> class

            ret = []
            ret_append = ret.append
            while lst:
                ov = <Elm_Map_Overlay *>lst.data
                lst = lst.next
                o = _elm_map_overlay_to_python(ov)
                if o is not None:
                    ret_append(o)
            return ret

    def members_get(self):
        return self.members


cdef class MapOverlayBubble(MapOverlay):
    """

    This overlay type has a `bubble` style. And can `follow` another overlay.

    .. note::  This overlay has a bubble style layout and icon or content can not
               be set.

    .. seealso:: :py:func:`Map.overlay_bubble_add`

    """
    def __init__(self, evasObject Map):
        self.overlay = elm_map_overlay_bubble_add(Map.obj)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)

    def follow(self, MapOverlay overlay):
        """ Follow another overlay.

        Bubble overlay will follow the parent overlay's movement (hide, show, move).

        :param overlay: another overlay to follow.
        :type overlay: :py:class:`MapOverlay`

        """
        elm_map_overlay_bubble_follow(self.overlay, overlay.overlay)

    def content_append(self, evasObject content):
        """  Add a content object to the bubble overlay.

        Added contents will be displayed inside the bubble overlay.

        :param content: The content to be added to the bubble overlay.
        :type content: :py:class:`efl.evas.Object`
        """
        elm_map_overlay_bubble_content_append(self.overlay, content.obj)

    def content_clear(self):
        """ Clear all contents inside the bubble overlay.

        This will delete all contents inside the bubble overlay.

        """
        elm_map_overlay_bubble_content_clear(self.overlay)


cdef class MapOverlayLine(MapOverlay):
    """

    This style of overlay is drawn as a simple line.

    .. seealso:: :py:func:`Map.overlay_line_add`

    """
    def __init__(self, evasObject Map, flon, flat, tlot, tlat):
        self.overlay = elm_map_overlay_line_add(Map.obj, flon, flat, tlot, tlat)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)


cdef class MapOverlayPolygon(MapOverlay):
    """

    This overlay style is represented by a polygon. The polygon is described
    by the points added using the :py:func:`region_add` method.

    At least 3 regions should be added to show the polygon overlay.

    .. seealso:: :py:func:`Map.overlay_polygon_add`

    """
    def __init__(self, evasObject Map):
        self.overlay = elm_map_overlay_polygon_add(Map.obj)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)

    def region_add(self, lon, lat):
        """ Add a  geographic coordinates  to the polygon overlay.

        :param lon: The longitude.
        :type lon: float
        :param lat: The latitude.
        :type lat: float

        """
        elm_map_overlay_polygon_region_add(self.overlay, lon, lat)


cdef class MapOverlayCircle(MapOverlay):
    """

    This style of overlay is drawn as a simple circle.

    .. seealso:: :py:func:`Map.overlay_circle_add`

    """
    def __init__(self, evasObject Map, lon, lat, radius):
        self.overlay = elm_map_overlay_circle_add(Map.obj, lon, lat, radius)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)


cdef class MapOverlayScale(MapOverlay):
    """

    The scale overlay shows the ratio of a distance on the map to
    the corresponding distance.

    .. seealso:: :py:func:`Map.overlay_scale_add`

    """
    def __init__(self, evasObject Map, x, y):
        self.overlay = elm_map_overlay_scale_add(Map.obj, x, y)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)


cdef class MapOverlayRoute(MapOverlay):
    """

    The route overlay display a :py:class:`MapRoute` graphically on the map.

    .. seealso:: :py:func:`Map.overlay_route_add`

    """
    def __init__(self, evasObject Map, MapRoute route):
        self.overlay = elm_map_overlay_route_add(Map.obj, route.route)
        elm_map_overlay_data_set(self.overlay, <void *>self)
        elm_map_overlay_del_cb_set(self.overlay, _map_overlay_del_cb, <void *>self)
        Py_INCREF(self)


cdef class Map(Object):
    """

    This is the class that actually implement the widget.

    """
    def __init__(self, evasObject parent, *args, **kwargs):
        """Map(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_map_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property zoom:
        """ The zoom level of the map.

        This property will respect the limits defined by :py:attr:`zoom_min`
        and :py:attr:`zoom_max`. By default these values are 0 (world map)
        and 18 (maximum zoom).

        This property should be used when zoom mode is set to
        `ELM_MAP_ZOOM_MODE_MANUAL`. That is the default mode, and can be set
        with :py:attr:`zoom_mode`.

        :type: int

        """
        def __get__(self):
            return elm_map_zoom_get(self.obj)

        def __set__(self, zoom):
            elm_map_zoom_set(self.obj, zoom)

    def zoom_set(self, zoom):
        elm_map_zoom_set(self.obj, zoom)
    def zoom_get(self):
        return elm_map_zoom_get(self.obj)


    property zoom_mode:
        """ The zoom mode used by the map object.

        This sets the zoom mode to manual or one of the automatic levels.
        Manual (`ELM_MAP_ZOOM_MODE_MANUAL`) means that zoom is set manually by
        the :py:attr:`zoom` property and will stay at that level until changed
        by code or until zoom_mode is changed. This is the default mode.

        The Automatic modes will allow the map object to automatically
        adjust zoom mode based on properties. `ELM_MAP_ZOOM_MODE_AUTO_FIT` will
        adjust zoom so the map fits inside the scroll frame with no pixels
        outside this area. `ELM_MAP_ZOOM_MODE_AUTO_FILL` will be similar but
        ensure no pixels within the frame are left unfilled. Do not forget that
        the valid sizes are 2^zoom, consequently the map may be smaller than
        the scroller view.

        :type: int

        """
        def __get__(self):
            return elm_map_zoom_mode_get(self.obj)

        def __set__(self, mode):
            elm_map_zoom_mode_set(self.obj, mode)

    def zoom_mode_set(self, mode):
        elm_map_zoom_mode_set(self.obj, mode)
    def zoom_mode_get(self):
        return elm_map_zoom_mode_get(self.obj)


    property zoom_min:
        """ The minimum zoom of the source. """
        def __get__(self):
            return elm_map_zoom_min_get(self.obj)

        def __set__(self, zoom):
            elm_map_zoom_min_set(self.obj, zoom)

    def zoom_min_set(self, zoom):
        elm_map_zoom_min_set(self.obj, zoom)
    def zoom_min_get(self):
        return elm_map_zoom_min_get(self.obj)


    property zoom_max:
        """ The maximum zoom of the source. """
        def __get__(self):
            return elm_map_zoom_max_get(self.obj)

        def __set__(self, zoom):
            elm_map_zoom_max_set(self.obj, zoom)

    def zoom_max_set(self, zoom):
        elm_map_zoom_max_set(self.obj, zoom)
    def zoom_max_get(self):
        return elm_map_zoom_max_get(self.obj)


    property region:
        """ The current geographic coordinates of the map.

        This gets the current center coordinates of the map object. It can be
        set by :py:func:`region_bring_in()` and :py:func:`region_show()`.

        :type: tuple of float (lon, lat)

        """
        def __get__(self):
            cdef double lon, lat
            elm_map_region_get(self.obj, &lon, &lat)
            return (lon, lat)

    def region_get(self):
        cdef double lon, lat
        elm_map_region_get(self.obj, &lon, &lat)
        return (lon, lat)


    def region_bring_in(self, lon, lat):
        """ Animatedly bring in given coordinates to the center of the map.

        This causes the map to jump to the given `lon` and `lat` coordinates
        and show it (by scrolling) in the center of the viewport, if it is not
        already centered. This will use animation to do so and take a period
        of time to complete.

        :param lon: The longitude to center at
        :type lon: float
        :param lat: The latitude to center at
        :type lat: float

        .. seealso:: :py:func:`region_show()`

        """
        elm_map_region_bring_in(self.obj, lon, lat)

    def region_show(self, lon, lat):
        """ Show the given coordinates at the center of the map, *immediately*.

        This causes the map to *redraw* its viewport's contents to the
        region containing the given `lat` and `lon`, that will be moved to the
        center of the map.

        :param lon: The longitude to center at
        :type lon: float
        :param lat: The latitude to center at
        :type lat: float

        .. seealso:: :py:func:`region_bring_in()`

        """
        elm_map_region_show(self.obj, lon, lat)

    def region_zoom_bring_in(self, zoom, lon, lat):
        """ Animatedly set the zoom level of the map and bring in given
        coordinates to the center of the map.

        This causes map to zoom into specific zoom level and also move to the
        given lat and lon coordinates and show it (by scrolling) in the
        center of the viewport concurrently.

        :param zoom: The zoom level to set
        :type zoom: int
        :param lon: The longitude to center at
        :type lon: float
        :param lat: The latitude to center at
        :type lat: float

        .. versionadded:: 1.11

        """
        elm_map_region_zoom_bring_in(self.obj, zoom, lon, lat)

    def canvas_to_region_convert(self, x, y):
        """ Convert canvas coordinates into geographic coordinates.

        This gets longitude and latitude from canvas x, y coordinates. The canvas
        coordinates mean x, y coordinate from current viewport.

        :param x: horizontal coordinate of the point to convert.
        :type x: int
        :param y: vertical coordinate of the point to convert.
        :type y: int
        :return: (lon, lat)
        :rtype: tuple of float

        .. seealso:: :py:func:`region_to_canvas_convert`

        """
        cdef double lon, lat
        elm_map_canvas_to_region_convert(self.obj, x, y, &lon, &lat)
        return (lon, lat)

    def region_to_canvas_convert(self, lon, lat):
        """ Convert geographic coordinates into canvas coordinates.

        This gets canvas x, y coordinates from longitude and latitude. The
        canvas coordinates mean x, y coordinate from current viewport.

        :param lon: The longitude to convert.
        :type lon: float
        :param lat: The latitude to convert.
        :type lat: float
        :return: (x, y)
        :rtype: tuple of int

        .. seealso:: :py:func:`canvas_to_region_convert`

        """
        cdef Evas_Coord x, y
        elm_map_region_to_canvas_convert(self.obj, lon, lat, &x, &y)
        return (x, y)


    property paused:
        """ The paused state of the map object.

        This set/get the paused state to on (**True**) or off (**False**)
        for the map.

        The default is off.

        This will stop zooming using animation, changing zoom levels will
        change instantly. This will stop any existing animations that are running.

        :type: bool

        """
        def __get__(self):
            return bool(elm_map_paused_get(self.obj))

        def __set__(self, paused):
            elm_map_paused_set(self.obj, bool(paused))

    def paused_set(self, paused):
        elm_map_paused_set(self.obj, bool(paused))
    def paused_get(self):
        return bool(elm_map_paused_get(self.obj))


    property rotate:
        """ The rotation of the map.

        Rotate (or get the rotation) of the map around the Z axis.
        The rotation is expressed using the tuple: **(degree, cx, cy)**, where
        `degree` is an angle that range from 0.0 to 360.0, while `cx` and `cy`
        are the center of rotation expressed in canvas units.

        :type: a tuple (float, int, int)

        """
        def __get__(self):
            cdef double degree
            cdef Evas_Coord cx, cy
            elm_map_rotate_get(self.obj, &degree, &cx, &cy)
            return (degree, cx, cy)

        def __set__(self, value):
            degree, cx, cy = value
            elm_map_rotate_set(self.obj, degree, cx, cy)

    def rotate_set(self, degree, cx, cy):
        elm_map_rotate_set(self.obj, degree, cx, cy)
    def rotate_get(self):
        cdef double degree
        cdef Evas_Coord cx, cy
        elm_map_rotate_get(self.obj, &degree, &cx, &cy)
        return (degree, cx, cy)


    property wheel_disabled:
        """ Mouse wheel can be used by the user to zoom in / out the map.

        This property `disable` the mouse wheel usage.

        :type: bool

        """
        def __get__(self):
            return bool(elm_map_wheel_disabled_get(self.obj))

        def __set__(self, disabled):
            elm_map_wheel_disabled_set(self.obj, bool(disabled))

    def wheel_disabled_set(self, disabled):
        elm_map_wheel_disabled_set(self.obj, bool(disabled))
    def wheel_disabled_get(self):
        return bool(elm_map_wheel_disabled_get(self.obj))


    property user_agent:
        """ The user agent used by the map object to access routing services.

        User agent is a client application implementing a network protocol used
        in communications within a client–server distributed computing system.

        The user_agent identification string will be transmitted in a header
        field *User-Agent*.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_map_user_agent_get(self.obj))

        def __set__(self, user_agent):
            if isinstance(user_agent, unicode):
                user_agent = PyUnicode_AsUTF8String(user_agent)
            elm_map_user_agent_set(self.obj,
                <const char *>user_agent if user_agent is not None else NULL)

    def user_agent_set(self, user_agent):
        if isinstance(user_agent, unicode):
            user_agent = PyUnicode_AsUTF8String(user_agent)
        elm_map_user_agent_set(self.obj,
            <const char *>user_agent if user_agent is not None else NULL)
    def user_agent_get(self):
        return _ctouni(elm_map_user_agent_get(self.obj))


    def overlay_add(self, lon, lat):
        """ Add a new overlay to the map object. This overlay has a default type.

        An overlay will be created and shown in a specific point of the map,
        defined by `lon` and `lat`.

        The created overlay has a default style layout before content or
        icon is set. If content or icon is set, those are displayed instead
        of default style layout.

        :param lon: The longitude of the overlay.
        :type lon: float
        :param lat: The latitude of the overlay.
        :type lat: float
        :return: a newly created overlay
        :rtype: :py:class:`MapOverlay`

        .. seealso:: :py:func:`overlay_bubble_add`, :py:func:`overlay_line_add`,
                      :py:func:`overlay_polygon_add`, :py:func:`overlay_circle_add`,
                      :py:func:`overlay_scale_add`, :py:func:`overlay_class_add`,
                      :py:func:`overlay_route_add`

        """
        return MapOverlay(self, lon, lat)


    property overlays:
        """ The list of all the overlays in the map object.

        This list includes group overlays also. So this can change dynamically
        while zooming and panning.

        :return: a list of all overlays
        :rtype: list of :py:class:`MapOverlay` objects

        """
        def __get__(self):
            cdef Eina_List *lst
            cdef Elm_Map_Overlay *ov
            lst = elm_map_overlays_get(self.obj)

            ret = []
            ret_append = ret.append
            while lst:
                ov = <Elm_Map_Overlay *>lst.data
                lst = lst.next
                o = _elm_map_overlay_to_python(ov)
                if o is not None:
                    ret_append(o)
            return ret

    def overlays_get(self):
        return self.overlays


    def overlays_show(self, overlays):
        """ Move and zoom the map to display a list of overlays.

        The map will be centered on the center point of the overlays in the list.
        Then the map will be zoomed in order to fit the overlays using the
        maximum zoom which allows display of all the overlays provided.

        :param overlays: the list of overlays to show
        :type overlays: list of :py:class:`MapOverlay`

        .. warning:: All the overlays in the list should belong to the same map object.

        """
        cdef Eina_List *lst

        lst = NULL
        for overlay in overlays:
            ov = <MapOverlay>overlay
            lst = eina_list_append(lst, ov.overlay)
        elm_map_overlays_show(lst)
        eina_list_free(lst)

    def overlay_bubble_add(self):
        """ Add a new bubble overlay to the map object.

        A bubble will not be displayed before geographic coordinates are set or
        any other overlays are followed.

        This overlay has a bubble style layout and icon or content can not be set.

        :return: a new bubble style overlay
        :rtype: :py:class:`MapOverlayBubble`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayBubble(self)

    def overlay_line_add(self, flon, flat, tlon, tlat):
        """ Add a new line overlay to the map object.

        This overlay has a line type.

        :param flon: The start longitude.
        :type flon: float
        :param flat: The start latitude.
        :type flat: float
        :param tlon: The end longitude.
        :type tlon: float
        :param tlat: The end latitude.
        :type tlat: float

        :return: a new line style overlay
        :rtype: :py:class:`MapOverlayLine`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayLine(self, flon, flat, tlon, tlat)

    def overlay_polygon_add(self):
        """ Add a new polygon overlay to the map object.

        This overlay has a polygon type.
        At least 3 regions should be added to show the polygon overlay.

        :return: a new polygon style overlay
        :rtype: :py:class:`MapOverlayPolygon`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayPolygon(self)

    def overlay_circle_add(self, lon, lat, radius):
        """ Add a new circle overlay to the map object.

        This overlay has a circle type.

        :param lon: The circle center longitude.
        :type lon: float
        :param lat: The circle center latitude.
        :type lat: float
        :param radius: The radius of the overlay, in pixels.
        :type radius: int
        :return: a new circle style overlay
        :rtype: :py:class:`MapOverlayCircle`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayCircle(self, lon, lat, radius)

    def overlay_scale_add(self, x, y):
        """ Add a new scale overlay to the map object.

        This overlay has a scale type.
        The scale overlay shows the ratio of a distance on the map to
        the corresponding distance.

        :param x: horizontal pixel coordinate.
        :type x: int
        :param y: vertical pixel coordinate
        :type y: int
        :return: a new scale style overlay
        :rtype: :py:class:`MapOverlayScale`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayScale(self, x, y)

    def overlay_class_add(self):
        """ Add a new class overlay to the map object.

        This overlay has a class type.
        This overlay is not shown before overlay members are appended.
        If overlay members in the same class are close, group overlays
        are created. If they are far away, group overlays are hidden.
        When group overlays are shown, they have default style layouts at first.

        You can change the state (hidden, paused, etc.) or set the content
        or icon of the group overlays by changing the state of the class overlay.
        Do not modify the group overlay itself.
        Also these changes have an influence on the overlays in the same class
        even if each overlay is alone and is not grouped.

        :return: a new class style overlay
        :rtype: :py:class:`MapOverlayClass`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayClass(self)

    def overlay_route_add(self, route):
        """ Add a new route overlay to the map object.

        This overlay has a route type.
        This overlay has a route style layout and icon or content can not be set.


        :param route: The route object to make an overlay from.
        :type route: :py:class:`efl.elementary.map.MapRoute`
        :return: a new route style overlay
        :rtype: :py:class:`MapOverlayRoute`

        .. seealso:: :py:func:`overlay_add`

        """
        return MapOverlayRoute(self, route)


    property tile_load_status:
        """ Get the information of tile load status.

        This gets the current tiles requested and the count of the loaded ones.

        :return: the number of requested and completed tiles
        :rtype: tuple of 2 int
        """
        def __get__(self):
            cdef int try_num, finish_num
            elm_map_tile_load_status_get(self.obj, &try_num, &finish_num)
            return (try_num, finish_num)

    def tile_load_status_get(self):
        cdef int try_num, finish_num
        elm_map_tile_load_status_get(self.obj, &try_num, &finish_num)
        return (try_num, finish_num)


    def sources_get(self, type):
        """ Get the names of available sources for a specific type.

        This will provide a list with all available sources for the given type.

        Default available sources of **tile** type:

        - "Mapnik"
        - "Osmarender"
        - "CycleMap"
        - "Maplint"

        Default available sources of **route** type:

        - "Yours"

        Default available sources of **name** type:

        - "Nominatim"

        :param type: the type of the source. Must be one of: `ELM_MAP_SOURCE_TYPE_TILE`,
                     `ELM_MAP_SOURCE_TYPE_ROUTE` or `ELM_MAP_SOURCE_TYPE_NAME`
        :type type: :ref:`Elm_Map_Source_Type`

        .. seealso:: :py:func:`source_set`, :py:func:`source_get`

        """
        cdef const char **lst

        i = 0
        ret = []
        lst = elm_map_sources_get(self.obj, type)
        while (lst[i]):
            ret.append(_ctouni(lst[i]))
            i += 1

        return ret

    def source_set(self, source_type, source_name):
        """ Set the current source of the map for a specific type.

        Map widget retrieves tile images that composes the map from a web service.
        This web service can be set with this method
        for `ELM_MAP_SOURCE_TYPE_TILE` type.
        A different service can return a different maps with different
        information and it can use different zoom values.

        Map widget provides route data based on a external web service.
        This web service can be set with this method
        for `ELM_MAP_SOURCE_TYPE_ROUTE` type.

        Map widget also provide geoname data based on a external web service.
        This web service can be set with this method
        for `ELM_MAP_SOURCE_TYPE_NAME` type.

        The current source can be get using elm_map_source_get().

        :param source_type: the type of the source. Must be one of: `ELM_MAP_SOURCE_TYPE_TILE`,
                            `ELM_MAP_SOURCE_TYPE_ROUTE` or `ELM_MAP_SOURCE_TYPE_NAME`
        :type source_type: :ref:`Elm_Map_Source_Type`
        :param source_name: The source to be used. Need to match one of the names
                            provided by :py:func:`sources_get`.
        :type source_name: string

        .. seealso:: :py:func:`sources_get`, :py:func:`source_get`

        """
        if isinstance(source_name, unicode):
            source_name = PyUnicode_AsUTF8String(source_name)
        elm_map_source_set(self.obj, source_type,
            <const char *>source_name if source_name is not None else NULL)

    def source_get(self, source_type):
        """ Get the name of currently used source for a specific type.

        :param source_type: the type of the source. Must be one of: `ELM_MAP_SOURCE_TYPE_TILE`,
                            `ELM_MAP_SOURCE_TYPE_ROUTE` or `ELM_MAP_SOURCE_TYPE_NAME`
        :type source_type: :ref:`Elm_Map_Source_Type`

        .. seealso:: :py:func:`sources_get`, :py:func:`source_set`
        """
        return _ctouni(elm_map_source_get(self.obj, source_type))

    def route_add(self, Elm_Map_Route_Type type, Elm_Map_Route_Method method,
                        double flon, double flat, double tlon, double tlat,
                        route_cb, *args, **kwargs):
        """ Add a new route to the map object.

        A route will be traced by point on coordinates (`flat`, `flon`)
        to point on coordinates (`tlat`, `tlon`), using the route service
        set with :py:func:`source_set`.

        It will take `type` on consideration to define the route,
        depending if the user will be walking or driving, the route may vary.
        One of `ELM_MAP_ROUTE_TYPE_MOTOCAR`, `ELM_MAP_ROUTE_TYPE_BICYCLE`,
        or `ELM_MAP_ROUTE_TYPE_FOOT` need to be used.

        Another parameter is what the route should prioritize, the minor distance
        or the less time to be spend on the route. So `method` should be one
        of `ELM_MAP_ROUTE_METHOD_SHORTEST` or `ELM_MAP_ROUTE_METHOD_FASTEST`.

        :param type: one of `ELM_MAP_ROUTE_TYPE_MOTOCAR`, `ELM_MAP_ROUTE_TYPE_BICYCLE`
                     or `ELM_MAP_ROUTE_TYPE_FOOT`
        :type type: :ref:`Elm_Map_Route_Type`
        :param method: `ELM_MAP_ROUTE_METHOD_SHORTEST` or `ELM_MAP_ROUTE_METHOD_FASTEST`
        :type method: :ref:`Elm_Map_Route_Method`
        :param flon: The start longitude.
        :type flon: float
        :param flat: The start latitude.
        :type flat: float
        :param tlon: The destination longitude.
        :type tlon: float
        :param tlat: The destination latitude.
        :type tlat: float
        :param route_cb: A function to be called when the calculation end.
        :type route_cb: callable
        :return: a new route object
        :rtype: :py:class:`MapRoute`

        .. note:: Any other arguments (positional or named) passed to the
                  function will be passed back in the `route_cb` function

        """
        return MapRoute(self, type, method, flon, flat, tlon, tlat,
                        route_cb, *args, **kwargs)

    def name_add(self, address, double lon, double lat,
                       name_cb, *args, **kwargs):
        """  Request an address or geographic coordinates (longitude, latitude)
        from a given address or geographic coordinate(longitude, latitude).

        If you want to get address from geographic coordinates, set param
        `address` to *None* and set `lon` and `lat` as you want to query.

        Instead if you want to query the geographic coordinates for a given
        address set `address` to something different than *None*.

        To get the string for this address, MapName.address_get() should be
        used after the `name_cb` callback or "name,loaded" signal is called.

        In the same way to get the longitude and latitude, MapName.region_get()
        should be used.

        :param address: The address to query, or *None* to query by coordinates
        :type address: string
        :param lon: The longitude of the point to query.
        :type lon: float
        :param lat: The latitude of the point to query.
        :type lat: float
        :param name_cb: A function to be called when the calculation end.
        :type name_cb: callable
        :return: a new name object
        :rtype: :py:class:`MapName`

        .. note:: Any other arguments (positional or named) passed to the
                  function will be passed back in the `name_cb` function

        """
        return MapName(self, address, lon, lat, name_cb, *args, **kwargs)

    # TODO elm_map_track_add

    # TODO elm_map_track_remove

    # TODO elm_map_name_search

    def callback_clicked_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "clicked" signal. """
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "clicked,double" signal. """
        self._callback_add("clicked,double", func, args, kwargs)

    def callback_clicked_double_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("clicked,double", func)

    def callback_press_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "press" signal. """
        self._callback_add("press", func, args, kwargs)

    def callback_press_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "longpressed" signal. """
        self._callback_add("longpressed", func, args, kwargs)

    def callback_longpressed_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("longpressed", func)

    def callback_scroll_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "scroll" signal. """
        self._callback_add("scroll", func, args, kwargs)

    def callback_scroll_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("scroll", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "scroll,drag,start" signal. """
        self._callback_add("scroll,drag,start", func, args, kwargs)

    def callback_scroll_drag_start_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "scroll,drag,stop" signal. """
        self._callback_add("scroll,drag,stop", func, args, kwargs)

    def callback_scroll_drag_stop_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("scroll,drag,stop", func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "scroll,anim,start" signal. """
        self._callback_add("scroll,anim,start", func, args, kwargs)

    def callback_scroll_anim_start_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "scroll,anim,stop" signal. """
        self._callback_add("scroll,anim,stop", func, args, kwargs)

    def callback_scroll_anim_stop_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("scroll,anim,stop", func)

    def callback_zoom_start_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "zoom,start" signal. """
        self._callback_add("zoom,start", func, args, kwargs)

    def callback_zoom_start_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("zoom,start", func)

    def callback_zoom_stop_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "zoom,stop" signal. """
        self._callback_add("zoom,stop", func, args, kwargs)

    def callback_zoom_stop_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("zoom,stop", func)

    def callback_zoom_change_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "zoom,change" signal. """
        self._callback_add("zoom,change", func, args, kwargs)

    def callback_zoom_change_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("zoom,change", func)

    def callback_tile_load_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "tile,load" signal. """
        self._callback_add("tile,load", func, args, kwargs)

    def callback_tile_load_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("tile,load", func)

    def callback_tile_loaded_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "tile,loaded" signal. """
        self._callback_add("tile,loaded", func, args, kwargs)

    def callback_tile_loaded_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("tile,loaded", func)

    def callback_tile_loaded_fail_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "tile,loaded,fail" signal. """
        self._callback_add("tile,loaded,fail", func, args, kwargs)

    def callback_tile_loaded_fail_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("tile,loaded,fail", func)

    def callback_route_load_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "route,load" signal. """
        self._callback_add("route,load", func, args, kwargs)

    def callback_route_load_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("route,load", func)

    def callback_route_loaded_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "route,loaded" signal. """
        self._callback_add("route,loaded", func, args, kwargs)

    def callback_route_loaded_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("route,loaded", func)

    def callback_route_loaded_fail_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "route,loaded,fail" signal. """
        self._callback_add("route,loaded,fail", func, args, kwargs)

    def callback_route_loaded_fail_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("route,loaded,fail", func)

    def callback_name_load_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "name,load" signal. """
        self._callback_add("name,load", func, args, kwargs)

    def callback_name_load_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("name,load", func)

    def callback_name_loaded_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "name,loaded" signal. """
        self._callback_add("name,loaded", func, args, kwargs)

    def callback_name_loaded_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("name,loaded", func)

    def callback_name_loaded_fail_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "name,loaded,fail" signal. """
        self._callback_add("name,loaded,fail", func, args, kwargs)

    def callback_name_loaded_fail_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("name,loaded,fail", func)

    def callback_overlay_clicked_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "overlay,clicked" signal. """
        self._callback_add("overlay,clicked", func, args, kwargs)

    def callback_overlay_clicked_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("overlay,clicked", func)

    def callback_overlay_del_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "overlay,del" signal. """
        self._callback_add("overlay,del", func, args, kwargs)

    def callback_overlay_del_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("overlay,del", func)

    def callback_loaded_add(self, func, *args, **kwargs):
        """ Add a callback to be called on the "loaded" signal. """
        self._callback_add("loaded", func, args, kwargs)

    def callback_loaded_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("loaded", func)

    property scroller_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.scroller_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scroller_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

_object_mapping_register("Elm_Map", Map)
