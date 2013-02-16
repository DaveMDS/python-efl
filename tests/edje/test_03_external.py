#!/usr/bin/env python

from efl import evas
from efl import ecore
from efl import edje
from efl import elementary
import os, unittest


theme_file = os.path.join(os.path.dirname(__file__), "theme.edj")


class TestElementaryExternal(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.theme = edje.Edje(self.canvas, file=theme_file, group="main")
        
    def tearDown(self):
        self.theme.delete()
        self.canvas.delete()

    def testExternalActionslider(self):
        elm_as = self.theme.part_external_object_get("ext_elm_actionslider")
        self.assertIsInstance(elm_as, elementary.Actionslider)

        # check values setted in edc (from external)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_actionslider", "label"), "ActionSlideR")

        # check values setted in edc (from object)
        self.assertEqual(elm_as.text, "ActionSlideR")

        # do params set
        self.theme.part_external_param_set("ext_elm_actionslider", "label", "new text")

        # recheck setted values
        self.assertEqual(self.theme.part_external_param_get("ext_elm_actionslider", "label"), "new text")
        self.assertEqual(elm_as.text, "new text")

    def testExternalBackground(self):
        elm_bg = self.theme.part_external_object_get("ext_elm_bg")
        self.assertIsInstance(elm_bg, elementary.Background)

        # TODO test params

    def testExternalBubble(self):
        elm_bg = self.theme.part_external_object_get("ext_elm_bubble")
        self.assertIsInstance(elm_bg, elementary.Bubble)

        # TODO test params

    def testExternalButton(self):
        elm_button = self.theme.part_external_object_get("ext_elm_button")
        self.assertIsInstance(elm_button, elementary.Button)

        # TODO test params

    def testExternalCalendar(self):
        elm_cal = self.theme.part_external_object_get("ext_elm_calendar")
        self.assertIsInstance(elm_cal, elementary.Calendar)

        # TODO test params

    def testExternalCheck(self):
        elm_check = self.theme.part_external_object_get("ext_elm_check")
        self.assertIsInstance(elm_check, elementary.Check)

        # TODO test params

    def testExternalClock(self):
        elm_clock = self.theme.part_external_object_get("ext_elm_clock")
        self.assertIsInstance(elm_clock, elementary.Clock)

        # check values setted in edc (from external)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "hours"), 23)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "minutes"), 58)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "seconds"), 59)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "editable"), True)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "am/pm"), True)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_clock", "show seconds"), True)

        # check values setted in edc (from object)
        self.assertEqual(elm_clock.time, (23, 58, 59))
        self.assertEqual(elm_clock.edit, True)
        self.assertEqual(elm_clock.show_am_pm, True)
        self.assertEqual(elm_clock.show_seconds, True)

        # do params set
        self.theme.part_external_param_set("ext_elm_clock", "hours", 2)
        self.theme.part_external_param_set("ext_elm_clock", "minutes", 3)
        self.theme.part_external_param_set("ext_elm_clock", "seconds", 4)
        self.theme.part_external_param_set("ext_elm_clock", "editable", False)
        self.theme.part_external_param_set("ext_elm_clock", "am/pm", False)
        self.theme.part_external_param_set("ext_elm_clock", "show seconds", False)

        # recheck setted values
        self.assertEqual(elm_clock.time, (2, 3, 4))
        self.assertEqual(elm_clock.edit, False)
        self.assertEqual(elm_clock.show_am_pm, False)
        self.assertEqual(elm_clock.show_seconds, False)

    def testExternalEntry(self):
        elm_entry = self.theme.part_external_object_get("ext_elm_entry")
        self.assertIsInstance(elm_entry, elementary.Entry)

        # TODO test params

    def testExternalFileselector(self):
        elm_fs = self.theme.part_external_object_get("ext_elm_fileselector")
        self.assertIsInstance(elm_fs, elementary.Fileselector)

        # TODO test params

    def testExternalFileselectorButton(self):
        elm_fs_btn = self.theme.part_external_object_get("ext_elm_fileselector_button")
        self.assertIsInstance(elm_fs_btn, elementary.FileselectorButton)

        # TODO test params

    def testExternalFileselectorEntry(self):
        elm_fs_en = self.theme.part_external_object_get("ext_elm_fileselector_entry")
        self.assertIsInstance(elm_fs_en, elementary.FileselectorEntry)

        # TODO test params

    def testExternalFrame(self):
        elm_frame = self.theme.part_external_object_get("ext_elm_frame")
        self.assertIsInstance(elm_frame, elementary.Frame)

        # TODO test params

    def testExternalGengrid(self):
        elm_gg = self.theme.part_external_object_get("ext_elm_gengrid")
        self.assertIsInstance(elm_gg, elementary.Gengrid)

        # TODO test params

    def testExternalGenlist(self):
        elm_gl = self.theme.part_external_object_get("ext_elm_genlist")
        self.assertIsInstance(elm_gl, elementary.Genlist)

        # TODO test params

    def testExternalHoversel(self):
        elm_hoversel = self.theme.part_external_object_get("ext_elm_hoversel")
        self.assertIsInstance(elm_hoversel, elementary.Hoversel)

        # TODO test params

    def testExternalIcon(self):
        elm_icon = self.theme.part_external_object_get("ext_elm_icon")
        self.assertIsInstance(elm_icon, elementary.Icon)

        # TODO test params

    def testExternalIndex(self):
        elm_index = self.theme.part_external_object_get("ext_elm_index")
        self.assertIsInstance(elm_index, elementary.Index)

        # TODO test params

    def testExternalLabel(self):
        elm_label = self.theme.part_external_object_get("ext_elm_label")
        self.assertIsInstance(elm_label, elementary.Label)

        # check values setted in edc (from external)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_label", "label"), "This is an elm label")

        # check values setted in edc (from object)
        self.assertEqual(elm_label.text, "This is an elm label")

        # do params set
        self.theme.part_external_param_set("ext_elm_label", "label", "new text")

        # recheck setted values
        self.assertEqual(self.theme.part_external_param_get("ext_elm_label", "label"), "new text")
        self.assertEqual(elm_label.text, "new text")

    def testExternalList(self):
        elm_list = self.theme.part_external_object_get("ext_elm_list")
        self.assertIsInstance(elm_list, elementary.List)

        # TODO test params

    def testExternalMap(self):
        elm_map = self.theme.part_external_object_get("ext_elm_map")
        self.assertIsInstance(elm_map, elementary.Map)

        # TODO test params

    def testExternalMultibuttonentry(self):
        elm_mbe = self.theme.part_external_object_get("ext_elm_multibuttonentry")
        self.assertIsInstance(elm_mbe, elementary.MultiButtonEntry)

        # TODO test params

    def testExternalNaviframe(self):
        elm_nf = self.theme.part_external_object_get("ext_elm_naviframe")
        self.assertIsInstance(elm_nf, elementary.Naviframe)

        # TODO test params

    def testExternalNotify(self):
        elm_notify = self.theme.part_external_object_get("ext_elm_notify")
        self.assertIsInstance(elm_notify, elementary.Notify)

        # TODO test params

    def testExternalPanes(self):
        elm_panes = self.theme.part_external_object_get("ext_elm_panes")
        self.assertIsInstance(elm_panes, elementary.Panes)

        # TODO test params

    def testExternalPhotocam(self):
        elm_photocam = self.theme.part_external_object_get("ext_elm_photocam")
        self.assertIsInstance(elm_photocam, elementary.Photocam)

        # TODO test params

    def testExternalProgressbar(self):
        elm_pb = self.theme.part_external_object_get("ext_elm_progressbar")
        self.assertIsInstance(elm_pb, elementary.Progressbar)

        # TODO test params

    def testExternalRadio(self):
        elm_radio = self.theme.part_external_object_get("ext_elm_radio")
        self.assertIsInstance(elm_radio, elementary.Radio)

        # TODO test params

    def testExternalScroller(self):
        elm_scroller = self.theme.part_external_object_get("ext_elm_scroller")
        self.assertIsInstance(elm_scroller, elementary.Scroller)

        # TODO test params

    def testExternalSegmentControl(self):
        elm_sc = self.theme.part_external_object_get("ext_elm_segment_control")
        self.assertIsInstance(elm_sc, elementary.SegmentControl)

        # TODO test params

    def testExternalSlider(self):
        elm_slider = self.theme.part_external_object_get("ext_elm_slider")
        self.assertIsInstance(elm_slider, elementary.Slider)

        # check values setted in edc (from external)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "label"), "external slider")
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "min"), -1)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "max"), 999)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "value"), 0.6)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "inverted"), True)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "horizontal"), True)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "span"), 45)
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "unit format"), "test %f")
        self.assertEqual(self.theme.part_external_param_get("ext_elm_slider", "indicator format"), "%f ind")

        # check values setted in edc (from object)
        self.assertEqual(elm_slider.text, "external slider")
        self.assertEqual(elm_slider.min_max, (-1, 999))
        self.assertEqual(elm_slider.value, 0.6)
        self.assertEqual(elm_slider.inverted, True)
        self.assertEqual(elm_slider.horizontal, True)
        self.assertEqual(elm_slider.span_size, 45)
        self.assertEqual(elm_slider.unit_format, "test %f")
        self.assertEqual(elm_slider.indicator_format, "%f ind")
        self.assertIsInstance(elm_slider.icon, elementary.Icon)

        # do params set
        self.theme.part_external_param_set("ext_elm_slider", "label", "new text")
        self.theme.part_external_param_set("ext_elm_slider", "min", -20.0)
        self.theme.part_external_param_set("ext_elm_slider", "max", 30.0)
        self.theme.part_external_param_set("ext_elm_slider", "value", 21.0)
        self.theme.part_external_param_set("ext_elm_slider", "inverted", False)
        self.theme.part_external_param_set("ext_elm_slider", "horizontal", False)
        self.theme.part_external_param_set("ext_elm_slider", "span", 11)
        self.theme.part_external_param_set("ext_elm_slider", "unit format", "uf")
        self.theme.part_external_param_set("ext_elm_slider", "indicator format", "if")
        self.theme.part_external_param_set("ext_elm_slider", "icon", "home")

        # recheck setted values
        self.assertEqual(elm_slider.text, "new text")
        self.assertEqual(elm_slider.min_max, (-20, 30))
        self.assertEqual(elm_slider.value_get(), 21)
        self.assertEqual(elm_slider.inverted, False)
        self.assertEqual(elm_slider.horizontal, False)
        self.assertEqual(elm_slider.span_size, 11)
        self.assertEqual(elm_slider.unit_format, "uf")
        self.assertEqual(elm_slider.indicator_format, "if")
        self.assertIsInstance(elm_slider.icon, elementary.Icon)

    def testExternalSlideshow(self):
        elm_ss = self.theme.part_external_object_get("ext_elm_slideshow")
        self.assertIsInstance(elm_ss, elementary.Slideshow)

        # TODO test params

    def testExternalSpinner(self):
        elm_spinner = self.theme.part_external_object_get("ext_elm_spinner")
        self.assertIsInstance(elm_spinner, elementary.Spinner)

        # TODO test params

    def testExternalThumb(self):
        elm_thumb = self.theme.part_external_object_get("ext_elm_thumb")
        self.assertIsInstance(elm_thumb, elementary.Thumb)

        # TODO test params

    def testExternalToolbar(self):
        elm_toolbar = self.theme.part_external_object_get("ext_elm_toolbar")
        self.assertIsInstance(elm_toolbar, elementary.Toolbar)

        # TODO test params

    def testExternalVideo(self):
        elm_video = self.theme.part_external_object_get("ext_elm_video")
        self.assertIsInstance(elm_video, elementary.Video)

        # TODO test params

    def testExternalWeb(self):
        elm_web = self.theme.part_external_object_get("ext_elm_web")
        self.assertIsInstance(elm_web, elementary.Web)

        # TODO test params


if __name__ == '__main__':
    unittest.main(verbosity=2)
    
    elementary.shutdown()
    edje.shutdown()
    ecore.shutdown()
    evas.shutdown()
