#!/usr/bin/env python
# encoding: utf-8

from efl import elementary
from efl import evas


def my_entry_bt_1(bt, en):
    en.entry_set("")

def my_entry_bt_2(bt, en):
    str = en.entry_get()
    print(("ENTRY: %s" % str))

def my_entry_bt_3(bt, en):
    str = en.selection_get()
    print(("SELECTION: %s" % str))

def my_entry_bt_4(bt, en):
    en.entry_insert("Insert some <b>BOLD</> text")

def my_entry_anchor_test(obj, anchor, en, *args, **kwargs):
    en.entry_insert("ANCHOR CLICKED")


def entry_clicked(obj, item=None):
    win = elementary.Window("entry", elementary.ELM_WIN_BASIC)
    win.title_set("Entry")
    win.autodel_set(True)

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = elementary.Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    en = elementary.Entry(win)
    en.line_wrap_set(False)
    en.entry_set("This is an entry widget in this window that<br>"
                 "uses markup <b>like this</> for styling and<br>"
                 "formatting <em>like this</>, as well as<br>"
                 "<a href=X><link>links in the text</></a>, so enter text<br>"
                 "in here to edit it. By the way, links are<br>"
                 "called <a href=anc-02>Anchors</a> so you will need<br>"
                 "to refer to them this way.")
    en.callback_anchor_clicked_add(my_entry_anchor_test, en)
    en.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    en.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bx.pack_end(en)
    en.show()

    bx2 = elementary.Box(win)
    bx2.horizontal_set(True)
    bx2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)

    bt = elementary.Button(win)
    bt.text_set("Clear")
    bt.callback_clicked_add(my_entry_bt_1, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = elementary.Button(win)
    bt.text_set("Print")
    bt.callback_clicked_add(my_entry_bt_2, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = elementary.Button(win)
    bt.text_set("Selection")
    bt.callback_clicked_add(my_entry_bt_3, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = elementary.Button(win)
    bt.text_set("Insert")
    bt.callback_clicked_add(my_entry_bt_4, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    en.focus_set(True)
    win.show()


def entry_scrolled_clicked(obj, item=None):
    win = elementary.Window("entry", elementary.ELM_WIN_BASIC)
    win.title_set("Scrolled Entry")
    win.autodel_set(True)

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    en = elementary.Entry(win)
    win.resize_object_add(en)
    en.scrollable_set(True)
    en.line_wrap_set(False)
    en.entry_set("This is an entry widget in this window that<br>"
                 "uses markup <b>like this</> for styling and<br>"
                 "formatting <em>like this</>, as well as<br>"
                 "<a href=X><link>links in the text</></a>, so enter text<br>"
                 "in here to edit it. By the way, links are<br>"
                 "called <a href=anc-02>Anchors</a> so you will need<br>"
                 "to refer to them this way.<br><br>" * 10)
    en.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    en.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    en.size_hint_min_set(200, 200)
    en.show()

    en.focus_set(True)
    win.show()


def anchor_clicked(obj, event_info):
    print(("Entry object is %s" % (obj)))
    print(("We should have EntryAnchorInfo here: %s" % (str(event_info))))
    print(("EntryAnchorInfo has the following properties and methods: %s" % (dir(event_info))))

def anchor_hover_opened(obj, event_info):
    print(("We should have EntryAnchorHoverInfo here: %s" % (event_info)))
    print(("EntryAnchorHoverInfo has the following properties and methods: %s" % (dir(event_info))))
    btn = Button(obj)
    btn.text_set("Testing entry anchor")
    event_info.hover.content_set("middle", btn)
    btn.show()

def entry_anchor_clicked(obj, item=None):
    win = elementary.Window("entry", elementary.ELM_WIN_BASIC)
    win.title_set("Entry Anchor")
    win.autodel_set(True)

    bg = elementary.Background(win)
    bg.size_hint_weight_set(1.0, 1.0)
    win.resize_object_add(bg)
    bg.show()

    box = elementary.Box(win)
    box.size_hint_weight_set(1.0, 1.0)
    win.resize_object_add(box)

    entry = elementary.Entry(win)
    entry.text_set("<a href=url:http://www.enlightenment.org/>Enlightenment</a>")
    entry.callback_anchor_clicked_add(anchor_clicked)
    entry.anchor_hover_style_set("popout")
    entry.anchor_hover_parent_set(win)
    entry.callback_anchor_hover_opened_add(anchor_hover_opened)
    entry.show()

    frame = elementary.Frame(win)
    frame.size_hint_align_set(-1.0, -1.0)
    frame.text_set("Entry test")
    frame.content_set(entry)
    frame.show()

    box.pack_end(frame)
    box.show()

    win.resize(400, 400)
    win.show()


if __name__ == "__main__":
    def destroy(obj):
        elementary.exit()

    elementary.init()
    win = elementary.Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = elementary.Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = elementary.Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = elementary.Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = elementary.Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [("Entry", entry_clicked),
             ("Entry Scrolled", entry_scrolled_clicked),
             ("Entry Anchor", entry_anchor_clicked)
            ]

    li = elementary.List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
