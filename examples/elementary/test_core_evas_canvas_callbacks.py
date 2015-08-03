#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EVAS_CALLBACK_RENDER_PRE, EVAS_CALLBACK_RENDER_POST, \
    EVAS_CALLBACK_CANVAS_FOCUS_IN, EVAS_CALLBACK_CANVAS_FOCUS_OUT, \
    EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, \
    EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, \
    EVAS_CALLBACK_RENDER_FLUSH_PRE, EVAS_CALLBACK_RENDER_FLUSH_POST, \
    EVAS_CALLBACK_CANVAS_VIEWPORT_RESIZE, \
    Text, Rectangle

# edje is imported because the canvas callbacks point to an edje obj,
# an instance cannot be created unless the class is available.
# (it's not mapped in efl.eo object_mapping)
from efl import edje

from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button


def btn_del_cbs_cb(button):
    canvas = button.evas_get()
    canvas.event_callback_del(EVAS_CALLBACK_CANVAS_FOCUS_IN, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_CANVAS_FOCUS_OUT, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, events_cb2)
    canvas.event_callback_del(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, events_cb2)
    canvas.event_callback_del(EVAS_CALLBACK_RENDER_FLUSH_PRE, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_RENDER_FLUSH_POST, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_RENDER_PRE, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_RENDER_POST, events_cb1)
    canvas.event_callback_del(EVAS_CALLBACK_CANVAS_VIEWPORT_RESIZE, events_cb1)


def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))


def core_evas_canvas_callbacks_clicked(obj, item=None):
    win = StandardWindow("evascanvascbs", "Evas canvas callbacks", autodel=True,
        size=(320,320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    text = Text(win.evas, text="Events printed on console", size=(300, 30),
        color=(0,0,0,255))
    text.font_set("Sans", 12)
    text.pos = (10, 10)
    text.show()

    canvas = win.evas_get()
    canvas.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_IN,
        events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_IN")
    canvas.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_OUT,
        events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_OUT")
    canvas.event_callback_add(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN,
        events_cb2, "EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN")
    canvas.event_callback_add(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT,
        events_cb2, "EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT")

    canvas.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_PRE,
        events_cb1, "EVAS_CALLBACK_RENDER_FLUSH_PRE")
    canvas.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_POST,
        events_cb1, "EVAS_CALLBACK_RENDER_FLUSH_POST")
    canvas.event_callback_add(EVAS_CALLBACK_RENDER_PRE,
        events_cb1, "EVAS_CALLBACK_RENDER_PRE")
    canvas.event_callback_add(EVAS_CALLBACK_RENDER_POST,
        events_cb1, "EVAS_CALLBACK_RENDER_POST")

    canvas.event_callback_add(EVAS_CALLBACK_CANVAS_VIEWPORT_RESIZE,
        events_cb1, "EVAS_CALLBACK_CANVAS_VIEWPORT_RESIZE")

    r2 = Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    r2.show()

    hbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        horizontal=True)
    win.resize_object_add(hbox)
    hbox.show()

    b = Button(win, text="del cbs", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(btn_del_cbs_cb)
    b.show()

    win.show()


if __name__ == "__main__":

    core_evas_canvas_callbacks_clicked(None)

    elementary.run()

