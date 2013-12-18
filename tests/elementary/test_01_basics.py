#!/usr/bin/env python

import unittest

from efl.eo import Eo
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.button import Button

elementary.init()

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
