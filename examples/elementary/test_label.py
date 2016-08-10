#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, Rectangle, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.grid import Grid
from efl.elementary.label import Label, ELM_WRAP_WORD, ELM_LABEL_SLIDE_MODE_AUTO
from efl.elementary.radio import Radio
from efl.elementary.separator import Separator
from efl.elementary.slider import Slider


def cb_slide_radio(radio, lb):
    lb.style = radio.text

def cb_slider_duration(slider, lb):
    lb.slide_duration = slider.value
    lb.slide_go()

    sl_spd = lb.data["slider_speed"]
    sl_spd.value = lb.slide_speed

def cb_slider_speed(slider, lb):
    lb.slide_speed = slider.value
    lb.slide_go()

    sl_dur = lb.data["slider_duration"]
    sl_dur.value = lb.slide_duration

def label_clicked(obj):
    win = StandardWindow("label", "Label test", autodel=True, size=(280, 400))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbox = Box(win, size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    win.resize_object_add(vbox)
    vbox.show()

    lb = Label(win, "<b>This is a small label</b>", size_hint_align=(0.0, 0.5))
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, size_hint_align=FILL_HORIZ)
    lb.text = "This is a larger label with newlines<br/>" \
              "to make it bigger, but it won't expand or wrap<br/>" \
              "just be a block of text that can't change its<br/>" \
              "formatting as it's fixed based on text<br/>"
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, line_wrap=ELM_WRAP_WORD, size_hint_weight=EXPAND_HORIZ,
               size_hint_align=FILL_HORIZ)
    lb.text =  "<b>This is more text designed to line-wrap here as " \
               "This object is resized horizontally. As it is " \
               "resized vertically though, nothing should change. " \
               "The amount of space allocated vertically should " \
               "change as horizontal size changes.</b>"
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, text="This small label set to wrap",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, style="default/left", text="Left aligned style",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, style="default/right", text="Right aligned style",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, style="marker", text="Marker style",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, style="marker/left", text="Marker left style",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    lb = Label(win, style="marker/right", text="Marker right style",
               size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    vbox.pack_end(lb)
    lb.show()

    sp = Separator(win, horizontal=True)
    vbox.pack_end(sp)
    sp.show()

    gd = Grid(win, size=(100, 100), size_hint_weight=EXPAND_BOTH,
              size_hint_align=FILL_BOTH)
    vbox.pack_end(gd)
    gd.show()

    lb = Label(win, text="Test Label Ellipsis:", size_hint_align=(0.0, 0.5))
    gd.pack(lb, 5, 5, 90, 15)
    lb.show()

    rect = Rectangle(win.evas, color=(255, 125, 125, 255))
    gd.pack(rect, 5, 15, 90, 15)
    rect.show()

    lb = Label(win, ellipsis=True, size_hint_align=(0.0, 0.5))
    lb.text = "This is a label set to ellipsis. " \
              "If set ellipsis to true and the text doesn't fit " \
              "in the label an ellipsis(\"...\") will be shown " \
              "at the end of the widget."
    gd.pack(lb, 5, 15, 90, 15)
    lb.show()

    lb = Label(win, text="Test Label Slide:", size_hint_align=(0.0, 0.5))
    gd.pack(lb, 5, 30, 90, 15)
    lb.show()


    rect = Rectangle(win.evas, color=(255, 125, 125, 255))
    gd.pack(rect, 5, 40, 90, 15)
    rect.show()

    lb = Label(win, slide_mode=ELM_LABEL_SLIDE_MODE_AUTO, style="slide_short",
               size_hint_align=(0.0, 0.5), slide_duration=15)
    lb.text = "This is a label set to slide. " \
              "If set slide to true the text of the label " \
              "will slide/scroll through the length of label." \
              "This only works with the themes \"slide_short\", " \
              "\"slide_long\" and \"slide_bounce\"."
    gd.pack(lb, 5, 40, 90, 15)
    lb.show()

    rd = Radio(win, state_value=1, text="slide_short")
    gd.pack(rd, 5, 55, 30, 15)
    rd.callback_changed_add(cb_slide_radio, lb)
    rd.show()
    rdg = rd

    rd = Radio(win, state_value=2, text="slide_long")
    rd.group_add(rdg)
    gd.pack(rd, 35, 55, 30, 15)
    rd.callback_changed_add(cb_slide_radio, lb)
    rd.show()

    rd = Radio(win, state_value=3, text="slide_bounce")
    rd.group_add(rdg)
    gd.pack(rd, 65, 55, 30, 15)
    rd.callback_changed_add(cb_slide_radio, lb)
    rd.show()

    sl_dur = Slider(win, text="Slide Duration", unit_format="%1.1f secs",
                    min_max=(1, 40), value=15, size_hint_align=FILL_HORIZ,
                    size_hint_weight=EXPAND_HORIZ)
    sl_dur.callback_changed_add(cb_slider_duration, lb)
    gd.pack(sl_dur, 5, 70, 90, 15)
    sl_dur.show()

    sl_spd = Slider(win, text="Slide Speed", unit_format="%1.1f px/sec",
                    min_max=(10, 300), value=10, size_hint_align=FILL_HORIZ,
                    size_hint_weight=EXPAND_HORIZ)
    sl_spd.callback_changed_add(cb_slider_speed, lb)
    gd.pack(sl_spd, 5, 80, 90, 15)
    sl_spd.show()

    lb.data["slider_duration"] = sl_dur
    lb.data["slider_speed"] = sl_spd
    win.show()


if __name__ == "__main__":

    label_clicked(None)

    elementary.run()
