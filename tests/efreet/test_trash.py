#!/usr/bin/python2

import os
from efl.efreet.efreet import Uri
from efl.efreet import trash
import unittest

class TestEfreetTrash(unittest.TestCase):

    def setUp(self):
        protocol = "file"
        hostname = "localhost"
        f = self.f = "efreet_trash_test"
        path = self.path = os.path.join("/tmp", f)
        self.u = Uri(protocol, hostname, path)
        open(path, "w").close()

    def test_dir_get(self):
        self.assertIsNotNone(trash.dir_get(self.path))

    def test_delete_uri(self):
        self.assertTrue(trash.delete_uri(self.u, True))

    def test_ls(self):
        trash.empty_trash()
        trash.delete_uri(self.u, True)
        self.assertEqual(trash.ls()[0], self.f)

    def test_is_empty(self):
        trash.empty_trash()
        self.assertTrue(trash.is_empty())
        trash.delete_uri(self.u, True)
        self.assertFalse(trash.is_empty())
        trash.empty_trash()

    def test_empty_trash(self):
        trash.delete_uri(self.u, True)
        self.assertTrue(trash.empty_trash())

if __name__ == "__main__":
    unittest.main()
