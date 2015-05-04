#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, \
    FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.button import Button
from efl.elementary.layout import Layout
from efl.elementary.list import List
from efl.elementary.radio import Radio
from efl.elementary.flip import Flip, ELM_FLIP_ROTATE_X_CENTER_AXIS, \
    ELM_FLIP_ROTATE_Y_CENTER_AXIS, ELM_FLIP_ROTATE_XZ_CENTER_AXIS, \
    ELM_FLIP_ROTATE_YZ_CENTER_AXIS, ELM_FLIP_CUBE_LEFT, ELM_FLIP_CUBE_RIGHT, \
    ELM_FLIP_CUBE_UP, ELM_FLIP_CUBE_DOWN, ELM_FLIP_PAGE_LEFT, \
    ELM_FLIP_PAGE_RIGHT, ELM_FLIP_PAGE_UP, ELM_FLIP_PAGE_DOWN, \
    ELM_FLIP_DIRECTION_UP, ELM_FLIP_DIRECTION_DOWN, \
    ELM_FLIP_DIRECTION_LEFT, ELM_FLIP_DIRECTION_RIGHT, \
    ELM_FLIP_INTERACTION_NONE, ELM_FLIP_INTERACTION_ROTATE, \
    ELM_FLIP_INTERACTION_CUBE, ELM_FLIP_INTERACTION_PAGE


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def my_flip_go(bt, fl, mode):
    fl.go(mode)

def my_flip_animate_begin(fl):
    print("Animation Begin")

def my_flip_animate_done(fl):
    print("Animation Done")

def flip_clicked(obj, item=None):
    win = StandardWindow("flip", "Flip", autodel=True, size=(320, 320))

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    fl = Flip(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    fl.callback_animate_begin_add(my_flip_animate_begin)
    fl.callback_animate_done_add(my_flip_animate_done)
    box.pack_end(fl)
    fl.show()

    # flip front content
    o = Background(win, size_hint_weight=EXPAND_BOTH,
        file=os.path.join(img_path, "sky_01.jpg"))
    fl.part_content_set("front", o)
    o.show()

    # flip back content
    ly = Layout(win, file=(os.path.join(script_path, "test.edj"), "layout"),
        size_hint_weight=EXPAND_BOTH)
    fl.part_content_set("back", ly)
    ly.show()

    bt = Button(win, text="Button 1")
    ly.part_content_set("element1", bt)
    bt.show()

    bt = Button(win, text="Button 2")
    ly.part_content_set("element2", bt)
    bt.show()

    bt = Button(win, text="Button 3")
    ly.part_content_set("element3", bt)
    bt.show()

    # flip buttons (first row)
    hbox = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), horizontal=True)
    hbox.show()
    box.pack_end(hbox)
    count = 1

    for mode in [ELM_FLIP_ROTATE_X_CENTER_AXIS,
                 ELM_FLIP_ROTATE_Y_CENTER_AXIS,
                 ELM_FLIP_ROTATE_XZ_CENTER_AXIS,
                 ELM_FLIP_ROTATE_YZ_CENTER_AXIS]:
        bt = Button(win, size_hint_weight=EXPAND_BOTH,
            size_hint_align=FILL_BOTH, text=str(count))
        bt.callback_clicked_add(my_flip_go, fl, mode)
        hbox.pack_end(bt)
        bt.show()
        count += 1

    # flip buttons (second row)
    hbox = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), horizontal=True)
    hbox.show()
    box.pack_end(hbox)

    for mode in [ELM_FLIP_CUBE_LEFT,
                 ELM_FLIP_CUBE_RIGHT,
                 ELM_FLIP_CUBE_UP,
                 ELM_FLIP_CUBE_DOWN]:
        bt = Button(win, size_hint_weight=EXPAND_BOTH,
            size_hint_align=FILL_BOTH, text=str(count))
        bt.callback_clicked_add(my_flip_go, fl, mode)
        hbox.pack_end(bt)
        bt.show()
        count += 1

    # flip buttons (third row)
    hbox = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), horizontal=True)
    hbox.show()
    box.pack_end(hbox)

    for mode in [ELM_FLIP_PAGE_LEFT,
                 ELM_FLIP_PAGE_RIGHT,
                 ELM_FLIP_PAGE_UP,
                 ELM_FLIP_PAGE_DOWN]:
        bt = Button(win, size_hint_weight=EXPAND_BOTH,
            size_hint_align=FILL_BOTH, text=str(count))
        bt.callback_clicked_add(my_flip_go, fl, mode)
        hbox.pack_end(bt)
        bt.show()
        count += 1

    win.show()


