#!/usr/bin/env python

from efl import ecore
import unittest


counters = [0, 0]
params = None


def poller_cb():
    counters[0] += 1
    return True

def poller_cb2(one, two, three, test):
    global params

    params = (one, two, three)
    counters[1] += 1
    return False


class TestPoller(unittest.TestCase):
    def testInit(self):
        
        p1 = ecore.Poller(4, poller_cb)
        p2 = ecore.Poller(2, poller_cb2, ecore.ECORE_POLLER_CORE,
                          "uno", "due", three="tre", test=self)
        p3 = ecore.Poller(16, lambda: ecore.main_loop_quit())

        self.assertIsInstance(p1, ecore.Poller)
        self.assertIsInstance(p2, ecore.Poller)
        self.assertIsInstance(p3, ecore.Poller)

        ecore.main_loop_begin()

        self.assertEqual(counters, [4, 1])
        self.assertEqual(params, ("uno", "due", "tre"))



if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
