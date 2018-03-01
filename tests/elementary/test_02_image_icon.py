#!/usr/bin/env python

import os
os.environ["ELM_ENGINE"] = "buffer"

import unittest
import logging

from efl.eo import Eo
from efl.evas import Image as evasImage
from efl import elementary as elm

script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")


class TestElmImage(unittest.TestCase):

    def setUp(self):
        self.w = elm.Window("t", elm.ELM_WIN_BASIC)
        self.o = elm.Image(self.w)

    def tearDown(self):
        self.o.delete()
        self.w.delete()

    def testImageConstructor(self):
        self.assertIsNotNone(self.o)
        self.assertEqual(Eo.parent_get(self.o), self.w)

    def testImageFile(self):
        img_file = os.path.join(script_path, u"icon.png")
        self.assertEqual(self.o.file, (None, None))
        self.o.file = img_file
        self.assertEqual(self.o.file, (img_file, None))
        self.assertEqual(self.o.object_size, (48, 48))

    def testImageFileException(self):
        self.assertRaises(RuntimeError,
                          setattr, self.o, "file",
                          u"this_fails.png")

    def testImageEvas(self):
        self.assertIsInstance(self.o.object, evasImage)

    def testImageBooleans(self):
        self.assertTrue(self.o.aspect_fixed)
        self.o.aspect_fixed = False
        self.assertFalse(self.o.aspect_fixed)

        self.assertFalse(self.o.editable)
        self.o.editable = True
        self.assertTrue(self.o.editable)

        self.assertFalse(self.o.fill_outside)
        self.o.fill_outside = True
        self.assertTrue(self.o.fill_outside)

        self.assertFalse(self.o.no_scale)
        self.o.no_scale = True
        self.assertTrue(self.o.no_scale)

        # Write-only value
        self.o.preload_disabled = True
        self.assertRaises(AttributeError, getattr, self.o, "preload_disabled")

        self.assertEqual(self.o.resizable, (True, True))
        self.o.resizable = False, False
        self.assertEqual(self.o.resizable, (False, False))

        self.assertTrue(self.o.smooth)
        self.o.smooth = False
        self.assertFalse(self.o.smooth)


class TestElmIcon(unittest.TestCase):

    def setUp(self):
        self.w = elm.Window("t", elm.ELM_WIN_BASIC)
        self.o = elm.Icon(self.w)

    def tearDown(self):
        self.o.delete()
        self.w.delete()

    def testIconConstructor(self):
        self.assertIsNotNone(self.o)
        self.assertEqual(Eo.parent_get(self.o), self.w)

    def testIconStandard(self):
        self.o.standard = u"elementary"
        self.assertEqual(u"elementary", self.o.standard)

    def testIconStandardException(self):
        self.assertRaises(RuntimeWarning,
                          setattr, self.o, "standard",
                          u"this_fails")

if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
