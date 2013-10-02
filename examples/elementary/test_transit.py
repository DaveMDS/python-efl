from efl import elementary
from efl.elementary.button import Button
from efl.elementary.window import StandardWindow
from efl.elementary.image import Image
from efl.elementary.transit import Transit, ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE, \
    ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT, ELM_TRANSIT_EFFECT_FLIP_AXIS_X, \
    ELM_TRANSIT_EFFECT_FLIP_AXIS_Y, ELM_TRANSIT_TWEEN_MODE_ACCELERATE, \
    ELM_TRANSIT_TWEEN_MODE_DECELERATE
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EVAS_ASPECT_CONTROL_VERTICAL


# class Custom_Effect:
#     _size.fr.w
#     _size.fr.h
#     _size.to.w
#     _size.to.h

# def custom_op(effect, transit, progress):
#     if not effect: return
#     elist = []

#     custom_effect = effect
#     objs = transit.objects

#     if progress < 0.5:
#         h = custom_effect.fr.h + (custom_effect.to.h * progress * 2)
#         w = custom_effect.fr.w
#     else:
#         h = custom_effect.fr.h + custom_effect.to.h
#         w = custom_effect.fr.w + \
#             (custom_effect.to.w * (progress - 0.5) * 2)

#     for obj in objs:
#         obj.resize(w, h)

# def custom_context_new(Evas_Coord from_w, Evas_Coord from_h, Evas_Coord to_w, Evas_Coord to_h):
#     custom_effect = Custom_Effect()

#     custom_effect.fr.w = from_w
#     custom_effect.fr.h = from_h
#     custom_effect.to.w = to_w - from_w
#     custom_effect.to.h = to_h - from_h

#     return custom_effect

# def custom_context_free(Elm_Transit_Effect *effect, Elm_Transit *transit __UNUSED__):
#     Custom_Effect *custom_effect = effect
#     free(custom_effect)

def transit_rotation_translation_color(obj):
    trans = Transit()
    trans.object_add(obj)
    trans.auto_reverse = True
    trans.repeat_times = 2

    # Translation Effect
    trans.effect_translation_add(-70.0, -150.0, 70.0, 150.0)

    # Color Effect
    trans.effect_color_add(100, 255, 100, 255, 50, 30, 50, 50)

    # Rotation Effect
    trans.effect_rotation_add(0.0, 135.0)

    trans.duration = 5.0
    trans.go()

def transit_wipe(obj):
    trans = Transit()
    trans.object_add(obj)
    trans.auto_reverse = True

    trans.effect_wipe_add(
        ELM_TRANSIT_EFFECT_WIPE_TYPE_HIDE,
        ELM_TRANSIT_EFFECT_WIPE_DIR_RIGHT)

    trans.duration = 5.0
    trans.go()

def transit_del_cb(transit, *args, **kwargs):
    obj = args[0]
    obj.freeze_events = False

