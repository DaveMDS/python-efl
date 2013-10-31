#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.clock import Clock

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND

def clock_clicked(obj):
    win = StandardWindow("clock", "Clock", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ck = Clock(win)
    bx.pack_end(ck)
    ck.show()

    ck = Clock(win, show_am_pm=True)
    bx.pack_end(ck)
    ck.show()

    print((ck.time_get()))

    ck = Clock(win, show_seconds=True)
    bx.pack_end(ck)
    ck.show()

    ck = Clock(win, show_seconds=True, show_am_pm=True)
    bx.pack_end(ck)
    ck.show()

    ck = Clock(win, edit=True, show_seconds=True, show_am_pm=True,
        time=(10, 11, 12))
    bx.pack_end(ck)
    ck.show()

    ck = Clock(win, edit=True, show_seconds=True, edit_mode = \
        elementary.ELM_CLOCK_EDIT_HOUR_DECIMAL | \
        elementary.ELM_CLOCK_EDIT_MIN_DECIMAL | \
        elementary.ELM_CLOCK_EDIT_SEC_DECIMAL)
    bx.pack_end(ck)
    ck.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    clock_clicked(None)

    elementary.run()
    elementary.shutdown()

