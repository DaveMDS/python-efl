#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL
EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
from efl import elementary as elm
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.icon import Icon
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.bubble import Bubble, ELM_BUBBLE_POS_TOP_LEFT, \
    ELM_BUBBLE_POS_TOP_RIGHT, ELM_BUBBLE_POS_BOTTOM_LEFT, \
    ELM_BUBBLE_POS_BOTTOM_RIGHT

def bubble_clicked(obj, item=None):
    win = Window("bubble", ELM_WIN_BASIC)
    win.title_set("Bubble")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = EXPAND_BOTH
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight = EXPAND_BOTH
    bx.show()

    # bb 1
    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)

    lb = Label(win)
    lb.text_set("Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 1", content = lb,
        pos = ELM_BUBBLE_POS_TOP_LEFT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: top_left")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    # bb 2
    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)

    lb = Label(win)
    lb.text_set("Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 2", content = lb,
        pos = ELM_BUBBLE_POS_TOP_RIGHT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: top_right")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    # bb 3
    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)

    lb = Label(win)
    lb.text_set("Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 3", content = ic,
        pos = ELM_BUBBLE_POS_BOTTOM_LEFT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: bottom_left")
    bx.pack_end(bb)
    bb.show()

    # bb 4
    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)

    lb = Label(win)
    lb.text_set("Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 4", content = lb,
        pos = ELM_BUBBLE_POS_BOTTOM_RIGHT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: bottom_right")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    def destroy(obj):
        elm.exit()

    elm.init()
    win = Window("test", ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = EXPAND_BOTH
    bg.show()

    box0 = Box(win)
    box0.size_hint_weight = EXPAND_BOTH
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

    items = [("Bubble", bubble_clicked),
            ]

    li = List(win)
    li.size_hint_weight = EXPAND_BOTH
    li.size_hint_align = FILL_BOTH
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elm.run()
    elm.shutdown()

