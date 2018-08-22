#!/usr/bin/env python
# encoding: utf-8

import platform
import logging
elog = logging.getLogger("efl")
elog.setLevel(logging.INFO)

elog_form = logging.Formatter(
    "[%(name)s] %(levelname)s in %(funcName)s:%(lineno)d - %(message)s"
    )
elog_hdlr = logging.StreamHandler()
elog_hdlr.setFormatter(elog_form)

elog.addHandler(elog_hdlr)

eolog = logging.getLogger("efl.eo")
eolog.setLevel(logging.INFO)

evaslog = logging.getLogger("efl.evas")
evaslog.setLevel(logging.INFO)

elmlog = logging.getLogger("efl.elementary")
elmlog.setLevel(logging.INFO)

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, EXPAND_BOTH, FILL_BOTH
from efl import elementary, __version__
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box, ELM_BOX_LAYOUT_FLOW_HORIZONTAL
from efl.elementary.button import Button
from efl.elementary.frame import Frame
from efl.elementary.label import Label
from efl.elementary.check import Check
from efl.elementary.entry import Entry
from efl.elementary.scroller import Scroller

from efl.elementary.configuration import Configuration
elm_conf = Configuration()

elog.setLevel(logging.DEBUG)


items = [
    ("Core Libs", [
        ("Ecore Events In Elm", "test_core_ecore_events_in_elm",
         "core_ecore_events_in_elm_clicked"),
        ("Evas Objects", "test_core_evas_objects", "core_evas_objects_clicked"),
        ("Evas Canvas Callbacks", "test_core_evas_canvas_callbacks",
         "core_evas_canvas_callbacks_clicked"),
        ("Evas Object Callbacks", "test_core_evas_object_callbacks",
         "core_evas_object_callbacks_clicked"),
        ("Evas Textgrid", "test_evas_textgrid", "evas_textgrid_clicked"),
        ("Evas Smart Object","test_core_evas_smart","core_evas_smart_clicked"),
    ]),
    ("3D", [
        ("Evas Map 3D", "test_3d", "evas3d_clicked"),
    ]),
    ("Booleans", [
        ("Check", "test_check", "check_clicked"),
        #TODO: ("Toggle", "test_check", "toggle_clicked"),
    ]),
    ("Boundaries", [
        ("Bubble", "test_bubble", "bubble_clicked"),
        ("Separator", "test_separator", "separator_clicked"),
    ]),
    ("Buttons", [
        ("Button", "test_button", "buttons_clicked"),
    ]),
    ("Containers", [
        ("Box Horiz", "test_box", "box_horiz_clicked"),
        ("Box Vert", "test_box", "box_vert_clicked"),
        ("Box Vert2", "test_box", "box_vert2_clicked"),
        ("Box Layout", "test_box", "box_layout_clicked"),
        ("Box Layout Transition", "test_box", "box_transition_clicked"),
        ("Frame", "test_frame", "frame_clicked"),
        ("Grid", "test_grid", "grid_clicked"),
        ("Layout", "test_layout", "layout_clicked"),
        ("Table", "test_table", "table_clicked"),
        ("Table Homogeneous", "test_table", "table2_clicked"),
        ("Table Repack", "test_table", "table3_clicked"),
        ("Table Repack 2", "test_table", "table4_clicked"),
        ("Table Percent", "test_table", "table5_clicked"),
        ("Table Multi", "test_table", "table6_clicked"),
        ("Table Multi 2", "test_table", "table7_clicked"),
        ("Table Padding", "test_table", "table8_clicked"),
    ]),
    ("Cursors", [
        ("Cursor", "test_cursor", "cursor_clicked"),
        ("Cursor2", "test_cursor", "cursor2_clicked"),
        ("Cursor3", "test_cursor", "cursor3_clicked"),
    ]),
    ("Dividers", [
        ("Panel", "test_panel", "panel_clicked"),
        ("Panel Scrollable", "test_panel_scroll", "panel_scroll_clicked"),
        ("Panes", "test_panes", "panes_clicked"),
    ]),
    # ("Drag & Drop", [
    #     (
    #         "Genlist DnD Default Anim",
    #         "test_dnd",
    #         "dnd_genlist_default_anim_clicked"
    #         ),
    #     (
    #         "Genlist DnD User Anim",
    #         "test_dnd",
    #         "dnd_genlist_user_anim_clicked"
    #         ),
    #     (
    #         "Genlist + Gengrid DnD",
    #         "test_dnd",
    #         "dnd_genlist_gengrid_clicked"
    #         ),
    # ]),
    ("Edje External", [
        ("Ext Button", "test_external", "edje_external_button_clicked"),
        ("Ext ProgressBar", "test_external", "edje_external_pbar_clicked"),
        ("Ext Scroller", "test_external", "edje_external_scroller_clicked"),
        ("Ext Slider", "test_external", "edje_external_slider_clicked"),
        ("Ext Video", "test_external", "edje_external_video_clicked"),
        ("Ext Icon", "test_external", "edje_external_icon_clicked"),
    ]),
    ("Effects", [
        ("Flip", "test_flip", "flip_clicked"),
        ("Flip Interactive", "test_flip", "flip_interactive_clicked"),
        ("Transit", "test_transit", "transit_clicked"),
        ("Transit Resize", "test_transit", "transit2_clicked"),
        ("Transit Flip", "test_transit", "transit3_clicked"),
        ("Transit Zoom", "test_transit", "transit4_clicked"),
        ("Transit Blend", "test_transit", "transit5_clicked"),
        ("Transit Fade", "test_transit", "transit6_clicked"),
        ("Transit Resizable", "test_transit", "transit7_clicked"),
        ("Transit Custom", "test_transit", "transit8_clicked"),
        ("Transit Chain", "test_transit", "transit9_clicked"),
        ("Transit Bezier", "test_transit_bezier", "transit_bezier_clicked"),
    ]),
    ("Entries", [
        ("Entry", "test_entry", "entry_clicked"),
        ("Entry Scrolled", "test_entry", "entry_scrolled_clicked"),
        ("Entry Anchor", "test_entry", "entry_anchor_clicked"),
        ("Entry Notepad", "test_entry", "entry_notepad_clicked"),
        ("MultiButtonEntry","test_multibuttonentry","multibuttonentry_clicked"),
    ]),
    ("Focus", [
        ("Focus", "test_focus", "focus_clicked"),
        ("Focus 2", "test_focus", "focus2_clicked"),
        ("Focus 3", "test_focus", "focus3_clicked"),
        ("Focus 4", "test_focus", "focus4_clicked"),
        ("Focus Custom", "test_focus", "focus5_clicked"),
        ("Focus Move Policy", "test_focus", "focus6_clicked"),
    ]),
    ("Geographic", [
        ("Map", "test_map", "map_clicked"),
    ]),
    ("Images", [
        ("Icon", "test_icon", "icon_clicked"),
        ("Icon Transparent", "test_icon", "icon_transparent_clicked"),
        ("Icon Standard", "test_icon", "icon_standard_clicked"),
        ("Image", "test_image", "test_image"),
        ("Image with memfile", "test_image_memfile", "test_image_memfile"),
        ("Image async load", "test_image_async", "test_image_async"),
        ("Photo", "test_photo", "photo_clicked"),
        ("Photocam", "test_photocam", "photocam_clicked"),
        ("Slideshow", "test_slideshow", "slideshow_clicked"),
        ("Thumb", "test_thumb", "thumb_clicked"),
        ("Video", "test_video", "video_clicked"),
    ]),
    ("Input", [
        ("Input events", "test_input_events", "elm_input_events_clicked"),
        ("Gesture Layer", "test_gesture_layer", "gesture_layer_clicked"),
    ]),
    ("Lists - Gengrid", [
        ("Gengrid", "test_gengrid", "gengrid_clicked"),
    ]),
    ("Lists - Genlist", [
        ("Genlist 1", "test_genlist_1", "test_genlist_1"),
        ("Genlist 2", "test_genlist_2", "test_genlist_2"),
        ("Genlist Multi Select", "test_genlist_multiselect", "test_genlist_multiselect"),
        ("Genlist Tree", "test_genlist_tree", "test_genlist_tree"),
        ("Genlist Group", "test_genlist_group", "test_genlist_group"),
        ("Genlist Filter", "test_genlist_filter", "test_genlist_filter"),
        ("Genlist Sorted", "test_genlist_sorted", "test_genlist_sorted"),
        ("Genlist Iteration", "test_genlist_iteration", "test_genlist_iteration"),
        ("Genlist Decorate Item Mode", "test_genlist_decorate", "test_genlist_decorate"),
        ("Genlist Decorate All Mode", "test_genlist_decorate_all", "test_genlist_decorate_all"),
        ("Genlist Search by Text", "test_genlist_search", "test_genlist_search"),
        ("Genlist Reorder Mode", "test_genlist_reorder", "test_genlist_reorder"),
        ("Genlist Reusable Contents", "test_genlist_reusable", "test_genlist_reusable"),
    ]),
    ("Lists - List", [
        ("List", "test_list", "list_clicked"),
        ("List 2", "test_list", "list2_clicked"),
        ("List 3", "test_list", "list3_clicked"),
    ]),
    ("Miscellaneous", [
        # ("Accessibility", "test_access", "access_clicked"),
        # ("Accessibility 2", "test_access", "access2_clicked"),
        # ("Accessibility 3", "test_access", "access3_clicked"),
        ("Configuration", "test_config", "config_clicked"),
        ("Copy And Paste", "test_cnp", "cnp_clicked"),
        ("Floating Objects", "test_floating", "floating_clicked"),
        ("Themes", "test_theme", "theme_clicked"),
    ]),
    ("Naviframe", [
        ("Naviframe", "test_naviframe", "test_naviframe"),
    ]),
    ("Popups", [
        ("Ctxpopup", "test_ctxpopup", "ctxpopup_clicked"),
        ("Hover", "test_hover", "hover_clicked"),
        ("Hover 2", "test_hover", "hover2_clicked"),
        ("Notify", "test_notify", "notify_clicked"),
        ("Popup", "test_popup", "popup_clicked"),
        ("Tooltip", "test_tooltip", "tooltip_clicked"),
    ]),
    ("Range Values", [
        ("Progressbar", "test_progressbar", "progressbar_clicked"),
        ("Slider", "test_slider", "slider_clicked"),
        ("Spinner", "test_spinner", "spinner_clicked"),
    ]),
    ("Scroller", [
        ("Scroller", "test_scroller", "scroller_clicked"),
    ]),
    ("Selectors", [
        ("Action Slider", "test_actionslider", "actionslider_clicked"),
        ("Color Selector", "test_colorselector", "colorselector_clicked"),
        ("Combobox", "test_combobox", "combobox_clicked"),
        ("Day Selector", "test_dayselector", "dayselector_clicked"),
        ("Disk Selector", "test_diskselector", "diskselector_clicked"),
        ("File Selector", "test_fileselector", "fileselector_clicked"),
        ("Fileselector button", "test_fileselector_button",
         "fileselector_button_clicked"),
        ("Fileselector entry", "test_fileselector_entry",
         "fileselector_entry_clicked"),
        ("Flip Selector", "test_flipselector", "flipselector_clicked"),
        ("Hoversel", "test_hoversel", "hoversel_clicked"),
        ("Index", "test_index", "index_clicked"),
        ("Main Menu", "test_main_menu", "main_menu_clicked"),
        ("Menu", "test_menu", "menu_clicked"),
        ("Radios", "test_radio", "radio_clicked"),
        ("Segment Control", "test_segment_control", "segment_control_clicked"),
    ]),
    ("Standardization", [
        ("Conformant", "test_conform", "conformant_clicked"),
        ("Conformant 2", "test_conform", "conformant2_clicked"),
    ]),
    ("Stored Surface Buffer", [
        ("Launcher", "test_mapbuf", "mapbuf_clicked"),
    ]),
    ("System", [
        ("Notification", "test_sys_notify", "sys_notify_clicked"),
    ]),
    ("Text", [
        ("Label", "test_label", "label_clicked"),
    ]),
    ("Times & Dates", [
        ("Calendar", "test_calendar", "calendar_clicked"),
        ("Calendar 2", "test_calendar", "calendar2_clicked"),
        ("Calendar 3", "test_calendar", "calendar3_clicked"),
        ("Clock", "test_clock", "clock_clicked"),
        ("Datetime", "test_datetime", "datetime_clicked"),
    ]),
    ("Toolbars", [
        ("Toolbar", "test_toolbar", "toolbar_clicked"),
        ("Toolbar Item States", "test_toolbar", "toolbar5_clicked"),
    ]),
    ("Web", [
        ("Web", "test_web", "web_clicked"),
    ]),
    ("Window / Background", [
        ("Window Standard/Dialog", "test_win_dialog", "window_dialog_clicked"),
        ("InnerWindow", "test_inwin", "inner_window_clicked"),
        ("Window States", "test_win", "window_states_clicked"),
        ("Bg Plain", "test_bg", "bg_plain_clicked"),
        ("Bg Image", "test_bg", "bg_image_clicked"),
    ])
    ]