def my_cb_radios (rd, fl):
    print((rd.value_get()))
    fl.interaction_set(rd.value_get())

def flip_interactive_clicked(obj, item=None):
    win = StandardWindow("flip", "Flip", autodel=True, size=(320, 320))

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    # flip object
    fl = Flip(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        interaction=ELM_FLIP_INTERACTION_NONE)
    fl.interaction_direction_enabled_set(ELM_FLIP_DIRECTION_UP, True)
    fl.interaction_direction_enabled_set(ELM_FLIP_DIRECTION_DOWN, True)
    fl.interaction_direction_enabled_set(ELM_FLIP_DIRECTION_LEFT, True)
    fl.interaction_direction_enabled_set(ELM_FLIP_DIRECTION_RIGHT, True)
    fl.interaction_direction_hitsize_set(ELM_FLIP_DIRECTION_UP, 0.25)
    fl.interaction_direction_hitsize_set(ELM_FLIP_DIRECTION_DOWN, 0.25)
    fl.interaction_direction_hitsize_set(ELM_FLIP_DIRECTION_LEFT, 0.25)
    fl.interaction_direction_hitsize_set(ELM_FLIP_DIRECTION_RIGHT, 0.25)
    fl.callback_animate_begin_add(my_flip_animate_begin)
    fl.callback_animate_done_add(my_flip_animate_done)
    box.pack_end(fl)
    fl.show()

    # front content (image)
    o = Background(win, size_hint_weight=EXPAND_BOTH,
        file=os.path.join(img_path, "sky_01.jpg"))
    fl.part_content_set("front", o)
    o.show()

    # back content (layout)
    ly = Layout(win, size_hint_weight=EXPAND_BOTH,
        file=(os.path.join(script_path, "test.edj"), "layout"))
    fl.part_content_set("back", ly)
    ly.show()

    bt = Button(win, text="Button 1")
    ly.part_content_set("element1", bt)
    bt.show()

    bt = Button(win, text="Button 2")
    ly.part_content_set("element2", bt)
    bt.show()

    bt = Button(win, text="Button 3")
    ly.part_content_set("element3", bt)
    bt.show()


    # radio buttons
    rd = Radio(win, state_value=ELM_FLIP_INTERACTION_NONE, text="None")
    rd.callback_changed_add(my_cb_radios, fl)
    box.pack_end(rd)
    rd.show()
    rdg = rd

    rd = Radio(win, state_value=ELM_FLIP_INTERACTION_ROTATE, text="Rotate")
    rd.callback_changed_add(my_cb_radios, fl)
    rd.group_add(rdg)
    box.pack_end(rd)
    rd.show()

    rd = Radio(win, state_value=ELM_FLIP_INTERACTION_CUBE, text="Cube")
    rd.callback_changed_add(my_cb_radios, fl)
    rd.group_add(rdg)
    box.pack_end(rd)
    rd.show()

    rd = Radio(win, state_value=ELM_FLIP_INTERACTION_PAGE, text="Page")
    rd.callback_changed_add(my_cb_radios, fl)
    rd.group_add(rdg)
    box.pack_end(rd)
    rd.show()

    # window show
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

    items = [("Flip", flip_clicked),
             ("Flip Interactive", flip_interactive_clicked),
            ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
