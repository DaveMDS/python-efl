#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.scroller import Scroller
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.icon import Icon
from efl.elementary.label import Label


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def frame_clicked(obj):
    win = StandardWindow("frame", "Frame test", autodel=True, size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    # frame 1 (label)
    lbl = Label(win, text="content")
    fr = Frame(win, size_hint_align=FILL_BOTH,
        text="Frame (label)", content=lbl)
    vbox.pack_end(fr)
    fr.show()

    # frame 1 (icon)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    fr = Frame(win, size_hint_align=FILL_BOTH,
        text="Frame (icon)", content=ic)
    vbox.pack_end(fr)
    fr.show()

    # frame 2 (collapsable label)
    lbl = Label(win, text="content")
    fr = Frame(win, size_hint_align=FILL_BOTH,
        autocollapse=True, text="Frame (collapsable label)", content=lbl)
    vbox.pack_end(fr)
    fr.show()

    # frame 3(collapsable icon)
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False))
    fr = Frame(win, size_hint_align=FILL_BOTH,
        autocollapse=True, text="Frame (collapsable icon)", content=ic)
    vbox.pack_end(fr)
    fr.show()

    win.show()

if __name__ == "__main__":

    frame_clicked(None)

    elementary.run()
