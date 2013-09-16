#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import ecore
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.icon import Icon
from efl.elementary.progressbar import Progressbar


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
    pb8.part_value_set("elm.cur.progressbar", progress * 1.50)
    pb8.part_value_set("elm.cur.progressbar1", progress)
    if progress < 1.0:
        return ecore.ECORE_CALLBACK_RENEW
    global my_progressbar_run
    my_progressbar_run = False
    return ecore.ECORE_CALLBACK_CANCEL

def begin_test(obj, *args, **kwargs):
    (pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8) = args
    pb2.pulse(True)
    pb5.pulse(True)
    pb7.pulse(True)
    global my_progressbar_run
    global my_progressbar_timer
    if not my_progressbar_run:
        my_progressbar_timer = ecore.timer_add(0.1, pb_timer_cb,
                                               *args)
        my_progressbar_run = True

def end_test(obj, pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8):
    pb2.pulse(False)
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

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.show()

    pb1 = Progressbar(win)
    pb1.span_size = 300
    pb1.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    pb1.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    bx.pack_end(pb1)
    pb1.show()

    pb2 = Progressbar(win)
    pb2.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    pb2.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb2.text = "Infinite bounce"
    pb2.pulse_mode = True
    bx.pack_end(pb2)
    pb2.show()

    ic1 = Icon(win)
    ic1.file = 'images/logo_small.png'
    ic1.size_hint_aspect = evas.EVAS_ASPECT_CONTROL_VERTICAL, 1, 1

    pb3 = Progressbar(win)
    pb3.text = "Inverted"
    pb3.content = ic1
    pb3.inverted = True
    pb3.unit_format = "%1.1f units"
    pb3.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb3.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(pb3)
    ic1.show()
    pb3.show()

    pb8 = Progressbar(win)
    pb8.style = "recording"
    pb8.text = "Style: recording"
    pb8.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb8.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(pb8)
    pb8.show()

    hbx = Box(win)
    hbx.horizontal = True
    hbx.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    hbx.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    bx.pack_end(hbx)
    hbx.show()

    pb4 = Progressbar(win)
    pb4.horizontal = False
    pb4.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    pb4.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    hbx.pack_end(pb4)
    pb4.span_size = 60
    pb4.text = "Vertical"
    pb4.show()

    pb5 = Progressbar(win)
    pb5.horizontal = False
    pb5.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb5.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    pb5.span_size = 120
    pb5.pulse_mode = True
    pb5.unit_format = None
    pb5.text = "Infinite bounce"
    hbx.pack_end(pb5)
    pb5.show()

    ic2 = Icon(win)
    ic2.file = 'images/logo_small.png'
    ic2.size_hint_aspect = evas.EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1

    pb6 = Progressbar(win)
    pb6.horizontal = False
    pb6.text = "Inverted"
    pb6.content = ic2
    pb6.inverted = True
    pb6.unit_format = "%1.2f%%"
    pb6.span_size = 200
    pb6.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb6.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    hbx.pack_end(pb6)
    ic2.show()
    pb6.show()

    pb7 = Progressbar(win)
    pb7.style = "wheel"
    pb7.text = "Style: wheel"
    pb7.pulse_mode = True
    pb7.size_hint_align = evas.EVAS_HINT_FILL, 0.5
    pb7.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(pb7)
    pb7.show()

    bt_bx = Box(win)
    bt_bx.horizontal = True
    bt_bx.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    bx.pack_end(bt_bx)
    bt_bx.show()

    pbt = (pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8)

    bt = Button(win)
    bt.text = "Start"
    bt.callback_clicked_add(begin_test, *pbt)
    bt_bx.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text = "Stop"
    bt.callback_clicked_add(end_test, *pbt)
    bt_bx.pack_end(bt)
    bt.show()

    win.callback_delete_request_add(clean_up, *pbt)
    win.show()


if __name__ == "__main__":
    elementary.init()

    progressbar_clicked(None)

    elementary.run()
    elementary.shutdown()
