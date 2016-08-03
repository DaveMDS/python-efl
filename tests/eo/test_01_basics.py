#!/usr/bin/env python

import efl.eo as eo
from efl.eo import Eo

import unittest
import logging


class TestBasics(unittest.TestCase):

    def setUp(self):
        self.o = Eo.__new__(Eo)

    def tearDown(self):
        self.o.delete()

    def testEoConstructor(self):
        self.assertRaises(TypeError, self.o.__init__)

    def testRepr(self):
        self.assertIsNotNone(repr(self.o))


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
