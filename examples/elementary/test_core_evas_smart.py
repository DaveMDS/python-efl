#!/usr/bin/env python
# encoding: utf-8

import os
from random import randint

from efl.evas import SmartObject, EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button


script_path = os.path.dirname(os.path.abspath(__file__))
ic_file = os.path.join(script_path, "images", "logo.png")
objects = []


def random_color():
    return (randint(0,255), randint(0,255), randint(0,255), 255)

class MySmartObj(SmartObject):
    def __init__(self, canvas):
        SmartObject.__init__(self, canvas)

        # gray background
        self.bg = self.Rectangle(color=(128,128,128,128))

        # green dragbar to move the obj
        self.dragpos = self.Rectangle(color=(0,128,0,128))
        self.dragpos.on_mouse_down_add(self.start_drag_move)
        self.dragpos.on_mouse_up_add(self.stop_drag_move)

        # blue rect to resize the obj
        self.dragsize = self.Rectangle(color=(0,0,128,128))
        self.dragsize.on_mouse_down_add(self.start_drag_resize)
        self.dragsize.on_mouse_up_add(self.stop_drag_resize)

        # testing factories
        self.obj_rect = self.Rectangle(size=(15,15), color=random_color())
        self.obj_rect.on_mouse_down_add(lambda o,e: self.hide())
        self.obj_line = self.Line(color=random_color())
        self.obj_image = self.FilledImage(file=ic_file, size=(20,20))
        self.obj_poly = self.Polygon(color=random_color())
        self.obj_text = self.Text(color=(0,0,0,255), font="Sans",
                                  pass_events=True, text="Drag me")

    def resize(self, w, h):
        print("RESIZE", w, h)
        self.bg.size = w, h
        self.obj_text.size = w, 15
        self.dragpos.size = w, 15
        self.dragsize.size = 15, 15
        self.dragsize.pos = self.bg.pos[0] + w - 15, self.bg.pos[1] + h - 15

    def move(self, x, y):
        print("MOVE", x, y)
        self.bg.pos = x, y
        self.obj_text.pos = x,y
        self.dragpos.pos = x, y
        self.dragsize.pos = x + self.bg.size[0] - 15, y + self.bg.size[1] - 15
        self.obj_rect.pos = x + 5, y + 20
        self.obj_line.geometry = x + 30, y + 20, 15, 15
        self.obj_image.pos = x + 30, y + 45

        self.obj_poly.points_clear()
        self.obj_poly.point_add(x + 5 + 0,  y + 45 + 0)
        self.obj_poly.point_add(x + 5 + 15, y + 45 + 15)
        self.obj_poly.point_add(x + 5 + 0,  y + 45 + 15)

    def delete(sef):
        print("my delete")

    def show(self):
        print("my show")
        for o in self.members:
            o.show()

    def hide(self):
        print("my hide")
        for o in self.members:
            o.hide()

    def clip_set(self, o):
        pass

    def clip_unset(self):
        pass

    # dragpos (move obj)
    def start_drag_move(self, obj, event):
        self.on_mouse_move_add(self.mouse_move_cb)

    def stop_drag_move(self, obj, event):
        self.on_mouse_move_del(self.mouse_move_cb)

    def mouse_move_cb(self, obj, event):
        x, y = event.position.canvas
        self.pos = x - self.bg.size[0] / 2, y

    # dragsize (resize obj)
    def start_drag_resize(self, obj, event):
        self.on_mouse_move_add(self.mouse_move_resize_cb)

    def stop_drag_resize(self, obj, event):
        self.on_mouse_move_del(self.mouse_move_resize_cb)

    def mouse_move_resize_cb(self, obj, event):
        x, y = event.position.canvas
        self.size = x - self.bg.pos[0], y - self.bg.pos[1]

def btn_add_cb(b):
    sm = MySmartObj(b.evas)
    sm.size = 100, 100
    sm.pos = 100, 100
    sm.show()
    objects.append(sm)

def btn_del_cb(b):
    objects.pop().delete()

def btn_hide_cb(b):
    for o in objects:
        o.hide()

def btn_show_cb(b):
    for o in objects:
        o.show()

def core_evas_smart_clicked(obj, item=None):
    win = StandardWindow("evassmart", "Evas Smart Object Test", autodel=True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win, horizontal=True,
              size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box.show()
    win.resize_object_add(box)

    b = Button(win, text="Add one", size_hint_align=(0.0,0.0))
    b.callback_clicked_add(btn_add_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Del last", size_hint_align=(0.0,0.0))
    b.callback_clicked_add(btn_del_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Hide all", size_hint_align=(0.0,0.0))
    b.callback_clicked_add(btn_hide_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Show all", size_hint_align=(0.0,0.0))
    b.callback_clicked_add(btn_show_cb)
    box.pack_end(b)
    b.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    elementary.init()
    core_evas_smart_clicked(None)
    elementary.run()
    elementary.shutdown()

