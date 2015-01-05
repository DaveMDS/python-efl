#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EVAS_CALLBACK_MOUSE_MOVE, EVAS_CALLBACK_MOUSE_IN, EVAS_CALLBACK_MOUSE_OUT
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.notify import Notify, ELM_NOTIFY_ORIENT_BOTTOM
from efl.elementary.fileselector_button import FileselectorButton
from efl.elementary.table import Table
from efl.elementary.video import Video, Player


def my_bt_open(bt, vfile, video):
    if (vfile and video):
        video.file_set(vfile)
        video.play()

def notify_show(video, event, no):
    no.show()

def notify_block(video, event, no):
    no.timeout = 0.0
    no.show()

def notify_unblock(video, event, no):
    no.timeout = 3.0
    no.show()

def video_clicked(obj):
    win = StandardWindow("video", "video", autodel=True, size=(800, 600))
    win.alpha = True # Needed to turn video fast path on

    video = Video(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(video)
    video.show()

    player = Player(win, content=video)
    player.show()

    notify = Notify(win, orient=ELM_NOTIFY_ORIENT_BOTTOM, timeout=3.0)
    notify.content = player

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)

    bt = FileselectorButton(win, text="Select Video",
        size_hint_weight=EXPAND_BOTH, size_hint_align=(0.5, 0.1))
    bt.callback_file_chosen_add(my_bt_open, video)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    tb.show()

    video.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, notify_show, notify)
    video.event_callback_add(EVAS_CALLBACK_MOUSE_IN, notify_block, notify)
    video.event_callback_add(EVAS_CALLBACK_MOUSE_OUT, notify_unblock, notify)

    win.show()


if __name__ == "__main__":
    elementary.init()

    video_clicked(None)

    elementary.run()
    elementary.shutdown()
