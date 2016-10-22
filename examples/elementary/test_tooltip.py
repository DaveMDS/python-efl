#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl.ecore import Timer, timer_add
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.list import List
from efl.elementary.toolbar import Toolbar
from efl.elementary.icon import Icon


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def _tt_icon(obj, *args, **kargs):
    ic = Icon(obj, file=os.path.join(img_path, "logo_small.png"),
        resizable=(False, False), size=(64, 64))
    return ic

def _tt_item_icon(obj, item, *args, **kargs):
    return _tt_icon(obj,item, *args, **kargs)

def _tt_icon2(obj, *args, **kargs):
    ic = Icon(obj, file=os.path.join(img_path, "icon_00.png"),
        resizable=(False, False), size=(64, 64))
    return ic

def _tt_timer_del(obj, data, *args):
    timer = data.get("timer")
    if timer:
        timer.delete()
        del data["timer"]


def tooltip_clicked(obj):
    win = StandardWindow("tooltips", "Tooltips", autodel=True, size=(400, 500))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    tb = Toolbar(win, homogeneous=False, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    bx.pack_end(tb)
    tb.show()

    ti = tb.item_append("document-open", "Open", None, None)
    ti.tooltip_text_set("Opens a file")

    ti = tb.item_append("view-close", "Icon", None, None)
    ti.tooltip_content_cb_set(_tt_item_icon, None)
    ti.tooltip_style_set("transparent")

    bt = Button(win, text="Simple text tooltip")
    bt.tooltip_text_set("Simple text tooltip")
    bx.pack_end(bt)
    bt.show()

    def _tt_text_replace(obj, data):
        value = data.get("value")
        if not value:
            value = 1
        obj.tooltip_text_set("count=%d" % value)
        value += 1
        data["value"] = value

    bt = Button(win, text="Simple text tooltip, click to change")
    bt.tooltip_text_set("Initial")
    data = dict()
    bt.callback_clicked_add(_tt_text_replace, data)
    bx.pack_end(bt)
    bt.show()

    def _tt_text_replace_timer_cb(obj, data):
        _tt_text_replace(obj, data)
        return True

    def _tt_text_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Simple text tooltip, click to start changed timed")
            return
        data["timer"] = Timer(1.5, _tt_text_replace_timer_cb, obj, data)
        obj.text_set("Simple text tooltip, click to stop changed timed")

    bt = Button(win, text="Simple text tooltip, click to start changed timed")
    bt.tooltip_text_set("Initial")
    data = dict()
    bt.callback_clicked_add(_tt_text_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    bt = Button(win, text="Icon tooltip")
    bt.tooltip_content_cb_set(_tt_icon, None)
    bx.pack_end(bt)
    bt.show()

    def _tt_icon_replace_timer_cb(obj, data):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.tooltip_content_cb_set(_tt_icon)
        else:
            obj.tooltip_content_cb_set(_tt_icon2)
        return True

    def _tt_icon_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Icon tooltip, click to start changed timed")
            return
        data["timer"] = timer_add(1.5, _tt_icon_replace_timer_cb, obj, data)
        obj.text_set("Icon tooltip, click to stop changed timed")

    bt = Button(win, text="Icon tooltip, click to start changed timed")
    bt.tooltip_content_cb_set(_tt_icon)
    data = dict()
    bt.callback_clicked_add(_tt_icon_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    bt = Button(win, text="Transparent Icon tooltip")
    bt.tooltip_content_cb_set(_tt_icon, None)
    bt.tooltip_style_set("transparent")
    bx.pack_end(bt)
    bt.show()

    def _tt_style_replace_timer_cb(obj, data):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.tooltip_style_set()
        else:
            obj.tooltip_style_set("transparent")
        return True

    def _tt_style_replace_timed(obj, data, *args, **kargs):
        timer = data.get("timer")
        if timer:
            timer.delete()
            del data["timer"]
            obj.text_set("Icon tooltip style, click to start changed timed")
            return
        data["timer"] = timer_add(1.5, _tt_style_replace_timer_cb, obj, data)
        obj.text_set("Icon tooltip, click to stop changed timed")

    bt = Button(win, text="Icon tooltip style, click to start changed timed")
    bt.tooltip_content_cb_set(_tt_icon, None)
    data = dict()
    bt.callback_clicked_add(_tt_style_replace_timed, data)
    bx.pack_end(bt)
    bt.show()
    bt.on_del_add(_tt_timer_del, data)

    def _tt_visible_lock_toggle(obj, data, *args, **kargs):
        value = data.get("value")
        data["value"] = not value
        if value:
            obj.text_set("Unlocked tooltip visibility")
            obj.tooltip_hide()
        else:
            obj.text_set("Locked tooltip visibility")
            obj.tooltip_show()

    bt = Button(win, text="Unlocked tooltip visibility")
    bt.tooltip_text_set(
        "This tooltip is unlocked visible,<br> click the button to lock!")
    data = dict()
    bt.callback_clicked_add(_tt_visible_lock_toggle, data)
    bx.pack_end(bt)
    bt.show()

    def _tt_move_freeze_toggle(obj, *args, **kargs):
        if obj.tooltip_move_freeze_get():
            obj.text_set("Unfreezed tooltip movement")
            obj.tooltip_move_freeze_pop()
        else:
            obj.text_set("Freezed tooltip movement")
            obj.tooltip_move_freeze_push()

    bt = Button(win, text="Freezed tooltip movement")
    bt.tooltip_text_set(
        "This tooltip has freezed movement,<br> click the button to unfreeze!")
    bt.tooltip_move_freeze_push()
    bt.callback_clicked_add(_tt_move_freeze_toggle)
    bx.pack_end(bt)
    bt.show()

    en = Entry(win, scrollable=True, single_line=True,
        entry="Hello, some scrolled entry here!", size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    en.tooltip_text_set("Type something here!")
    bx.pack_end(en)
    en.show()

    lst = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        size_hint_min=(100, 100))
    li = lst.item_append("Hello")
    li.tooltip_text_set("Something useful here?")
    li = lst.item_append("Icon Tooltip")
    li.tooltip_content_cb_set(_tt_item_icon, None)
    bx.pack_end(lst)
    lst.go()
    lst.show()

    win.show()


if __name__ == "__main__":

    tooltip_clicked(None)

    elementary.run()
