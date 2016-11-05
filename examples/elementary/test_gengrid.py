#!/usr/bin/env python
# encoding: utf-8

import random
import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EXPAND_HORIZ, FILL_HORIZ, EVAS_ASPECT_CONTROL_BOTH
from efl import elementary as elm
from efl.elementary import StandardWindow, Button, Check, Entry, Image, \
    Label, Gengrid, GengridItemClass, Slider, Radio, Table, Scrollable, \
    ELM_GLOB_MATCH_NOCASE


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


class ScrollableGengrid(Scrollable, Gengrid):
    def __init__(self, canvas, *args, **kwargs):
        Gengrid.__init__(self, canvas, *args, **kwargs)


images = ["panel_01.jpg", "plant_01.jpg", "rock_01.jpg", "rock_02.jpg",
          "sky_01.jpg", "sky_02.jpg", "sky_03.jpg", "sky_04.jpg", "wood_01.jpg"]


def gg_text_get(obj, part, item_data):
    return "Item # %s" % (item_data)


def gg_content_get(obj, part, data):
    if part == "elm.swallow.icon":
        im = Image(obj, file=os.path.join(img_path, random.choice(images)),
                   size_hint_aspect=(EVAS_ASPECT_CONTROL_BOTH, 1, 1))
        return im

    return None


def gg_state_get(obj, part, item_data):
    return False


def gg_del(obj, item_data):
    # commented out because this make clear() slow with many items
    # print "[item del] # %d - %s" % (item_data, obj)
    pass


def gg_sel(gg, ggi, *args, **kwargs):
    (x, y) = ggi.pos_get()
    print(("[item selected] # %d  at pos %d %d" % (ggi.data, x, y)))


def gg_unsel(gg, ggi, *args, **kwargs):
    print(("[item unselected] # %d" % (ggi.data)))


def gg_clicked_double(gg, ggi, *args, **kwargs):
    print(("[item double clicked] # %d" % (ggi.data)))


