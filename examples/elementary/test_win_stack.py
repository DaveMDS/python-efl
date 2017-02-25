#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, FILL_VERT

from efl import elementary as elm
from efl.elementary import Window, Background, Box, Button, Label


level = 0
popto_win = None

def new_win(stack_top, title):
    global level
    global popto_win

    win = Window("window-stack",
        elm.ELM_WIN_NAVIFRAME_BASIC if level >=3 else elm.ELM_WIN_DIALOG_BASIC, 
        autodel=True, title=title, size=(280, 400))

    bg = Background(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    lb = Label(win, text="Press below to push another window on the stack",
               size_hint_weight=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    box.pack_end(lb)
    lb.show()

    if level == 3:
        popto_win = win

    if level > 7:
        bt = Button(win, text="Pop to level 3", size_hint_fill=FILL_BOTH,
                    size_hint_weight=EXPAND_HORIZ)
        bt.callback_clicked_add(lambda w: popto_win.stack_pop_to())
        box.pack_end(bt)
        bt.show()

    bt = Button(win, text="Push", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(button_pressed_cb, stack_top)
    box.pack_end(bt)
    bt.show()

    return win

def button_pressed_cb(btn, master_win):
    global level

    level += 1
    win = new_win(master_win, "Level %d" % level)
    win.stack_master_id = master_win.stack_id
    win.show()


def window_stack_clicked(obj):
    win = Window("window-stack", elm.ELM_WIN_BASIC, autodel=True,
                 title="Window Stack", size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

    win.stack_base = True

    bg = Background(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    lb = Label(win, text="Press below to push another window on the stack",
               size_hint_weight=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    box.pack_end(lb)
    lb.show()

    bt = Button(win, text="Push", size_hint_align=FILL_HORIZ,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(button_pressed_cb, win)
    box.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    window_stack_clicked(None)
    elm.run()
