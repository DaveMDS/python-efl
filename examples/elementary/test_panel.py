#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.panel import Panel


def panel_clicked(obj):
    win = Window("panel", elementary.ELM_WIN_BASIC)
    win.title_set("Panel test")
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

    panel = Panel(win)
    panel.orient = elementary.ELM_PANEL_ORIENT_LEFT
    panel.size_hint_weight_set(0.0, evas.EVAS_HINT_EXPAND);
    panel.size_hint_align_set(0.0, evas.EVAS_HINT_FILL);

    bt = Button(win)
    bt.text_set("HIDE ME :)")
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND);
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL);
    bt.show()

    panel.content_set(bt)

    bx.pack_end(panel)
    panel.show()

    win.resize(300, 300)
    win.show()


if __name__ == "__main__":
    elementary.init()

    panel_clicked(None)

    elementary.run()
    elementary.shutdown()

