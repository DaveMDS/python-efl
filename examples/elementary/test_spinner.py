#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.spinner import Spinner


def spinner_clicked(obj):
    win = Window("spinner", elementary.ELM_WIN_BASIC)
    win.title_set("Spinner test")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(bx)
    bx.show()

    sp = Spinner(win)
    sp.editable = True
    sp.label_format = "%1.1f units"
    sp.step = 1.3
    sp.wrap = True
    sp.min_max = -50.0, 250.0
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format = "Base 5.5, Round 2 : %1.1f"
    sp.min_max = -100.0, 100.0
    sp.round = 2
    sp.base = 5.5
    sp.value = 5.5
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format = "Percentage %%%1.2f something"
    sp.step = 5.0
    sp.min_max = 0.0, 100.0
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format = "%1.1f units"
    sp.step = 1.3
    sp.wrap = True
    sp.style = "vertical"
    sp.min_max = -50.0, 250.0
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format = "Disabled %.0f"
    sp.disabled = True
    sp.min_max = -50.0, 250.0
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.wrap = True
    sp.min_max = 1, 12
    sp.value = 1
    sp.label_format = "%.0f"
    sp.editable = False
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
    sp.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    sp.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(sp)
    sp.show()

    win.resize(300, 300)
    win.show()

if __name__ == "__main__":
    elementary.init()

    spinner_clicked(None)

    elementary.run()
    elementary.shutdown()
