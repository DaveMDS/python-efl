#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_CALLBACK_MOUSE_IN, EVAS_CALLBACK_MOUSE_OUT, \
    EVAS_CALLBACK_MOUSE_DOWN, EVAS_CALLBACK_MOUSE_UP, \
    EVAS_CALLBACK_MOUSE_MOVE, EVAS_CALLBACK_MOUSE_WHEEL, \
    EVAS_CALLBACK_MULTI_DOWN, EVAS_CALLBACK_MULTI_UP, \
    EVAS_CALLBACK_MULTI_MOVE, EVAS_CALLBACK_FREE, \
    EVAS_CALLBACK_KEY_DOWN, EVAS_CALLBACK_KEY_UP, \
    EVAS_CALLBACK_FOCUS_IN, EVAS_CALLBACK_FOCUS_OUT, \
    EVAS_CALLBACK_SHOW, EVAS_CALLBACK_HIDE, EVAS_CALLBACK_MOVE, \
    EVAS_CALLBACK_RESIZE, EVAS_CALLBACK_RESTACK, \
    EVAS_CALLBACK_DEL, EVAS_CALLBACK_HOLD, \
    EVAS_CALLBACK_CHANGED_SIZE_HINTS, \
    EVAS_CALLBACK_IMAGE_PRELOADED, EVAS_CALLBACK_IMAGE_UNLOADED, \
    Text, Rectangle, EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button


def btn_del_cbs_cb(button, rect):
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_IN, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_OUT, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_DOWN, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_UP, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_MOVE, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MOUSE_WHEEL, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MULTI_DOWN, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MULTI_UP, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_MULTI_MOVE, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_FREE, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_KEY_DOWN, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_KEY_UP, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_FOCUS_IN, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_FOCUS_OUT, events_cb2)
    rect.event_callback_del(EVAS_CALLBACK_SHOW, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_HIDE, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_MOVE, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_RESIZE, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_RESTACK, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_DEL, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_HOLD, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_CHANGED_SIZE_HINTS, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_IMAGE_PRELOADED, events_cb1)
    rect.event_callback_del(EVAS_CALLBACK_IMAGE_UNLOADED, events_cb1)


def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))


