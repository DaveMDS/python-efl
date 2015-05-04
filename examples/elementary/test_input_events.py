#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl.evas import EVAS_CALLBACK_KEY_UP
from efl import elementary

from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry, utf8_to_markup
from efl.elementary.window import StandardWindow


def filter_cb(obj, text, data):
    return None

def changed_cb(obj):
    obj.cursor_end_set()

def events_cb(obj, src, event_type, event, data):

    entry = data
    append = entry.entry_append

    append(utf8_to_markup(
        "Obj: %r\n\nSrc: %r\n\nEvent: %s" % (obj, src, event)
        ))
    append("<br><br>Modifiers:<br>")
    append(utf8_to_markup(
        "Control: %s Shift: %s Alt: %s" % (
            event.modifier_is_set("Control"),
            event.modifier_is_set("Shift"),
            event.modifier_is_set("Alt")
            )
        ))

    if event_type == EVAS_CALLBACK_KEY_UP:
        append("<br><br>This event was handled so it won't propagate to a parent of Obj.<br><br>")
        append("---------------------------------------------------------------")
        append("<br><br>")

        return True

    append("<br><br>This event was not handled so it will propagate to a parent of Obj if it has one.<br><br>")
    append("---------------------------------------------------------------")
    append("<br><br>")

    return False

def elm_input_events_clicked(obj, item=None):
    win = StandardWindow("inputevents", "Input Events Test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    entry = Entry(win, scrollable=True, size_hint_align=FILL_BOTH,
        size_hint_weight=(1.0, 0.2))
    entry.text = (
        "This example will show how Elementary input events are handled. "
        "Typing in this entry will log in the entry box below all events "
        "caught by event handlers set to this Entry widget and its parent, "
        "the Window widget. Key up events are checked for in the callback "
        "and won't propagate to a parent widget."
        )
    entry.show()

    log_entry = Entry(win, editable=False, scrollable=True, focus_allow=False,
        size_hint_align=FILL_BOTH, size_hint_weight=(1.0, 0.8))
    log_entry.callback_changed_add(changed_cb)
    log_entry.show()

    btn = Button(win, text="Clear log", focus_allow=False)
    btn.callback_clicked_add(lambda x: setattr(log_entry, "entry", ""))
    btn.show()

    box.pack_end(entry)
    box.pack_end(log_entry)
    box.pack_end(btn)

    entry.elm_event_callback_add(events_cb, log_entry)
    entry.markup_filter_append(filter_cb)
    win.elm_event_callback_add(events_cb, log_entry)

    win.resize(640, 480)
    win.show()

    entry.focus = True


if __name__ == "__main__":

    elm_input_events_clicked(None)

    elementary.run()

