#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl import edje
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.bubble import Bubble
from efl.elementary.button import Button
from efl.elementary.label import Label
from efl.elementary.layout import Layout
from efl.elementary.list import List
from efl.elementary.frame import Frame
from efl.elementary.separator import Separator
from efl.elementary.scroller import Scroller
from efl.elementary.spinner import Spinner
from efl.elementary.check import Check
from efl.elementary.entry import Entry
from efl.elementary.table import Table
from efl.elementary.toolbar import Toolbar, ELM_TOOLBAR_SHRINK_MENU
from efl.elementary.object import ELM_FOCUS_DOWN, ELM_FOCUS_UP, \
    ELM_FOCUS_MOVE_POLICY_CLICK, ELM_FOCUS_MOVE_POLICY_IN, \
    ELM_FOCUS_MOVE_POLICY_KEY_ONLY
from efl.elementary.configuration import Configuration
from efl.elementary.theme import theme_overlay_add
from efl.elementary.radio import Radio


script_path = os.path.dirname(os.path.abspath(__file__))
edj_file = os.path.join(script_path, "test.edj")
conf = Configuration()

# Focus
def _tb_sel(tb, item):
    print(item)
    print(item.text)

def _obj_focused_cb(obj):
    print("Focused: ", obj)

def focus_clicked(obj, item=None):
    win = StandardWindow("focus", "Focus", autodel=True, size=(800,600))
    
    win.focus_highlight_enabled = True

    tbx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(tbx)
    tbx.show()

    ### Toolbar
    tbar = Toolbar(win, shrink_mode=ELM_TOOLBAR_SHRINK_MENU,
                   size_hint_align=(EVAS_HINT_FILL,0.0))
    tbar.callback_focused_add(_obj_focused_cb)

    tb_it = tbar.item_append("document-print", "Hello", _tb_sel)
    tb_it.disabled = True
    tb_it = tbar.item_append("folder-new", "World", _tb_sel)
    tb_it = tbar.item_append("object-rotate-right", "H", _tb_sel)
    tb_it = tbar.item_append("object-rotate-left", "Comes", _tb_sel)
    tb_it = tbar.item_append("folder", "Elementary", _tb_sel)

    tb_it = tbar.item_append("view-refresh", "Menu", _tb_sel)
    tb_it.menu = True
    tbar.menu_parent = win
    menu = tb_it.menu

    menu.item_add(None, "Shrink", "edit-cut", _tb_sel)
    menu_it = menu.item_add(None, "Mode", "edit-copy", _tb_sel)
    menu.item_add(menu_it, "is set to", "edit-paste", _tb_sel)
    menu.item_add(menu_it, "or to", "edit-paste", _tb_sel)
    menu.item_add(None, "Menu", "edit-delete", _tb_sel)

    tbx.pack_end(tbar)
    tbar.show()


    mainbx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    tbx.pack_end(mainbx)
    mainbx.show()

    ## First Col
    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    mainbx.pack_end(bx)
    bx.show()

    lb = Label(win, text="<b>Use Tab or Shift+Tab<br/>or Arrow keys</b>",
                    size_hint_align=FILL_BOTH)
    bx.pack_end(lb)
    lb.show()

    tg = Check(win, style="toggle")
    tg.callback_focused_add(_obj_focused_cb)
    tg.part_text_set("on", "Yes")
    tg.part_text_set("off", "No")
    bx.pack_end(tg)
    tg.show()
    
    en = Entry(win, scrollable=True, single_line=True, text="This is a single line",
                    size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.callback_focused_add(_obj_focused_cb)
    bx.pack_end(en)
    en.show()

    #
    bx2 = Box(win, horizontal=True, size_hint_align=FILL_BOTH)
    bx.pack_end(bx2)
    bx2.show()

    for i in range(2):
        bt = Button(win, text="Box", size_hint_align=FILL_BOTH, disabled=(i % 2))
        bt.callback_focused_add(_obj_focused_cb)
        bx2.pack_end(bt)
        bt.show()

    sc = Scroller(win, bounce=(True,True), content_min_limit=(1,1),
                  size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx2.pack_end(sc)
    sc.show()

    bt = Button(win, text="Scroller", size_hint_align=FILL_BOTH)
    bt.callback_focused_add(_obj_focused_cb)
    sc.content = bt
    bt.show()

    #
    bt = Button(win, text="Box", size_hint_align=FILL_BOTH)
    bt.callback_focused_add(_obj_focused_cb)
    bx.pack_end(bt)
    bt.show()

    #
    bx2 = Box(win, horizontal=True, size_hint_align=FILL_BOTH)
    bx.pack_end(bx2)
    bx2.show()
    
    for i in range(2):
        bx3 = Box(win, size_hint_align=FILL_BOTH)
        bx2.pack_end(bx3)
        bx3.show()

        for j in range(3):
            bt = Button(win, text="Box", size_hint_align=FILL_BOTH)
            bt.callback_focused_add(_obj_focused_cb)
            bx3.pack_end(bt)
            bt.show()
    

    sc = Scroller(win, bounce=(False, True), content_min_limit=(1,0),
                  size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    sc.content_min_limit=(1, 1) ## Why this do not work ???
    bx2.pack_end(sc)
    sc.show()

    bx3 = Box(win, size_hint_align=FILL_BOTH)
    sc.content = bx3
    bx3.show()

    for i in range(5):
        bt = Button(win, text="BX Scroller", size_hint_align=FILL_BOTH)
        bt.callback_focused_add(_obj_focused_cb)
        bx3.pack_end(bt)
        bt.show()


    ## Second Col
    ly = Layout(win, size_hint_weight=EXPAND_BOTH)
    ly.file = edj_file, "twolines"
    mainbx.pack_end(ly)
    ly.show()

    bx2 = Box(win, horizontal=True, size_hint_align=FILL_BOTH)
    ly.part_content_set("element1", bx2)
    bx2.show()

    for i in range(3):
        bt = Button(win, text="Layout", size_hint_align=FILL_BOTH)
        bt.callback_focused_add(_obj_focused_cb)
        bx2.pack_end(bt)
        bt.show()
        bx2.focus_custom_chain_prepend(bt)

    bx2 = Box(win, size_hint_align=FILL_BOTH)
    ly.part_content_set("element2", bx2)
    bx2.show()

    bt = Button(win, text="Disable", size_hint_align=FILL_BOTH)
    bt.callback_clicked_add(lambda b: b.disabled_set(True))
    bt.callback_focused_add(_obj_focused_cb)
    bx2.pack_end(bt)
    bt.show()
    bx2.focus_custom_chain_prepend(bt)

    bt2 = Button(win, text="Enable", size_hint_align=FILL_BOTH)
    bt2.callback_clicked_add(lambda b, b1: b1.disabled_set(False), bt)
    bt2.callback_focused_add(_obj_focused_cb)
    bx2.pack_end(bt2)
    bt2.show()
    bx2.focus_custom_chain_append(bt2)

    ## Third Col
    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    mainbx.pack_end(bx)
    bx.show()

    fr = Frame(win, text="Frame")
    bx.pack_end(fr)
    fr.show()

    tb = Table(win, size_hint_weight=EXPAND_BOTH)
    fr.content = tb
    tb.show()

    for j in range(1):
        for i in range(2):
            bt = Button(win, text="Table", size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
            bt.callback_focused_add(_obj_focused_cb)
            tb.pack(bt, i, j, 1, 1)
            bt.show()

    #
    fr = Bubble(win, text="Bubble", size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
    bx.pack_end(fr)
    fr.show()

    tb = Table(win,  size_hint_weight=EXPAND_BOTH)
    fr.content = tb
    tb.show()

    for j in range(2):
        bt = Button(win, text="Table", size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
        bt.callback_focused_add(_obj_focused_cb)
        tb.pack(bt, 0, j, 1, 1)
        bt.show()


    win.show()


# Focus 2
def _focus_obj(bt, newfocus):
    print(newfocus)
    newfocus.focus = True

def _focus_layout_part(bt, layout):
    newfocus = layout.edje.part_object_get("sky")
    print(newfocus)
    newfocus.focus = True
    

def focus2_clicked(obj, item=None):
    win = StandardWindow("focus2", "Focus 2", autodel=True, size=(400, 400))

    win.focus_highlight_enabled = True

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    PARENT = bx

    en = Entry(PARENT, scrollable=True, single_line=True,
               text="Entry that should get focus",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bx.pack_end(en)
    en.show()
    
    bt = Button(PARENT, text="Give focus to entry")
    bt.callback_clicked_add(_focus_obj, en)
    bx.pack_end(bt)
    bt.show()
   
    ly = Layout(PARENT, size_hint_weight=EXPAND_BOTH)
    ly.file = edj_file, "layout"
    bx.pack_end(ly)
    ly.show()

    bt1 = bt = Button(ly, text="Button 1")
    ly.part_content_set("element1", bt)

    en1 = Entry(ly, scrollable=True, single_line=True,
                text="Scrolled Entry that should get focus",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ )
    ly.part_content_set("element2", en1)

    bt = Button(ly, text="Button 2")
    ly.part_content_set("element3", bt)


    bt = Button(PARENT, text="Give focus to layout",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_focus_obj, ly)
    bx.pack_end(bt)
    bt.show()

    bt = Button(PARENT, text="Give focus to layout part",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_focus_layout_part, ly)
    bx.pack_end(bt)
    bt.show()

    bt = Button(PARENT, text="Give focus to layout 'Button 1'",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_focus_obj, bt1)
    bx.pack_end(bt)
    bt.show()

    bt = Button(PARENT, text="Give focus to layout 'Entry'",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_focus_obj, en1)
    bx.pack_end(bt)
    bt.show()

    bt.focus_next_object_set(en, ELM_FOCUS_DOWN)
    en.focus_next_object_set(bt, ELM_FOCUS_UP)
    win.show()


# Focus 3
focused = None
def _focused_cb(obj):
    global focused
    print(obj)
    focused = obj

def _unfocused_cb(obj):
    global focused
    print(obj)
    focused = None

def _add_cb(bt, win, bx):
    en = Entry(win, scrollable=True, single_line=True, text="An entry",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.callback_focused_add(_focused_cb)
    en.callback_unfocused_add(_unfocused_cb)
    bx.pack_start(en)
    en.show()

def _del_cb(bt, bx):
    if focused:
        focused.delete()

def _hide_cb(bt):
    if focused:
        focused.hide()

def focus3_clicked(obj, item=None):
    win = StandardWindow("focus3", "Focus 3", autodel=True, size=(320, 480))

    win.focus_highlight_enabled = True

    bx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bx)
    bx.show()

    en = Entry(win, scrollable=True, single_line=True, text="An entry",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    en.callback_focused_add(_focused_cb)
    en.callback_unfocused_add(_unfocused_cb)
    bx.pack_end(en)
    en.show()

    bt = Button(win, text="Add", focus_allow=False,
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_add_cb, win, bx)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Del", focus_allow=False,
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_del_cb, bx)
    bx.pack_end(bt)
    bt.show()

    bt = Button(win, text="hide", focus_allow=False,
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_HORIZ)
    bt.callback_clicked_add(_hide_cb)
    bx.pack_end(bt)
    bt.show()

    win.show()


# Focus 4
def _highlight_enabled_cb(chk, win):
    conf.focus_highlight_enabled = chk.state

def _highlight_animate_cb(chk, win):
    conf.focus_highlight_animate = chk.state

def _win_highlight_enabled_cb(chk, win):
    win.focus_highlight_enabled = chk.state

def _win_highlight_animate_cb(chk, win):
    win.focus_highlight_animate = chk.state

def _custom_chain_cb(chk, bx):
    print(chk.state)
    if chk.state is True:
        i = 0
        custom_chain = []
        for child in bx.children:
            print(child)
            if i == 0:
                c = child   
                custom_chain.append(child)
                bx.focus_custom_chain_set(custom_chain)
            elif i == 1:
                bx.focus_custom_chain_prepend(child, c)
            elif i == 2:
                bx.focus_custom_chain_append(child, c)
                c = child
            elif i == 3:
                bx.focus_custom_chain_prepend(child, c)
            i += 1
        
    else:
        bx.focus_custom_chain_unset()

def focus4_clicked(obj, item=None):
    win = StandardWindow("focus4", "Focus 4", autodel=True, size=(320, 320))

    win.focus_highlight_enabled = True
    win.focus_highlight_animate = True

    fr = Frame(win, style="pad_large",
              size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(fr)
    fr.show()

    # First Example - Using Focus Highlight
    bx = Box(fr)
    fr.content = bx
    bx.show()

    tg = Check(bx, text="Focus Highlight Enabled (Config)", state=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tg.callback_changed_add(_highlight_enabled_cb, win)

    bx.pack_end(tg)
    tg.show()

    tg = Check(bx, text="Focus Highlight Animate (Config)", state=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tg.callback_changed_add(_highlight_animate_cb, win)
    bx.pack_end(tg)
    tg.show()

    tg = Check(bx, text="Focus Highlight Enabled (Win)", state=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tg.callback_changed_add(_win_highlight_enabled_cb, win)
    bx.pack_end(tg)
    tg.show()

    tg = Check(bx, text="Focus Highlight Animate (Win)", state=True,
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tg.callback_changed_add(_win_highlight_animate_cb, win)
    bx.pack_end(tg)
    tg.show()

    sp = Separator(win, horizontal=True,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(sp)
    sp.show()

    # Second Example - Using Custom Chain
    lb = Label(bx, text="Custom Chain: Please use tab key to check",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(lb)
    lb.show()

    bx2 = Box(bx, horizontal=True,
              size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx.pack_end(bx2)
    bx2.show()

    bt1 = Button(bx2, text="Button 1",
                 size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx2.pack_end(bt1)
    bt1.show()
    
    bt2 = Button(bx2, text="Button 2",
                 size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx2.pack_end(bt2)
    bt2.show()
    
    bt3 = Button(bx2, text="Button 3",
                 size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx2.pack_end(bt3)
    bt3.show()
    
    bt4 = Button(bx2, text="Button 4",
                 size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx2.pack_end(bt4)
    bt4.show()

    bx2.focus_custom_chain = [bt2, bt1, bt4, bt3]
   
    tg = Check(bx, text="Custom Chain", state=False, 
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    tg.callback_changed_add(_custom_chain_cb, bx)
    bx.pack_end(tg)
    tg.show()
   

    win.show()


# Focus 5 (custom)
def _glow_effect_on_cb(btn, win, chk):
    if chk.state:
        win.focus_highlight_style = "glow_effect"

def _glow_effect_off_cb(btn, win, chk):
    if chk.state:
        win.focus_highlight_style = "glow"

def focus5_clicked(obj, item=None):

    theme_overlay_add(os.path.join(script_path, "test_focus_custom.edj"))

    win = StandardWindow("focus5", "Focus Custom", autodel=True, size=(320, 320))
    win.focus_highlight_enabled = True
    win.focus_highlight_animate = True
    win.focus_highlight_style = "glow"

    fr = Frame(win, style="pad_large",
              size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(fr)
    fr.show()

    bx = Box(fr)
    fr.content = bx
    bx.show()

    chk = Check(bx, text='Enable glow effect on "Glow" Button', state=True,
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(chk)
    chk.show()

    spinner = Spinner(bx, size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(spinner)
    spinner.show()

    bt = Button(bx, text="Glow Button",
                size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bt.callback_focused_add(_glow_effect_on_cb, win, chk)
    bt.callback_unfocused_add(_glow_effect_off_cb, win, chk)
    bx.pack_end(bt)
    bt.show()

    sp = Separator(bx, horizontal=True,
                   size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    bx.pack_end(sp)
    sp.show()

    bx2 = Box(bx, horizontal=True,
              size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx.pack_end(bx2)
    bx2.show()

    for i in range (1, 5):
        bt = Button(bx2, text="Button %d" % i,
                    size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
        bx2.pack_end(bt)
        bt.show()

    win.show()


# Focus Move Policy
def _move_policy_changed_cb(radio, bt3, text):
    bt3.text = "Test Button " + text
    bt3.focus_move_policy = radio.state_value

def focus6_clicked(obj, item=None):
    win = StandardWindow("focus6", "Focus Move Policy", 
                         autodel=True, size=(320, 320))
    win.focus_highlight_enabled = True
    win.focus_highlight_animate = True

    bx = Box(win, size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    win.resize_object_add(bx)
    bx.show()

    # first frame
    fr = Frame(bx, text="Focusable Buttons", size_hint_fill=FILL_BOTH)
    bx.pack_end(fr)
    fr.show()

    frbx = Box(fr, size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    fr.content = frbx
    frbx.show()

    bt1 = Button(frbx, text="Button 1", size_hint_fill=FILL_HORIZ)
    frbx.pack_end(bt1)
    bt1.show()

    bt2 = Button(frbx, text="Button 2", size_hint_fill=FILL_HORIZ)
    frbx.pack_end(bt2)
    bt2.show()

    bt3 = Button(frbx, text="Test Button (MOUSE CLICK or KEY)", 
                 size_hint_fill=FILL_HORIZ)
    frbx.pack_end(bt3)
    bt3.show()

    bt4 = Button(frbx, text="Button 4", size_hint_fill=FILL_HORIZ)
    frbx.pack_end(bt4)
    bt4.show()


    # second frame
    fr = Frame(bx, text="Focus Options for a TEST button", 
               size_hint_fill=FILL_BOTH)
    bx.pack_end(fr)
    fr.show()

    frbx = Box(fr, size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    fr.content = frbx
    frbx.show()

    lbl = Label(frbx, text="This focus option will be applied only for the TEST button. <br/>The focus policies of other buttons will remain in MOUSE CLICK status.",
                size_hint_expand=EXPAND_HORIZ)
    frbx.pack_end(lbl)
    lbl.show()
    
    rdg = Radio(frbx, state_value=ELM_FOCUS_MOVE_POLICY_CLICK,
                text="Focus Move Pollicy Mouse Click",
                size_hint_align=(0.0,0.5))
    frbx.pack_end(rdg)
    rdg.show()
    rdg.callback_changed_add(_move_policy_changed_cb, bt3, "(MOUSE CLICK or KEY)")

    rd = Radio(frbx, state_value=ELM_FOCUS_MOVE_POLICY_IN,
               text="Focus Move Policy Mouse In",
               size_hint_align=(0.0,0.5))
    frbx.pack_end(rd)
    rd.group_add(rdg)
    rd.show()
    rd.callback_changed_add(_move_policy_changed_cb, bt3, "(MOUSE IN or KEY))")

    rd = Radio(frbx, state_value=ELM_FOCUS_MOVE_POLICY_KEY_ONLY,
               text="Focus Move Pollicy Key Only",
               size_hint_align=(0.0,0.5))
    frbx.pack_end(rd)
    rd.group_add(rdg)
    rd.show()
    rd.callback_changed_add(_move_policy_changed_cb, bt3, "(KEY ONLY)")

    # show the win
    bt1.focus = True
    win.show()


if __name__ == "__main__":
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

    items = [("Focus", focus_clicked),
             ("Focus 2", focus2_clicked),
             ("Focus 3", focus3_clicked),
             ("Focus 4", focus4_clicked),
             ("Focus Custom", focus5_clicked),
             ("Focus Move Policy", focus6_clicked),
            ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
