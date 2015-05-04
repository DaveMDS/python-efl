#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import elementary
from efl.elementary.genlist import Genlist, GenlistItemClass, ELM_LIST_COMPRESS
from efl.elementary.store import Store, StoreItemMappingLabel, StoreItemMappingNone
from efl.elementary.box import Box
from efl.elementary.window import StandardWindow

class My_Item(object):
    sender = None
    subject = None
    date = None
    head_content = None

# callbacks just to see user interacting with genlist
def st_selected(obj, event_info):
    print("selected: %s" % event_info)

def st_double_clicked(obj, event_info):
    print("double clicked: %s" % event_info)

def st_longpress(obj, event_info):
    print("longpress %s" % event_info)

mapping = [
    StoreItemMappingLabel("elm.title.1", 1),
    StoreItemMappingLabel("elm.title.2", 2),
    StoreItemMappingLabel("elm.text", 3),
    StoreItemMappingNone("elm.swallow.icon", 0),
    StoreItemMappingNone("elm.swallow.end", 0),
]

def st_store_list(info, *args, **kwargs):
    if info.path.endswith("py"):
        info.base.item_class = GenlistItemClass(item_style="default")
        return True
    else:
        return False
    # char sort_id[7];

    # # create a sort id based on the filename itself assuming it is a numeric
    # # value like the id number in mh mail folders which is what this test
    # # uses as a data source
    # file = strrchr(info.path, '/')
    # if file: file++
    # else file = info.path
    # id = atoi(file);
    # sort_id[0] = ((id >> 30) & 0x3f) + 32;
    # sort_id[1] = ((id >> 24) & 0x3f) + 32;
    # sort_id[2] = ((id >> 18) & 0x3f) + 32;
    # sort_id[3] = ((id >> 12) & 0x3f) + 32;
    # sort_id[4] = ((id >>  6) & 0x3f) + 32;
    # sort_id[5] = ((id >>  0) & 0x3f) + 32;
    # sort_id[6] = 0;
    # info.base.sort_id = strdup(sort_id);
    # # choose the item genlist item class to use (only item style should be
    # # provided by the app, store will fill everything else in, so it also
    # # has to be writable
    # info.base.item_class = itc1; # based on item info - return the item class wanted (only style field used - rest reset to internal funcs store sets up to get label/icon etc)
    # info.base.mapping = it1_mapping;
    # info.base.data = NULL; # if we can already parse and load all of item here and want to - set this
    # return True; # return true to include this, false not to

def st_store_fetch(sti, *args, **kwargs):
    if sti.data: return
    path = sti.filesystem_path
    have_content = None
    content = []
    myit = My_Item()
    with open(path, "r", encoding="UTF-8") as f:
        for line in f:
            if have_content is None:
                if line.startswith("From:"):
                    myit.sender = line[5:]
                elif line.startswith("Subject:"):
                    myit.subject = line[8:]
                elif line.startswith("Date:"):
                    myit.date = line[5:]
                elif line == "\n":
                    have_content = True
            else:
                content.append(line)

    myit.head_content = content #elm_entry_utf8_to_markup(content)
    sti.data = myit

def st_store_unfetch(sti, *args, **kwargs):
    print("unfetch")

def store_clicked(obj):
    win = StandardWindow("store", "Store")
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win)
    gl.mode = ELM_LIST_COMPRESS
    gl.callback_selected_add(st_selected)
    gl.callback_clicked_double_add(st_double_clicked)
    gl.callback_longpressed_add(st_longpress)
    gl.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    gl.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(gl)
    gl.show()

    itc1 = GenlistItemClass()
    itc1.item_style = "message"

    st = Store()
    st.fs_list_func_set(st_store_list)
    st.fetch_func_set(st_store_fetch)
    #st.fetch_thread = False
    #st.unfetch_func_set(st_store_unfetch)
    st.items_sorted = False
    st.target_genlist = gl
    st.filesystem_directory = "."

    win.size = 480, 800
    win.show()

if __name__ == "__main__":

    store_clicked(None)

    elementary.run()
