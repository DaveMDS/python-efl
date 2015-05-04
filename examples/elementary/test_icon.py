#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow, Window, ELM_WIN_BASIC
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.check import Check
from efl.elementary.list import List
from efl.elementary.icon import Icon, ELM_ICON_LOOKUP_FDO_THEME, \
    ELM_ICON_LOOKUP_THEME_FDO, ELM_ICON_LOOKUP_THEME, ELM_ICON_LOOKUP_FDO
from efl.elementary.radio import Radio
from efl.elementary.theme import Theme


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


def standard_list_populate(li, order):
    li.clear()
    for group in Theme(default=True).group_base_list_get("elm/icon"):
        name = '/'.join(group.split('/')[2:-1])
        if '-' in name or name == 'folder':
            try:
                ic = Icon(li, standard=name, order_lookup=order,
                          size_hint_min=(32,32))
            except:
                ic = None
            li.item_append(name, ic)
    li.go()

def icon_standard_clicked(obj, item=None):
    win = StandardWindow("icon-standard", "Icon Standard",
                         autodel=True, size=(300,400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())
    
    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    fr = Frame(vbox, text="standard icon order lookup", size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    hbox = Box(fr, horizontal=True)
    fr.content = hbox
    hbox.show()

    li = List(vbox, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    vbox.pack_end(li)
    li.show()

    rdg = Radio(hbox, text="fdo, theme", state_value=ELM_ICON_LOOKUP_FDO_THEME)
    rdg.callback_changed_add(lambda r: standard_list_populate(li, r.state_value))
    hbox.pack_end(rdg)
    rdg.show()

    rd = Radio(hbox, text="theme, fdo", state_value=ELM_ICON_LOOKUP_THEME_FDO)
    rd.group_add(rdg)
    rd.callback_changed_add(lambda r: standard_list_populate(li, r.state_value))
    hbox.pack_end(rd)
    rd.show()

    rd = Radio(hbox, text="fdo only", state_value=ELM_ICON_LOOKUP_FDO)
    rd.group_add(rdg)
    rd.callback_changed_add(lambda r: standard_list_populate(li, r.state_value))
    hbox.pack_end(rd)
    rd.show()

    rd = Radio(hbox, text="theme only", state_value=ELM_ICON_LOOKUP_THEME)
    rd.group_add(rdg)
    rd.callback_changed_add(lambda r: standard_list_populate(li, r.state_value))
    hbox.pack_end(rd)
    rd.show()

    rdg.value = ELM_ICON_LOOKUP_THEME_FDO
    standard_list_populate(li, ELM_ICON_LOOKUP_THEME_FDO)

    win.show()


if __name__ == "__main__":
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
             ("Icon transparent", icon_transparent_clicked),
             ("Icon standard", icon_standard_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
