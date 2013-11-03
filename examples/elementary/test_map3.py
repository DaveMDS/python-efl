#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.ctxpopup import Ctxpopup
from efl.elementary.entry import Entry
from efl.elementary.hoversel import Hoversel
from efl.elementary.label import Label
from efl.elementary.map import Map, ELM_MAP_ROUTE_TYPE_MOTOCAR, \
    ELM_MAP_ROUTE_METHOD_FASTEST, ELM_MAP_SOURCE_TYPE_ROUTE, \
    ELM_MAP_SOURCE_TYPE_NAME
from efl.elementary.separator import Separator

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_HORIZ = EVAS_HINT_FILL, 0.5

_from = None
_to = None


def cb_btn_goto(bt, m):
    m.zoom = 12
    m.region_show(9.204, 45.446)

def cb_ctx_set_from(ctx, item, m, lon, lat):
    global _from

    ctx.dismiss()
    if _from is None:
        _from = m.overlay_add(lon, lat)
        _from.color = (150, 0, 0, 150)
    else:
        _from.region = (lon, lat)

def cb_ctx_set_to(ctx, item, m, lon, lat):
    global _to

    ctx.dismiss()
    if _to is None:
        _to = m.overlay_add(lon, lat)
        _to.color = (0, 0, 150, 150)
    else:
        _to.region = (lon, lat)

def cb_btn_calc_route(bt, m):
    if not (_from and _to):
        return

    (flon, flat) = _from.region
    (tlon, tlat) = _to.region
    m.route_add(ELM_MAP_ROUTE_TYPE_MOTOCAR,
                ELM_MAP_ROUTE_METHOD_FASTEST,
                flon, flat, tlon, tlat, cb_route)

    lb = m.data["lb_distance"]
    lb.text = "requesting route..."

def cb_btn_search_name(bt, m, en):
    m.name_add(en.text, 0, 0, cb_search_name, en)
    en.text = "searching..."

def cb_search_name(m, name, en):
    global _from

    en.text = name.address
    (lon, lat) = name.region
    m.zoom = 12
    m.region_show(lon, lat)

    if _from is None:
        _from = m.overlay_add(lon, lat)
        _from.color = (150, 0, 0, 150)
    else:
        _from.region = (lon, lat)

def cb_btn_search_region(bt, m, en):
    if _from is None:
        return
    (lon, lat) = _from.region
    m.name_add(None, lon, lat, cb_search_region, en)
    en.text = "searching..."

def cb_search_region(m, name, en):
    global _name

    en.text = name.address

def cb_route(m, route):
    nodes = route.node.count('\n')
    lb = m.data["lb_distance"]
    lb.text = "distance: %.2f Km   nodes:%d" % (route.distance, nodes)

    ov = m.overlay_route_add(route)

    print("Node: %s" % (route.node))
    print("Waypoint %s" % (route.waypoint))

def cb_btn_clear_overlays(btn, m):
    for ov in m.overlays:
        if ov != _from and ov != _to:
            ov.delete()

def cb_map_clicked(m):
    (x, y) = m.evas.pointer_canvas_xy_get()
    (lon, lat) = m.canvas_to_region_convert(x, y)
    cp = Ctxpopup(m)
    cp.item_append("%f  %f" % (lon, lat)).disabled = True
    cp.item_append("Set start point", None, cb_ctx_set_from, m, lon, lat)
    cp.item_append("Set end point", None, cb_ctx_set_to, m, lon, lat)
    cp.move(x, y)
    cp.show()

def cb_map_load(m):
    lb = m.data["lb_load_status"]
    status = m.tile_load_status
    lb.text = "tile_load_status: %d / %d" % (status[1], status[0])

def cb_hovsel_selected(hov, item, m, type, name):
    m.source_set(type, item.text)
    hov.text = "%s: %s" % (name, item.text)

def map_route_clicked(obj):
    win = StandardWindow("maproute", "Map Route test", autodel=True,
        size=(600, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    map_obj = Map(win, zoom=2, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    map_obj.callback_clicked_add(cb_map_clicked)
    map_obj.callback_tile_load_add(cb_map_load)
    map_obj.callback_tile_loaded_add(cb_map_load)
    vbox.pack_end(map_obj)
    map_obj.show()

    lb = Label(win, text="load_status: 0 / 0")
    vbox.pack_end(lb)
    lb.show()
    map_obj.data["lb_load_status"] = lb

    lb = Label(win)
    lb.text = "First set Start and End point and then click 'Calc Route !'"
    vbox.pack_end(lb)
    lb.show()
    map_obj.data["lb_distance"] = lb

    # info
    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    # route
    src_type = ELM_MAP_SOURCE_TYPE_ROUTE

    ho = Hoversel(win, hover_parent=win,
        text="Routes: %s" % (map_obj.source_get(src_type)))
    for src in map_obj.sources_get(src_type):
        ho.item_add(src)
    ho.callback_selected_add(cb_hovsel_selected, map_obj, src_type, "Routes")
    hbox.pack_end(ho)
    ho.show()

    sep = Separator(win)
    sep.show()
    hbox.pack_end(sep)

    bt = Button(win, text="GOTO")
    bt.callback_clicked_add(cb_btn_goto, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Calc Route !")
    bt.callback_clicked_add(cb_btn_calc_route, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="clear route overlays")
    bt.callback_clicked_add(cb_btn_clear_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    # names
    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
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

    en = Entry(win, scrollable=True, text="type an address here",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    # en.single_line = True
    hbox.pack_end(en)
    en.show()

    bt = Button(win, text="Search Address !")
    bt.callback_clicked_add(cb_btn_search_name, map_obj, en)
    hbox.pack_end(bt)
    bt.show()

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    en = Entry(win, scrollable=True, disabled=True,
        text="place the start point and press the button",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    # en.single_line = True
    hbox.pack_end(en)
    en.show()

    bt = Button(win, text="Search start point Region")
    bt.callback_clicked_add(cb_btn_search_region, map_obj, en)
    hbox.pack_start(bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    map_route_clicked(None)

    elementary.run()
    elementary.shutdown()
