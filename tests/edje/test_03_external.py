#!/usr/bin/env python

from efl import evas
from efl import ecore
from efl import edje
from efl import elementary
import os, unittest


theme_file = os.path.join(os.path.dirname(__file__), "theme.edj")


class TestEdjeExternal(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.theme = edje.Edje(self.canvas, file=theme_file, group="main")
        
    def tearDown(self):
        self.theme.delete()
        self.canvas.delete()

    def testExternalLabel(self):
        elm_label = self.theme.part_external_object_get("ext_elm_label")
        self.assertIsInstance(elm_label, elementary.Label)


        self.assertEqual(elm_label.text, "This is an elm label")
        self.theme.part_external_param_set("ext_elm_label", "label", "new text")
        self.assertEqual(elm_label.text, "new text")


    def testExternalSlider(self):
        elm_slider = self.theme.part_external_object_get("ext_elm_slider")
        self.assertIsInstance(elm_slider, elementary.Slider)

        # check values setted in edc
        self.assertEqual(elm_slider.text, "external slider")
        self.assertEqual(elm_slider.min_max, (-1, 999))
        self.assertEqual(elm_slider.value_get(), 0.6)
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


if __name__ == '__main__':
    unittest.main(verbosity=2)
    
    elementary.shutdown()
    edje.shutdown()
    ecore.shutdown()
    evas.shutdown()
