#!/usr/bin/env python
# encoding: utf-8

from efl import elementary
from efl import evas


def btn_del_cbs_cb(button):
    canvas = button.evas_get()
    canvas.event_callback_del(evas.EVAS_CALLBACK_CANVAS_FOCUS_IN, events_cb1)
    canvas.event_callback_del(evas.EVAS_CALLBACK_CANVAS_FOCUS_OUT, events_cb1)
    # canvas.event_callback_del(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, events_cb1)
    # canvas.event_callback_del(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, events_cb1)
    canvas.event_callback_del(evas.EVAS_CALLBACK_RENDER_FLUSH_PRE, events_cb1)
    canvas.event_callback_del(evas.EVAS_CALLBACK_RENDER_FLUSH_POST, events_cb1)
    canvas.event_callback_del(evas.EVAS_CALLBACK_RENDER_PRE, events_cb1)
    canvas.event_callback_del(evas.EVAS_CALLBACK_RENDER_POST, events_cb1)


def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))


def core_evas_canvas_callbacks_clicked(obj, item=None):
    win = elementary.Window("evascanvascbs", elementary.ELM_WIN_BASIC)
    win.title_set("Evas canvas callbacks")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bg.show()

    text = evas.Text(win.evas, text="Events printed on console", size=(300, 30), color=(0,0,0,255))
    text.font_set("Sans", 12)
    text.pos = (10, 10)
    text.show()

    canvas = win.evas_get()
    canvas.event_callback_add(evas.EVAS_CALLBACK_CANVAS_FOCUS_IN, events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_IN")
    canvas.event_callback_add(evas.EVAS_CALLBACK_CANVAS_FOCUS_OUT, events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_OUT")
    # canvas.event_callback_add(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, events_cb2, "EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN")
    # canvas.event_callback_add(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, events_cb1, "EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT")

    canvas.event_callback_add(evas.EVAS_CALLBACK_RENDER_FLUSH_PRE, events_cb1, "EVAS_CALLBACK_RENDER_FLUSH_PRE")
    canvas.event_callback_add(evas.EVAS_CALLBACK_RENDER_FLUSH_POST, events_cb1, "EVAS_CALLBACK_RENDER_FLUSH_POST")
    canvas.event_callback_add(evas.EVAS_CALLBACK_RENDER_PRE, events_cb2, "EVAS_CALLBACK_RENDER_PRE")
    canvas.event_callback_add(evas.EVAS_CALLBACK_RENDER_POST, events_cb2, "EVAS_CALLBACK_RENDER_POST")

    r2 = evas.Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    r2.show()
    
    hbox = elementary.Box(win)
    win.resize_object_add(hbox)
    hbox.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    hbox.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    hbox.horizontal = True
    hbox.show()

    b = elementary.Button(win)
    b.text = "del cbs"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(btn_del_cbs_cb)
    b.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    elementary.init()

    core_evas_canvas_callbacks_clicked(None)

    elementary.run()
    elementary.shutdown()

