#!/usr/bin/env python

from efl import evas
from efl import ecore
from efl import edje
from efl.edje import Edje

import os, unittest


theme_path = os.path.dirname(os.path.abspath(__file__))
theme_file = os.path.join(theme_path, "theme.edj")


expected_signals = ["edje,state,ltr", "load", "edje,state,ltr", "resize",
                    "cursor,changed", "changed", "emit,message", "emit,message"]
expected_signals2 = ["load", "resize"]
expected_messages = [33, 33]
expected_text_parts = ["label", "label"]


class MyEdje(Edje):
    def __init__(self, canvas):
        Edje.__init__(self, canvas, file=theme_file, group="main")


    @edje.on_signal("*", "*")
    def cb_signal_all(self, emission, source):
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

    def tearDown(self):
        self.canvas.delete()

    def testDecorators(self):
        o = MyEdje(self.canvas)
        self.assertIsInstance(o, Edje)

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

        o.delete()
        self.assertTrue(o.is_deleted())


if __name__ == '__main__':
    unittest.main(verbosity=2)
    edje.shutdown()
    ecore.shutdown()
    evas.shutdown()
