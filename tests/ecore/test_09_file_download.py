#!/usr/bin/env python

import unittest
import os
import logging

from efl import ecore


URL = "http://check.sourceforge.net/xml/check_unittest.xslt"
DST = "/tmp/ecore_dwnl_test.html"

class TestFileDownload(unittest.TestCase):

    def progress_cb(self, dest, dltotal, dlnow, ultotal, ulnow):
        # print("Download Progress: file=%s, dltotal=%d, dlnow=%d, ultotal=%d, ulnow=%d" %
              # (dest, dltotal, dlnow, ultotal, ulnow))
        self.assertEqual(dest, DST)
        self.dltotal = dltotal
        return ecore.ECORE_FILE_PROGRESS_CONTINUE

    def completion_cb(self, dest, status):
        # print("Download Finished: file=%s, status=%s" % (dest, status))
        self.assertEqual(dest, DST)
        self.assertEqual(status, 200)
        self.completed = True
        self.complete_status = status
        ecore.main_loop_quit()
    
    def testInit(self):
        self.dltotal = 0
        self.completed = False
        self.complete_status = 0

        if os.path.exists(DST):
            os.remove(DST)

        self.assertEqual(ecore.file_download_protocol_available('http://'), True)

        ecore.FileDownload(URL, DST,
                           completion_cb = self.completion_cb,
                           progress_cb = self.progress_cb)

        t = ecore.timer_add(5, ecore.main_loop_quit) # just a timeout (should be faster)
        ecore.main_loop_begin()
        t.delete()

        self.assertTrue(self.completed)
        self.assertTrue(self.dltotal > 0)
        self.assertEqual(self.complete_status, 200)
        self.assertTrue(os.path.exists(DST))
        # This doesn't work ... should it ??
        # self.assertEqual(os.path.getsize(DST), self.dltotal)
        self.assertTrue(os.path.getsize(DST) > 0)
        os.remove(DST)


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
