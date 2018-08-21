#!/usr/bin/env python

import unittest
import tempfile
import logging
import os

from efl import ecore


@unittest.skip("double-free when run from 00_run_all_tests, works good otherwise")
class TestFileMonitor(unittest.TestCase):

    def monitor_cb(self, event, path, tmp_path):
        """ for reference:
        if event == ecore.ECORE_FILE_EVENT_MODIFIED:
            print("EVENT_MODIFIED: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_CLOSED:
            print("EVENT_CLOSED: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_CREATED_FILE:
            print("ECORE_FILE_EVENT_CREATED_FILE: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_CREATED_DIRECTORY:
            print("ECORE_FILE_EVENT_CREATED_DIRECTORY: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_DELETED_FILE:
            print("ECORE_FILE_EVENT_DELETED_FILE: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_DELETED_DIRECTORY:
            print("ECORE_FILE_EVENT_DELETED_DIRECTORY: '%s'" % path)
        elif event == ecore.ECORE_FILE_EVENT_DELETED_SELF:
            print("ECORE_FILE_EVENT_DELETED_SELF: '%s'" % path)
        """
        self.counters[event] += 1

    def do_stuff(self, tmp_path, fm):
        folder1 = os.path.join(tmp_path, "folder1")
        folder2 = os.path.join(tmp_path, "folder2")
        file1 = os.path.join(tmp_path, "file1")
        file2 = os.path.join(tmp_path, "file2")

        # this should trigger two ECORE_FILE_EVENT_CREATED_DIRECTORY
        os.mkdir(folder1)
        os.mkdir(folder2)

        # this should trigger two ECORE_FILE_EVENT_DELETED_DIRECTORY
        os.rmdir(folder1)
        os.rmdir(folder2)

        # this should trigger two ECORE_FILE_EVENT_CREATED_FILE
        fp1 = open(file1, 'a')
        fp2 = open(file2, 'a')

        # this should trigger two ECORE_FILE_EVENT_MODIFIED
        fp1.write("nothing to say")
        fp2.write("nothing to say")

        # this should trigger two ECORE_FILE_EVENT_CLOSED
        fp1.close()
        fp2.close()

        # this should trigger two ECORE_FILE_EVENT_DELETED_FILE
        os.remove(file1)
        os.remove(file2)

        # this should trigger one ECORE_FILE_EVENT_DELETED_SELF
        os.rmdir(tmp_path)

        return ecore.ECORE_CALLBACK_CANCEL

    def testInit(self):
        self. counters = [0, 0, 0, 0, 0, 0 , 0, 0]

        path = tempfile.mkdtemp()
        fm = ecore.FileMonitor(path, self.monitor_cb, path)
        self.assertIsInstance(fm, ecore.FileMonitor)
        self.assertEqual(fm.path, path)

        ecore.Timer(0.01, self.do_stuff, path, fm)
        t = ecore.Timer(1.0, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(fm.path, path)
        fm.delete()

        self.assertEqual(self.counters, [0, 2, 2, 2, 2, 1, 2, 2])


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
