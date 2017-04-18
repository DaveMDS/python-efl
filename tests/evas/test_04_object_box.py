#!/usr/bin/env python

from efl import evas
import unittest
import logging


class TestBoxBasics(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())

    def tearDown(self):
        self.canvas.delete()

    def testConstructor(self):
        box = evas.Box(self.canvas)
        self.assertEqual(type(box), evas.Box)
        box.delete()

    def testConstructorBaseParameters(self):
        size = (20, 30)
        pos = (40, 50)
        geometry = (60, 70, 80, 90)

        # create box using size/pos
        box1 = evas.Box(self.canvas, name="box1", size=size, pos=pos)
        self.assertEqual(box1.name, "box1")
        self.assertEqual(box1.size, size)
        self.assertEqual(box1.pos, pos)
        box1.delete()

        # create box2 using geometry
        box2 = evas.Box(self.canvas, name="box2", geometry=geometry)
        self.assertEqual(box2.name, "box2")
        self.assertEqual(box2.geometry, geometry)
        box2.delete()

    def testRemoveAll(self):
        box = evas.Box(self.canvas)
        r1 = evas.Rectangle(self.canvas)
        r2 = evas.Rectangle(self.canvas)
        box.append(r1)
        box.append(r2)
        box.remove_all(True)
        self.assertEqual(r1.is_deleted(), True)
        self.assertEqual(r2.is_deleted(), True)
        box.delete()


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
