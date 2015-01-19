#!/usr/bin/env python
# encoding: utf-8

import time
import sys
import os
#if sys.version_info < (3,): range = xrange

from efl import evas
from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ, \
    EVAS_ASPECT_CONTROL_VERTICAL, Rectangle
from efl.ecore import Timer
from efl import elementary
from efl.elementary.window import StandardWindow, Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.button import Button
from efl.elementary.list import List
from efl.elementary.icon import Icon
from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass, \
    ELM_GENLIST_ITEM_NONE, ELM_OBJECT_SELECT_MODE_ALWAYS, \
    ELM_OBJECT_SELECT_MODE_DEFAULT, ELM_GENLIST_ITEM_GROUP, \
    ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
from efl.elementary.general import cache_all_flush, ELM_GLOB_MATCH_NOCASE
from efl.elementary.radio import Radio
from efl.elementary.check import Check
from efl.elementary.entry import Entry


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

def gl_text_get(obj, part, item_data):
    return "Item # %i" % (item_data,)

def gl_content_get(obj, part, data):
    ic = Icon(obj, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    return ic

def gl_state_get(obj, part, item_data):
    return False

def gl_comp_func(item1, item2):
    #print(item1.data)
    #print(item2.data)
    # If data1 is 'less' than data2, -1 must be returned, if it is 'greater',
    # 1 must be returned, and if they are equal, 0 must be returned.
    if item1.data < item2.data:
        return -1
    elif item1.data == item2.data:
        return 0
    elif item1.data > item2.data:
        return 1
    else:
        print("BAAAAAAAAD Comparison!")
        return 0

def gl_item_sel(gli, gl, *args, **kwargs):
    print("\n---GenlistItem selected---")
    print(gli)
    print(gl)
    print(args)
    print(kwargs)
    print(("item_data: %s" % gli.data_get()))

def glg_text_get(obj, part, item_data):
    return "Group # %i" % (item_data,)

def glg_content_get(obj, part, data):
    ic = Icon(obj, file=os.path.join(img_path, "logo.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    return ic

def _gl_selected(gl, gli, *args, **kwargs):
    print("\n---Genlist selected---")
    print(gl)
    print(gli)
    print(args)
    print(kwargs)

def _gl_clicked_double(gl, gli, *args, **kwargs):
    print("\n---Genlist double clcked---")
    print(gl)
    print(gli)
    print(args)
    print(kwargs)

def _gl_longpressed(gl, gli, *args, **kwargs):
    print("\n---Genlist longpressed---")
    print(gl)
    print(gli)
    print(args)
    print(kwargs)

def _gl_over_click(evas, evt, gl):
    print("\n---OverRect click---")
    gli = gl.at_xy_item_get(evt.position.canvas.x, evt.position.canvas.y)
    if gli:
        print(gli)
    else:
        print("over none")


def genlist_clicked(obj, item=None):
    win = StandardWindow("Genlist", "Genlist test", autodel=True)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    gl.callback_selected_add(_gl_selected, "arg1", "arg2",
        kwarg1="kwarg1", kwarg2="kwarg2")
    gl.callback_clicked_double_add(_gl_clicked_double, "arg1", "arg2",
        kwarg1="kwarg1", kwarg2="kwarg2")
    gl.callback_longpressed_add(_gl_longpressed, "arg1", "arg2",
        kwarg1="kwarg1", kwarg2="kwarg2")
    bx.pack_end(gl)
    gl.show()

    over = Rectangle(win.evas_get())
    over.color_set(0, 0, 0, 0)
    over.event_callback_add(evas.EVAS_CALLBACK_MOUSE_DOWN, _gl_over_click, gl)
    over.repeat_events_set(True)
    over.show()
    over.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(over)

    vbx = Box(win, horizontal=True)
    bx.pack_end(vbx)
    vbx.show()

    itc1 = GenlistItemClass(item_style="default",
                            text_get_func=gl_text_get,
                            content_get_func=gl_content_get,
                            state_get_func=gl_state_get)

    bt_50 = Button(win, text="Go to 50")
    vbx.pack_end(bt_50)
    bt_50.show()

    bt_1500 = Button(win, text="Go to 1500")
    vbx.pack_end(bt_1500)
    bt_1500.show()

    def tooltip_content_cb(gl, item, obj):
        txt = "Tooltip <b>from callback</b> for item # %d" % item.data
        return Label(gl, text=txt)

    for i in range(0, 2000):
        gli = gl.item_append(itc1, i, func=gl_item_sel)

        if i % 2:
            gli.tooltip_text_set("Static Tooltip for item # %d" % i)
        else:
            gli.tooltip_content_cb_set(tooltip_content_cb)

        if i == 50:
            bt_50._callback_add("clicked", lambda bt, it: it.bring_in(), gli)
        elif i == 1500:
            bt_1500._callback_add("clicked", lambda bt, it: it.bring_in(), gli)

    win.resize(480, 800)
    win.show()


def genlist2_clicked(obj, item=None):
    win = Window("Genlist", ELM_WIN_BASIC, title="Genlist test 2",
        autodel=True, size=(320, 320))

    bg = Background(win, file=os.path.join(img_path, "plant_01.jpg"),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.show()

    itc1 = GenlistItemClass(item_style="default",
                            text_get_func=gl_text_get,
                            content_get_func=gl_content_get,
                            state_get_func=gl_state_get)

    gl.item_append(itc1, 1001, func=gl_item_sel)
    gl.item_append(itc1, 1002, func=gl_item_sel)
    gl.item_append(itc1, 1003, func=gl_item_sel)
    gl.item_append(itc1, 1004, func=gl_item_sel)
    gl.item_append(itc1, 1005, func=gl_item_sel)
    gl.item_append(itc1, 1006, func=gl_item_sel)
    gl.item_append(itc1, 1007, func=gl_item_sel)

    bx.pack_end(gl)

    bx2 = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)

    def my_gl_first(bt, gl):
        gli = gl.first_item
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win, text="/\\", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_first, gl)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_last(bt, gl):
        gli = gl.last_item_get()
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win, text="\\/", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_last, gl)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_disable(bt, gl):
        gli = gl.selected_item
        if gli:
            gli.disabled = True
            gli.selected = False
            gli.update()
        else:
            print("no item selected")

    bt = Button(win, text="#", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_disable, gl)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_update_all(bt, gl):
        gli = gl.first_item_get()
        i = 0
        while gli:
            gli.update()
            print(i)
            i += 1
            gli = gli.next_get()

    bt = Button(win, text="U", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_update_all, gl)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()


    bx2 = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)


    def my_gl_clear(bt, gl):
        gl.clear()

    bt = Button(win, text="X", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_clear, gl)
    bx2.pack_end(bt)
    bt.show()


    class MyGlAdd:
        i = 0
    def my_gl_add(bt, gl, itc1):
        gl.item_append(itc1, MyGlAdd.i, func=gl_item_sel)
        MyGlAdd.i += 1

    bt = Button(win, text="+", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_add, gl, itc1)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_del(bt, gl):
        gli = gl.selected_item_get()
        if gli:
            gli.delete()
        else:
            print("no item selected")

    bt = Button(win, text="-", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_del, gl)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    bx2 = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)


    class MyGlInsertBefore:
        i = 0
    def my_gl_insert_before(bt, gl, itc1):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_before(itc1, MyGlInsertBefore.i, gli,
                func=gl_item_sel)
            MyGlInsertBefore.i += 1
        else:
            print("no item selected")

    bt = Button(win, text="+ before", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_insert_before, gl, itc1)
    bx2.pack_end(bt)
    bt.show()


    class MyGlInsertAfter:
        i = 0
    def my_gl_insert_after(bt, gl, itc1):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_after(itc1, MyGlInsertAfter.i, gli, func=gl_item_sel)
            MyGlInsertAfter.i += 1
        else:
            print("no item selected")

    bt = Button(win, text="+ after", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_insert_after, gl, itc1)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_flush(bt, gl):
        def my_gl_flush_delay():
            cache_all_flush()
        Timer(1.2, my_gl_flush_delay)
    bt = Button(win, text="Flush", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(my_gl_flush, gl)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.show()


def genlist3_clicked(obj, item=None):
    win = StandardWindow("Genlist", "Genlist Group test", autodel=True,
        size=(320, 320))

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gl)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get,
                             state_get_func=gl_state_get)

    itc_g = GenlistItemClass(item_style="group_index",
                             text_get_func=glg_text_get,
                             content_get_func=glg_content_get)

    for i in range(300):
        if i % 10 == 0:
            git = gl.item_append(itc_g, i/10,
                                 flags=ELM_GENLIST_ITEM_GROUP)
            git.select_mode_set(ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY)
        gl.item_append(itc_i, i, git)

    win.show()

