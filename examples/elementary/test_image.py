#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.image import Image
from efl.elementary.progressbar import Progressbar
from efl.elementary.separator import Separator
from efl.elementary.radio import Radio


orients = [
    ("Rotate 90", elementary.ELM_IMAGE_ROTATE_90),
    ("Rotate 180", elementary.ELM_IMAGE_ROTATE_180),
    ("Rotate 270", elementary.ELM_IMAGE_ROTATE_270),
    ("Flip Horizontal", elementary.ELM_IMAGE_FLIP_HORIZONTAL),
    ("Flip Vertical", elementary.ELM_IMAGE_FLIP_VERTICAL),
    ("Flip Transpose", elementary.ELM_IMAGE_FLIP_TRANSPOSE),
    ("Flip Tranverse", elementary.ELM_IMAGE_FLIP_TRANSVERSE),
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
    win = StandardWindow("image", "Image test")
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win)
    win.resize_object_add(vbox)
    vbox.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    vbox.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    vbox.show()

    im = Image(win)
    im.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    im.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    im.file = 'images/logo.png'
    vbox.pack_end(im)
    im.show()

    sep = Separator(win)
    sep.horizontal = True
    vbox.pack_end(sep)
    sep.show()
    
    hbox = Box(win)
    hbox.layout = elementary.ELM_BOX_LAYOUT_FLOW_HORIZONTAL
    hbox.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    vbox.pack_end(hbox)
    hbox.show()

    for rot in orients:
        b = Button(win)
        b.text = rot[0]
        hbox.pack_end(b)
        b.callback_clicked_add(lambda b: im.orient_set(rot[1]))
        b.show()

    sep = Separator(win)
    sep.horizontal = True
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win)
    hbox.horizontal = True
    hbox.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    vbox.pack_end(hbox)
    hbox.show()

    b = Button(win)
    b.text = "Set remote URL"
    hbox.pack_end(b)
    b.callback_clicked_add(lambda b: im.file_set(remote_url))
    b.show()

    pb = Progressbar(win)
    pb.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    pb.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
    hbox.pack_end(pb)
    pb.show()

    im.callback_download_start_add(_cb_im_download_start, pb)
    im.callback_download_done_add(_cb_im_download_done)
    im.callback_download_progress_add(_cb_im_download_progress, pb)
    im.callback_download_error_add(_cb_im_download_error, pb)
    
    win.resize(320, 480)
    win.show()


if __name__ == "__main__":
    elementary.init()

    image_clicked(None)

    elementary.run()
    elementary.shutdown()
