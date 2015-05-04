#!/usr/bin/env python
# encoding: utf-8

import os
from efl.evas import Rectangle, Line, Text, Polygon, FilledImage, \
    EVAS_IMAGE_ORIENT_180
from efl import elementary
from efl.elementary.window import StandardWindow

img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo.png")

def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))

def core_evas_objects_clicked(obj, item=None):
    win = StandardWindow("evasobjects", "Evas Objects Test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    rect = Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    rect.show()

    line = Line(win.evas, start=(20,40), end=(200,100), color=(255,0,0,255))
    line.show()

    text = Text(win.evas, text="Evas Text Object", size=(300, 30), color=(0,0,0,255))
    text.font_set("Sans", 16)
    text.pos = (40, 20)
    text.show()

    poly = Polygon(win.evas, color=(200, 0, 200, 200))
    poly.point_add(10,100)
    poly.point_add(100,120)
    poly.point_add(20,30)
    poly.show()

    image = FilledImage(win.evas, file=ic_file, size=(50,70), pos=(120,70))
    image.orient = EVAS_IMAGE_ORIENT_180
    image.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":

    core_evas_objects_clicked(None)

    elementary.run()