def genlist4_clicked(obj, item=None):
    win = StandardWindow("Genlist", "Genlist sorted insert test", autodel=True,
        size=(320, 320))

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gl)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get,
                             state_get_func=gl_state_get)

    for i in range(100,-1,-1):
        GenlistItem(itc_i, i).sorted_insert(gl, gl_comp_func)

    win.show()

def genlist5_clicked(obj, item=None):
    win = StandardWindow("Genlist", "Genlist iteration test", autodel=True,
        size=(320, 320))

    gl = Genlist(win, homogeneous=True, size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(gl)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get,
                             state_get_func=gl_state_get)

    item_count = 10000

    t1 = time.time()
    for i in range(item_count):
        GenlistItem(itc_i, i).append_to(gl)
    t2 = time.time()

    assert(len(gl) == gl.items_count)

    t3 = time.time()
    it = gl.first_item
    while it:
        d = it.data
        it = it.next
    t4 = time.time()

    assert(d == item_count-1)

    t5 = time.time()
    for it in gl:
        e = it.data
    t6 = time.time()

    assert(e == item_count-1)
    assert(it in gl)

    print("Time to add {0} items:".format(item_count))
    print(t2-t1)
    print("Time to iterate item data over {0} items using "
        "it.next:".format(item_count))
    print(t4-t3)
    print("Time to iterate item data over {0} items using "
        "a python iterator:".format(item_count))
    print(t6-t5)

    win.show()

