#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL
from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Button, Icon, Separator, \
    Combobox, GenlistItemClass, Label


class ComboboxItemClass(GenlistItemClass):
    def text_get(self, gl, part, item_data):
        return item_data

    def content_get(self, gl, part, item_data):
        if part == 'elm.swallow.end':
            return Icon(gl, standard='folder')
        else:
            return Icon(gl, standard='user-home')
    
    def filter_get(self, gl, key, item_data):
        if not key:
            return True
        if key.lower() in item_data.lower():
            return True
        return False


def btn_click_cb(btn, cbox):
    if cbox.expanded:
        cbox.hover_end()
    else:
        cbox.hover_begin()

def combobox_item_pressed_cb(cbox, item):
    print("ITEM,PRESSED", item)
    cbox.text = item.text
    cbox.hover_end()

def combobox_changed_cb(cbox):
    cbox.filter = cbox.text

def generic_obj_cb(cbox, event_name):
    print("EV", event_name, cbox)

def generic_item_cb(cbox, item, event_name):
    print("EV", event_name, item)

def combobox_clicked(obj):
    win = StandardWindow("combobox", "Combobox", autodel=True, size=(320, 500))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    itc = ComboboxItemClass()

    # combo 1 - a short list with callbacks
    cbox1 = Combobox(win, size_hint_expand=EXPAND_HORIZ,
                     size_hint_fill=FILL_HORIZ)
    cbox1.part_text_set("guide", "A short list (with callbacks attached)")
    cbox1.callback_item_pressed_add(combobox_item_pressed_cb)
    cbox1.callback_dismissed_add(generic_obj_cb, "DISMISSED")
    cbox1.callback_expanded_add(generic_obj_cb, "EXPANDED")
    cbox1.callback_clicked_add(generic_obj_cb, "CLICKED")
    cbox1.callback_item_selected_add(generic_item_cb, "ITEM,SELECTED")

    for i in range(1, 7):
        cbox1.item_append(itc,  "Item # %d" % i)
    bx.pack_end(cbox1)
    cbox1.show()

    # combo 2 - a long list with filtering
    cbox2 = Combobox(win, size_hint_expand=EXPAND_HORIZ,
                    size_hint_fill=FILL_HORIZ)
    cbox2.part_text_set("guide", "A long list (with item filtering)")
    cbox2.callback_item_pressed_add(combobox_item_pressed_cb)
    cbox2.callback_changed_add(combobox_changed_cb)
    cbox2.callback_filter_done_add(generic_obj_cb, "FILTER,DONE")

    for i in range(1, 1001):
        cbox2.item_append(itc, "Item # %d" % i)
    bx.pack_end(cbox2)
    cbox2.show()

    # combo 3 - disabled
    cbox3 = Combobox(win, text="Disabled Combobox", disabled=True,
                     size_hint_expand=EXPAND_HORIZ, size_hint_fill=FILL_HORIZ)
    cbox3.part_text_set("guide", "A long list")
    bx.pack_end(cbox3)
    cbox3.show()

    # expand-from-code button
    bt = Button(win, text="Toggle first combo hover state")
    bt.callback_clicked_add(btn_click_cb, cbox1)
    bx.pack_start(bt)
    bt.show()

    lb = Label(win, text="""<failure>
<big><b>THE COMBOBOX WIDGET IS BROKEN AND DEPRECATED.<br>
DO NOT USE IN ANY CASE.<b></big><br><br>
The behaviour and the API of the Combobox will change in future release.<br> <br>
If you are already using this we really encourage you to switch to other widgets.<br><br>
We are really sorry about this breakage, but there is nothing we can do to avoid this :( <br><br></failure>
""")
    bx.pack_start(lb)
    lb.show()

    #
    win.show()


if __name__ == "__main__":
    combobox_clicked(None)
    elm.run()

