#!/usr/bin/env python

import os
import unittest
from efl import ecore


def cb_read(fd_handler, a, b):
    data = os.read(fd_handler.fd, 50)
    print("ready for read: %s, params: a=%s, b=%s " % (fd_handler, a, b))
    return True

def timer_write(wfd):
    print("write to fd: %s" % wfd)
    os.write(wfd, b"[some data]")
    return True


class TestFdHandler(unittest.TestCase):
    def testInit(self):
        rfd, wfd = os.pipe()
        fdh = ecore.fd_handler_add(rfd, ecore.ECORE_FD_READ, cb_read, 123, b="xyz")

        ecore.timer_add(0.2, timer_write, wfd)

        print("before: fdh=%s" % fdh)

        ecore.timer_add(1, ecore.main_loop_quit)
        ecore.main_loop_begin()
        print("main loop stopped")

        print("after: fdh=%s" % fdh)

        fdh.delete()
        del fdh


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
