#!/usr/bin/env python
# encoding: utf-8

import os

from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Button, Icon, Naviframe, Photo
from efl.evas import EXPAND_BOTH, FILL_BOTH


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def navi_pop(bt, nf):
    nf.item_pop()

def title_visible(obj, item):
    item.title_enabled = (not item.title_enabled, True)

def page2(bt, nf):
    ic = Icon(nf, file=os.path.join(img_path, "icon_right_arrow.png"))

    bt = Button(nf, content=ic)
    bt.callback_clicked_add(page3, nf)

    content = Photo(nf, file=os.path.join(img_path, "plant_01.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 2", None, bt, content, "basic")
    item.part_text_set("subtitle", "Here is sub-title part!")

def page3(bt, nf):
    bt = Button(nf, text="Prev")
    bt.callback_clicked_add(navi_pop, nf)

    bt2 = Button(nf, text="Next")
    bt2.callback_clicked_add(page4, nf)

    content = Photo(nf, file=os.path.join(img_path, "rock_01.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 3", bt, bt2, content, "basic")

    ic = Icon(nf, file=os.path.join(img_path, "logo_small.png"))
    item.part_content_set("icon", ic)

def page4(bt, nf):
    ic = Icon(nf, file=os.path.join(img_path, "icon_right_arrow.png"))
    bt = Button(nf, content=ic)
    bt.callback_clicked_add(page5, nf)

    content = Photo(nf, file=os.path.join(img_path, "rock_02.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 4", None, bt, content, "basic")
    ic = Icon(nf, file=os.path.join(img_path, "logo_small.png"))
    item.part_content_set("icon", ic)
    item.part_text_set("subtitle", "Title area visibility test")
    item.title_enabled = (False, False)

    content.callback_clicked_add(title_visible, item)

def page5(bt, nf):
    bt = Button(nf, text="Page 4")
    bt.callback_clicked_add(navi_pop, nf)

    bt2 = Button(nf, text="Page 6")
    bt2.callback_clicked_add(page6, nf)

    content = Photo(nf, file=os.path.join(img_path, "sky_01.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_insert_after(nf.top_item_get(), "Page 5", bt, bt2, content, "basic")
    item.part_text_set("subtitle", "This page is inserted without transition")

def page6(bt, nf):
    bt = Button(nf, text="Page 5")
    bt.callback_clicked_add(navi_pop, nf)

    bt2 = Button(nf, text="Page 7")
    bt2.callback_clicked_add(page7, nf)

    content = Photo(nf, file=os.path.join(img_path, "sky_03.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 6", bt, bt2, content, "overlap")
    item.part_text_set("subtitle", "Overlap style!")

def page7(bt, nf):
    bt = Button(nf, text="Page 6")
    bt.callback_clicked_add(navi_pop, nf)

    bt2 = Button(nf, text="Page 1")
    bt2.callback_clicked_add(lambda x: nf.data["page1"].promote())

    content = Photo(nf, file=os.path.join(img_path, "sky_02.jpg"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 7", bt, bt2, content, "overlap")
    item.part_text_set("subtitle", "Overlap style!")


def push_pop_cb(nf, item, signal):
    print("Signal: '%s' on item: %s " % (signal, item))


def test_naviframe(obj):
    win = StandardWindow("naviframe", "Naviframe test",
                         autodel=True, size=(400, 400))
    win.focus_highlight_enabled = True

    nf = Naviframe(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    nf.callback_transition_finished_add(push_pop_cb, "transition,finished")
    nf.callback_item_activated_add(push_pop_cb, "item,activated")
    win.resize_object_add(nf)
    nf.show()

    bt = Button(win, text="Next")
    bt.callback_clicked_add(page2, nf)

    content = Photo(nf, file=os.path.join(img_path, "logo.png"),
                    fill_inside=True, style="shadow")

    item = nf.item_push("Page 1", None, bt, content, "basic")
    nf.data["page1"] = item

    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_naviframe(None)
    elm.run()
