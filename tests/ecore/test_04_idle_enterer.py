#!/usr/bin/env python

from efl import ecore
import unittest


def cb_true(n, t, a):
    print("cb_true: %s %s %s" % (n, t, a))
    return True

def cb_false(n, t, a):
    print("cb_false: %s %s %s" % (n, t, a))
    return False

def cb_idle():
    print("idle...")
    return True

def sleeper():
    import time
    print("sleep 0.1s")
    time.sleep(0.1)
    return True


class TestIdleEnterer(unittest.TestCase):
    def testInit(self):

        i1 = ecore.IdleEnterer(cb_true, 123, "teste", a=456)
        i2 = ecore.IdleEnterer(cb_false, 789, "bla", a="something in a")

        self.assertIsInstance(i1, ecore.IdleEnterer)
        self.assertIsInstance(i2, ecore.IdleEnterer)

        before1 = i1.__repr__()
        before2 = i2.__repr__()

        t = ecore.Timer(1, ecore.main_loop_quit)
        timer = ecore.Timer(0.1, sleeper)
        idler = ecore.Idler(cb_idle)

        ecore.main_loop_begin()
        timer.delete()
        idler.delete()

        after1 = i1.__repr__()
        after2 = i2.__repr__()

        self.assertEqual(before1, after1)
        self.assertNotEqual(before2, after2) # already deleted

        self.assertEqual(t.is_deleted(), True)
        self.assertEqual(i1.is_deleted(), False)
        self.assertEqual(i2.is_deleted(), True)

        i1.delete()
        del i1
        del i2 # already deleted since returned false
        del t
        del timer
        del idler


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