def gengrid_clicked(obj):

    global item_count
    # item_count = 25
    item_count = 50

    win = StandardWindow("gengrid", "Gengrid", autodel=True, size=(480, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elm.exit())

    tb = Table(win, homogeneous=False, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tb)
    tb.show()

    # gengrid
    itc = GengridItemClass(item_style="default",
                           text_get_func=gg_text_get,
                           content_get_func=gg_content_get,
                           state_get_func=gg_state_get,
                           del_func=gg_del)
    gg = ScrollableGengrid(win, size_hint_weight=EXPAND_BOTH,
                           size_hint_align=FILL_BOTH, horizontal=False,
                           bounce=(False, True),
                           item_size=(80, 80), align=(0.5, 0.0))
    tb.pack(gg, 0, 0, 6, 1)
    gg.callback_selected_add(gg_sel)
    gg.callback_unselected_add(gg_unsel)
    gg.callback_clicked_double_add(gg_clicked_double)
    gg.show()

    def tooltip_content_cb(gl, item, obj):
        txt = "Tooltip <b>from callback</b> for item # %d" % item.data
        return Label(gl, text=txt)

    # add the first items
    for i in range(item_count):
        ggi = gg.item_append(itc, i, None)
        if i % 2:
            ggi.tooltip_text_set("Static Tooltip for item # %d" % i)
        else:
            ggi.tooltip_content_cb_set(tooltip_content_cb)

    # multi select
    def multi_select_changed(bt, gg):
        gg.multi_select_set(bt.state)
        print((gg.multi_select))

    bt = Check(win, text="MultiSelect", state=gg.multi_select)
    bt.callback_changed_add(multi_select_changed, gg)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()

    # horizontal
    def horizontal_changed(bt, gg):
        gg.horizontal_set(bt.state)

    bt = Check(win, text="Horizontal")
    bt.callback_changed_add(horizontal_changed, gg)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    # reorder mode
    def reorder_mode_changed(bt, gg):
        gg.reorder_mode = bt.state

    bt = Check(win, text="Reorder mode enable")
    bt.callback_changed_add(reorder_mode_changed, gg)
    tb.pack(bt, 2, 1, 2, 1)
    bt.show()

    # bounce h
    def bounce_h_changed(bt, gg):
        (h_bounce, v_bounce) = gg.bounce_get()
        gg.bounce_set(bt.state, v_bounce)
        print((gg.bounce_get()))

    bt = Check(win, text="BounceH")
    h_bounce = gg.bounce[0]
    bt.state = h_bounce
    bt.callback_changed_add(bounce_h_changed, gg)
    tb.pack(bt, 4, 1, 1, 1)
    bt.show()

    # bounce v
    def bounce_v_changed(bt, gg):
        (h_bounce, v_bounce) = gg.bounce_get()
        gg.bounce_set(h_bounce, bt.state)
        print((gg.bounce_get()))

    bt = Check(win, text="BounceV")
    v_bounce = gg.bounce[1]
    bt.state = v_bounce
    bt.callback_changed_add(bounce_v_changed, gg)
    tb.pack(bt, 5, 1, 1, 1)
    bt.show()

    # item size
    def item_size_w_changed(sl, gg):
        (w, h) = gg.item_size_get()
        gg.item_size_set(sl.value, h)
        print((gg.item_size_get()))

    def item_size_h_changed(sl, gg):
        (w, h) = gg.item_size_get()
        gg.item_size_set(w, sl.value)
        print((gg.item_size_get()))

    (w, h) = gg.item_size
    sl = Slider(win, text="ItemSizeW", min_max=(0, 500), span_size=100,
                indicator_format="%.0f", unit_format="%.0f", value=w)
    sl.callback_changed_add(item_size_w_changed, gg)
    tb.pack(sl, 0, 2, 2, 1)
    sl.show()

    sl = Slider(win, text="ItemSizeH", min_max=(0, 500), span_size=100,
                indicator_format="%.0f", unit_format="%.0f", value=h)
    sl.callback_changed_add(item_size_h_changed, gg)
    tb.pack(sl, 0, 3, 2, 1)
    sl.show()

    # align
    def alignx_changed(sl, gg):
        (ax, ay) = gg.align
        gg.align = sl.value, ay
        print(gg.align)

    def aligny_changed(sl, gg):
        (ax, ay) = gg.align
        gg.align = ax, sl.value
        print(gg.align)

    (ax, ay) = gg.align

    sl = Slider(win, text="AlignX", min_max=(0.0, 1.0), span_size=100,
                indicator_format="%.2f", unit_format="%.2f", value=ax)
    sl.callback_changed_add(alignx_changed, gg)
    tb.pack(sl, 0, 4, 2, 1)
    sl.show()

    sl = Slider(win, text="AlignY", min_max=(0.0, 1.0), span_size=100,
                indicator_format="%.2f", unit_format="%.2f", value=ay)
    sl.callback_changed_add(aligny_changed, gg)
    tb.pack(sl, 0, 5, 2, 1)
    sl.show()

    # select first
    def select_first_clicked(bt, gg):
        ggi = gg.first_item
        if ggi:
            ggi.selected = not ggi.selected

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Select first")
    bt.callback_clicked_add(select_first_clicked, gg)
    tb.pack(bt, 2, 2, 1, 1)
    bt.show()

    # select last
    def select_last_clicked(bt, gg):
        ggi = gg.last_item
        if ggi:
            ggi.selected = not ggi.selected

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Select last")
    bt.callback_clicked_add(select_last_clicked, gg)
    tb.pack(bt, 3, 2, 1, 1)
    bt.show()

    # selection del
    def seldel_clicked(bt, gg):
        for ggi in gg.selected_items_get():
            ggi.delete()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Sel del")
    bt.callback_clicked_add(seldel_clicked, gg)
    tb.pack(bt, 4, 2, 1, 1)
    bt.show()

    # clear
    def clear_clicked(bt, gg):
        global item_count
        item_count = 0
        gg.clear()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Clear")
    bt.callback_clicked_add(clear_clicked, gg)
    tb.pack(bt, 5, 2, 1, 1)
    bt.show()

    # append
    def append_clicked(bt, gg, n):
        global item_count
        while n:
            item_count += 1
            gg.item_append(itc, item_count, None)
            n -= 1

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Append 1")
    bt.callback_clicked_add(append_clicked, gg, 1)
    tb.pack(bt, 2, 3, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Append 100")
    bt.callback_clicked_add(append_clicked, gg, 100)
    tb.pack(bt, 3, 3, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Append 1000")
    bt.callback_clicked_add(append_clicked, gg, 1000)
    tb.pack(bt, 4, 3, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Append 10000 :)")
    bt.callback_clicked_add(append_clicked, gg, 10000)
    tb.pack(bt, 5, 3, 1, 1)
    bt.show()

    # prepend
    def prepend_clicked(bt, gg):
        global item_count
        item_count += 1
        gg.item_prepend(itc, item_count)

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Prepend")
    bt.callback_clicked_add(prepend_clicked, gg)
    tb.pack(bt, 2, 4, 1, 1)
    bt.show()

    # insert_before
    def ins_before_clicked(bt, gg):
        global item_count
        item_count += 1
        before = gg.selected_item_get()
        if before:
            gg.item_insert_before(itc, item_count, before)
        else:
            print("nothing selected")

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Ins before")
    bt.callback_clicked_add(ins_before_clicked, gg)
    tb.pack(bt, 3, 4, 1, 1)
    bt.show()

    # insert_after
    def ins_after_clicked(bt, gg):
        global item_count
        item_count += 1
        after = gg.selected_item_get()
        if after:
            gg.item_insert_after(itc, item_count, after)
        else:
            print("nothing selected")

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Ins after")
    bt.callback_clicked_add(ins_after_clicked, gg)
    tb.pack(bt, 4, 4, 1, 1)
    bt.show()

    # item content unset
    def content_unset_clicked(bt, gg):
        item = gg.selected_item
        if item is None:
            print("You must select an item first!")
        else:
            contents = item.all_contents_unset()
            for obj in contents:
                obj.pos = (0, 0)
                obj.show()
            # Now all the unsetted objects are orphan in the canvas,
            # the user should do something with them

    bt = Button(win, size_hint_align=FILL_HORIZ, text="Item content unset")
    bt.callback_clicked_add(content_unset_clicked, gg)
    tb.pack(bt, 5, 4, 1, 1)
    bt.show()

    # scroll_to methods
    rdg = rd = Radio(win, text='SCROLL_IN',
                     state_value=elm.ELM_GENGRID_ITEM_SCROLLTO_IN)
    tb.pack(rd, 2, 5, 1, 1)
    rd.show()

    rd = Radio(win, text='SCROLL_TOP',
               state_value=elm.ELM_GENGRID_ITEM_SCROLLTO_TOP)
    rd.group_add(rdg)
    tb.pack(rd, 3, 5, 1, 1)
    rd.show()

    rd = Radio(win, text='SCROLL_MIDDLE',
               state_value=elm.ELM_GENGRID_ITEM_SCROLLTO_MIDDLE)
    rd.group_add(rdg)
    tb.pack(rd, 4, 5, 1, 1)
    rd.show()

    rd = Radio(win, text='SCROLL_BOTTOM',
               state_value=elm.ELM_GENGRID_ITEM_SCROLLTO_BOTTOM)
    rd.group_add(rdg)
    tb.pack(rd, 5, 5, 1, 1)
    rd.show()

    rdg.value = elm.ELM_GENGRID_ITEM_SCROLLTO_IN

    # show first/last
    def show_clicked(bt, gg, rdg, what):
        ggi = getattr(gg, what)
        if ggi:
            ggi.show(rdg.value)

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Show first")
    bt.callback_clicked_add(show_clicked, gg, rdg, "first_item")
    tb.pack(bt, 2, 6, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Show last")
    bt.callback_clicked_add(show_clicked, gg, rdg, "last_item")
    tb.pack(bt, 3, 6, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="Show selected")
    bt.callback_clicked_add(show_clicked, gg, rdg, "selected_item")
    tb.pack(bt, 2, 7, 2, 1)
    bt.show()

    # bring-in first/last/selected
    def bring_in_clicked(bt, gg, rdg, what):
        ggi = getattr(gg, what)
        if ggi:
            ggi.bring_in(rdg.value)

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="BringIn first")
    bt.callback_clicked_add(bring_in_clicked, gg, rdg, "first_item")
    tb.pack(bt, 4, 6, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="BringIn last")
    bt.callback_clicked_add(bring_in_clicked, gg, rdg, "last_item")
    tb.pack(bt, 5, 6, 1, 1)
    bt.show()

    bt = Button(win, size_hint_align=(EVAS_HINT_FILL, 0), text="BringIn sel")
    bt.callback_clicked_add(bring_in_clicked, gg, rdg, "selected_item")
    tb.pack(bt, 4, 7, 2, 1)
    bt.show()

    # search_by_text_item_get
    def search_cb(en, gg):
        flags = ELM_GLOB_MATCH_NOCASE
        from_item = gg.selected_item.next if gg.selected_item else None

        item = gg.search_by_text_item_get(from_item, "elm.text", en.text, flags)
        if item:
            item.selected = True
            en.focus = True
        elif gg.selected_item:
            gg.selected_item.selected = False

    lb = Label(win, text="Search:")
    tb.pack(lb, 0, 6, 2, 1)
    lb.show()

    en = Entry(win, single_line=True, scrollable=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.part_text_set("guide", "Type the search query")
    en.callback_activated_add(search_cb, gg)
    tb.pack(en, 0, 7, 2, 1)
    en.show()
    en.focus = True

    print(gg)

    win.show()


if __name__ == "__main__":

    gengrid_clicked(None)

    elm.run()
