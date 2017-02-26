#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.icon import Icon
from efl.elementary.list import List
from efl.elementary.panel import Panel, ELM_PANEL_ORIENT_LEFT, \
    ELM_PANEL_ORIENT_TOP, ELM_PANEL_ORIENT_RIGHT, ELM_PANEL_ORIENT_BOTTOM
from efl.elementary.photo import Photo
from efl.elementary.table import Table
from efl.elementary.toolbar import Toolbar, ELM_TOOLBAR_SHRINK_NONE


script_path = os.path.dirname(os.path.abspath(__file__))
img_file = os.path.join(script_path, "images", "plant_01.jpg")


def toolbar_item_clicked_cb(toolbar, item, win):
    p = win.data["panel1"]
    print("The top panel is currently %s" % ("hidden" if p.hidden else "shown"))
    p = win.data["panel2"]
    print("The left panel is currently %s" % ("hidden" if p.hidden else "shown"))
    p = win.data["panel3"]
    print("The right panel is currently %s" % ("hidden" if p.hidden else "shown"))
    p = win.data["panel4"]
    print("The bottom panel is currently %s" % ("hidden" if p.hidden else "shown"))

def panel_toggled_cb(panel):
    print("Panel toggled")

def panel_clicked(obj):
    win = StandardWindow("panel", "Panel test", autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    # top panel (toolbar content)
    panel1 = Panel(bx, orient=ELM_PANEL_ORIENT_TOP,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    panel1.callback_toggled_add(panel_toggled_cb)
    bx.pack_end(panel1)
    panel1.show()
    win.data['panel1'] = panel1

    toolbar = Toolbar(panel1, homogeneous=False,
                      shrink_mode=ELM_TOOLBAR_SHRINK_NONE)
    toolbar.item_append("user-home", "Hello", toolbar_item_clicked_cb, win)
    panel1.content = toolbar
    toolbar.show()

    # table + bg image
    table = Table(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx.pack_end(table)
    table.show()

    photo = Photo(table, fill_inside=True, style="shadow", file=img_file,
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    table.pack(photo, 0, 0, 4, 5)
    photo.show()

    # left panel (list content)
    panel2 = Panel(table, orient=ELM_PANEL_ORIENT_LEFT,
                   size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    panel2.callback_toggled_add(panel_toggled_cb)
    table.pack(panel2, 0, 0, 2, 4)
    panel2.show()

    li = List(panel2, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    for i in range(1, 50):
        ic = Icon(win, standard="user-home")
        li.item_append("Item #%d" % i, ic)
    panel2.content = li
    li.show()
    win.data['panel2'] = panel2

    # right panel (button content)
    panel3 = Panel(table, orient=ELM_PANEL_ORIENT_RIGHT, hidden=True,
                   size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    panel3.callback_toggled_add(panel_toggled_cb)
    table.pack(panel3, 2, 0, 2, 4);
    panel3.show()
    win.data['panel3'] = panel3

    bt = Button(panel3, text="HIDE ME :)", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(lambda b: panel3.toggle())
    panel3.content = bt
    bt.show()

    # bottom panel (toolbar content)
    panel4 = Panel(table, orient=ELM_PANEL_ORIENT_BOTTOM, hidden=True,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    panel4.callback_toggled_add(panel_toggled_cb)
    table.pack(panel4, 0, 4, 4, 1)
    panel4.show()
    win.data['panel4'] = panel4

    toolbar = Toolbar(panel4, homogeneous=False,
                      shrink_mode=ELM_TOOLBAR_SHRINK_NONE,
                      size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    toolbar.item_append(None, "Hello", toolbar_item_clicked_cb, win)
    panel4.content = toolbar
    toolbar.show()

    win.show()


if __name__ == "__main__":

    panel_clicked(None)

    elementary.run()

