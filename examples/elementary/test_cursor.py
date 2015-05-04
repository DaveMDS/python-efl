#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.frame import Frame
from efl.elementary.clock import Clock
from efl.elementary.entry import Entry
from efl.elementary.toolbar import Toolbar
from efl.elementary.theme import Theme
from efl.elementary.configuration import Configuration


script_path = os.path.dirname(os.path.abspath(__file__))

def cursor_clicked(obj, item=None):
    win = StandardWindow("cursors", "Cursors", autodel=True, size=(320,480))
    win.autodel_set(True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ck = Clock(win, cursor="clock")
    bx.pack_end(ck)
    ck.show()

    bt = Button(win, text="Coffee Mug", cursor="coffee_mug")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Cursor unset", cursor="bogosity")
    bt.cursor_unset()
    bx.pack_end(bt)
    bt.show()

    lst = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        cursor="watch")
    lst.item_append("watch over list")
    lst.item_append("watch over list")
    bx.pack_end(lst)
    lst.go()
    lst.show()

    en = Entry(win, scrollable=True, single_line=True, entry="Xterm cursor",
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ,
        cursor="xterm")
    bx.pack_end(en)
    en.show()

    win.show()


def cursor2_clicked(obj, item=None):
    win = StandardWindow("cursors", "Cursors 2", autodel=True, size=(320, 480))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    tb = Toolbar(win, size_hint_weight=(0.0, 0.0),
        size_hint_align=(EVAS_HINT_FILL, 0.0))
    ti = tb.item_append("folder-new", "Bogosity", None, None)
    ti.cursor_set("bogosity")
    ti = tb.item_append("clock", "Unset", None, None)
    ti.cursor_unset()
    ti = tb.item_append("document-print", "Xterm", None, None)
    ti.cursor_set("xterm")
    bx.pack_end(tb)
    tb.show()

    lst = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    li = lst.item_append("cursor bogosity")
    li.cursor_set("bogosity")
    li = lst.item_append("cursor unset")
    li.cursor_unset()
    li = lst.item_append("cursor xterm")
    li.cursor_set("xterm")
    bx.pack_end(lst)
    lst.go()
    lst.show()

    win.show()


def cursor3_clicked(obj, item=None):
    win = StandardWindow("cursors", "Cursors 3", autodel=True, size=(320, 480))

    conf = Configuration()

    Theme.default_get().extension_add(os.path.join(script_path, "cursors.edj"))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bt = Button(win, text="hand1", cursor="hand1",
        cursor_theme_search_enabled=False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="hand2 x", cursor="hand2")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="hand2", cursor="hand2",
        cursor_theme_search_enabled=False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="hand3", cursor="hand3",
        cursor_theme_search_enabled=False)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="hand3", cursor="hand3",
        cursor_theme_search_enabled=False, cursor_style="transparent")
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="not existent", cursor="hand4",
        cursor_theme_search_enabled=False)
    bx.pack_end(bt)
    bt.show()

    conf.cursor_engine_only = False

    bt = Button(win, text="hand 2 engine only config false", cursor="hand2")
    bx.pack_end(bt)
    bt.show()

    conf.cursor_engine_only = True

    bt = Button(win, text="hand 2 engine only config true", cursor="hand2")
    bx.pack_end(bt)
    bt.show()

    lst = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
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
    li.cursor_style_set("transparent")
    li.cursor_engine_only_set(False)
    bx.pack_end(lst)
    lst.go()
    lst.show()

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

    items = [("Cursor", cursor_clicked),
             ("Cursor 2", cursor2_clicked),
             ("Cursor 3", cursor3_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
