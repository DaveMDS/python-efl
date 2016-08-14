#!/usr/bin/env python

import os
import unittest
import logging

from efl import ecore


NUM_WRITE = 30

class TestFdHandler(unittest.TestCase):

    def cb_read(self, fd_handler, a, b):
        self.assertEqual(a, 123)
        self.assertEqual(b, "xyz")

        self.assertTrue(fd_handler.can_read())
        self.assertFalse(fd_handler.can_write())
        self.assertFalse(fd_handler.has_error())
        self.assertEqual(fd_handler.fd, self.rfd)

        data = os.read(fd_handler.fd, 32)
        # print("READ:", data)
        self.assertEqual(data, self.sent_data)

        self.num_read += 1
        if self.num_read >= NUM_WRITE:
            ecore.main_loop_quit()

        return ecore.ECORE_CALLBACK_RENEW

    def write_timer(self, wfd):
        self.sent_data = b"data for the reader #%d" % self.num_write
        # print("WRIT:", self.sent_data)
        os.write(wfd, self.sent_data)

        self.num_write += 1
        return ecore.ECORE_CALLBACK_RENEW

    def testInit(self):
        self.num_write = 0
        self.num_read = 0
        self.sent_data = None

        self.rfd, wfd = os.pipe()
        fdh = ecore.fd_handler_add(self.rfd, ecore.ECORE_FD_READ,
                                   self.cb_read, 123, b="xyz")

        self.assertIsInstance(fdh, ecore.FdHandler)

        ecore.timer_add(0.01, self.write_timer, wfd)
        t = ecore.timer_add(1.0, ecore.main_loop_quit) # just a timeout (should quit earlier)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(self.num_read, NUM_WRITE)
        self.assertEqual(self.num_write, NUM_WRITE)

        self.assertEqual(fdh.is_deleted(), False)
        fdh.delete()
        self.assertEqual(fdh.is_deleted(), True)
        del fdh


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
