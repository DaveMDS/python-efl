#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.check import Check
from efl.elementary.clock import Clock, ELM_CLOCK_EDIT_HOUR_DECIMAL, \
    ELM_CLOCK_EDIT_MIN_DECIMAL, ELM_CLOCK_EDIT_SEC_DECIMAL


def pause_changed_cb(ck, widgets):
    for w in widgets:
        w.pause = ck.state

def clock_clicked(obj):
    win = StandardWindow("clock", "Clock", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    L = []

    ck = Clock(win)
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    ck = Clock(win, show_am_pm=True)
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    print((ck.time_get()))

    ck = Clock(win, show_seconds=True)
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    ck = Clock(win, show_seconds=True, show_am_pm=True)
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    ck = Clock(win, edit=True, show_seconds=True, show_am_pm=True,
        time=(10, 11, 12))
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    ck = Clock(
        win, edit=True, show_seconds=True, edit_mode = (
            ELM_CLOCK_EDIT_HOUR_DECIMAL |
            ELM_CLOCK_EDIT_MIN_DECIMAL |
            ELM_CLOCK_EDIT_SEC_DECIMAL
            )
        )
    bx.pack_end(ck)
    ck.show()
    L.append(ck)

    hbox = Box(win, horizontal=True)
    bx.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="pause")
    ck.callback_changed_add(pause_changed_cb, L)
    ck.show()
    hbox.pack_end(ck)

    win.show()


if __name__ == "__main__":

    clock_clicked(None)

    elementary.run()

