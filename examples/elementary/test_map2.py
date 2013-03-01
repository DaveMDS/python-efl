#!/usr/bin/env python
# encoding: utf-8

import random

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.ctxpopup import Ctxpopup
# from efl.elementary.entry import Entry
# from efl.elementary.frame import Frame
# from efl.elementary.grid import Grid
# from efl.elementary.hover import Hover
# from efl.elementary.hoversel import Hoversel
# from efl.elementary.label import Label
# from efl.elementary.layout import Layout
# from efl.elementary.list import List
from efl.elementary.icon import Icon
# from efl.elementary.index import Index
# from efl.elementary.innerwindow import InnerWindow
# from efl.elementary.image import Image
from efl.elementary.map import Map
# from efl.elementary.fileselector import Fileselector
# from efl.elementary.fileselector_button import FileselectorButton
# from efl.elementary.fileselector_entry import FileselectorEntry
# from efl.elementary.flip import Flip
# from efl.elementary.gengrid import Gengrid, GengridItemClass
# from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass
# from efl.elementary.radio import Radio
# from efl.elementary.separator import Separator
# from efl.elementary.slider import Slider
# from efl.elementary.table import Table
# from efl.elementary.flipselector import FlipSelector


def cb_btn_clear_overlays(bt, Map):
    for ov in Map.overlays:
        print ov, ov.type
        if (ov.type != elementary.ELM_MAP_OVERLAY_TYPE_CLASS):
            ov.delete()

def cb_btn_ungroup_overlays(bt, Map):
    for ov in Map.overlays:
        if isinstance(ov, MapOverlayClass):
            print ov
            # TODO ungroup instead
            for ov2 in ov.members:
                ov.delete()

def cb_btn_show_overlays(bt, Map):
    Map.overlays_show(Map.overlays)

def cb_chk_overlays_hidden(ck, Map):
    for ov in Map.overlays:
        ov.hide = ck.state

def cb_chk_overlays_paused(ck, Map):
    for ov in Map.overlays:
        ov.paused = ck.state

def cb_overlay_clicked(Map, ov):
    ov.delete()

def cb_ctx_overlay_add(li, item, Map, lon, lat, min_zoom = 0, icon = None):
    item.widget_get().dismiss()
    ov = Map.overlay_add(lon, lat)
    if min_zoom > 0:
        ov.displayed_zoom_min = min_zoom
    if icon:
        ov.icon = icon

    ov.callback_clicked_set(cb_overlay_clicked)

def cb_ctx_overlay_add_custom(li, item, Map, lon, lat):
    item.widget_get().dismiss()
    cont = Icon(Map)
    cont.file_set("images/sky_01.jpg")
    cont.size_hint_min = (50, 50)
    cont.show()
    ov = Map.overlay_add(lon, lat)
    ov.content = cont

def cb_ctx_overlay_add_random_color(li, item, Map, lon, lat):
    item.widget_get().dismiss()
    ov = Map.overlay_add(lon, lat)
    ov.color = (random.randint(0, 255), random.randint(0, 255),
                random.randint(0, 255), 200)

def cb_ctx_overlay_grouped(li, item, Map, lon, lat, sx, sy):
    item.widget_get().dismiss()
    cls = Map.overlay_class_add()
    for x in range(4):
        for y in range(4):
            (lon, lat) = Map.canvas_to_region_convert(sx + x * 10, sy + y * 10)
            ov = Map.overlay_add(lon, lat)
            cls.append(ov)

def cb_ctx_overlay_bubble(li, item, Map, lon, lat):
    item.widget_get().dismiss()

    ov = Map.overlay_add(lon, lat)
    bub = Map.overlay_bubble_add()
    bub.follow(ov)

    lb = Label(Map)
    lb.text = "You can push contents here"
    bub.content_append(lb)
    lb.show()

    ic = Icon(Map)
    ic.file_set("images/sky_01.jpg")
    ic.size_hint_min = (50, 50)
    bub.content_append(ic)
    ic.show()

    bt = Button(Map)
    bt.text = "clear me"
    bt.callback_clicked_add(lambda bt:bub.content_clear())
    bub.content_append(bt)
    bt.show()

