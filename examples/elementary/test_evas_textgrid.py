#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl.evas import Textgrid, EVAS_TEXTGRID_PALETTE_STANDARD
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background


def evas_textgrid_clicked(obj, item=None):
    win = StandardWindow("evastextgrid", "Evas Textgrid Test", autodel=True,
        size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tg = Textgrid(win.evas)
    tg.size = 15, 1
    tg.size_hint_weight_set(1.0, 1.0)
    win.resize_object_add(tg)
    tg.font = "Courier", 20
    tg.palette_set(EVAS_TEXTGRID_PALETTE_STANDARD, 0, 0, 0, 0, 255)
    tg.palette_set(EVAS_TEXTGRID_PALETTE_STANDARD, 1, 255, 255, 255, 255)

    row = tg.cellrow_get(0)
    for cell in row:
        cell.codepoint="ö"
        cell.fg = 1
        cell.bg = 0
    tg.cellrow_set(0, row)

    tg.show()
    tg.update_add(0, 0, 10, 1)

    rowback = tg.cellrow_get(0)

    win.show()


if __name__ == "__main__":
    evas.init()
    elementary.init()

    evas_textgrid_clicked(None)

    elementary.run()
    elementary.shutdown()
    evas.shutdown()

