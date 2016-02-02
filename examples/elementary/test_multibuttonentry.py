#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary import StandardWindow
from efl.elementary import Box
from efl.elementary import Button
from efl.elementary import MultiButtonEntry
from efl.elementary import Scroller, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_AUTO

SCROLL_POLICY_VERT = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_AUTO

counter = 0

def cb_item_selected(mbe, item):
    print("ITEM SELECTED", item)

def cb_item_clicked(mbe, item):
    print("ITEM CLICKED", item)

def cb_item_longpressed(mbe, item):
    print("ITEM LONGPRESSED", item)


def cb_btn_item_prepend(btn, mbe):
    global counter

    counter += 1
    mbe.item_prepend("item #%d" % (counter), cb_item_selected)

def cb_btn_item_append(btn, mbe):
    global counter

    counter += 1
    mbe.item_append("item #%d" % (counter), cb_item_selected)

def cb_btn_item_insert_after(btn, mbe):
    global counter

    counter += 1
    after = mbe.selected_item
    mbe.item_insert_after(after, "item #%d" % (counter), cb_item_selected)

def cb_btn_item_insert_before(btn, mbe):
    global counter

    counter += 1
    before = mbe.selected_item
    mbe.item_insert_before(before, "item #%d" % (counter), cb_item_selected)

def cb_btn_clear2(btn, mbe):
    for item in mbe.items:
        item.delete()

def cb_filter1(mbe, text):
    print(text)
    return True

def cb_filter2(mbe, text):
    if text == "nope":
        return False
    else:
        return True

def cb_print(btn, mbe):
    for i in mbe.items:
        print(i.text)

def custom_format_func(count):
    return "+ {} rabbits".format(count)


def multibuttonentry_clicked(obj, item=None):
    win = StandardWindow("multibuttonentry", "MultiButtonEntry test",
        autodel=True, size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    mbe = MultiButtonEntry(win, size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_BOTH, text="To: ")
    mbe.callback_item_selected_add(cb_item_selected)
    mbe.callback_item_clicked_add(cb_item_clicked)
    mbe.callback_item_longpressed_add(cb_item_longpressed)
    mbe.part_text_set("guide", "Tap to add recipient. Type \"nope\" to test filter rejection.")
    mbe.filter_append(cb_filter1)
    mbe.filter_append(cb_filter2)
    mbe.show()

    sc = Scroller(win, bounce=(False, True), policy=SCROLL_POLICY_VERT,
        size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH, content=mbe)
    vbox.pack_end(sc)
    sc.show()

    print(mbe.entry)

    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="item_append", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_item_append, mbe)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="item_prepend", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_item_prepend, mbe)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="item_insert_after", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_item_insert_after, mbe)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="item_insert_before", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_item_insert_before, mbe)
    hbox.pack_end(bt)
    bt.show()


    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="delete selected item", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda btn: mbe.selected_item.delete())
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="clear", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda bt: mbe.clear())
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="clear2", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_btn_clear2, mbe)
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="toggle expand", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda btn: mbe.expanded_set(not mbe.expanded_get()))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="print", size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(cb_print, mbe)
    hbox.pack_end(bt)
    bt.show()


    hbox = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    vbox.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Change format function",
                size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: mbe.format_function_set(custom_format_func))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Unset format function",
                size_hint_align=FILL_HORIZ, size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(lambda b: mbe.format_function_set(None))
    hbox.pack_end(bt)
    bt.show()

    mbe.focus = True

    win.show()


if __name__ == "__main__":

    import logging
    elog = logging.getLogger("efl")
    elog.setLevel(logging.INFO)

    elog_form = logging.Formatter(
        "[%(name)s] %(levelname)s in %(funcName)s:%(lineno)d - %(message)s"
        )
    elog_hdlr = logging.StreamHandler()
    elog_hdlr.setFormatter(elog_form)

    elog.addHandler(elog_hdlr)

    multibuttonentry_clicked(None)

    elementary.run()
