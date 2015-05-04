#!/usr/bin/env python
# encoding: utf-8

import os
from random import randint

from efl.evas import SmartObject, Smart, EXPAND_BOTH, FILL_BOTH, Rectangle, \
    Line, FilledImage, Polygon, Text, SmartCbDescription
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button


script_path = os.path.dirname(os.path.abspath(__file__))
ic_file = os.path.join(script_path, "images", "logo.png")
objects = []


def random_color():
    return (randint(0, 255), randint(0, 255), randint(0, 255), 255)


class MySmart(Smart):

    @staticmethod
    def resize(smart_object, w, h):
        print("RESIZE", w, h)
        smart_object.bg.size = w, h
        smart_object.obj_text.size = w, 15
        smart_object.dragpos.size = w, 15
        smart_object.dragsize.size = 15, 15
        smart_object.dragsize.pos = smart_object.bg.pos[0] + w - 15, smart_object.bg.pos[1] + h - 15

    @staticmethod
    def move(smart_object, x, y):
        print("MOVE", x, y)
        smart_object.bg.pos = x, y
        smart_object.obj_text.pos = x, y
        smart_object.dragpos.pos = x, y
        smart_object.dragsize.pos = x + smart_object.bg.size[0] - 15, y + smart_object.bg.size[1] - 15
        smart_object.obj_rect.pos = x + 5, y + 20
        smart_object.obj_line.geometry = x + 30, y + 20, 15, 15
        smart_object.obj_image.pos = x + 30, y + 45

        smart_object.obj_poly.points_clear()
        smart_object.obj_poly.point_add(x + 5 + 0,  y + 45 + 0)
        smart_object.obj_poly.point_add(x + 5 + 15, y + 45 + 15)
        smart_object.obj_poly.point_add(x + 5 + 0,  y + 45 + 15)

    @staticmethod
    def delete(smart_object):
        print("my delete")

    @staticmethod
    def show(smart_object):
        print("my show")
        for o in smart_object:
            o.show()

    @staticmethod
    def hide(smart_object):
        print("my hide")
        for o in smart_object:
            o.hide()

    @staticmethod
    def clip_set(smart_object, o):
        pass

    @staticmethod
    def clip_unset(smart_object):
        pass

descriptions = (
    SmartCbDescription("mycb", "i"),
    )


class MySmartObj(SmartObject):

    def __init__(self, canvas, smart):
        SmartObject.__init__(self, canvas, smart)

        # gray background
        self.bg = Rectangle(canvas, color=(128, 128, 128, 128))
        self.member_add(self.bg)

        # green dragbar to move the obj
        self.dragpos = Rectangle(canvas, color=(0, 128, 0, 128))
        self.member_add(self.dragpos)
        self.dragpos.on_mouse_down_add(self.start_drag_move)
        self.dragpos.on_mouse_up_add(self.stop_drag_move)

        # blue rect to resize the obj
        self.dragsize = Rectangle(canvas, color=(0, 0, 128, 128))
        self.member_add(self.dragsize)
        self.dragsize.on_mouse_down_add(self.start_drag_resize)
        self.dragsize.on_mouse_up_add(self.stop_drag_resize)

        # testing factories
        self.obj_rect = Rectangle(canvas, size=(15, 15), color=random_color())
        self.member_add(self.obj_rect)
        self.obj_rect.on_mouse_down_add(lambda o, e: self.hide())
        self.obj_line = Line(canvas, color=random_color())
        self.member_add(self.obj_line)
        self.obj_image = FilledImage(canvas, file=ic_file, size=(20, 20))
        self.member_add(self.obj_image)
        self.obj_poly = Polygon(canvas, color=random_color())
        self.member_add(self.obj_poly)
        self.obj_text = Text(canvas, color=(0, 0, 0, 255), font="Sans",
                                  pass_events=True, text="Drag me")
        self.member_add(self.obj_text)

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
    sm = MySmart(callback_descriptions=descriptions)
    print(sm.callback_descriptions)
    so = MySmartObj(b.evas, sm)
    so.size = 100, 100
    so.pos = 100, 100
    so.show()
    objects.append(so)


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
    print(win.callback_descriptions_get())
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    box = Box(win, horizontal=True,
              size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box.show()
    win.resize_object_add(box)

    b = Button(win, text="Add one", size_hint_align=(0.0, 0.0))
    b.callback_clicked_add(btn_add_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Del last", size_hint_align=(0.0, 0.0))
    b.callback_clicked_add(btn_del_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Hide all", size_hint_align=(0.0, 0.0))
    b.callback_clicked_add(btn_hide_cb)
    box.pack_end(b)
    b.show()

    b = Button(win, text="Show all", size_hint_align=(0.0, 0.0))
    b.callback_clicked_add(btn_show_cb)
    box.pack_end(b)
    b.show()

    win.resize(320, 320)
    win.show()


if __name__ == "__main__":
    import logging
    efl_log = logging.getLogger("efl")
    efl_log_form = logging.Formatter(
        "[%(name)s] %(levelname)s in %(funcName)s:%(lineno)d - %(message)s"
        )
    efl_log_handler = logging.StreamHandler()
    efl_log_handler.setFormatter(efl_log_form)
    efl_log.addHandler(efl_log_handler)
    core_evas_smart_clicked(None)
    elementary.run()
