#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, Rectangle, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.label import Label
from efl.elementary.icon import Icon
from efl.elementary.mapbuf import Mapbuf
from efl.elementary.scroller import Scroller, ELM_SCROLLER_POLICY_OFF
from efl.elementary.table import Table

ALIGN_CENTER = 0.5, 0.5

SCROLL_POLICY_OFF = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

names = [ "Hello", "World", "Spam", "Egg", "Ham", "Good", "Bad", "Milk",
          "Smell", "Of", "Sky", "Gold", "Hole", "Pig", "And", "Calm"]

mb_list = []

def cb_btn_close(btn, win):
    win.delete()
    elementary.exit()

def cb_ck_map(ck):
    for mb in mb_list:
        mb.enabled = ck.state

def cb_ck_alpha(ck):
    for mb in mb_list:
        mb.alpha = ck.state

def cb_ck_smooth(ck):
    for mb in mb_list:
        mb.smooth = ck.state

def cb_ck_fs(ck, win):
    win.fullscreen = ck.state

def mapbuf_clicked(obj, item=None):
    global mb_list

    win = Window("mapbuf", ELM_WIN_BASIC, title="Mapbuf test", autodel=True,
        size=(480, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win, file=os.path.join(img_path, "sky_04.jpg"),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    # launcher
    sc = Scroller(win, bounce=(True, False), policy=SCROLL_POLICY_OFF,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sc)

    bx = Box(win, horizontal=True, homogeneous=True)
    bx.show()

    for k in range(8):
        tb = Table(win, size_hint_align=ALIGN_CENTER,
            size_hint_weight=(0.0, 0.0))
        tb.show()

        pad = Rectangle(win.evas, color=(255, 255, 0, 255))
        pad.size_hint_min = (464, 4)
        pad.size_hint_weight = (0.0, 0.0)
        pad.size_hint_align = (EVAS_HINT_FILL, EVAS_HINT_FILL)
        pad.show()
        tb.pack(pad, 1, 0, 5, 1)

        pad = Rectangle(win.evas, color=(255, 255, 0, 255))
        pad.size_hint_min = (464, 4)
        pad.size_hint_weight = (0.0, 0.0)
        pad.size_hint_align = (EVAS_HINT_FILL, EVAS_HINT_FILL)
        pad.show()
        tb.pack(pad, 1, 11, 5, 1)

        pad = Rectangle(win.evas, color=(255, 255, 0, 255))
        pad.size_hint_min = (4, 4)
        pad.size_hint_weight = (0.0, 0.0)
        pad.size_hint_align = (EVAS_HINT_FILL, EVAS_HINT_FILL)
        pad.show()
        tb.pack(pad, 0, 1, 1, 10)

        pad = Rectangle(win.evas, color=(255, 255, 0, 255))
        pad.size_hint_min = (4, 4)
        pad.size_hint_weight = (0.0, 0.0)
        pad.size_hint_align = (EVAS_HINT_FILL, EVAS_HINT_FILL)
        pad.show()
        tb.pack(pad, 6, 1, 1, 10)

        mb = Mapbuf(win, content=tb)
        mb.point_color_set(k % 4, 255, 0, 0, 255)
        mb_list.append(mb)
        bx.pack_end(mb)
        mb.show()

        n = m = 0
        for j in range(5):
            for i in range(5):
                ic = Icon(win, scale=0.5,
                    file=os.path.join(img_path, "icon_%02d.png" % (n)),
                    resizable=(False, False), size_hint_weight=EXPAND_BOTH,
                    size_hint_align=ALIGN_CENTER)
                tb.pack(ic, 1 + i, 1 + (j * 2), 1, 1)
                ic.show()

                lb = Label(win, style="marker", text=names[m])
                tb.pack(lb, 1 + i, 1 + (j * 2) + 1, 1, 1)
                lb.show()

                n = n + 1 if n < 23 else 0
                m = m + 1 if m < 15 else 0

    sc.content = bx
    sc.page_relative_set(1.0, 1.0)
    sc.show()

    # controls
    hbox = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    vbox.pack_start(hbox)
    hbox.show()

    ck = Check(win, text="Map", state=False)
    ck.callback_changed_add(cb_ck_map)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="Alpha", state=True)
    ck.callback_changed_add(cb_ck_alpha)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="Smooth", state=True)
    ck.callback_changed_add(cb_ck_smooth)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="FS", state=False)
    ck.callback_changed_add(cb_ck_fs, win)
    hbox.pack_end(ck)
    ck.show()

    bt = Button(win, text="Close", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_close, win)
    hbox.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    mapbuf_clicked(None)

    elementary.run()
