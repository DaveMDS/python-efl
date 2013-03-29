#!/usr/bin/python2

from efl.efreet.efreet import Uri
import unittest

class TestEfreetUri(unittest.TestCase):

    def setUp(self):
        self.protocol = "file"
        self.hostname = "localhost"
        self.path = "/home/test"
        self.uri = self.protocol + "://" + self.hostname + self.path

    def test_default_constructor(self):
        u = Uri(self.protocol, self.hostname, self.path)
        self.assertEqual(u.protocol + "://" + u.hostname + u.path, self.uri)

    def test_decode_constructor(self):
        u = Uri.decode(self.protocol + "://" + self.hostname + self.path)
        self.assertEqual(u.protocol + "://" + u.hostname + u.path, self.uri)

    def test_encode(self):
        u = Uri(self.protocol, self.hostname, self.path)
        self.assertEqual(u.encode(), self.protocol + "://" + self.path)

    def test_protocol(self):
        u = Uri(self.protocol, self.hostname, self.path)
        self.assertEqual(u.protocol, self.protocol)
        u.protocol = self.protocol
        self.assertEqual(u.protocol, self.protocol)

    def test_hostname(self):
        u = Uri(self.protocol, self.hostname, self.path)
        self.assertEqual(u.hostname, self.hostname)
        u.hostname = self.hostname
        self.assertEqual(u.hostname, self.hostname)

    def test_path(self):
        u = Uri(self.protocol, self.hostname, self.path)
        self.assertEqual(u.path, self.path)
        u.path = self.path
        self.assertEqual(u.path, self.path)

if __name__ == "__main__":
    unittest.main()
