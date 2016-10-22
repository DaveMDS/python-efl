#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.check import Check
from efl.elementary.configuration import Configuration
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry, Entry_markup_to_utf8, ELM_WRAP_WORD, \
    ELM_TEXT_FORMAT_PLAIN_UTF8
from efl.elementary.list import List
from efl.elementary.frame import Frame
from efl.elementary.hover import Hover
from efl.elementary.label import Label
from efl.elementary.separator import Separator
from efl.elementary.icon import Icon
from efl.elementary.scroller import Scrollable, ELM_SCROLLER_POLICY_OFF, \
    ELM_SCROLLER_POLICY_ON


SCROLL_POLICY_OFF = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
SCROLL_POLICY_ON = ELM_SCROLLER_POLICY_ON, ELM_SCROLLER_POLICY_ON

class ScrollableEntry(Scrollable, Entry):
    def __init__(self, canvas, *args, **kwargs):
        Entry.__init__(self, canvas, *args, **kwargs)
        self.scrollable = True


## Test "Entry"
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

def my_entry_bt_5(chk):
    Configuration().context_menu_disabled = chk.state

def my_entry_anchor_test(obj, anchor, en, *args, **kwargs):
    en.entry_insert("ANCHOR CLICKED")

def my_entry_bt_6(bt, en):
    en.select_region = (3, 10)

def my_entry_bt_7(bt, en):
    print("Sel region: ", en.select_region)