mode_type = ["slide", "rotate"]

class ItemClass10(GenlistItemClass):
    def text_get(self, obj, part, data):
        t = data
        if part == "elm.text.mode":
            return "Mode # %i" % (t,)
        else:
            return "Item # %i" % (t,)

    def content_get(self, obj, part, data):
        ic = Icon(obj)
        if part == "elm.swallow.end":
            f = os.path.join(img_path, "bubble.png")
        else:
            f = os.path.join(img_path, "logo_small.png")
        ic.file = f
        ic.size_hint_aspect = EVAS_ASPECT_CONTROL_VERTICAL, 1, 1
        return ic

def gl_sel10(it, gl, data):
    rd = data[1]
    v = rd.value
    if v:
        it.decorate_mode_set(mode_type[v], True)

def my_gl_mode_right(obj, it, rd):
    v = rd.value
    if not v:
        it.decorate_mode_set(mode_type[v], True)

def my_gl_mode_left(obj, it, rd):
    v = rd.value
    if not v:
        it.decorate_mode_set(mode_type[v], False)

def my_gl_mode_cancel(obj, it, rd):
    print("drag")
    v = rd.value
    glit = obj.decorated_item
    if glit:
        glit.decorate_mode_set(mode_type[v], False)

def genlist10_clicked(obj, item=None):
    win = StandardWindow("genlist-decorate-item-mode",
        "Genlist Decorate Item Mode", autodel=True, size=(520, 520))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    bx2 = Box(win)
    bx2.show()

    fr = Frame(win, text="Decorate Item Mode Type", content=bx2)
    bx.pack_end(fr)
    fr.show()

    rd = Radio(win, size_hint_weight=EXPAND_BOTH, state_value=0,
        text="Slide : Sweep genlist items to the right.")
    rd.show()
    bx2.pack_end(rd)
    rdg = rd

    rd = Radio(win, size_hint_weight=EXPAND_BOTH, state_value=1,
        text = "Rotate : Click each item.")
    rd.group_add(rdg)
    rd.show()
    bx2.pack_end(rd)

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.callback_drag_start_right_add(my_gl_mode_right, rdg)
    gl.callback_drag_start_left_add(my_gl_mode_left, rdg)
    gl.callback_drag_start_up_add(my_gl_mode_cancel, rdg)
    gl.callback_drag_start_down_add(my_gl_mode_cancel, rdg)
    gl.show()

    itc10 = ItemClass10(item_style="default", decorate_item_style="mode")
    itc10.state_get = gl_state_get

    for i in range(1000, 1050):
        GenlistItem(item_class=itc10,
            item_data=i,
            parent_item=None,
            flags=ELM_GENLIST_ITEM_NONE,
            func=gl_sel10,
            func_data=(i, rdg)
            ).append_to(gl)

    bx.pack_end(gl)

    win.size = 520, 520
    win.show()


