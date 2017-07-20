#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow, Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List, ELM_LIST_LIMIT, ELM_LIST_COMPRESS
from efl.elementary.icon import Icon
from efl.elementary.table import Table


ALIGN_CENTER = 0.5, 0.5

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def my_list_show_it(obj, it):
    it.show()

def list_clicked(obj, item=None):
    win = StandardWindow("list", "List", autodel=True, size=(320, 320))

    li = List(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(li)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(True, True))
    it1 = li.item_append("Hello", ic)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    li.item_append("Hello", ic)
    ic = Icon(win, standard="folder", resizable=(False, False))
    ic2 = Icon(win, standard="user-home", resizable=(False, False))
    li.item_append(".", ic, ic2)

    ic = Icon(win, standard="user-trash", resizable=(False, False))
    ic2 = Icon(win, standard="folder", resizable=(False, False))
    it2 = li.item_append("How", ic, ic2)

    bx = Box(win, horizontal=True)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=ALIGN_CENTER)
    bx.pack_end(ic)
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=(0.5, 0.0))
    bx.pack_end(ic)
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=(0.0, EVAS_HINT_FILL))
    bx.pack_end(ic)
    ic.show()
    li.item_append("are")

    li.item_append("you")
    it3 = li.item_append("doing")
    li.item_append("out")
    li.item_append("there")
    li.item_append("today")
    li.item_append("?")
    it4 = li.item_append("Here")
    li.item_append("are")
    li.item_append("some")
    li.item_append("more")
    li.item_append("items")
    li.item_append("Is this label long enough?")
    it5 = li.item_append("Maybe this one is even longer so we can test long long items.")

    li.go()

    li.show()

    tb2 = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb2)

    bt = Button(win, text="Hello", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.5))
    bt.callback_clicked_add(my_list_show_it, it1)
    tb2.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win, text="How", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.5))
    bt.callback_clicked_add(my_list_show_it, it2)
    tb2.pack(bt, 0, 1, 1, 1)
    bt.show()

    bt = Button(win, text="doing", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.5))
    bt.callback_clicked_add(my_list_show_it, it3)
    tb2.pack(bt, 0, 2, 1, 1)
    bt.show()

    bt = Button(win, text="Here", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.5))
    bt.callback_clicked_add(my_list_show_it, it4)
    tb2.pack(bt, 0, 3, 1, 1)
    bt.show()

    bt = Button(win, text="Maybe this...", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.5))
    bt.callback_clicked_add(my_list_show_it, it5)
    tb2.pack(bt, 0, 4, 1, 1)
    bt.show()

    tb2.show()

    win.show()


def my_list2_clear(bt, li):
    li.clear()

def my_list2_sel(obj, it):
    it = obj.selected_item_get()
    if it is not None:
        it.selected_set(False)

def list2_clicked(obj, item=None):
    win = Window("list-2", ELM_WIN_BASIC, title="List 2",
        autodel=True, size=(320, 320))

    bg = Background(win, file=os.path.join(img_path, "plant_01.jpg"),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    li = List(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH,
        mode=ELM_LIST_LIMIT)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    it = li.item_append("Hello", ic, callback=my_list2_sel)
    it.selected_set(True)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    li.item_append("world", ic)
    ic = Icon(win, standard="folder", resizable=(False, False))
    li.item_append(".", ic)

    ic = Icon(win, standard="user-trash", resizable=(False, False))
    ic2 = Icon(win, standard="go-next", resizable=(False, False))
    it2 = li.item_append("How", ic, ic2)

    bx2 = Box(win, horizontal=True)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=ALIGN_CENTER)
    bx2.pack_end(ic)
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=(0.5, 0.0))
    bx2.pack_end(ic)
    ic.show()

    li.item_append("are", bx2)

    li.item_append("you")
    li.item_append("doing")
    li.item_append("out")
    li.item_append("there")
    li.item_append("today")
    li.item_append("?")
    li.item_append("Here")
    li.item_append("are")
    li.item_append("some")
    li.item_append("more")
    li.item_append("items")
    li.item_append("Longer label.")

    li.go()

    bx.pack_end(li)
    li.show()

    bx2 = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)

    bt = Button(win, text="Clear", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_list2_clear, li)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.show()


def list3_clicked(obj, item=None):
    win = StandardWindow("list-3", "List 3", autodel=True, size=(320, 300))

    li = List(win, size_hint_weight=EXPAND_BOTH, mode=ELM_LIST_COMPRESS)
    win.resize_object_add(li)

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    li.item_append("Hello", ic)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    li.item_append("world", ic)
    ic = Icon(win, standard="folder", resizable=(False, False))
    li.item_append(".", ic)

    ic = Icon(win, standard="window-close", resizable=(False, False))
    ic2 = Icon(win, standard="view-refresh", resizable=(False, False))
    it2 = li.item_append("How", ic, ic2)

    bx = Box(win, horizontal=True)
    bx.horizontal_set(True)

    ic = Icon(win, standard="user-trash", resizable=(False, False),
        size_hint_align=ALIGN_CENTER)
    bx.pack_end(ic)
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=(0.5, 0.0))
    bx.pack_end(ic)
    ic.show()

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size_hint_align=(0.0, EVAS_HINT_FILL))
    bx.pack_end(ic)
    ic.show()

    li.item_append("are", bx)
    li.item_append("you")
    li.item_append("doing")
    li.item_append("out")
    li.item_append("there")
    li.item_append("today")
    li.item_append("?")
    li.item_append("Here")
    li.item_append("are")
    li.item_append("some")
    li.item_append("more")
    li.item_append("items")
    li.item_append("Is this label long enough?")
    it5 = li.item_append("Maybe this one is even longer so we can test long long items.")

    li.go()
    li.show()

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

    items = [("List", list_clicked),
             ("List 2", list2_clicked),
             ("List 3", list3_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
