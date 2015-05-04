#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow, Window, ELM_WIN_BASIC
from efl.elementary.background import Background, ELM_BG_OPTION_SCALE
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "plant_01.jpg")

def bg_plain_clicked(obj, item=None):
    win = Window("bg plain", ELM_WIN_BASIC, title="Bg Plain", autodel=True,
        size=(320, 320))

    bg = Background(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    win.show()


def bg_image_clicked(obj, item=None):
    win = Window("bg-image", ELM_WIN_BASIC, title="Bg Image", autodel=True,
        size=(320, 320), size_hint_min=(160, 160), size_hint_max=(320,320))

    bg = Background(win, file=ic_file, option=ELM_BG_OPTION_SCALE,
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    win.show()

    (filename, group) = bg.file_get()
    print(("Background image: '%s'  group: '%s'" % (filename, group)))
    print(("Option: %d" % (bg.option_get())))


if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application", size=(320,520))
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

    items = [("Bg Plain", bg_plain_clicked),
             ("Bg Image", bg_image_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()

