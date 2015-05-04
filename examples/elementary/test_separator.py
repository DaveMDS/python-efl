#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.separator import Separator


def separator_clicked(obj):
    win = StandardWindow("separators", "Separators", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx0 = Box(win, size_hint_weight=EXPAND_BOTH, horizontal=True)
    win.resize_object_add(bx0)
    bx0.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    bx0.pack_end(bx)
    bx.show()

    bt = Button(win, text="Left upper corner")
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win, horizontal=True)
    bx.pack_end(sp)
    sp.show()

    bt = Button(win, text="Left lower corner", disabled=True)
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win)
    bx0.pack_end(sp)
    sp.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    bx0.pack_end(bx)
    bx.show()

    bt = Button(win, text="Right upper corner", disabled=True)
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win, horizontal=True)
    bx.pack_end(sp)
    sp.show()

    bt = Button(win, text="Right lower corner")
    bx.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    separator_clicked(None)

    elementary.run()
