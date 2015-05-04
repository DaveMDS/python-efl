#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_FILL, EVAS_HINT_EXPAND, EXPAND_BOTH, FILL_BOTH, \
    EVAS_ASPECT_CONTROL_VERTICAL
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.genlist import Genlist, GenlistItemClass, \
    ELM_GENLIST_ITEM_NONE
from efl.elementary.gengrid import Gengrid, GengridItemClass
from efl.elementary.configuration import Configuration
from efl.elementary.access import Accessible
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.list import List
from efl.elementary.icon import Icon


config = Configuration()

img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "images")

def cleanup_cb(obj):
    config.access = False

class GLItC1(GenlistItemClass):
    def text_get(self, gl, part, data):
        return "Item # {0}".format(data)

    def content_get(self, gl, part, data):
        if not part == "elm.swallow.end":
            bt = Button(gl, text="OK", size_hint_align=FILL_BOTH,
                size_hint_weight=EXPAND_BOTH)
        else:
            bt = Icon(gl, file=os.path.join(img_path, "logo_small.png"),
                size_hint_aspect=(EVAS_ASPECT_CONTROL_VERTICAL, 1, 1))

        return bt

class GLItC2(GenlistItemClass):
    def content_get(self, gl, part, data):
        if part != "elm.swallow.content": return

        grid = Gengrid(gl, horizontal=False, reorder_mode=True,
            item_size=(config.scale * 100, config.scale * 100),
            size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)

        gic = GGItC(item_style="default")

        for i in range(4):
            grid.item_append(gic, i)

        #gic.free()

        scale = config.scale

        grid.size_hint_min = 300 * config.scale, 150 * config.scale

        return grid


class GGItC(GengridItemClass):
    def content_get(self, gg, part, data):
        if not part == "elm.swallow.icon":
            ic = Icon(gg, scale=0.5,
                file=os.path.join(img_path, "icon_%02i.png" % (data % 4)),
                resizable=(0, 0), size_hint_weight=EXPAND_BOTH,
                size_hint_align=(0.5, 0.5))
            ic.show()
            return ic

def _realized(obj, ei):
    if not ei: return
    item = ei

    itc = item.item_class

    if not itc.item_style == "full":
        # unregister item itself
        item.access_unregister()

        # convey highlight to its content
        content = item.part_content_get("elm.swallow.content")
        if not content: return

        items.append(content)

    else:
        bt = item.part_content_get("elm.swallow.end")
        if not bt: return

        items.append(bt)

    item.access_order = items

