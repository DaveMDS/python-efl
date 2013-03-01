#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.hoversel import Hoversel
from efl.elementary.map import Map
from efl.elementary.slider import Slider


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

def cb_btn_show(bt, Map, lon, lat):
    Map.region_show(lon, lat)
    print_map_info(Map)

def cb_btn_bringin(bt, Map, lon, lat):
    Map.region_bring_in(lon, lat)
    print_map_info(Map)

def cb_slider_rot(sl, Map):
    (cx, cy) = Map.center
    Map.rotate_set(sl.value, cx, cy)
    print("New rotate: %f %d %d" % Map.rotate)

def cb_hovsel_selected(hov, item, Map, type):
    Map.source_set(type, item.text)
    hov.text = "Tiles: %s" % (item.text)

def map_clicked(obj):
    win = Window("map", elementary.ELM_WIN_BASIC)
    win.title = "Map test"
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    vbox = Box(win)
    vbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    vbox.size_hint_align = (evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    win.resize_object_add(vbox)
    vbox.show()

    map_obj = Map(win)
    map_obj.zoom = 2
    map_obj.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    map_obj.size_hint_align = (evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    # map_obj.callback_clicked_add(cb_map_clicked)
    vbox.pack_end(map_obj)
    map_obj.show()

    # view
    hbox = Box(win)
    hbox.horizontal = True
    hbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, 0.0)
    hbox.size_hint_align = (evas.EVAS_HINT_FILL, 0.0)
    vbox.pack_end(hbox)
    hbox.show()
    
    bt = Button(win)
    bt.text = "Zoom +"
    bt.callback_clicked_add(cb_btn_zoom, map_obj, 1)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text = "Zoom -"
    bt.callback_clicked_add(cb_btn_zoom, map_obj, -1)
    hbox.pack_end(bt)
    bt.show()

    sl = Slider(win)
    sl.text = "Rotation:"
    sl.min_max = (0, 360)
    sl.value = 0
    sl.indicator_format = "%3.0f"
    sl.callback_changed_add(cb_slider_rot, map_obj)
    hbox.pack_end(sl)
    sl.show()

    ho = Hoversel(win)
    ho.hover_parent_set(win)
    type = elementary.ELM_MAP_SOURCE_TYPE_TILE
    ho.text_set("Tiles: %s" % (map_obj.source_get(type)))
    for src in map_obj.sources_get(type):
        ho.item_add(src)
    ho.callback_selected_add(cb_hovsel_selected, map_obj, type)
    hbox.pack_end(ho)
    ho.show()

    # show / bring in
    hbox = Box(win)
    hbox.horizontal = True
    hbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, 0.0)
    hbox.size_hint_align = (evas.EVAS_HINT_FILL, 0.0)
    vbox.pack_end(hbox)
    hbox.show()
    
    bt = Button(win)
    bt.text = "Show Sydney"
    bt.callback_clicked_add(cb_btn_show, map_obj, 151.175274, -33.859126)
    hbox.pack_end(bt)
    bt.show()
    
    bt = Button(win)
    bt.text = "Show Paris"
    bt.callback_clicked_add(cb_btn_show, map_obj, 2.342913, 48.853701)
    hbox.pack_end(bt)
    bt.show()
    
    bt = Button(win)
    bt.text = "BringIn Sydney"
    bt.callback_clicked_add(cb_btn_bringin, map_obj, 151.175274, -33.859126)
    hbox.pack_end(bt)
    bt.show()
    
    bt = Button(win)
    bt.text = "BringIn Paris"
    bt.callback_clicked_add(cb_btn_bringin, map_obj, 2.342913, 48.853701)
    hbox.pack_end(bt)
    bt.show()

    hbox = Box(win)
    hbox.horizontal = True
    hbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, 0.0)
    hbox.size_hint_align = (evas.EVAS_HINT_FILL, 0.0)
    vbox.pack_end(hbox)
    hbox.show()

    # options
    ck = Check(win)
    ck.text = "wheel_disabled"
    ck.callback_changed_add(lambda bt: map_obj.wheel_disabled_set(bt.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win)
    ck.text = "paused"
    ck.callback_changed_add(lambda bt: map_obj.paused_set(bt.state))
    hbox.pack_end(ck)
    ck.show()

    print_map_info(map_obj)

    win.resize(600, 600)
    win.show()


if __name__ == "__main__":
    elementary.init()

    map_clicked(None)

    elementary.run()
    elementary.shutdown()
