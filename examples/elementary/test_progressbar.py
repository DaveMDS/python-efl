#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EVAS_ASPECT_CONTROL_HORIZONTAL, FilledImage, \
    EXPAND_BOTH, FILL_BOTH, FILL_HORIZ
from efl.ecore import Timer, ECORE_CALLBACK_RENEW, ECORE_CALLBACK_CANCEL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.icon import Icon
from efl.elementary.progressbar import Progressbar


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


my_progressbar_run = False
my_progressbar_timer = None

def pb_timer_cb(pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8):
    progress = pb1.value_get()
    if progress < 1.0:
        progress += 0.0123
    else:
        progress = 0.0
    pb1.value_set(progress)
    pb4.value_set(progress)
    pb3.value_set(progress)
    pb6.value_set(progress)
    pb8.part_value_set("elm.cur.progressbar", progress)
    pb8.part_value_set("elm.cur.progressbar1", progress * 1.50)
    if progress < 1.0:
        return ECORE_CALLBACK_RENEW
    global my_progressbar_run
    my_progressbar_run = False
    return ECORE_CALLBACK_CANCEL

def begin_test(obj, *args, **kwargs):
    (pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8) = args
    print("Pbar 2 is_pulsing: %s" % (pb2.is_pulsing))
    pb2.pulse(True)
    print("Pbar 2 is_pulsing: %s" % (pb2.is_pulsing))
    pb5.pulse(True)
    pb7.pulse(True)
    global my_progressbar_run
    global my_progressbar_timer
    if not my_progressbar_run:
        my_progressbar_timer = Timer(0.1, pb_timer_cb, *args)
        my_progressbar_run = True

def end_test(obj, pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8):
    print("Pbar 2 is_pulsing: %s" % (pb2.is_pulsing))
    pb2.pulse(False)
    print("Pbar 2 is_pulsing: %s" % (pb2.is_pulsing))
    pb5.pulse(False)
    pb7.pulse(False)
    global my_progressbar_run
    global my_progressbar_timer
    if my_progressbar_run:
        my_progressbar_timer.delete()
        my_progressbar_run = False

def clean_up(obj, *args):
    end_test(None, *args)
    obj.delete()

def progressbar_clicked(obj):
    win = StandardWindow("progressbar", "Progressbar test")
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    pb1 = Progressbar(win, span_size=300, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(pb1)
    pb1.show()

    pb2 = Progressbar(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, text="Infinite bounce", pulse_mode=True)
    bx.pack_end(pb2)
    pb2.show()

    ic1 = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))

    pb3 = Progressbar(win, text="Inverted", content=ic1, inverted=True,
        unit_format="%1.1f units", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    bx.pack_end(pb3)
    ic1.show()
    pb3.show()

    pb8 = Progressbar(win, style="double", text="Style: double",
        size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_BOTH)
    bx.pack_end(pb8)
    pb8.show()

    hbx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    bx.pack_end(hbx)
    hbx.show()

    pb4 = Progressbar(win, horizontal=False, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH, span_size=60, text="Vertical")
    hbx.pack_end(pb4)
    pb4.show()

    pb5 = Progressbar(win, horizontal=False, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, span_size=120, pulse_mode=True,
        unit_format=None, text="Infinite bounce")
    hbx.pack_end(pb5)
    pb5.show()

    ic2 = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1))

    pb6 = Progressbar(win, horizontal=False, text="Inverted", content=ic2,
        inverted=True, unit_format="%1.2f%%", span_size=200,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    hbx.pack_end(pb6)
    ic2.show()
    pb6.show()

    pb7 = Progressbar(win, style="wheel", text="Style: wheel", pulse_mode=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    bx.pack_end(pb7)
    pb7.show()

    bt_bx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    bx.pack_end(bt_bx)
    bt_bx.show()

    pbt = (pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8)

    bt = Button(win, text="Start")
    bt.callback_clicked_add(begin_test, *pbt)
    bt_bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Stop")
    bt.callback_clicked_add(end_test, *pbt)
    bt_bx.pack_end(bt)
    bt.show()

    win.callback_delete_request_add(clean_up, *pbt)
    win.show()


if __name__ == "__main__":

    progressbar_clicked(None)

    elementary.run()
