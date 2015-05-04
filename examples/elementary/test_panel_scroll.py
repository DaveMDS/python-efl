#!/usr/bin/env python
# encoding: utf-8


from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.list import List
from efl.elementary.panel import Panel, ELM_PANEL_ORIENT_LEFT
from efl.elementary.table import Table


def panel_scroll_clicked(obj):
    win = StandardWindow("panel", "Panel test", autodel=True, size=(320, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    # bor for button and table
    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    # toggle button
    button = Button(box, text="Toggle",
                    size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    button.show()
    box.pack_end(button)
   
    # table for panel and center content
    table = Table(win,
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    table.show()
    box.pack_end(table)

    # center content
    li = List(table, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    for i in range(1, 50):
        li.item_append("center list item #%.02d" % i)
    table.pack(li, 0, 0, 1, 1)
    li.show()

    # panel
    panel = Panel(table, orient=ELM_PANEL_ORIENT_LEFT, hidden=True,
                  scrollable=True, scrollable_content_size = 0.75,
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    panel.show()
    table.pack(panel, 0, 0, 1, 1)

    li = List(panel, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    for i in range(1, 7):
        li.item_append("panel item #%d" % i)
    panel.content = li
    li.show()

    button.callback_clicked_add(lambda b: panel.toggle())
    win.show()


if __name__ == "__main__":

    panel_scroll_clicked(None)

    elementary.run()

