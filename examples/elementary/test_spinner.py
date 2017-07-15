#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.spinner import Spinner


def spinner_clicked(obj):
    win = StandardWindow("spinner", "Spinner test", autodel=True,
        size=(300, 300))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    sp = Spinner(win, editable=True, label_format="%1.1f units", step=1.3,
        wrap=True, min_max=(-50.0, 250.0), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win, label_format="Base 5.5, Round 2 : %1.1f",
        min_max=(-100.0, 100.0), round=2, base=5.5, value=5.5,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win, label_format="Percentage %%%1.2f something",
        step=5.0, min_max=(0.0, 100.0), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    sp.callback_min_reached_add(lambda o: print("Min reached"))
    sp.callback_max_reached_add(lambda o: print("Max reached"))
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win, label_format="%1.1f units", step=1.3, wrap=True,
        style="vertical", min_max=(-50.0, 250.0), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win, label_format="Disabled %.0f", disabled=True,
        min_max=(-50.0, 250.0), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win, wrap=True, min_max=(1, 12), value=1,
        label_format="%.0f", editable=False, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)

    sp.special_value_add(1, "January")
    sp.special_value_add(2, "February")
    sp.special_value_add(3, "March")
    sp.special_value_add(4, "April")
    sp.special_value_add(5, "May")
    sp.special_value_add(6, "June")
    sp.special_value_add(7, "July")
    sp.special_value_add(8, "August")
    sp.special_value_add(9, "September")
    sp.special_value_add(10, "October")
    sp.special_value_add(11, "November")
    sp.special_value_add(12, "December")

    bx.pack_end(sp)
    sp.show()

    win.show()

if __name__ == "__main__":

    spinner_clicked(None)

    elementary.run()