def access_clicked(obj, item=None):
    win = StandardWindow("access", "Access")
    win.autodel = True
    win.on_free_add(cleanup_cb)

    config.access = True

    bx = Box(win, size_hint_weight=EXPAND_BOTH, homogeneous=True,
        horizontal=True)
    win.resize_object_add(bx)
    bx.show()

    gl = Genlist(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    bx.pack_end(gl)
    gl.show()

    gl.callback_realized_add(_realized)

    itc1 = GLItC1(item_style="default")
    itc2 = GLItC2(item_style="full")

    for i in range(1,9):
        if i % 4:
            gl.item_append(itc1, i, None, ELM_GENLIST_ITEM_NONE)
        else:
            gl.item_append(itc2, i, None, ELM_GENLIST_ITEM_NONE)

    itc1.free()
    itc2.free()
    win.resize(500, 400)
    win.show()

# def access2_clicked(void *data EINA_UNUSED, Evas_Object *obj EINA_UNUSED, void *event_info EINA_UNUSED):
#     int i, j, k
#     char buf[PATH_MAX]
#     Evas_Object *win, *bx, *sc, *ly, *ly2, *ic
#     Evas_Object *ao, *to

#     win = StandardWindow("access", "Access")
#     elm_win_autodel_set(win, True)
#     evas_object_event_callback_add(win, EVAS_CALLBACK_FREE, _cleanup_cb, NULL)

#     elm_config_access_set(True)

#     sc = elm_scroller_add(win)
#     elm_scroller_bounce_set(sc, True, False)
#     elm_scroller_policy_set(sc, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF)
#     evas_object_size_hint_weight_set(sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#     elm_win_resize_object_add(win, sc)
#     evas_object_show(sc)

#     bx = Box(win)
#     evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#     evas_object_size_hint_align_set(bx, EVAS_HINT_FILL, EVAS_HINT_FILL)
#     elm_box_homogeneous_set(bx, True)
#     elm_box_horizontal_set(bx, True)
#     elm_object_content_set(sc, bx)
#     evas_object_show(bx)

#     for (k = 0 ; k < 3; k++)
#           ly = elm_layout_add(win)
#           snprintf(buf, sizeof(buf), "%s/objects/test.edj", elm_app_data_dir_get())
#           elm_layout_file_set(ly, buf, "access_page")
#           evas_object_size_hint_weight_set(ly, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#           evas_object_size_hint_align_set(ly, EVAS_HINT_FILL, EVAS_HINT_FILL)
#           evas_object_show(ly)

#           for (j = 0; j < 3; j++)
#                  for (i = 0; i < 3; i++)
#                         ly2 = elm_layout_add(win)
#                         snprintf(buf, sizeof(buf), "%s/objects/test.edj", elm_app_data_dir_get())
#                         elm_layout_file_set(ly2, buf, "access_icon")
#                         evas_object_size_hint_weight_set(ly2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#                         evas_object_size_hint_align_set(ly2, EVAS_HINT_FILL, EVAS_HINT_FILL)

#                         ic = Icon(win)
#                         elm_object_scale_set(ic, 0.5)
#                         snprintf(buf, sizeof(buf), "%s/images/icon_%02i.png", elm_app_data_dir_get(), (i + (k * 3)))
#                         elm_image_file_set(ic, buf, NULL)
#                         elm_image_resizable_set(ic, 0, 0)
#                         evas_object_size_hint_weight_set(ic, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#                         evas_object_size_hint_align_set(ic, 0.5, 0.5)
#                         elm_object_part_content_set(ly2, "slot", ic)
#                         evas_object_show(ic)

#                         snprintf(buf, sizeof(buf), "slot.%i.%i", i, j)
#                         elm_object_part_content_set(ly, buf, ly2)
#                         evas_object_show(ly2)

#                         /* access */
#                         to = (Evas_Object *)edje_object_part_object_get(elm_layout_edje_get(ly2), "access")
#                         ao = elm_access_object_register(to, ly2)
#                         elm_object_focus_custom_chain_append(ly2, ao, NULL)

#           elm_box_pack_end(bx, ly)

#     evas_object_resize(win, 300, 300)
#     evas_object_show(win)

# static Eina_Bool
# _key_down_cb(void *data, int type EINA_UNUSED, void *ei)
#     Elm_Access_Action_Info *a
#     Ecore_Event_Key *ev = ei

#     a = calloc(1, sizeof(Elm_Access_Action_Info))
#     if (!a) return ECORE_CALLBACK_PASS_ON

#     if (ev && ev->key)
#           if (!strcmp(ev->key, "F1"))
#                  a->highlight_cycle = True
#                  elm_access_action(data, ELM_ACCESS_ACTION_HIGHLIGHT_NEXT, a)
#     free(a)

#     return ECORE_CALLBACK_PASS_ON

# static char *
# _access_info_cb(void *data, Evas_Object *obj EINA_UNUSED)
#     if (data) return strdup(data)
#     return NULL

# def access3_clicked(void *data EINA_UNUSED, Evas_Object *obj EINA_UNUSED, void *event_info EINA_UNUSED):
#     char buf[PATH_MAX]
#     Evas_Object *win, *box, *lbl, *ly, *btn
#     Evas_Object *red_ao, *green_ao, *blue_ao, *black_ao, *to

#     win = StandardWindow("access", "Access")
#     elm_win_autodel_set(win, True)
#     evas_object_event_callback_add(win, EVAS_CALLBACK_FREE, _cleanup_cb, NULL)

#     elm_config_access_set(True)

#     box = Box(win)
#     evas_object_size_hint_weight_set(box, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#     elm_win_resize_object_add(win, box)
#     evas_object_show(box)

#     lbl = elm_label_add(box)
#     elm_object_text_set(lbl,
#                               "Move a mouse pointer to any object and press F1 to "
#                               "move access highlight to the next object.")
#     evas_object_size_hint_weight_set(lbl, EVAS_HINT_EXPAND, 0.0)
#     evas_object_size_hint_align_set(lbl, EVAS_HINT_FILL, EVAS_HINT_FILL)
#     elm_box_pack_end(box, lbl)
#     evas_object_show(lbl)

#     ly = elm_layout_add(box)
#     snprintf(buf, sizeof(buf), "%s/objects/test.edj", elm_app_data_dir_get())
#     elm_layout_file_set(ly, buf, "access_color_page")
#     evas_object_size_hint_weight_set(ly, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#     evas_object_size_hint_align_set(ly, EVAS_HINT_FILL, EVAS_HINT_FILL)
#     elm_box_pack_end(box, ly)
#     evas_object_show(ly)

#     btn = elm_button_add(win)
#     elm_object_text_set(btn, "action")
#     evas_object_size_hint_weight_set(btn, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND)
#     evas_object_size_hint_align_set(btn, EVAS_HINT_FILL, EVAS_HINT_FILL)
#     evas_object_show(btn)

#     elm_object_part_content_set(ly, "center", btn)

#     to = (Evas_Object *)edje_object_part_object_get(elm_layout_edje_get(ly), "red")
#     red_ao = elm_access_object_register(to, ly)
#     elm_access_info_cb_set(red_ao, ELM_ACCESS_INFO, _access_info_cb, "red")
#     elm_access_highlight_next_set(btn, ELM_HIGHLIGHT_DIR_NEXT, red_ao)

#     to = (Evas_Object *)edje_object_part_object_get(elm_layout_edje_get(ly), "green")
#     green_ao = elm_access_object_register(to, ly)
#     elm_access_info_cb_set(green_ao, ELM_ACCESS_INFO, _access_info_cb, "green")
#     elm_access_highlight_next_set(red_ao, ELM_HIGHLIGHT_DIR_NEXT, green_ao)

#     to = (Evas_Object *)edje_object_part_object_get(elm_layout_edje_get(ly), "blue")
#     blue_ao = elm_access_object_register(to, ly)
#     elm_access_info_cb_set(blue_ao, ELM_ACCESS_INFO, _access_info_cb, "blue")
#     elm_access_highlight_next_set(green_ao, ELM_HIGHLIGHT_DIR_NEXT, blue_ao)

#     to = (Evas_Object *)edje_object_part_object_get(elm_layout_edje_get(ly), "black")
#     black_ao = elm_access_object_register(to, ly)
#     elm_access_info_cb_set(black_ao, ELM_ACCESS_INFO, _access_info_cb, "black")
#     elm_access_highlight_next_set(blue_ao, ELM_HIGHLIGHT_DIR_NEXT, black_ao)

#     ecore_event_handler_add(ECORE_EVENT_KEY_DOWN, _key_down_cb, win)

#     evas_object_resize(win, 300, 300)
#     evas_object_show(win)

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
        ("Access 1", access_clicked),
        #("Access 2", access2_clicked),
        #("Access 3", accesst3_clicked),
    ]

    li = List(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    box0.pack_end(li)
    li.show()

    for item in items:
        li.item_append(item[0], callback=item[1])

    li.go()

    win.show()
    elementary.run()
