#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, \
    FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box

# XXX:  Check needs to be imported here to make part_content_get work.
#
#       We should make object_from_instance more intelligent,
#       importing on demand.
from efl.elementary.check import Check

from efl.elementary.dayselector import Dayselector, ELM_DAYSELECTOR_SUN, \
    ELM_DAYSELECTOR_MON, ELM_DAYSELECTOR_TUE, ELM_DAYSELECTOR_WED, \
    ELM_DAYSELECTOR_THU, ELM_DAYSELECTOR_FRI, ELM_DAYSELECTOR_SAT


def cb_changed(ds):
    print("\nSelected Days:")
    print("Sun: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_SUN)))
    print("Mon: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_MON)))
    print("Tue: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_TUE)))
    print("Wed: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_WED)))
    print("Thu: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_THU)))
    print("Fri: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_FRI)))
    print("Sat: {0}".format(ds.day_selected_get(ELM_DAYSELECTOR_SAT)))


def dayselector_clicked(obj):
    win = StandardWindow("dayselector", "Dayselector test", autodel=True,
        size=(350, 120))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(box)
    box.show()

    # default
    ds = Dayselector(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    box.pack_end(ds)
    ds.show()
    ds.callback_dayselector_changed_add(cb_changed)

    # Sunday first
    ds = Dayselector(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, week_start=ELM_DAYSELECTOR_SUN)
    box.pack_end(ds)
    ds.show()
    ds.callback_dayselector_changed_add(cb_changed)
    sunday = ds.part_content_get("day0")
    sunday.signal_emit("elm,type,weekend,style1", "")

    # Monday first
    ds = Dayselector(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, week_start=ELM_DAYSELECTOR_MON)
    ds.callback_dayselector_changed_add(cb_changed)
    box.pack_end(ds)
    ds.show()
    sunday = ds.part_content_get("day0")
    sunday.signal_emit("elm,type,weekend,style1", "")

    win.show()


if __name__ == "__main__":

    dayselector_clicked(None)

    elementary.run()

