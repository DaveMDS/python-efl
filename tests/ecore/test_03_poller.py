#!/usr/bin/env python

import unittest
import logging

from efl import ecore


class TestPoller(unittest.TestCase):

    def cb_renew(self):
        self.counters[0] += 1
        return ecore.ECORE_CALLBACK_RENEW

    def cb_cancel(self, one, two, three, test):
        self.assertEqual(one, "uno")
        self.assertEqual(two, "due")
        self.assertEqual(three, "tre")
        self.assertEqual(test, self)
        self.counters[1] += 1
        return ecore.ECORE_CALLBACK_CANCEL

    def testInit(self):
        self.counters = [0, 0]

        p1 = ecore.Poller(4, self.cb_renew)
        p2 = ecore.Poller(2, self.cb_cancel, ecore.ECORE_POLLER_CORE,
                          "uno", "due", three="tre", test=self)
        p3 = ecore.Poller(16, lambda: ecore.main_loop_quit())

        self.assertIsInstance(p1, ecore.Poller)
        self.assertIsInstance(p2, ecore.Poller)
        self.assertIsInstance(p3, ecore.Poller)

        ecore.main_loop_begin()

        # all the callback has been called?
        self.assertEqual(self.counters, [4, 1])

        # not yet deleted since returned true
        self.assertEqual(p1.is_deleted(), False)
        p1.delete()
        self.assertEqual(p1.is_deleted(), True)
        del p1

        # already deleted since returned false
        self.assertEqual(p2.is_deleted(), True)
        self.assertEqual(p3.is_deleted(), True)
        del p2 
        del p3


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
