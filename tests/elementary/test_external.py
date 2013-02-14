#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import ecore
from efl import elementary



def edje_external_button_clicked(obj, item=None):
    win = elementary.Window("edje-external-button", elementary.ELM_WIN_BASIC)
    win.title_set("Edje External Button")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = elementary.Layout(win)
    ly.file_set("test_external.edj", "external/button")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    win.resize(320, 400)
    win.show()


def animate(ly):
    val = ly.edje_get().part_external_object_get("ext_pbar1").value
    val += 0.0123

    for part_name in ["ext_pbar1", "ext_pbar3", "ext_pbar4", "ext_pbar6"]:
        ly.edje_get().part_external_object_get(part_name).value = val

    if val < 1:
        ecore.timer_add(0.1, animate, ly)
    else:
        for part_name in ["ext_pbar2", "ext_pbar5", "ext_pbar7"]:
            ly.edje_get().part_external_object_get(part_name).pulse(False)
        for part_name in ["ext_button1", "ext_button2", "ext_button3"]:
            ly.edje_get().part_external_object_get(part_name).disabled = False

    return False

def cb_btn3_clicked(bt, ly):
    ly.edje_get().part_external_object_get("ext_pbar1").value = 0.0

    for part_name in ["ext_pbar2", "ext_pbar5", "ext_pbar7"]:
        ly.edje_get().part_external_object_get(part_name).pulse(True)
    for part_name in ["ext_button1", "ext_button2", "ext_button3"]:
        ly.edje_get().part_external_object_get(part_name).disabled = True

    ecore.timer_add(0.1, animate, ly)

def edje_external_pbar_clicked(obj, item=None):
    win = elementary.Window("edje-external-pbar", elementary.ELM_WIN_BASIC)
    win.title_set("Edje External Progress Bar")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = elementary.Layout(win)
    ly.file_set("test_external.edj", "external/pbar")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    bt = ly.edje_get().part_external_object_get("ext_button3")
    bt.text = "...or from Python"
    bt.callback_clicked_add(cb_btn3_clicked, ly)

    win.resize(320, 400)
    win.show()


def edje_external_scroller_clicked(obj, item=None):
    win = elementary.Window("edje-external-scroller", elementary.ELM_WIN_BASIC)
    win.title_set("Edje External Scroller")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = elementary.Layout(win)
    ly.file_set("test_external.edj", "external/scroller")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    win.resize(320, 400)
    win.show()


def edje_external_slider_clicked(obj, item=None):
    win = elementary.Window("edje-external-slider", elementary.ELM_WIN_BASIC)
    win.title_set("Edje External Slider")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = elementary.Layout(win)
    ly.file_set("test_external.edj", "external/slider")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    win.resize(320, 400)
    win.show()


def edje_external_video_clicked(obj, item=None):
    win = elementary.Window("edje-external-video", elementary.ELM_WIN_BASIC)
    win.title_set("Edje External Video")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    ly = elementary.Layout(win)
    ly.file_set("test_external.edj", "external/video")
    ly.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(ly)
    ly.show()

    win.resize(320, 400)
    win.show()



if __name__ == "__main__":
    def destroy(obj):
        elementary.exit()

    elementary.init()
    win = elementary.Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = elementary.Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = elementary.Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = elementary.Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [("Ext Button", edje_external_button_clicked),
            ("Ext ProgressBar", edje_external_pbar_clicked),
            ("Ext Scroller", edje_external_scroller_clicked),
            ("Ext Slider", edje_external_slider_clicked),
            ("Ext Video", edje_external_video_clicked)]
 
    li = elementary.List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
    ecore.shutdown()
    evas.shutdown()
