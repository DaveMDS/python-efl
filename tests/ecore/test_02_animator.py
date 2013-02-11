#!/usr/bin/env python

from efl import ecore
import unittest


def cb_true(n, t, a):
    print("cb_true: %s %s %s" % (n, t, a))
    return True

def cb_false(n, t, a):
    print("cb_false: %s %s %s" % (n, t, a))
    return False


class TestAnimator(unittest.TestCase):
    def testInit(self):
        ecore.animator_frametime_set(1.0/24.0)
        self.assertEqual(ecore.animator_frametime_get(), 1.0/24.0)

        a1 = ecore.animator_add(cb_true, 123, "teste", a=456)
        a2 = ecore.Animator(cb_false, 789, "bla", a="something in a")
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
        del a1
        del a2 # already deleted since returned false
        del a3 # already deleted since returned false


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
