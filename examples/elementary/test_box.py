#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box, ELM_BOX_LAYOUT_HORIZONTAL
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.icon import Icon
from efl.elementary.separator import Separator


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo_small.png")

def box_vert_clicked(obj, item=None):
    win = StandardWindow("box-vert", "Box Vert", autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    for align in ((0.5, 0.5), (0.0, 0.5), (EVAS_HINT_EXPAND, 0.5)):
        ic = Icon(win, file=ic_file, resizable=(0, 0), size_hint_align=align)
        bx.pack_end(ic)
        ic.show()

    win.show()

def boxvert2_del_cb(bt, bx):
    bx.unpack(bt)
    bt.move(0, 0)
    bt.color_set(128, 64, 0, 128)

def box_vert2_clicked(obj, item=None):
    win = StandardWindow("box-vert2", "Box Vert 2", autodel=True)

    bx = Box(win, size_hint_weight=(0.0, 0.0))
    win.resize_object_add(bx)
    bx.show()

    for i in range(5):
        bt = Button(win, text="Button %d" % i,
            size_hint_align=FILL_BOTH, size_hint_weight=(0.0, 0.0))
        bt.callback_clicked_add(boxvert2_del_cb, bx)
        bx.pack_end(bt)
        bt.show()

    win.show()

def box_horiz_clicked(obj, item=None):
    win = StandardWindow("box-horiz", "Box Horiz", autodel=True)

    bx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    for align in ((0.5, 0.5), (0.5, 0.0), (0.0, EVAS_HINT_EXPAND)):
        ic = Icon(win, file=ic_file, resizable=(0, 0), size_hint_align=align)
        bx.pack_end(ic)
        ic.show()

    win.show()


layout_list = ["horizontal","vertical","homogeneous_vertical",
    "homogeneous_horizontal", "homogeneous_max_size_horizontal",
    "homogeneous_max_size_vertical", "flow_horizontal", "flow_vertical",
    "stack"]
current_layout = ELM_BOX_LAYOUT_HORIZONTAL


def box_layout_button_cb(obj, box):
    global current_layout

    current_layout += 1
    if current_layout >= len(layout_list):
        current_layout = 0
    obj.text_set("layout: %s" % layout_list[current_layout])
    box.layout_set(current_layout)

def box_layout_clicked(obj, item=None):
    win = StandardWindow("box-layout", "Box Layout", autodel=True)

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    bx = Box(win, layout=ELM_BOX_LAYOUT_HORIZONTAL,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH
        )
    vbox.pack_end(bx)
    bx.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    bt = Button(win, text="layout: %s" % layout_list[current_layout])
    bt.callback_clicked_add(box_layout_button_cb, bx)
    vbox.pack_end(bt)
    bt.show()

    for i in range(5):
        ic = Icon(win, file=ic_file, resizable=(0, 0),
            size_hint_align=(0.5, 0.5))
        bx.pack_end(ic)
        ic.show()

    ic = Icon(win, file=ic_file, resizable=(0, 0), size_hint_align=(1.0, 1.0))
    bx.pack_end(ic)
    ic.show()

    ic = Icon(win, file=ic_file, resizable=(0, 0), size_hint_align=(0.0, 0.0))
    bx.pack_end(ic)
    ic.show()

    win.show()

def box_transition_button_cb(obj, box):
    global current_layout

    from_ly = current_layout
    current_layout += 1
    if current_layout >= len(layout_list):
        current_layout = 0

    obj.text_set("layout: %s" % layout_list[current_layout])
    box.layout_transition(0.4, from_ly, current_layout)

def box_transition_clicked(obj, item=None):
    win = StandardWindow("box-layout-transition", "Box Layout Transition",
        autodel=True
        )

    vbox = Box(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    bx = Box(win, layout=ELM_BOX_LAYOUT_HORIZONTAL,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH
        )
    vbox.pack_end(bx)
    bx.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    bt = Button(win, text="layout: %s" % layout_list[current_layout])
    bt.callback_clicked_add(box_transition_button_cb, bx)
    vbox.pack_end(bt)
    bt.show()

    for i in range(4):
        ic = Icon(win, file=ic_file, resizable=(0, 0),
            size_hint_align=(0.5, 0.5))
        bx.pack_end(ic)
        ic.show()

    win.show()


if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda x: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text =   "Please select a test from the list below<br>" \
                "by clicking the test button to show the<br>" \
                "test window."
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Box Vert", box_vert_clicked),
             ("Box Vert 2", box_vert2_clicked),
             ("Box Horiz", box_horiz_clicked),
             ("Box Layout", box_layout_clicked),
             ("Box Layout Transition", box_transition_clicked)]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()

