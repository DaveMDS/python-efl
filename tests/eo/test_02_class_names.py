#!/usr/bin/env python

import os
os.environ["ELM_ENGINE"] = "buffer"

from efl import evas
from efl import edje
from efl import emotion
from efl import elementary as elm

import unittest
import logging


""" NOT TESTED YET:

Evas_Canvas  ->  Canvas
Evas_Smart  ->  SmartObject
Evas_FilledImage  ->  FilledImage

Elm_Conformant  ->  Conformant
Elm_Widget  ->  Object
Elm_Web  ->  Web

"""

class TestElmClassNames(unittest.TestCase):

    def setUp(self):
        elm.need_ethumb()
        self.win = elm.Window("t", elm.ELM_WIN_BASIC)
        self.frame = elm.Frame(self.win)

    def tearDown(self):
        self.win.delete()

    def testElm(self):
        # 1. test window

        # this code will force the recreation of the py object (by class name)
        # in the function object_from_instance()
        self.win._wipe_obj_data_NEVER_USE_THIS()
        del self.win
        self.win = self.frame.top_widget_get()
        self.assertIsInstance(self.win, elm.Window)

        # 2. test all the other widgets
        for cls in [elm.Actionslider, elm.Background, elm.Box,
                    elm.Bubble, elm.Button, elm.Calendar, elm.Check, elm.Clock,
                    elm.Colorselector, elm.Ctxpopup, elm.Datetime, # elm.Combobox
                    elm.Dayselector, elm.Diskselector, elm.Entry, elm.Fileselector,
                    elm.FileselectorButton, elm.FileselectorEntry, elm.Flip,
                    elm.FlipSelector, elm.Frame, elm.Gengrid, elm.Genlist,
                    elm.GestureLayer, elm.Grid, elm.Hover, elm.Hoversel, elm.Icon,
                    elm.Image, elm.Index, elm.InnerWindow, elm.Label, elm.Layout,
                    elm.List, elm.Map, elm.Mapbuf, elm.Menu, elm.MultiButtonEntry,
                    elm.Naviframe, elm.Notify, elm.Panel, elm.Panes, elm.Photo,
                    elm.Photocam, elm.Plug, elm.Popup, elm.Progressbar, elm.Radio,
                    elm.Scroller, elm.SegmentControl, elm.Separator, elm.Slider,
                    elm.Slideshow, elm.Spinner, elm.Table, elm.Thumb, elm.Toolbar,
                    elm.Video, elm.Player]:
            obj1 = cls(self.win)
            self.frame.content = obj1

            obj1._wipe_obj_data_NEVER_USE_THIS()
            del obj1
            obj2 = self.frame.content
            self.assertIsInstance(obj2, cls)

            obj2.delete()
            del obj2

    def testEvas(self):
        for cls in [evas.Image, evas.Line, evas.Polygon, evas.Text, evas.Textblock,
                    evas.Box, evas.Textgrid, evas.Table, evas.Grid,
                    edje.Edje, emotion.Emotion]:
            obj1 = cls(self.win.evas)
            self.frame.content = obj1

            obj1._wipe_obj_data_NEVER_USE_THIS()
            del obj1
            obj2 = self.frame.content
            self.assertIsInstance(obj2, cls)

            obj2.delete()
            del obj2


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
