#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EXPAND_BOTH, FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.check import Check


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo_small.png")

def ck_1(obj):
    print("test check 1 state: %s" % obj.state)

def ck_2(obj):
    print("test check 2 state: %s" % obj.state)

def ck_never(obj):
    print("disabled check changed (should never happen unless you enable or set it)")

def ck_3(obj):
    print("test check 3 state: %s" % obj.state)

def ck_4(obj):
    print("test check 4 state: %s" % obj.state)

def check_clicked(obj):
    win = StandardWindow("check", "Check test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ic = Icon(win, file=ic_file, size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ck = Check(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ,
        text="Icon sized to check", content=ic, state=True
        )
    ck.callback_changed_add(ck_1)
    bx.pack_end(ck)
    ck.show()
    ic.show()

    ic = Icon(win, file=ic_file, resizable=(0, 0))
    ck = Check(win, text="Icon no scale", content=ic)
    ck.callback_changed_add(ck_2)
    bx.pack_end(ck)
    ck.show()
    ic.show()

    ck = Check(win, text="Label Only")
    ck.callback_changed_add(ck_3)
    bx.pack_end(ck)
    ck.show()

    ic = Icon(win, file=ic_file, size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ck = Check(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ,
        text="Disabled check", content=ic, state=True
        )
    ck.callback_changed_add(ck_never)
    bx.pack_end(ck)
    ck.disabled_set(True)
    ck.show()
    ic.show()

    ic = Icon(win, file=ic_file,
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1), resizable=(0, 0))
    ck = Check(win, content=ic)
    ck.callback_changed_add(ck_4)
    bx.pack_end(ck)
    ck.show()
    ic.show()

    win.show()


if __name__ == "__main__":

    check_clicked(None)

    elementary.run()

