.. currentmodule:: efl.elementary

Map
###

.. image:: /images/map-preview.png
    :width: 100%


Widget description
==================

The *Map* is a widget specifically for displaying a geographic map.
It uses `OpenStreetMap <http://www.openstreetmap.org/>`_ as map tile provider,
`YOURS <http://www.yournavigation.org/>`_ for routing calculation and
`Nominatim <http://nominatim.openstreetmap.org/>`_ to convert geographic
coordinates to/from address names. But custom providers can be added.

It supports some basic but yet nice features:

- zooming and scrolling
- markers with content to be displayed when user clicks over them
- automatic grouping of markers based on zoom level
- routes calculation
- names/coordinates conversion (and viceversa)


Emitted signals
===============

- ``clicked`` - Called when a user has clicked the map without dragging around.
- ``clicked,double`` - Called when a user has double-clicked the map.
- ``press`` - This is called when a user has pressed down on the map.
- ``longpressed`` - This is called when a user has pressed down on the map
  for a long time without dragging around.
- ``scroll`` - the content has been scrolled (moved).
- ``scroll,drag,start`` - dragging the contents around has started.
- ``scroll,drag,stop`` - dragging the contents around has stopped.
- ``scroll,anim,start`` - scrolling animation has started.
- ``scroll,anim,stop`` - scrolling animation has stopped.
- ``zoom,start`` - Zoom animation started.
- ``zoom,stop`` - Zoom animation stopped.
- ``zoom,change`` - Zoom changed when using an auto zoom mode.
- ``tile,load`` - A map tile image load begins.
- ``tile,loaded`` -  A map tile image load ends.
- ``tile,loaded,fail`` -  A map tile image load fails.
- ``route,load`` - Route request begins.
- ``route,loaded`` - Route request ends.
- ``route,loaded,fail`` - Route request fails.
- ``name,load`` - Name request begins.
- ``name,loaded`` - Name request ends.
- ``name,loaded,fail`` - Name request fails.
- ``overlay,clicked`` - A overlay is clicked.
- ``loaded`` - when a map is finally loaded.


Scrollable Interface
====================

This widget supports the scrollable interface.

If you wish to control the scolling behaviour using these functions,
inherit both the widget class and the
:py:class:`Scrollable<efl.elementary.scroller.Scrollable>` class
using multiple inheritance, for example::

    class ScrollableGenlist(Genlist, Scrollable):
        def __init__(self, canvas, *args, **kwargs):
            Genlist.__init__(self, canvas)


Enumerations
============

.. _Elm_Map_Overlay_Type:

Map overlay types
-----------------

.. data:: ELM_MAP_OVERLAY_TYPE_NONE

    None

.. data:: ELM_MAP_OVERLAY_TYPE_DEFAULT

    The default overlay type.

.. data:: ELM_MAP_OVERLAY_TYPE_CLASS

    The Class overlay is used to group marker together.

.. data:: ELM_MAP_OVERLAY_TYPE_GROUP

    A group of overlays.

.. data:: ELM_MAP_OVERLAY_TYPE_BUBBLE

    This class can *follow* another overlay.

.. data:: ELM_MAP_OVERLAY_TYPE_ROUTE

    This is used to draw a route result on the map.

.. data:: ELM_MAP_OVERLAY_TYPE_LINE

    Simply draw a line on the map.

.. data:: ELM_MAP_OVERLAY_TYPE_POLYGON

    Simply draw a polygon on the map.

.. data:: ELM_MAP_OVERLAY_TYPE_CIRCLE

    Simply draw a circle on the map.

.. data:: ELM_MAP_OVERLAY_TYPE_SCALE

    This will draw a dinamic scale on the map.


.. _Elm_Map_Route_Method:

Map route methods
-----------------

.. data:: ELM_MAP_ROUTE_METHOD_FASTEST

    Route should prioritize time

.. data:: ELM_MAP_ROUTE_METHOD_SHORTEST

    Route should prioritize distance


.. _Elm_Map_Route_Type:

Map route types
---------------

.. data:: ELM_MAP_ROUTE_TYPE_MOTOCAR

    Route should consider an automobile will be used.

.. data:: ELM_MAP_ROUTE_TYPE_BICYCLE

    Route should consider a bicycle will be used by the user.

.. data:: ELM_MAP_ROUTE_TYPE_FOOT

    Route should consider user will be walking.


.. _Elm_Map_Source_Type:

Map source types
----------------

.. data:: ELM_MAP_SOURCE_TYPE_TILE

    Map tile provider

.. data:: ELM_MAP_SOURCE_TYPE_ROUTE

    Route service provider

.. data:: ELM_MAP_SOURCE_TYPE_NAME

    Name service provider


.. _Elm_Map_Zoom_Mode:

Map zoom modes
--------------

.. data:: ELM_MAP_ZOOM_MODE_MANUAL

    Zoom controlled manually by :py:attr:`~Map.zoom`

    It's set by default.

.. data:: ELM_MAP_ZOOM_MODE_AUTO_FIT

    Zoom until map fits inside the scroll frame with no pixels outside this
    area.

.. data:: ELM_MAP_ZOOM_MODE_AUTO_FILL

    Zoom until map fills scroll, ensuring no pixels are left unfilled.


Inheritance diagram
===================

.. inheritance-diagram:: Map
    :parts: 2


.. autoclass:: Map
.. autoclass:: MapRoute
.. autoclass:: MapName
.. autoclass:: MapOverlay
.. autoclass:: MapOverlayClass
.. autoclass:: MapOverlayBubble
.. autoclass:: MapOverlayLine
.. autoclass:: MapOverlayPolygon
.. autoclass:: MapOverlayCircle
.. autoclass:: MapOverlayScale
.. autoclass:: MapOverlayRoute
