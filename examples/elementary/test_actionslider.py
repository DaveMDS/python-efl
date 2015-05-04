#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, EXPAND_HORIZ, FILL_BOTH
from efl import elementary
from efl.elementary.actionslider import Actionslider, ELM_ACTIONSLIDER_NONE, \
    ELM_ACTIONSLIDER_ALL, ELM_ACTIONSLIDER_LEFT, ELM_ACTIONSLIDER_CENTER, \
    ELM_ACTIONSLIDER_RIGHT
from efl.elementary.box import Box
from efl.elementary.window import StandardWindow


positions = {
    ELM_ACTIONSLIDER_NONE: "none",
    ELM_ACTIONSLIDER_ALL: "all",
    ELM_ACTIONSLIDER_LEFT: "left",
    ELM_ACTIONSLIDER_CENTER: "center",
    ELM_ACTIONSLIDER_RIGHT: "right"
}

def _pos_selected_cb(obj, event_info):
    print("Selection: {0}".format(event_info))
    print("Label selected: {0}".format(obj.selected_label))
    ipos = obj.indicator_pos
    mpos = obj.magnet_pos
    epos = obj.enabled_pos
    iposs = []
    mposs = []
    eposs = []
    for k, v in positions.items():
        if k == ELM_ACTIONSLIDER_NONE or k == ELM_ACTIONSLIDER_ALL:
            if k == ipos:
                iposs = [v,]
            if k == mpos:
                mposs = [v,]
            if k == epos:
                eposs = [v,]
        else:
            if k & obj.indicator_pos:
                iposs.append(v)
            if k & obj.magnet_pos:
                mposs.append(v)
            if k & obj.enabled_pos:
                eposs.append(v)
    print("actionslider indicator pos: {0}".format(", ".join(iposs)))
    print("actionslider magnet pos: {0}".format(", ".join(mposs)))
    print("actionslider enabled pos: {0}".format(", ".join(eposs)))

def _position_change_magnetic_cb(obj, event_info):
    if event_info == "left":
        obj.magnet_pos = ELM_ACTIONSLIDER_LEFT
    elif event_info == "right":
        obj.magnet_pos = ELM_ACTIONSLIDER_RIGHT

def _magnet_enable_disable_cb(obj, event_info):
    if event_info == "left":
        obj.magnet_pos = ELM_ACTIONSLIDER_CENTER
    elif event_info == "right":
        obj.magnet_pos = ELM_ACTIONSLIDER_NONE

def actionslider_clicked(obj):
    win = StandardWindow("actionslider", "Actionslider")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    acts = Actionslider(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_RIGHT, magnet_pos=ELM_ACTIONSLIDER_RIGHT,
        enabled_pos=(ELM_ACTIONSLIDER_LEFT | ELM_ACTIONSLIDER_RIGHT))
    acts.part_text_set("left", "Snooze")
    acts.part_text_set("center", "")
    acts.part_text_set("right", "Stop")
    acts.callback_pos_changed_add(_position_change_magnetic_cb)
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    acts = Actionslider(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_CENTER,
        magnet_pos=ELM_ACTIONSLIDER_CENTER,
        enabled_pos=(ELM_ACTIONSLIDER_LEFT | ELM_ACTIONSLIDER_RIGHT))
    acts.part_text_set("left", "Snooze")
    acts.part_text_set("center", "")
    acts.part_text_set("right", "Stop")
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    acts = Actionslider(win, style="bar", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_LEFT,
        magnet_pos=(ELM_ACTIONSLIDER_CENTER | ELM_ACTIONSLIDER_RIGHT),
        enabled_pos=(ELM_ACTIONSLIDER_CENTER | ELM_ACTIONSLIDER_RIGHT))
    acts.part_text_set("left", "")
    acts.part_text_set("center", "Accept")
    acts.part_text_set("right", "Reject")
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    acts = Actionslider(win, style="bar", text="Go",
        size_hint_weight=EXPAND_HORIZ, size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_LEFT, magnet_pos=ELM_ACTIONSLIDER_LEFT)
    acts.part_text_set("left", "")
    acts.part_text_set("center", "Accept")
    acts.part_text_set("right", "Reject")
    acts.callback_pos_changed_add(_position_change_magnetic_cb)
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    acts = Actionslider(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_LEFT, magnet_pos=ELM_ACTIONSLIDER_ALL)
    acts.part_text_set("left", "Left")
    acts.part_text_set("center", "Center")
    acts.part_text_set("right", "Right")
    acts.text_set("Go")
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    acts = Actionslider(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0),
        indicator_pos=ELM_ACTIONSLIDER_CENTER,
        magnet_pos=ELM_ACTIONSLIDER_CENTER)
    acts.part_text_set("left", "Enable")
    acts.part_text_set("center", "Magnet")
    acts.part_text_set("right", "Disable")
    acts.callback_pos_changed_add(_magnet_enable_disable_cb)
    acts.callback_selected_add(_pos_selected_cb)
    bx.pack_end(acts)
    acts.show()

    win.resize(320, 400)
    win.show()

if __name__ == "__main__":

    actionslider_clicked(None)

    elementary.run()
