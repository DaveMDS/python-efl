#!/usr/bin/env python

from efl import evas
import unittest


class TestLineBasics(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()
        del self.canvas

    def testConstructor(self):
        o = evas.Line(self.canvas, start=(10, 20), end=(30, 40))
        self.assertEqual(type(o), evas.Line)
        self.assertEqual(o.start_get(), (10, 20))
        self.assertEqual(o.end_get(), (30, 40))


if __name__ == '__main__':
    unittest.main(verbosity=2)
    evas.shutdown()
