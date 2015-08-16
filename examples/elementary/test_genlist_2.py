#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ

from efl import elementary as elm
from efl.elementary import Window, Background, Box, Button, Icon, \
    Genlist, GenlistItemClass


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


# item class functions
def gl_text_get(obj, part, item_data):
    return "Item # %i" % (item_data,)

def gl_content_get(obj, part, item_data):
    ic = Icon(obj, file=os.path.join(img_path, "logo_small.png"))
    return ic

# genlist callbacks
def item_selected_cb(item, gl, item_data):
    print("\n---GenlistItem selected---")
    print(item)
    print(gl)
    print(("item_data: %s" % item_data))


# just an auto incrementing counter
class MyCounter:
    def __init__(self):
        self._i = 0

    @property
    def i(self):
        self._i += 1
        return self._i

my_counter = MyCounter()


def test_genlist_2(parent):
    win = Window("Genlist", elm.ELM_WIN_BASIC, title="Genlist test 2",
                 autodel=True, size=(320, 320))

    # window background
    bg = Background(win, file=os.path.join(img_path, "plant_01.jpg"),
                    size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    # main vertical box
    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    # the Genlist widget
    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.show()
    box.pack_end(gl)

    itc1 = GenlistItemClass(item_style="default",
                            text_get_func=gl_text_get,
                            content_get_func=gl_content_get)

    gl.item_append(itc1, 1001, func=item_selected_cb)
    gl.item_append(itc1, 1002, func=item_selected_cb)
    gl.item_append(itc1, 1003, func=item_selected_cb)
    gl.item_append(itc1, 1004, func=item_selected_cb)
    gl.item_append(itc1, 1005, func=item_selected_cb)
    gl.item_append(itc1, 1006, func=item_selected_cb)
    gl.item_append(itc1, 1007, func=item_selected_cb)


    ### horizontal buttons box
    box2 = Box(win, horizontal=True, homogeneous=True,
              size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    box.pack_end(box2)
    box2.show()

    # select first item
    def select_first_item_cb(bt, gl):
        gli = gl.first_item
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win, text="First", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(select_first_item_cb, gl)
    box2.pack_end(bt)
    bt.show()

    # select last item
    def select_last_item_cb(bt, gl):
        gli = gl.last_item_get()
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win, text="Last", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(select_last_item_cb, gl)
    box2.pack_end(bt)
    bt.show()

    # disable item
    def disable_item_cb(bt, gl):
        gli = gl.selected_item
        if gli:
            gli.disabled = True
        else:
            print("no item selected")

    bt = Button(win, text="Disable", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(disable_item_cb, gl)
    box2.pack_end(bt)
    bt.show()

    # update all items
    def update_all_cb(bt, gl):
        gli = gl.first_item_get()
        while gli:
            print("Item data: %d" % gli.data)
            gli.update()
            gli = gli.next_get()

    bt = Button(win, text="Update all", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(update_all_cb, gl)
    box2.pack_end(bt)
    bt.show()


    ### horizontal buttons box
    box2 = Box(win, horizontal=True, homogeneous=True,
              size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    box.pack_end(box2)
    box2.show()

    # genlist clear
    bt = Button(win, text="Clear", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: gl.clear())
    box2.pack_end(bt)
    bt.show()

    # genlist apend
    def append_item_cb(bt, gl, itc1):
        gl.item_append(itc1, my_counter.i, func=item_selected_cb)

    bt = Button(win, text="Append", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(append_item_cb, gl, itc1)
    box2.pack_end(bt)
    bt.show()

    # item delete
    def delete__item_cb(bt, gl):
        gli = gl.selected_item_get()
        if gli:
            gli.delete()
        else:
            print("no item selected")

    bt = Button(win, text="Delete", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(delete__item_cb, gl)
    box2.pack_end(bt)
    bt.show()


    ### horizontal buttons box
    box2 = Box(win, horizontal=True, homogeneous=True,
              size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    box.pack_end(box2)
    box2.show()

    # insert before
    def insert_before_cb(bt):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_before(itc1, my_counter.i, gli,
                                  func=item_selected_cb)
        else:
            print("no item selected")

    bt = Button(win, text="Insert before", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(insert_before_cb)
    box2.pack_end(bt)
    bt.show()

    # insert after
    def insert_after_cb(bt):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_after(itc1, my_counter.i, gli, func=item_selected_cb)
        else:
            print("no item selected")

    bt = Button(win, text="Insert after", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(insert_after_cb)
    box2.pack_end(bt)
    bt.show()

    # flush
    bt = Button(win, text="Flush", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: elm.cache_all_flush())
    box2.pack_end(bt)
    bt.show()

    # show the whole window
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_2(None)
    elm.run()
