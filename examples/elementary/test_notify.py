#!/usr/bin/env python
# encoding: utf-8

from __future__ import print_function

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.notify import Notify, ELM_NOTIFY_ALIGN_FILL
from efl.elementary.table import Table


def notify_clicked(obj=None):
    win = StandardWindow("notify", "Notify", autodel=True, size=(400,400))
    if obj is None:
        win.callback_delete_request_add(lambda x: elementary.exit())
    win.show()

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    # Notify top
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(0.5, 0.0),
        content=bx)

    lb = Label(win, text="This position is the default.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Top")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 2, 1, 1, 1)
    bt.show()

    # Notify bottom
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, allow_events=False, size_hint_weight=EXPAND_BOTH,
        align=(0.5, 1.0), timeout=(5.0), content=bx)

    notify.callback_timeout_add(lambda x: setattr(x, "timeout", 2.0))
    notify.callback_block_clicked_add(
        lambda x: print("Notify block area clicked!!"))

    lb = Label(win)
    lb.text = (
        "Bottom position. This notify uses a timeout of 5 sec.<br/>"
        "<b>The events outside the window are blocked.</b>"
        )
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Bottom")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 2, 3, 1, 1)
    bt.show()

    # Notify left
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(0.0, 0.5),
        timeout=10.0, content=bx)
    notify.callback_timeout_add(lambda x: print("Notify timed out!"))

    lb = Label(win)
    lb.text = "Left position. This notify uses a timeout of 10 sec."
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Left")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 1, 2, 1, 1)
    bt.show()

    # Notify center
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(0.5, 0.5),
        timeout=10.0, content=bx)
    notify.callback_timeout_add(lambda x: print("Notify timed out!"))

    lb = Label(win)
    lb.text = "Center position. This notify uses a timeout of 10 sec."
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Center")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 2, 2, 1, 1)
    bt.show()

    # Notify right
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(1.0, 0.5),
        content=bx)

    lb = Label(win, text="Right position.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Right")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 3, 2, 1, 1)
    bt.show()

    # Notify top left
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(0.0, 0.0),
        content=bx)

    lb = Label(win, text="Top Left position.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Top Left")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    # Notify top right
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(1.0, 0.0),
        content=bx)

    lb = Label(win, text="Top Right position.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Top Right")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 3, 1, 1, 1)
    bt.show()

    # Notify bottom left
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(0.0, 1.0),
        content=bx)

    lb = Label(win, text="Bottom Left position.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Bottom Left")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 1, 3, 1, 1)
    bt.show()

    # Notify bottom right
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH, align=(1.0, 1.0),
        content=bx)

    lb = Label(win, text="Bottom Right position.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close in 2s")
    bt.callback_clicked_add(lambda x, y=notify: setattr(y, "timeout", 2.0))
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=FILL_BOTH, text="Bottom Right")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 3, 3, 1, 1)
    bt.show()

    # Notify top fill
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH,
        align=(ELM_NOTIFY_ALIGN_FILL, 0.0), timeout=5.0, content=bx)

    lb = Label(win)
    lb.text = (
        "Fill top. This notify fills horizontal area.<br/>"
        "<b>notify.align = (ELM_NOTIFY_ALIGN_FILL, 0.0)</b>"
        )
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0.5), text="Top fill")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 1, 0, 3, 1)
    bt.show()

    # Notify bottom fill
    bx = Box(win, horizontal=True)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH,
        align=(ELM_NOTIFY_ALIGN_FILL, 1.0), timeout=5.0, content=bx)

    lb = Label(win, size_hint_weight=EXPAND_BOTH, size_hint_align=(0.0, 0.5))
    lb.text = (
        "Fill Bottom. This notify fills horizontal area.<br/>"
        "<b>notify.align = (ELM_NOTIFY_ALIGN_FILL, 1.0)</b>"
        )
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0.5), text="Bottom fill")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 1, 4, 3, 1)
    bt.show()

    # Notify left fill
    bx = Box(win)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH,
        align=(0.0, ELM_NOTIFY_ALIGN_FILL), timeout=5.0, content=bx)

    lb = Label(win, text="Left fill.")
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=(0.5, EVAS_HINT_FILL), text="Left fill")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 0, 1, 1, 3)
    bt.show()

    # Notify right fill
    bx = Box(win)
    bx.show()

    notify = Notify(win, size_hint_weight=EXPAND_BOTH,
        align=(1.0, ELM_NOTIFY_ALIGN_FILL), timeout=5.0, content=bx)

    lb = Label(win)
    lb.text = "Right fill."
    bx.pack_end(lb)
    lb.show()

    bt = Button(win, text="Close")
    bt.callback_clicked_add(lambda x, y=notify: y.hide())
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, size_hint_align=(0.5, EVAS_HINT_FILL), text="Right fill")
    bt.callback_clicked_add(lambda x, y=notify: y.show())
    tb.pack(bt, 4, 1, 1, 3)
    bt.show()



if __name__ == "__main__":

    notify_clicked(None)

    elementary.run()
