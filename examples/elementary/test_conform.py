#!/usr/bin/env python
# encoding: utf-8

from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.conformant import Conformant
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.box import Box
from efl.elementary.naviframe import Naviframe
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.scroller import Scrollable

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, \
    EXPAND_HORIZ, FILL_BOTH, FILL_HORIZ


class ScrollableEntry(Scrollable, Entry):
    def __init__(self, canvas, *args, **kwargs):
        Entry.__init__(self, canvas, *args, **kwargs)
        self.scrollable = True

def conformant_clicked(obj, item=None):
    win = StandardWindow("conformant", "Conformant", autodel=True,
        conformant=True, size=(240,240))

    conform = Conformant(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(conform)
    conform.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)

    en = ScrollableEntry(win, single_line=True, bounce=(True, False),
        text="This is the top entry here", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    en.show()
    bx.pack_end(en)

    btn = Button(win, text="Test Conformant", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_BOTH)
    bx.pack_end(btn)
    btn.show()

    en = ScrollableEntry(win, single_line=True, bounce=(True, False),
        text="This is the middle entry here", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    en.show()
    bx.pack_end(en)

    btn = Button(win, text="Test Conformant", size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    bx.pack_end(btn)
    btn.show()

    en = ScrollableEntry(win, bounce=(False, True),
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    en.text = \
        "This is a multi-line entry at the bottom<br/>" \
        "This can contain more than 1 line of text and be " \
        "scrolled around to allow for entering of lots of " \
        "content. It is also to test to see that autoscroll " \
        "moves to the right part of a larger multi-line " \
        "text entry that is inside of a scroller than can be " \
        "scrolled around, thus changing the expected position " \
        "as well as cursor changes updating auto-scroll when " \
        "it is enabled."
    en.show()
    bx.pack_end(en)

    conform.content = bx
    bx.show()

    win.show()

def popobj(obj, *args, **kwargs):
    nf = args[0]
    nf.item_pop()

def conformant2_clicked(obj, item=None):
    win = StandardWindow("conformant2", "Conformant 2", autodel=True,
        conformant=True, size=(240,480))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    en = ScrollableEntry(win, single_line=True, bounce=(True, False),
        text="This is the top entry here", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(en)
    en.show()

    btn = Button(win, focus_allow=False, text="Delete Below",
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(btn)
    btn.show()

    pg = Naviframe(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx.pack_end(pg)
    pg.show()

    btn.callback_clicked_add(popobj, pg)

    conform = Conformant(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    pg.item_simple_push(conform)
    conform.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)

    en = ScrollableEntry(win, bounce=(False, True),
        text="This entry and button below get deleted.",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    en.show()
    bx.pack_end(en)

    btn = Button(win, focus_allow=False, text="Delete this bottom bit 1",
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(btn)
    btn.show()

    btn.callback_clicked_add(popobj, pg)

    conform.content = bx
    bx.show()

    conform = Conformant(win, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    pg.item_simple_push(conform)
    conform.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)

    en = ScrollableEntry(win, bounce=(False, True),
        text="This entry and button below get deleted.",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    en.show()
    bx.pack_end(en)

    btn = Button(win, focus_allow=False, text="Delete this bottom bit 2",
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(btn)
    btn.show()

    btn.callback_clicked_add(popobj, pg)

    conform.content = bx
    bx.show()

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

    items = [
        ("Conformant", conformant_clicked),
        ("Conformant 2", conformant2_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
