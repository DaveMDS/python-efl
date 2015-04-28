#!/usr/bin/python

import efl.elementary as elm

from efl.elementary.window import StandardWindow
from efl.elementary.systray import Systray, on_systray_ready
from efl.elementary.menu import Menu


def systray_clicked(obj, item=None):
    if not elm.need_systray():
        print("systray support not available")
        return

    win = StandardWindow("test", "systray test", size=(400, 400), autodel=True)
    if not obj:
        win.callback_delete_request_add(lambda x: elm.exit())

    menu = Menu(win)
    menu.item_add(None, "it works!")

    global tray
    tray = Systray(win)
    tray.icon_name = "elementary"
    tray.att_icon_name = "elementary"
    tray.menu = menu

    on_systray_ready(lambda x: tray.register())

    win.show()

if __name__ == "__main__":
    elm.init()

    systray_clicked(None)

    elm.run()
    elm.shutdown()
