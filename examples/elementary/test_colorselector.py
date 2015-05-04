#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, Rectangle, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.button import Button
from efl.elementary.colorselector import Colorselector, \
    ELM_COLORSELECTOR_PALETTE, ELM_COLORSELECTOR_COMPONENTS, \
    ELM_COLORSELECTOR_BOTH

FILL_AND_ALIGN_TOP = EVAS_HINT_FILL, 0.0

def cb_cs_changed(cs, rect):
    print("changed")
    (r, g, b, a) = cs.color
    r = (r * a) / 255
    g = (g * a) / 255
    b = (b * a) / 255
    rect.color = (r, g, b, a)

def cb_cs_item_sel(cs, item, rect):
    print("selected")
    (r, g, b, a) = item.color
    r = (r * a) / 255
    g = (g * a) / 255
    b = (b * a) / 255
    rect.color = (r, g, b, a)

def cb_cs_item_lp(cs, item, rect):
    print("longpressed")
    (r, g, b, a) = item.color
    r = (r * a) / 255
    g = (g * a) / 255
    b = (b * a) / 255
    rect.color = (r, g, b, a)

def selected_item_get(bt, cs):
    item = cs.palette_selected_item_get() 
    print("Selected: {}".format(item.color if item is not None else None))

def palette_items(bt, cs):
    for item in cs.palette_items_get():
        print("Item: {} {}".format(item.color, "<- selected" if item.selected else ""))


def colorselector_clicked(obj):
    win = StandardWindow("colorselector", "ColorSelector test",
        autodel=True, size=(350,350))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    re = Rectangle(win.evas)
    re.size_hint_min = (1, 100)
    re.show()

    fr = Frame(win, text="Color View", content=re,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    cs = Colorselector(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH, color=(255, 160, 132, 255))
    cs.callback_changed_add(cb_cs_changed, re)
    cs.callback_color_item_selected_add(cb_cs_item_sel, re)
    cs.callback_color_item_longpressed_add(cb_cs_item_lp, re)
    cs.show()

    fr = Frame(win, text="Color Selector", content=cs,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    re.color = cs.color
    cs.palette_color_add(255, 90, 18, 255)
    cs.palette_color_add(255, 213, 0, 255)
    cs.palette_color_add(146, 255, 11, 255)
    cs.palette_color_add(9, 186, 10, 255)
    cs.palette_color_add(86, 201, 242, 255)
    cs.palette_color_add(18, 83, 128, 255)
    cs.palette_color_add(140, 53, 238, 255)
    cs.palette_color_add(255, 145, 145, 255)
    cs.palette_color_add(255, 59, 119, 255)
    cs.palette_color_add(133, 100, 69, 255)
    cs.palette_color_add(255, 255, 119, 255)
    cs.palette_color_add(133, 100, 255, 255)

    last_item = cs.palette_items_get()[-1]
    last_item.color = (255, 0, 0, 255)

    hbox = Box(win, horizontal=True, size_hint_align=FILL_AND_ALIGN_TOP,
        size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Palette", size_hint_align=FILL_AND_ALIGN_TOP,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda btn: cs.mode_set(ELM_COLORSELECTOR_PALETTE))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Components", size_hint_align=FILL_AND_ALIGN_TOP,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda btn: cs.mode_set(ELM_COLORSELECTOR_COMPONENTS))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Both", size_hint_align=FILL_AND_ALIGN_TOP,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda btn: cs.mode_set(ELM_COLORSELECTOR_BOTH))
    hbox.pack_end(bt)
    bt.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="palette items", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(palette_items, cs)
    hbox.pack_end(bt)
    bt.show()
    
    bt = Button(win, text="palette selected item", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(selected_item_get, cs)
    hbox.pack_end(bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    colorselector_clicked(None)

    elementary.run()

