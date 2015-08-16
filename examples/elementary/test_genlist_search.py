#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, Box, Check, Label, Frame, \
    Entry, Genlist, GenlistItemClass


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


cities = ("Albany","Annapolis","Atlanta","Augusta","Austin","Baton Rouge",
"Bismarck","Boise","Boston","Carson City","Charleston","Cheyenne","Columbia",
"Columbus","Concord","Denver","Des Moines","Dover","Frankfort","Harrisburg",
"Hartford","Helena","Honolulu","Indianapolis","Jackson","Jefferson City",
"Juneau","Lansing","Lincoln","Little Rock","Madison","Montgomery","Montpelier",
"Nashville","Oklahoma City","Olympia","Phoenix","Pierre","Providence",
"Raleigh","Richmond","Sacramento","Saint Paul","Salem","Salt Lake City",
"Santa Fe","Springfield","Tallahassee","Topeka","Trenton"
)

class MyItemClass(GenlistItemClass):
    def text_get(self, obj, part, data):
        if part == "elm.text":
            return data

    def content_get(self, obj, part, data):
        if part == "elm.swallow.icon":
            return Icon(obj, file=os.path.join(img_path, "logo_small.png"))

def genlist_search_cb(en, gl, tg):
    flags = elm.ELM_GLOB_MATCH_NOCASE if tg.state == False else 0
    from_item = gl.selected_item.next if gl.selected_item else None

    item = gl.search_by_text_item_get(from_item, "elm.text", en.text, flags)
    if item:
        item.selected = True
        en.focus = True
    elif gl.selected_item:
        gl.selected_item.selected = False


def test_genlist_search(parent):
    win = StandardWindow("genlist-search", "Genlist Search by Text",
                         size=(300,520), autodel=True)

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    lb = Label(win)
    lb.text = \
    "<align=left>This example show the usage of search_by_text_item_get().<br>" \
    "Enter a search string and press Enter to show the next result.<br>" \
    "Search will start from the selected item (not included).<br>" \
    "You can search using glob patterns.</align>"
    fr = Frame(win, text="Information", content=lb,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(fr)
    fr.show()

    tg = Check(win, style="toggle", text="Case Sensitive Search");
    bx.pack_end(tg)
    tg.show()

    en = Entry(win, single_line=True, scrollable=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.part_text_set("guide", "Type the search query")
    en.callback_activated_add(genlist_search_cb, gl, tg)
    bx.pack_end(en)
    en.show()

    itc = MyItemClass()
    for name in cities:
        gl.item_append(itc, name)

    bx.pack_end(gl)
    gl.show()

    en.focus = True
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_search(None)
    elm.run()
