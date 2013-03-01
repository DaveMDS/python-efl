#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.notify import Notify
from efl.elementary.table import Table


def notify_close(bt, notify):
    notify.hide()

def notify_show(bt, win, orient):
    notify = Notify(win)
    notify.repeat_events_set(False)
    notify.timeout_set(5)
    notify.orient_set(orient)

    bx = Box(win)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.horizontal_set(True)
    notify.content_set(bx)
    bx.show()

    lb = Label(win)
    lb.text_set("Text notification")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win)
    bt.text_set("Close")
    bt.callback_clicked_add(notify_close, notify)
    bx.pack_end(bt)
    bt.show()
    notify.show()

def notify_clicked(obj):
    win = Window("notify", elementary.ELM_WIN_BASIC)
    win.title_set("Notify test")
    win.autodel_set(True)
    win.size_hint_min_set(160, 160)
    win.size_hint_max_set(320, 320)
    win.resize(320, 320)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    tb = Table(win)
    tb.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win)
    bt.text_set("Top")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_TOP)
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Center")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_CENTER)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Bottom")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_BOTTOM)
    tb.pack(bt, 1, 2, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Left")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_LEFT)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Top Left")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_TOP_LEFT)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Bottom Left")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_BOTTOM_LEFT)
    tb.pack(bt, 0, 2, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Right")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_RIGHT)
    tb.pack(bt, 2, 1, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Top Right")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_TOP_RIGHT)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    bt = Button(win)
    bt.text_set("Bottom Right")
    bt.callback_clicked_add(notify_show, win, elementary.ELM_NOTIFY_ORIENT_BOTTOM_RIGHT)
    tb.pack(bt, 2, 2, 1, 1)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    notify_clicked(None)

    elementary.run()
    elementary.shutdown()
