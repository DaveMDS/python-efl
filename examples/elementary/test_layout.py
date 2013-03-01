#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.button import Button
from efl.elementary.layout import Layout


def _event(*args, **kargs):
    print((args, kargs))

def layout_clicked(obj):
    win = Window("layout", elementary.ELM_WIN_BASIC)
    win.title_set("Layout")
    win.elm_event_callback_add(_event)
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    ly = Layout(win)
    ly.file_set("test.edj", "layout")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    bt = Button(win)
    bt.text_set("Button 1")
    ly.part_content_set("element1", bt)
    bt.elm_event_callback_add(_event)
    bt.elm_event_callback_del(_event)
    bt.show()

    bt = Button(win)
    bt.text_set("Button 2")
    ly.part_content_set("element2", bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Button 3")
    ly.part_content_set("element3", bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    layout_clicked(None)

    elementary.run()
    elementary.shutdown()
