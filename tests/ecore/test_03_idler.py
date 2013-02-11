#!/usr/bin/env python

from efl import ecore
import unittest


def cb_true(n, t, a):
    print("cb_true: %s %s %s" % (n, t, a))
    return True

def cb_false(n, t, a):
    print("cb_false: %s %s %s" % (n, t, a))
    return False


class TestIdler(unittest.TestCase):
    def testInit(self):
        i1 = ecore.idler_add(cb_true, 123, "teste", a=456)
        i2 = ecore.Idler(cb_false, 789, "bla", a="something in a")

        self.assertIsInstance(i1, ecore.Idler)
        self.assertIsInstance(i2, ecore.Idler)
        
        before1 = i1.__repr__()
        before2 = i2.__repr__()

        t = ecore.timer_add(1, ecore.main_loop_quit)
        ecore.main_loop_begin()

        after1 = i1.__repr__()
        after2 = i2.__repr__()

        self.assertEqual(before1, after1)
        self.assertNotEqual(before2, after2) # already deleted

        self.assertEqual(t.is_deleted(), True)
        self.assertEqual(i1.is_deleted(), False)
        self.assertEqual(i2.is_deleted(), True)
        
        
        i1.delete()
        del t
        del i1
        del i2 # already deleted since returned false


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
