#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box, ELM_BOX_LAYOUT_FLOW_HORIZONTAL
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.button import Button
from efl.elementary.check import Check
from efl.elementary.hoversel import Hoversel
from efl.elementary.radio import Radio
from efl.elementary.slider import Slider
from efl.elementary.separator import Separator
from efl.elementary.fileselector import Fileselector, \
    ELM_FILESELECTOR_SORT_LAST, ELM_FILESELECTOR_LIST, ELM_FILESELECTOR_GRID, \
    ELM_FILESELECTOR_SORT_BY_FILENAME_ASC, ELM_FILESELECTOR_SORT_BY_FILENAME_DESC, \
    ELM_FILESELECTOR_SORT_BY_TYPE_ASC, ELM_FILESELECTOR_SORT_BY_TYPE_DESC, \
    ELM_FILESELECTOR_SORT_BY_SIZE_ASC, ELM_FILESELECTOR_SORT_BY_SIZE_DESC, \
    ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC, ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC



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

def ck_cb_multi_select(bt, fs):
    print("Toggle multi_select")
    fs.multi_select = not fs.multi_select

def ck_cb_hidden(bt, fs):
    print("Toggle hidden_visible")
    fs.hidden_visible = not fs.hidden_visible

def bt_cb_sel_get(bt, fs):
    print("Get Selected:" + fs.selected)

def bt_cb_path_get(bt, fs):
    print("Get Path:" + fs.path)

def bt_cb_paths_get(bt, fs):
    print("Get Path:" + str(fs.selected_paths))

def bt_cb_current_name_get(bt, fs):
    print("Get CurrentName:" + str(fs.current_name))

def rd_cb_mode(rd, fs):
    mode = rd.value
    fs.mode_set(mode)

def sl_cb_thumb_size(sl, fs):
    val = int(sl.value)
    fs.thumbnail_size = (val, val)

def hs_cb_sort_method(hs, item, fs, method):
    fs.sort_method = method

def custom_filter_all(path, is_dir, data):
    return True

def custom_filter_edje(path, is_dir, data):
    if is_dir or path.endswith(".edc") or path.endswith(".edj"):
        return True
    return False

