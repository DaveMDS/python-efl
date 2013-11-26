#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow, Window, ELM_WIN_BASIC
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.check import Check
from efl.elementary.list import List
from efl.elementary.icon import Icon

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def aspect_fixed_cb(obj, ic):
    ic.aspect_fixed = obj.state

def fill_outside_cb(obj, ic):
    ic.fill_outside = obj.state

def smooth_cb(obj, ic):
    ic.smooth = obj.state

def bt_clicked(obj):
    win = StandardWindow("preload-prescale", "Preload & Prescale", autodel=True,
        size=(350, 350))

    ic = Icon(win, file=os.path.join(img_path, "insanely_huge_test_image.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        resizable=(True, True), aspect_fixed=True, preload_disabled=True,
        prescale=True)
    win.resize_object_add(ic)
    ic.show()

    win.show()


def icon_clicked(obj, item=None):
    win = StandardWindow("icon test", "Icon Test", autodel=True,
        size=(400, 400))
    win.show()

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    ic = Icon(box, file=os.path.join(img_path, "logo.png"),
        resizable=(True, True), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    box.pack_end(ic)
    ic.show()

    hbox = Box(box, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    box.pack_end(hbox)
    hbox.show()

    # Test Aspect Fixed
    tg = Check(hbox, text="Aspect Fixed", state=True)
    tg.callback_changed_add(aspect_fixed_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Fill Outside
    tg = Check(hbox, text="Fill Outside")
    tg.callback_changed_add(fill_outside_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Smooth
    tg = Check(hbox, text="Smooth", state=True)
    tg.callback_changed_add(smooth_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Preload, Prescale
    bt = Button(hbox, text="Preload & Prescale")
    bt.callback_clicked_add(bt_clicked)
    hbox.pack_end(bt)
    bt.show()


def icon_transparent_clicked(obj, item=None):
    win = Window("icon-transparent", ELM_WIN_BASIC, title="Icon Transparent",
        autodel=True, alpha=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    icon = Icon(win, file=os.path.join(img_path, "logo.png"),
        resizable=(False, False))
    win.resize_object_add(icon)
    icon.show()

    win.show()


if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Icon", icon_clicked),
             ("Icon transparent", icon_transparent_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
    elementary.shutdown()
