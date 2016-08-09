#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import Line
from efl import elementary
from efl.elementary.button import Button
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.background import Background
from efl.elementary.image import Image
from efl.elementary.label import Label
from efl.elementary.transit import Transit, ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

SEGMENT_MAX = 200
BTN_SIZE = 50
WIN_W, WIN_H = 400, 400 + BTN_SIZE
CTRL_W, CTRL_H = 15, 15

ctrl_pt1 = None
ctrl_pt2 = None
label = None
revert_btn = None
bezier_lines = []

def clamp(minimum, x, maximum):
    return max(minimum, min(x, maximum))

def v_get():
    x, y, w, h = ctrl_pt1.geometry
    v1 = float((x - (w/2))) / WIN_W;
    v2 = 1 - float((y - (h/2))) / (WIN_H - BTN_SIZE)

    x, y, w, h = ctrl_pt2.geometry
    v3 = float((x - (w/2))) / WIN_W;
    v4 = 1 - float((y - (h/2))) / (WIN_H - BTN_SIZE)

    return (v1, v2, v3, v4)

def update_curve():
    v1, v2, v3, v4 = v_get()
    label.text = "<align=left><b>Control Points:</b></br>" \
                 "x1: %0.2f   y1: %0.2f</br>" \
                 "x2: %0.2f   y2: %0.2f</align>" % (v1, v2, v3, v4)

    prev_x, prev_y = 0, WIN_H - BTN_SIZE - 1
    for i, line in enumerate(bezier_lines):
        progress = float(i) / float((SEGMENT_MAX - 1))

        tx = (3 * progress * pow(1 - progress, 2) * v1) + \
             (3 * pow(progress, 2) * (1 - progress) * v3) + \
             (pow(progress, 3) * 1)
        ty = (3 * progress * pow((1 - progress), 2) * v2) + \
             (3 * pow(progress, 2) * (1 - progress) * v4) + \
             (pow(progress, 3) * 1)

        cur_x = int(tx * WIN_W)
        cur_y = (WIN_H - BTN_SIZE - 1) - (int(ty * (WIN_H - BTN_SIZE)))
        line.xy = prev_x, prev_y, cur_x, cur_y
        prev_x, prev_y = cur_x, cur_y

def ctrl_pt_mouse_down_cb(obj, event):
    obj.data["dragging"] = True

def ctrl_pt_mouse_up_cb(obj, event):
    obj.data["dragging"] = False

def ctrl_pt_mouse_move_cb(obj, event):
    if obj.data["dragging"]:
        x = (event.position.canvas.x - (CTRL_W/2))
        y = (event.position.canvas.y - (CTRL_H/2))
        x = clamp(-(CTRL_W/2), x, WIN_W - (CTRL_W/2))
        y = clamp(-(CTRL_H/2), y, WIN_H - (CTRL_H/2))

        obj.move(x,y)
        obj.data["line"].end = x + (CTRL_W/2), y + (CTRL_H/2)
        update_curve()

def transit_del_cb(obj):
    revert_btn.disabled = True
    for w in ctrl_pt1, ctrl_pt2, ctrl_pt1.data["line"], ctrl_pt2.data["line"]:
        w.show()

def btn_clicked_cb(btn):
    v1, v2, v3, v4 = v_get()
    transit = Transit(duration=1.0, auto_reverse=True,
                      tween_mode=ELM_TRANSIT_TWEEN_MODE_BEZIER_CURVE,
                      tween_mode_factor_n=[v1, v2, v3, v4])
    transit.object_add(btn)
    transit.effect_translation_add(0, 0, (WIN_W - BTN_SIZE), 0)
    transit.del_cb_set(transit_del_cb)
    transit.go()

    revert_btn.disabled = False
    revert_btn.data['transit'] = transit
    for w in ctrl_pt1, ctrl_pt2, ctrl_pt1.data["line"], ctrl_pt2.data["line"]:
        w.hide()

def revert_btn_clicked_cb(btn):
    transit = btn.data['transit']
    transit.revert()
    
def transit_bezier_clicked(obj, item=None):
    global ctrl_pt1, ctrl_pt2, label, bezier_lines, revert_btn

    win = Window("transit_bezier", ELM_WIN_BASIC, title="Transit Bezier",
                 autodel=True, size=(WIN_W, WIN_H))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    # BG. Fix window size
    bg = Background(win, size_hint_min=(WIN_W, WIN_H))
    win.resize_object_add(bg)
    bg.show()

    # Control Point 1
    line = Line(win.evas, anti_alias=True, pass_events=True,
                color=(0, 174, 219, 255),
                xy=(0, WIN_W, 100 + (CTRL_W/2) , 300 + (CTRL_H/2)))
    ctrl_pt1 = Image(win, file=os.path.join(img_path, "bubble.png"),
                     size=(CTRL_W,CTRL_H), pos=(100,300))
    ctrl_pt1.on_mouse_down_add(ctrl_pt_mouse_down_cb)
    ctrl_pt1.on_mouse_up_add(ctrl_pt_mouse_up_cb)
    ctrl_pt1.on_mouse_move_add(ctrl_pt_mouse_move_cb)
    ctrl_pt1.data["dragging"] = False
    ctrl_pt1.data["line"] = line
    ctrl_pt1.show()
    line.show()

    # Control Point 2
    line = Line(win.evas, anti_alias=True, pass_events=True,
                color=(219, 174, 0, 255),
                xy=(WIN_W, 0, 300 + (CTRL_W/2), 100 + (CTRL_H/2)))
    ctrl_pt2 = Image(win, file=os.path.join(img_path, "bubble.png"),
                     size=(CTRL_W,CTRL_H), pos=(300,100))
    ctrl_pt2.on_mouse_down_add(ctrl_pt_mouse_down_cb)
    ctrl_pt2.on_mouse_up_add(ctrl_pt_mouse_up_cb)
    ctrl_pt2.on_mouse_move_add(ctrl_pt_mouse_move_cb)
    ctrl_pt2.data["dragging"] = False
    ctrl_pt2.data["line"] = line
    ctrl_pt2.show()
    line.show()

    # Bezier Lines
    for i in range(SEGMENT_MAX):
        line = Line(win.evas, color=(255, 50, 50, 255), anti_alias=True,
                    pass_events=True)
        bezier_lines.append(line)
        line.show()

    # Label
    label = Label(win, size=(WIN_W, 50), pass_events=True)
    label.show()

    # Revert btn
    btn = Button(win, text="Revert", size=(70,50), pos=(100,0), disabled=True)
    btn.callback_clicked_add(revert_btn_clicked_cb)
    btn.show()
    revert_btn = btn

    # Button
    btn = Button(win, text="Go", size=(BTN_SIZE,BTN_SIZE),
                 pos=(0, WIN_H - BTN_SIZE))
    btn.callback_clicked_add(btn_clicked_cb)
    btn.show()

    update_curve()
    win.show()


if __name__ == "__main__":
    transit_bezier_clicked(None)
    elementary.run()
