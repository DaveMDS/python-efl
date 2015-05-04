#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.icon import Icon
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.bubble import Bubble, ELM_BUBBLE_POS_TOP_LEFT, \
    ELM_BUBBLE_POS_TOP_RIGHT, ELM_BUBBLE_POS_BOTTOM_LEFT, \
    ELM_BUBBLE_POS_BOTTOM_RIGHT


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo_small.png")

def bubble_clicked(obj, item=None):
    win = StandardWindow("bubble", "Bubble", autodel=True, size=(320,320))

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight = EXPAND_BOTH
    bx.show()

    # bb 1
    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    lb = Label(win, text="Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 1", content = lb,
        pos = ELM_BUBBLE_POS_TOP_LEFT, size_hint_weight = EXPAND_BOTH,
        size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: top_left")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    # bb 2
    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    lb = Label(win, text="Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 2", content = lb,
        pos = ELM_BUBBLE_POS_TOP_RIGHT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: top_right")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    # bb 3
    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    lb = Label(win, text="Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 3", content = ic,
        pos = ELM_BUBBLE_POS_BOTTOM_LEFT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: bottom_left")
    bx.pack_end(bb)
    bb.show()

    # bb 4
    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    lb = Label(win, text="Blah, Blah, Blah")

    bb = Bubble(win, text = "Message 4", content = lb,
        pos = ELM_BUBBLE_POS_BOTTOM_RIGHT,
        size_hint_weight = EXPAND_BOTH, size_hint_align = FILL_BOTH)
    bb.part_text_set("info", "Corner: bottom_right")
    bb.part_content_set("icon", ic)
    bx.pack_end(bb)
    bb.show()

    win.show()


if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda x: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text =   "Please select a test from the list below<br>" \
                "by clicking the test button to show the<br>" \
                "test window."
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Bubble", bubble_clicked),
            ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
