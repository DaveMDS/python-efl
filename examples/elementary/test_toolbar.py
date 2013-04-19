#!/usr/bin/env python
# encoding: utf-8

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

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL


def tb_1(obj, it, ph):
    ph.file = "images/panel_01.jpg"

def tb_2(obj, it, ph):
    ph.file = "images/rock_01.jpg"

def tb_3(obj, it, ph):
    ph.file = "images/wood_01.jpg"

def tb_3a(obj, it, ph):
    tb_3(obj, it, ph)
    it.state = it.state_next()

def tb_3b(obj, it, ph):
    tb_3(obj, it, ph)
    del it.state

def tb_4(obj, it, ph):
    ph.file = "images/sky_03.jpg"

def tb_4a(obj, it, ph):
    it.state = it.state_prev()

def tb_5(obj, it, ph):
    ph.file = None

def toolbar_clicked(obj, item=None):
    win = StandardWindow("toolbar", "Toolbar")
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bx.show()

    tb = Toolbar(win)
    tb.homogeneous = False
    tb.size_hint_weight = 0.0, 0.0
    tb.size_hint_align = EVAS_HINT_FILL, 0.0

    ph1 = Photo(win)
    ph2 = Photo(win)
    ph3 = Photo(win)
    ph4 = Photo(win)

    item = tb.item_append("document-print", "Hello", tb_1)
    item.disabled = True

    item = tb.item_append("clock", "World,", tb_2, ph2)
    item.selected = True

    tb.item_append("folder-new", "here", tb_3, ph4)
    tb.item_append("clock", "comes", tb_4, ph4)
    tb.item_append("folder-new", "python-elementary!", tb_5, ph4)

    item = tb.item_append("clock", "Menu", tb_5, ph4)
    item.menu = True
    tb.menu_parent = win

    menu = item.menu

    menu.item_add(None, "Here", "clock", tb_3, ph4)
    menu_item = menu.item_add(None, "Comes", "refresh", tb_4, ph4)
    menu.item_add(menu_item, "hey ho", "folder-new", tb_4, ph4)
    menu.item_add(None, "python-elementary", "document-print", tb_5, ph4)

    bx.pack_end(tb)
    tb.show()

    tb = Table(win)
    tb.size_hint_weight = 0.0, EVAS_HINT_EXPAND
    tb.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    ph1.size = 40
    ph1.file = "images/plant_01.jpg"
    ph1.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph1.size_hint_align = 0.5, 0.5
    tb.pack(ph1, 0, 0, 1, 1)
    ph1.show()

    ph2.size = 80
    ph2.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph2.size_hint_align = 0.5, 0.5
    tb.pack(ph2, 1, 0, 1, 1)
    ph2.show()

    ph3.size = 40
    ph3.file = "images/sky_01.jpg"
    ph3.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph3.size_hint_align = 0.5, 0.5
    tb.pack(ph3, 0, 1, 1, 1)
    ph3.show()

    ph4.size = 60
    ph4.file = "images/sky_02.jpg"
    ph4.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph4.size_hint_align = 0.5, 0.5
    tb.pack(ph4, 1, 1, 1, 1)
    ph4.show()

    bx.pack_end(tb)
    tb.show()

    win.resize(320, 300)
    win.show()


# Toolbar with multiple state buttons
def toolbar5_clicked(obj, item=None):
    win = StandardWindow("toolbar5", "Toolbar 5")
    win.autodel = True

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(bx)
    bx.show()

    tb = Toolbar(win)
    tb.homogeneous = 0
    tb.shrink_mode = ELM_TOOLBAR_SHRINK_MENU
    tb.size_hint_weight = 0.0, 0.0
    tb.size_hint_align = EVAS_HINT_FILL, 0.0
    tb.select_mode = ELM_OBJECT_SELECT_MODE_NONE

    ph1 = Photo(win)
    ph2 = Photo(win)
    ph3 = Photo(win)
    ph4 = Photo(win)

    tb_it = tb.item_append("document-print", "Hello", tb_1, ph1)
    tb_it.disabled = True
    tb_it.priority = 100

    tb_it = tb.item_append("images/icon_04.png", "World", tb_2, ph1)
    tb_it.priority = -100

    tb_it = tb.item_append("object-rotate-right", "H", tb_3a, ph4)
    tb_it.state_add("object-rotate-left", "H2", tb_3b, ph4)
    tb_it.priority = 150

    tb_it = tb.item_append("mail-send", "Comes", tb_4a, ph4)
    tb_it.state_add("emptytrash", "Comes2", tb_4a, ph4)
    tb_it.state_add("trashcan_full", "Comes3", tb_4a, ph4)
    tb_it.priority = 0

    tb_it = tb.item_append("clock", "Elementary", tb_5, ph4)
    tb_it.priority = -200

    tb_it = tb.item_append("refresh", "Menu")
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

    tb = Table(win)
    tb.size_hint_weight = 0.0, EVAS_HINT_EXPAND
    tb.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    ph = ph1
    ph.size = 40
    ph.file = "images/plant_01.jpg"
    ph.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph.size_hint_align = 0.5, 0.5
    tb.pack(ph, 0, 0, 1, 1)
    ph.show()

    ph = ph2
    ph.size = 80
    ph.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph.size_hint_align = 0.5, 0.5
    tb.pack(ph, 1, 0, 1, 1)
    ph.show()

    ph = ph3
    ph.size = 20
    ph.file = "images/sky_01.jpg"
    ph.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph.size_hint_align = 0.5, 0.5
    tb.pack(ph, 0, 1, 1, 1)
    ph.show()

    ph = ph4
    ph.size = 60
    ph.file = "images/sky_02.jpg"
    ph.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    ph.size_hint_align = 0.5, 0.5
    tb.pack(ph, 1, 1, 1, 1)
    ph.show()

    bx.pack_end(tb)
    tb.show()

    win.size = 320, 300
    win.show()


if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application")
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win)
    box0.size_hint_weight_set(EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
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

    items = [
        ("Toolbar", toolbar_clicked),
        ("Toolbar Item States", toolbar5_clicked),
    ]

    li = List(win)
    li.size_hint_weight_set(EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
    li.size_hint_align_set(EVAS_HINT_FILL, EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
