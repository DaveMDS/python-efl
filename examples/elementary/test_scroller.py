#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.button import Button
from efl.elementary.scroller import Scroller
from efl.elementary.table import Table


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def my_scroller_go_300_300(bt, sc):
    sc.region_bring_in(300, 300, 318, 318)

def my_scroller_go_900_300(bt, sc):
    sc.region_bring_in(900, 300, 318, 318)

def my_scroller_go_300_900(bt, sc):
    sc.region_bring_in(300, 900, 318, 318)

def my_scroller_go_900_900(obj, sc):
    sc.region_bring_in(900, 900, 318, 318)

def cb_edges(obj, border):
    print("Border callback: " + border)

def cb_drags(obj, action):
    print("Drag callback: " + action)

def cb_anims(obj, action):
    print("Anim callback: " + action)

def scroller_clicked(obj):
    win = StandardWindow("scroller", "Scroller", autodel=True, size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tb = Table(win, size_hint_weight=EXPAND_BOTH)

    img = ["panel_01.jpg",
           "plant_01.jpg",
           "rock_01.jpg",
           "rock_02.jpg",
           "sky_01.jpg",
           "sky_02.jpg",
           "sky_03.jpg",
           "sky_04.jpg",
           "wood_01.jpg"]

    n = 0
    for j in range(12):
        for i in range(12):
            bg2 = Background(win, file=os.path.join(img_path, img[n]),
                size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
                size_hint_min=(318, 318))

            n += 1
            if n >= 9:
                n = 0
            tb.pack(bg2, i, j, 1, 1)
            bg2.show()

    sc = Scroller(win, size_hint_weight=EXPAND_BOTH, content=tb,
        page_relative=(1.0, 1.0))
    sc.callback_edge_top_add(cb_edges, "top")
    sc.callback_edge_bottom_add(cb_edges, "bottom")
    sc.callback_edge_left_add(cb_edges, "left")
    sc.callback_edge_right_add(cb_edges, "right")
    sc.callback_scroll_drag_start_add(cb_drags, "start")
    sc.callback_scroll_drag_stop_add(cb_drags, "stop")
    sc.callback_scroll_anim_start_add(cb_anims, "start")
    sc.callback_scroll_anim_stop_add(cb_anims, "stop")
    win.resize_object_add(sc)

    tb.show()

    sc.show()

    tb2 = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb2)

    bt = Button(win, text="to 300 300", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.1, 0.1))
    bt.callback_clicked_add(my_scroller_go_300_300, sc)
    tb2.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win, text="to 900 300", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.1))
    bt.callback_clicked_add(my_scroller_go_900_300, sc)
    tb2.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win, text="to 300 900", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.1, 0.9))
    bt.callback_clicked_add(my_scroller_go_300_900, sc)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="to 900 900", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.9))
    bt.callback_clicked_add(my_scroller_go_900_900, sc)
    tb2.pack(bt, 1, 1, 1, 1)
    bt.show()

    tb2.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    scroller_clicked(None)

    elementary.run()
    elementary.shutdown()
