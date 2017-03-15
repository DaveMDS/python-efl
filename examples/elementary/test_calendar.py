#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.calendar_elm import Calendar, \
    ELM_DAY_MONDAY, ELM_DAY_THURSDAY, ELM_DAY_SATURDAY, \
    ELM_CALENDAR_UNIQUE, ELM_CALENDAR_DAILY, ELM_CALENDAR_WEEKLY, \
    ELM_CALENDAR_MONTHLY, ELM_CALENDAR_ANNUALLY, \
    ELM_CALENDAR_SELECT_MODE_NONE, ELM_CALENDAR_SELECT_MODE_ONDEMAND
from efl.elementary.label import Label
from efl.elementary.frame import Frame
from efl.elementary.list import List
from efl.elementary.entry import Entry

from datetime import datetime, timedelta


api = {
    "state" : 0,  # What state we are testing
    "cal" : None     # box used in set_api_state
}

STATE_MARK_MONTHLY = 0
STATE_MARK_WEEKLY = 1
STATE_SUNDAY_HIGHLIGHT = 2
STATE_SELECT_DATE_DISABLED_WITH_MARKS = 3
STATE_SELECT_DATE_DISABLED_NO_MARKS = 4
API_STATE_LAST = 5

def set_api_state(api):
    cal = api["cal"]
    if not cal:
        return
    m = None

    if api["state"] == STATE_MARK_MONTHLY:
        cal.min_max_year = (2010, 2011)
        the_time = datetime(2010, 12, 31)
        m = cal.mark_add("checked", the_time, ELM_CALENDAR_MONTHLY)
        cal.selected_time = the_time
    elif api["state"] == STATE_MARK_WEEKLY:
        the_time = datetime(2010, 12, 26)
        if m is not None:
            m.delete()
        m = cal.mark_add("checked", the_time, ELM_CALENDAR_WEEKLY)
        cal.selected_time = the_time
    elif api["state"] == STATE_SUNDAY_HIGHLIGHT:
        the_time = datetime(2010, 12, 25)
        # elm_calendar_mark_del(m)
        m = cal.mark_add("holiday", the_time, ELM_CALENDAR_WEEKLY)
        cal.selected_time = the_time
    elif api["state"] == STATE_SELECT_DATE_DISABLED_WITH_MARKS:
        the_time = datetime(2011, 1, 1)
        cal.select_mode = ELM_CALENDAR_SELECT_MODE_NONE
        cal.selected_time = the_time
    elif api["state"] == STATE_SELECT_DATE_DISABLED_NO_MARKS:
        the_time = datetime(2011, 2, 1)
        del cal.marks
        cal.select_mode = ELM_CALENDAR_SELECT_MODE_NONE
        cal.selected_time = the_time
    elif api["state"] == API_STATE_LAST:
        return
    else:
        return

def api_bt_clicked(bt, a):
    print("clicked event on API Button: api_state=<%d>\n" % a["state"])
    set_api_state(a)
    a["state"] += 1
    bt.text = "Next API function (%d)" % a["state"]
    if a["state"] == API_STATE_LAST:
        bt.disabled = True