def selected_cb(o, mod, func):
    exec("from {0} import {1}; {1}(o)".format(mod, func))


def menu_create(search, win):
    tbx.clear()
    for category in items:
        frame = Frame(win, size_hint_weight=EXPAND_BOTH,
                      size_hint_align=FILL_BOTH, text=category[0])
        frame.show()
        tbx.pack_end(frame)

        tbx2 = Box(win, layout=ELM_BOX_LAYOUT_FLOW_HORIZONTAL,
                   size_hint_weight=(EVAS_HINT_EXPAND, 0.0),
                   size_hint_align=(EVAS_HINT_FILL, 0.0))
        frame.content_set(tbx2)
        tbx2.show()

        cnt = 0
        for test in category[1]:
            if search is None or test[0].lower().find(search.lower()) > -1:
                bt = Button(win, text=test[0])
                bt.callback_clicked_add(selected_cb, test[1], test[2])
                bt.show()
                tbx2.pack_end(bt)
                cnt += 1

        if cnt < 1:
            frame.delete()


def destroy(obj, str1, str2, str3, str4):
    elementary.exit()


def cb_mirroring(toggle):
    elm_conf.mirrored = toggle.state


def cb_filter(en, win):
    menu_create(en.text_get(), win)

if __name__ == "__main__":
    title = "Python EFL version %s (on python: %s)" % (
             __version__, platform.python_version())
    win = StandardWindow("test", title)
    win.callback_delete_request_add(destroy, "test1", "test2",
                                    str3="test3", str4="test4")

    box0 = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box0)
    box0.show()

    lb = Label(win)
    lb.text = ("Please select a test from the list below by clicking<br>"
               "the test button to show the test window.")
    lb.show()

    fr = Frame(win, text="Information", content=lb)
    box0.pack_end(fr)
    fr.show()

    tg = Check(win, style="toggle", text="UI-Mirroring:")
    tg.callback_changed_add(cb_mirroring)
    box0.pack_end(tg)
    tg.show()

    bx1 = Box(win, size_hint_weight=(EVAS_HINT_EXPAND, 0.0),
              size_hint_align=(EVAS_HINT_FILL, 0.0), horizontal=True)
    box0.pack_end(bx1)
    bx1.show()

    lb = Label(win, text="Filter:")
    bx1.pack_end(lb)
    lb.show()

    en = Entry(win, single_line=True, scrollable=True,
               size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    en.part_text_set("guide", "Type widget name here to search.")
    en.callback_changed_add(cb_filter, win)
    bx1.pack_end(en)
    en.show()
    en.focus_set(True)

    sc = Scroller(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
                  bounce=(False, True))
    sc.show()
    box0.pack_end(sc)

    tbx = Box(win, size_hint_weight=(EVAS_HINT_EXPAND, 0.0),
              size_hint_align=(EVAS_HINT_FILL, 0.0))
    sc.content_set(tbx)
    tbx.show()

    menu_create(None, win)

    win.resize(480, 480)
    win.show()
    elementary.run()
