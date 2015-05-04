#!/usr/bin/env python
# encoding: utf-8

import os
from random import randint

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_CALLBACK_MOUSE_DOWN, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.entry import Entry
from efl.elementary.hoversel import Hoversel
from efl.elementary.icon import Icon
from efl.elementary.label import Label
from efl.elementary.separator import Separator
from efl.elementary.map import Map, MapOverlayClass, ELM_MAP_OVERLAY_TYPE_CLASS, \
    ELM_MAP_SOURCE_TYPE_TILE, ELM_MAP_ROUTE_TYPE_MOTOCAR, ELM_MAP_ROUTE_METHOD_FASTEST, \
    ELM_MAP_SOURCE_TYPE_ROUTE, ELM_MAP_SOURCE_TYPE_NAME
from efl.elementary.menu import Menu
from efl.elementary.slider import Slider


elementary.need_efreet()

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

route_start_point = None
route_end_point = None

def print_map_info(Map):
    print("---Map info---")
    # print("user_agent: %s" % (Map.user_agent))
    print("zoom:%d (min:%d max:%d mode:%d)" %
          (Map.zoom, Map.zoom_min, Map.zoom_max, Map.zoom_mode))
    print("region:%f %f" % Map.region)

    (x, y) = Map.center
    print("map_center:%d %d" % (x, y))
    (lon, lat) = Map.canvas_to_region_convert(x, y)
    print("canvas_to_region:%f %f" % (lon, lat))
    (x2, y2) = Map.region_to_canvas_convert(lon, lat)
    print("region_to_canvas:%d %d (should be equal to %d %d)" % (x2, y2, x, y))

def cb_btn_zoom(bt, Map, zoom):
    Map.zoom += zoom
    print_map_info(Map)

def cb_menu_show(menu, item, Map, lon, lat):
    Map.region_show(lon, lat)
    print_map_info(Map)

def cb_menu_bringin(menu, item, Map, lon, lat):
    Map.region_bring_in(lon, lat)
    print_map_info(Map)

def cb_slider_rot(sl, Map):
    (cx, cy) = Map.center
    Map.rotate_set(sl.value, cx, cy)
    print("New rotate: %f %d %d" % Map.rotate)

def cb_hovsel_selected(hov, item, Map, src_type, name):
    Map.source_set(src_type, item.text)
    hov.text = "%s: %s" % (name, item.text)

def cb_chk_overlays_hidden(ck, Map):
    for ov in Map.overlays:
        ov.hide = ck.state

def cb_chk_overlays_paused(ck, m):
    for ov in m.overlays:
        ov.paused = ck.state


