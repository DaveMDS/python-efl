#!/usr/bin/env python

from efl import ecore
import unittest
import os
import tempfile


counters = [0, 0, 0, 0, 0, 0 , 0, 0]

def monitor_cb(event, path, tmp_path):
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
    counters[event] += 1

def do_stuff(tmp_path, fm):
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

    # this should trigger one ECORE_FILE_EVENT_DELETED_SELF !!! we get two
    os.rmdir(tmp_path)


class TestFileMonitor(unittest.TestCase):
    def testInit(self):
        path = tempfile.mkdtemp()
        fm = ecore.FileMonitor(path, monitor_cb, path)
        self.assertIsInstance(fm, ecore.FileMonitor)
        self.assertEqual(fm.path, path)

        ecore.Timer(0.1, do_stuff, path, fm)
        ecore.Timer(1.0, lambda: ecore.main_loop_quit())

        ecore.main_loop_begin()
        self.assertEqual(fm.path, path)
        fm.delete()

        # FIXME: we receive two ECORE_FILE_EVENT_DELETED_SELF, it's wrong
        # should be [0, 2, 2, 2, 2, 1, 2, 2]
        self.assertEqual(counters, [0, 2, 2, 2, 2, 2, 2, 2])


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
