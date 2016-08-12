#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.photo import Photo
from efl.elementary.scroller import Scroller
from efl.elementary.table import Table


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

images = ["panel_01.jpg",
          "mystrale.jpg",
          "mystrale_2.jpg",
          "rock_02.jpg",
          "sky_01.jpg",
          "sky_02.jpg",
          "sky_03.jpg",
          "sky_04.jpg",
          "wood_01.jpg"]

def drag_start_cb(ph):
    print("drag start %r" % ph)

def drag_end_cb(ph):
    print("drag end %r" % ph)

def _clicked_cb(ph):
    print("clicked on %r" % ph)

def photo_clicked(obj):
    win = StandardWindow("photo", "Photo test", autodel=True, size=(300, 300))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    elementary.need_ethumb()

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    tb.show()

    sc = Scroller(win, size_hint_weight=EXPAND_BOTH, content=tb)
    win.resize_object_add(sc)
    sc.show()

    n = 0
    for j in range(12):
        for i in range(12):
            ph = Photo(
                win, aspect_fixed=False, size=80, editable=True,
                size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
            ph.callback_clicked_add(_clicked_cb)
            name = os.path.join(img_path, images[n])
            n += 1
            if n >= 9: n = 0
            if n == 8:
                ph.thumb = name
            else:
                ph.file = name
            ph.callback_drag_start_add(drag_start_cb)
            ph.callback_drag_end_add(drag_end_cb)
            if n in [2, 3]:
                ph.fill_inside = True
                ph.style = "shadow"

            if j == i == 0:
                print("Size:", ph.size)
                print("Fill Inside:", ph.fill_inside)
                print("Editable:", ph.editable) # THIS ONE IS FAILING !!

            tb.pack(ph, i, j, 1, 1)
            ph.show()

    win.show()


if __name__ == "__main__":

    photo_clicked(None)

    elementary.run()
