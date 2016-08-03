#!/usr/bin/env python

from efl import evas
import unittest
import logging


class TestPolygonBasics(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()
        del self.canvas

    def testConstructor(self):
        o = evas.Polygon(self.canvas, geometry=(10, 20, 30, 40))
        self.assertEqual(type(o), evas.Polygon)
        self.assertEqual(o.geometry_get(), (10, 20, 30, 40))


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
