#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.panel import Panel, ELM_PANEL_ORIENT_LEFT

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_VERT = 0.0, EVAS_HINT_EXPAND
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_VERT_ALIGN_LEFT = 0.0, EVAS_HINT_FILL

def panel_clicked(obj):
    win = StandardWindow("panel", "Panel test", autodel=True, size=(300, 300))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bt = Button(win, text="HIDE ME :)", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    bt.show()

    panel = Panel(win, orient=ELM_PANEL_ORIENT_LEFT, content=bt,
        size_hint_weight=EXPAND_VERT, size_hint_align=FILL_VERT_ALIGN_LEFT)

    bx.pack_end(panel)
    panel.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    panel_clicked(None)

    elementary.run()
    elementary.shutdown()

