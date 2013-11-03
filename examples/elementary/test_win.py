#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.slider import Slider

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_HORIZ = EVAS_HINT_FILL, 0.5

def cb_alpha(bt, win, bg, on):
    win.alpha = on
    print("alpha: %s" % win.alpha)

    bg.hide() if on else bg.show()

def cb_fullscreen(bt, win, fs):
    win.fullscreen = fs
    print("fullscreen: %s" % win.fullscreen)

def cb_rot(bt, win, ck, rot):
    if ck.state:
        win.rotation_with_resize_set(rot)
    else:
        win.rotation = rot

def cb_win_moved(win):
    print("MOVE - win geom: x %d, y %d, w %d, h %d" % win.geometry)

def window_states_clicked(obj):
    win = Window("window-states", ELM_WIN_BASIC,
        title="Window States test", autodel=True, size=(280, 400))
    win.callback_moved_add(cb_win_moved)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    print(win.available_profiles)

    bg = Background(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    for state in [True, False]:
        bt = Button(win, text="Alpha " + ("On" if state else "Off"),
            size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_HORIZ)
        bt.callback_clicked_add(cb_alpha, win, bg, state)
        hbox.pack_end(bt)
        bt.show()

    for state in [True, False]:
        bt = Button(win, text="FS " + ("On" if state else "Off"),
            size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_HORIZ)
        bt.callback_clicked_add(cb_fullscreen, win, state)
        hbox.pack_end(bt)
        bt.show()

    sl = Slider(win, text="Visual test", indicator_format="%3.0f",
        min_max=(50, 150), value=50, inverted=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=(0.5, EVAS_HINT_FILL))
    vbox.pack_end(sl)
    sl.show()

    ck = Check(win, text="Resize on rotate", size_hint_align=(0.0, 0.0))
    vbox.pack_end(ck)
    ck.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    for rot in [0, 90, 180, 270]:
        bt = Button(win, text="Rot " + str(rot), size_hint_align=FILL_HORIZ,
            size_hint_weight=EXPAND_HORIZ)
        bt.callback_clicked_add(cb_rot, win, ck, rot)
        hbox.pack_end(bt)
        bt.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    window_states_clicked(None)

    elementary.run()
    elementary.shutdown()

