#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import Window, StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry, ELM_SCROLLER_POLICY_OFF, \
    ELM_SCROLLER_POLICY_ON, Entry_markup_to_utf8
from efl.elementary.list import List
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.separator import Separator
from efl.elementary.icon import Icon

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL

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
    win = Window("entry", elementary.ELM_WIN_BASIC)
    win.title_set("Entry")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    en = Entry(win)
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

    bx2 = Box(win)
    bx2.horizontal_set(True)
    bx2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)

    bt = Button(win)
    bt.text_set("Clear")
    bt.callback_clicked_add(my_entry_bt_1, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Print")
    bt.callback_clicked_add(my_entry_bt_2, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win)
    bt.text_set("Selection")
    bt.callback_clicked_add(my_entry_bt_3, en)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win)
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


def scrolled_entry_bt_1(obj, data):
    en = data
    en.text = ""

def scrolled_entry_bt_2(obj, data):
    en = data
    s = en.text
    print("ENTRY:")
    if s: print(s)
    print("ENTRY PLAIN UTF8:")
    if s:
        s = Entry_markup_to_utf8(s)
        if s:
            print(s)

def scrolled_entry_bt_3(obj, data):
    en = data
    s = en.selection
    print("SELECTION:")
    if s: print(s)
    print("SELECTION PLAIN UTF8:")
    if s:
        s = elm_entry_markup_to_utf8(s)
        if s:
             print(s)

def scrolled_entry_bt_4(obj, data):
    en = data
    en.entry_insert("Insert some <b>BOLD</> text")

def scrolled_entry_bt_5(obj, data):
    en = data
    s = en.text
    print("PASSWORD: '%s'" % (s,))

def scrolled_anchor_test(obj, anchor, data):
    en = data
    en.entry_insert("ANCHOR CLICKED")