def edit_icon_clicked_cb(ic, data):
    item = data[2]
    item.delete()

class ItemClass15(GenlistItemClass):
    def text_get(self, obj, part, data):
        return "Item #%i" % (data[0])

    def content_get(self, obj, part, data):
        checked = data[1]

        # "edit" EDC layout is like below. each part is swallow part.
        # the existing item is swllowed to elm.swallow.edit.content part.
        # --------------------------------------------------------------------
        # | elm.edit.icon.1 | elm.swallow.decorate.content | elm.edit.icon,2 |
        # --------------------------------------------------------------------

        if part == "elm.swallow.end":
            ic = Icon(obj, file=os.path.join(img_path, "bubble.png"),
                size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
            return ic
        elif part == "elm.edit.icon.1":
            ck = Check(obj, state=checked, propagate_events=False)
            ck.show()
            return ck
        elif part == "elm.edit.icon.2":
            icn = Icon(obj, file=os.path.join(img_path, "icon_06.png"),
                propagate_events=False,
                size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
            icn.callback_clicked_add(edit_icon_clicked_cb, data)
            return icn
        else:
            return

    def delete(obj, *args):
        print("item deleted.")

def gl15_sel(it, gl, data):
    checked = data[1]
    if gl.decorate_mode:
        if not data[1]:
            data[1] = True
        else:
            data[1] = False
    it.update()

def gl15_deco_all_mode(obj, gl):
    gl.decorate_mode = True
    gl.select_mode = ELM_OBJECT_SELECT_MODE_ALWAYS

def gl15_normal_mode(obj, gl):
    gl.decorate_mode = False
    gl.select_mode = ELM_OBJECT_SELECT_MODE_DEFAULT

def genlist15_clicked(obj, item=None):
    win = StandardWindow("genlist-decorate-all-mode",
        "Genlist Decorate All Mode", autodel=True, size=(520, 520))

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    gl.show()

    itc15 = ItemClass15(item_style="default", decorate_all_item_style="edit")
    itc15.state_get = gl_state_get

    for i in range(100):
        ck = Check(gl)
        data = [i, False]
        it = GenlistItem(item_class=itc15,
            item_data=data,
            parent_item=None,
            flags=ELM_GENLIST_ITEM_NONE,
            func=gl15_sel,
            func_data=data,
            ).append_to(gl)

        data.append(it)

    bx.pack_end(gl)
    bx.show()

    bx2 = Box(win, horizontal=True, homogeneous=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)

    bt = Button(win, text="Decorate All mode", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(gl15_deco_all_mode, gl)
    bx2.pack_end(bt)
    bt.show()

    bt = Button(win, text="Normal mode", size_hint_align=FILL_BOTH,
        size_hint_weight=EXPAND_HORIZ)
    bt.callback_clicked_add(gl15_normal_mode, gl)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.show()

### Genlist search by text
cities = ("Albany","Annapolis","Atlanta","Augusta","Austin","Baton Rouge",
"Bismarck","Boise","Boston","Carson City","Charleston","Cheyenne","Columbia",
"Columbus","Concord","Denver","Des Moines","Dover","Frankfort","Harrisburg",
"Hartford","Helena","Honolulu","Indianapolis","Jackson","Jefferson City",
"Juneau","Lansing","Lincoln","Little Rock","Madison","Montgomery","Montpelier",
"Nashville","Oklahoma City","Olympia","Phoenix","Pierre","Providence",
"Raleigh","Richmond","Sacramento","Saint Paul","Salem","Salt Lake City",
"Santa Fe","Springfield","Tallahassee","Topeka","Trenton"
)

class ItemClass20(GenlistItemClass):
    def text_get(self, obj, part, data):
        if part == "elm.text":
            return data

    def content_get(self, obj, part, data):
        if part == "elm.swallow.icon":
            return Icon(obj, file=os.path.join(img_path, "logo_small.png"))

def genlist20_search_cb(en, gl, tg):
    flags = ELM_GLOB_MATCH_NOCASE if tg.state == False else 0
    from_item = gl.selected_item.next if gl.selected_item else None

    item = gl.search_by_text_item_get(from_item, "elm.text", en.text, flags)
    if item:
        item.selected = True
        en.focus = True
    elif gl.selected_item:
        gl.selected_item.selected = False

def genlist20_clicked(obj, item=None):
    win = StandardWindow("genlist-search-by-text",
        "Genlist Search By Text", autodel=True, size=(300, 520))

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    lb = Label(win)
    lb.text = \
    "<align=left>This example show the usage of search_by_text_item_get().<br>" \
    "Enter a search string and press Enter to show the next result.<br>" \
    "Search will start from the selected item (not included).<br>" \
    "You can search using glob patterns.</align>"
    fr = Frame(win, text="Information", content=lb,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(fr)
    fr.show()

    tg = Check(win, style="toggle", text="Case Sensitive Search");
    bx.pack_end(tg)
    tg.show()

    bx_entry = Box(win, horizontal=True,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(bx_entry)
    bx_entry.show()

    lb = Label(win, text="Search:")
    bx_entry.pack_end(lb)
    lb.show()

    en = Entry(win, single_line=True, scrollable=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.part_text_set("guide", "Type the search query")
    en.callback_activated_add(genlist20_search_cb, gl, tg)
    bx_entry.pack_end(en)
    en.show()
    en.focus = True

    bx.pack_end(gl)
    gl.show()

    itc20 = ItemClass20()
    for name in cities:
        gl.item_append(itc20, name)

    win.show()


### Genlist reorder mode
class ItemClass11(GenlistItemClass):
    def text_get(self, obj, part, data):
        if part == "elm.text":
            return "Item # %d" % data

    def content_get(self, obj, part, data):
        if part == "elm.swallow.icon":
            return Icon(obj, file=os.path.join(img_path, "logo_small.png"))

def genlist11_focus_highlight_ck_changed_cb(chk, win):
    win.focus_highlight_enabled = chk.state

def genlist11_reorder_tg_changed_cb(chk, gl):
    gl.reorder_mode = chk.state

def genlist11_clicked(obj, item=None):
    win = StandardWindow("genlist-reorder-mode", "Genlist Reorder Mode",
                         autodel=True, size=(350, 500))

    gl = Genlist(win, size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    lb = Label(win)
    lb.text = "<align=left>Enable reorder mode if you want to move items.<br>" \
              "To move longress with mouse.</align>"
    fr = Frame(win, text="Reorder Mode", content=lb,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(fr)
    fr.show()

    hbx = Box(win, horizontal=True, padding=(20,0),
              size_hint_weight=EXPAND_HORIZ)
    bx.pack_end(hbx)
    hbx.show()

    tg = Check(win, style="toggle", text="Reorder Mode:")
    tg.callback_changed_add(genlist11_reorder_tg_changed_cb, gl)
    hbx.pack_end(tg)
    tg.show()

    ck = Check(win, text="Focus Highlight")
    ck.state = win.focus_highlight_enabled
    ck.callback_changed_add(genlist11_focus_highlight_ck_changed_cb, win)
    hbx.pack_end(ck)
    ck.show()

    itc11 = ItemClass11()
    for i in range(1,50):
        gl.item_append(itc11, i)
    bx.pack_end(gl)
    gl.show()
   
    win.show()

if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application",
        size=(320,520))
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    items = [
        ("Genlist", genlist_clicked),
        ("Genlist 2", genlist2_clicked),
        ("Genlist Group", genlist3_clicked),
        ("Genlist Sorted", genlist4_clicked),
        ("Genlist Iteration", genlist5_clicked),
        ("Genlist Decorate Item Mode", genlist10_clicked),
        ("Genlist Decorate All Mode", genlist15_clicked),
        ("Genlist Search By Text", genlist20_clicked),
        ("Genlist Reorder Mode", genlist11_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
    elementary.shutdown()
