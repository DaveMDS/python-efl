#!/usr/bin/env python
# encoding: utf-8

import os
import logging

efllog = logging.getLogger("efl")
efllog.setLevel(logging.DEBUG)
efllog.addHandler(logging.StreamHandler())
elmlog = logging.getLogger("efl.elementary")
elmlog.setLevel(logging.DEBUG)
elmlog.propagate = False
elmlog.addHandler(logging.StreamHandler())

from efl.ecore import Timer, ECORE_CALLBACK_CANCEL, ECORE_CALLBACK_RENEW, \
    AnimatorTimeline
from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH, \
    EVAS_ASPECT_CONTROL_VERTICAL, EVAS_CALLBACK_MOUSE_MOVE, \
    EVAS_CALLBACK_MOUSE_UP, EVAS_CALLBACK_MOUSE_DOWN, \
    EVAS_EVENT_FLAG_ON_HOLD
from efl import elementary
from efl.elementary import Label
from efl.elementary import Frame
from efl.elementary import List, ELM_LIST_LIMIT
from efl.elementary import Box
from efl.elementary import StandardWindow
from efl.elementary import Icon
from efl.elementary import Genlist, GenlistItem, GenlistItemClass, \
    ELM_SEL_FORMAT_TARGETS, ELM_GENLIST_ITEM_NONE, DragUserInfo
from efl.elementary import Gengrid, GengridItemClass
from efl.elementary import Background
from efl.elementary import Check
from efl.elementary import Button
from efl.elementary import Configuration
conf = Configuration()
SCALE = conf.scale


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

img = (
    "panel_01.jpg",
    "plant_01.jpg",
    "rock_01.jpg",
    "rock_02.jpg",
    "sky_01.jpg",
    "sky_02.jpg",
    "sky_03.jpg",
    "sky_04.jpg",
    "wood_01.jpg",
    )

class AnimIconSt:
    def __init__(self):
        self.start_x = 0
        self.start_y = 0
        self.o = None

class DragAnimSt:
    def __init__(self):
        self.icwin = None
        self.e = None
        self.mdx = 0     # Mouse-down x
        self.mdy = 0     # Mouse-down y
        self.icons = []   # List of icons to animate (anim_icon_st)
        self.tm = None
        self.ea = None
        self.gl = None

DRAG_TIMEOUT = 0.3
ANIM_TIME = 0.5

