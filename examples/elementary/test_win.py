#!/usr/bin/env python
# encoding: utf-8

from efl.ecore import Timer
from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, FILL_VERT
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.slider import Slider


def cb_alpha(ck, win, bg):
    win.alpha = ck.state
    print("alpha: %s" % win.alpha)
    bg.hide() if ck.state is True else bg.show()

def cb_rot(bt, win, ck, rot):
    if ck.state:
        win.rotation_with_resize_set(rot)
    else:
        win.rotation = rot

def cb_iconify_and_activate(bt, win):
    win.iconified = True
    Timer(3.0, lambda: win.activate())

def cb_iconify_and_deiconify(bt, win):
    win.iconified = True
    Timer(3.0, lambda: win.iconified_set(False))

def cb_win_moved(win):
    print("MOVE - win geom: x %d, y %d, w %d, h %d" % win.geometry)

def set_and_report(win, prop, val):
    setattr(win, prop, val)
    print("Property: '%s' is now: '%s'" % (prop, getattr(win, prop)))

def window_states_clicked(obj):
    win = Window("window-states", ELM_WIN_BASIC, autodel=True,
                 title="Window States test", size=(280, 400))
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

    hbox = Box(win, horizontal=True, size_hint_align=FILL_HORIZ,
               size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Lower", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: win.lower())
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Iconify and Activate", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_iconify_and_activate, win)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Iconify and Deiconify", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_iconify_and_deiconify, win)
    hbox.pack_end(bt)
    bt.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_HORIZ,
               size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Move 0 0", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: win.move(0,0))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Move 20 20", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: win.move(20,20))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Center", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: win.center(True, True))
    hbox.pack_end(bt)
    bt.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_HORIZ,
               size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="Alpha")
    ck.callback_changed_add(cb_alpha, win, bg)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="Borderless")
    ck.callback_changed_add(lambda c: set_and_report(win, 'borderless', c.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="Fullscreen")
    ck.callback_changed_add(lambda c: set_and_report(win, 'fullscreen', c.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="NoBlank")
    ck.callback_changed_add(lambda c: set_and_report(win, 'noblank', c.state))
    hbox.pack_end(ck)
    ck.show()

    sl = Slider(win, text="Visual test", indicator_format="%3.0f",
                min_max=(50, 150), value=50, inverted=True,
                size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
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

    window_states_clicked(None)

    elementary.run()

