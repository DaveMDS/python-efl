#!/usr/bin/env python
# encoding: utf-8

import os

from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Image
from efl.evas import EXPAND_BOTH, FILL_BOTH


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


def test_image_memfile(obj, it=None):
    win = StandardWindow("image", "Image test", autodel=True, size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

    box = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(box)
    box.show()

    im = Image(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)

    with open(os.path.join(img_path, "logo.png"), "rb") as fp:
        image_data = fp.read()
        im.memfile_set(image_data, len(image_data))
    box.pack_end(im)
    im.show()

    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_image_memfile(None)
    elm.run()
