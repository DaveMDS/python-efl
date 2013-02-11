#!/usr/bin/env python
# encoding: utf-8

from efl import elementary
from efl import evas


def btn_del_cbs_cb(button, rect):
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_IN, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_OUT, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_DOWN, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_UP, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_MOVE, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOUSE_WHEEL, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MULTI_DOWN, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MULTI_UP, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_MULTI_MOVE, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_FREE, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_KEY_DOWN, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_KEY_UP, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_FOCUS_IN, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_FOCUS_OUT, events_cb2)
    rect.event_callback_del(evas.EVAS_CALLBACK_SHOW, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_HIDE, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_MOVE, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_RESIZE, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_RESTACK, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_DEL, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_HOLD, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_CHANGED_SIZE_HINTS, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_IMAGE_PRELOADED, events_cb1)
    rect.event_callback_del(evas.EVAS_CALLBACK_IMAGE_UNLOADED, events_cb1)


def events_cb1(rect, event_name):
    print(event_name + " No data for event")

def events_cb2(rect, evtinfo, event_name):
    print(event_name + " " + str(evtinfo))


def core_evas_object_callbacks_clicked(obj, item=None):
    win = elementary.Window("evas3d", elementary.ELM_WIN_BASIC)
    win.title_set("Evas object callbacks")
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
    
    r = evas.Rectangle(win.evas, size=(100,100), color=(100,0,0,200), pos=(50,50))
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_IN, events_cb2, "EVAS_CALLBACK_MOUSE_IN")
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_OUT, events_cb2, "EVAS_CALLBACK_MOUSE_OUT")
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_DOWN, events_cb2, "EVAS_CALLBACK_MOUSE_DOWN")
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_UP, events_cb2, "EVAS_CALLBACK_MOUSE_UP")
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_MOVE, events_cb2, "EVAS_CALLBACK_MOUSE_MOVE")
    r.event_callback_add(evas.EVAS_CALLBACK_MOUSE_WHEEL, events_cb2, "EVAS_CALLBACK_MOUSE_WHEEL")
    r.event_callback_add(evas.EVAS_CALLBACK_MULTI_DOWN, events_cb2, "EVAS_CALLBACK_MULTI_DOWN")
    r.event_callback_add(evas.EVAS_CALLBACK_MULTI_UP, events_cb2, "EVAS_CALLBACK_MULTI_UP")
    r.event_callback_add(evas.EVAS_CALLBACK_MULTI_MOVE, events_cb2, "EVAS_CALLBACK_MULTI_MOVE")
    r.event_callback_add(evas.EVAS_CALLBACK_FREE, events_cb1, "EVAS_CALLBACK_FREE")
    r.event_callback_add(evas.EVAS_CALLBACK_KEY_DOWN, events_cb2, "EVAS_CALLBACK_KEY_DOWN")
    r.event_callback_add(evas.EVAS_CALLBACK_KEY_UP, events_cb2, "EVAS_CALLBACK_KEY_UP")
    r.event_callback_add(evas.EVAS_CALLBACK_FOCUS_IN, events_cb2, "EVAS_CALLBACK_FOCUS_IN")
    r.event_callback_add(evas.EVAS_CALLBACK_FOCUS_OUT, events_cb2, "EVAS_CALLBACK_FOCUS_OUT")
    r.event_callback_add(evas.EVAS_CALLBACK_SHOW, events_cb1, "EVAS_CALLBACK_SHOW")
    r.event_callback_add(evas.EVAS_CALLBACK_HIDE, events_cb1, "EVAS_CALLBACK_HIDE")
    r.event_callback_add(evas.EVAS_CALLBACK_MOVE, events_cb1, "EVAS_CALLBACK_MOVE")
    r.event_callback_add(evas.EVAS_CALLBACK_RESIZE, events_cb1, "EVAS_CALLBACK_RESIZE")
    r.event_callback_add(evas.EVAS_CALLBACK_RESTACK, events_cb1, "EVAS_CALLBACK_RESTACK")
    r.event_callback_add(evas.EVAS_CALLBACK_DEL, events_cb1, "EVAS_CALLBACK_DEL")
    r.event_callback_add(evas.EVAS_CALLBACK_HOLD, events_cb1, "EVAS_CALLBACK_HOLD")
    r.event_callback_add(evas.EVAS_CALLBACK_CHANGED_SIZE_HINTS, events_cb1, "EVAS_CALLBACK_CHANGED_SIZE_HINTS")
    r.event_callback_add(evas.EVAS_CALLBACK_IMAGE_PRELOADED, events_cb1, "EVAS_CALLBACK_IMAGE_PRELOADED")
    r.event_callback_add(evas.EVAS_CALLBACK_IMAGE_UNLOADED, events_cb1, "EVAS_CALLBACK_IMAGE_UNLOADED")
    ##  r.event_callback_add(evas.EVAS_CALLBACK_CANVAS_FOCUS_IN, events_cb1, "EVAS_CALLBACK_CANVAS_FOCUS_IN")
    ##  r.event_callback_add(evas.EVAS_CALLBACK_CANVAS_FOCUS_OUT, events_cb1, "")
    ## r.event_callback_add(evas.EVAS_CALLBACK_RENDER_FLUSH_PRE, events_cb1, "")
    ## r.event_callback_add(evas.EVAS_CALLBACK_RENDER_FLUSH_POST, events_cb1, "")
    ## r.event_callback_add(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_IN, events_cb1, "")
    ## r.event_callback_add(evas.EVAS_CALLBACK_CANVAS_OBJECT_FOCUS_OUT, events_cb1, "")
    
    ## r.event_callback_add(evas.EVAS_CALLBACK_RENDER_PRE, events_cb1, "")
    ## r.event_callback_add(evas.EVAS_CALLBACK_RENDER_POST, events_cb1, "")
    #? r.event_callback_add(evas.EVAS_CALLBACK_IMAGE_RESIZE, events_cb1, "")
    #? r.event_callback_add(evas.EVAS_CALLBACK_DEVICE_CHANGED, events_cb1, "")
    r.show()

    r2 = evas.Rectangle(win.evas, size=(120,70), color=(0,100,0,100), pos=(70,70))
    r2.show()
    
    hbox = elementary.Box(win)
    win.resize_object_add(hbox)
    hbox.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    hbox.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    hbox.horizontal = True
    hbox.show()

    b = elementary.Button(win)
    b.text = "show / hide"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.hide() if r.visible else r.show(), r)
    b.show()

    b = elementary.Button(win)
    b.text = "move"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, t: r.pos_set(r.pos[0] + 1, r.pos[1]), r)
    b.show()

    b = elementary.Button(win)
    b.text = "resize"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.size_set(r.size[0] + 1, r.size[1] + 1), r)
    b.show()

    b = elementary.Button(win)
    b.text = "delete"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.delete(), r)
    b.show()

    b = elementary.Button(win)
    b.text = "raise"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.raise_(), r)
    b.show()

    b = elementary.Button(win)
    b.text = "hints"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b, r: r.size_hint_align_set(0.0, 0.0), r)
    b.show()

    b = elementary.Button(win)
    b.text = "del cbs"
    b.size_hint_align_set(0.5, 1.0)
    hbox.pack_end(b)
    b.callback_clicked_add(btn_del_cbs_cb, r)
    b.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    elementary.init()

    core_evas_object_callbacks_clicked(None)

    elementary.run()
    elementary.shutdown()

