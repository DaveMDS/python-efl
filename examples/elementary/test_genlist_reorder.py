#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, Box, Check, Label, Frame, \
    Genlist, GenlistItemClass


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


class MyItemClass(GenlistItemClass):
    def text_get(self, obj, part, data):
        if part == "elm.text":
            return "Item # %d" % data

    def content_get(self, obj, part, data):
        if part == "elm.swallow.icon":
            return Icon(obj, file=os.path.join(img_path, "logo_small.png"))


def genlist11_focus_highlight_ck_changed_cb(chk, win):
    win.focus_highlight_enabled = chk.state

def genlist11_reorder_tg_changed_cb(chk, gl):
    gl.reorder_mode = chk.state


def test_genlist_reorder(parent):
    win = StandardWindow("genlist-reorder", "Genlist Reorder Mode",
                         size=(350,500), autodel=True)

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    lb = Label(win)
    lb.text = "<align=left>Enable reorder mode if you want to move items.<br>" \
              "To move longress with mouse.</align>"
    fr = Frame(win, text="Reorder Mode", content=lb,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(fr)
    fr.show()

    hbx = Box(win, horizontal=True, padding=(20,0),
              size_hint_weight=EXPAND_HORIZ)
    bx.pack_end(hbx)
    hbx.show()

    tg = Check(win, style="toggle", text="Reorder Mode:")
    tg.callback_changed_add(genlist11_reorder_tg_changed_cb, gl)
    hbx.pack_end(tg)
    tg.show()

    ck = Check(win, text="Focus Highlight")
    ck.state = win.focus_highlight_enabled
    ck.callback_changed_add(genlist11_focus_highlight_ck_changed_cb, win)
    hbx.pack_end(ck)
    ck.show()

    itc = MyItemClass()
    for i in range(1,50):
        gl.item_append(itc, i)
    bx.pack_end(gl)
    gl.show()

    win.show()
  


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_reorder(None)
    elm.run()
