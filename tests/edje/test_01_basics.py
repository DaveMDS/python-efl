#!/usr/bin/env python

from efl import evas
from efl import edje
import os, unittest
import logging


theme_path = os.path.dirname(os.path.abspath(__file__))
theme_file = os.path.join(theme_path, "theme.edj")


class TestBasics(unittest.TestCase):

    def testFrametime(self):
        edje.frametime_set(1/60)
        self.assertEqual(edje.frametime_get(), 1/60)

    def testFontset(self):
        edje.fontset_append_set("test.ttf")
        self.assertEqual(edje.fontset_append_get(), "test.ttf")

    def testFileCollectionList(self):
        self.assertEqual(edje.file_collection_list(theme_file), ["main"])

    def testFileGroupExists(self):
        self.assertTrue(edje.file_group_exists(theme_file, "main"))
        self.assertFalse(edje.file_group_exists(theme_file, "not_exist"))

    def testFileDataGet(self):
        self.assertEqual(edje.file_data_get(theme_file, "key1"), "value1")
        self.assertEqual(edje.file_data_get(theme_file, "key2"), "value2")
        self.assertIsNone(edje.file_data_get(theme_file, "non_exists"))

    def testFileCacheSet(self):
        edje.file_cache_set(32)
        self.assertEqual(edje.file_cache_get(), 32)

    def testCollectionCacheSet(self):
        edje.collection_cache_set(32)
        self.assertEqual(edje.collection_cache_get(), 32)

    def testColorClasses(self):
        edje.color_class_set("MyColorClass",
                             100, 150, 200, 255,
                             101, 151, 201, 255,
                             102, 152, 202, 255)
        self.assertEqual(edje.color_class_get("MyColorClass"),
                         (100, 150, 200, 255,
                          101, 151, 201, 255,
                          102, 152, 202, 255))

        self.assertEqual(edje.color_class_list(), ["MyColorClass"])

        edje.color_class_del("MyColorClass")
        self.assertEqual(edje.color_class_get("MyColorClass"),
                         (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        self.assertEqual(edje.color_class_list(), [])

    def testTextClasses(self):
        edje.text_class_set("MyTextClass", "Sans", 12)
        edje.text_class_set("MySecondTextClass", "Sans", 6)

        self.assertEqual(edje.text_class_list(), ["MyTextClass", "MySecondTextClass"])

        edje.text_class_del("MyTextClass")
        edje.text_class_del("MySecondTextClass")
        self.assertEqual(edje.text_class_list(), [])

    def testAvailableModules(self):
        self.assertIsInstance(edje.available_modules_get(), list)


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
