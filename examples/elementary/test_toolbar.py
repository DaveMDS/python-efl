#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.photo import Photo
from efl.elementary.table import Table
from efl.elementary.toolbar import Toolbar, ELM_TOOLBAR_SHRINK_MENU, \
    ELM_OBJECT_SELECT_MODE_NONE
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List

ALIGN_CENTER = 0.5, 0.5

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def tb_1(obj, it, ph):
    ph.file = os.path.join(img_path, "panel_01.jpg")

def tb_2(obj, it, ph):
    ph.file = os.path.join(img_path, "rock_01.jpg")

def tb_3(obj, it, ph):
    ph.file = os.path.join(img_path, "wood_01.jpg")

def tb_3a(obj, it, ph):
    tb_3(obj, it, ph)
    it.state = it.state_next()

def tb_3b(obj, it, ph):
    tb_3(obj, it, ph)
    del it.state

def tb_4(obj, it, ph):
    ph.file = os.path.join(img_path, "sky_03.jpg")

def tb_4a(obj, it, ph):
    it.state = it.state_prev()

def tb_5(obj, it, ph):
    ph.file = None

def cb_clicked(tb, it):
    print("CLICKED")
    print(tb)
    print(it)

def cb_item_focused(tb, item):
    print("ITEM FOCUSED")
    print(tb)
    print(item)

def cb_selected(tb, item):
    print("SELECTED")
    print(tb)
    print(item)

def toolbar_clicked(obj, item=None):
    win = StandardWindow("toolbar", "Toolbar", autodel=True, size=(320, 300))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    tbl = Table(win, size_hint_weight=(0.0, EVAS_HINT_EXPAND),
        size_hint_align=FILL_BOTH)

    tb = Toolbar(win, homogeneous=False, size_hint_weight=(0.0, 0.0),
        size_hint_align=(EVAS_HINT_FILL, 0.0))
    tb.callback_clicked_add(cb_clicked)
    tb.callback_selected_add(cb_selected)
    tb.callback_item_focused_add(cb_item_focused)

    ph1 = Photo(win, size=40, file=os.path.join(img_path, "plant_01.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph1, 0, 0, 1, 1)
    ph1.show()

    ph2 = Photo(win, size=80, size_hint_weight=EXPAND_BOTH,
        size_hint_align=ALIGN_CENTER)
    tbl.pack(ph2, 1, 0, 1, 1)
    ph2.show()

    ph3 = Photo(win, size=40, file=os.path.join(img_path, "sky_01.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph3, 0, 1, 1, 1)
    ph3.show()

    ph4 = Photo(win, size=60, file=os.path.join(img_path, "sky_02.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph4, 1, 1, 1, 1)
    ph4.show()

    item = tb.item_append("document-print", "Hello", tb_1)
    item.disabled = True

    item = tb.item_append("document-open", "World,", tb_2, ph2)
    item.selected = True

    tb.item_append("folder-new", "here", tb_3, ph4)
    tb.item_append("document-save", "comes", tb_4, ph4)
    tb.item_append("document-send", "python-elementary!", tb_5, ph4)

    item = tb.item_append("go-down", "Menu", tb_5, ph4)
    item.menu = True
    tb.menu_parent = win

    menu = item.menu

    menu.item_add(None, "Here", "folder", tb_3, ph4)
    menu_item = menu.item_add(None, "Comes", "view-refresh", tb_4, ph4)
    menu.item_add(menu_item, "hey ho", "folder-new", tb_4, ph4)
    menu.item_add(None, "python-elementary", "document-print", tb_5, ph4)

    bx.pack_end(tb)
    tb.show()

    bx.pack_end(tbl)
    tbl.show()

    win.show()


# Toolbar with multiple state buttons
def toolbar5_clicked(obj, item=None):
    win = StandardWindow("toolbar5", "Toolbar 5", autodel=True, size=(320, 300))
    win.autodel = True

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    tbl = Table(win, size_hint_weight=(0.0, EVAS_HINT_EXPAND),
        size_hint_align=FILL_BOTH)

    tb = Toolbar(win, homogeneous=False, shrink_mode=ELM_TOOLBAR_SHRINK_MENU,
        size_hint_weight=(0.0, 0.0), size_hint_align=(EVAS_HINT_FILL, 0.0),
        select_mode=ELM_OBJECT_SELECT_MODE_NONE)

    ph1 = Photo(win, size=40, file=os.path.join(img_path, "plant_01.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph1, 0, 0, 1, 1)
    ph1.show()

    ph2 = Photo(win, size=80, size_hint_weight=EXPAND_BOTH,
        size_hint_align=ALIGN_CENTER)
    tbl.pack(ph2, 1, 0, 1, 1)
    ph2.show()

    ph3 = Photo(win, size=20, file=os.path.join(img_path, "sky_01.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph3, 0, 1, 1, 1)
    ph3.show()

    ph4 = Photo(win, size=60, file=os.path.join(img_path, "sky_02.jpg"),
        size_hint_weight=EXPAND_BOTH, size_hint_align=ALIGN_CENTER)
    tbl.pack(ph4, 1, 1, 1, 1)
    ph4.show()

    tb_it = tb.item_append("document-print", "Hello", tb_1, ph1)
    tb_it.disabled = True
    tb_it.priority = 100

    tb_it = tb.item_append(os.path.join(img_path, "icon_04.png"),
        "World", tb_2, ph1)
    tb_it.priority = -100

    tb_it = tb.item_append("object-rotate-right", "H", tb_3a, ph4)
    tb_it.state_add("object-rotate-left", "H2", tb_3b, ph4)
    tb_it.priority = 150

    tb_it = tb.item_append("object-rotate-left", "Comes", tb_4a, ph4)
    tb_it.state_add("emptytrash", "Comes2", tb_4a, ph4)
    tb_it.state_add("trashcan_full", "Comes3", tb_4a, ph4)
    tb_it.priority = 0

    tb_it = tb.item_append("user-trash", "Elementary", tb_5, ph4)
    tb_it.priority = -200

    tb_it = tb.item_append("view-refresh", "Menu")
    tb_it.menu = True
    tb_it.priority = -9999
    tb.menu_parent = win
    menu = tb_it.menu

    menu.item_add(None, "edit-cut", "Shrink", tb_3, ph4)
    menu_it = menu.item_add(None, "edit-copy", "Mode", tb_4, ph4)
    menu.item_add(menu_it, "edit-paste", "is set to", tb_4, ph4)
    menu.item_add(None, "edit-delete", "Menu", tb_5, ph4)

    bx.pack_end(tb)
    tb.show()

    bx.pack_end(tbl)
    tbl.show()

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

    items = [
        ("Toolbar", toolbar_clicked),
        ("Toolbar Item States", toolbar5_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
