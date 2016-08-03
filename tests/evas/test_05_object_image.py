#!/usr/bin/env python

from efl import evas
import os, unittest
import logging


icon_file = os.path.join(os.path.dirname(__file__), "icon.png")


class TestImageBasics(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()
        del self.canvas

    def testConstructor(self):
        o = evas.Image(self.canvas, file=icon_file, geometry=(10, 20, 30, 40))
        self.assertEqual(type(o), evas.Image)
        self.assertEqual(o.geometry_get(), (10, 20, 30, 40))
        self.assertEqual(o.file_get(), (icon_file, None))


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
