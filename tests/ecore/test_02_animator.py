#!/usr/bin/env python

import unittest
import logging

from efl import ecore


class TestAnimator(unittest.TestCase):

    def cb_renew(self, n, t, a):
        self.assertEqual(n, 123)
        self.assertEqual(t, "teste")
        self.assertEqual(a, 456)
        return ecore.ECORE_CALLBACK_RENEW

    def cb_cancel(self, n, t, a):
        self.assertEqual(n, 789)
        self.assertEqual(t, "bla")
        self.assertEqual(a, "something in a")
        return ecore.ECORE_CALLBACK_CANCEL

    def testInit(self):
        ecore.animator_frametime_set(1.0/24.0)
        self.assertEqual(ecore.animator_frametime_get(), 1.0/24.0)

        a1 = ecore.animator_add(self.cb_renew, 123, "teste", a=456)
        a2 = ecore.Animator(self.cb_cancel, 789, "bla", a="something in a")
        a3 = ecore.animator_add(ecore.main_loop_quit)

        self.assertIsInstance(a1, ecore.Animator)
        self.assertIsInstance(a2, ecore.Animator)
        self.assertIsInstance(a3, ecore.Animator)

        before1 = a1.__repr__()
        before2 = a2.__repr__()
        before3 = a3.__repr__()

        ecore.main_loop_begin()

        after1 = a1.__repr__()
        after2 = a2.__repr__()
        after3 = a3.__repr__()

        self.assertEqual(before1, after1)
        self.assertNotEqual(before2, after2) # already deleted
        self.assertNotEqual(before3, after3) # already deleted

        self.assertEqual(a1.is_deleted(), False)
        self.assertEqual(a2.is_deleted(), True)
        self.assertEqual(a3.is_deleted(), True)

        a1.delete()
        self.assertEqual(a1.is_deleted(), True)
        del a1
        del a2 # already deleted since returned false
        del a3 # already deleted since returned false


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