def cb_ctx_overlay_line(li, item, Map, lon, lat):
    item.widget_get().dismiss()
    line = Map.overlay_line_add(lon, lat, lon + 1, lat + 1)

def cb_ctx_overlay_polygon(li, item, Map, lon, lat):
    item.widget_get().dismiss()
    poly = Map.overlay_polygon_add()
    poly.region_add(lon, lat)
    poly.region_add(lon + 1, lat + 1)
    poly.region_add(lon + 1, lat - 1)
    poly.region_add(lon - 1, lat)

def cb_ctx_overlay_circle(li, item, Map, lon, lat, radius):
    item.widget_get().dismiss()
    Map.overlay_circle_add(lon, lat, radius)

def cb_ctx_overlay_scale(li, item, Map, x, y):
    item.widget_get().dismiss()
    Map.overlay_scale_add(x, y)

def test(li, item, Map, lon, lat):
    print li
    print item
    print Map
    # ctx.dismiss()
    ov = Map.overlay_add(lon, lat)

def cb_map_clicked(Map):
    (x, y) = Map.evas.pointer_canvas_xy_get()
    (lon, lat) = Map.canvas_to_region_convert(x, y)
    cp = Ctxpopup(Map)
    cp.item_append("%f  %f" % (lon, lat), None, None).disabled = True
    cp.item_append("Add Overlay here", None, cb_ctx_overlay_add, Map, lon, lat)
    ic = Icon(Map)
    ic.file_set("images/logo.png")
    cp.item_append("Add Overlay with icon", None, cb_ctx_overlay_add, Map, lon, lat, 0, ic)
    cp.item_append("Add Overlay custom content", None, cb_ctx_overlay_add_custom, Map, lon, lat)
    cp.item_append("Add Overlay random color", None, cb_ctx_overlay_add_random_color, Map, lon, lat)
    cp.item_append("Add Overlay (min zoom 4)", None, cb_ctx_overlay_add, Map, lon, lat, 4)
    cp.item_append("Add 16 Grouped Overlays", None, cb_ctx_overlay_grouped, Map, lon, lat, x, y)
    cp.item_append("Add one with a bubble attached", None, cb_ctx_overlay_bubble, Map, lon, lat)
    cp.item_append("Add an Overlay Line", None, cb_ctx_overlay_line, Map, lon, lat)
    cp.item_append("Add an Overlay Polygon", None, cb_ctx_overlay_polygon, Map, lon, lat)
    cp.item_append("Add an Overlay Circle", None, cb_ctx_overlay_circle, Map, lon, lat, 10)
    cp.item_append("Add an Overlay Scale", None, cb_ctx_overlay_scale, Map, x, y)
    cp.move(x, y)
    cp.show()

def map_overlays_clicked(obj):
    win = Window("map2", elementary.ELM_WIN_BASIC)
    win.title = "Map Overlay test"
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
    map_obj.callback_clicked_add(cb_map_clicked)
    vbox.pack_end(map_obj)
    map_obj.show()

    # overlays
    hbox = Box(win)
    hbox.horizontal = True
    hbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, 0.0)
    hbox.size_hint_align = (evas.EVAS_HINT_FILL, 0.0)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win)
    ck.text = "overlays hidden"
    ck.callback_changed_add(cb_chk_overlays_hidden, map_obj)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win)
    ck.text = "overlays paused"
    ck.callback_changed_add(cb_chk_overlays_paused, map_obj)
    hbox.pack_end(ck)
    ck.show()

    bt = Button(win)
    bt.text = "clear overlays"
    bt.callback_clicked_add(cb_btn_clear_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text = "ungroup (BROKEN)"
    bt.callback_clicked_add(cb_btn_ungroup_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text = "overlays_show()"
    bt.callback_clicked_add(cb_btn_show_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    win.resize(600, 600)
    win.show()


if __name__ == "__main__":
    elementary.init()

    map_overlays_clicked(None)

    elementary.run()
    elementary.shutdown()
