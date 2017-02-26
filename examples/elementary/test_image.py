#!/usr/bin/env python
# encoding: utf-8

import os

from efl import evas
from efl import elementary as elm
from efl.evas import EXPAND_BOTH, FILL_BOTH
from efl.elementary import StandardWindow, Box, Button, Image, \
    Progressbar, Separator


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

orients = [
    ("Orient 0", evas.EVAS_IMAGE_ORIENT_0),
    ("Orient 90", evas.EVAS_IMAGE_ORIENT_90),
    ("Orient 180", evas.EVAS_IMAGE_ORIENT_180),
    ("Orient 270", evas.EVAS_IMAGE_ORIENT_270),
    ("Flip Horizontal", evas.EVAS_IMAGE_FLIP_HORIZONTAL),
    ("Flip Vertical", evas.EVAS_IMAGE_FLIP_VERTICAL),
    ("Flip Transpose", evas.EVAS_IMAGE_FLIP_TRANSPOSE),
    ("Flip Tranverse", evas.EVAS_IMAGE_FLIP_TRANSVERSE),
]

remote_url = "http://41.media.tumblr.com/29f1ecd4f98aaff73fb21f479b450d4c/tumblr_mqsxdciQmB1rrju89o1_1280.jpg"


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


def test_image(obj, it=None):
    win = StandardWindow("image", "Image test", autodel=True, size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

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

    hbox = Box(win, layout=elm.ELM_BOX_LAYOUT_FLOW_HORIZONTAL,
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
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_image(None)
    elm.run()
