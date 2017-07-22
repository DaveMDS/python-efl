#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary as elm


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


class MyItemClass(elm.GenlistItemClass):
    def __init__(self):
        elm.GenlistItemClass.__init__(self, item_style="tree_effect")

    def text_get(self, obj, part, item_data):
        return "Item # %i" % item_data

    def content_get(self, obj, part, item_data):
        icon = "logo_small.png" if part == "elm.swallow.icon" else "bubble.png"
        return elm.Icon(obj, file=os.path.join(img_path, icon))

itc = MyItemClass()


def test_genlist_multiselect(parent):
    win = elm.StandardWindow("Genlist", "Genlist Multi Select",
                         size=(320, 500), autodel=True)

    # vertical box + options frame
    box = elm.Box(win, size_hint_expand=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    fr = elm.Frame(win, text='Multi Select Options',
               size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    box.pack_end(fr)
    fr.show()

    hbox = elm.Box(win, horizontal=True, homogeneous=False,
                size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    fr.content = hbox
    hbox.show()

    # Genlist
    gl = elm.Genlist(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box.pack_end(gl)
    gl.show()

    for i in range(100):
        gl.item_append(itc, i)

    # Options
    ck = elm.Check(win, style="toggle", text="Multi Select Enable")
    ck.callback_changed_add(lambda o: setattr(gl, "multi_select", o.state))
    hbox.pack_end(ck)
    ck.show()

    rdg = rd = elm.Radio(win, text="Default mode", state_value=0)
    rd.callback_changed_add(lambda o: setattr(gl, "multi_select_mode",
                                elm.ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT))
    hbox.pack_end(rd)
    rd.show()

    rd = elm.Radio(win, text="With Control mode", state_value=1)
    rd.callback_changed_add(lambda o: setattr(gl, "multi_select_mode",
                                elm.ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL))
    rdg.group_add(rd)
    hbox.pack_end(rd)
    rd.show()

    # show the window
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_multiselect(None)
    elm.run()
