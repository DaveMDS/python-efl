#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.hover import Hover
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.icon import Icon


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def hover_bt1_clicked(bt, hv):
    hv.show()

def hover_clicked(obj, item=None):
    win = StandardWindow("hover", "Hover", autodel=True, size=(320, 320))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    hv = Hover(win)

    bt = Button(win, text="Button")
    bt.callback_clicked_add(hover_bt1_clicked, hv)
    bx.pack_end(bt)
    bt.show()
    hv.target = bt

    bt = Button(win, text="Popup")
    hv.part_content_set("middle", bt)
    bt.show()

    bx = Box(win)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    bx.pack_end(ic)
    ic.show()

    for t in "Top 1", "Top 2", "Top 3":
        bt = Button(win, text=t)
        bx.pack_end(bt)
        bt.show()

    bx.show()

    hv.part_content_set("top", bx)

    bt = Button(win, text="Bottom")
    hv.part_content_set("bottom", bt)
    bt.show()

    bt = Button(win, text="Left")
    hv.part_content_set("left", bt)
    bt.show()

    bt = Button(win, text="Right")
    hv.part_content_set("right", bt)
    bt.show()

    win.show()


def hover2_clicked(obj, item=None):
    win = StandardWindow("hover2", "Hover 2", autodel=True, size=(320, 320))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    hv = Hover(win, style="popout")

    bt = Button(win, text="Button")
    bt.callback_clicked_add(hover_bt1_clicked, hv)
    bx.pack_end(bt)
    bt.show()
    hv.target_set(bt)

    bt = Button(win, text="Popup")
    hv.part_content_set("middle", bt)
    bt.show()

    bx = Box(win)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    bx.pack_end(ic)
    ic.show()

    for t in "Top 1", "Top 2", "Top 3":
        bt = Button(win, text=t)
        bx.pack_end(bt)
        bt.show()

    bx.show()
    hv.part_content_set("top", bx)

    bt = Button(win, text="Bot")
    hv.part_content_set("bottom", bt)
    bt.show()

    bt = Button(win, text="Left")
    hv.part_content_set("left", bt)
    bt.show()

    bt = Button(win, text="Right")
    hv.part_content_set("right", bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Hover", hover_clicked),
             ("Hover 2", hover2_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
