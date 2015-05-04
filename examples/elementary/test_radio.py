#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EXPAND_BOTH, FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.radio import Radio


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def radio_clicked(obj):
    win = StandardWindow("radio", "Radio test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    rd = Radio(win, state_value=0, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, text="Icon sized to radio", content=ic)
    bx.pack_end(rd)
    rd.show()
    ic.show()
    rdg = rd

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    rd = Radio(win, state_value=1, text="Icon no scale", content=ic)
    rd.group_add(rdg)
    bx.pack_end(rd)
    rd.show()
    ic.show()

    rd = Radio(win, state_value=2, text="Label Only")
    rd.group_add(rdg)
    bx.pack_end(rd)
    rd.show()

    rd = Radio(win, state_value=3, text="Disabled", disabled=True)
    rd.group_add(rdg)
    bx.pack_end(rd)
    rd.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    rd = Radio(win, state_value=4, content=ic)
    rd.group_add(rdg)
    bx.pack_end(rd)
    rd.show()
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    rd = Radio(win, state_value=5, content=ic, disabled=True)
    rd.group_add(rdg)
    bx.pack_end(rd)
    rd.show()
    ic.show()

    rdg.value = 2

    win.show()


if __name__ == "__main__":

    radio_clicked(None)

    elementary.run()
