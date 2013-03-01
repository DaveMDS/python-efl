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
    sp.label_format_set("%1.1f units")
    sp.step_set(1.3)
    sp.wrap_set(1)
    sp.min_max_set(-50.0, 250.0)
    sp.size_hint_align_set(evas.EVAS_HINT_FILL, 0.5)
    sp.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format_set("%1.1f units")
    sp.step_set(1.3)
    sp.wrap_set(1)
    sp.style_set("vertical");
    sp.min_max_set(-50.0, 250.0)
    sp.size_hint_align_set(evas.EVAS_HINT_FILL, 0.5)
    sp.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.pack_end(sp)
    sp.show()

    sp = Spinner(win)
    sp.label_format_set("Disabled %.0f")
    sp.disabled_set(1)
    sp.min_max_set(-50.0, 250.0)
    sp.size_hint_align_set(evas.EVAS_HINT_FILL, 0.5)
    sp.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.pack_end(sp)
    sp.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    spinner_clicked(None)

    elementary.run()
    elementary.shutdown()
