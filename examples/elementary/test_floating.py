#!/usr/bin/env python
# encoding: utf-8

import os
from math import sin

from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass, \
    ELM_GENLIST_ITEM_NONE
from efl.elementary.icon import Icon
from efl.ecore import Animator, loop_time_get
from efl.evas import EVAS_ASPECT_CONTROL_VERTICAL, EVAS_HINT_EXPAND, \
    EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

class ItemClass(GenlistItemClass):
    def text_get(self, obj, part, *args, **kwargs):
       return "Item #{0}".format(args[0])

    def content_get(self, obj, part, *args, **kwargs):
        ic = Icon(obj, file=os.path.join(img_path, "logo_small.png"),
            size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
        return ic

def gl_sel_cb(obj, event_info, data):
    print("sel item data [{0}] on genlist obj [{1}], item [{2}]".format(data, obj, event_info))

def anim(*args, **kwargs):
    gl = args[0]
    y = 0
    x = (sin(loop_time_get()) * 500)
    gl.move(x, y)

    return True

def del_cb(obj, *args, **kwargs):
    ani = args[0]
    ani.delete()

def floating_clicked(obj):
    win = StandardWindow("floating", "Floating", autodel=True, size=(480, 800))

    gl = Genlist(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        pos=(800, 0), size=(480, 800))
    gl.show()

    for i in range(20):
        GenlistItem(ItemClass(), i, None, ELM_GENLIST_ITEM_NONE, gl_sel_cb, i).append_to(gl)

    win.show()

    ani = Animator(anim, gl)
    win.callback_delete_request_add(del_cb, ani)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

if __name__ == "__main__":

    floating_clicked(None)

    elementary.run()
