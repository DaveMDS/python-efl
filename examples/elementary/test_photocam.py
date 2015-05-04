#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EVAS_IMAGE_ORIENT_0, EVAS_IMAGE_ORIENT_90, EVAS_IMAGE_ORIENT_180, \
    EVAS_IMAGE_ORIENT_270, EVAS_IMAGE_FLIP_HORIZONTAL, EVAS_IMAGE_FLIP_VERTICAL, \
    EVAS_IMAGE_FLIP_TRANSPOSE, EVAS_IMAGE_FLIP_TRANSVERSE
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.photocam import Photocam, ELM_PHOTOCAM_ZOOM_MODE_MANUAL, \
    ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT, ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL
from efl.elementary.progressbar import Progressbar
from efl.elementary.separator import Separator
from efl.elementary.table import Table
from efl.elementary.fileselector_button import FileselectorButton


remote_url = "http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73751/world.topo.bathy.200407.3x21600x10800.jpg"


def _cb_zoom_in(bt, pc):
    pc.zoom_mode = ELM_PHOTOCAM_ZOOM_MODE_MANUAL
    zoom = pc.zoom - 0.5
    if zoom >= (1.0 / 32.0):
        pc.zoom = zoom

def _cb_zoom_out(bt, pc):
    pc.zoom_mode = ELM_PHOTOCAM_ZOOM_MODE_MANUAL
    zoom = pc.zoom + 0.5
    if zoom <= 256.0:
        pc.zoom = zoom


def _cb_pc_download_start(im, pb):
    print("CB DOWNLOAD START")
    pb.value = 0.0
    pb.show()

def _cb_pc_download_done(im, pb):
    print("CB DOWNLOAD DONE")
    pb.hide()

def _cb_pc_download_progress(im, progress, pb):
    if progress.total > 0:
        print("CB DOWNLOAD PROGRESS [now: %.0f, total: %.0f, %.2f %%]" %
             (progress.now, progress.total, progress.now / progress.total * 100))
        pb.value = progress.now / progress.total

def _cb_pc_download_error(im, info, pb):
    print("CB DOWNLOAD ERROR [status %s, open_error: %s]" % (info.status, info.open_error))
    pb.hide()


def _cb_orient(btn, pc, orient):
    pc.image_orient = orient


def photocam_clicked(obj):
    win = StandardWindow("photocam", "Photocam test", autodel=True,
        size=(600, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    # Photocam widget
    pc = Photocam(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(pc)
    pc.show()

    # table for buttons
    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    # zoom out btn
    bt = Button(win, text="Z -", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.1, 0.1))
    bt.callback_clicked_add(_cb_zoom_out, pc)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    # select file btn
    bt = FileselectorButton(win, text="Select Photo File",
        size_hint_weight=EXPAND_BOTH, size_hint_align=(0.5, 0.1))
    bt.callback_file_chosen_add(lambda fs, path: pc.file_set(path))
    tb.pack(bt, 1, 0, 1, 1)
    bt.show()

    # zoom in btn
    bt = Button(win, text="Z +", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.1))
    bt.callback_clicked_add(_cb_zoom_in, pc)
    tb.pack(bt, 2, 0, 1, 1)
    bt.show()

    # progressbar for remote loading
    pb = Progressbar(win, unit_format="loading %.2f %%",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    tb.pack(pb, 1, 1, 1, 1)

    # Fit btn
    bt = Button(win, text="Fit", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.1, 0.9))
    bt.callback_clicked_add(lambda b: pc.zoom_mode_set(ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT))
    tb.pack(bt, 0, 2, 1, 1)
    bt.show()

    # load remote url
    bt = Button(win, text="Load remote URL (27MB)",
        size_hint_weight=EXPAND_BOTH, size_hint_align=(0.5, 0.9))
    bt.callback_clicked_add(lambda b: pc.file_set(remote_url))
    tb.pack(bt, 1, 2, 1, 1)
    bt.show()

    pc.callback_download_start_add(_cb_pc_download_start, pb)
    pc.callback_download_done_add(_cb_pc_download_done, pb)
    pc.callback_download_progress_add(_cb_pc_download_progress, pb)
    pc.callback_download_error_add(_cb_pc_download_error, pb)

    # Fill btn
    bt = Button(win, text="Fill", size_hint_weight=EXPAND_BOTH,
        size_hint_align=(0.9, 0.9))
    bt.callback_clicked_add(lambda b: pc.zoom_mode_set(ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL))
    tb.pack(bt, 2, 2, 1, 1)
    bt.show()

    # Orient buttons
    box = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    tb.pack(box, 0, 1, 1, 1)
    box.show()

    orients = [
        (EVAS_IMAGE_ORIENT_0, "Orient 0"),
        (EVAS_IMAGE_ORIENT_90, "Orient 90"),
        (EVAS_IMAGE_ORIENT_180, "Orient 180"),
        (EVAS_IMAGE_ORIENT_270, "Orient 270"),
        (EVAS_IMAGE_FLIP_HORIZONTAL, "Flip Horiz"),
        (EVAS_IMAGE_FLIP_VERTICAL, "Flip Vert"),
        (EVAS_IMAGE_FLIP_TRANSPOSE, "Transpose"),
        (EVAS_IMAGE_FLIP_TRANSVERSE, "Transverse"),
    ]

    for val, label in orients:
        bt = Button(win, text=label, size_hint_align=(0.1, 0.5))
        bt.callback_clicked_add(_cb_orient, pc, val)
        box.pack_end(bt)
        bt.show()

    # show the win
    win.show()


if __name__ == "__main__":

    photocam_clicked(None)

    elementary.run()
