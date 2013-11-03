#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.button import Button
from efl.elementary.table import Table

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

def table_clicked(obj):
    win = StandardWindow("table", "Table", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="Button 1", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 2", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 3", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 4", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 1, 2, 1)
    bt.show()

    bt = Button(win, text="Button 5", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 2, 1, 1, 3)
    bt.show()

    bt = Button(win, text="Button 6", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 2, 2, 2)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    table_clicked(None)

    elementary.run()
    elementary.shutdown()
