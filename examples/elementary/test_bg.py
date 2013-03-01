#!/usr/bin/env python
# encoding: utf-8


from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List


def bg_plain_clicked(obj, item=None):
    win = Window("bg plain", elementary.ELM_WIN_BASIC)
    win.title_set("Bg Plain")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    win.resize(320, 320)
    win.show()


def bg_image_clicked(obj, item=None):
    win = Window("bg-image", elementary.ELM_WIN_BASIC)
    win.title_set("Bg Image")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.file_set("images/plant_01.jpg")
    bg.option_set(elementary.ELM_BG_OPTION_SCALE)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    win.size_hint_min_set(160, 160)
    win.size_hint_max_set(320, 320)
    win.resize(320, 320)
    win.show()

    (filename, group) = bg.file_get()
    print(("Background image: '%s'  group: '%s'" % (filename, group)))
    print(("Option: %d" % (bg.option_get())))


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

    items = [("Bg Plain", bg_plain_clicked),
             ("Bg Image", bg_image_clicked)]

    li = List(win)
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

