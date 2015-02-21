#!/usr/bin/python

from efl.ecore import ECORE_CALLBACK_DONE
import efl.elementary as elm
elm.init()
if not elm.need_systray():
    raise SystemExit("systray support missing")

from efl.elementary.window import StandardWindow
from efl.elementary.systray import Systray, on_systray_ready
from efl.elementary.menu import Menu


def ready_cb(event):
    print(tray.register())

    return ECORE_CALLBACK_DONE


win = StandardWindow("test", "systray test", size=(400, 400))
win.callback_delete_request_add(lambda x: elm.exit())

on_systray_ready(ready_cb)

menu = Menu(win)
menu.item_add(None, "it works!")

tray = Systray(win)
tray.icon_name = "elementary"
tray.att_icon_name = "elementary"
tray.menu = menu

win.show()

elm.run()
elm.shutdown()