class DndGenlistItemClass(GenlistItemClass):
    def text_get(self, obj, part, data, *args):
        return data

    def content_get(self, obj, part, data, *args):
        if part == "elm.swallow.icon":
            icon = Icon(obj, file=os.path.join(img_path, data),
                size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
            icon.show()
            return icon
        return None

itc1 = DndGenlistItemClass()

class DndGengridItemClass(GengridItemClass):
    def text_get(self, obj, part, data, *args):
        return data

    def content_get(self, obj, part, data, *args):
        if part == "elm.swallow.icon":
            icon = Icon(obj, file=os.path.join(img_path, data),
                size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
            icon.show()
            return icon
        return None

gic = DndGengridItemClass()

def win_del(obj, data):
    data.drop_item_container_del()
    data.drag_item_container_del()

def gl_item_getcb(gl, x, y):
    # This function returns pointer to item under (x,y) coords
    gli, yposret = gl.at_xy_item_get(x, y)
    if gli is not None:
        print("over %r yposret=%d" % (gli, yposret))
    else:
        print("over none, yposret=%d" % yposret)
    return gli, None, yposret

def grid_item_getcb(grid, x, y):
    # This function returns pointer to item under (x,y) coords
    item, xposret, yposret = grid.at_xy_item_get(x, y)
    if item is not None:
        print("over %r xposret=%d yposret=%d" % (item, xposret, yposret))
    else:
        print("over none, xposret=%d yposret=%d", xposret, yposret)
    return item, xposret, yposret

def gl_poscb(obj, it, x, y, xposret, yposret, action, data):
    print("obj: %r, item: %r, x y: %d %d, posret: %d %d" %
          (obj, it, x, y, xposret, yposret))

def gl_dropcb(obj, it, ev, xposret, yposret, data):
    # This function is called when data is dropped on the genlist
    if ev.data is None:
        return False

    p = ev.data

    wh0rdlist = p.split("#")

    wh0rdlist.pop(0)
    wh0rdlist.pop()

    for wh0rd in wh0rdlist:
        print("Item %s" % wh0rd)

        if yposret == -1:
            obj.item_insert_before(itc1, wh0rd, before_item=it, flags=ELM_GENLIST_ITEM_NONE)
        elif yposret == 0 or yposret == 1:
            if not it:
                it = obj.last_item
            if it:
                obj.item_insert_after(itc1, wh0rd, after_item=it, flags=ELM_GENLIST_ITEM_NONE)
            else:
                obj.item_append(itc1, wh0rd, flags=ELM_GENLIST_ITEM_NONE)
        else:
            return False

    return True

def grid_dropcb(obj, it, ev, xposret, yposret, data):
    # This function is called when data is dropped on the gengrid
    if ev.data is None:
        return False

    p = ev.data

    wh0rdlist = p.split("#")
    wh0rdlist.pop(0)
    wh0rdlist.pop()

    for wh0rd in wh0rdlist:
        print("Item %s" % wh0rd)

        if not it:
            it = obj.last_item

        if it:
            it = obj.item_insert_after(gic, wh0rd, after_item=it)
        else:
            it = obj.item_append(gic, wh0rd)

    return True

def anim_st_free(anim_st):
    # Stops and free mem of ongoing animation
    if anim_st is not None:
        anim_st.gl.event_callback_del(
            EVAS_CALLBACK_MOUSE_MOVE, gl_obj_mouse_move)
        anim_st.gl.event_callback_del(
            EVAS_CALLBACK_MOUSE_UP, gl_obj_mouse_up)
        if anim_st.tm is not None:
            anim_st.tm.delete()
            anim_st.tm = None

        if anim_st.ea is not None:
            anim_st.ea.delete()
            anim_st.ea = None

        for st in anim_st.icons:
            st.o.delete()

def drag_anim_play(pos, anim_st):
    # Impl of the animation of icons, called on frame time

    if anim_st is not None:
        if pos > 0.99:
            anim_st.ea = None  # Avoid deleting on mouse up

            for st in anim_st.icons:
                st.o.hide()   # Hide animated icons
            anim_st_free(anim_st)
            return ECORE_CALLBACK_CANCEL

        for st in anim_st.icons:
            w, h = st.o.size
            xm, ym = anim_st.e.pointer_canvas_xy
            x = st.start_x + (pos * (xm - (st.start_x + (w/2))))
            y = st.start_y + (pos * (ym - (st.start_y + (h/2))))
            st.o.move(x, y)

        return ECORE_CALLBACK_RENEW

    return ECORE_CALLBACK_CANCEL

def gl_anim_start(anim_st):
    # Start icons animation before actually drag-starts
    yposret = 0

    items = list(anim_st.gl.selected_items)
    gli, yposret = anim_st.gl.at_xy_item_get(anim_st.mdx, anim_st.mdy)
    if gli is not None:
        # Add the item mouse is over to the list if NOT seleced
        if not gli in items:
            items.append(gli)

    for gli in items:
        # Now add icons to animation window
        o = gli.part_content_get("elm.swallow.icon")

        if o is not None:
            st = AnimIconSt()
            ic = Icon(anim_st.gl, file=o.file, size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_BOTH, pos=o.pos, size=o.size)
            st.start_x, st.start_y = o.pos
            ic.show()

            st.o = ic
            anim_st.icons.append(st)

    anim_st.tm = None
    anim_st.ea = AnimatorTimeline(drag_anim_play, DRAG_TIMEOUT,
        anim_st)

    return ECORE_CALLBACK_CANCEL

def gl_obj_mouse_up(obj, event_info, data):
    # Cancel any drag waiting to start on timeout
    anim_st_free(data)

def gl_obj_mouse_move(obj, event_info, data):
    # Cancel any drag waiting to start on timeout
    if event_info.event_flags & EVAS_EVENT_FLAG_ON_HOLD:
        print("event on hold")
        anim_st_free(data)

def gl_obj_mouse_down(obj, event_info, data):
    # Launch a timer to start drag animation
    anim_st = DragAnimSt()
    anim_st.e = obj.evas
    anim_st.mdx = event_info.position.canvas.x
    anim_st.mdy = event_info.position.canvas.y
    anim_st.gl = data
    anim_st.tm = Timer(DRAG_TIMEOUT, gl_anim_start, anim_st)
    data.event_callback_add(EVAS_CALLBACK_MOUSE_UP,
            gl_obj_mouse_up, anim_st)
    data.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE,
            gl_obj_mouse_move, anim_st)
    # END   - Handling drag start animation

def gl_dragdone(obj, doaccept, data):
    if doaccept:
        # Remove items dragged out (accepted by target)
        for it in data:
            it.delete()

def gl_createicon(win, xoff, yoff, data):
    print("in gl_createicon")
    it = data
    o = it.part_content_get("elm.swallow.icon")

    if o is None:
        return

    w = h = 30

    f, g = o.file

    xm, ym = o.evas.pointer_canvas_xy

    if xoff is not None:
        xoff = xm - (w/2)
    if yoff is not None:
        yoff = ym - (h/2)

    icon = Icon(win, file=(f, g), size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)

    if (xoff is not None) and (yoff is not None):
        icon.move(xoff, yoff)
    icon.resize(w, h)

    return icon, xoff, yoff

def gl_icons_get(gl):
    # Start icons animation before actually drag-starts

    icons = []

    xm, ym = gl.evas.pointer_canvas_xy
    items = list(gl.selected_items)
    gli, yposret = gl.at_xy_item_get(xm, ym)

    if gli is not None:
        # Add the item mouse is over to the list if NOT seleced
        if not gli in items:
            items.append(gli)

    for it in items:
        # Now add icons to animation window
        o = it.part_content_get("elm.swallow.icon")

        if o is not None:
            f, g = o.file
            x, y, w, h = o.geometry

            ic = Icon(gl, file=(f, g), size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_BOTH, pos=(x,y), size=(w,h))

            ic.show()
            icons.append(ic)

    return icons

def gl_get_drag_data(gl, it):
    # Construct a string of dragged info, user frees returned string
    drag_data = None

    items = list(gl.selected_items)
    if it is not None:
        # Add the item mouse is over to the list if NOT seleced
        if not it in items:
            items.append(it)

    if items is not None:
        # Now we can actually compose string to send and start dragging
        drag_data = "file://"

        for it in items:
            t = it.part_text_get("elm.text")
            if t is not None:
                drag_data += "#"
                drag_data += t

        drag_data += "#"

        print("Sending <%s>" % drag_data)

    return drag_data, items

def grid_get_drag_data(gg, it):
    # Construct a string of dragged info, user frees returned string
    drag_data = None

    items = list(gg.selected_items)
    if it is not None:
        # Add the item mouse is over to the list if NOT seleced
        if not it in items:
            items.append(it)

    if items is not None:
        # Now we can actually compose string to send and start dragging

        drag_data = "file://"

        for it in items:
            t = it.part_text_get("elm.text")
            if t is not None:
                drag_data += "#"
                drag_data += t

        drag_data += "#"

        print("Sending <%s>" % drag_data)

    return drag_data, items

def gl_dnd_default_anim_data_getcb(gl, it, info):
    # This called before starting to drag, mouse-down was on it
    info.format = ELM_SEL_FORMAT_TARGETS
    info.createicon = gl_createicon
    info.createdata = it
    info.icons = gl_icons_get(gl)
    info.dragdone = gl_dragdone

    # Now, collect data to send for drop from ALL selected items
    # Save list pointer to remove items after drop and free list on done
    info.data, info.donecbdata = gl_get_drag_data(gl, it)
    info.acceptdata = info.donecbdata

    if info.data is not None:
        return True
    else:
        return False

def gl_dnd_user_anim_data_getcb(gl, it, info):
    # This called before starting to drag, mouse-down was on it
    info.format = ELM_SEL_FORMAT_TARGETS
    info.createicon = gl_createicon
    info.createdata = it
    info.dragdone = gl_dragdone

    # Now, collect data to send for drop from ALL selected items
    # Save list pointer to remove items after drop and free list on done
    info.data, info.donecbdata = gl_get_drag_data(gl, it)
    info.acceptdata = info.donecbdata

    if info.data is not None:
        return True
    else:
        return False

def grid_icons_get(grid):
    # Start icons animation before actually drag-starts

    xposret, yposret = 0, 0
    icons = []

    xm, ym = grid.evas.pointer_canvas_xy
    items = list(grid.selected_items)

    gli, xposret, yposret = grid.at_xy_item_get(xm, ym)
    if gli is not None:
        # Add the item mouse is over to the list if NOT seleced
        if not gli in items:
            items.append(gli)

    for gli in items:
        # Now add icons to animation window
        o = gli.part_content_get("elm.swallow.icon")

        if o is not None:
            ic = Icon(grid, file=o.file, pos=o.pos, size=o.size,
                size_hint_align=FILL_BOTH, size_hint_weight=EXPAND_BOTH)
            ic.show()
            icons.append(ic)

    return icons

def grid_data_getcb(grid, it, info):
    # This called before starting to drag, mouse-down was on it
    info.format = ELM_SEL_FORMAT_TARGETS
    info.createicon = gl_createicon
    info.createdata = it
    info.icons = grid_icons_get(grid)
    info.dragdone = gl_dragdone

    # Now, collect data to send for drop from ALL selected items
    # Save list pointer to remove items after drop and free list on done
    info.data, info.donecbdata = grid_get_drag_data(grid, it)
    info.acceptdata = info.donecbdata

    if info.data:
        return True
    else:
        return False

def dnd_genlist_default_anim_clicked(obj, item=None):
    win = StandardWindow("dnd-genlist-default-anim",
        "DnD-Genlist-Default-Anim", autodel=True, size=(680, 800))

    bxx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bxx)
    bxx.show()

    for j in range(2):
        gl = Genlist(win, multi_select=True, size_hint_weight=EXPAND_BOTH,
            size_hint_align=FILL_BOTH)

        win.callback_delete_request_add(win_del, gl)
        gl.drop_item_container_add(ELM_SEL_FORMAT_TARGETS, gl_item_getcb,
            #poscb=gl_poscb,
            dropcb=gl_dropcb)

        gl.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT, gl_item_getcb,
            gl_dnd_default_anim_data_getcb)

        gl.mode = ELM_LIST_LIMIT
        bxx.pack_end(gl)
        gl.show()

        for i in range (20):
            gl.item_append(itc1, img[i % 9], flags=ELM_GENLIST_ITEM_NONE)

    win.show()

