#!/usr/bin/env python

from efl import ecore
import unittest
import os


def _completion_cb(dest, status):
    print("Download Finished: file=%s, status=%s" % (dest, status))
    ecore.main_loop_quit()

def _progress_cb(dest, dltotal, dlnow, ultotal, ulnow):
    print("Download Progress: file=%s, dltotal=%d, dlnow=%d, ultotal=%d, ulnow=%d" %
          (dest, dltotal, dlnow, ultotal, ulnow))
    return ecore.ECORE_FILE_PROGRESS_CONTINUE


class TestFileDownload(unittest.TestCase):
    def testInit(self):
        dst = "/tmp/ecore_dwnl_test.html"
        if os.path.exists(dst):
            os.remove(dst)

        self.assertEqual(ecore.file_download_protocol_available('http://'), True)

        ecore.FileDownload("http://www.google.com", dst,
                            completion_cb = _completion_cb,
                            progress_cb = _progress_cb)
        
        ecore.main_loop_begin()
        


if __name__ == '__main__':
    unittest.main(verbosity=2)
    ecore.shutdown()
