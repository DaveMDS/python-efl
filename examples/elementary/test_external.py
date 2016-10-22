#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl.ecore import Timer
from efl import edje
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.progressbar import Progressbar
from efl.elementary.button import Button
from efl.elementary.layout import Layout
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")
theme_file = os.path.join(script_path, "test_external.edj")

def edje_external_button_clicked(obj, item=None):
    win = StandardWindow("edje-external-button", "Edje External Button",
                         autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win,file=(theme_file, "external/button"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()

    win.show()

def animate(ly):
    val = ly.edje.part_external_object_get("ext_pbar1").value
    val += 0.0123

    for part_name in ["ext_pbar1", "ext_pbar3", "ext_pbar4", "ext_pbar6"]:
        ly.edje.part_external_object_get(part_name).value = val

    if val < 1:
        Timer(0.1, animate, ly)
    else:
        for part_name in ["ext_pbar2", "ext_pbar5", "ext_pbar7"]:
            ly.edje.part_external_object_get(part_name).pulse(False)
            ly.edje.part_external_object_get(part_name).pulse_mode = False
        for part_name in ["ext_button1", "ext_button2", "ext_button3"]:
            ly.edje_get().part_external_object_get(part_name).disabled = False

    return False

def cb_btn3_clicked(bt, ly):
    ly.edje.part_external_object_get("ext_pbar1").value = 0.0

    for part_name in ["ext_pbar2", "ext_pbar5", "ext_pbar7"]:
        ly.edje.part_external_object_get(part_name).pulse_mode = True
        ly.edje.part_external_object_get(part_name).pulse(True)
    for part_name in ["ext_button1", "ext_button2", "ext_button3"]:
        ly.edje_get().part_external_object_get(part_name).disabled = True

    Timer(0.1, animate, ly)

def edje_external_pbar_clicked(obj, item=None):
    win = StandardWindow("edje-external-pbar", "Edje External Progress Bar",
                         autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(theme_file, "external/pbar"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()

    bt = ly.edje.part_external_object_get("ext_button3")
    bt.text = "...or from Python"
    bt.callback_clicked_add(cb_btn3_clicked, ly)

    win.show()

def edje_external_scroller_clicked(obj, item=None):
    win = StandardWindow("edje-external-scroller", "Edje External Scroller",
                         autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(theme_file, "external/scroller"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()

    win.show()

def edje_external_slider_clicked(obj, item=None):
    win = StandardWindow("edje-external-slider", "Edje External Slider",
                         autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(theme_file, "external/slider"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()

    win.show()

def edje_external_video_clicked(obj, item=None):
    win = StandardWindow("edje-external-video", "Edje External Video",
                         autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(theme_file, "external/video"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()

    win.show()

def edje_external_icon_clicked(obj, item=None):
    win = StandardWindow("edje-external-icon", "Edje External Icon",
        autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = Layout(win, file=(theme_file, "external/icon"),
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ly)
    ly.show()
    ly.signal_emit("elm_test,animations,start", "elm_test")

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
        ("Ext Button", edje_external_button_clicked),
        ("Ext ProgressBar", edje_external_pbar_clicked),
        ("Ext Scroller", edje_external_scroller_clicked),
        ("Ext Slider", edje_external_slider_clicked),
        ("Ext Video", edje_external_video_clicked),
        ("Ext Icon", edje_external_icon_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
