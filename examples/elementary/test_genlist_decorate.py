#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, Box, Frame, Radio, \
    Genlist, GenlistItem, GenlistItemClass

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


# genlist items class
class MyItemClass(GenlistItemClass):
    def text_get(self, obj, part, item_data):
        if part == "elm.text.mode":
            return "Mode # %i" % item_data
        else:
            return "Item # %i" % item_data

    def content_get(self, obj, part, item_data):
        ic = Icon(obj)
        if part == "elm.swallow.end":
            f = os.path.join(img_path, "bubble.png")
        else:
            f = os.path.join(img_path, "logo_small.png")
        ic.file = f
        ic.size_hint_aspect = EVAS_ASPECT_CONTROL_VERTICAL, 1, 1
        return ic

mode_type = ["slide", "rotate"]

# genlist callbacks
def gl_selected_cb(gl, it, rdg):
    val = rdg.value
    if val == 1:
        it.decorate_mode_set(mode_type[val], True)

def gl_drag_start_right_cb(obj, it, rdg):
    val = rdg.value
    if val == 0:
        it.decorate_mode_set(mode_type[val], True)

def gl_drag_start_left_cb(obj, it, rdg):
    val = rdg.value
    if val == 0:
        it.decorate_mode_set(mode_type[val], False)

def gl_drag_end_cb(obj, it, rdg):
    print("drag")
    val = rdg.value
    glit = obj.decorated_item
    if glit:
        glit.decorate_mode_set(mode_type[val], False)


def test_genlist_decorate(parent):
    win = StandardWindow("Genlist", "Genlist Decorate Item Mode",
                         size=(520,520), autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bx2 = Box(win)
    bx2.show()

    fr = Frame(win, text="Decorate Item Mode Type", content=bx2)
    bx.pack_end(fr)
    fr.show()

    rdg = Radio(win, size_hint_weight=EXPAND_BOTH, state_value=0,
               text="Slide : Sweep genlist items to the right.")
    rdg.show()
    bx2.pack_end(rdg)

    rd = Radio(win, size_hint_weight=EXPAND_BOTH, state_value=1,
        text = "Rotate : Click each item.")
    rd.group_add(rdg)
    rd.show()
    bx2.pack_end(rd)

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.callback_selected_add(gl_selected_cb, rdg)
    gl.callback_drag_start_right_add(gl_drag_start_right_cb, rdg)
    gl.callback_drag_start_left_add(gl_drag_start_left_cb, rdg)
    gl.callback_drag_start_up_add(gl_drag_end_cb, rdg)
    gl.callback_drag_start_down_add(gl_drag_end_cb, rdg)
    bx.pack_end(gl)
    gl.show()

    itc = MyItemClass(item_style="default", decorate_item_style="mode")

    for i in range(1000, 1050):
        gl.item_append(itc, i)

    win.size = 520, 520
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_decorate(None)
    elm.run()
