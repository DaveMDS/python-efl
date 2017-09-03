#!/usr/bin/env python

from efl import evas
import unittest
import logging


def _new_canvas():
    c = evas.Canvas(method="buffer", size=(400, 500), viewport=(0, 0, 400, 500))
    c.engine_info_set(c.engine_info_get())
    return c


class TestCanvasConstructor(unittest.TestCase):
    def testNoConstructorArgs(self):
        c = evas.Canvas(method="buffer")
        self.assertEqual(c.output_method_get(), 1)
        self.assertEqual(c.size_get(), (0, 0))
        self.assertEqual(c.viewport_get(), (0, 0, 1, 1))
        c.delete()

    def testConstructorArgs(self):
        m = "buffer"
        s = (400, 500)
        v = (0, 0, 30, 40)
        c = evas.Canvas(method=m, size=s, viewport=v)
        c.engine_info_set(c.engine_info_get())
        self.assertEqual(c.output_method_get(), evas.render_method_lookup(m))
        self.assertEqual(c.size_get(), s)
        self.assertEqual(c.viewport_get(), v)
        self.assertEqual(isinstance(str(c), str), True)
        self.assertEqual(isinstance(repr(c), str), True)
        c.delete()


class TestCanvasMethods(unittest.TestCase):
    def setUp(self):
        self.canvas = _new_canvas()

    def tearDown(self):
        self.canvas.delete()

    def testSizeGet(self):
        self.assertEqual(self.canvas.size_get(), (400, 500))

    def testSizeSet(self):
        self.canvas.size_set(200, 300)
        self.assertEqual(self.canvas.size_get(), (200, 300))


class TestCanvasProperties(unittest.TestCase):
    def setUp(self):
        self.canvas = _new_canvas()

    def tearDown(self):
        self.canvas.delete()

    def testSizeGet(self):
        self.assertEqual(self.canvas.size, (400, 500))

    def testSizeSet(self):
        self.canvas.size = (200, 300)
        self.assertEqual(self.canvas.size_get(), (200, 300))

    def testRectGet(self):
        self.assertEqual(self.canvas.rect, (0, 0, 400, 500))

    def testRectSetTuple(self):
        self.canvas.rect = (0, 0, 200, 300)
        self.assertEqual(self.canvas.size_get(), (200, 300))

    def testRectSetRect(self):
        self.canvas.rect = evas.Rect(size=(200, 300))
        self.assertEqual(self.canvas.size_get(), (200, 300))


class TestCanvasDeletion(unittest.TestCase):
    def testEmptyCanvasDelete(self):
        canvas = _new_canvas()
        canvas.delete()

    def testCanvasDelete(self):
        canvas = _new_canvas()
        r1 = evas.Rectangle(canvas)
        r2 = evas.Rectangle(canvas)
        r1.delete()
        r2.delete()
        canvas.delete()

    def testFullCanvasDelete(self):
        canvas = _new_canvas()
        r = evas.Rectangle(canvas)
        i = evas.Image(canvas)
        canvas.delete()


class TestCanvasFactory(unittest.TestCase):
    def setUp(self):
        self.canvas = _new_canvas()

    def tearDown(self):
        self.canvas.delete()

    def testRectangle(self):
        o = self.canvas.Rectangle()
        self.assertEqual(type(o), evas.Rectangle)
        o.delete()

    def testImage(self):
        o = self.canvas.Image()
        self.assertEqual(type(o), evas.Image)
        o.delete()

    def testBox(self):
        o = self.canvas.Box()
        self.assertEqual(type(o), evas.Box)
        o.delete()

    def testPolygon(self):
        o = self.canvas.Polygon()
        self.assertEqual(type(o), evas.Polygon)
        o.delete()

    def testText(self):
        o = self.canvas.Text()
        self.assertEqual(type(o), evas.Text)
        o.delete()

    def testTextblock(self):
        o = self.canvas.Textblock()
        self.assertEqual(type(o), evas.Textblock)
        o.delete()


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
