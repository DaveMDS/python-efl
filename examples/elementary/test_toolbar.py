#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.photo import Photo
from efl.elementary.table import Table
from efl.elementary.toolbar import Toolbar


def tb_1(obj, it, ph):
    ph.file = "images/panel_01.jpg"

def tb_2(obj, it, ph):
    ph.file = "images/rock_01.jpg"

def tb_3(obj, it, ph):
    ph.file = "images/wood_01.jpg"

def tb_4(obj, it, ph):
    ph.file = "images/sky_03.jpg"

def tb_5(obj, it, ph):
    ph.file = None

def toolbar_clicked(obj):
    win = Window("toolbar", elementary.ELM_WIN_BASIC)
    win.title = "Toolbar"
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.show()

    tb = Toolbar(win)
    tb.homogeneous = False
    tb.size_hint_weight = 0.0, 0.0
    tb.size_hint_align = evas.EVAS_HINT_FILL, 0.0

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
    tb.size_hint_weight = 0.0, evas.EVAS_HINT_EXPAND
    tb.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL

    ph1.size = 40
    ph1.file = "images/plant_01.jpg"
    ph1.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    ph1.size_hint_align = 0.5, 0.5
    tb.pack(ph1, 0, 0, 1, 1)
    ph1.show()

    ph2.size = 80
    ph2.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    ph2.size_hint_align = 0.5, 0.5
    tb.pack(ph2, 1, 0, 1, 1)
    ph2.show()

    ph3.size = 40
    ph3.file = "images/sky_01.jpg"
    ph3.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    ph3.size_hint_align = 0.5, 0.5
    tb.pack(ph3, 0, 1, 1, 1)
    ph3.show()

    ph4.size = 60
    ph4.file = "images/sky_02.jpg"
    ph4.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    ph4.size_hint_align = 0.5, 0.5
    tb.pack(ph4, 1, 1, 1, 1)
    ph4.show()

    bx.pack_end(tb)
    tb.show()

    win.resize(320, 300)
    win.show()


if __name__ == "__main__":
    elementary.init()

    toolbar_clicked(None)

    elementary.run()
    elementary.shutdown()
