#!/usr/bin/env python

import unittest
import os
import tempfile
import logging

from efl import ecore, ecore_con


TIMEOUT = 5.0 # seconds

class TestCon(unittest.TestCase):

    def testLookup(self):
        def _dns_complete(canonname, ip, sockaddr, arg1, my_karg):
            self.assertEqual(canonname, 'google-public-dns-a.google.com')
            self.assertEqual(ip, '8.8.8.8')
            self.assertEqual(arg1, "arg1")
            self.assertEqual(my_karg, 1234)
            self.complete = True
            ecore.main_loop_quit()

        self.complete = False
        ecore_con.Lookup('google-public-dns-a.google.com',
                          _dns_complete, "arg1", my_karg=1234)

        t = ecore.Timer(TIMEOUT, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertTrue(self.complete)

    def testUrl(self):
        self.complete_counter = 0
        self.progress_counter = 0
        self.exit_counter = 3 # we expect 3 complete cb calls
        self.test_url = 'http://www.example.com'
        self.received_data = []

        def _on_complete(event, add=1):
            self.assertIsInstance(event, ecore_con.EventUrlComplete)
            self.assertEqual(event.status, 200) # assume net is ok
            self.assertEqual(event.url.url, self.test_url)

            self.complete_counter += add
            self.exit_counter -= 1
            if self.exit_counter == 0:
                ecore.main_loop_quit()

        def _on_progress(event, param1, two, one):
            self.assertIsInstance(event, ecore_con.EventUrlProgress)
            self.assertEqual(param1, 'param1')
            self.assertEqual(one, 1)
            self.assertEqual(two, 2)
            self.progress_counter += 1

        def _on_data(event):
            self.assertIsInstance(event, ecore_con.EventUrlData)
            self.received_data.append(event.data)

        u = ecore_con.Url(self.test_url)
        self.assertIsInstance(u, ecore_con.Url)

        u.on_complete_event_add(_on_complete, add=100)
        u.on_complete_event_add(_on_complete, add=10)
        u.on_complete_event_del(_on_complete, add=100) #test event_del
        u.on_complete_event_add(_on_complete, add=1)
        u.on_complete_event_add(_on_complete, add=5)

        u.on_progress_event_add(_on_progress, 'param1', one=1, two=2)
        u.on_data_event_add(_on_data)

        self.assertTrue(u.get()) #perform the GET request

        t = ecore.Timer(TIMEOUT, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(u.status_code, 200) # assume net is ok
        self.assertEqual(self.complete_counter, 16)
        self.assertTrue(self.progress_counter > 0)

        data = b''.join(self.received_data)
        self.assertEqual(len(data), u.received_bytes)

        u.delete()

    def testUrlDelete(self):
        self.test_url1 = 'http://www.example.com'
        self.test_url2 = 'http://www.google.com'
        self.complete_counter = 0

        def _on_complete1(event):
            self.assertIsInstance(event, ecore_con.EventUrlComplete)
            self.assertEqual(event.url.url, self.test_url1)
            self.complete_counter += 1
            if self.complete_counter >= 11:
                ecore.main_loop_quit()

        def _on_complete2(event):
            self.assertIsInstance(event, ecore_con.EventUrlComplete)
            self.assertEqual(event.url.url, self.test_url2)
            self.complete_counter += 10
            if self.complete_counter >= 11:
                ecore.main_loop_quit()
            
        u1 = ecore_con.Url(self.test_url1)
        u1.on_complete_event_add(_on_complete1)

        u2 = ecore_con.Url(self.test_url2)
        u2.on_complete_event_add(_on_complete2)

        u3 = ecore_con.Url(self.test_url1)
        u3.on_complete_event_add(_on_complete1)
        u3.get() 
        u3.delete() # the previous get will not run

        self.assertTrue(u1.get()) #perform the GET request
        self.assertTrue(u2.get()) #perform the GET request

        t = ecore.Timer(TIMEOUT, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(u1.status_code, 200) # assume net is ok
        self.assertEqual(u2.status_code, 200) # assume net is ok
        self.assertEqual(self.complete_counter, 11)

        u1.delete()
        u2.delete()

    def testUrlToFile(self):
        self.test_url = 'http://www.example.com'
        self.complete = False

        def _on_complete(event):
            self.complete = True
            ecore.main_loop_quit()

        fd, path = tempfile.mkstemp()
        u = ecore_con.Url(self.test_url, fd=fd)
        u.on_complete_event_add(_on_complete)
        u.get()

        t = ecore.Timer(TIMEOUT, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(self.complete, True)
        self.assertEqual(u.status_code, 200) # assume net is ok
        self.assertEqual(os.path.getsize(path), u.received_bytes)
        os.unlink(path)

        u.delete()

    # def testFtp(self):
        # pass #TODO

    def testPost(self):
        self.test_url = 'https://httpbin.org/post'
        self.data_to_post = b'my data to post'

        def _on_complete(event):
            ecore.main_loop_quit()

        u = ecore_con.Url(self.test_url)
        u.on_complete_event_add(_on_complete)
        # u.post(self.data_to_post, "multipart/form-data")
        u.post(self.data_to_post, "text/txt")

        t = ecore.Timer(TIMEOUT, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        self.assertEqual(u.status_code, 200) # assume net is ok
        u.delete()

if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
