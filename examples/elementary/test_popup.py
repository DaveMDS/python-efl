#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    FilledImage
from efl import elementary as elm
from efl.elementary.window import StandardWindow
from efl.elementary.button import Button
from efl.elementary.list import List, ELM_LIST_LIMIT
from efl.elementary.icon import Icon
from efl.elementary.popup import Popup, ELM_WRAP_CHAR


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def cb_bnt_close(btn, popup):
    if "im" in popup.data:
        popup.data["im"].delete()
    popup.delete()

def cb_btn_restack(btn, popup):
    im = FilledImage(popup.evas)
    im.file = os.path.join(img_path, "mystrale_2.jpg")
    im.move(40, 40)
    im.resize(500, 320)
    im.show()

    popup.data["im"] = im
    popup.raise_()

def cb_popup_center_text(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH, timeout=3.0)
    popup.text = "This Popup has content area and timeout value is 3 seconds"
    popup.show()

def cb_popup_center_title_text_1button(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    popup.text = "This Popup has content area and " \
                 "action area set, action area has one button Close"
    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button1", bt)
    popup.show()

def cb_popup_center_title_text_2button(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    popup.text = "This Popup has title area, content area and " \
                 "action area set, action area has one button Close"
    popup.part_text_set("title,text", "Title")
    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button1", bt)
    popup.show()

def cb_popup_center_title_text_block_clicked_event(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    popup.text = "This Popup has title area and content area. " \
                 "When clicked on blocked event region, popup gets deleted"
    popup.part_text_set("title,text", "Title")
    popup.callback_block_clicked_add(cb_bnt_close, popup)
    popup.show()

def cb_popup_bottom_title_text_3button(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH,
        content_text_wrap_type=ELM_WRAP_CHAR)
    popup.text = "This Popup has title area, content area and " \
                 "action area set with content being character wrapped. " \
                 "action area has three buttons OK, Cancel and Close"
    popup.part_text_set("title,text", "Title")

    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    popup.part_content_set("title,icon", ic)

    bt = Button(win, text="OK")
    popup.part_content_set("button1", bt)

    bt = Button(win, text="Cancel")
    popup.part_content_set("button2", bt)

    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button3", bt)

    popup.show()

def cb_popup_center_title_content_3button(li, item, win):
    ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
    bt = Button(win, text="Content", content=ic)

    popup = Popup(win, size_hint_weight=EXPAND_BOTH, content=bt)
    popup.part_text_set("title,text", "Title")

    bt = Button(win, text="OK")
    popup.part_content_set("button1", bt)

    bt = Button(win, text="Cancel")
    popup.part_content_set("button2", bt)

    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button3", bt)

    popup.show()

def cb_popup_center_title_item_3button(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    popup.part_text_set("title,text", "Title")

    for i in range(1, 11):
        if i in [3, 5, 6]:
            ic = Icon(win, file=os.path.join(img_path, "logo_small.png"))
            popup.item_append("item"+str(i), ic)
        else:
            popup.item_append("item"+str(i), None)

    bt = Button(win, text="OK")
    popup.part_content_set("button1", bt)

    bt = Button(win, text="Cancel")
    popup.part_content_set("button2", bt)

    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button3", bt)

    popup.show()

def cb_popup_center_title_text_2button_restack(li, item, win):
    popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    popup.text = "When you click the 'Restack' button, " \
                 "an image will be located under this popup"
    popup.part_text_set("title,text", "Title")

    bt = Button(win, text="Restack")
    bt.callback_clicked_add(cb_btn_restack, popup)
    popup.part_content_set("button1", bt)

    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button3", bt)

    popup.show()

times = 0
g_popup = None
def cb_popup_center_text_1button_hide_show(li, item, win):
    global times
    global g_popup

    times += 1

    if g_popup is not None:
        g_popup.text = "You have checked this popup %d times." % times
        g_popup.show()
        return

    g_popup = Popup(win, size_hint_weight=EXPAND_BOTH)
    g_popup.text = "Hide this popup by using the button." \
                   "When you click list item again, you will see this popup again."

    bt = Button(win, text="Hide")
    bt.callback_clicked_add(lambda b: g_popup.hide())
    g_popup.part_content_set("button1", bt)

    g_popup.show()


def _popup_dismissed_cb(popup):
    print("dismissed", popup)
    popup.delete()

def cb_popup_center_title_1button_hide_effect(li, item, win):
    popup = Popup(win, text="This Popup has title area, content area and " \
                  "action area set, action area has one button Close",
                  size_hint_expand=EXPAND_BOTH)
    popup.part_text_set("title", "Title")
    popup.callback_dismissed_add(_popup_dismissed_cb)

    btn = Button(popup, text="Close")
    btn.callback_clicked_add(lambda b: popup.dismiss())
    popup.part_content_set("button1", btn)

    popup.show()

def cb_popup_scrollable(li, item, win):
    lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    popup = Popup(win, text=lorem*160, scrollable=True,
                  size_hint_weight=EXPAND_BOTH)
    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button1", bt)
    popup.show()
    
def cb_popup_align(li, item, win):
    popup = Popup(win, text="Align (0.2, 0.8)", align=(0.2, 0.8),
                  size_hint_weight=EXPAND_BOTH)
    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button1", bt)
    popup.show()

def cb_popup_orient(li, item, win, name, orient):
    popup = Popup(win, text=name, orient=orient, size_hint_weight=EXPAND_BOTH)
    bt = Button(win, text="Close")
    bt.callback_clicked_add(cb_bnt_close, popup)
    popup.part_content_set("button1", bt)
    popup.show()

orients = [
    ("ELM_POPUP_ORIENT_TOP", elm.ELM_POPUP_ORIENT_TOP),
    ("ELM_POPUP_ORIENT_CENTER", elm.ELM_POPUP_ORIENT_CENTER),
    ("ELM_POPUP_ORIENT_BOTTOM", elm.ELM_POPUP_ORIENT_BOTTOM),
    ("ELM_POPUP_ORIENT_LEFT", elm.ELM_POPUP_ORIENT_LEFT),
    ("ELM_POPUP_ORIENT_RIGHT", elm.ELM_POPUP_ORIENT_RIGHT),
    ("ELM_POPUP_ORIENT_TOP_LEFT", elm.ELM_POPUP_ORIENT_TOP_LEFT),
    ("ELM_POPUP_ORIENT_TOP_RIGHT", elm.ELM_POPUP_ORIENT_TOP_RIGHT),
    ("ELM_POPUP_ORIENT_BOTTOM_LEFT", elm.ELM_POPUP_ORIENT_BOTTOM_LEFT),
    ("ELM_POPUP_ORIENT_BOTTOM_RIGHT", elm.ELM_POPUP_ORIENT_BOTTOM_RIGHT),
]

def popup_clicked(obj):
    win = StandardWindow("popup", "Popup test", autodel=True, size=(400, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

    li = List(win, mode=ELM_LIST_LIMIT, size_hint_weight=EXPAND_BOTH)
    li.callback_selected_add(lambda li, it: it.selected_set(False))
    win.resize_object_add(li)
    li.show()

    li.item_append("popup-center-text", None, None,
                   cb_popup_center_text, win)
    li.item_append("popup-center-text + 1 button", None, None,
                   cb_popup_center_title_text_1button, win)
    li.item_append("popup-center-title + text + 1 button", None, None,
                   cb_popup_center_title_text_2button, win)
    li.item_append("popup-center-title + text (block,clicked handling)", None, None,
                   cb_popup_center_title_text_block_clicked_event, win)
    li.item_append("popup-bottom-title + text + 3 buttons", None, None,
                   cb_popup_bottom_title_text_3button, win)
    li.item_append("popup-center-title + content + 3 buttons", None, None,
                   cb_popup_center_title_content_3button, win)
    li.item_append("popup-center-title + items + 3 buttons", None, None,
                   cb_popup_center_title_item_3button, win)
    li.item_append("popup-center-title + text + 2 buttons (check restacking)", None, None,
                   cb_popup_center_title_text_2button_restack, win)
    li.item_append("popup-center-text + 1 button (check hide, show)", None, None,
                   cb_popup_center_text_1button_hide_show, win)
    li.item_append("popup-center-title + text + 1 button + hide effect", None, None,
                   cb_popup_center_title_1button_hide_effect, win)
    li.item_append("Popup Scrollable", None, None,
                   cb_popup_scrollable, win)
    li.item_append("Popup Align (0.2, 0.8)", None, None,
                   cb_popup_align, win)
    for name, val in orients:
        li.item_append("Popup Orient (%s)" % name, None, None,
                      cb_popup_orient, win, name, val)

    li.go()

    win.show()


if __name__ == "__main__":

    popup_clicked(None)

    elm.run()
