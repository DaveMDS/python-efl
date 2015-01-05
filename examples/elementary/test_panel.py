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
    bx.pack_end(panel1)
    panel1.show()

    toolbar = Toolbar(panel1, homogeneous=False,
                      shrink_mode=ELM_TOOLBAR_SHRINK_NONE)
    toolbar.item_append("home", "Hello Toolbar")
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
    table.pack(panel2, 0, 0, 2, 4)
    panel2.show()

    li = List(panel2, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    for i in range(1, 50):
        ic = Icon(win, standard="home")
        li.item_append("Item #%d" % i, ic)
    panel2.content = li
    li.show()

    # right panel (button content)
    panel3 = Panel(table, orient=ELM_PANEL_ORIENT_RIGHT, hidden=True,
                   size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    table.pack(panel3, 2, 0, 2, 4);
    panel3.show()

    bt = Button(panel3, text="HIDE ME :)", size_hint_weight=EXPAND_BOTH,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(lambda b: panel3.toggle())
    panel3.content = bt
    bt.show()

    # bottom panel (toolbar content)
    panel4 = Panel(table, orient=ELM_PANEL_ORIENT_BOTTOM, hidden=True,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    table.pack(panel4, 0, 4, 4, 1)
    panel4.show()

    toolbar = Toolbar(panel4, homogeneous=False,
                      shrink_mode=ELM_TOOLBAR_SHRINK_NONE,
                      size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    toolbar.item_append("home", "Hello Toolbar")
    panel4.content = toolbar
    toolbar.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    panel_clicked(None)

    elementary.run()
    elementary.shutdown()

