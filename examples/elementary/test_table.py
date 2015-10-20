#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.button import Button
from efl.elementary.table import Table
from efl.elementary.box import Box
from efl.elementary.list import List
from efl.elementary.label import Label
from efl.elementary.frame import Frame
from efl.elementary.slider import Slider


### Table
def table_clicked(obj, item=None):
    win = StandardWindow("table", "Table", autodel=True)

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="Button 1", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 2", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 3", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    bt = Button(win, text="Button 4", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 1, 2, 1)
    bt.show()

    bt = Button(win, text="Button 5", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 2, 1, 1, 3)
    bt.show()

    bt = Button(win, text="Button 6", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 2, 2, 2)
    bt.show()

    win.show()


### Table Homogeneous
def table2_clicked(obj, item=None):
    win = StandardWindow("table2", "Table Homogeneous", autodel=True)

    tb = Table(win, homogeneous=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="A", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 2, 2)
    bt.show()

    bt = Button(win, text="Blah blah blah", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 3, 0, 2, 3)
    bt.show()

    bt = Button(win, text="Hallow", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 3, 10, 1)
    bt.show()

    bt = Button(win, text="B", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 2, 5, 2, 1)
    bt.show()

    bt = Button(win, text="C", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 8, 8, 1, 1)
    bt.show()

    bt = Button(win, text="Wide", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 7, 7, 2)
    bt.show()

    win.show()


### Table Repack
def table3_cb1(obj, win):
    tb = win.data["tb"]
    b2 = win.data["b2"]

    tb.unpack(b2)
    tb.pack(b2, 1, 0, 1, 2)

def table3_cb2(obj, win):
    tb = win.data["tb"]
    b2 = win.data["b2"]

    tb.unpack(b2)
    tb.pack(b2, 1, 0, 1, 1)

