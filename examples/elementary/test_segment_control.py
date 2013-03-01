#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.segment_control import SegmentControl


def cb_seg_changed(seg, item):
    print seg
    print item
    
def segment_control_clicked(obj):
    win = Window("segment-control", elementary.ELM_WIN_BASIC)
    win.title_set("Segment Control test")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    vbox = Box(win)
    vbox.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    vbox.size_hint_align = (evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    win.resize_object_add(vbox)
    vbox.show()

    # segment 1
    seg = SegmentControl(win)
    seg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    seg.size_hint_align = (evas.EVAS_HINT_FILL,0.5)
    seg.item_add(None, "Only Text")
    ic = Icon(win)
    ic.file = "images/logo_small.png"
    it = seg.item_add(ic)
    ic = Icon(win)
    ic.file = "images/logo_small.png"
    seg.item_add(ic, "Text + Icon")
    seg.item_add(None, "Seg4")
    seg.item_add(None, "Seg5")

    seg.callback_changed_add(cb_seg_changed)
    # it.selected_set(True)
    vbox.pack_end(seg)
    seg.show()

    # segment 2
    seg = SegmentControl(win)
    seg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    seg.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)
    seg.item_add(None, "SegmentItem")
    it = seg.item_add(None, "SegmentItem")
    seg.item_add(None, "SegmentItem")
    seg.item_add(None, "SegmentItem")

    print it
    # it.selected_set(True)
    vbox.pack_end(seg)
    seg.show()

    # segment 3
    seg = SegmentControl(win)
    seg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    seg.size_hint_align = (0.5, 0.5)

    for i in range(3):
        ic = Icon(win)
        ic.file = "images/logo_small.png"
        if i == 1:
            it = seg.item_add(ic)
        else:
            seg.item_add(ic)

    # it.selected_set(True)
    vbox.pack_end(seg)
    seg.show()

    # segment 4
    seg = SegmentControl(win)
   
    seg.size_hint_weight = (evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    seg.size_hint_align = (evas.EVAS_HINT_FILL, 0.5)

    seg.item_add(None, "Disabled")

    ic = Icon(win)
    ic.file = "images/logo_small.png"
    seg.item_add(ic, "Disabled")

    ic = Icon(win)
    ic.file = "images/logo_small.png"
    seg.item_add(ic)

    seg.disabled = True
    # it.selected_set(True)
    vbox.pack_end(seg)
    seg.show()


    win.resize(320, 280)
    win.show()


if __name__ == "__main__":
    elementary.init()

    segment_control_clicked(None)

    elementary.run()
    elementary.shutdown()
