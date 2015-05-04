#!/usr/bin/env python
# encoding: utf-8

import os

from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.separator import Separator
from efl.elementary.button import Button
from efl.elementary.theme import Theme
from efl.evas import EVAS_HINT_FILL, EVAS_HINT_EXPAND


script_path = os.path.dirname(os.path.abspath(__file__))

theme_file = os.path.join(script_path, "test_theme.edj")
th = Theme.default_get()


def add_ext_clicked_cb(obj):
    th.extension_add(theme_file)
    print("Estensions: " + str(th.extension_list))

def del_ext_clicked_cb(obj):
    th.extension_del(theme_file)
    print("Estensions: " + str(th.extension_list))

def add_ovr_clicked_cb(obj):
    th.overlay_add(theme_file)
    print("Overlays: " + str(th.overlay_list))

def del_ovr_clicked_cb(obj):
    th.overlay_del(theme_file)
    print("Overlays: " + str(th.overlay_list))

def theme_clicked(obj, data=None):

    win = StandardWindow("config", "Theme", autodel=True, size=(400,200))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win)
    box.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    box.show()
    win.resize_object_add(box)

    bt = Button(win, text = "A button with a custom style")
    bt.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bt.style = "my_custom_style"
    bt.show()
    box.pack_end(bt)

    bt = Button(win, text = "A button with default style")
    bt.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bt.show()
    box.pack_end(bt)

    sep = Separator(win, horizontal=True)
    sep.show()
    box.pack_end(sep)
    
    hbox = Box(win, horizontal=True)
    hbox.show()
    box.pack_end(hbox)

    bt = Button(win, text = "Add Extension")
    bt.callback_clicked_add(add_ext_clicked_cb)
    bt.show()
    hbox.pack_end(bt)

    bt = Button(win, text = "Remove Extension")
    bt.callback_clicked_add(del_ext_clicked_cb)
    bt.show()
    hbox.pack_end(bt)

    bt = Button(win, text = "Add Overlay")
    bt.callback_clicked_add(add_ovr_clicked_cb)
    bt.show()
    hbox.pack_end(bt)

    bt = Button(win, text = "Remove Overlay")
    bt.callback_clicked_add(del_ovr_clicked_cb)
    bt.show()
    hbox.pack_end(bt)

    win.show()


if __name__ == "__main__":

    theme_clicked(None)

    elementary.run()

