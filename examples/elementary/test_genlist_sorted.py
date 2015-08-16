#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, \
    Genlist, GenlistItem, GenlistItemClass

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


# items class functions
def gl_text_get(obj, part, item_data):
    return "Item # %i" % (item_data,)

def gl_content_get(obj, part, item_data):
    return Icon(obj, file=os.path.join(img_path, "logo_small.png"))


# comparison function to sort items
def gl_comp_func(item1, item2):
    # If data1 is 'less' than data2, -1 must be returned, if it is 'greater',
    # 1 must be returned, and if they are equal, 0 must be returned.
    if item1.data < item2.data:
        return -1
    elif item1.data == item2.data:
        return 0
    elif item1.data > item2.data:
        return 1
    else:
        print("BAAAAAAAAD Comparison!")
        return 0


def test_genlist_sorted(parent):
    win = StandardWindow("Genlist", "Genlist sorted insert test",
                         size=(320,320), autodel=True)

    gl = Genlist(win, homogeneous=True, mode=elm.ELM_LIST_COMPRESS,
                 size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gl)
    gl.show()

    itc = GenlistItemClass(item_style="default",
                           text_get_func=gl_text_get,
                           content_get_func=gl_content_get)

    for i in range(100,-1,-1):
        gl.item_sorted_insert(itc, i, gl_comp_func)

    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_sorted(None)
    elm.run()
