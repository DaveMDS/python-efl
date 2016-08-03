#!/usr/bin/env python
# encoding: utf-8

import unittest
import logging

from efl.eo import Eo
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC
from efl.elementary.entry import Entry


class TestElmBasics(unittest.TestCase):

    def setUp(self):
        self.o = Window("t", ELM_WIN_BASIC)

    def tearDown(self):
        self.o.delete()

    def testEntryUnicode(self):
        o = Entry(self.o)
        t = u"aöäöäa"
        o.text = t
        self.assertEqual(o.text, t)
        o.delete()

if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