def entry_clicked(obj, item=None):
    win = StandardWindow("entry", "Entry", autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    en = Entry(win, line_wrap=False, size_hint_weight=EXPAND_BOTH,
               size_hint_align=FILL_BOTH)
    en.entry_set("This is an entry widget in this window that<br>"
                 "uses markup <b>like this</> for styling and<br>"
                 "formatting <em>like this</>, as well as<br>"
                 "<a href=X><link>links in the text</></a>, so enter text<br>"
                 "in here to edit it. By the way, links are<br>"
                 "called <a href=anc-02>Anchors</a> so you will need<br>"
                 "to refer to them this way.")
    en.callback_anchor_clicked_add(my_entry_anchor_test, en)
    bx.pack_end(en)
    en.show()

    bx2 = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
              size_hint_align=FILL_BOTH)

    bt = Button(win, text="Clear", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_1, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Print", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_2, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Selection", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_3, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Insert", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_4, en)
    bx2.pack_end(bt)
    bt.show()

    ck = Check(win, text="Context menu disabled")
    ck.callback_changed_add(my_entry_bt_5)
    bx2.pack_end(ck)
    ck.show()

    bx.pack_end(bx2)
    bx2.show()

    bx2 = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
              size_hint_align=FILL_BOTH)

    bt = Button(win, text="Sel region set", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_6, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Sel region get", size_hint_weight=EXPAND_HORIZ,
                size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(my_entry_bt_7, en)
    bx2.pack_end(bt)
    bt.show()

    ck = Check(win, text="Select allow", state=True)
    ck.callback_changed_add(lambda c: setattr(en, "select_allow", c.state))
    bx2.pack_end(ck)
    ck.show()
    
    bx.pack_end(bx2)
    bx2.show()

    en.focus_set(True)
    win.show()


## Test "Entry Scrolled"
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

def my_filter(obj, text, data):
    print(text, data)

def entry_scrolled_clicked(obj, item = None):
    #static Elm_Entry_Filter_Accept_Set digits_filter_data, digits_filter_data2;
    #static Elm_Entry_Filter_Limit_Size limit_filter_data, limit_filter_data2;


    win = StandardWindow("entry-scrolled", "Entry Scrolled", autodel=True,
                         size=(320, 300))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    # disabled entry
    en = ScrollableEntry(win, size_hint_weight=EXPAND_HORIZ,
                         size_hint_align=FILL_HORIZ, policy=SCROLL_POLICY_OFF,
                         text="Disabled entry", single_line=True, disabled=True)
    en.show()
    bx.pack_end(en)

    # password entry
    en = ScrollableEntry(win, size_hint_weight=EXPAND_HORIZ,
                         size_hint_align=FILL_HORIZ, policy=SCROLL_POLICY_OFF,
                         password=True, single_line=True, disabled=True,
                         text="Access denied, give up!")
    en.show()
    bx.pack_end(en)

    # multi-line disable entry
    en = ScrollableEntry(win, size_hint_weight=EXPAND_BOTH,
                         size_hint_align=FILL_BOTH, policy=SCROLL_POLICY_ON,
                         disabled=True)
    en.context_menu_item_add("Hello")
    en.context_menu_item_add("World")
    en.text = "Multi-line disabled entry widget :)<br/>"\
        "We can use markup <b>like this</> for styling and<br/>"\
        "formatting <em>like this</>, as well as<br/>"\
        "<a href=X><link>links in the text</></a>,"\
        "but it won't be editable or clickable."
    en.show()
    bx.pack_end(en)

    sp = Separator(win, horizontal=True)
    bx.pack_end(sp)
    sp.show()

    # Single line selected entry
    en = ScrollableEntry(win, size_hint_weight=EXPAND_HORIZ,
                         size_hint_align=FILL_HORIZ,
                         text="This is a single line",
                         policy=SCROLL_POLICY_OFF, single_line=True)
    en.select_all()
    en.show()
    bx.pack_end(en)

    # Filter test
    en = ScrollableEntry(win, size_hint_weight=EXPAND_HORIZ,
                         size_hint_align=FILL_HORIZ, text="Filter test",
                         policy=SCROLL_POLICY_OFF, single_line=True)
    en.show()
    bx.pack_end(en)

    en.markup_filter_append(my_filter, "test")

    # # Only digits entry
    # en = ScrollableEntry(win)
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
    # en = ScrollableEntry(win)
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
    # en = ScrollableEntry(win)
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
    # en = ScrollableEntry(win)
    # en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    # en.size_hint_align = EVAS_HINT_FILL, 0.5
    # en.text = "And now only 30 bytes"
    # en.policy = ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF
    # en.single_line = True
    # en.show()
    # bx.pack_end(en)

    # limit_filter_data2.max_char_count = 0
    # limit_filter_data2.max_byte_count = 30
    # en.markup_filter_append(elm_entry_filter_limit_size, limit_filter_data2)

    # Single line password entry
    en_p = ScrollableEntry(win, size_hint_weight=EXPAND_HORIZ,
                           size_hint_align=FILL_HORIZ, policy=SCROLL_POLICY_OFF,
                           text="Password here", single_line=True,
                           password=True)
    en_p.show()
    bx.pack_end(en_p)

    # entry with icon/end widgets
    en = ScrollableEntry(win, policy=SCROLL_POLICY_OFF,
                         single_line=True, size_hint_weight=EXPAND_BOTH,
                         size_hint_align=FILL_BOTH,
                         text="entry with icon and end objects")
    bt = Icon(win, standard="user-home", size_hint_min=(48, 48),
              color=(128, 0, 0, 128))
    bt.show()
    en.part_content_set("icon", bt)
    bt = Icon(win, standard="user-trash", size_hint_min=(48, 48),
              color=(128, 0, 0, 128))
    bt.show()
    en.part_content_set("end", bt)
    en.show()
    bx.pack_end(en)

    # markup entry
    en = ScrollableEntry(win, size_hint_weight=EXPAND_BOTH,
                         size_hint_align=FILL_BOTH, policy=SCROLL_POLICY_ON)
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

    bx2 = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
              size_hint_align=FILL_BOTH)

    bt = Button(win, text="Clear", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ, propagate_events=False,
                focus_allow=False)
    bt.callback_clicked_add(scrolled_entry_bt_1, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Print", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ, propagate_events=False,
                focus_allow=False)
    bt.callback_clicked_add(scrolled_entry_bt_2, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Print pwd", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ, propagate_events=False,
                focus_allow=False)
    bt.callback_clicked_add(scrolled_entry_bt_5, en_p)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Selection", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ, propagate_events=False,
                focus_allow=False)
    bt.callback_clicked_add(scrolled_entry_bt_3, en)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Insert", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_HORIZ, propagate_events=False,
                focus_allow=False)
    bt.callback_clicked_add(scrolled_entry_bt_4, en)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.focus_set(True)
    win.show()


