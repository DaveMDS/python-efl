#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.check import Check
from efl.elementary.index import Index
from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass
from efl.elementary.separator import Separator


def gl_text_get(gl, part, data):
    return str(data)

def cb_idx_item(idx, item, gl_item):
    print(("Current Index: %s" % (item.letter)))

def cb_idx_changed(idx, item):
    print(("changed event on: %s" % (item.letter)))

def cb_idx_delay_changed(idx, item):
    print(("delay_changed event on: %s" % (item.letter)))
    gl_item = item.data["gl_item"]
    gl_item.bring_in()

def cb_idx_selected(idx, item):
    print(("selected event on: %s" % (item.letter)))


def index_clicked(obj):
    win = StandardWindow("index", "Index test", autodel=True, size=(320, 480))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    # index
    idx = Index(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    idx.callback_delay_changed_add(cb_idx_delay_changed)
    idx.callback_changed_add(cb_idx_changed)
    idx.callback_selected_add(cb_idx_selected)
    win.resize_object_add(idx)
    idx.show()

    # genlist
    itc = GenlistItemClass(item_style="default",
                           text_get_func=gl_text_get)
                           # content_get_func=gl_content_get,
                           # state_get_func=gl_state_get)
    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(gl)
    gl.show()


    for i in 'ABCDEFGHILMNOPQRSTUVZ':
        for j in 'acegikmo':
            gl_item = gl.item_append(itc, i + j)
            if j == 'a':
                idx_item = idx.item_append(i, cb_idx_item, gl_item)
                idx_item.data["gl_item"] = gl_item

    idx.level_go(0)

    sep = Separator(win, horizontal=True)
    vbox.pack_end(sep)
    sep.show()

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    ck = Check(win, text="autohide_disabled")
    ck.callback_changed_add(lambda ck: idx.autohide_disabled_set(ck.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="indicator_disabled")
    ck.callback_changed_add(lambda ck: idx.indicator_disabled_set(ck.state))
    hbox.pack_end(ck)
    ck.show()

    ck = Check(win, text="horizontal")
    ck.callback_changed_add(lambda ck: idx.horizontal_set(ck.state))
    hbox.pack_end(ck)
    ck.show()

    win.show()


if __name__ == "__main__":

    index_clicked(None)

    elementary.run()
