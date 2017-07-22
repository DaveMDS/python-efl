#!/usr/bin/env python

from efl import evas
from efl import ecore
from efl import edje
from efl.edje import Edje

import os, unittest
import logging


theme_path = os.path.dirname(os.path.abspath(__file__))
theme_file = os.path.join(theme_path, "theme.edj")


expected_signals = ["seat,added,seat1,default", "edje,language,none",
                    "edje,state,ltr", "load", "edje,state,ltr", "resize",
                    "emit,message", "emit,message"]
expected_signals2 = ["load", "resize"]
expected_messages = [33, 33]
expected_text_parts = ["label", "label"]


class MyEdje(Edje):
    def __init__(self, canvas):
        Edje.__init__(self, canvas, file=theme_file, group="main")


    @edje.on_signal("*", "*")
    def cb_signal_all(self, emission, source):
        if source == "" or source == "edje":
            expected_signals.remove(emission)

    @edje.on_signal("load", "*")
    @edje.on_signal("resize", "*")
    def cb_signal_load_resize(self, emission, source):
        expected_signals2.remove(emission)

    @edje.message_handler
    def message_handler(self, msg):
        expected_messages.remove(msg.val)

    @edje.on_text_change
    def text_change(self, part):
        expected_text_parts.remove(part)


class TestEdjeDecoratedCallbacks(unittest.TestCase):
    def setUp(self):
        self.canvas = evas.Canvas(method="buffer",
                                  size=(400, 500),
                                  viewport=(0, 0, 400, 500))
        self.canvas.engine_info_set(self.canvas.engine_info_get())
        self.o = MyEdje(self.canvas)
        self.assertIsInstance(self.o, Edje)

    def tearDown(self):
        self.o.delete()
        self.assertTrue(self.o.is_deleted())
        self.canvas.delete()

    def testDecorators(self):
        o = self.o

        # this should trigger text_change, two times
        ecore.Timer(0.1, lambda: o.part_text_set("label", "asd"))
        ecore.Timer(0.1, lambda: o.part_text_set("label", "asd2"))

        # ask the edje obj to send a message, two times
        ecore.Timer(0.1, lambda: o.signal_emit("emit,message", ""))
        ecore.Timer(0.1, lambda: o.signal_emit("emit,message", ""))

        # and then quit the main loop
        ecore.Timer(0.2, lambda: ecore.main_loop_quit())

        ecore.main_loop_begin()

        self.assertEqual(expected_signals, [])
        self.assertEqual(expected_signals2, [])
        self.assertEqual(expected_messages, [])
        self.assertEqual(expected_text_parts, [])


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
