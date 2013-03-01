#!/usr/bin/env python
# encoding: utf-8

import time

from efl import evas
from efl import ecore
from efl import elementary
from efl.elementary.window import Window
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.button import Button
from efl.elementary.list import List
from efl.elementary.icon import Icon
from efl.elementary.genlist import Genlist, GenlistItem, GenlistItemClass


def gl_text_get(obj, part, item_data):
    return "Item # %i" % (item_data,)

def gl_content_get(obj, part, data):
    ic = Icon(obj)
    ic.file_set("images/logo_small.png")
    ic.size_hint_aspect_set(evas.EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)
    return ic

def gl_state_get(obj, part, item_data):
    return False

def gl_comp_func(item1, item2):
    #print(item1.data)
    #print(item2.data)
    # If data1 is 'less' than data2, -1 must be returned, if it is 'greater', 1 must be returned, and if they are equal, 0 must be returned.
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
    ic = Icon(obj)
    ic.file_set("images/logo.png")
    ic.size_hint_aspect_set(evas.EVAS_ASPECT_CONTROL_VERTICAL, 1, 1)
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
    win = Window("Genlist", elementary.ELM_WIN_BASIC)
    win.title_set("Genlist test")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    gl = Genlist(win)
    gl.callback_selected_add(_gl_selected, "arg1", "arg2", kwarg1="kwarg1", kwarg2="kwarg2")
    gl.callback_clicked_double_add(_gl_clicked_double, "arg1", "arg2", kwarg1="kwarg1", kwarg2="kwarg2")
    gl.callback_longpressed_add(_gl_longpressed, "arg1", "arg2", kwarg1="kwarg1", kwarg2="kwarg2")
    gl.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    gl.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bx.pack_end(gl)
    gl.show()

    over = evas.Rectangle(win.evas_get())
    over.color_set(0, 0, 0, 0)
    over.event_callback_add(evas.EVAS_CALLBACK_MOUSE_DOWN, _gl_over_click, gl)
    over.repeat_events_set(True)
    over.show()
    over.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(over)

    vbx = Box(win)
    vbx.horizontal_set(True)
    bx.pack_end(vbx)
    vbx.show()

    itc1 = GenlistItemClass(item_style="default",
                            text_get_func=gl_text_get,
                            content_get_func=gl_content_get,
                            state_get_func=gl_state_get)

    bt_50 = Button(win)
    bt_50.text_set("Go to 50")
    vbx.pack_end(bt_50)
    bt_50.show()

    bt_1500 = Button(win)
    bt_1500.text_set("Go to 1500")
    vbx.pack_end(bt_1500)
    bt_1500.show()

    for i in range(0, 2000):
        gli = gl.item_append(itc1, i, func=gl_item_sel)
        if i == 50:
            bt_50._callback_add("clicked", lambda bt, it: it.bring_in(), gli)
        elif i == 1500:
            bt_1500._callback_add("clicked", lambda bt, it: it.bring_in(), gli)

    win.resize(480, 800)
    win.show()


