#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.check import Check
from efl.elementary.fileselector_button import FileselectorButton
from efl.elementary.fileselector import Fileselector
from efl.elementary.separator import Separator


def toggle_is_save(bt, fsb):
    print("Toggle is save")
    fsb.is_save = not fsb.is_save


def toggle_inwin(bt, fsb):
    print("Toggle inwin mode")
    fsb.inwin_mode = not fsb.inwin_mode


def toggle_folder_only(bt, fsb):
    print("Toggle folder_only")
    fsb.folder_only = not fsb.folder_only


def toggle_expandable(bt, fsb):
    print("Toggle expandable")
    fsb.expandable = not fsb.expandable


class FsButton(Fileselector, FileselectorButton):

    def __init__(self, *args, **kwargs):
        FileselectorButton.__init__(self, *args, **kwargs)


def fileselector_button_clicked(obj, item=None):
    win = StandardWindow("fileselector", "File selector button test",
                         autodel=True, size=(240, 350))
    if not obj:
        win.callback_delete_request_add(lambda x: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    fse = FsButton(win, text="Select a file", inwin_mode=False,
                             size_hint_align=FILL_BOTH,
                             size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(fse)
    fse.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="inwin", state=fse.inwin_mode)
    ck.callback_changed_add(toggle_inwin, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="folder_only", state=fse.folder_only)
    ck.callback_changed_add(toggle_folder_only, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="is_save", state=fse.is_save)
    ck.callback_changed_add(toggle_is_save, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="expandable", state=fse.expandable)
    ck.callback_changed_add(toggle_expandable, fse)
    hbox.pack_end(ck)
    ck.show()

    win.show()


if __name__ == "__main__":

    import logging
    efl_log = logging.getLogger("efl")
    efl_log.addHandler(logging.StreamHandler())

    fileselector_button_clicked(None)

    elementary.run()
