#!/usr/bin/env python
# encoding: utf-8

import os

from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Image, Check, Button
from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")
img_file = os.path.join(img_path, "insanely_huge_test_image.jpg")

def image_load_cb(img, signal):
    print("Signal: %s" % signal)

def create_image(win):
    box = win.data["box"]
    async = win.data["async_chk"].state
    preload_disabled = win.data["preload_chk"].state

    if "image" in win.data:
        print("Deleting old image")
        win.data["image"].delete()

    print("Creating image, async: %s, preload_disabled: %s" % (
          async, preload_disabled))

    im = Image(win, async_open=async, preload_disabled=preload_disabled,
               size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box.pack_start(im)
    win.data["image"] = im

    im.callback_load_open_add(image_load_cb, "load,open")
    im.callback_load_ready_add(image_load_cb, "load,ready")
    im.callback_load_error_add(image_load_cb, "load,error")
    im.callback_load_cancel_add(image_load_cb, "load,cancel")

    im.show()
    im.file = img_file


def test_image_async(obj, it=None):
    win = StandardWindow("image-async", "Image Async Test",
                         autodel=True, size=(320, 480))

    box = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(box)
    box.show()
    win.data["box"] = box

    hbox = Box(box, horizontal=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    box.pack_end(hbox)
    hbox.show()

    ck = Check(hbox, text="Async file open")
    hbox.pack_end(ck)
    ck.show()
    win.data["async_chk"] = ck

    ck = Check(hbox, text="Disable preload")
    hbox.pack_end(ck)
    ck.show()
    win.data["preload_chk"] = ck

    bt = Button(box, text="Image Reload")
    bt.callback_clicked_add(lambda b: create_image(win))
    box.pack_end(bt)
    bt.show()

    create_image(win)
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_image_async(None)
    elm.run()
