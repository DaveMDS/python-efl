#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.list import List
from efl.elementary.fileselector import Fileselector, ELM_FILESELECTOR_SORT_LAST
from efl.elementary.fileselector_button import FileselectorButton
from efl.elementary.fileselector_entry import FileselectorEntry
from efl.elementary.separator import Separator

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

def fs_cb_done(fs, selected, win):
    win.delete()

def fs_cb_selected(fs, selected, win):
    print("Selected file: " + selected)
    print("           or:" + fs.selected_get())

def fs_cb_directory_open(fs, folder, win):
    print("Folder open: " + folder)

def ck_cb_is_save(bt, fs):
    print("Toggle is save")
    fs.is_save = not fs.is_save

def ck_cb_folder_only(bt, fs):
    print("Toggle folder_only")
    fs.folder_only = not fs.folder_only

def ck_cb_expandable(bt, fs):
    print("Toggle expandable")
    fs.expandable = not fs.expandable

def ck_cb_buttons(bt, fs):
    print("Toggle buttons_ok_cancel")
    fs.buttons_ok_cancel = not fs.buttons_ok_cancel

def ck_cb_hidden(bt, fs):
    print("Toggle hidden_visible")
    fs.hidden_visible = not fs.hidden_visible

def bt_cb_sel_get(bt, fs):
    print("Get Selected:" + fs.selected_get())

def bt_cb_path_get(bt, fs):
    print("Get Path:" + fs.path_get())

def bt_cb_mode_cycle(bt, fs):
    mode = fs.mode + 1
    fs.mode_set(mode if mode < 2 else 0)

def bt_cb_sort_cycle(bt, fs):
    sort_method = fs.sort_method + 1
    fs.sort_method = sort_method if sort_method < ELM_FILESELECTOR_SORT_LAST else 0

def fileselector_clicked(obj, item=None):
    win = StandardWindow("fileselector", "File selector test", autodel=True,
        size=(240,350))

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    fs = Fileselector(win, is_save=True, expandable=True, folder_only=True,
        path=os.getenv("HOME"), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    fs.callback_done_add(fs_cb_done, win)
    fs.callback_selected_add(fs_cb_selected, win)
    fs.callback_directory_open_add(fs_cb_directory_open, win)
    vbox.pack_end(fs)
    fs.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="is_save", state=fs.is_save)
    ck.callback_changed_add(ck_cb_is_save, fs)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="folder_only", state=fs.folder_only)
    ck.callback_changed_add(ck_cb_folder_only, fs)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="expandable", state=fs.expandable)
    ck.callback_changed_add(ck_cb_expandable, fs)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="buttons", state=fs.buttons_ok_cancel)
    ck.callback_changed_add(ck_cb_buttons, fs)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="hidden", state=fs.hidden_visible)
    ck.callback_changed_add(ck_cb_hidden, fs)
    hbox.pack_end(ck)
    ck.show()

    hbox = Box(win, horizontal=True)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="selected_get")
    bt.callback_clicked_add(bt_cb_sel_get, fs)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="path_get")
    bt.callback_clicked_add(bt_cb_path_get, fs)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="mode cycle")
    bt.callback_clicked_add(bt_cb_mode_cycle, fs)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="sort_method cycle")
    bt.callback_clicked_add(bt_cb_sort_cycle, fs)
    hbox.pack_end(bt)
    bt.show()

    win.resize(240, 350)
    win.show()


def fileselector_button_clicked(obj, item=None):
    win = StandardWindow("fileselector", "File selector test", autodel=True,
        size=(240, 350))

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    fse = FileselectorButton(win, text="Select a file", inwin_mode=False,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(fse)
    fse.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="inwin", state=fse.inwin_mode)
    ck.callback_changed_add(ck_entry_cb_inwin, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="folder_only", state=fse.folder_only)
    ck.callback_changed_add(ck_entry_cb_folder_only, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="is_save", state=fse.is_save)
    ck.callback_changed_add(ck_entry_cb_is_save, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="expandable", state=fse.expandable)
    ck.callback_changed_add(ck_entry_cb_expandable, fse)
    hbox.pack_end(ck)
    ck.show()

    win.show()


def ck_entry_cb_is_save(bt, fse):
    print("Toggle is save")
    fse.is_save = not fse.is_save

def ck_entry_cb_inwin(bt, fse):
    print("Toggle inwin mode")
    fse.inwin_mode = not fse.inwin_mode

def ck_entry_cb_folder_only(bt, fse):
    print("Toggle folder_only")
    fse.folder_only = not fse.folder_only

def ck_entry_cb_expandable(bt, fse):
    print("Toggle expandable")
    fse.expandable = not fse.expandable


def fileselector_entry_clicked(obj, item=None):
    win = StandardWindow("fileselector", "File selector test", autodel=True,
        size=(240, 150))

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    fse = FileselectorEntry(win, text="Select a file", inwin_mode=False,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(fse)
    fse.show()

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="inwin", state=fse.inwin_mode)
    ck.callback_changed_add(ck_entry_cb_inwin, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="folder_only", state=fse.folder_only)
    ck.callback_changed_add(ck_entry_cb_folder_only, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="is_save", state=fse.is_save)
    ck.callback_changed_add(ck_entry_cb_is_save, fse)
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="expandable", state=fse.expandable)
    ck.callback_changed_add(ck_entry_cb_expandable, fse)
    hbox.pack_end(ck)
    ck.show()

    win.show()


if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Fileselector", fileselector_clicked),
             ("Fileselector Button", fileselector_button_clicked),
             ("Fileselector Entry", fileselector_entry_clicked),
            ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
    elementary.shutdown()