def genlist2_clicked(obj, item=None):
    win = Window("Genlist", elementary.ELM_WIN_BASIC)
    win.title_set("Genlist test 2")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.file_set("images/plant_01.jpg")
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    bx = Box(win)
    win.resize_object_add(bx)
    bx.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bx.show()

    gl = Genlist(win)
    gl.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    gl.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
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

    bx2 = Box(win)
    bx2.horizontal_set(True)
    bx2.homogeneous_set(True)
    bx2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)


    def my_gl_first(bt, gl):
        gli = gl.first_item_get()
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win)
    bt.text_set("/\\")
    bt.callback_clicked_add(my_gl_first, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_last(bt, gl):
        gli = gl.last_item_get()
        if gli:
            gli.show()
            gli.selected = True

    bt = Button(win)
    bt.text_set("\\/")
    bt.callback_clicked_add(my_gl_last, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_disable(bt, gl):
        gli = gl.selected_item_get()
        if gli:
            gli.disabled = True
            gli.selected = False
            gli.update()
        else:
            print("no item selected")

    bt = Button(win)
    bt.text_set("#")
    bt.callback_clicked_add(my_gl_disable, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_update_all(bt, gl):
        gli = gl.first_item_get()
        i = 0
        while gli:
            gli.update()
            print(i)
            i = i + 1
            gli = gli.next_get()

    bt = Button(win)
    bt.text_set("U")
    bt.callback_clicked_add(my_gl_update_all, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()


    bx2 = Box(win)
    bx2.horizontal_set(True)
    bx2.homogeneous_set(True)
    bx2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)


    def my_gl_clear(bt, gl):
        gl.clear()

    bt = Button(win)
    bt.text_set("X")
    bt.callback_clicked_add(my_gl_clear, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    class MyGlAdd:
        i = 0
    def my_gl_add(bt, gl, itc1):
        gl.item_append(itc1, MyGlAdd.i, func=gl_item_sel)
        MyGlAdd.i = MyGlAdd.i + 1

    bt = Button(win)
    bt.text_set("+")
    bt.callback_clicked_add(my_gl_add, gl, itc1)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_del(bt, gl):
        gli = gl.selected_item_get()
        if gli:
            gli.delete()
        else:
            print("no item selected")

    bt = Button(win)
    bt.text_set("-")
    bt.callback_clicked_add(my_gl_del, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    bx2 = Box(win)
    bx2.horizontal_set(True)
    bx2.homogeneous_set(True)
    bx2.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)


    class MyGlInsertBefore:
        i = 0
    def my_gl_insert_before(bt, gl, itc1):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_before(itc1, MyGlInsertBefore.i, gli, func=gl_item_sel)
            MyGlInsertBefore.i = MyGlInsertBefore.i + 1
        else:
            print("no item selected")

    bt = Button(win)
    bt.text_set("+ before")
    bt.callback_clicked_add(my_gl_insert_before, gl, itc1)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    class MyGlInsertAfter:
        i = 0
    def my_gl_insert_after(bt, gl, itc1):
        gli = gl.selected_item_get()
        if gli:
            gl.item_insert_after(itc1, MyGlInsertAfter.i, gli, func=gl_item_sel)
            MyGlInsertAfter.i = MyGlInsertAfter.i + 1
        else:
            print("no item selected")

    bt = Button(win)
    bt.text_set("+ after")
    bt.callback_clicked_add(my_gl_insert_after, gl, itc1)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()


    def my_gl_flush(bt, gl):
        def my_gl_flush_delay():
            elm_cache_all_flush()
        ecore.timer_add(1.2, my_gl_flush_delay)
    bt = Button(win)
    bt.text_set("Flush")
    bt.callback_clicked_add(my_gl_flush, gl)
    bt.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    bt.size_hint_weight_set(evas.EVAS_HINT_EXPAND, 0.0)
    bx2.pack_end(bt)
    bt.show()

    bx.pack_end(bx2)
    bx2.show()

    win.resize(320, 320)
    win.show()


def genlist3_clicked(obj, item=None):
    win = Window("Genlist", elementary.ELM_WIN_BASIC)
    win.title_set("Genlist Group test")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    gl = Genlist(win)
    win.resize_object_add(gl)
    gl.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    gl.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
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
                                 flags=elementary.ELM_GENLIST_ITEM_GROUP)
            git.select_mode_set(elementary.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY)
        gl.item_append(itc_i, i, git)

    win.resize(320, 320)
    win.show()

def genlist4_clicked(obj, item=None):
    win = Window("Genlist", elementary.ELM_WIN_BASIC)
    win.title_set("Genlist sorted insert test")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    gl = Genlist(win)
    win.resize_object_add(gl)
    gl.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    gl.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get,
                             state_get_func=gl_state_get)

    for i in range(100,-1,-1):
        GenlistItem(itc_i, None, 0, None, i).sorted_insert(gl, gl_comp_func)

    win.resize(320, 320)
    win.show()

def genlist5_clicked(obj, item=None):
    win = Window("Genlist", elementary.ELM_WIN_BASIC)
    win.title_set("Genlist iteration test")
    win.autodel_set(True)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    gl = Genlist(win)
    win.resize_object_add(gl)
    gl.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    gl.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    gl.show()

    itc_i = GenlistItemClass(item_style="default",
                             text_get_func=gl_text_get,
                             content_get_func=gl_content_get,
                             state_get_func=gl_state_get)

    item_count = 10000

    t1 = time.time()
    for i in xrange(item_count):
        GenlistItem(itc_i, None, 0, None, i).append_to(gl)
    t2 = time.time()

    j = gl.first_item
    t3 = time.time()
    while j:
        d = j.data
        j = j.next
    t4 = time.time()

    print("Time to add {0} items:".format(item_count))
    print(t2-t1)
    print("Time to iterate item data over {0} items:".format(item_count))
    print(t4-t3)

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    def destroy(obj):
        elementary.exit()

    elementary.init()
    win = Window("test", elementary.ELM_WIN_BASIC)
    win.title_set("python-elementary test application")
    win.callback_delete_request_add(destroy)

    bg = Background(win)
    win.resize_object_add(bg)
    bg.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    bg.show()

    box0 = Box(win)
    box0.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text_set("Information")
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content_set(lb)
    lb.show()

    items = [
        ("Genlist", genlist_clicked),
        ("Genlist 2", genlist2_clicked),
        ("Genlist Group", genlist3_clicked),
        ("Genlist Sorted", genlist4_clicked),
        ("Genlist Iteration", genlist5_clicked),
    ]

    li = List(win)
    li.size_hint_weight_set(evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND)
    li.size_hint_align_set(evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
