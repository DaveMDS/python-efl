#!/usr/bin/env python

from efl import evas
import unittest


class TestTextblockBasics(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()
        del self.canvas

    def testConstructor(self):
        o = evas.Textblock(self.canvas, text_markup="MyTextblock")
        self.assertEqual(type(o), evas.Textblock)
        self.assertEqual(o.text_markup_get(), "MyTextblock")


if __name__ == '__main__':
    unittest.main(verbosity=2)
    evas.shutdown()