def fileselector_clicked(obj, item=None):
    win = StandardWindow("fileselector", "File selector test",
                         autodel=True, size=(500,500))

    box1 = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box1)
    box1.show()

    fs = Fileselector(win, is_save=True, expandable=False, folder_only=False,
                      path=os.getenv("HOME"), current_name="No name",
                      size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    fs.callback_done_add(fs_cb_done, win)
    fs.callback_selected_add(fs_cb_selected, win)
    fs.callback_directory_open_add(fs_cb_directory_open, win)
    box1.pack_end(fs)
    fs.show()

    fs.custom_filter_append(custom_filter_all, filter_name="All Files")
    fs.custom_filter_append(custom_filter_edje, filter_name="Edje Files")
    fs.mime_types_filter_append(["text/*"], "Text Files")
    fs.mime_types_filter_append(["image/*"], "Image Files")


    sep = Separator(win)
    box1.pack_end(sep)
    sep.show()

    vbox = Box(win)
    box1.pack_end(vbox)
    vbox.show()

    # Options frame
    fr = Frame(win, text="Options")
    vbox.pack_end(fr)
    fr.show()

    fbox1 = Box(win)
    fr.content = fbox1
    fbox1.show()

    fbox2 = Box(win, horizontal=True)
    fbox1.pack_end(fbox2)
    fbox2.show()

    ck = Check(win, text="is_save", state=fs.is_save)
    ck.callback_changed_add(ck_cb_is_save, fs)
    fbox2.pack_end(ck)
    ck.show()

    ck = Check(win, text="folder_only", state=fs.folder_only)
    ck.callback_changed_add(ck_cb_folder_only, fs)
    fbox2.pack_end(ck)
    ck.show()

    ck = Check(win, text="expandable", state=fs.expandable)
    ck.callback_changed_add(ck_cb_expandable, fs)
    fbox2.pack_end(ck)
    ck.show()

    fbox2 = Box(win, horizontal=True)
    fbox1.pack_end(fbox2)
    fbox2.show()

    ck = Check(win, text="multiple selection", state=fs. multi_select)
    ck.callback_changed_add(ck_cb_multi_select, fs)
    fbox2.pack_end(ck)
    ck.show()

    ck = Check(win, text="buttons", state=fs.buttons_ok_cancel)
    ck.callback_changed_add(ck_cb_buttons, fs)
    fbox2.pack_end(ck)
    ck.show()

    ck = Check(win, text="hidden", state=fs.hidden_visible)
    ck.callback_changed_add(ck_cb_hidden, fs)
    fbox2.pack_end(ck)
    ck.show()

    # Getters frame
    fr = Frame(win, text="Getters", size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    fbox1 = Box(win)
    fr.content = fbox1
    fbox1.show()

    fbox2 = Box(win, horizontal=True)
    fbox1.pack_end(fbox2)
    fbox2.show()

    bt = Button(win, text="selected_get")
    bt.callback_clicked_add(bt_cb_sel_get, fs)
    fbox2.pack_end(bt)
    bt.show()

    bt = Button(win, text="path_get")
    bt.callback_clicked_add(bt_cb_path_get, fs)
    fbox2.pack_end(bt)
    bt.show()

    bt = Button(win, text="selected_paths")
    bt.callback_clicked_add(bt_cb_paths_get, fs)
    fbox2.pack_end(bt)
    bt.show()

    fbox2 = Box(win, horizontal=True)
    fbox1.pack_end(fbox2)
    fbox2.show()

    bt = Button(win, text="current_name_get")
    bt.callback_clicked_add(bt_cb_current_name_get, fs)
    fbox2.pack_end(bt)
    bt.show()

    # Mode frame
    fr = Frame(win, text="Mode", size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    fbox = Box(win, horizontal=True)
    fr.content = fbox
    fbox.show()

    rdg = rd = Radio(win, text="List", state_value=ELM_FILESELECTOR_LIST)
    rd.callback_changed_add(rd_cb_mode, fs)
    fbox.pack_end(rd)
    rd.show()

    rd = Radio(win, text="Grid", state_value=ELM_FILESELECTOR_GRID)
    rd.callback_changed_add(rd_cb_mode, fs)
    rd.group_add(rdg)
    fbox.pack_end(rd)
    rd.show()

    # Thumbsize frame
    fr = Frame(win, text="Thumbnail size", size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    sl = Slider(win, min_max=(4, 130), unit_format="%.0f px",
                value=fs.thumbnail_size[0])
    sl.callback_delay_changed_add(sl_cb_thumb_size, fs)
    fr.content = sl
    sl.show()

    # Sort method frame
    fr = Frame(win, text="Sort method", size_hint_align=FILL_BOTH)
    vbox.pack_end(fr)
    fr.show()

    hs = Hoversel(win, text="File name (asc)")
    sorts = (
        ("File name (asc)", ELM_FILESELECTOR_SORT_BY_FILENAME_ASC),
        ("File name (desc)", ELM_FILESELECTOR_SORT_BY_FILENAME_DESC),
        ("Type (asc)", ELM_FILESELECTOR_SORT_BY_TYPE_ASC),
        ("Type (desc)", ELM_FILESELECTOR_SORT_BY_TYPE_DESC),
        ("Size (asc)", ELM_FILESELECTOR_SORT_BY_SIZE_ASC),
        ("Size (desc)", ELM_FILESELECTOR_SORT_BY_SIZE_DESC),
        ("Modified time (asc)", ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC),
        ("Modified time (desc)", ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC),
    )
    for sort in sorts:
        hs.item_add(label=sort[0], callback=hs_cb_sort_method, fs=fs, method=sort[1])
    fr.content = hs
    hs.show()

    win.show()


if __name__ == "__main__":

    fileselector_clicked(None)

    elementary.run()
