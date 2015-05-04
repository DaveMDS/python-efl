#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import Image, Map, EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.slider import Slider


img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")
ic_file = os.path.join(img_path, "rock_02.jpg")

class Point(object):
    def __init__(self, x, y, z, u, v):
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v


class Side(object):
    def __init__(self, eva):
        self.obj = None
        self.points = []

        img = Image(eva)
        img.file = ic_file
        img.fill = (0, 0, 256, 256)
        img.smooth_scale = False
        img.resize(256, 256)
        img.show()
        self.obj = img


class Cube(object):
    def __init__(self, win, w, h, d):
        self.win = win
        self.sides = []

        self.rotx = 0.0
        self.roty = 0.0
        self.rotz = 0.0
        self.cxo = 0.0
        self.cyo = 0.0
        self.focv = 256.0
        self.z0v = 0.0

        for i in range(6):
            self.sides.append(Side(win.evas))

        w -= (w / 2)
        h -= (h / 2)
        d -= (d / 2)

        self.sides[0].points.append(Point(-w, -h, -d,   0,   0))
        self.sides[0].points.append(Point( w, -h, -d, 256,   0))
        self.sides[0].points.append(Point( w,  h, -d, 256, 256))
        self.sides[0].points.append(Point(-w,  h, -d,   0, 256))

        self.sides[1].points.append(Point( w, -h, -d,   0,   0))
        self.sides[1].points.append(Point( w, -h,  d, 256,   0))
        self.sides[1].points.append(Point( w,  h,  d, 256, 256))
        self.sides[1].points.append(Point( w,  h, -d,   0, 256))

        self.sides[2].points.append(Point( w, -h,  d,   0,   0))
        self.sides[2].points.append(Point(-w, -h,  d, 256,   0))
        self.sides[2].points.append(Point(-w,  h,  d, 256, 256))
        self.sides[2].points.append(Point( w,  h,  d,   0, 256))

        self.sides[3].points.append(Point(-w, -h,  d,   0,   0))
        self.sides[3].points.append(Point(-w, -h, -d, 256,   0))
        self.sides[3].points.append(Point(-w,  h, -d, 256, 256))
        self.sides[3].points.append(Point(-w,  h,  d,   0, 256))

        self.sides[4].points.append(Point(-w, -h,  d,   0,   0))
        self.sides[4].points.append(Point( w, -h,  d, 256,   0))
        self.sides[4].points.append(Point( w, -h, -d, 256, 256))
        self.sides[4].points.append(Point(-w, -h, -d,   0, 256))

        self.sides[5].points.append(Point(-w,  h, -d,   0,   0))
        self.sides[5].points.append(Point( w,  h, -d, 256,   0))
        self.sides[5].points.append(Point( w,  h,  d, 256, 256))
        self.sides[5].points.append(Point(-w,  h,  d,   0, 256))

    def update(self):
        (x, y, w, h) = self.win.geometry

        x = w / 2
        y = h / 2
        z = 512
        dx = self.rotx
        dy = self.roty
        dz = self.rotz
        cx = (w / 2) + self.cxo
        cy = (h / 2) + self.cyo
        foc = self.z0v
        z0 = self.focv

        m = Map(4)
        m.smooth = True

        for i in range(6):
            for j in range(4):
                m.point_coord_set(j, self.sides[i].points[j].x + x,
                                     self.sides[i].points[j].y + y,
                                     self.sides[i].points[j].z + z)
                m.point_image_uv_set(j, self.sides[i].points[j].u,
                                        self.sides[i].points[j].v)
                m.point_color_set(j, 255, 255, 255, 255)

            m.util_3d_rotate(dx, dy, dz, x, y, z)
            m.util_3d_lighting(-1000, -1000, -1000,
                               255, 255, 255,
                               20, 20, 20)
            m.util_3d_perspective(cx, cy, foc, z0)

            if m.util_clockwise:
                self.sides[i].obj.map_enabled = True
                self.sides[i].obj.map = m
                self.sides[i].obj.show()
            else:
                self.sides[i].obj.hide()

        m.delete()


def ch_rot_x(sl, cube):
    cube.rotx = sl.value
    cube.update()

def ch_rot_y(sl, cube):
    cube.roty = sl.value
    cube.update()

def ch_rot_z(sl, cube):
    cube.rotz = sl.value
    cube.update()

def ch_cx(sl, cube):
    cube.cxo = sl.value
    cube.update()

def ch_cy(sl, cube):
    cube.cyo = sl.value
    cube.update()

def ch_foc(sl, cube):
    cube.focv = sl.value
    cube.update()

def ch_z0(sl, cube):
    cube.z0v = sl.value
    cube.update()

def evas3d_clicked(obj, item=None):
    win = StandardWindow("evas3d", "Evas 3d test")
    win.autodel_set(True)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    cube = Cube(win, 240, 240, 240)

    vbox = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    sl = Slider(win, text="Rot X", unit_format="%1.0f units", span_size=360,
        min_max=(0, 360), size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_rot_x, cube)
    sl.show()

    sl = Slider(win, text="Rot Y", unit_format="%1.0f units", span_size=360,
        min_max=(0, 360), size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_rot_y, cube)
    sl.show()

    sl = Slider(win, text="Rot Z", unit_format="%1.0f units", span_size=360,
        min_max=(0, 360), size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_rot_z, cube)
    sl.show()

    sl = Slider(win, text="CX Off", unit_format="%1.0f units", span_size=360,
        min_max=(-320, 320), value=cube.cxo, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_cx, cube)
    sl.show()

    sl = Slider(win, text="CY Off", unit_format="%1.0f units", span_size=360,
        min_max=(-320, 320), value=cube.cyo, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_cy, cube)
    sl.show()

    sl = Slider(win, text="Foc", unit_format="%1.0f units", span_size=360,
        min_max=(1, 2000), value=cube.focv, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_foc, cube)
    sl.show()

    sl = Slider(win, text="Z0", unit_format="%1.0f units", span_size=360,
        min_max=(-2000, 2000), value=cube.z0v, size_hint_align=FILL_HORIZ,
        size_hint_weight=EXPAND_BOTH)
    vbox.pack_end(sl)
    sl.callback_changed_add(ch_z0, cube)
    sl.show()

    win.resize(480, 480)
    cube.update()
    win.show()


if __name__ == "__main__":

    evas3d_clicked(None)

    elementary.run()