def cb_menu_overlay_normal(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    ov.callback_clicked_set(lambda m,o: o.delete())

def cb_menu_overlay_icon(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    ov.icon = Icon(Map, file=os.path.join(img_path, "logo.png"))

def cb_menu_overlay_custom(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    cont = Icon(Map, file=os.path.join(img_path, "sky_01.jpg"))
    cont.size_hint_min = 50, 50
    ov.content = cont

def cb_menu_overlay_random_color(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    ov.color = (randint(0, 255), randint(0, 255), randint(0, 255), 255)
    ov.callback_clicked_set(lambda m,o: o.delete())

def cb_menu_overlay_min_zoom(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    ov.displayed_zoom_min = 4
    ov.callback_clicked_set(lambda m,o: o.delete())

def cb_menu_overlay_grouped(menu, item, Map, lon, lat):
    cls = Map.overlay_class_add()
    for x in range(4):
        for y in range(4):
            ov = Map.overlay_add(lon + x, lat + y)
            ov.callback_clicked_set(lambda m,o: o.delete())
            cls.append(ov)

def cb_menu_overlay_bubble(menu, item, Map, lon, lat):
    ov = Map.overlay_add(lon, lat)
    bub = Map.overlay_bubble_add()
    bub.follow(ov)

    lb = Label(Map, text="You can push contents here")
    bub.content_append(lb)
    lb.show()

    ic = Icon(Map, file=os.path.join(img_path, "sky_01.jpg"))
    ic.size_hint_min = 50, 50
    bub.content_append(ic)
    ic.show()

    bt = Button(Map, text="clear me")
    bt.callback_clicked_add(lambda bt:bub.content_clear())
    bub.content_append(bt)
    bt.show()

def cb_menu_overlay_line(menu, item, Map, lon, lat):
    line = Map.overlay_line_add(lon, lat, lon + 1, lat + 1)

def cb_menu_overlay_poly(menu, item, Map, lon, lat):
    poly = Map.overlay_polygon_add()
    poly.region_add(lon, lat)
    poly.region_add(lon + 1, lat + 1)
    poly.region_add(lon + 1, lat - 1)
    poly.region_add(lon - 1, lat)

def cb_menu_overlay_circle(menu, item, Map, lon, lat):
    cir = Map.overlay_circle_add(lon, lat, 10)

def cb_menu_overlay_scale(menu, item, Map, x, y):
    Map.overlay_scale_add(x, y)

def cb_menu_overlays_clear(menu, item, Map):
    for ov in Map.overlays:
        if ov.type != ELM_MAP_OVERLAY_TYPE_CLASS:
            ov.delete()

def cb_menu_overlays_show(menu, item, Map):
    l = [ov for ov in Map.overlays if not isinstance(ov, MapOverlayClass)]
    Map.overlays_show(l) # TODO FIXME

def cb_menu_overlays_ungroup(menu, item, Map):
    for ov in Map.overlays:
        print("DEL1: " + str(ov))
        if isinstance(ov, MapOverlayClass):
            # TODO ungroup instead
            print ("****")
            for ov2 in ov.members:
                print("DEL2: " + str(ov2))
                ov2.delete() # TODO FIXME

def cb_menu_route_start(menu, item, Map, lon, lat):
    global route_start_point
    route_start_point = Map.overlay_add(lon, lat)
    route_start_point.color = (255, 0, 0, 255)

def cb_menu_route_end(menu, item, Map, lon, lat):
    global route_end_point
    route_end_point = Map.overlay_add(lon, lat)
    route_end_point.color = (0, 0, 255, 255)

def cb_btn_calc_route(btn, Map):
    lb = Map.data["lb_distance"]
    if not (route_start_point and route_end_point):
        lb.text = "You must first place Start and End point"
        return
    (flon, flat) = route_start_point.region
    (tlon, tlat) = route_end_point.region
    Map.route_add(ELM_MAP_ROUTE_TYPE_MOTOCAR,
                  ELM_MAP_ROUTE_METHOD_FASTEST,
                  flon, flat, tlon, tlat, cb_route_done)

    lb = Map.data["lb_distance"]
    lb.text = "requesting route..."

def cb_route_done(Map, route):
    nodes = route.node.count('\n')
    lb = Map.data["lb_distance"]
    lb.text = "distance: %.2f Km   nodes:%d" % (route.distance, nodes)

    ov = Map.overlay_route_add(route)

    print("Nodes:\n %s" % (route.node))
    print("Waypoints:\n %s" % (route.waypoint))

def cb_map_mouse_down(Map, evtinfo):
    (x,y) = evtinfo.position.canvas
    (lon, lat) = Map.canvas_to_region_convert(x, y)
    if evtinfo.button == 3:
        m = Menu(Map)
        mi = m.item_add(None, "Lat: %f" % lat)
        mi.disabled = True
        mi = m.item_add(None, "Lon: %f" % lon)
        mi.disabled = True
        
        mi = m.item_add(None, "Move")
        m.item_add(mi, "Show Sydney", None, cb_menu_show, Map, 151.175274, -33.859126)
        m.item_add(mi, "Show Paris", None, cb_menu_show, Map, 2.342913, 48.853701)
        m.item_add(mi, "Bringin Sydney", None, cb_menu_bringin, Map, 151.175274, -33.859126)
        m.item_add(mi, "Bringin Paris", None, cb_menu_bringin, Map, 2.342913, 48.853701)
        
        mi = m.item_add(None, "Add overlay")
        m.item_add(mi, "Normal", None, cb_menu_overlay_normal, Map, lon, lat)
        m.item_add(mi, "Icon", None, cb_menu_overlay_icon, Map, lon, lat)
        m.item_add(mi, "Custom content", None, cb_menu_overlay_custom, Map, lon, lat)
        m.item_add(mi, "Random color", None, cb_menu_overlay_random_color, Map, lon, lat)
        m.item_add(mi, "Min zoom 4", None, cb_menu_overlay_min_zoom, Map, lon, lat)
        m.item_add(mi, "16 grouped", None, cb_menu_overlay_grouped, Map, lon, lat)
        m.item_add(mi, "Bubble attached", None, cb_menu_overlay_bubble, Map, lon, lat)
        m.item_add(mi, "Line", None, cb_menu_overlay_line, Map, lon, lat)
        m.item_add(mi, "Polygon", None, cb_menu_overlay_poly, Map, lon, lat)
        m.item_add(mi, "Circle", None, cb_menu_overlay_circle, Map, lon, lat)
        m.item_add(mi, "Scale", None, cb_menu_overlay_scale, Map, x, y)

        mi = m.item_add(None, "Overlays")
        m.item_add(mi, "Clear", None, cb_menu_overlays_clear, Map)
        m.item_add(mi, "Show (BROKEN)", None, cb_menu_overlays_show, Map)
        m.item_add(mi, "ungroup (BROKEN)", None, cb_menu_overlays_ungroup, Map)

        mi = m.item_add(None, "Route")
        m.item_add(mi, "Set start point", None, cb_menu_route_start, Map, lon, lat)
        m.item_add(mi, "Set end point", None, cb_menu_route_end, Map, lon, lat)

        m.move(x, y)
        m.show()

def cb_map_load(m):
    lb = m.data["lb_load_status"]
    status = m.tile_load_status
    lb.text = "tile_load_status: %d / %d" % (status[1], status[0])

def cb_btn_search_name(bt, Map, en):
    Map.name_add(en.text, 0, 0, cb_search_name_done, en)
    en.text = "searching..."

def cb_search_name_done(Map, name, en):
    global route_start_point

    en.text = name.address
    (lon, lat) = name.region
    Map.region_show(lon, lat)
    Map.zoom = 12

    if route_start_point is None:
        route_start_point = Map.overlay_add(lon, lat)
        route_start_point.color = (255, 0, 0, 255)
    else:
        route_start_point.region = (lon, lat)

def cb_btn_search_region(bt, Map, en):
    if route_start_point is None:
        en.text = "You must first place the start point"
    else:
        (lon, lat) = route_start_point.region
        Map.name_add(None, lon, lat, cb_search_region_done, en)
        en.text = "searching..."

def cb_search_region_done(Map, name, en):
    en.text = name.address

def cb_btn_goto(btn, Map):
    Map.zoom = 12
    Map.region_show(9.204, 45.446)

def map_clicked(obj):
    win = StandardWindow("map", "Map test", autodel=True, size=(600, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win)
    vbox.size_hint_weight = EXPAND_BOTH
    vbox.size_hint_align = FILL_BOTH
    win.resize_object_add(vbox)
    vbox.show()

    map_obj = Map(win, zoom=2)
    map_obj.size_hint_weight = EXPAND_BOTH
    map_obj.size_hint_align = FILL_BOTH
    map_obj.callback_tile_load_add(cb_map_load)
    map_obj.callback_tile_loaded_add(cb_map_load)
    map_obj.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, cb_map_mouse_down)
    vbox.pack_end(map_obj)
    map_obj.show()

    ###
    lb = Label(win, text="load_status: 0 / 0")
    vbox.pack_end(lb)
    lb.show()
    map_obj.data["lb_load_status"] = lb

    ###
    hbox = Box(win, horizontal=True)
    hbox.size_hint_weight = EXPAND_HORIZ
    hbox.size_hint_align = FILL_HORIZ
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Goto")
    bt.callback_clicked_add(cb_btn_goto, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Zoom +")
    bt.callback_clicked_add(cb_btn_zoom, map_obj, 1)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Zoom -")
    bt.callback_clicked_add(cb_btn_zoom, map_obj, -1)
    hbox.pack_end(bt)
    bt.show()

    sl = Slider(win, text="Rotation:", min_max=(0, 360), value=0,
        indicator_format="%3.0f")
    sl.callback_changed_add(cb_slider_rot, map_obj)
    hbox.pack_end(sl)
    sl.show()

    src_type = ELM_MAP_SOURCE_TYPE_TILE
    ho = Hoversel(win, hover_parent=win,
                  text="Tiles: %s" % (map_obj.source_get(src_type)))
    for src in map_obj.sources_get(src_type):
        ho.item_add(src)
    ho.callback_selected_add(cb_hovsel_selected, map_obj, src_type, "Tiles")
    hbox.pack_end(ho)
    ho.show()

    ###
    hbox = Box(win, horizontal=True)
    hbox.size_hint_weight = EXPAND_HORIZ
    hbox.size_hint_align = FILL_HORIZ
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="wheel_disabled")
    ck.callback_changed_add(lambda bt: map_obj.wheel_disabled_set(bt.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="paused")
    ck.callback_changed_add(lambda bt: map_obj.paused_set(bt.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="hide overlays")
    ck.callback_changed_add(cb_chk_overlays_hidden, map_obj)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="pause overlays")
    ck.callback_changed_add(cb_chk_overlays_paused, map_obj)
    hbox.pack_end(ck)
    ck.show()

    ###
    sp = Separator(win, horizontal=True)
    sp.show()
    vbox.pack_end(sp)

    hbox = Box(win, horizontal=True)
    hbox.size_hint_weight = EXPAND_HORIZ
    hbox.size_hint_align = FILL_HORIZ
    vbox.pack_end(hbox)
    hbox.show()

    src_type = ELM_MAP_SOURCE_TYPE_ROUTE
    ho = Hoversel(win, hover_parent=win,
                  text="Routes: %s" % (map_obj.source_get(src_type)))
    for src in map_obj.sources_get(src_type):
        ho.item_add(src)
    ho.callback_selected_add(cb_hovsel_selected, map_obj, src_type, "Routes")
    hbox.pack_end(ho)
    ho.show()

    lb = Label(win, text="Set Start and End point to calculate route")
    hbox.pack_end(lb)
    lb.show()
    map_obj.data["lb_distance"] = lb

    bt = Button(win, text="Calc route")
    bt.callback_clicked_add(cb_btn_calc_route, map_obj)
    hbox.pack_end(bt)
    bt.show()

    ###
    sp = Separator(win, horizontal=True)
    sp.show()
    vbox.pack_end(sp)

    hbox = Box(win, horizontal=True)
    hbox.size_hint_weight = EXPAND_HORIZ
    hbox.size_hint_align = FILL_HORIZ
    vbox.pack_end(hbox)
    hbox.show()
    
    src_type = ELM_MAP_SOURCE_TYPE_NAME
    ho = Hoversel(win, hover_parent=win,
                  text="Names: %s" % (map_obj.source_get(src_type)))
    for src in map_obj.sources_get(src_type):
        ho.item_add(src)
    ho.callback_selected_add(cb_hovsel_selected, map_obj, src_type, "Names")
    hbox.pack_end(ho)
    ho.show()

    en = Entry(win, scrollable=True, text="type an address here")
    en.size_hint_weight = EXPAND_BOTH
    en.size_hint_align = FILL_BOTH
    en.single_line = True
    hbox.pack_end(en)
    en.show()

    bt = Button(win, text="Search address")
    bt.callback_clicked_add(cb_btn_search_name, map_obj, en)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Search start point")
    bt.callback_clicked_add(cb_btn_search_region, map_obj, en)
    hbox.pack_end(bt)
    bt.show()


    print_map_info(map_obj)
    win.show()


if __name__ == "__main__":

    map_clicked(None)

    elementary.run()
