#!/usr/bin/env python
# encoding: utf-8

from __future__ import print_function

from efl.evas import EXPAND_BOTH, FILL_BOTH

from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.notify import Notify
from efl.elementary.label import Label
from efl.elementary.general import policy_get, policy_set, on_policy_changed, \
    ELM_POLICY_QUIT, ELM_POLICY_EXIT, ELM_POLICY_THROTTLE, ELM_POLICY_LAST, \
    ELM_POLICY_QUIT_NONE, ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

win = None


policy_mapping = {
    ELM_POLICY_QUIT: "ELM_POLICY_QUIT",
    ELM_POLICY_EXIT: "ELM_POLICY_EXIT",
    ELM_POLICY_THROTTLE: "ELM_POLICY_THROTTLE",
    ELM_POLICY_LAST: "ELM_POLICY_LAST"
}

policy_quit_value_mapping = {
    ELM_POLICY_QUIT_NONE: "ELM_POLICY_QUIT_NONE",
    ELM_POLICY_QUIT_LAST_WINDOW_CLOSED: "ELM_POLICY_QUIT_LAST_WINDOW_CLOSED"
}


@on_policy_changed
def policy_changed(ev):
    text = "policy changed: %s<br>new value: %s<br>old value: %s" % (
        policy_mapping[ev.policy],
        policy_quit_value_mapping[ev.new_value],
        policy_quit_value_mapping[ev.old_value])
    n = Notify(win, timeout=5)
    l = Label(n, text=text)
    n.content = l
    l.show()
    n.show()


def core_ecore_events_in_elm_clicked(obj, item=None):
    global win
    win = StandardWindow(
        "ecoreevents", "Ecore events in Elm", autodel=True,
        size=(480, 240))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    hbox = Box(
        win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        horizontal=True)
    win.resize_object_add(hbox)
    hbox.show()

    b = Button(win, text="change quit policy", size_hint_align=(0.5, 1.0))
    hbox.pack_end(b)

    def policy_change(btn):
        old_value = bool(policy_get(ELM_POLICY_QUIT))
        new_value = not old_value
        policy_set(ELM_POLICY_QUIT, new_value)
        print("changing policy: %s\nnew value: %s\nold value: %s" % (
            "ELM_POLICY_QUIT",
            policy_quit_value_mapping[new_value],
            policy_quit_value_mapping[old_value]))

    b.callback_clicked_add(policy_change)
    b.show()

    win.show()


if __name__ == "__main__":

    core_ecore_events_in_elm_clicked(None)

    elementary.run()
