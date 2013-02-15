#!/usr/bin/env python
# encoding: utf-8

from efl import elementary
from efl import evas



def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))


def core_evas_objects_clicked(obj, item=None):

    win = elementary.Window("evasobjects", elementary.ELM_WIN_BASIC)
    win.title_set("Evas Objects Test")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bg.show()


    rect = evas.Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    rect.show()

    line = evas.Line(win.evas, start=(20,40), end=(200,100), color=(255,0,0,255))
    line.show()

    text = evas.Text(win.evas, text="Evas Text Object", size=(300, 30), color=(0,0,0,255))
    text.font_set("Sans", 16)
    text.pos = (40, 20)
    text.show()

    poly = evas.Polygon(win.evas, color=(200, 0, 200, 200))
    poly.point_add(10,100)
    poly.point_add(100,120)
    poly.point_add(20,30)
    poly.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    elementary.init()

    core_evas_objects_clicked(None)

    elementary.run()
    elementary.shutdown()

