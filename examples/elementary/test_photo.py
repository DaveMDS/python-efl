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
            ph = Photo(win, aspect_fixed=False, size=80, editable=True,
                size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
            name = os.path.join(img_path, images[n])
            n += 1
            if n >= 9: n = 0
            if n == 8:
                ph.thumb = name
            else:
                ph.file = name
            if n in [2, 3]:
                ph.fill_inside = True
                ph.style = "shadow"

            tb.pack(ph, i, j, 1, 1)
            ph.show()

    win.show()


if __name__ == "__main__":
    elementary.init()

    photo_clicked(None)

    elementary.run()
    elementary.shutdown()
