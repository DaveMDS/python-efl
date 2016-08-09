#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ

from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Entry, Genlist, GenlistItemClass


names = [
   "Aaliyah", "Aamir", "Aaralyn", "Aaron", "Abagail",
   "Babitha", "Bahuratna", "Bandana", "Bulbul", "Cade", "Caldwell",
   "Chandan", "Caster", "Dagan", "Daulat", "Dag", "Earl", "Ebenzer",
   "Ellison", "Elizabeth", "Filbert", "Fitzpatrick", "Florian", "Fulton",
   "Frazer", "Gabriel", "Gage", "Galen", "Garland", "Gauhar", "Hadden",
   "Hafiz", "Hakon", "Haleem", "Hank", "Hanuman", "Jabali", "Jaimini",
   "Jayadev", "Jake", "Jayatsena", "Jonathan", "Kamaal", "Jeirk",
   "Jasper", "Jack", "Mac", "Macy", "Marlon", "Milson"
]


# item class functions
def gl_text_get(obj, part, item_data):
    return item_data

def gl_filter_get(obj, key, item_data):
    print('"%s" -> "%s"' % (item_data, key))
    if not key:
        return True
    if key.lower() in item_data.lower():
        return True
    return False


def entry_changed_cb(en, gl):
    gl.filter = en.text or None

def filter_done_cb(gl):
    print("filter,done")
    print("Filtered items count: ", gl.filtered_items_count())

def test_genlist_filter(parent):
    win = StandardWindow("genlist-filter", "Genlist Filter", autodel=True,
                         size=(420, 600), focus_highlight_enabled=True)

    # main vertical box
    box = Box(win, size_hint_expand=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    
    # the Genlist widget
    gl = Genlist(win, mode=elm.ELM_LIST_COMPRESS, homogeneous=True,
                 select_mode=elm.ELM_OBJECT_SELECT_MODE_ALWAYS,
                 size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    gl.callback_filter_done_add(filter_done_cb)
    gl.show()
    box.pack_end(gl)

    itc = GenlistItemClass(item_style="default",
                           text_get_func=gl_text_get,
                           filter_get_func=gl_filter_get)

    for i in range(500):
        gl.item_append(itc, names[i % len(names)])


    # the entry
    en = Entry(box, single_line=True,
               size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    en.part_text_set('guide', 'Type here to filter items')
    en.callback_changed_user_add(entry_changed_cb, gl)
    box.pack_start(en)
    en.show()


    #
    win.show()
    en.focus = True


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_filter(None)
    elm.run()
