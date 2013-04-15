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

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL

def conformant_clicked(obj, item=None):
    win = StandardWindow("conformant", "Conformant")
    win.autodel = True
    win.conformant = True

    conform = Conformant(win)
    conform.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(conform)
    conform.show()

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bx.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    en = Entry(win)
    en.scrollable = True
    en.single_line = True
    en.bounce = True, False
    en.text = "This is the top entry here"
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    en.show()
    bx.pack_end(en)

    btn = Button(win)
    btn.text = "Test Conformant"
    btn.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    btn.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(btn)
    btn.show()

    en = Entry(win)
    en.scrollable = True
    en.single_line = True
    en.bounce = True, False
    en.text = "This is the middle entry here"
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    en.show()
    bx.pack_end(en)

    btn = Button(win)
    btn.text = "Test Conformant"
    btn.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    btn.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(btn)
    btn.show()

    en = Entry(win)
    en.scrollable = True
    en.bounce = False, True
    en.text = "This is a multi-line entry at the bottom<br/>" \
    "This can contain more than 1 line of text and be " \
    "scrolled around to allow for entering of lots of " \
    "content. It is also to test to see that autoscroll " \
    "moves to the right part of a larger multi-line " \
    "text entry that is inside of a scroller than can be " \
    "scrolled around, thus changing the expected position " \
    "as well as cursor changes updating auto-scroll when " \
    "it is enabled."
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.show()
    bx.pack_end(en)

    conform.content = bx
    bx.show()

    win.size = 240, 240
    win.show()

def popobj(obj, *args, **kwargs):
    nf = args[0]
    nf.item_pop()

def conformant2_clicked(obj, item=None):
    win = StandardWindow("conformant2", "Conformant 2")
    win.autodel = True
    win.conformant = True

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(bx)
    bx.show()

    en = Entry(win)
    en.scrollable = True
    en.single_line = True
    en.bounce = True, False
    en.text = "This is the top entry here"
    en.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    en.size_hint_align = EVAS_HINT_FILL, 0.5
    bx.pack_end(en)
    en.show()

    btn = Button(win)
    btn.focus_allow = False
    btn.text = "Delete Below"
    btn.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    btn.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(btn)
    btn.show()

    pg = Naviframe(win)
    pg.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    pg.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(pg)
    pg.show()

    btn.callback_clicked_add(popobj, pg)

    conform = Conformant(win)
    conform.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    conform.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    pg.item_simple_push(conform)
    conform.show()

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bx.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    en = Entry(win)
    en.scrollable = True
    en.bounce = False, True
    en.text = "This entry and button below get deleted."
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.show()
    bx.pack_end(en)

    btn = Button(win)
    btn.focus_allow = False
    btn.text = "Delete this bottom bit 1"
    btn.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    btn.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(btn)
    btn.show()

    btn.callback_clicked_add(popobj, pg)

    conform.content = bx
    bx.show()

    conform = Conformant(win)
    conform.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    conform.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    pg.item_simple_push(conform)
    conform.show()

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    bx.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

    en = Entry(win)
    en.scrollable = True
    en.bounce = False, True
    en.text = "This entry and button below get deleted."
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.show()
    bx.pack_end(en)

    btn = Button(win)
    btn.focus_allow = False
    btn.text = "Delete this bottom bit 2"
    btn.size_hint_weight = EVAS_HINT_EXPAND, 0.0
    btn.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    bx.pack_end(btn)
    btn.show()

    btn.callback_clicked_add(popobj, pg)

    conform.content = bx
    bx.show()

    win.size = 240, 480
    win.show()

if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application")
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win)
    box0.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text = "Information"
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text = "Please select a test from the list below<br>" \
                "by clicking the test button to show the<br>" \
                "test window."
    fr.content_set(lb)
    lb.show()

    items = [
        ("Conformant", conformant_clicked),
        ("Conformant 2", conformant2_clicked),
    ]

    li = List(win)
    li.size_hint_weight_set(EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
    li.size_hint_align_set(EVAS_HINT_FILL, EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
