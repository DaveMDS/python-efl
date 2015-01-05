#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EVAS_ASPECT_CONTROL_HORIZONTAL, \
    EXPAND_BOTH, EXPAND_HORIZ, EXPAND_VERT, \
    FILL_BOTH, FILL_HORIZ, FILL_VERT
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.list import List
from efl.elementary.icon import Icon
from efl.elementary.slider import Slider


ALIGN_CENTER = 0.5, 0.5
ZERO_WEIGHT = 0.0, 0.0

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


def delay_change_cb(obj, data=None):
    print("delay,changed! slider value : %d" % round(obj.value))

def change_cb(obj, data=None):
    data.value = obj.value

def change_print_cb(obj, data=None):
    print("change to %3.3f" % obj.value)

def bt_0(obj, data=None):
    data.value = 0.0

def bt_1(obj, data=None):
    data.value = 1.0

def bt_p1(obj, data=None):
    data.value += 0.1

def bt_m1(obj, data=None):
    data.value -= 0.1

def step_size_calculate(min_size, max_size):
    steps = max_size - min_size
    if steps:
        step = (1.0 / steps)
    return step

def slider_clicked(obj):
    win = StandardWindow("slider", "Slider", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda x: elementary.exit())
    win.show()

    fr = Frame(win, size_hint_weight=EXPAND_BOTH, style="pad_large")
    win.resize_object_add(fr)
    fr.show()

    bx = Box(win)
    fr.content = bx
    bx.show()

    # disabled horizontal slider
    ic = Icon(bx, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ic.show()

    sl = Slider(bx, text="Disabled", unit_format="%1.1f units", span_size=120,
        min_max=(50, 150), value=80, disabled=True, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    sl.part_content_set("icon", ic)
    bx.pack_end(sl)
    sl.show()

    step = step_size_calculate(0, 9)
    sl = Slider(bx, unit_format="%1.0f units", indicator_format="%1.0f",
        span_size=120, min_max=(0, 9), text="Manual step", step=step,
        size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_HORIZ)
    bx.pack_end(sl)
    sl.show()

    # normal horizontal slider
    ic = Icon(bx, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))

    sl1 = sl = Slider(bx, text="Horizontal", unit_format="%1.1f units",
        indicator_format="%1.1f", span_size=120, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    sl.part_content_set("icon", ic)
    bx.pack_end(sl)
    ic.show()
    sl.show()

    # horizontally inverted slider
    ic = Icon(bx, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ic.show()

    sl = Slider(bx, text="Horizontal inverted", unit_format="%3.0f units",
        span_size=80, indicator_format="%3.0f", min_max=(50, 150), value=80,
        inverted=True, size_hint_align=ALIGN_CENTER,
        size_hint_weight=(0.0, 0.0))
    sl.part_content_set("end", ic)
    sl.callback_delay_changed_add(delay_change_cb)
    bx.pack_end(sl)
    sl.show()

    # disabled horizontally inverted slider
    ic = Icon(bx, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    ic.show()

    sl = Slider(bx, text="Disabled inverted", span_size=80,
        indicator_format="%3.0f", min_max=(50, 150), value=80, inverted=True,
        disabled=True, size_hint_align=ALIGN_CENTER,
        size_hint_weight=(0.0, 0.0))
    sl.part_content_set("end", ic)
    bx.pack_end(sl)
    sl.show()

    # scale doubled slider
    sl = Slider(bx, indicator_show=False, text="Scale doubled",
        unit_format="%3.0f units", span_size=40, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ, indicator_format="%3.0f",
        min_max=(50, 150), value=80, inverted=True, scale=2.0)
    bx.pack_end(sl)
    sl.show()

    # horizontal box
    bx2 = Box(bx, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_VERT, horizontal=True)
    bx.pack_end(bx2)
    bx2.show()

    # vertical inverted slider
    ic = Icon(bx2, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1))
    ic.show()

    sl = Slider(bx2, text="Vertical inverted", inverted=True,
        unit_format="%1.1f units", span_size=60,
        size_hint_align=FILL_VERT,
        size_hint_weight=EXPAND_VERT,
        indicator_format="%1.1f", value=0.2, scale=1.0, horizontal=False)
    sl.part_content_set("icon", ic)
    bx2.pack_end(sl)
    sl.show()

    sl1.callback_changed_add(change_cb, sl)

    # disabled vertical slider
    ic = Icon(bx2, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1))

    sl = Slider(bx2, text="Disabled vertical", inverted=True,
        unit_format="%1.1f units", span_size=100,
        size_hint_align=FILL_VERT,
        size_hint_weight=EXPAND_VERT,
        indicator_format="%1.1f", value=0.2, scale=1.0, horizontal=False)
    #
    # XXX:  If vertical mode is set after disabled, it's no longer disabled.
    #       Elm bug?
    #
    sl.disabled = True

    sl.part_content_set("icon", ic)
    bx2.pack_end(sl)
    sl.show()

    # normal vertical slider
    sl = Slider(bx2, text="Vertical", unit_format="%1.1f units", span_size=60,
        size_hint_align=FILL_VERT,
        size_hint_weight=EXPAND_VERT, indicator_show=False,
        value=0.2, scale=1.0, horizontal=False)
    sl.callback_changed_add(change_print_cb, sl)
    bx2.pack_end(sl)
    sl.show()

    # box for bottom buttons
    bx2 = Box(win,size_hint_weight=EXPAND_HORIZ, horizontal=True)
    bx.pack_end(bx2)
    bx2.show()

    bt = Button(win, text="0")
    bt.callback_clicked_add(bt_0, sl)
    bt.show()
    bx2.pack_end(bt)

    bt = Button(win, text="1")
    bt.callback_clicked_add(bt_1, sl)
    bt.show()
    bx2.pack_end(bt)

    bt = Button(win, text="+0.1")
    bt.callback_clicked_add(bt_p1, sl)
    bt.show()
    bx2.pack_end(bt)

    bt = Button(win, text="-0.1")
    bt.callback_clicked_add(bt_m1, sl)
    bt.show()
    bx2.pack_end(bt)

if __name__ == "__main__":
    elementary.init()

    slider_clicked(None)

    elementary.run()
    elementary.shutdown()

