#!/usr/bin/env python
# encoding: utf-8

import os

from efl import elementary

from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.transit import Transit
from efl.elementary.gesture_layer import GestureLayer, ELM_GESTURE_ZOOM, \
    ELM_GESTURE_MOMENTUM, ELM_GESTURE_ROTATE, ELM_GESTURE_STATE_MOVE, \
    ELM_GESTURE_STATE_END, ELM_GESTURE_STATE_ABORT, ELM_GESTURE_STATE_START
from efl.elementary.background import Background
from efl.elementary.layout import Layout
from efl.elementary.entry import Entry, ELM_WRAP_MIXED
from efl.elementary.icon import Icon

from efl.evas import EVAS_HINT_EXPAND, EXPAND_BOTH, FILL_BOTH, \
    EVAS_EVENT_FLAG_NONE, Map, Polygon


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

#We zoom out to this value so we'll be able to use map and have a nice
#resolution when zooming in.
BASE_ZOOM = 0.5
#The amount of zoom to do when "lifting" objects.
LIFT_FACTOR = 1.3
#The base size of the shadow image.
SHADOW_W = 118
SHADOW_H = 118

zoom_out_animation_duration = 0.4

class Photo_Object(object):
    ic = None
    shadow = None
    hit = None
    gl = None
    zoom_out = None
    # bx, by - current wanted coordinates of the photo object.
    # bw, bh - original size of the "ic" object.
    # dx, dy - Used to indicate the distance between the center point
    #   where we put down our fingers (when started moving the item) to
    #   the coords of the object, so we'll be able to calculate movement
    #   correctly.
    bx, by, bw, bh, dx, dy = None, None, None, None, None, None
    # Because gesture layer only knows the amount of rotation/zoom we do
    # per gesture, we have to keep the current rotate/zoom factor and the
    # one that was before we started the gesture.
    base_rotate, rotate = None, None
    base_zoom, zoom = None, None
    shadow_zoom = None

def apply_changes(po):
    """
    This function applies the information from the Photo_Object to the actual
    evas objects. Zoom/rotate factors and etc.
    """

    map = Map(4)
    map.point_coord_set(0, po.bx, po.by, 0)
    map.point_coord_set(1, po.bx + po.bw, po.by, 0)
    map.point_coord_set(2, po.bx + po.bw, po.by + po.bh, 0)
    map.point_coord_set(3, po.bx, po.by + po.bh, 0)
    map.point_image_uv_set(0, 0, 0)
    map.point_image_uv_set(1, po.bw, 0)
    map.point_image_uv_set(2, po.bw, po.bh)
    map.point_image_uv_set(3, 0, po.bh)
    map.util_rotate(po.rotate, po.bx + po.bw / 2, po.by + po.bh /2)
    map.util_zoom(po.zoom, po.zoom, po.bx + po.bw / 2, po.by + po.bh /2)
    po.ic.map_enabled = True
    po.ic.map = map

    shadow_map = Map(4)
    shadow_map.point_coord_set(0, po.bx, po.by, 0)
    shadow_map.point_coord_set(1, po.bx + po.bw, po.by, 0)
    shadow_map.point_coord_set(2, po.bx + po.bw, po.by + po.bh, 0)
    shadow_map.point_coord_set(3, po.bx, po.by + po.bh, 0)
    shadow_map.point_image_uv_set(0, 0, 0)
    shadow_map.point_image_uv_set(1, SHADOW_W, 0)
    shadow_map.point_image_uv_set(2, SHADOW_W, SHADOW_H)
    shadow_map.point_image_uv_set(3, 0, SHADOW_H)
    shadow_map.util_rotate(po.rotate, po.bx + po.bw / 2, po.by + po.bh /2)
    shadow_map.util_zoom(po.zoom * po.shadow_zoom,
          po.zoom * po.shadow_zoom,
          po.bx + (po.bw / 2), po.by + (po.bh / 2))
    po.shadow.map_enabled = True
    po.shadow.map = shadow_map
    #evas_map_free(shadow_map);

    # Update the position of the hit box
    po.hit.points_clear()
    minx, miny, minz = map.point_coord_get(0)
    maxx = minx
    maxy = miny
    po.hit.point_add(minx, miny)
    for i in range(1, 3):
        x, y, z = map.point_coord_get(i)
        po.hit.point_add(x, y)
        if x < minx:
            minx = x
        elif x > maxx:
            maxx = x

        if y < miny:
            miny = y
        elif y > maxy:
            maxy = y

    po.shadow.raise_()
    po.ic.raise_()
    po.hit.raise_()
    #evas_map_free(map);

