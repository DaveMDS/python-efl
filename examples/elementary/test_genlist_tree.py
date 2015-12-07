#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Check, Icon, Frame, \
    Genlist, GenlistItemClass, ELM_GENLIST_ITEM_TREE


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


class MyItemClass(GenlistItemClass):
    def __init__(self):
        GenlistItemClass.__init__(self, item_style="tree_effect")

    def text_get(self, obj, part, item_data):
        return "Item # %i" % item_data

    def content_get(self, obj, part, item_data):
        if part == 'elm.swallow.icon':
            ic = Icon(obj, file=os.path.join(img_path, "logo_small.png"))
            return ic

itc = MyItemClass()


# list callbacks
def list_expand_request_cb(gl, gli):
    gli.expanded = True

def list_contract_request_cb(gl, gli):
    gli.expanded = False

def list_expanded_cb(gl, gli):
    start = gli.data * 10
    for i in range(start, start + 30):
        gl.item_append(itc, i, gli, flags=ELM_GENLIST_ITEM_TREE)

def list_contracted_cb(gl, gli):
    gli.subitems_clear()


def test_genlist_tree(parent):
    win = StandardWindow("Genlist", "Genlist Tree",
                         size=(320, 320), autodel=True)

    # vertical box + options frame
    box = Box(win, size_hint_expand=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    fr = Frame(win, text='Genlist Tree Options',
               size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    box.pack_end(fr)
    fr.show()

    hbox = Box(win, horizontal=True, homogeneous=True,
               size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    fr.content = hbox
    hbox.show()

    # Genlist
    gl = Genlist(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    gl.callback_expand_request_add(list_expand_request_cb)
    gl.callback_contract_request_add(list_contract_request_cb)
    gl.callback_expanded_add(list_expanded_cb)
    gl.callback_contracted_add(list_contracted_cb)
    box.pack_end(gl)
    gl.show()

    gl.item_append(itc, 1, flags=ELM_GENLIST_ITEM_TREE)
    gl.item_append(itc, 2, flags=ELM_GENLIST_ITEM_TREE)
    gl.item_append(itc, 3)

    # option buttons
    ck = Check(win, text='Tree Effect')
    ck.callback_changed_add(lambda c: setattr(gl, "tree_effect_enabled", c.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text='Homogeneous')
    ck.callback_changed_add(lambda c: setattr(gl, "homogeneous", c.state))
    hbox.pack_end(ck)
    ck.show()

    # show the window
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_tree(None)
    elm.run()