## Test "Entry Anchor"
def anchor_clicked(obj, event_info):
    print("Entry object is %s" % (obj))
    print("We should have EntryAnchorInfo here: %s" % (str(event_info)))
    print("EntryAnchorInfo has the following properties and methods: %s" % (dir(event_info)))
    print(event_info.name)

def anchor_hover_opened(obj, event_info):
    print("We should have EntryAnchorHoverInfo here: %s" % (event_info))
    print("EntryAnchorHoverInfo has the following properties and methods: %s" % (dir(event_info)))
    print(event_info.anchor_info.name)
    btn = Button(obj, text="Testing entry anchor")
    event_info.hover.part_content_set("middle", btn)
    btn.show()

def entry_anchor_clicked(obj, item=None):
    win = StandardWindow("entry", "Entry Anchor", autodel=True, size=(400,400))

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)

    entry = Entry(win, anchor_hover_style="popout", anchor_hover_parent=win)
    entry.text = "<a href=url:http://www.enlightenment.org/>Enlightenment</a>"
    entry.callback_anchor_clicked_add(anchor_clicked)
    entry.callback_anchor_hover_opened_add(anchor_hover_opened)
    entry.show()

    frame = Frame(win, size_hint_align=FILL_BOTH, text="Entry test",
                  content=entry)
    frame.show()

    box.pack_end(frame)
    box.show()

    win.show()


## Test "Entry Notepad"
def entry_notepad_label_update(en, lb):
    lb.text = "<b>cursor</b>  pos:%d  char:'%s'  geom:%s" % (
               en.cursor_pos,
               en.cursor_content_get().replace('<','&lt;').replace('>','&gt;'),
               en.cursor_geometry_get()
              )

def entry_notepad_changed_cb(entry,  label):
    print("entry changed")

def entry_notepad_cursor_changed_cb(entry, label):
    print("cursor changed")
    entry_notepad_label_update(entry, label)


def entry_notepad_clicked(obj, item=None):
    win = StandardWindow("entry", "Entry Notepad", autodel=True, size=(400,400))

    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    label = Label(box, text="Info")
    box.pack_end(label)
    label.show()

    entry = Entry(box, scrollable=True, line_wrap=ELM_WRAP_WORD,
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    entry.callback_changed_add(entry_notepad_changed_cb, label)
    entry.callback_cursor_changed_add(entry_notepad_cursor_changed_cb, label)
    try: # do not fail if the file do not exists, entry can manage the case
        entry.file=("note.txt", ELM_TEXT_FORMAT_PLAIN_UTF8)
    except RuntimeError:
        pass
    box.pack_end(entry)
    entry.show()

    hbox = Box(box, horizontal=True, size_hint_weight=EXPAND_HORIZ)
    box.pack_end(hbox)
    hbox.show()

    bt = Button(hbox, text="Clear")
    bt.callback_clicked_add(lambda b: setattr(entry, "text", ""))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(hbox, text="Save")
    bt.callback_clicked_add(lambda b: entry.file_save())
    hbox.pack_end(bt)
    bt.show()

    ck = Check(hbox, text="Auto Save", state=entry.autosave)
    ck.callback_changed_add(lambda c: setattr(entry, "autosave", c.state))
    hbox.pack_end(ck)
    ck.show()

    win.show()

if __name__ == "__main__":
    win = StandardWindow("test", "python-elementary test application",
                         size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [("Entry", entry_clicked),
             ("Entry Scrolled", entry_scrolled_clicked),
             ("Entry Anchor", entry_anchor_clicked),
             ("Entry Notepad", entry_notepad_clicked)
            ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
