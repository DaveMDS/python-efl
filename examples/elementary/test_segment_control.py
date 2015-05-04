#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.segment_control import SegmentControl


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def cb_seg_changed(seg, item):
    print(seg)
    print(item)

def segment_control_clicked(obj):
    win = StandardWindow("segment-control", "Segment Control test",
        autodel=True, size=(320, 280))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    # segment 1
    seg = SegmentControl(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    seg.item_add(None, "Only Text")
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    it = seg.item_add(ic)
    ic = Icon(win)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    seg.item_add(ic, "Text + Icon")
    seg.item_add(None, "Seg4")
    seg.item_add(None, "Seg5")

    seg.callback_changed_add(cb_seg_changed)
    it.selected = True
    vbox.pack_end(seg)
    seg.show()

    # segment 2
    seg = SegmentControl(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ)
    seg.item_add(None, "SegmentItem")
    it = seg.item_add(None, "SegmentItem")
    seg.item_add(None, "SegmentItem")
    seg.item_add(None, "SegmentItem")

    it.selected = True
    vbox.pack_end(seg)
    seg.show()

    # segment 3
    seg = SegmentControl(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.5, 0.5))

    for i in range(3):
        ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
        if i == 1:
            it = seg.item_add(ic)
        else:
            seg.item_add(ic)

    it.selected = True
    vbox.pack_end(seg)
    seg.show()

    # segment 4
    seg = SegmentControl(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_HORIZ, disabled=True)

    seg.item_add(None, "Disabled")

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    it = seg.item_add(ic, "Disabled")

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    seg.item_add(ic)

    it.selected = True

    vbox.pack_end(seg)
    seg.show()

    win.show()


if __name__ == "__main__":

    segment_control_clicked(None)

    elementary.run()
