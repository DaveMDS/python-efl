#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EVAS_ASPECT_CONTROL_VERTICAL, EXPAND_BOTH, FILL_BOTH
from efl import elementary
from efl.elementary.button import Button
from efl.elementary.window import StandardWindow
from efl.elementary.image import Image
from efl.elementary.transit import Transit, ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE, \
    ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT, ELM_TRANSIT_EFFECT_FLIP_AXIS_X, \
    ELM_TRANSIT_EFFECT_FLIP_AXIS_Y, ELM_TRANSIT_TWEEN_MODE_ACCELERATE, \
    ELM_TRANSIT_TWEEN_MODE_DECELERATE, ELM_TRANSIT_TWEEN_MODE_BOUNCE, \
    TransitCustomEffect
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List


script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

class CustomEffect(TransitCustomEffect):
    def __init__(self, from_w, from_h, to_w, to_h):
        self.fr_w = from_w
        self.fr_h = from_h
        self.to_w = to_w - from_w
        self.to_h = to_h - from_h

    def transition_cb(effect, transit, progress):
        if progress < 0.5:
            h = effect.fr_h + (effect.to_h * progress * 2)
            w = effect.fr_w
        else:
            h = effect.fr_h + effect.to_h
            w = effect.fr_w + (effect.to_w * (progress - 0.5) * 2)

        for obj in transit.objects:
            obj.resize(w, h)

    def end_cb(effect, transit):
        print("Effect done")

def transit_rotation_color(obj):
    trans = Transit()
    trans.object_add(obj)
    trans.auto_reverse = True
    trans.repeat_times = 2
    trans.duration = 2.0
    trans.tween_mode = ELM_TRANSIT_TWEEN_MODE_BOUNCE
    trans.tween_mode_factor_n = [1.0, 3.0]

    # Color Effect
    trans.effect_color_add(100, 255, 100, 255, 50, 30, 50, 50)

    # Rotation Effect
    trans.effect_rotation_add(0.0, 190.0)

    trans.go()

def transit_wipe(obj):
    trans = Transit()
    trans.object_add(obj)
    trans.auto_reverse = True

    trans.effect_wipe_add(ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE,
                          ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT)

    trans.duration = 2.0
    trans.go_in(3.0)

def transit_del_cb(transit, *args, **kwargs):
    obj = args[0]
    obj.freeze_events = False

def transit_image_animation(obj, data):
    ic = data

    images = [
        os.path.join(img_path, "icon_19.png"),
        os.path.join(img_path, "icon_00.png"),
        os.path.join(img_path, "icon_11.png"),
        os.path.join(img_path, "logo_small.png")
    ]

    trans = Transit()
    trans.del_cb_set(transit_del_cb, obj)
    trans.object_add(ic)
    trans.effect_image_animation_add(images)
    trans.duration = 5.0
    trans.go()

    obj.freeze_events = True

def transit_resizing(obj):
    trans = Transit()
    trans.object_add(obj)

    trans.effect_resizing_add(100, 50, 300, 150)

    trans.duration = 5.0
    trans.go()

def transit_flip(obj, data):
    obj2 = data

    trans = Transit()
    trans.object_add(obj)
    trans.object_add(obj2)

    trans.effect_flip_add(ELM_TRANSIT_EFFECT_FLIP_AXIS_X, True)

    trans.duration = 5.0
    trans.go()

def transit_zoom(obj):
    trans = Transit()
    trans.object_add(obj)

    trans.effect_zoom_add(1.0, 3.0)

    trans.duration = 5.0
    trans.go()

def transit_blend(obj, data):
    obj2 = data

    trans = Transit()
    trans.object_add(obj)
    trans.object_add(obj2)

    trans.effect_blend_add()

    trans.duration = 5.0
    trans.go()

def transit_fade(obj, data):
    obj2 = data

    trans = Transit()
    trans.object_add(obj)
    trans.object_add(obj2)

    trans.effect_fade_add()

    trans.duration = 5.0
    trans.go()

