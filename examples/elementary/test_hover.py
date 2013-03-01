#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.hover import Hover
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.icon import Icon


def hover_bt1_clicked(bt, hv):
    hv.show()

def hover_clicked(obj, item=None):
    win = Window("hover", elementary.ELM_WIN_BASIC)
    win.title_set("Hover")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    hv = Hover(win)

    bt = Button(win)
    bt.text_set("Button")
    bt.callback_clicked_add(hover_bt1_clicked, hv)
    bx.pack_end(bt)
    bt.show()
    hv.parent_set(win)
    hv.target_set(bt)

    bt = Button(win)
    bt.text_set("Popup")
    hv.part_content_set("middle", bt)
    bt.show()

    bx = Box(win)

    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.resizable_set(0, 0)
    bx.pack_end(ic)
    ic.show()

    bt = Button(win)
    bt.text_set("Top 1")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Top 2")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Top 3")
    bx.pack_end(bt)
    bt.show()

    bx.show()

    hv.part_content_set("top", bx)

    bt = Button(win)
    bt.text_set("Bottom")
    hv.part_content_set("bottom", bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Left")
    hv.part_content_set("left", bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Right")
    hv.part_content_set("right", bt)
    bt.show()

    bg.size_hint_min_set(160, 160)
    bg.size_hint_max_set(640, 640)

    win.resize(320, 320)
    win.show()


def hover2_clicked(obj, item=None):
    win = Window("hover2", elementary.ELM_WIN_BASIC)
    win.title_set("Hover 2")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    hv = Hover(win)
    hv.style_set("popout")

    bt = Button(win)
    bt.text_set("Button")
    bt.callback_clicked_add(hover_bt1_clicked, hv)
    bx.pack_end(bt)
    bt.show()
    hv.parent_set(win)
    hv.target_set(bt)

    bt = Button(win)
    bt.text_set("Popup")
    hv.part_content_set("middle", bt)
    bt.show()

    bx = Box(win)

    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.resizable_set(0, 0)
    bx.pack_end(ic)
    ic.show()

    bt = Button(win)
    bt.text_set("Top 1")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Top 2")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Top 3")
    bx.pack_end(bt)
    bt.show()

    bx.show()
    hv.part_content_set("top", bx)

    bt = Button(win)
    bt.text_set("Bot")
    hv.part_content_set("bottom", bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Left")
    hv.part_content_set("left", bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Right")
    hv.part_content_set("right", bt)
    bt.show()

    bg.size_hint_min_set(160, 160)
    bg.size_hint_max_set(640, 640)
    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    def destroy(obj):
        elementary.exit()

    elementary.init()
    win = Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [("Hover", hover_clicked),
             ("Hover 2", hover2_clicked)]

    li = List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()

