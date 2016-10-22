#!/usr/bin/env python
# encoding: utf-8

import os

from efl.ecore import Timer
from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.hoversel import Hoversel, ELM_ICON_STANDARD, ELM_ICON_FILE
from efl.elementary.icon import Icon

WEIGHT_ZERO = 0.0, 0.0
ALIGN_CENTER = 0.5, 0.5

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def hoversel_clicked(obj):
    win = StandardWindow("hoversel", "Hoversel", autodel=True, size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    def _sel_label_cb(hoversel, item):
        text = hoversel.text
        hoversel.text = item.text
        Timer(2.0, lambda: hoversel.text_set("Labels"))

    bt = Hoversel(win, hover_parent=win, text="Labels",
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)
    bt.item_add("Item 1")
    bt.item_add("Item 2")
    bt.item_add("Item 3")
    bt.item_add("Item 4 - Long Label Here")
    bt.callback_selected_add(_sel_label_cb)
    bx.pack_end(bt)
    bt.show()

    bt = Hoversel(win, hover_parent=win, text="Some Icons",
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)
    bt.item_add("Item 1")
    bt.item_add("Item 2")
    bt.item_add("Item 3", "user-home", ELM_ICON_STANDARD)
    bt.item_add("Item 4", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    bt = Hoversel(win, hover_parent=win, text="All Icons",
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)
    bt.item_add("Item 1", "user-trash", ELM_ICON_STANDARD)
    bt.item_add("Item 2", "go-down", ELM_ICON_STANDARD)
    bt.item_add("Item 3", "user-home", ELM_ICON_STANDARD)
    bt.item_add("Item 4", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    bt = Hoversel(win, hover_parent=win, text="All Icons",
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)
    bt.item_add("Item 1", "user-trash", ELM_ICON_STANDARD)
    bt.item_add("Item 2", os.path.join(img_path, "logo_small.png"),
                ELM_ICON_FILE)
    bt.item_add("Item 3", "user-home", ELM_ICON_STANDARD)
    bt.item_add("Item 4", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    bt = Hoversel(win, hover_parent=win, text="Disabled Hoversel",
                  disabled=True, size_hint_weight=WEIGHT_ZERO,
                  size_hint_align=ALIGN_CENTER)
    bt.item_add("Item 1", "folder", ELM_ICON_STANDARD)
    bt.item_add("Item 2", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    ic = Icon(win, file=os.path.join(img_path, "sky_03.jpg"))
    bt = Hoversel(win, hover_parent=win, text="Icon + Label", content=ic,
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)
    ic.show()

    bt.item_add("Item 1", "user-trash", ELM_ICON_STANDARD)
    bt.item_add("Item 2", "go-down", ELM_ICON_STANDARD)
    bt.item_add("Item 3", "user-home", ELM_ICON_STANDARD)
    bt.item_add("Item 4", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    bt = Hoversel(win, hover_parent=win, text="Label auto changed",
                  auto_update=True,
                  size_hint_weight=WEIGHT_ZERO, size_hint_align=ALIGN_CENTER)

    bt.item_add("Item 1", "user-trash", ELM_ICON_STANDARD)
    bt.item_add("Item 2", "go-down", ELM_ICON_STANDARD)
    bt.item_add("Item 3", "user-home", ELM_ICON_STANDARD)
    bt.item_add("Item 4", "view-close", ELM_ICON_STANDARD)
    bx.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    hoversel_clicked(None)

    elementary.run()
