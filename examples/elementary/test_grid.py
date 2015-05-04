#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH, FILL_BOTH, Rectangle
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.grid import Grid, grid_pack_get, grid_pack_set


def cb_change(bt):
    (x, y, w, h) = grid_pack_get(bt)
    grid_pack_set(bt, x - 2, y - 2, w + 4, h + 4)

def grid_clicked(obj):
    win = StandardWindow("grid", "Grid test", autodel=True, size=(480, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    gd = Grid(win, size=(100, 100), size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gd)
    gd.show()

    en = Entry(win, scrollable=True, text="Entry text 2", single_line=True)
    gd.pack(en, 60, 20, 30, 10)
    en.show()

    bt = Button(win, text="Next API function", disabled=True)
    gd.pack(bt, 30, 0, 40, 10)
    bt.disabled = True
    bt.show()

    bt = Button(win, text="Button")
    gd.pack(bt,  0,  0, 20, 20)
    bt.show()

    bt = Button(win, text="Button")
    gd.pack(bt, 10, 10, 40, 20)
    bt.show()

    bt = Button(win, text="Button")
    gd.pack(bt, 10, 30, 20, 50)
    bt.show()

    bt = Button(win, text="Button")
    gd.pack(bt, 80, 80, 20, 20)
    bt.show()

    bt = Button(win, text="Change")
    bt.callback_clicked_add(cb_change)
    gd.pack(bt, 40, 40, 20, 20)
    bt.show()

    re = Rectangle(win.evas, color=(128, 0, 0, 128))
    gd.pack(re, 40, 70, 20, 10)
    re.show()

    re = Rectangle(win.evas, color=(0, 128, 0, 128))
    gd.pack(re, 60, 70, 10, 10)
    re.show()

    re = Rectangle(win.evas, color=(0, 0, 128, 128))
    gd.pack(re, 40, 80, 10, 10)
    re.show()

    re = Rectangle(win.evas, color=(128, 0, 128, 128))
    gd.pack(re, 50, 80, 10, 10)
    re.show()

    re = Rectangle(win.evas, color=(128, 64, 0, 128))
    gd.pack(re, 60, 80, 10, 10)
    re.show()

    win.show()


if __name__ == "__main__":

    grid_clicked(None)

    elementary.run()
