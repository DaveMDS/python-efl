#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, FilledImage, \
    EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.icon import Icon
from efl.elementary.button import Button
from efl.elementary.list import List, ELM_LIST_COMPRESS
from efl.elementary.ctxpopup import Ctxpopup
from efl.elementary.scroller import Scroller


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def cb_items(li, item):
    print(("ctxpopup item selected: %s" % (item.text)))

def item_new(cp, label, icon = None):
    if icon:
        ic = Icon(cp, standard=icon, resizable=(False,False))
        return cp.item_append(label, ic, cb_items)
    else:
        return cp.item_append(label, None, cb_items)

def cb_btn(btn):
    cp = btn.data["ctxpopup"]
    if "img" in cp.data:
        return
    img = FilledImage(btn.evas)
    img.file_set(os.path.join(img_path, "sky_04.jpg"))
    img.move(40, 40)
    img.resize(320, 320)
    img.show()

    cp = btn.data["ctxpopup"]
    cp.data["img"] = img
    cp.raise_()
    # NOTE: the '_' is wanted as 'raise' is a reserved word in py

def cb_dismissed(cp):
    if "img" in cp.data:
        cp.data["img"].delete()

def cb_geometry_update(cp, geom):
    print("geometry,update", geom)

def cb_item1(li, item):
    cp = Ctxpopup(li)
    cp.callback_geometry_update_add(cb_geometry_update)
    it = item_new(cp, "Go to home folder", "user-home")
    it = item_new(cp, "Save file", "document-save")
    it = item_new(cp, "Delete file", "user-trash")
    it = item_new(cp, "Navigate to folder", "folder")
    it.disabled = True
    it = item_new(cp, "Edit entry", "document-edit")
    it = item_new(cp, "Set date and time", "list-remove")
    it.disabled = True

    ic = Icon(cp, standard="list-add", resizable=(False,False))
    it2 = cp.item_prepend("Prepended item", ic, cb_items)

    ic = Icon(cp, standard="list-add", resizable=(False,False))
    cp.item_insert_before(it2, "Before the Prepended", ic)

    ic = Icon(cp, standard="list-add", resizable=(False,False))
    cp.item_insert_after(it2, "After the Prepended", ic)

    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

    print("\n### Testing items getters 1")
    for it in cp.items:
        print("ITEM: " + it.text)

    print("\n### Testing items getters 2")
    print("FIRST ITEM: " + cp.first_item.text)
    print("LAST ITEM: " + cp.last_item.text)

    print("\n### Testing items getters 3")
    it = cp.first_item
    while it:
        print("ITEM: " + it.text)
        it = it.next

    print("\n### Testing items getters 4")
    it = cp.last_item
    while it:
        print("ITEM: " + it.text)
        it = it.prev

def cb_item2(li, item):
    cp = Ctxpopup(li)
    it = item_new(cp, "", "user-home")
    it = item_new(cp, "", "user-trash")
    it = item_new(cp, "", "user-bookmarks")
    it = item_new(cp, "", "folder")
    it = item_new(cp, "", "document-save")
    it.disabled = True
    it = item_new(cp, "", "document-send")

    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

def cb_item3(li, item):
    cp = Ctxpopup(li)
    it = item_new(cp, "Eina")
    it = item_new(cp, "Eet")
    it = item_new(cp, "Evas")
    it = item_new(cp, "Ecore")
    it.disabled = True
    it = item_new(cp, "Embryo")
    it = item_new(cp, "Edje")

    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

def cb_item4(li, item):
    cp = Ctxpopup(li)
    cp.horizontal = True
    it = item_new(cp, "", "user-home")
    it = item_new(cp, "", "document-save")
    it = item_new(cp, "", "user-trash")
    it = item_new(cp, "", "folder")
    it = item_new(cp, "", "user-bookmarks")
    it = item_new(cp, "", "document-send")

    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

def cb_item5(li, item):
    box = Box(li, size_hint_min=(150, 150))

    sc = Scroller(li, bounce=(False, True), size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_BOTH)
    sc.show()

    bt = Button(li, text="Enlightenment", size_hint_min=(140, 140))

    sc.content = bt
    box.pack_end(sc)

    cp = Ctxpopup(li, content = box)
    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

def cb_item6(li, item):
    box = Box(li, size_hint_min=(200, 150))

    sc = Scroller(li, bounce=(False, True), size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_BOTH)
    sc.show()

    bt = Button(li, text="Ctxpop will be on the top of layer",
        size_hint_min=(190, 140))
    bt.callback_clicked_add(cb_btn)

    sc.content = bt
    box.pack_end(sc)

    cp = Ctxpopup(li, content=box)
    cp.callback_dismissed_add(cb_dismissed)
    (x, y) = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()
    bt.data["ctxpopup"] = cp

def cb_item11(li, item):
    cp = Ctxpopup(li)
    cp.callback_geometry_update_add(cb_geometry_update)
    for i in range(100):
        item_new(cp, "Item #%d" % i, "clock")

    x, y = li.evas.pointer_canvas_xy_get()
    cp.move(x, y)
    cp.show()

def ctxpopup_clicked(obj):
    win = StandardWindow("ctxpopup", "Context popup test", autodel=True,
        size=(400,400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    li = List(win, size_hint_weight=EXPAND_BOTH, mode=ELM_LIST_COMPRESS)
    win.resize_object_add(li)
    li.show()

    li.item_append("Ctxpopup with icons and labels", callback=cb_item1)
    li.item_append("Ctxpopup with icons only", callback=cb_item2)
    li.item_append("Ctxpopup with labels only", callback=cb_item3)
    li.item_append("Ctxpopup at horizontal mode", callback=cb_item4)
    li.item_append("Ctxpopup with user content", callback=cb_item5)
    li.item_append("Ctxpopup with restacking", callback=cb_item6)
    li.item_append("Ctxpopup with more items", callback=cb_item11)
    li.go()

    win.show()


if __name__ == "__main__":

    ctxpopup_clicked(None)

    elementary.run()

