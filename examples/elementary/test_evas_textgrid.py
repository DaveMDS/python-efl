#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl.evas import Textgrid, EVAS_TEXTGRID_PALETTE_STANDARD
from efl import elementary
from efl.elementary.window import StandardWindow

if "unichr" not in dir(__builtins__):
    unichr = chr


def evas_textgrid_clicked(obj, item=None):
    win = StandardWindow(
        "evastextgrid", "Evas Textgrid Test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    W = 80
    H = 26

    tg = Textgrid(
        win.evas, size_hint_weight=(1.0, 1.0), size=(W, H),
        font=("monospace", 14))
    win.resize_object_add(tg)
    tg.palette_set(EVAS_TEXTGRID_PALETTE_STANDARD, 0, 0, 0, 0, 255)

    win.size_step = tg.cell_size

    # XXX: Add 1 to size, else the last row/col won't fit. Unknown reason.
    win.size = (W * tg.cell_size[0] + 1, H * tg.cell_size[1] + 1)

    for i in range(H):
        ci = i + 1
        cv = ci * 9
        tg.palette_set(
            EVAS_TEXTGRID_PALETTE_STANDARD, ci, cv, cv, cv, 255)
        row = tg.cellrow_get(i)
        if row is not None:
            for cell in row:
                cell.codepoint = unichr(1000 + i)
                cell.bg = 0
                cell.fg = ci
            tg.cellrow_set(i, row)

    tg.show()
    tg.update_add(0, 0, 80, 26)

    win.show()


if __name__ == "__main__":
    evas.init()

    evas_textgrid_clicked(None)

    elementary.run()
    evas.shutdown()
