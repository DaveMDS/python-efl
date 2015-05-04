#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.button import Button
from efl.elementary.layout import Layout


script_path = os.path.dirname(os.path.abspath(__file__))

def _event(*args, **kargs):
    print((args, kargs))

def layout_clicked(obj):
    win = StandardWindow("layout", "Layout", autodel=True)
    win.elm_event_callback_add(_event)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(os.path.join(script_path, "test.edj"), "layout"),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()
    print(ly.file)
    print(ly.file_get())

    bt = Button(win, text="Button 1")
    ly.part_content_set("element1", bt)
    bt.elm_event_callback_add(_event)
    bt.elm_event_callback_del(_event)
    bt.show()

    bt = Button(win, text="Button 2")
    ly.part_content_set("element2", bt)
    bt.show()

    bt = Button(win, text="Button 3")
    ly.part_content_set("element3", bt)
    bt.show()

    for o in ly.content_swallow_list_get():
        print("Swallowed: " + str(o))

    win.show()


if __name__ == "__main__":

    layout_clicked(None)

    elementary.run()