def dnd_genlist_user_anim_clicked(obj, item=None):
    win = StandardWindow("dnd-genlist-user-anim", "DnD-Genlist-User-Anim",
        autodel=True, size=(680,800))

    bxx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bxx)
    bxx.show()

    for j in range(2):
        gl = Genlist(win, multi_select=True, size_hint_weight=EXPAND_BOTH,
            size_hint_align=FILL_BOTH)

        win.callback_delete_request_add(win_del, gl)
        gl.drop_item_container_add(ELM_SEL_FORMAT_TARGETS, gl_item_getcb,
            dropcb=gl_dropcb)

        gl.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT, gl_item_getcb,
            gl_dnd_user_anim_data_getcb)

        # We add mouse-down, up callbacks to start/stop drag animation
        gl.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, gl_obj_mouse_down, gl)

        gl.mode = ELM_LIST_LIMIT
        bxx.pack_end(gl)
        gl.show()

        for i in range(20):
            gl.item_append(itc1, img[i % 9], flags=ELM_GENLIST_ITEM_NONE)

    win.show()

def dnd_genlist_gengrid_clicked(obj, item=None):
    win = StandardWindow("dnd-genlist-gengrid", "DnD-Genlist-Gengrid",
        autodel=True, size=(680,800))

    bxx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bxx)
    bxx.show()

    gl = Genlist(win, multi_select=True,
    size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.callback_delete_request_add(win_del, gl)

    # START Drag and Drop handling
    gl.drop_item_container_add(ELM_SEL_FORMAT_TARGETS, gl_item_getcb,
        dropcb=gl_dropcb)

    gl.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT, gl_item_getcb,
        gl_dnd_default_anim_data_getcb)
    # END Drag and Drop handling

    gl.mode = ELM_LIST_LIMIT
    bxx.pack_end(gl)
    gl.show()

    for i in range(20):
        gl.item_append(itc1, img[i % 9], flags=ELM_GENLIST_ITEM_NONE)

    grid = Gengrid(win, item_size=(conf.scale * 150, conf.scale * 150),
        horizontal=False, reorder_mode=False, multi_select=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.callback_delete_request_add(win_del, grid)

    grid.drop_item_container_add(ELM_SEL_FORMAT_TARGETS, grid_item_getcb,
        dropcb=grid_dropcb)

    grid.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT, grid_item_getcb,
        grid_data_getcb)

    for i in range(20):
        grid.item_append(gic, img[i % 9])

    bxx.pack_end(grid)
    grid.show()

    win.show()


