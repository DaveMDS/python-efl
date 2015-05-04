#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH,EVAS_ASPECT_CONTROL_VERTICAL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.icon import Icon
from efl.elementary.button import Button


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo_small.png")

def buttons_clicked(obj):
    win = StandardWindow("buttons", "Buttons", focus_highlight_enabled=True,
        autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ic.show()
    bt = Button(win, text="Icon sized to button", content=ic)
    bx.pack_end(bt)
    bt.show()

    ic = Icon(win, file=ic_file, resizable=(False, False))
    ic.show()
    bt = Button(win, text="Icon no scale", content=ic)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="No icon")
    bx.pack_end(bt)
    bt.show()

    ic = Icon(win, file=ic_file, resizable=(False, False))
    bt = Button(win, content=ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()

    win.show()


if __name__ == "__main__":

    buttons_clicked(None)

    elementary.run()

