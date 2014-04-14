#!/usr/bin/env python

from efl.eo import Eo

import unittest


class TestBasics(unittest.TestCase):

    def setUp(self):
        self.o = Eo.__new__(Eo)

    def tearDown(self):
        self.o.delete()

    def testEoConstructor(self):
        self.assertRaises(TypeError, self.o.__init__)

    def testRepr(self):
        self.assertIsNotNone(repr(self.o))

    def testParentGet(self):
        self.assertIsNone(self.o.parent_get())


if __name__ == '__main__':
    unittest.main(verbosity=2)
    eo.shutdown()