def zoom_out_animation_operation(transit, *args, **kwargs):
    """Zoom out animation"""
    po, progress = args
    po.zoom = BASE_ZOOM + ((po.base_zoom - BASE_ZOOM) * (1.0 - progress))
    apply_changes(po)

def zoom_out_animation_end(transit, *args, **kwargs):
    po = args[0]

    po.base_zoom = po.zoom = BASE_ZOOM
    apply_changes(po)

    po.zoom_out = None

def rotate_move(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("rotate move <%d,%d> base=<%f> <%f>" % (p.x, p.y, p.base_angle, p.angle))
    po.rotate = po.base_rotate + p.angle - p.base_angle
    if po.rotate < 0:
        po.rotate += 360
    apply_changes(po)
    return EVAS_EVENT_FLAG_NONE

def rotate_end(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("rotate end/abort <%d,%d> base=<%f> <%f>" % (p.x, p.y, p.base_angle, p.angle))
    po.base_rotate += p.angle - p.base_angle
    if po.rotate < 0:
        po.rotate += 360
    return EVAS_EVENT_FLAG_NONE

def zoom_start(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("zoom start <%d,%d> <%f>" % (p.x, p.y, p.zoom))

    # If there's an active animator, stop it
    if po.zoom_out:
        elm_transit_del(po.zoom_out)
        po.zoom_out = None

    # Give it a "lift" effect right from the start
    po.base_zoom = BASE_ZOOM * LIFT_FACTOR
    po.zoom = po.base_zoom
    po.shadow_zoom = 1.7

    apply_changes(po)
    return EVAS_EVENT_FLAG_NONE

def zoom_move(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("zoom move <%d,%d> <%f>" % (p.x, p.y, p.zoom))
    po.zoom = po.base_zoom * p.zoom
    apply_changes(po)
    return EVAS_EVENT_FLAG_NONE

def zoom_end(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("zoom end/abort <%d,%d> <%f>" % (p.x, p.y, p.zoom))

    # Apply the zoom out animator
    po.shadow_zoom = 1.3
    po.base_zoom = po.zoom
    po.zoom_out = Transit()
    po.zoom_out.duration = zoom_out_animation_duration
    po.zoom_out.effect_add(zoom_out_animation_operation, po, zoom_out_animation_end)
    po.zoom_out.go()
    return EVAS_EVENT_FLAG_NONE

def momentum_start(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("momentum_start <%d,%d>" % (p.x2, p.y2))

    po.dx = p.x2 - po.bx
    po.dy = p.y2 - po.by
    apply_changes(po)

    return EVAS_EVENT_FLAG_NONE

def momentum_move(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("momentum move <%d,%d>" % (p.x2, p.y2))

    po.bx = p.x2 - po.dx
    po.by = p.y2 - po.dy
    apply_changes(po)

    return EVAS_EVENT_FLAG_NONE

def momentum_end(event_info, *args, **kwargs):
    po = args[0]
    p = event_info

    print("momentum end/abort <%d,%d> <%d,%d>" % (p.x2, p.y2, p.mx, p.my))
    #(void) po;
    #(void) p;

    # Make sure middle is in the screen, if not, fix it.
    # FIXME: Use actual window sizes instead of the hardcoded
    # values
    mx = po.bx + (po.bw / 2)
    my = po.by + (po.bh / 2)
    if mx < 0:
       po.bx = 0 - (po.bw / 2)
    elif mx > 480:
       po.bx = 480 - (po.bw / 2)

    if my < 0:
       po.by = 0 - (po.bw / 2)
    elif my > 800:
       po.by = 800 - (po.bh / 2)

    apply_changes(po)

    return EVAS_EVENT_FLAG_NONE

def photo_object_add(parent, ic, icon, x, y, w, h, angle):
    po = Photo_Object()
    po.base_zoom = po.zoom = BASE_ZOOM

    if ic:
        po.ic = ic
    else:
        po.ic = Icon(parent)
        po.ic.file = icon

    po.bx = x
    po.by = y
    po.bw = w
    po.bh = h

    # Add shadow
    po.shadow = Icon(po.ic, file=os.path.join(img_path, "pol_shadow.png"))
    po.shadow.size = SHADOW_W, SHADOW_H
    po.shadow.show()

    po.hit = Polygon(parent.evas)
    po.hit.precise_is_inside = True
    po.hit.repeat_events = True
    po.hit.color = 0, 0, 0, 0

    po.ic.pos = 0, 0
    po.ic.size = po.bw, po.bh
    po.ic.show()

    po.hit.show()

    po.gl = GestureLayer(po.ic, hold_events=True)
    po.gl.attach(po.hit)

    # FIXME: Add a po.rotate start so we take the first angle!!!!
    po.gl.cb_set(ELM_GESTURE_ROTATE, ELM_GESTURE_STATE_MOVE, rotate_move, po)
    po.gl.cb_set(ELM_GESTURE_ROTATE, ELM_GESTURE_STATE_END, rotate_end, po)
    po.gl.cb_set(ELM_GESTURE_ROTATE, ELM_GESTURE_STATE_ABORT, rotate_end, po)
    po.gl.cb_set(ELM_GESTURE_ZOOM, ELM_GESTURE_STATE_START, zoom_start, po)
    po.gl.cb_set(ELM_GESTURE_ZOOM, ELM_GESTURE_STATE_MOVE, zoom_move, po)
    po.gl.cb_set(ELM_GESTURE_ZOOM, ELM_GESTURE_STATE_END, zoom_end, po)
    po.gl.cb_set(ELM_GESTURE_ZOOM, ELM_GESTURE_STATE_ABORT, zoom_end, po)
    po.gl.cb_set(ELM_GESTURE_MOMENTUM, ELM_GESTURE_STATE_START, momentum_start, po)
    po.gl.cb_set(ELM_GESTURE_MOMENTUM, ELM_GESTURE_STATE_MOVE, momentum_move, po)
    po.gl.cb_set(ELM_GESTURE_MOMENTUM, ELM_GESTURE_STATE_END, momentum_end, po)
    po.gl.cb_set(ELM_GESTURE_MOMENTUM, ELM_GESTURE_STATE_ABORT, momentum_end, po)

    po.rotate = po.base_rotate = angle
    po.shadow_zoom = 1.3

    apply_changes(po)
    return po

def gesture_layer_clicked(obj):
    w = 480
    h = 800

    win = Window("gesture-layer", ELM_WIN_BASIC, title="Gesture Layer",
        autodel=True, size=(w, h))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    bg = Background(win, file=os.path.join(img_path, "wood_01.jpg"),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    photos = [photo_object_add(win, None,
                               os.path.join(img_path, "pol_sky.png"), 200, 200, 365, 400, 0),
              photo_object_add(win, None,
                               os.path.join(img_path, "pol_twofish.png"), 40, 300, 365, 400, 45)]

    en = Entry(win, line_wrap=ELM_WRAP_MIXED)
    en.text = "You can use whatever object you want, even entries like this."

    postit = Layout(win,
        file=(os.path.join(script_path, "postit_ent.edj"), "main"))
    postit.part_content_set("ent", en)

    photos.append(photo_object_add(win, postit, None, 50, 50, 382, 400, 355))

    win.show()

if __name__ == "__main__":

    gesture_layer_clicked(None)

    elementary.run()
