#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.diskselector import Diskselector

months=["January", "February", "March", "April", "May", "June", "August", "September", "October", "November", "December"]
weekdays=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
months_short=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

def disk_create(win, rnd):
    di = Diskselector(win)
    for m in months:
        if m == "August":
            it = di.item_append(m)
        else:
            di.item_append(m)

    it.selected = True
    di.round_enabled = rnd

    return di

def cb_sel(ds, item):
    print(("Selected item: %s" % (item.text.encode("UTF-8"))))


def diskselector_clicked(obj):
    win = Window("diskselector", elementary.ELM_WIN_BASIC)
    win.title = "Diskselector test"
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    vbox = Box(win)
    vbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(vbox)
    vbox.show()

    di = disk_create(win, True)
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.first_item.selected = True

    di = disk_create(win, False)
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.first_item.next.selected = True

    di = disk_create(win, False)
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.side_text_max_length = 4

    ic = Icon(win)
    ic.file = "images/logo_small.png"
    di = Diskselector(win)
    di.item_append("Sunday", ic)
    for day in weekdays:
        di.item_append(day)
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()

    ic = Icon(win)
    ic.file = "images/logo_small.png"
    di = Diskselector(win)
    di.item_append("머리스타일", ic)
    for lan in ["プロが伝授する", "生上访要求政府", "English", "والشريعة", "עִבְרִית", "Grüßen"]:
        di.item_append(lan)
    di.round_enabled = True
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()

    di = Diskselector(win)
    di.display_item_num = 5
    for m in months_short:
        di.item_append(m)
    di.round_enabled = True
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.last_item.selected = True

    di = Diskselector(win)
    di.display_item_num = 7
    for i in range(31):
        di.item_append(str(i))
    di.round_enabled = True
    di.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    di.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    di.callback_selected_add(cb_sel)
    vbox.pack_end(di)
    di.show()
    di.last_item.selected = True


    win.resize(320, 480)
    win.show()


if __name__ == "__main__":
    elementary.init()

    diskselector_clicked(None)

    elementary.run()
    elementary.shutdown()
