#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box, ELM_BOX_LAYOUT_FLOW_HORIZONTAL
from efl.elementary.button import Button
from efl.elementary.image import Image, ELM_IMAGE_ROTATE_90, \
    ELM_IMAGE_ROTATE_180, ELM_IMAGE_ROTATE_270, ELM_IMAGE_FLIP_HORIZONTAL, \
    ELM_IMAGE_FLIP_VERTICAL, ELM_IMAGE_FLIP_TRANSPOSE, ELM_IMAGE_FLIP_TRANSVERSE
from efl.elementary.progressbar import Progressbar
from efl.elementary.separator import Separator


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

orients = [
    ("Rotate 90", ELM_IMAGE_ROTATE_90),
    ("Rotate 180", ELM_IMAGE_ROTATE_180),
    ("Rotate 270", ELM_IMAGE_ROTATE_270),
    ("Flip Horizontal", ELM_IMAGE_FLIP_HORIZONTAL),
    ("Flip Vertical", ELM_IMAGE_FLIP_VERTICAL),
    ("Flip Transpose", ELM_IMAGE_FLIP_TRANSPOSE),
    ("Flip Tranverse", ELM_IMAGE_FLIP_TRANSVERSE),
]

remote_url = "http://31.media.tumblr.com/29f1ecd4f98aaff73fb21f479b450d4c/tumblr_mqsxdciQmB1rrju89o1_1280.jpg"


def _cb_im_download_start(im, pb):
    print("CB DOWNLOAD START")
    pb.value = 0.0

def _cb_im_download_done(im):
    print("CB DOWNLOAD DONE")

def _cb_im_download_progress(im, progress, pb):
    if progress.total > 0:
        print("CB DOWNLOAD PROGRESS [now: %.0f, total: %.0f, %.2f %%]" %
             (progress.now, progress.total, progress.now / progress.total * 100))
        pb.value = progress.now / progress.total

def _cb_im_download_error(im, info, pb):
    print("CB DOWNLOAD ERROR [status %s, open_error: %s]" % (info.status, info.open_error))
    pb.value = 1.0

def image_clicked(obj):
    win = StandardWindow("image", "Image test", autodel=True, size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    im = Image(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        file=os.path.join(img_path, "logo.png"))
    vbox.pack_end(im)
    im.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, layout=ELM_BOX_LAYOUT_FLOW_HORIZONTAL,
        size_hint_align=FILL_BOTH)
    vbox.pack_end(hbox)
    hbox.show()

    for rot in orients:
        b = Button(win, text=rot[0])
        hbox.pack_end(b)
        b.callback_clicked_add(lambda b, y=rot[1]: im.orient_set(y))
        b.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True, size_hint_align=FILL_BOTH)
    vbox.pack_end(hbox)
    hbox.show()

    b = Button(win, text="Set remote URL")
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b: im.file_set(remote_url))
    b.show()

    pb = Progressbar(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    hbox.pack_end(pb)
    pb.show()

    im.callback_download_start_add(_cb_im_download_start, pb)
    im.callback_download_done_add(_cb_im_download_done)
    im.callback_download_progress_add(_cb_im_download_progress, pb)
    im.callback_download_error_add(_cb_im_download_error, pb)

    win.show()


if __name__ == "__main__":
    elementary.init()

    image_clicked(None)

    elementary.run()
    elementary.shutdown()
