#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH, \
    EVAS_CALLBACK_MOUSE_DOWN, Rectangle
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.menu import Menu


def menu_show(rect, evtinfo, menu):
    (x,y) = evtinfo.position.canvas
    menu.move(x, y)
    menu.show()

def menu_populate_4(menu, item):
    menu.item_add(item, "menu 2", "folder")

    item2 = menu.item_add(item, "menu 3", "folder-new")

    menu.item_separator_add(item)

    item3 = menu.item_add(item, "Disabled item", "document-print")
    item3.disabled = True

    item3 = menu.item_add(item, "Disabled item", "mail-send")
    item3.disabled = True

    item3 = menu.item_add(item, "Disabled item", "view-refresh")
    item3.disabled = True

def menu_populate_3(menu, item):
    menu.item_add(item, "menu 2", "refresh")

    item2 = menu.item_add(item, "menu 3",  "mail-send")

    menu.item_separator_add(item)

    item3 = menu.item_add(item, "Disabled item", "folder")
    item3.disabled = True

def menu_populate_2(menu, item):
    menu.item_add(item, "menu 2", "document-print")

    item2 = menu.item_add(item, "menu 3", "folder-new")

    menu_populate_3(menu, item2)

    menu.item_separator_add(item)

    item2 = menu.item_add(item, "menu 2", "view-refresh")

    menu.item_separator_add(item)

    item3 = menu.item_add(item, "Disabled item", "mail-send")
    item3.disabled = True

    menu_populate_4(menu, item2)

def menu_populate_1(menu, item):
    item2 = menu.item_add(item, "menu 1", "view-refresh")

    menu_populate_2(menu, item2)

def menu_clicked(obj):
    win = StandardWindow("menu", "Menu test", autodel=True, size=(350, 200))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    rect = Rectangle(win.evas_get(), color=(0, 0, 0, 0))
    win.resize_object_add(rect)
    rect.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    rect.show()

    menu = Menu(win)
    item = menu.item_add(None, "first item", "folder")
    item = menu.item_add(None, "second item", "mail-send")
    menu_populate_1(menu, item)

    menu.item_add(item, "sub menu", "refresh")

    rect.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, menu_show, menu)

    win.show()


if __name__ == "__main__":

    menu_clicked(None)

    elementary.run()