def core_evas_object_callbacks_clicked(obj, item=None):
    win = StandardWindow("evas3d", "Evas object callbacks", autodel=True,
        size=(320,320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    text = Text(win.evas, text="Events printed on console", size=(300, 30),
        color=(0,0,0,255))
    text.font_set("Sans", 12)
    text.pos = (10, 10)
    text.show()

    r = Rectangle(win.evas, size=(100,100), color=(100,0,0,200), pos=(50,50))
    r.event_callback_add(EVAS_CALLBACK_MOUSE_IN, events_cb2, "EVAS_CALLBACK_MOUSE_IN")
    r.event_callback_add(EVAS_CALLBACK_MOUSE_OUT, events_cb2, "EVAS_CALLBACK_MOUSE_OUT")
    r.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, events_cb2, "EVAS_CALLBACK_MOUSE_DOWN")
    r.event_callback_add(EVAS_CALLBACK_MOUSE_UP, events_cb2, "EVAS_CALLBACK_MOUSE_UP")
    r.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, events_cb2, "EVAS_CALLBACK_MOUSE_MOVE")
    r.event_callback_add(EVAS_CALLBACK_MOUSE_WHEEL, events_cb2, "EVAS_CALLBACK_MOUSE_WHEEL")
    r.event_callback_add(EVAS_CALLBACK_MULTI_DOWN, events_cb2, "EVAS_CALLBACK_MULTI_DOWN")
    r.event_callback_add(EVAS_CALLBACK_MULTI_UP, events_cb2, "EVAS_CALLBACK_MULTI_UP")
    r.event_callback_add(EVAS_CALLBACK_MULTI_MOVE, events_cb2, "EVAS_CALLBACK_MULTI_MOVE")
    r.event_callback_add(EVAS_CALLBACK_FREE, events_cb1, "EVAS_CALLBACK_FREE")
    r.event_callback_add(EVAS_CALLBACK_KEY_DOWN, events_cb2, "EVAS_CALLBACK_KEY_DOWN")
    r.event_callback_add(EVAS_CALLBACK_KEY_UP, events_cb2, "EVAS_CALLBACK_KEY_UP")
    r.event_callback_add(EVAS_CALLBACK_FOCUS_IN, events_cb2, "EVAS_CALLBACK_FOCUS_IN")
    r.event_callback_add(EVAS_CALLBACK_FOCUS_OUT, events_cb2, "EVAS_CALLBACK_FOCUS_OUT")
    r.event_callback_add(EVAS_CALLBACK_SHOW, events_cb1, "EVAS_CALLBACK_SHOW")
    r.event_callback_add(EVAS_CALLBACK_HIDE, events_cb1, "EVAS_CALLBACK_HIDE")
    r.event_callback_add(EVAS_CALLBACK_MOVE, events_cb1, "EVAS_CALLBACK_MOVE")
    r.event_callback_add(EVAS_CALLBACK_RESIZE, events_cb1, "EVAS_CALLBACK_RESIZE")
    r.event_callback_add(EVAS_CALLBACK_RESTACK, events_cb1, "EVAS_CALLBACK_RESTACK")
    r.event_callback_add(EVAS_CALLBACK_DEL, events_cb1, "EVAS_CALLBACK_DEL")
    r.event_callback_add(EVAS_CALLBACK_HOLD, events_cb1, "EVAS_CALLBACK_HOLD")
    r.event_callback_add(EVAS_CALLBACK_CHANGED_SIZE_HINTS, events_cb1, "EVAS_CALLBACK_CHANGED_SIZE_HINTS")
    r.event_callback_add(EVAS_CALLBACK_IMAGE_PRELOADED, events_cb1, "EVAS_CALLBACK_IMAGE_PRELOADED")
    r.event_callback_add(EVAS_CALLBACK_IMAGE_UNLOADED, events_cb1, "EVAS_CALLBACK_IMAGE_UNLOADED")
    ##  r.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_IN, events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_IN")
    ##  r.event_callback_add(EVAS_CALLBACK_CANVAS_FOCUS_OUT, events_cb1, "")
    ## r.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_PRE, events_cb1, "")
    ## r.event_callback_add(EVAS_CALLBACK_RENDER_FLUSH_POST, events_cb1, "")
    ## r.event_callback_add(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, events_cb1, "")
    ## r.event_callback_add(EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, events_cb1, "")

    ## r.event_callback_add(EVAS_CALLBACK_RENDER_PRE, events_cb1, "")
    ## r.event_callback_add(EVAS_CALLBACK_RENDER_POST, events_cb1, "")
    #? r.event_callback_add(EVAS_CALLBACK_IMAGE_RESIZE, events_cb1, "")
    #? r.event_callback_add(EVAS_CALLBACK_DEVICE_CHANGED, events_cb1, "")
    r.show()

    r2 = Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    r2.show()

    hbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        horizontal=True)
    win.resize_object_add(hbox)
    hbox.show()

    b = Button(win, text="show / hide", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.hide() if r.visible else r.show(), r)
    b.show()

    b = Button(win, text="move", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, t: r.pos_set(r.pos[0] + 1, r.pos[1]), r)
    b.show()

    b = Button(win, text="resize", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.size_set(r.size[0] + 1, r.size[1] + 1), r)
    b.show()

    b = Button(win, text="delete", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.delete(), r)
    b.show()

    b = Button(win, text="raise", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.raise_(), r)
    b.show()

    b = Button(win, text="hints", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.size_hint_align_set(0.0, 0.0), r)
    b.show()

    b = Button(win, text="del cbs", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)
    b.callback_clicked_add(btn_del_cbs_cb, r)
    b.show()

    win.show()


if __name__ == "__main__":

    core_evas_object_callbacks_clicked(None)

    elementary.run()
