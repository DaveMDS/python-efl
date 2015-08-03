#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.frame import Frame
from efl.elementary.scroller import Scroller, \
    ELM_SCROLLER_MOVEMENT_BLOCK_VERTICAL, ELM_SCROLLER_MOVEMENT_BLOCK_HORIZONTAL
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

def cb_freeze(chk, scroller):
    if chk.state:
        scroller.scroll_freeze_push()
    else:
        scroller.scroll_freeze_pop()

def cb_hold(chk, scroller):
    if chk.state:
        scroller.scroll_hold_push()
    else:
        scroller.scroll_hold_pop()

def cb_block(chk, scroller, direction):
    if chk.state:
        scroller.movement_block |= direction
    else:
        scroller.movement_block &= 0xFF ^ direction

def cb_snap(chk, scroller):
    scroller.page_snap = (chk.state, chk.state)

def cb_loop_h(chk, scroller):
    h, v = scroller.loop
    scroller.loop = chk.state, v

def cb_loop_v(chk, scroller):
    h, v = scroller.loop
    scroller.loop = h, chk.state

def cb_wheel_disabled(chk, scroller):
    scroller.wheel_disabled = chk.state


def scroller_clicked(obj):
    win = StandardWindow("scroller", "Scroller", autodel=True, size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tb = Table(win, size_hint_weight=EXPAND_BOTH)

    img = ["panel_01.jpg", "plant_01.jpg", "rock_01.jpg",
           "rock_02.jpg", "sky_01.jpg", "sky_02.jpg",
           "sky_03.jpg", "sky_04.jpg", "wood_01.jpg"]

    n = 0
    for j in range(12):
        for i in range(12):
            bg = Background(win, file=os.path.join(img_path, img[n]),
                            size_hint_min=(318, 318))
            n += 1
            if n >= 9:
                n = 0
            tb.pack(bg, i, j, 1, 1)
            bg.show()

    sc = Scroller(win, content=tb, page_size=(318, 318),
                  size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    sc.callback_edge_top_add(cb_edges, "top")
    sc.callback_edge_bottom_add(cb_edges, "bottom")
    sc.callback_edge_left_add(cb_edges, "left")
    sc.callback_edge_right_add(cb_edges, "right")
    sc.callback_scroll_drag_start_add(cb_drags, "start")
    sc.callback_scroll_drag_stop_add(cb_drags, "stop")
    sc.callback_scroll_anim_start_add(cb_anims, "start")
    sc.callback_scroll_anim_stop_add(cb_anims, "stop")
    sc.show()
    tb.show()

    tb2 = Table(win, size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    win.resize_object_add(tb2)
    tb2.pack(sc, 0, 1, 1, 1)
    tb2.show()

    fr = Frame(win, text="Options", size_hint_expand=EXPAND_HORIZ,
               size_hint_fill=FILL_HORIZ)
    tb2.pack(fr, 0, 0, 1, 1)
    fr.show()

    box = Box(fr, horizontal=True)
    fr.content = box
    box.show()

    ck = Check(box, text="Freeze")
    ck.callback_changed_add(cb_freeze, sc)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Hold")
    ck.callback_changed_add(cb_hold, sc)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Block in X axis")
    ck.callback_changed_add(cb_block, sc, ELM_SCROLLER_MOVEMENT_BLOCK_HORIZONTAL)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Block in Y axis")
    ck.callback_changed_add(cb_block, sc, ELM_SCROLLER_MOVEMENT_BLOCK_VERTICAL)
    box.pack_end(ck)
    ck.show()
    
    ck = Check(box, text="Snap to pages")
    ck.callback_changed_add(cb_snap, sc)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Loop in X axis")
    ck.callback_changed_add(cb_loop_h, sc)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Loop in Y axis")
    ck.callback_changed_add(cb_loop_v, sc)
    box.pack_end(ck)
    ck.show()

    ck = Check(box, text="Wheel disabled")
    ck.callback_changed_add(cb_wheel_disabled, sc)
    box.pack_end(ck)
    ck.show()

    bt = Button(win, text="to 300 300", size_hint_expand=EXPAND_BOTH,
                size_hint_align=(0.1, 0.1))
    bt.callback_clicked_add(my_scroller_go_300_300, sc)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="to 900 300", size_hint_expand=EXPAND_BOTH,
                size_hint_align=(0.9, 0.1))
    bt.callback_clicked_add(my_scroller_go_900_300, sc)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="to 300 900", size_hint_expand=EXPAND_BOTH,
                size_hint_align=(0.1, 0.9))
    bt.callback_clicked_add(my_scroller_go_300_900, sc)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="to 900 900", size_hint_expand=EXPAND_BOTH,
                size_hint_align=(0.9, 0.9))
    bt.callback_clicked_add(my_scroller_go_900_900, sc)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    win.show()


if __name__ == "__main__":

    scroller_clicked(None)

    elementary.run()
