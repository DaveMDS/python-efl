#!/usr/bin/env python
# encoding: utf-8


from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.frame import Frame
from efl.elementary.clock import Clock
from efl.elementary.entry import Entry
from efl.elementary.toolbar import Toolbar

def cursor_clicked(obj, item=None):
    win = Window("cursors", elementary.ELM_WIN_BASIC)
    win.title_set("Cursors")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    ck = Clock(win)
    ck.cursor_set("clock")
    bx.pack_end(ck)
    ck.show()

    bt = Button(win)
    bt.text_set("Coffee Mug")
    bt.cursor_set("coffee_mug")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Cursor unset")
    bt.cursor_set("bogosity")
    bt.cursor_unset()
    bx.pack_end(bt)
    bt.show()

    lst = List(win)
    lst.item_append("watch over list")
    lst.item_append("watch over list")
    lst.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    lst.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    lst.cursor_set("watch")
    bx.pack_end(lst)
    lst.go()
    lst.show()

    en = Entry(win)
    en.scrollable_set(True)
    en.single_line_set(True)
    en.entry_set("Xterm cursor")
    en.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    en.size_hint_align_set(evas.EVAS_HINT_FILL, 0.5)
    en.cursor_set("xterm")
    bx.pack_end(en)
    en.show()

    win.resize(320, 480)
    win.show()


def cursor2_clicked(obj, item=None):
    win = Window("cursors", elementary.ELM_WIN_BASIC)
    win.title_set("Cursors 2")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    tb = Toolbar(win)
    ti = tb.item_append("folder-new", "Bogosity", None, None)
    ti.cursor_set("bogosity")
    ti = tb.item_append("clock", "Unset", None, None)
    ti.cursor_unset()
    ti = tb.item_append("document-print", "Xterm", None, None)
    ti.cursor_set("xterm")
    tb.size_hint_weight_set(0.0, 0.0)
    tb.size_hint_align_set(evas.EVAS_HINT_FILL, 0.0)
    bx.pack_end(tb)
    tb.show()

    lst = List(win)
    li = lst.item_append("cursor bogosity")
    li.cursor_set("bogosity")
    li = lst.item_append("cursor unset")
    li.cursor_unset()
    li = lst.item_append("cursor xterm")
    li.cursor_set("xterm")
    lst.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    lst.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bx.pack_end(lst)
    lst.go()
    lst.show()

    win.resize(320, 480)
    win.show()


def cursor3_clicked(obj, item=None):
    win = Window("cursors", elementary.ELM_WIN_BASIC)
    win.title_set("Cursors 3")
    win.autodel_set(True)

    elementary.theme_extension_add("./cursors.edj")
    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    bt = Button(win)
    bt.text_set("hand1")
    bt.cursor_set("hand1")
    bt.cursor_theme_search_enabled_set(False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("hand2 x")
    bt.cursor_set("hand2")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("hand2")
    bt.cursor_set("hand2")
    bt.cursor_theme_search_enabled_set(False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("hand3")
    bt.cursor_set("hand3")
    bt.cursor_theme_search_enabled_set(False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("hand3")
    bt.cursor_set("hand3")
    bt.cursor_theme_search_enabled_set(False)
    bt.cursor_style_set("transparent")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("not existent")
    bt.cursor_set("hand4")
    bt.cursor_theme_search_enabled_set(False)
    bx.pack_end(bt)
    bt.show()

    elementary.cursor_engine_only_set(False)
    bt = Button(win)
    bt.text_set("hand 2 engine only config false")
    bt.cursor_set("hand2")
    bx.pack_end(bt)
    bt.show()

    elementary.cursor_engine_only_set(True)
    bt = Button(win)
    bt.text_set("hand 2 engine only config true")
    bt.cursor_set("hand2")
    bx.pack_end(bt)
    bt.show()

    lst = List(win)
    li = lst.item_append("cursor hand2 x")
    li.cursor_set("hand2")
    li = lst.item_append("cursor hand2")
    li.cursor_set("hand2")
    li.cursor_engine_only_set(False)
    li = lst.item_append("cursor hand3")
    li.cursor_set("hand3")
    li.cursor_engine_only_set(False)
    li = lst.item_append("cursor hand3 transparent")
    li.cursor_set("hand3")
    bt.cursor_style_set("transparent")
    li.cursor_engine_only_set(False)
    lst.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    lst.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bx.pack_end(lst)
    lst.go()
    lst.show()

    win.resize(320, 480)
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

    items = [("Cursor", cursor_clicked),
             ("Cursor 2", cursor2_clicked),
             ("Cursor 3", cursor3_clicked)]

    li = List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320, 480)
    win.show()
    elementary.run()
    elementary.shutdown()

