#!/usr/bin/env python

from efl import evas
import unittest
import logging


class MySmart(evas.Smart):
    @staticmethod
    def resize(obj, w, h):
        w2 = w / 2
        h2 = h / 2
        obj.r1.geometry = (0, 0, w2, h2)
        obj.r2.geometry = (w2, h2, w2, h2)

    @staticmethod
    def move(obj, x, y):
        obj.callback_call("event1")


class MyObject(evas.SmartObject):
    def __init__(self, canvas, smart, *args, **kargs):
        evas.SmartObject.__init__(self, canvas, smart, *args, **kargs)
        w, h = self.size
        w2 = w / 2
        h2 = h / 2
        self.r1 = evas.Rectangle(canvas, geometry=(0, 0, w2, h2),
                                color="#ff0000")
        self.member_add(self.r1)

        self.r2 = evas.Rectangle(canvas, geometry=(w2, h2, w2, h2),
                                color="#00ff00")
        self.member_add(self.r2)


class SmartObjectTest(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.obj = MyObject(self.canvas, MySmart())

    def testMembers(self):
        self.assertEqual(self.obj.members, (self.obj.r1, self.obj.r2))

    def testResize(self):
        self.obj.resize(100, 100)
        self.assertEqual(self.obj.r1.geometry, (0, 0, 50, 50))
        self.assertEqual(self.obj.r2.geometry, (50, 50, 50, 50))

    def testCallbackSimple(self):
        self.expected_cbs = 2
        def _event1_cb(obj, event_info):
            self.expected_cbs -= 1
        self.obj.callback_add("event1", _event1_cb)
        self.obj.move(1, 1) # should fire "event1"
        self.obj.move(2, 2) # should fire "event1"
        self.obj.callback_del("event1", _event1_cb)
        self.obj.move(0, 0) # should NOT fire "event1"
        self.assertEqual(self.expected_cbs, 0)

    def testCallbackArgs(self):
        def _event1_cb(obj, event_info, arg1, arg2, arg3, mykarg2, mykarg1):
            self.assertEqual(arg1, 11)
            self.assertEqual(arg2, 22)
            self.assertEqual(arg3, "arg3")
            self.assertEqual(mykarg2, "k2")
            self.assertEqual(mykarg1, "k1")
        self.obj.callback_add("event1", _event1_cb, 11, 22, "arg3", mykarg1="k1", mykarg2="k2")
        self.obj.move(1, 1) # should fire "event1" with the correct args
        self.obj.callback_del("event1", _event1_cb)
        self.obj.move(0, 0)

    def testCallbackMulti(self):
        def _event1_cb1(obj, event_info):
            self.expected_cbs += 1
        def _event1_cb2(obj, event_info):
            self.expected_cbs += 10

        self.expected_cbs = 0
        self.obj.callback_add("event1", _event1_cb1)
        self.obj.move(1, 1) # should fire "event1" in cb1
        self.assertEqual(self.expected_cbs, 1)

        self.expected_cbs = 0
        self.obj.callback_add("event1", _event1_cb2)
        self.obj.move(2, 2) # should fire "event1" in both cbs
        self.assertEqual(self.expected_cbs, 11)

        self.expected_cbs = 0
        self.obj.callback_del("event1", _event1_cb1)
        self.obj.move(3, 3) # should fire "event1" only in cb2
        self.assertEqual(self.expected_cbs, 10)

        self.expected_cbs = 0
        self.obj.callback_del("event1", _event1_cb2)
        self.obj.move(0, 0) # should NOT fire "event1"
        self.assertEqual(self.expected_cbs, 0)

    def testCallbackLots(self):
        def _event1_cb(obj, event_info):
            self.expected_cbs -= 1

        self.expected_cbs = 20000
        self.obj.callback_add("event1", _event1_cb)
        self.obj.callback_add("event1", _event1_cb)
        for i in range(10000):
            self.obj.move(i+1, i-1) # should fire "event1" 10000 times * 2 cbs
        self.assertEqual(self.expected_cbs, 0)
        self.obj.callback_del("event1", _event1_cb)
        self.obj.callback_del("event1", _event1_cb)
        self.obj.move(0, 0) # should NOT fire "event1"
        self.assertEqual(self.expected_cbs, 0)

    def testCallbackLots2(self):
        def _event1_cb(obj, event_info):
            self.expected_cbs -= 1

        self.expected_cbs = 10000
        for i in range(10000):
            self.obj.callback_add("event1", _event1_cb)
        self.obj.move(1, 1)
        self.assertEqual(self.expected_cbs, 0)
        for i in range(10000):
            self.obj.callback_del("event1", _event1_cb)
        self.assertRaises(ValueError, self.obj.callback_del, "event1", _event1_cb)
        self.obj.move(0, 0) # should NOT fire "event1"
        self.assertEqual(self.expected_cbs, 0)

    def testCallbackWrongDel1(self):
        def _event1_cb(obj, event_info):
            pass
        self.assertRaises(ValueError, self.obj.callback_del, "event1", _event1_cb)

    def testCallbackWrongDel2(self):
        def _event1_cb(obj, event_info):
            pass
        self.obj.callback_add("event1", _event1_cb)
        self.obj.callback_add("event1", _event1_cb)
        self.obj.callback_del("event1", _event1_cb)
        self.obj.callback_del("event1", _event1_cb)
        self.assertRaises(ValueError, self.obj.callback_del, "event1", _event1_cb)


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