def transit_image_animation(obj, data):
    ic = data

    images = [
        "images/icon_19.png",
        "images/icon_00.png",
        "images/icon_11.png",
        "images/logo_small.png"
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
    win = StandardWindow("transit", "Transit")
    win.autodel = True

    bx = Box(win)
    bx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(bx)
    bx.size_hint_min = 318, 318
    bx.show()

    ic = Image(win)
    ic.file = "images/icon_11.png"
    ic.size_hint_aspect = EVAS_ASPECT_CONTROL_VERTICAL, 1, 1

    bt = Button(win)
    bt.text = "ImageAnimation Effect"
    bt.part_content_set("icon", ic)
    bx.pack_end(bt)
    bt.show()
    ic.show()
    bt.callback_clicked_add(transit_image_animation, ic)

    bt = Button(win)
    bt.text = "Color, Rotation and Translation"
    bx.pack_end(bt)
    bt.show()
    bt.callback_clicked_add(transit_rotation_translation_color)

    bt = Button(win)
    bt.text = "Wipe Effect"
    bx.pack_end(bt)
    bt.show()
    bt.callback_clicked_add(transit_wipe)

    win.show()

# Resizing Effect
def transit2_clicked(obj, item=None):
    win = StandardWindow("transit2", "Transit 2")
    win.autodel = True

    bt = Button(win)
    bt.text = "Resizing Effect"
    bt.show()
    bt.move(50, 100)
    bt.resize(100, 50)
    bt.callback_clicked_add(transit_resizing)

    win.resize(400, 400)
    win.show()

# Flip Effect
def transit3_clicked(obj, item=None):
    win = StandardWindow("transit3", "Transit 3")
    win.autodel = True

    bt = Button(win)
    bt.text = "Front Button - Flip Effect"
    bt.show()
    bt.move(50, 50)
    bt.resize(200, 200)

    bt2 = Button(win)
    bt2.text = "Back Button - Flip Effect"
    bt2.move(50, 50)
    bt2.resize(200, 200)

    win.resize(300, 300)
    win.show()

    bt.callback_clicked_add(transit_flip, bt2)
    bt2.callback_clicked_add(transit_flip, bt)

# Zoom Effect
def transit4_clicked(obj, item=None):
    win = StandardWindow("transit4", "Transit 4")
    win.autodel = True

    bt = Button(win)
    bt.text = "Zoom Effect"
    bt.resize(100, 50)
    bt.move(100, 125)
    bt.show()

    bt.callback_clicked_add(transit_zoom)

    win.resize(300, 300)
    win.show()

# Blend Effect
def transit5_clicked(obj, item=None):
    win = StandardWindow("transit5", "Transit 5")
    win.autodel = True

    ic = Image(win)
    ic.file = "images/rock_01.jpg"
    ic.size_hint_max = 50, 50

    bt = Button(win)
    bt.part_content_set("icon", ic)
    bt.text = "Before Button - Blend Effect"
    bt.move(25, 125)
    bt.resize(250, 50)
    bt.show()

    ic = Image(win)
    ic.file = "images/rock_02.jpg"
    ic.size_hint_max = 50, 50

    bt2 = Button(win)
    bt2.part_content_set("icon", ic)
    bt2.text = "After Button - Blend Effect"
    bt2.move(25, 125)
    bt2.resize(250, 50)

    win.resize(300, 300)
    win.show()

    bt.callback_clicked_add(transit_blend, bt2)
    bt2.callback_clicked_add(transit_blend, bt)

# Fade Effect */
def transit6_clicked(obj, item=None):
    win = StandardWindow("transit6","Transit 6")
    win.autodel = True

    ic = Image(win)
    ic.file = "images/rock_01.jpg"
    ic.size_hint_max = 50, 50

    bt = Button(win)
    bt.part_content_set("icon", ic)
    bt.text = "Before Button - Fade Effect"
    bt.move(25, 125)
    bt.resize(250, 50)
    bt.show()

    ic = Image(win)
    ic.file = "images/rock_02.jpg"
    ic.size_hint_max = 50, 50

    bt2 = Button(win)
    bt2.part_content_set("icon", ic)
    bt2.text = "After Button - Fade Effect"
    bt2.move(25, 125)
    bt2.resize(250, 50)

    win.resize(300, 300)
    win.show()

    bt.callback_clicked_add(transit_fade, bt2)
    bt2.callback_clicked_add(transit_fade, bt)

# Resizable Flip Effect
def transit7_clicked(obj, item=None):
    win = StandardWindow("transit7", "Transit 7")
    win.autodel = True

    bt = Button(win)
    bt.text = "Front Button - Resizable Flip Effect"
    bt.show()
    bt.move(50, 100)
    bt.resize(250, 30)

    bt2 = Button(win)
    bt2.text = "Back Button - Resizable Flip Effect"
    bt2.move(50, 100)
    bt2.resize(300, 200)

    win.resize(400, 400)
    win.show()

    bt.callback_clicked_add(transit_resizable_flip, bt2)
    bt2.callback_clicked_add(transit_resizable_flip, bt)

# Custom Effect
# def transit8_clicked(obj, item=None):
#     Elm_Transit_Effect *effect_context

#     win = StandardWindow("transit8", "Transit 8")
#     win.autodel = True

#     bt = Button(win)
#     bt.text = "Button - Custom Effect"
#     bt.show()
#     bt.move(50, 50)
#     bt.resize(150, 150)

#     # Adding Transit
#     trans = Transit()
#     trans.auto_reverse = True
#     trans.tween_mode = ELM_TRANSIT_TWEEN_MODE_DECELERATE
#     effect_context = _custom_context_new(150, 150, 50, 50)
#     trans.object_add(bt)
#     trans.effect_add(trans, _custom_op, effect_context, _custom_context_free)
#     trans.duration = 5.0
#     trans.repeat_times = -1
#     trans.go()

#     win.resize(400, 400)
#     win.show()

# Chain Transit Effect
def transit9_clicked(obj, item=None):
    win = StandardWindow("transit9", "Transit 9")
    win.autodel = True

    bt = Button(win)
    bt.text = "Chain 1"
    bt.resize(100, 100)
    bt.move(0, 0)
    bt.show()

    bt2 = Button(win)
    bt2.text = "Chain 2"
    bt2.resize(100, 100)
    bt2.move(300, 0)
    bt2.show()

    bt3 = Button(win)
    bt3.text = "Chain 3"
    bt3.resize(100, 100)
    bt3.move(300, 300)
    bt3.show()

    bt4 = Button(win)
    bt4.text = "Chain 4"
    bt4.resize(100, 100)
    bt4.move(0, 300)
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

    win.resize(400, 400)
    win.show()

if __name__ == "__main__":
    elementary.init()
    win = StandardWindow("test", "python-elementary test application")
    win.callback_delete_request_add(lambda o: elementary.exit())

    box0 = Box(win)
    box0.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    win.resize_object_add(box0)
    box0.show()

    fr = Frame(win)
    fr.text = "Information"
    box0.pack_end(fr)
    fr.show()

    lb = Label(win)
    lb.text_set("Please select a test from the list below<br>"
                 "by clicking the test button to show the<br>"
                 "test window.")
    fr.content = lb
    lb.show()

    items = [
        ("Transit", transit_clicked),
        ("Transit Resize", transit2_clicked),
        ("Transit Flip", transit3_clicked),
        ("Transit Zoom", transit4_clicked),
        ("Transit Blend", transit5_clicked),
        ("Transit Fade", transit6_clicked),
        ("Transit Resizable", transit7_clicked),
        #("Transit Custom", transit8_clicked),
        ("Transit Chain", transit9_clicked),
    ]

    li = List(win)
    li.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
    li.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.resize(320,520)
    win.show()
    elementary.run()
    elementary.shutdown()
