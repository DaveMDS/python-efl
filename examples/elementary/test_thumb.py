#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.scroller import Scroller
from efl.elementary.table import Table
from efl.elementary.thumb import Thumb


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def thumb_clicked(obj):
    if not elementary.need_ethumb():
        print("Ethumb not available!")
        return

    images = (
        "panel_01.jpg",
        "plant_01.jpg",
        "rock_01.jpg",
        "rock_02.jpg",
        "sky_01.jpg",
        "sky_02.jpg",
        "sky_03.jpg",
        "sky_04.jpg",
        "wood_01.jpg",
        "mystrale.jpg",
        "mystrale_2.jpg"
    )

    win = StandardWindow("thumb", "Thumb", autodel=True, size=(600, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    tb = Table(win, size_hint_weight=EXPAND_BOTH)

    n = 0
    for j in range(12):
        for i in range(12):
            n = (n + 1) % 11
            th = Thumb(win, file=os.path.join(img_path, images[n]),
                size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
                editable=True)
            tb.pack(th, i, j, 1, 1)
            th.show()

    sc = Scroller(win, size_hint_weight=EXPAND_BOTH, content=tb)
    win.resize_object_add(sc)

    tb.show()
    sc.show()

    win.show()


if __name__ == "__main__":

    thumb_clicked(None)

    elementary.run()
