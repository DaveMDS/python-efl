#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.check import Check
from efl.elementary.list import List
from efl.elementary.icon import Icon


def aspect_fixed_cb(obj, ic):
    ic.aspect_fixed_set(obj.state_get())

def fill_outside_cb(obj, ic):
    ic.fill_outside_set(obj.state_get())

def smooth_cb(obj, ic):
    ic.smooth_set(obj.state_get())

def bt_clicked(obj):
    win = Window("preload-prescale", elementary.ELM_WIN_BASIC)
    win.title_set("Preload & Prescale")
    win.autodel_set(True)

    bg = Background(win)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(bg)
    bg.show()

    ic = Icon(win)
    win.resize_object_add(ic)
    ic.file_set("images/insanely_huge_test_image.jpg")

    ic.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    ic.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    ic.resizable_set(True, True)
    ic.aspect_fixed_set(True)
    ic.preload_disabled_set(True)
    ic.prescale_set(True)
    ic.show()

    win.resize(350, 350)
    win.show()


def icon_clicked(obj, item=None):
    win = Window("icon test", elementary.ELM_WIN_BASIC)
    win.title_set("Icon Test")
    win.autodel_set(True)

    bg = Background(win)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(bg)
    bg.show()

    box = Box(win)
    win.resize_object_add(box)
    box.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    box.show()

    content_box = Box(win)
    win.resize_object_add(content_box)
    content_box.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    content_box.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box.pack_end(content_box)
    content_box.show()

    ic = Icon(win)
    ic.file_set("images/logo.png")
    ic.resizable_set(True, True)
    ic.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    ic.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)

    content_box.pack_end(ic)
    ic.show()

    hbox = Box(win)
    hbox.horizontal_set(True)
    content_box.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    box.pack_end(hbox)
    hbox.show()

    # Test Aspect Fixed
    tg = Check(win)
    tg.text_set("Aspect Fixed")
    tg.state_set(True)
    tg.callback_changed_add(aspect_fixed_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Fill Outside
    tg = Check(win)
    tg.text_set("Fill Outside")
    tg.callback_changed_add(fill_outside_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Smooth
    tg = Check(win)
    tg.text_set("Smooth")
    tg.state_set(True)
    tg.callback_changed_add(smooth_cb, ic)
    hbox.pack_end(tg)
    tg.show()

    # Test Preload, Prescale
    bt = Button(win)
    bt.text_set("Preload & Prescale")
    bt.callback_clicked_add(bt_clicked)
    hbox.pack_end(bt)
    bt.show()

    win.resize(400, 400)
    win.show()


def icon_transparent_clicked(obj, item=None):
    win = Window("icon-transparent", elementary.ELM_WIN_BASIC)
    win.title_set("Icon Transparent")
    win.autodel_set(True)
    win.alpha_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    icon = Icon(win)
    icon.file_set("images/logo.png")
    icon.resizable_set(0, 0)
    win.resize_object_add(icon)
    icon.show()

    win.show()


if __name__ == "__main__":
    def destroy(obj):
        elementary.exit()

    elementary.init()
    win = Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [("Icon", icon_clicked),
             ("Icon transparent", icon_transparent_clicked)]

    li = List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