def entry_scrolled_clicked(obj, item = None):
    #static Elm_Entry_Filter_Accept_Set digits_filter_data, digits_filter_data2;
    #static Elm_Entry_Filter_Limit_Size limit_filter_data, limit_filter_data2;


    win = StandardWindow("entry-scrolled", "Entry Scrolled")
    win.autodel = True

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(bx)
    bx.show()

    # disabled entry
    en = Entry(win)
    en.scrollable = True
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    en.text = "Disabled entry"
    en.single_line = True
    en.disabled = True
    en.show()
    bx.pack_end(en)

    # password entry
    en = Entry(win)
    en.scrollable = True
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    en.password = True
    en.single_line = True
    en.text = "Access denied, give up!"
    en.disabled = True
    en.show()
    bx.pack_end(en)

    # multi-line disable entry
    en = Entry(win)
    en.scrollable = True
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.scrollbar_policy = ELM_SCROLLER_POLICY_ON, ELM_SCROLLER_POLICY_ON
    en.disabled = True
    en.context_menu_item_add("Hello")
    en.context_menu_item_add("World")
    en.text = "Multi-line disabled entry widget :)<br/>"\
        "We can use markup <b>like this</> for styling and<br/>"\
        "formatting <em>like this</>, as well as<br/>"\
        "<a href=X><link>links in the text</></a>,"\
        "but it won't be editable or clickable."
    en.show()
    bx.pack_end(en)

    sp = Separator(win)
    sp.horizontal = True
    bx.pack_end(sp)
    sp.show()

    # Single line selected entry
    en = Entry(win)
    en.scrollable = True
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    en.text = "This is a single line"
    en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    en.single_line = True
    en.select_all()
    en.show()
    bx.pack_end(en)

    # # Only digits entry
    # en = Entry(win)
    # en.scrollable = True
    # en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    # en.size_hint_align = EVAS_HINT_FILL, 0.5
    # en.text = "01234"
    # en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    # en.single_line = True
    # en.show()
    # bx.pack_end(en)

    # digits_filter_data.accepted = "0123456789"
    # digits_filter_data.rejected = NULL
    # en.markup_filter_append(elm_entry_filter_accept_set, digits_filter_data)

    # # No digits entry
    # en = Entry(win)
    # en.scrollable = True
    # en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    # en.size_hint_align = EVAS_HINT_FILL, 0.5
    # en.text = "No numbers here"
    # en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    # en.single_line = True
    # en.show()
    # bx.pack_end(en)

    # digits_filter_data2.accepted = NULL
    # digits_filter_data2.rejected = "0123456789"
    # en.markup_filter_append(elm_entry_filter_accept_set, digits_filter_data2)

    # # Size limited entry
    # en = Entry(win)
    # en.scrollable = True
    # en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    # en.size_hint_align = EVAS_HINT_FILL, 0.5
    # en.text = "Just 20 chars"
    # en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    # en.single_line = True
    # en.show()
    # bx.pack_end(en)

    # limit_filter_data.max_char_count = 20
    # limit_filter_data.max_byte_count = 0
    # en.markup_filter_append(elm_entry_filter_limit_size, limit_filter_data)

    # # Byte size limited entry
    # en = Entry(win)
    # en.scrollable = True
    # en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    # en.size_hint_align = EVAS_HINT_FILL, 0.5
    # en.text = "And now only 30 bytes"
    # en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    # en.single_line = True
    # en.show()
    # bx.pack_end(en)

    # limit_filter_data2.max_char_count = 0
    # limit_filter_data2.max_byte_count = 30
    # en.markup_filter_append(elm_entry_filter_limit_size, limit_filter_data2)

    # Single line password entry
    en_p = Entry(win)
    en_p.scrollable = True
    en_p.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en_p.size_hint_align = EVAS_HINT_FILL, 0.5
    en_p.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    en_p.text = "Password here"
    en_p.single_line = True
    en_p.password = True
    en_p.show()
    bx.pack_end(en_p)

    # entry with icon/end widgets
    en = Entry(win)
    en.scrollable = True
    en.scrollbar_policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    en.single_line = True
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt = Icon(win)
    bt.standard = "home"
    bt.size_hint_min = 48, 48
    bt.color = 128, 0, 0, 128
    bt.show()
    en.part_content_set("icon", bt)
    bt = Icon(win)
    bt.standard = "delete"
    bt.color = 128, 0, 0, 128
    bt.size_hint_min = 48, 48
    bt.show()
    en.part_content_set("end", bt)
    en.text = "entry with icon and end objects"
    en.show()
    bx.pack_end(en)

    # markup entry
    en = Entry(win)
    en.scrollable = True
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.scrollbar_policy = ELM_SCROLLER_POLICY_ON, ELM_SCROLLER_POLICY_ON
    en.text = "This is an entry widget in this window that<br/>"\
        "uses markup <b>like this</> for styling and<br/>"\
        "formatting <em>like this</>, as well as<br/>"\
        "<a href=X><link>links in the text</></a>, so enter text<br/>"\
        "in here to edit it. By them way, links are<br/>"\
        "called <a href=anc-02>Anchors</a> so you will need<br/>"\
        "to refer to them this way. At the end here is a really long "\
        "line to test line wrapping to see if it works. But just in "\
        "case this line is not long enough I will add more here to "\
        "really test it out, as Elementary really needs some "\
        "good testing to see if entry widgets work as advertised."
    en.callback_anchor_clicked_add(scrolled_anchor_test, en)
    en.show()
    bx.pack_end(en)

    bx2 = Box(win)
    bx2.horizontal = True
    bx2.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    bt = Button(win)
    bt.text = "Clear"
    bt.callback_clicked_add(scrolled_entry_bt_1, en)
    bt.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.pack_end(bt)
    bt.propagate_events = 0
    bt.focus_allow = 0
    bt.show()

    bt = Button(win)
    bt.text = "Print"
    bt.callback_clicked_add(scrolled_entry_bt_2, en)
    bt.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.pack_end(bt)
    bt.propagate_events = 0
    bt.focus_allow = 0
    bt.show()

    bt = Button(win)
    bt.text = "Print pwd"
    bt.callback_clicked_add(scrolled_entry_bt_5, en_p)
    bt.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.pack_end(bt)
    bt.propagate_events = 0
    bt.focus_allow = 0
    bt.show()

    bt = Button(win)
    bt.text = "Selection"
    bt.callback_clicked_add(scrolled_entry_bt_3, en)
    bt.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.pack_end(bt)
    bt.propagate_events = 0
    bt.focus_allow = 0
    bt.show()

    bt = Button(win)
    bt.text = "Insert"
    bt.callback_clicked_add(scrolled_entry_bt_4, en)
    bt.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bt.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    bx2.pack_end(bt)
    bt.propagate_events = 0
    bt.focus_allow = 0
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.size = 320, 300

    win.focus_set(True)
    win.show()

def anchor_clicked(obj, event_info):
    print(("Entry object is %s" % (obj)))
    print(("We should have EntryAnchorInfo here: %s" % (str(event_info))))
    print(("EntryAnchorInfo has the following properties and methods: %s" % (dir(event_info))))
    print(event_info.name)

def anchor_hover_opened(obj, event_info):
    print(("We should have EntryAnchorHoverInfo here: %s" % (event_info)))
    print(("EntryAnchorHoverInfo has the following properties and methods: %s" % (dir(event_info))))
    print(event_info.anchor_info.name)
    btn = Button(obj)
    btn.text_set("Testing entry anchor")
    event_info.hover.part_content_set("middle", btn)
    btn.show()

def entry_anchor_clicked(obj, item=None):
    win = Window("entry", elementary.ELM_WIN_BASIC)
    win.title_set("Entry Anchor")
    win.autodel_set(True)

    bg = Background(win)
    bg.size_hint_weight_set(1.0, 1.0)
    win.resize_object_add(bg)
    bg.show()

    box = Box(win)
    box.size_hint_weight_set(1.0, 1.0)
    win.resize_object_add(box)

    entry = Entry(win)
    entry.text_set("<a href=url:http://www.enlightenment.org/>Enlightenment</a>")
    entry.callback_anchor_clicked_add(anchor_clicked)
    entry.anchor_hover_style_set("popout")
    entry.anchor_hover_parent_set(win)
    entry.callback_anchor_hover_opened_add(anchor_hover_opened)
    entry.show()

    frame = Frame(win)
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
    win = Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [("Entry", entry_clicked),
             ("Entry Scrolled", entry_scrolled_clicked),
             ("Entry Anchor", entry_anchor_clicked)
            ]

    li = List(win)
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
