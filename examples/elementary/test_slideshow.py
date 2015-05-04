#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EVAS_CALLBACK_MOUSE_IN, \
    EVAS_CALLBACK_MOUSE_OUT, EVAS_CALLBACK_MOUSE_UP, EVAS_CALLBACK_MOUSE_MOVE, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.hoversel import Hoversel
from efl.elementary.notify import Notify, ELM_NOTIFY_ORIENT_BOTTOM
from efl.elementary.photo import Photo
from efl.elementary.spinner import Spinner
from efl.elementary.slideshow import Slideshow, SlideshowItemClass


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

images = [
    "logo.png",
    "plant_01.jpg",
    "rock_01.jpg",
    "rock_02.jpg",
    "sky_01.jpg",
    "sky_04.jpg",
    "wood_01.jpg",
    "mystrale.jpg",
    "mystrale_2.jpg"
]

def notify_show(no, event, *args, **kwargs):
    no = args[0]
    no.show()

def next(bt, ss):
    ss.next()

def previous(bt, ss):
    ss.previous()

def mouse_in(bx, event, *args, **kwargs):
    no = args[0]
    no.timeout = 0.0
    no.show()

def mouse_out(bx, event, *args, **kwargs):
    no = args[0]
    no.timeout = 3.0

def hv_select(hv, hvit, ss, transition):
    ss.transition = transition
    hv.text = transition

def layout_select(hv, hvit, ss, layout):
    ss.layout = layout
    hv.text = layout

def start(bt, ss, sp, bt_start, bt_stop):
    ss.timeout = sp.value
    bt_start.disabled = True
    bt_stop.disabled = False

def stop(bt, ss, sp, bt_start, bt_stop):
    ss.timeout = 0.0
    bt_start.disabled = False
    bt_stop.disabled = True

def spin(sp, ss):
    if (ss.timeout > 0):
        ss.timeout = sp.value


def ss_changed_cb(ss, item):
    print("CHANGED", item)

def ss_transition_end_cb(ss, item, last_item):
    print("TRANSITION END", item)
    if item == last_item:
        print("Reaches to End of slides\n")

class ssClass(SlideshowItemClass):
    def get(self, obj, item_data):
        print("Class get", item_data)
        photo = Photo(obj, file=item_data, fill_inside=True, style="shadow")
        return photo

    def delete(self, obj, item_data):
        print("Class delete", item_data)

def slideshow_clicked(obj):
    win = StandardWindow("slideshow", "Slideshow",
                         autodel=True, size=(500, 400))

    ss = Slideshow(win, loop=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(ss)
    ss.show()

    ssc = ssClass()
    for i in range(len(images)):
        print("ADD", images[i])
        slide_last_it = ss.item_add(ssc, os.path.join(img_path, images[i]))

    ss.callback_changed_add(ss_changed_cb)
    ss.callback_transition_end_add(ss_transition_end_cb, slide_last_it)

    bx = Box(win, horizontal=True)
    bx.show()

    no = Notify(win, align=(0.5, 1.0), timeout=3.0, content=bx,
                size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(no)

    bx.event_callback_add(EVAS_CALLBACK_MOUSE_IN, mouse_in, no)
    bx.event_callback_add(EVAS_CALLBACK_MOUSE_OUT, mouse_out, no)

    bt = Button(win, text="Previous")
    bt.callback_clicked_add(previous, ss)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Next")
    bt.callback_clicked_add(next, ss)
    bx.pack_end(bt)
    bt.show()

    hv = Hoversel(win, hover_parent=win, text=ss.transitions[0])
    bx.pack_end(hv)
    for transition in ss.transitions:
        hv.item_add(transition, None, 0, hv_select, ss, transition)
    hv.item_add("None", None, 0, hv_select, ss, None)
    hv.show()

    hv = Hoversel(win, hover_parent=win, text=ss.layout)
    bx.pack_end(hv)
    for layout in ss.layouts:
         hv.item_add(layout, None, 0, layout_select, ss, layout)
    hv.show()

    sp = Spinner(win, label_format="%2.0f secs.",
                 step=1, min_max=(1, 30), value=3)
    sp.callback_changed_add(spin, ss)
    bx.pack_end(sp)
    sp.show()

    bt_start = Button(win, text="Start")
    bt_stop = Button(win, text="Stop", disabled=True)

    bt_start.callback_clicked_add(start, ss, sp, bt_start, bt_stop)
    bx.pack_end(bt_start)
    bt_start.show()

    bt_stop.callback_clicked_add(stop, ss, sp, bt_start, bt_stop)
    bx.pack_end(bt_stop)
    bt_stop.show()

    ss.event_callback_add(EVAS_CALLBACK_MOUSE_UP, notify_show, no)
    ss.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, notify_show, no)

    win.show()


if __name__ == "__main__":

    slideshow_clicked(None)

    elementary.run()
