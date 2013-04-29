from efl import elementary
from efl.evas import EVAS_HINT_FILL, EVAS_HINT_EXPAND

from efl.elementary.window import StandardWindow
from efl.elementary.label import Label
from efl.elementary.entry import Entry, ELM_WRAP_CHAR
from efl.elementary.grid import Grid
from efl.elementary.button import Button
from efl.elementary.object import ELM_SEL_TYPE_CLIPBOARD, ELM_SEL_FORMAT_TEXT

def bt_copy_clicked(obj, data):
    en = data
    txt = en.text

    glb.text = txt
    en.parent_widget.cnp_selection_set(ELM_SEL_TYPE_CLIPBOARD, \
        ELM_SEL_FORMAT_TEXT, txt)

def bt_paste_clicked(obj, data):
    en = data

    en.cnp_selection_get(ELM_SEL_TYPE_CLIPBOARD, ELM_SEL_FORMAT_TEXT)

def bt_clear_clicked(obj, data):
    en = data

    glb.text = ""
    en.parent_widget.cnp_selection_clear(ELM_SEL_TYPE_CLIPBOARD)

def cnp_clicked(obj):
    win = StandardWindow("copypaste", "CopyPaste")
    win.autodel = True
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    gd = Grid(win)
    gd.size = 100, 100
    gd.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(gd)
    gd.show()

    en = Entry(win)
    en.scrollable = True
    en.line_wrap = ELM_WRAP_CHAR
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.text = "Elementary provides "
    gd.pack(en, 10, 10, 60, 30)
    en.show()

    bt = Button(win)
    bt.text = "Copy from left entry"
    bt.callback_clicked_add(bt_copy_clicked, en)
    gd.pack(bt, 70, 10, 22, 30)
    bt.show()

    bt = Button(win)
    bt.text = "Clear clipboard"
    bt.callback_clicked_add(bt_clear_clicked, en)
    gd.pack(bt, 70, 70, 22, 20)
    bt.show()

    en = Entry(win)
    en.scrollable = True
    en.line_wrap = ELM_WRAP_CHAR
    en.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    en.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    en.text = "rich copying and pasting functionality,"
    gd.pack(en, 10, 40, 60, 30)
    en.show()

    bt = Button(win)
    bt.text = "Paste to left entry"
    bt.callback_clicked_add(bt_paste_clicked, en)
    gd.pack(bt, 70, 40, 22, 30)
    bt.show()

    lb = Label(win)
    lb.text = "<b>Clipboard:</b>"
    lb.size_hint_weight = 0.0, 0.0
    lb.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    gd.pack(lb, 10, 70, 60, 10)
    lb.show()

    global glb
    glb = Label(win)
    glb.text = ""
    glb.size_hint_weight = 0.0, 0.0
    glb.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    gd.pack(glb, 10, 80, 60, 10)
    glb.show()

    win.size = 480, 200
    win.show()

if __name__ == "__main__":
    elementary.init()

    cnp_clicked(None)

    elementary.run()
    elementary.shutdown()
