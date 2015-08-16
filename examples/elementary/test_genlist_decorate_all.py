#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, Box, Button, Check, \
    Genlist, GenlistItem, GenlistItemClass


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


def edit_icon_clicked_cb(ic, item_data):
    item = item_data[2]
    item.delete()

# genlist items class
class MyItemClass(GenlistItemClass):
    def text_get(self, obj, part, item_data):
        return "Item #%i" % (item_data[0])

    def content_get(self, obj, part, item_data):
        # "edit" EDC layout is like below. each part is swallow part.
        # the existing item is swllowed to elm.swallow.edit.content part.
        # --------------------------------------------------------------------
        # | elm.edit.icon.1 | elm.swallow.decorate.content | elm.edit.icon,2 |
        # --------------------------------------------------------------------

        if part == "elm.swallow.end":
            return Icon(obj, file=os.path.join(img_path, "bubble.png"),
                        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
        elif part == "elm.edit.icon.1":
            checked = item_data[1]
            return Check(obj, state=checked)
        elif part == "elm.edit.icon.2":
            ic = Icon(obj, file=os.path.join(img_path, "icon_06.png"),
                      propagate_events=False,
                      size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
            ic.callback_clicked_add(edit_icon_clicked_cb, item_data)
            return ic

    def delete(self, obj, item_data):
        print("item deleted.")


# genlist callbacks
def gl_item_selected_cb(gl, it):
    if gl.decorate_mode:
        checked = it.data[1]
        it.data[1] = not checked
        it.update()

def deco_all_mode_cb(btn, gl):
    gl.decorate_mode = True
    gl.select_mode = elm.ELM_OBJECT_SELECT_MODE_ALWAYS

def deco_normal_mode_cb(btn, gl):
    gl.decorate_mode = False
    gl.select_mode = elm.ELM_OBJECT_SELECT_MODE_DEFAULT


def test_genlist_decorate_all(parent):
    win = StandardWindow("Genlist", "Genlist Decorate All Mode",
                         size=(520,520), autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.callback_selected_add(gl_item_selected_cb)
    bx.pack_end(gl)
    gl.show()

    itc = MyItemClass(item_style="default", decorate_all_item_style="edit")

    for i in range(100):
        item_data = [i, False]
        it = gl.item_append(itc, item_data)
        item_data.append(it)


    bx2 = Box(win, horizontal=True, homogeneous=True,
              size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(bx2)
    bx2.show()

    bt = Button(win, text="Decorate All mode", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(deco_all_mode_cb, gl)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Normal mode", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(deco_normal_mode_cb, gl)
    bx2.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_decorate_all(None)
    elm.run()
