#!/usr/bin/env python

from efl import evas
from efl import ecore
from efl import edje
import os, unittest
import logging


theme_path = os.path.dirname(os.path.abspath(__file__))
theme_file = os.path.join(theme_path, "theme.edj")


class TestEdjeObject(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()

    def testConstructor(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        o.show()
        o.delete()

    def testConstructorNotExist(self):
        def f():
            o = edje.Edje(self.canvas, file="inexistent", group="")
        self.assertRaises(edje.EdjeLoadError, f)

    def testPartExists(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.part_exists("bg"), True)
        o.delete()

    def testPartNotExists(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.part_exists("bg123"), False)
        o.delete()

    def testFileSetGet(self):
        o = edje.Edje(self.canvas)
        o.file_set(theme_file, "main")
        self.assertEqual(o.file_get(), (theme_file, "main"))
        o.delete()

    def testDataGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.data_get("key3"), "value3")
        self.assertEqual(o.data_get("key4"), "value4")
        self.assertIsNone(o.data_get("not_exist"))
        o.delete()

    def testBaseScaleGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.base_scale_get(), 1.0)
        o.delete()

    def testColorClasses(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        o.color_class_set("MyColorClass",
                          100, 150, 200, 255,
                          101, 151, 201, 255,
                          102, 152, 202, 255)
        self.assertEqual(o.color_class_get("MyColorClass"),
                         (100, 150, 200, 255,
                          101, 151, 201, 255,
                          102, 152, 202, 255))

        o.color_class_del("MyColorClass")
        self.assertEqual(o.color_class_get("MyColorClass"),
                         (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        o.delete()

    def testPartObjectGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")

        rect = o.part_object_get("rect")
        self.assertIsInstance(rect, evas.Rectangle)
        self.assertEqual(rect.color, (255, 0, 0, 255))

        label = o.part_object_get("label")
        self.assertIsInstance(label, evas.Text)
        self.assertEqual(label.color, (0, 0, 200, 255))
        self.assertEqual(label.text, "label test")

        o.delete()

    def testPartGeometryGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.part_geometry_get("rect"), (50, 50, 100, 100))
        o.delete()

    def testPartSizeGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.part_size_get("rect"), (100, 100))
        o.delete()

    def testPartPosGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        self.assertEqual(o.part_pos_get("rect"), (50, 50))
        o.delete()

    def testPartTextSetGet(self):
        o = edje.Edje(self.canvas, file=theme_file, group="main")
        o.part_text_set("label", "new text")
        self.assertEqual(o.part_text_get("label"), "new text")
        o.delete()

    def testSignals(self):
        expected_signals = ["seat,added,seat1,default", "edje,language,none",
                            "edje,state,ltr", "load", "edje,state,ltr",
                            "resize", "quit"]
        def _signal_cb(obj, emission, source):
            expected_signals.remove(emission)
            if emission == "quit":
                self.assertEqual(expected_signals, [])
                ecore.main_loop_quit()

        o = edje.Edje(self.canvas, file=theme_file, group="main")
        o.signal_callback_add("*", "*", _signal_cb)
        o.signal_emit("quit", "")
        ecore.main_loop_begin()
        o.delete()


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
