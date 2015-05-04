#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, \
    FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.diskselector import Diskselector


months=["January", "February", "March", "April", "May", "June", "August", "September", "October", "November", "December"]
weekdays=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
months_short=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "logo_small.png")


def disk_create(win, rnd, **kwargs):
    di = Diskselector(win, round_enabled=rnd, **kwargs)
    for m in months:
        if m == "August":
            it = di.item_append(m)
        else:
            di.item_append(m)

    it.selected = True

    return di

def cb_sel(ds, item):
    print("Selected item: " + item.text.encode("utf-8"))


def diskselector_clicked(obj):
    win = StandardWindow("diskselector", "Diskselector test", autodel=True,
        size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    di = disk_create(win, rnd=True, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.first_item.selected = True

    di = disk_create(win, rnd=False, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.first_item.next.selected = True

    di = disk_create(win, rnd=False, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, side_text_max_length=4)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()

    ic = Icon(win, file=ic_file)
    di = Diskselector(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    di.item_append("Sunday", ic)
    for day in weekdays:
        di.item_append(day)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()

    ic = Icon(win, file=ic_file)
    di = Diskselector(win, round_enabled=True, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    di.item_append("머리스타일", ic)
    for lan in ["プロが伝授する", "生上访要求政府", "English", "والشريعة", "עִבְרִית", "Grüßen"]:
        di.item_append(lan)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()

    di = Diskselector(win, display_item_num=5, round_enabled=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    for m in months_short:
        di.item_append(m)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.last_item.selected = True

    di = Diskselector(win, display_item_num=7, round_enabled=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    di.display_item_num = 7
    for i in range(31):
        di.item_append(str(i))
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.last_item.selected = True

    win.show()

if __name__ == "__main__":

    diskselector_clicked(None)

    elementary.run()
