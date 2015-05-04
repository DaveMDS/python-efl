#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.notify import Notify
from efl.elementary.label import Label
from efl.elementary.entry import Entry, utf8_to_markup
from efl.elementary.need import need_sys_notify
from efl.elementary.general import on_sys_notify_action_invoked, \
    on_sys_notify_notification_closed, sys_notify_send
from efl.ecore import ECORE_CALLBACK_DONE


def _ev_handler(event, l, n):
    print(event)
    l.text = utf8_to_markup(str(event))
    n.show()

    return ECORE_CALLBACK_DONE


def _bt_clicked(obj, s, b):
    sys_notify_send(icon="", summary=s.entry, body=b.entry)


def sys_notify_clicked(obj):

    if not need_sys_notify():
        raise SystemExit("Sys notify not available")

    win = StandardWindow(
        "sys_notify", "Sys notify test", autodel=True, size=(320, 160)
        )
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    l = Label(win)
    l.show()

    n = Notify(
        win, size_hint_weight=EXPAND_BOTH, align=(0.5, 0.0), timeout=2.0,
        content=l
        )

    on_sys_notify_action_invoked(_ev_handler, l, n)
    on_sys_notify_notification_closed(_ev_handler, l, n)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    s = Entry(
        win, single_line=True, scrollable=True, entry="Summary",
        size_hint_align=FILL_BOTH
        )
    bx.pack_end(s)
    s.show()

    b = Entry(
        win, single_line=True, scrollable=True, entry="Body long description.",
        size_hint_align=FILL_BOTH
        )
    bx.pack_end(b)
    b.show()

    it = Button(win, text="Send Notification")
    it.callback_clicked_add(_bt_clicked, s, b)
    bx.pack_end(it)
    it.show()

    win.show()

if __name__ == "__main__":

    sys_notify_clicked(None)

    elementary.run()
