#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.menu import Menu
from efl.elementary.label import Label


def _click_me_cb(menu, item, menu_it1):
    menu_it1.disabled = not menu_it1.disabled
    print("The first item is now %s" % (
          "disabled" if menu_it1.disabled else "enabled"))

def main_menu_clicked(obj):
    win = StandardWindow("window-mainmenu", "Main Menu",
                         autodel=True, size=(250, 350))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    lb = Label(win, size_hint_weight=EXPAND_BOTH,
               text="Note: the D-Bus menu example requires support from the "
                    "desktop environment to display the application menu")
    win.resize_object_add(lb)
    lb.show()

    menu = win.main_menu_get()

    menu_it = menu.item_add(None, "first item", "user-home")
    menu.item_add(menu_it, "first item", "user-trash")
    menu_it1 = menu.item_add(menu_it, "submenu")
    menu.item_add(menu_it1,  "first item")
    menu.item_add(menu_it1, "second item",  "gimp")

    menu_it = menu.item_add(None, "second item", "folder")
    menu_it1 = menu.item_add(menu_it, "disabled item")
    menu_it1.disabled = True

    menu.item_separator_add(menu_it)
    menu.item_add(menu_it, "click me :-)", None, _click_me_cb, menu_it1)
    menu.item_add(menu_it, "third item", "folder")
    menu_it1 = menu.item_add(menu_it, "sub menu")
    menu.item_add(menu_it1, "first sub item")

    win.show()


if __name__ == "__main__":

    main_menu_clicked(None)

    elementary.run()

