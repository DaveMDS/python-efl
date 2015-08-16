#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL

from efl import elementary as elm
from efl.elementary import StandardWindow, Icon, Genlist, GenlistItemClass



script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")



# normal items class functions
def gl_text_get(obj, part, item_data):
    return "Item # %i" % (item_data,)

def gl_content_get(obj, part, item_data):
    return Icon(obj, file=os.path.join(img_path, "logo_small.png"))


# group items class functions
def glg_text_get(obj, part, item_data):
    return "Group # %i" % (item_data,)

def glg_content_get(obj, part, data):
    ic = Icon(obj, file=os.path.join(img_path, "logo.png"),
              size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    return ic


def test_genlist_group(parent):
    win = StandardWindow("Genlist", "Genlist Group test",
                         size=(320,320), autodel=True)

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gl)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get)

    itc_g = GenlistItemClass(item_style="group_index",
                             text_get_func=glg_text_get,
                             content_get_func=glg_content_get)

    for i in range(300):
        if i % 10 == 0:
            git = gl.item_append(itc_g, i / 10,
                                 flags=elm.ELM_GENLIST_ITEM_GROUP)
            git.select_mode_set(elm.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY)
        gl.item_append(itc_i, i, git)

    win.show()

if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_group(None)
    elm.run()
