#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
# from efl.elementary.check import Check
# from efl.elementary.ctxpopup import Ctxpopup
# from efl.elementary.entry import Entry
# from efl.elementary.frame import Frame
# from efl.elementary.flip import Flip
# from efl.elementary.gengrid import Gengrid, GengridItemClass
# from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass
# from efl.elementary.grid import Grid
# from efl.elementary.hover import Hover
# from efl.elementary.hoversel import Hoversel
# from efl.elementary.label import Label
# from efl.elementary.layout import Layout
# from efl.elementary.list import List
# from efl.elementary.icon import Icon
# from efl.elementary.index import Index
# from efl.elementary.innerwindow import InnerWindow
# from efl.elementary.image import Image
# from efl.elementary.map import Map
# from efl.elementary.mapbuf import Mapbuf
# from efl.elementary.menu import Menu
# from efl.elementary.multibuttonentry import MultiButtonEntry
# from efl.elementary.naviframe import Naviframe
# from efl.elementary.notify import Notify
# from efl.elementary.fileselector import Fileselector
# from efl.elementary.fileselector_button import FileselectorButton
# from efl.elementary.fileselector_entry import FileselectorEntry
# from efl.elementary.panel import Panel
# from efl.elementary.panes import Panes
# from efl.elementary.photo import Photo
# from efl.elementary.popup import Popup
# from efl.elementary.progressbar import Progressbar
# from efl.elementary.radio import Radio
# from efl.elementary.scroller import Scroller
# from efl.elementary.segment_control import SegmentControl
from efl.elementary.separator import Separator
# from efl.elementary.slider import Slider
# from efl.elementary.table import Table
# from efl.elementary.flipselector import FlipSelector


def separator_clicked(obj):
    win = Window("separators", elementary.ELM_WIN_BASIC)
    win.title_set("Separators")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx0 = Box(win)
    bx0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx0.horizontal_set(True)
    win.resize_object_add(bx0)
    bx0.show()

    bx = Box(win)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx0.pack_end(bx)
    bx.show()

    bt = Button(win)
    bt.text_set("Left upper corner")
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win)
    sp.horizontal_set(True)
    bx.pack_end(sp)
    sp.show()

    bt = Button(win)
    bt.text_set("Left lower corner")
    bt.disabled_set(True)
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win)
    bx0.pack_end(sp)
    sp.show()

    bx = Box(win)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx0.pack_end(bx)
    bx.show()

    bt = Button(win)
    bt.text_set("Right upper corner")
    bt.disabled_set(True)
    bx.pack_end(bt)
    bt.show()

    sp = Separator(win)
    sp.horizontal_set(True)
    bx.pack_end(sp)
    sp.show()

    bt = Button(win)
    bt.text_set("Right lower corner")
    bx.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    separator_clicked(None)

    elementary.run()
    elementary.shutdown()