# A simple test, just displaying calendar in it's default state
def calendar_clicked(obj, item=None):
    win = StandardWindow("calendar", "Calendar", autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bt = Button(bx, text="Next API function")
    bt.callback_clicked_add(api_bt_clicked, api)
    bx.pack_end(bt)
    if api["state"] == API_STATE_LAST:
        bt.disabled = True
    bt.show()

    the_time = datetime(2010, 12, 31)
    cal = Calendar(bx, first_day_of_week=ELM_DAY_MONDAY,
        size_hint_weight=EXPAND_BOTH, selected_time=the_time,
        min_max_year=(2010,2012))
    api["cal"] = cal
    bx.pack_end(cal)
    cal.show()

    win.show()


def print_cal_info(cal, en):
    stm = cal.selected_time
    if not stm:
        return

    sel_enabled = True if cal.select_mode != ELM_CALENDAR_SELECT_MODE_NONE else False
    wds = cal.weekdays_names

    info = (
        "  Day: %i, Mon: %i, Year %i, WeekDay: %i<br>"
        "  Interval: %0.2f, Sel Enabled : %s<br>"
        "  Date Min: %s, Date Max: %s <br>"
        "  Weekdays: %s, %s, %s, %s, %s, %s, %s<br>" % (
            stm.day, stm.month, stm.year, stm.weekday(),
            cal.interval, sel_enabled,
            cal.date_min, cal.date_max,
            wds[0], wds[1], wds[2], wds[3], wds[4], wds[5], wds[6]
            )
        )

    en.text = info

def print_cal_info_cb(obj, data):
    print_cal_info(obj, data)

# def format_month_year(stm):
#     return "%b %y" % stm

# A test intended to cover all the calendar api and much use cases as possible
def calendar2_clicked(obj, item=None):
    weekdays = [
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    ]

    win = StandardWindow("calendar2", "Calendar 2", autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bxh = Box(bx, horizontal=True, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    bxh.show()
    bx.pack_end(bxh)

    # Wide cal
    cal = Calendar(bx, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH, weekdays_names=weekdays,
        first_day_of_week=ELM_DAY_SATURDAY, interval=0.4,
        date_min=datetime(2012, 12, 7), date_max=datetime(2020, 1, 3))
    cal.show()
    bx.pack_end(cal)

    # Top left cal
    cal2 = Calendar(bxh, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH, select_mode=ELM_CALENDAR_SELECT_MODE_NONE)
    cal2.show()
    bxh.pack_end(cal2)

    # Top right cal
    cal3 = Calendar(bxh, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)

    selected_time = datetime.now() + timedelta(34)
    cal3.selected_time = selected_time

    selected_time = datetime.now() + timedelta(1)
    cal3.mark_add("checked", selected_time, ELM_CALENDAR_UNIQUE)

    del(cal3.marks)
    selected_time = datetime.now()
    cal3.mark_add("checked", selected_time, ELM_CALENDAR_DAILY)
    cal3.mark_add("holiday", selected_time, ELM_CALENDAR_DAILY)
    cal3.marks_draw()
    cal3.show()
    bxh.pack_end(cal3)

    en = Entry(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        editable=False)
    en.show()
    bx.pack_end(en)
    win.show()

    cal3.min_max_year = (-1, -1)

    # TODO: cal.format_function_set(format_month_year)

    selected_time = datetime.now() + timedelta(4)
    cal.mark_add("holiday", selected_time, ELM_CALENDAR_ANNUALLY)

    selected_time = datetime.now() + timedelta(1)
    cal.mark_add("checked", selected_time, ELM_CALENDAR_UNIQUE)

    selected_time = datetime.now() - timedelta(363)
    cal.mark_add("checked", selected_time, ELM_CALENDAR_MONTHLY)

    selected_time = datetime.now() - timedelta(5)
    mark = cal.mark_add("holiday", selected_time, ELM_CALENDAR_WEEKLY)

    selected_time = datetime.now() + timedelta(1)
    cal.mark_add("holiday", selected_time, ELM_CALENDAR_WEEKLY)

    mark.delete()
    cal.marks_draw()

    print_cal_info(cal, en)
    cal.callback_changed_add(print_cal_info_cb, en)

def calendar3_clicked(obj, item=None):
    win = StandardWindow("calendar", "Calendar", autodel=True)

    bxx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bxx)
    bxx.show()

    selected_time = datetime.now() + timedelta(34)

    cal = Calendar(win, size_hint_weight=EXPAND_BOTH,
        first_day_of_week=ELM_DAY_THURSDAY,
        select_mode=ELM_CALENDAR_SELECT_MODE_ONDEMAND,
        selected_time=selected_time)

    bxx.pack_end(cal)

    cal.show()

    win.show()

if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [
        ("Calendar", calendar_clicked),
        ("Calendar 2", calendar2_clicked),
        ("Calendar 3", calendar3_clicked)
        ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
