#!/usr/bin/env python

from efl import eo
from efl.eo import Eo

from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.button import Button

eo.init()
elementary.init()

import os, unittest


class TestBasics(unittest.TestCase):

    def setUp(self):
        self.o = eo.Eo.__new__(eo.Eo)

    def tearDown(self):
        self.o.delete()

    def testEoConstructor(self):
        self.assertRaises(TypeError, self.o.__init__)

    def testRepr(self):
        self.assertIsNotNone(repr(self.o))

    def testParentGet(self):
        self.assertIsNone(self.o.parent_get())

class TestElmBasics(unittest.TestCase):

    def setUp(self):
        self.o = Window("t", ELM_WIN_BASIC)

    def tearDown(self):
        self.o.delete()

    def testParentGet1(self):
        self.assertIsNone(self.o.parent_get())

    def testParentGet2(self):
        o = Button(self.o)
        self.assertEqual(Eo.parent_get(o), self.o)
        o.delete()

if __name__ == '__main__':
    unittest.main(verbosity=2)
    elementary.shutdown()
    eo.shutdown()
