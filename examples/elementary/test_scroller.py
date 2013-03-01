#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.button import Button
from efl.elementary.scroller import Scroller
from efl.elementary.table import Table


def my_scroller_go_300_300(bt, sc):
    sc.region_bring_in(300, 300, 318, 318)

def my_scroller_go_900_300(bt, sc):
    sc.region_bring_in(900, 300, 318, 318)

def my_scroller_go_300_900(bt, sc):
    sc.region_bring_in(300, 900, 318, 318)

def my_scroller_go_900_900(obj, sc):
    sc.region_bring_in(900, 900, 318, 318)

def cb_edges(obj, border):
    print(("Border callback:", border))

def cb_drags(obj, action):
    print(("Drag callback:", action))

def cb_anims(obj, action):
    print(("Anim callback:", action))

def scroller_clicked(obj):
    win = Window("scroller", elementary.ELM_WIN_BASIC)
    win.title_set("Scroller")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    tb = Table(win)
    tb.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)

    img = ["images/panel_01.jpg",
           "images/plant_01.jpg",
           "images/rock_01.jpg",
           "images/rock_02.jpg",
           "images/sky_01.jpg",
           "images/sky_02.jpg",
           "images/sky_03.jpg",
           "images/sky_04.jpg",
           "images/wood_01.jpg"]

    n = 0
    for j in range(12):
        for i in range(12):
            bg2 = Background(win)
            bg2.file_set(img[n])

            n = n + 1
            if n >= 9:
                n = 0
            bg2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
            bg2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
            bg2.size_hint_min_set(318, 318)
            tb.pack(bg2, i, j, 1, 1)
            bg2.show()

    sc = Scroller(win)
    sc.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    sc.callback_edge_top_add(cb_edges, "top")
    sc.callback_edge_bottom_add(cb_edges, "bottom")
    sc.callback_edge_left_add(cb_edges, "left")
    sc.callback_edge_right_add(cb_edges, "right")
    sc.callback_scroll_drag_start_add(cb_drags, "start")
    sc.callback_scroll_drag_stop_add(cb_drags, "stop")
    sc.callback_scroll_anim_start_add(cb_anims, "start")
    sc.callback_scroll_anim_stop_add(cb_anims, "stop")
    win.resize_object_add(sc)

    sc.content_set(tb)
    tb.show()

    sc.page_relative_set(1.0, 1.0)
    sc.show()

    tb2 = Table(win)
    tb2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(tb2)

    bt = Button(win)
    bt.text_set("to 300 300")
    bt.callback_clicked_add(my_scroller_go_300_300, sc)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bt.size_hint_align_set(0.1, 0.1)
    tb2.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("to 900 300")
    bt.callback_clicked_add(my_scroller_go_900_300, sc)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bt.size_hint_align_set(0.9, 0.1)
    tb2.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("to 300 900")
    bt.callback_clicked_add(my_scroller_go_300_900, sc)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bt.size_hint_align_set(0.1, 0.9)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("to 900 900")
    bt.callback_clicked_add(my_scroller_go_900_900, sc)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bt.size_hint_align_set(0.9, 0.9)
    tb2.pack(bt, 1, 1, 1, 1)
    bt.show()

    tb2.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    elementary.init()

    scroller_clicked(None)

    elementary.run()
    elementary.shutdown()
