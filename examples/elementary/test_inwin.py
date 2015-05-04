#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.label import Label
from efl.elementary.innerwindow import InnerWindow


def inner_window_clicked(obj):
    win = StandardWindow("inner-window", "InnerWindow test", autodel=True,
        size=(320, 320))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    lb = Label(win)
    lb.text_set("This is an \"inwin\" - a window in a<br/>"
                "window. This is handy for quick popups<br/>"
                "you want centered, taking over the window<br/>"
                "until dismissed somehow. Unlike hovers they<br/>"
                "don't hover over their target.")

    iw = InnerWindow(win, content=lb)
    iw.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":

    inner_window_clicked(None)

    elementary.run()
