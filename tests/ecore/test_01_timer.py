#!/usr/bin/env python

import unittest
import logging

from efl import ecore


class TestTimer(unittest.TestCase):

    def cb_renew1(self, n, t, a):
        self.assertEqual(n, 123)
        self.assertEqual(t, "teste")
        self.assertEqual(a, 456)
        return ecore.ECORE_CALLBACK_RENEW

    def cb_renew2(self, n, t, a):
        self.assertEqual(n, 789)
        self.assertEqual(t, "bla")
        self.assertEqual(a, "something in a")
        return ecore.ECORE_CALLBACK_RENEW

    def cb_cancel(self, n, t, a):
        self.assertEqual(n, 666)
        self.assertEqual(t, "bla")
        self.assertEqual(a, "something else in a")
        return ecore.ECORE_CALLBACK_CANCEL

    def testInit(self):
        t1 = ecore.timer_add(0.2, self.cb_renew1, 123, "teste", a=456)
        t2 = ecore.Timer(0.5, self.cb_renew2, 789, "bla", a="something in a")
        t3 = ecore.Timer(0.4, self.cb_cancel, 666, "bla", a="something else in a")
        t4 = ecore.timer_add(1, ecore.main_loop_quit)

        self.assertIsInstance(t1, ecore.Timer)
        self.assertIsInstance(t2, ecore.Timer)
        self.assertIsInstance(t3, ecore.Timer)
        self.assertIsInstance(t4, ecore.Timer)

        before1 = t1.__repr__()
        before2 = t2.__repr__()
        before3 = t3.__repr__()
        before4 = t4.__repr__()

        ecore.main_loop_begin()

        after1 = t1.__repr__()
        after2 = t2.__repr__()
        after3 = t3.__repr__()
        after4 = t4.__repr__()

        self.assertEqual(before1, after1)
        self.assertEqual(before2, after2)
        self.assertNotEqual(before3, after3) # already deleted
        self.assertNotEqual(before4, after4) # already deleted

        self.assertEqual(t1.is_deleted(), False)
        self.assertEqual(t2.is_deleted(), False)
        self.assertEqual(t3.is_deleted(), True)
        self.assertEqual(t4.is_deleted(), True)

        t1.delete()
        self.assertEqual(t1.is_deleted(), True)
        del t1
        t2.delete()
        self.assertEqual(t2.is_deleted(), True)
        del t2
        del t3 # already deleted since returned false
        del t4 # already deleted since returned false


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
