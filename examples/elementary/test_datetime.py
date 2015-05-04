#!/usr/bin/env python
# encoding: utf-8


from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, \
    FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.datetime_elm import Datetime, ELM_DATETIME_MINUTE, \
    ELM_DATETIME_HOUR, ELM_DATETIME_AMPM, ELM_DATETIME_DATE, \
    ELM_DATETIME_MONTH, ELM_DATETIME_YEAR

from datetime import datetime


def changed_cb(obj):
    print("Datetime value is changed")

def datetime_clicked(obj):
    win = StandardWindow("dt", "DateTime")
    win.autodel = True

    bx = Box(win, size_hint_weight=EXPAND_BOTH, horizontal=False,
        size_hint_min=(360, 240))
    win.resize_object_add(bx)
    bx.show()

    dt = Datetime(bx, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    dt.field_visible_set(ELM_DATETIME_HOUR, False)
    dt.field_visible_set(ELM_DATETIME_MINUTE, False)
    dt.field_visible_set(ELM_DATETIME_AMPM, False)
    bx.pack_end(dt)
    dt.show()

    dt = Datetime(bx, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)
    dt.field_visible_set(ELM_DATETIME_YEAR, False)
    dt.field_visible_set(ELM_DATETIME_MONTH, False)
    dt.field_visible_set(ELM_DATETIME_DATE, False)
    bx.pack_end(dt)
    dt.show()

    dt = Datetime(bx, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_HORIZ)

    # get the current local time
    time1 = datetime.now()
    # set the max year as 2030 and the remaining fields are equal to current time values
    time1.replace(year = 130)
    dt.value_max = time1
    # set the min time limit as "1980 January 10th 02:30 PM"
    time1.replace(year = 80, month = 4, day = 10, hour = 14, minute = 30)
    dt.value_min = time1
    # minutes can be input only in between 15 and 45
    dt.field_limit_set(ELM_DATETIME_MINUTE, 15, 45)
    dt.callback_changed_add(changed_cb)
    bx.pack_end(dt)
    dt.show()

    win.show()

if __name__ == "__main__":

    datetime_clicked(None)

    elementary.run()
