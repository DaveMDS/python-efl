#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.fileselector_button import FileselectorButton
from efl.elementary.table import Table
from efl.elementary.video import Video, Player


def my_bt_open(bt, vfile, video):
    if (vfile and video):
        video.file_set(vfile)
        video.play()
    print(video.file)
    print(video.file_get())

def video_clicked(obj):
    win = StandardWindow("video", "video", autodel=True, size=(800, 600))
    win.alpha = True # Needed to turn video fast path on

    video = Video(win, size_hint_weight=EXPAND_BOTH)

    player = Player(win, content=video, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(player)
    player.show()

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    bt = FileselectorButton(win, text="Select Video",
                            size_hint_weight=EXPAND_BOTH,
                            size_hint_align=(0.5, 0.1))
    bt.callback_file_chosen_add(my_bt_open, video)
    tb.pack(bt, 0, 0, 1, 1)
    bt.show()

    win.show()


if __name__ == "__main__":

    video_clicked(None)

    elementary.run()
