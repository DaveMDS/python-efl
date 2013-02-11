#!/usr/bin/env python

from efl import ecore
import unittest


def cb(n, t, a):
    print("cb data: %s %s %s" % (n, t, a))
    return True

def cb_false(n, t, a):
    print("cb data false: %s %s %s" % (n, t, a))
    return False


class TestTimer(unittest.TestCase):
    def testInit(self):
        t1 = ecore.timer_add(0.2, cb, 123, "teste", a=456)
        t2 = ecore.Timer(0.5, cb, 789, "bla", a="something in a")
        t3 = ecore.Timer(0.4, cb_false, 666, "bla", a="something else in a")
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
        del t1
        t2.delete()
        del t2
        del t3 # already deleted since returned false
        del t4 # already deleted since returned false


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
