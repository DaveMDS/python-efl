#!/usr/bin/env python
# encoding: utf-8

import random
import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
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
from efl.elementary.map import Map, MapOverlayClass, ELM_MAP_OVERLAY_TYPE_CLASS
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

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_HORIZ = EVAS_HINT_FILL, 0.5

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def cb_btn_clear_overlays(bt, m):
    for ov in m.overlays:
        print(ov, ov.type)
        if (ov.type != ELM_MAP_OVERLAY_TYPE_CLASS):
            ov.delete()

def cb_btn_ungroup_overlays(bt, m):
    for ov in m.overlays:
        if isinstance(ov, MapOverlayClass):
            print(ov)
            # TODO ungroup instead
            for ov2 in ov.members:
                print("deleting ov")
                ov2.delete()

def cb_btn_show_overlays(bt, m):
    m.overlays_show(m.overlays)

def cb_chk_overlays_hidden(ck, m):
    for ov in m.overlays:
        ov.hide = ck.state

def cb_chk_overlays_paused(ck, m):
    for ov in m.overlays:
        ov.paused = ck.state

def cb_overlay_clicked(m, ov):
    ov.delete()

def cb_ctx_overlay_add(li, item, m, lon, lat, min_zoom = 0, icon = None):
    item.widget.dismiss()
    ov = m.overlay_add(lon, lat)
    if min_zoom > 0:
        ov.displayed_zoom_min = min_zoom
    if icon:
        ov.icon = icon

    ov.callback_clicked_set(cb_overlay_clicked)

def cb_ctx_overlay_add_custom(li, item, m, lon, lat):
    item.widget.dismiss()
    cont = Icon(m, file=os.path.join(img_path, "sky_01.jpg"),
        size_hint_min=(50, 50))
    cont.show()
    ov = m.overlay_add(lon, lat)
    ov.content = cont

def cb_ctx_overlay_add_random_color(li, item, m, lon, lat):
    item.widget.dismiss()
    ov = m.overlay_add(lon, lat)
    ov.color = (random.randint(0, 255), random.randint(0, 255),
                random.randint(0, 255), 200)

def cb_ctx_overlay_grouped(li, item, m, lon, lat, sx, sy):
    item.widget.dismiss()
    cls = m.overlay_class_add()
    for x in range(4):
        for y in range(4):
            (lon, lat) = m.canvas_to_region_convert(sx + x * 10, sy + y * 10)
            ov = m.overlay_add(lon, lat)
            cls.append(ov)

def cb_ctx_overlay_bubble(li, item, m, lon, lat):
    item.widget.dismiss()

    ov = m.overlay_add(lon, lat)
    bub = m.overlay_bubble_add()
    bub.follow(ov)

    lb = Label(m, text="You can push contents here")
    bub.content_append(lb)
    lb.show()

    ic = Icon(m, file=os.path.join(img_path, "sky_01.jpg"),
        size_hint_min=(50, 50))
    bub.content_append(ic)
    ic.show()

    bt = Button(m, text="clear me")
    bt.callback_clicked_add(lambda bt:bub.content_clear())
    bub.content_append(bt)
    bt.show()

def cb_ctx_overlay_line(li, item, m, lon, lat):
    item.widget.dismiss()
    line = m.overlay_line_add(lon, lat, lon + 1, lat + 1)

def cb_ctx_overlay_polygon(li, item, m, lon, lat):
    item.widget.dismiss()
    poly = m.overlay_polygon_add()
    poly.region_add(lon, lat)
    poly.region_add(lon + 1, lat + 1)
    poly.region_add(lon + 1, lat - 1)
    poly.region_add(lon - 1, lat)

def cb_ctx_overlay_circle(li, item, m, lon, lat, radius):
    item.widget.dismiss()
    m.overlay_circle_add(lon, lat, radius)

def cb_ctx_overlay_scale(li, item, m, x, y):
    item.widget.dismiss()
    m.overlay_scale_add(x, y)

def test(li, item, m, lon, lat):
    print(li)
    print(item)
    print(m)
    # ctx.dismiss()
    ov = m.overlay_add(lon, lat)

def cb_map_clicked(m):
    (x, y) = m.evas.pointer_canvas_xy_get()
    (lon, lat) = m.canvas_to_region_convert(x, y)
    cp = Ctxpopup(m)
    cp.item_append("%f  %f" % (lon, lat), None, None).disabled = True
    cp.item_append("Add Overlay here", None, cb_ctx_overlay_add, m, lon, lat)
    ic = Icon(m, file=os.path.join(img_path, "logo.png"))
    cp.item_append("Add Overlay with icon", None, cb_ctx_overlay_add, m, lon, lat, 0, ic)
    cp.item_append("Add Overlay custom content", None, cb_ctx_overlay_add_custom, m, lon, lat)
    cp.item_append("Add Overlay random color", None, cb_ctx_overlay_add_random_color, m, lon, lat)
    cp.item_append("Add Overlay (min zoom 4)", None, cb_ctx_overlay_add, m, lon, lat, 4)
    cp.item_append("Add 16 Grouped Overlays", None, cb_ctx_overlay_grouped, m, lon, lat, x, y)
    cp.item_append("Add one with a bubble attached", None, cb_ctx_overlay_bubble, m, lon, lat)
    cp.item_append("Add an Overlay Line", None, cb_ctx_overlay_line, m, lon, lat)
    cp.item_append("Add an Overlay Polygon", None, cb_ctx_overlay_polygon, m, lon, lat)
    cp.item_append("Add an Overlay Circle", None, cb_ctx_overlay_circle, m, lon, lat, 10)
    cp.item_append("Add an Overlay Scale", None, cb_ctx_overlay_scale, m, x, y)
    cp.move(x, y)
    cp.show()

def map_overlays_clicked(obj):
    win = StandardWindow("map2", "Map Overlay test", autodel=True,
        size=(600, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    map_obj = Map(win, zoom=2, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    map_obj.callback_clicked_add(cb_map_clicked)
    vbox.pack_end(map_obj)
    map_obj.show()

    # overlays
    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="overlays hidden")
    ck.callback_changed_add(cb_chk_overlays_hidden, map_obj)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="overlays paused")
    ck.callback_changed_add(cb_chk_overlays_paused, map_obj)
    hbox.pack_end(ck)
    ck.show()

    bt = Button(win, text="clear overlays")
    bt.callback_clicked_add(cb_btn_clear_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="ungroup (BROKEN)")
    bt.callback_clicked_add(cb_btn_ungroup_overlays, map_obj)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="overlays_show()")
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
