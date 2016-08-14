#!/usr/bin/env python

import unittest
import logging

from efl import ecore


class TestIdler(unittest.TestCase):

    def cb_renew(self, n, t, a):
        self.assertEqual(n, 123)
        self.assertEqual(t, "teste")
        self.assertEqual(a, 456)
        self.counters[0] += 1
        return ecore.ECORE_CALLBACK_RENEW

    def cb_cancel(self, n, t, a):
        self.assertEqual(n, 789)
        self.assertEqual(t, "bla")
        self.assertEqual(a, "something in a")
        self.counters[1] += 1
        return ecore.ECORE_CALLBACK_CANCEL

    def testInit(self):
        self.counters = [0, 0]

        i1 = ecore.idler_add(self.cb_renew, 123, "teste", a=456)
        i2 = ecore.Idler(self.cb_cancel, 789, "bla", a="something in a")

        self.assertIsInstance(i1, ecore.Idler)
        self.assertIsInstance(i2, ecore.Idler)

        t = ecore.timer_add(1, ecore.main_loop_quit)
        ecore.main_loop_begin()

        # all the callback has been called?
        self.assertTrue(self.counters[0] > 1)
        self.assertTrue(self.counters[1] == 1)

        # not yet deleted since returned true
        self.assertEqual(i1.is_deleted(), False)
        i1.delete()
        self.assertEqual(i1.is_deleted(), True)
        del i1

        # already deleted since returned false
        self.assertEqual(i2.is_deleted(), True)
        self.assertEqual(t.is_deleted(), True)
        del i2 
        del t


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
