#!/usr/bin/env python

import unittest
import logging
import time

from efl import ecore


class TestIdleEnterer(unittest.TestCase):

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

    def cb_idle(self):
        self.counters[2] += 1
        return ecore.ECORE_CALLBACK_RENEW

    def cb_sleeper(self):
        time.sleep(0.1)
        self.counters[3] += 1
        return ecore.ECORE_CALLBACK_RENEW

    def testInit(self):
        self.counters = [0, 0, 0, 0]

        i1 = ecore.IdleEnterer(self.cb_renew, 123, "teste", a=456)
        i2 = ecore.IdleEnterer(self.cb_cancel, 789, "bla", a="something in a")

        self.assertIsInstance(i1, ecore.IdleEnterer)
        self.assertIsInstance(i2, ecore.IdleEnterer)

        t = ecore.Timer(1, ecore.main_loop_quit)
        timer = ecore.Timer(0.1, self.cb_sleeper)
        idler = ecore.Idler(self.cb_idle)

        ecore.main_loop_begin()

        # all the callback has been called?
        self.assertTrue(self.counters[0] > 1)
        self.assertTrue(self.counters[1] == 1)
        self.assertTrue(self.counters[2] > 1)
        self.assertTrue(self.counters[3] > 1)

        # "i1"  not yet deleted since returned true
        self.assertEqual(i1.is_deleted(), False)
        i1.delete()
        self.assertEqual(i1.is_deleted(), True)
        del i1

        # "i2" already deleted since returned false
        self.assertEqual(i2.is_deleted(), True)
        del i2
        
        # "t" already deleted since returned false
        self.assertEqual(t.is_deleted(), True)
        del t

        # "idler" not yet deleted since returned true
        self.assertEqual(idler.is_deleted(), False)
        idler.delete()
        self.assertEqual(idler.is_deleted(), True)
        del idler
        
        # "timer" not yet deleted since returned true
        self.assertEqual(timer.is_deleted(), False)
        timer.delete()
        self.assertEqual(timer.is_deleted(), True)
        del timer
        


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
