#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.notify import Notify, ELM_NOTIFY_ORIENT_TOP, \
    ELM_NOTIFY_ORIENT_CENTER, ELM_NOTIFY_ORIENT_BOTTOM, \
    ELM_NOTIFY_ORIENT_LEFT, ELM_NOTIFY_ORIENT_RIGHT, \
    ELM_NOTIFY_ORIENT_TOP_LEFT, ELM_NOTIFY_ORIENT_TOP_RIGHT, \
    ELM_NOTIFY_ORIENT_BOTTOM_LEFT, ELM_NOTIFY_ORIENT_BOTTOM_RIGHT
from efl.elementary.table import Table

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

def notify_close(bt, notify):
    notify.hide()

def notify_show(bt, win, orient):
    notify = Notify(win, repeat_events=False, timeout=5, orient=orient)

    bx = Box(win, size_hint_weight=EXPAND_BOTH, horizontal=True)
    notify.content_set(bx)
    bx.show()

    lb = Label(win, text="Text notification")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(notify_close, notify)
    bx.pack_end(bt)
    bt.show()
    notify.show()

def notify_clicked(obj):
    win = StandardWindow("notify", "Notify test", autodel=True, size=(320, 320),
        size_hint_min=(160, 160), size_hint_max=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="Top")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_TOP)
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Center")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_CENTER)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    bt = Button(win, text="Bottom")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_BOTTOM)
    tb.pack(bt, 1, 2, 1, 1)
    bt.show()

    bt = Button(win, text="Left")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_LEFT)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="Top Left")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_TOP_LEFT)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Bottom Left")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_BOTTOM_LEFT)
    tb.pack(bt, 0, 2, 1, 1)
    bt.show()

    bt = Button(win, text="Right")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_RIGHT)
    tb.pack(bt, 2, 1, 1, 1)
    bt.show()

    bt = Button(win, text="Top Right")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_TOP_RIGHT)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Bottom Right")
    bt.callback_clicked_add(notify_show, win, ELM_NOTIFY_ORIENT_BOTTOM_RIGHT)
    tb.pack(bt, 2, 2, 1, 1)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    notify_clicked(None)

    elementary.run()
    elementary.shutdown()
