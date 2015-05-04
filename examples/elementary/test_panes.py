#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.button import Button
from efl.elementary.panes import Panes


def cb_panes(panes, event):
    print(("Event: %s" % (event)))

def panes_clicked(obj):
    win = StandardWindow("panes", "Panes test", autodel=True, size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    panes = Panes(win, content_left_min_relative_size=0.3,
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(panes)
    panes.callback_clicked_add(cb_panes, "clicked")
    panes.callback_clicked_double_add(cb_panes, "clicked,double")
    panes.callback_press_add(cb_panes, "press")
    panes.callback_unpress_add(cb_panes, "unpress")
    panes.show()

    bt = Button(win, text="Left")
    panes.part_content_set("left", bt)
    bt.show()

    panes_h = Panes(win, horizontal=True,
                    size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
                    content_left_min_size=30, content_right_min_size=100)
    panes.part_content_set("right", panes_h)
    panes_h.show()

    bt = Button(win, text="Up")
    panes_h.part_content_set("left", bt)
    bt.show()

    bt = Button(win, text="Down")
    panes_h.part_content_set("right", bt)
    bt.show()

    win.show()


if __name__ == "__main__":

    panes_clicked(None)

    elementary.run()
