#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.icon import Icon
from efl.elementary.button import Button

def buttons_clicked(obj):
    win = Window("buttons", elementary.ELM_WIN_BASIC)
    win.title_set("Buttons")
    win.focus_highlight_enabled_set(True)
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(evas.EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)
    bt = Button(win)
    bt.text_set("Icon sized to button")
    bt.content_set(ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()

    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.resizable_set(0, 0)
    bt = Button(win)
    bt.text_set("Icon no scale")
    bt.content_set(ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()

    bt = Button(win)
    bt.text_set("No icon")
    bx.pack_end(bt)
    bt.show()

    ic = Icon(win)
    ic.file_set("images/logo_small.png")
    ic.resizable_set(0, 0)
    bt = Button(win)
    bt.content_set(ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    buttons_clicked(None)

    elementary.run()
    elementary.shutdown()

