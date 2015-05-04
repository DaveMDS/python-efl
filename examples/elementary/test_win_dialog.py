#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow, DialogWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label


def clicked_cb(btn, parent):
    dia = DialogWindow(parent, "window-dia", "DialogWindow",
                       size=(200,150), autodel=True)

    lb = Label(dia, text="This is a DialogWindow",
               size_hint_weight=EXPAND_BOTH)
    dia.resize_object_add(lb)
    lb.show()

    dia.show()

def window_dialog_clicked(obj):
    win = StandardWindow("window-states", "This is a StandardWindow",
                         autodel=True, size=(400, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()
    
    bt = Button(win, text="Create a new dialog")
    bt.callback_clicked_add(clicked_cb, win)
    box.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    window_dialog_clicked(None)

    elementary.run()