def _drop_box_button_new_cb(obj, ev, data):
    win = data
    if ev.data is None:
        return False
    if ev.len <= 0:
        return False

    p = ev.data

    wh0rdlist = p.split("#")
    wh0rdlist.pop(0)
    wh0rdlist.pop()

    for wh0rd in wh0rdlist:
        ic = Icon(
            win, file=os.path.join(img_path, wh0rd),
            size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
        bt = Button(win, text="Dropped button")
        bt.part_content_set("icon", ic)
        obj.pack_end(bt)
        bt.show()
        ic.show()

    return True

def _enter_but_cb(obj, data):
    print("Entered _enter_but_cb - drop it here and I will never print this line anymore.")

def _drop_but_icon_change_cb(obj, ev, data):
    win = data
    if ev.data is None:
        return False
    if ev.len <= 0:
        return False

    p = ev.data

    wh0rdlist = p.split("#")
    wh0rdlist.pop(0)
    wh0rdlist.pop()

    ic = Icon(
        win, file=os.path.join(img_path, wh0rdlist[0]),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    obj.part_content_get("icon").delete()
    obj.part_content_set("icon", ic)
    ic.show()

    return True

# Callback used to test multi-callbacks feature */
def _drop_but_cb_remove_cb(obj, ev, data):
    print("Second callback called - removing it")
    obj.drop_target_del(ELM_SEL_FORMAT_TARGETS, _enter_but_cb, dropcb=_drop_but_cb_remove_cb)
    return True

def _drop_bg_change_cb(obj, ev, data):
    if ev.data is None:
        return False
    if ev.len <= 0:
        return False

    p = ev.data

    wh0rdlist = p.split("#")
    wh0rdlist.pop(0)
    wh0rdlist.pop()

    obj.file = os.path.join(img_path, wh0rdlist[0])

    return True

def _5s_cancel_ck_changed(obj, ev, data):
    _5s_cancel = obj.state


def dnd_multi_features_clicked(obj, item=None):
    win = StandardWindow("dnd-multi-features", "DnD-Multi Features",
        autodel=True, size=(680,800))

    bg = Background(win, size_hint_weight=EXPAND_BOTH)
    bg.drop_target_add(ELM_SEL_FORMAT_TARGETS, dropcb=_drop_bg_change_cb)
    win.resize_object_add(bg)
    bg.show()

    bxx = Box(win, horizontal=True, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bxx)
    bxx.show()

    grid = Gengrid(
        bxx, horizontal=True, reorder_mode=False, multi_select=True,
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        item_size=(SCALE * 100, SCALE * 100))
    win.callback_delete_request_add(win_del, grid)

    gic = DndGengridItemClass()

    grid.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT, grid_item_getcb, grid_data_getcb)
    for i in range(10):
         grid.item_append(gic, img[i % 9])
    bxx.pack_end(grid)
    grid.show()



    vert_box = Box(bxx, size_hint_weight=EXPAND_BOTH)
    bxx.pack_end(vert_box)
    vert_box.show()
    vert_box.drop_target_add(ELM_SEL_FORMAT_TARGETS, dropcb=_drop_box_button_new_cb, dropdata=win)

    _5s_cancel = False
    ck = Check(vert_box, style="toggle", text="Cancel after 5s:", state=_5s_cancel)
    ck.callback_changed_add(_5s_cancel_ck_changed)
    vert_box.pack_end(ck)
    ck.show()

    ic = Icon(
        win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    bt = Button(win, text="Multi-callbacks check")
    bt.drop_target_add(ELM_SEL_FORMAT_TARGETS, dropcb=_drop_but_icon_change_cb, dropdata=win)
    bt.drop_target_add(ELM_SEL_FORMAT_TARGETS, _enter_but_cb, dropcb=_drop_but_cb_remove_cb)
    bt.part_content_set("icon", ic)
    vert_box.pack_end(bt)
    bt.show()
    ic.show()

    ic = Icon(
        win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    bt = Button(win, text="Drop into me to change my icon")
    bt.drop_target_add(ELM_SEL_FORMAT_TARGETS, dropcb=_drop_but_icon_change_cb, dropdata=win)
    bt.part_content_set("icon", ic)
    vert_box.pack_end(bt)
    bt.show()
    ic.show()

    ic = Icon(
        win, file=os.path.join(img_path, "logo_small.png"),
        size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))
    bt = Button(win, text="No action on drop")
    bt.part_content_set("icon", ic)
    vert_box.pack_end(bt)
    bt.show()
    ic.show()

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

    items = [
        ("DnD Genlist Default Anim", dnd_genlist_default_anim_clicked),
        ("DnD Genlist User Anim", dnd_genlist_user_anim_clicked),
        ("DnD Genlist+Gengrid", dnd_genlist_gengrid_clicked),
        ("DnD-Multi Features", dnd_multi_features_clicked),
        ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