def table3_clicked(obj, item=None):
    win = StandardWindow("table3", "Table Repack", autodel=True)

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    win.data["tb"] = tb
    tb.show()

    bt = Button(win, text="Click me", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 0, 1, 1)
    win.data["b1"] = bt
    bt.callback_clicked_add(table3_cb1, win)
    bt.show()

    bt = Button(win, text="Click me", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 0, 1, 1)
    win.data["b2"] = bt
    bt.callback_clicked_add(table3_cb2, win)
    bt.show()

    bt = Button(win, text="Button 3", disabled=True,
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()

    win.show()


### Table Repack 2
def table4_clicked(obj, item=None):
    win = StandardWindow("table4", "Table Repack 2", autodel=True)

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    win.data["tb"] = tb
    tb.show()

    bt = Button(win, text="Click me", size_hint_weight=(0.25, 0.25),
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 0, 1, 1)
    win.data["b1"] = bt
    bt.callback_clicked_add(table3_cb1, win)
    bt.show()

    bt = Button(win, text="Click me", size_hint_weight=(0.75, 0.25),
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 0, 1, 1)
    win.data["b2"] = bt
    bt.callback_clicked_add(table3_cb2, win)
    bt.show()

    bt = Button(win, text="Button 3", disabled=True,
                size_hint_weight=(0.25, 0.75), size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()

    win.show()


### Table Percent
def table5_clicked(obj, item=None):
    win = StandardWindow("table5", "Table Percent", autodel=True)

    tb = Table(win, homogeneous=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="A", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 33, 0, 34, 33)
    bt.show()

    bt = Button(win, text="B", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 67, 33, 33, 34)
    bt.show()

    bt = Button(win, text="C", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 33, 67, 34, 33)
    bt.show()

    bt = Button(win, text="D", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 33, 33, 34)
    bt.show()

    bt = Button(win, text="X", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 33, 33, 34, 34)
    bt.show()

    win.show()


### Table Multi
def table6_clicked(obj, item=None):
    win = StandardWindow("table6", "Table Multi", autodel=True)

    tb = Table(win, homogeneous=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="C", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 2, 2)
    bt.show()

    bt = Button(win, text="A", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 2, 2)
    bt.show()

    bt = Button(win, text="Blah blah blah", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 3, 0, 2, 3)
    bt.show()

    bt = Button(win, text="Hallow", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 3, 10, 1)
    bt.show()

    bt = Button(win, text="B", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    bt = Button(win, text="Wide", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 7, 7, 2)
    bt.show()

    win.show()


### Table Multi 2
def table7_clicked(obj, item=None):
    win = StandardWindow("table7", "Table Multi 2", autodel=True)

    tb = Table(win, padding=(10, 20), size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = Button(win, text="C", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 2, 2)
    bt.show()

    bt = Button(win, text="A", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 2, 2)
    bt.show()

    bt = Button(win, text="Blah blah blah", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 3, 0, 2, 3)
    bt.show()

    bt = Button(win, text="Hallow", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 0, 3, 10, 1)
    bt.show()

    bt = Button(win, text="B", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    bt = Button(win, text="Wide", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    tb.pack(bt, 1, 7, 7, 2)
    bt.show()

    win.show()


### Table Padding
def table8_clicked(obj, item=None):
    win = StandardWindow("table7", "Table Multi 2", autodel=True)

    bx = Box(win, size_hint_expand=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    # outer table for the table alignment and background
    tb_out = Table(win, size_hint_fill=FILL_BOTH, size_hint_expand=EXPAND_BOTH)
    bx.pack_end(tb_out)
    tb_out.show()

    # table background
    bg = Background(tb_out, color=(255, 255, 0), size_hint_fill=FILL_BOTH,
                    size_hint_expand=EXPAND_BOTH)
    tb_out.pack(bg, 0, 0, 1, 1)
    bg.show()

    # actual table for a padding test
    tb = Table(tb_out, padding=(10,10))
    tb_out.pack(tb, 0, 0, 1, 1)
    tb.show()

    # first row
    bt = Button(tb, text="colspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    bt = Button(tb, text="colspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    bt = Button(tb, text="colspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    # second row
    bt = Button(tb, text="colspan 3", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 0, 1, 3, 1)
    bt.show()

    # third row
    bt = Button(tb, text="rowspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 0, 2, 1, 1)
    bt.show()

    bt = Button(tb, text="rowspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 1, 2, 1, 1)
    bt.show()

    bt = Button(tb, text="rowspan 2", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 2, 2, 1, 2)
    bt.show()
 
    # fourth row
    bt = Button(tb, text="rowspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 0, 3, 1, 1)
    bt.show()
   
    bt = Button(tb, text="rowspan 1", size_hint_expand=EXPAND_BOTH,
                size_hint_fill=FILL_BOTH)
    tb.pack(bt, 1, 3, 1, 1)
    bt.show()

    # horizontal padding sliders
    sl = Slider(bx, text="Horizontal Padding", unit_format="%1.0f pixel",
                min_max=(0,100), value=10,
                size_hint_fill=FILL_HORIZ, size_hint_expand=EXPAND_HORIZ)
    sl.callback_changed_add(lambda s: tb.padding_set(s.value, tb.padding[1]))
    bx.pack_end(sl)
    sl.show()

    # vertical padding sliders
    sl = Slider(bx, text="Vertical Padding", unit_format="%1.0f pixel",
                min_max=(0,100), value=10,
                size_hint_fill=FILL_HORIZ, size_hint_expand=EXPAND_HORIZ)
    sl.callback_changed_add(lambda s: tb.padding_set(tb.padding[0], sl.value))
    bx.pack_end(sl)
    sl.show()

    #
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
        ("Table", table_clicked),
        ("Table Homogeneous", table2_clicked),
        ("Table Repack", table3_clicked),
        ("Table Repack 2", table4_clicked),
        ("Table Percent", table5_clicked),
        ("Table Multi", table6_clicked),
        ("Table Multi 2", table7_clicked),
        ("Table Padding", table8_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