def transit_resizable_flip(obj, data):
    obj2 = data

    trans = Transit()
    trans.object_add(obj)
    trans.object_add(obj2)

    trans.effect_resizable_flip_add(ELM_TRANSIT_EFFECT_FLIP_AXIS_Y, True)

    trans.duration = 5.0
    trans.go()

# Translation, Rotation, Color, Wipe, ImagemAnimation Effect
def transit_clicked(obj, item=None):
    win = StandardWindow("transit", "Transit", autodel=True, size=(300,300))

    bx = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(bx)
    bx.show()

    ic = Image(win, file=os.path.join(img_path, "icon_11.png"))
    bt = Button(win, text="ImageAnimation Effect", size_hint_weight=EXPAND_BOTH)
    bt.part_content_set("icon", ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()
    bt.callback_clicked_add(transit_image_animation, ic)

    bt = Button(win, text="Rotation + Color", size_hint_weight=EXPAND_BOTH)
    bx.pack_end(bt)
    bt.show()
    bt.callback_clicked_add(transit_rotation_color)

    bt = Button(win, text="Wipe Effect (in 3 sec)", size_hint_weight=EXPAND_BOTH)
    bx.pack_end(bt)
    bt.show()
    bt.callback_clicked_add(transit_wipe)

    win.show()

# Resizing Effect
def transit2_clicked(obj, item=None):
    win = StandardWindow("transit2", "Transit 2", autodel=True, size=(400, 400))

    bt = Button(win, text="Resizing Effect", pos=(50, 100), size=(100, 50))
    bt.show()
    bt.callback_clicked_add(transit_resizing)

    win.show()

# Flip Effect
def transit3_clicked(obj, item=None):
    win = StandardWindow("transit3", "Transit 3", autodel=True, size=(300, 300))

    bt = Button(win, text="Front Button - Flip Effect", pos=(50, 50),
                size=(200, 200))
    bt.show()

    bt2 = Button(win, text="Back Button - Flip Effect", pos=(50, 50),
                 size=(200, 200))

    win.show()

    bt.callback_clicked_add(transit_flip, bt2)
    bt2.callback_clicked_add(transit_flip, bt)

# Zoom Effect
def transit4_clicked(obj, item=None):
    win = StandardWindow("transit4", "Transit 4", autodel=True, size=(300, 300))

    bt = Button(win, text="Zoom Effect", size=(100, 50), pos=(100, 125))
    bt.show()

    bt.callback_clicked_add(transit_zoom)

    win.show()

# Blend Effect
def transit5_clicked(obj, item=None):
    win = StandardWindow("transit5", "Transit 5", autodel=True, size=(300, 300))

    ic = Image(win, file=os.path.join(img_path, "rock_01.jpg"),
               size_hint_max=(50, 50))

    bt = Button(win, text="Before Button - Blend Effect", pos=(25, 125),
                size=(250, 50))
    bt.part_content_set("icon", ic)
    bt.show()

    ic = Image(win, file=os.path.join(img_path, "rock_02.jpg"),
               size_hint_max=(50, 50))

    bt2 = Button(win, text="After Button - Blend Effect", pos=(25, 125),
                 size=(250, 50))
    bt2.part_content_set("icon", ic)

    win.show()

    bt.callback_clicked_add(transit_blend, bt2)
    bt2.callback_clicked_add(transit_blend, bt)

# Fade Effect */
def transit6_clicked(obj, item=None):
    win = StandardWindow("transit6","Transit 6", autodel=True, size=(300, 300))

    ic = Image(win, file=os.path.join(img_path, "rock_01.jpg"),
               size_hint_max=(50, 50))

    bt = Button(win, text="Before Button - Fade Effect", pos=(25, 125),
                size=(250, 50))
    bt.part_content_set("icon", ic)
    bt.show()

    ic = Image(win, file=os.path.join(img_path, "rock_02.jpg"),
               size_hint_max=(50, 50))

    bt2 = Button(win, text="After Button - Fade Effect", pos=(25, 125),
                 size=(250, 50))
    bt2.part_content_set("icon", ic)

    win.show()

    bt.callback_clicked_add(transit_fade, bt2)
    bt2.callback_clicked_add(transit_fade, bt)

# Resizable Flip Effect
def transit7_clicked(obj, item=None):
    win = StandardWindow("transit7", "Transit 7", autodel=True, size=(400, 400))

    bt = Button(win, text="Front Button - Resizable Flip Effect", pos=(50, 100),
                size=(250, 30))
    bt.show()

    bt2 = Button(win, text="Back Button - Resizable Flip Effect", pos=(50, 100),
                 size=(300, 200))

    win.show()

    bt.callback_clicked_add(transit_resizable_flip, bt2)
    bt2.callback_clicked_add(transit_resizable_flip, bt)

# Custom Effect
def transit8_clicked(obj, item=None):
    win = StandardWindow("transit8", "Transit 8", autodel=True, size=(400, 400))

    bt = Button(win, text="Button - Custom Effect", pos=(50, 50),
                size=(150, 150))
    bt.show()

    # Adding Transit
    trans = Transit()
    trans.auto_reverse = True
    trans.tween_mode = ELM_TRANSIT_TWEEN_MODE_DECELERATE
    trans.object_add(bt)
    trans.effect_add(CustomEffect(150, 150, 50, 50))
    trans.duration = 5.0
    trans.repeat_times = -1
    trans.go()

    win.show()

# Chain Transit Effect
def transit9_clicked(obj, item=None):
    win = StandardWindow("transit9", "Transit 9", autodel=True, size=(400, 400))

    bt = Button(win, text="Chain 1", size=(100, 100), pos=(0, 0))
    bt.show()

    bt2 = Button(win, text="Chain 2", size=(100, 100), pos=(300, 0))
    bt2.show()

    bt3 = Button(win, text="Chain 3", size=(100, 100), pos=(300, 300))
    bt3.show()

    bt4 = Button(win, text="Chain 4", size=(100, 100), pos=(0, 300))
    bt4.show()

    trans = Transit()
    trans.tween_mode = ELM_TRANSIT_TWEEN_MODE_ACCELERATE
    trans.effect_translation_add(0, 0, 300, 0)
    trans.object_add(bt)
    trans.duration = 1
    trans.objects_final_state_keep = True
    trans.go()

    trans2 = Transit()
    trans2.tween_mode = ELM_TRANSIT_TWEEN_MODE_ACCELERATE
    trans2.effect_translation_add(0, 0, 0, 300)
    trans2.object_add(bt2)
    trans2.duration = 1
    trans2.objects_final_state_keep = True
    trans.chain_transit_add(trans2)

    trans3 = Transit()
    trans3.tween_mode = ELM_TRANSIT_TWEEN_MODE_ACCELERATE
    trans3.effect_translation_add(0, 0, -300, 0)
    trans3.object_add(bt3)
    trans3.duration = 1
    trans3.objects_final_state_keep = True
    trans2.chain_transit_add(trans3)

    trans4 = Transit()
    trans4.tween_mode = ELM_TRANSIT_TWEEN_MODE_ACCELERATE
    trans4.effect_translation_add(0, 0, 0, -300)
    trans4.object_add(bt4)
    trans4.duration = 1
    trans4.objects_final_state_keep = True
    trans3.chain_transit_add(trans4)

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
        ("Transit", transit_clicked),
        ("Transit Resize", transit2_clicked),
        ("Transit Flip", transit3_clicked),
        ("Transit Zoom", transit4_clicked),
        ("Transit Blend", transit5_clicked),
        ("Transit Fade", transit6_clicked),
        ("Transit Resizable", transit7_clicked),
        ("Transit Custom", transit8_clicked),
        ("Transit Chain", transit9_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
