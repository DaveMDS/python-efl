#!/usr/bin/env python


import os
import unittest
import logging
import subprocess

from efl import ecore


script_path = os.path.dirname(os.path.realpath(__file__))
helper = os.path.join(script_path, "exe_helper.sh")


# basic read flags with line support
flags = ecore.ECORE_EXE_PIPE_READ | \
        ecore.ECORE_EXE_PIPE_READ_LINE_BUFFERED | \
        ecore.ECORE_EXE_TERM_WITH_PARENT


class TestExeSubprocess(unittest.TestCase):
    def testInit(self):
        self.exe_terminated = False
        self.num_lines_from_exe = 0
        self.num_lines_from_popen = 0
        self.check_output_tested = False
        self.call_tested = False

        # spawn a "slow" ecore.Exe child (will start on ml begin)
        exe = ecore.Exe("%s 0.001" % helper, flags)
        exe.on_add_event_add(self.on_exe_add)
        exe.on_data_event_add(self.on_exe_data)
        exe.on_del_event_add(self.on_exe_del)

        # start ml with a 5 secs timeout
        t = ecore.timer_add(15, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()

        # do the ecore exe terminate? (timeout not expired)
        self.assertEqual(self.exe_terminated, True)

        # do ecore exe received all the expected lines?
        self.assertEqual(self.num_lines_from_exe, 1000)

        # do the subprocess.call() test runs?
        self.assertEqual(self.call_tested, True)

        # do the subprocess.check_output() test runs?
        self.assertEqual(self.check_output_tested, True)

        # wait for the popen process to succesfully terminate
        out, err = self.proc.communicate()
        self.assertEqual(err, None)

        # do we received all the expected lines from popen?
        self.num_lines_from_popen += len(out.split())
        self.assertEqual(self.num_lines_from_popen, 1000)

    def on_exe_add(self, exe, event):
        self.assertIsInstance(event, ecore.EventExeAdd)

        # subprocess.call() in the middle of ecore.Exe (sync)
        ret = subprocess.call("%s 0.0 >/dev/null" % helper, shell=True)
        self.assertEqual(ret, 0)
        self.call_tested = True
        
        # subprocess.check_output() in the middle of ecore.Exe (sync)
        out = subprocess.check_output([helper, "0.0"])
        self.assertEqual(len(out.split()), 1000)
        self.check_output_tested = True

        # spawn a Popen child, will read it's output later (async)
        self.proc = subprocess.Popen([helper, "0.0"], stdout=subprocess.PIPE)

    def on_exe_data(self, exe, event):
        self.assertIsInstance(event, ecore.EventExeData)
        self.num_lines_from_exe += len(event.lines)

        # read a single line from the Popen process stdout
        self.proc.stdout.readline() # WARNING: this one is blocking
        self.num_lines_from_popen += 1

    def on_exe_del(self, exe, event):
        self.assertIsInstance(event, ecore.EventExeDel)
        self.exe_terminated = True
        ecore.main_loop_quit()


class TestExe(unittest.TestCase):
    def testInit(self):
        self.num_add = 0
        self.num_del = 0
        self.num_data = 0

        # EXE 1: simple ls -la output, monitor for add, del and data (stdout)
        def on_add(x, event, a, b, c):
            self.assertEqual(x, exe1)
            self.assertIsInstance(event, ecore.EventExeAdd)
            self.assertEqual(a, 1)
            self.assertEqual(b, 2)
            self.assertEqual(c, 3)
            self.num_add += 1

        def on_del(x, event):
            self.assertEqual(x, exe1)
            self.assertIsInstance(event, ecore.EventExeDel)
            self.num_del += 1

        def on_data(x, event):
            self.assertEqual(x, exe1)
            self.assertIsInstance(event, ecore.EventExeData)
            self.assertTrue(len(event.lines) >= 13) #we have at least 13 files here
            self.num_data += 1

        exe1 = ecore.Exe('ls -l "%s"' % script_path, flags)
        exe1.on_add_event_add(on_add, 1, c=3, b=2)
        exe1.on_del_event_add(on_del)
        exe1.on_data_event_add(on_data)

        # EXE 2: use C-api like event handler, will catch all 3 Exe() instances
        def catch_all_exe_add(event, pos1, pos2, karg1):
            self.assertIsInstance(event, ecore.EventExeAdd)
            self.assertEqual(pos1, "pos1")
            self.assertEqual(pos2, "pos2")
            self.assertEqual(karg1, "k")
            self.num_add += 1
            return ecore.ECORE_CALLBACK_RENEW

        def catch_all_exe_del(event):
            self.assertIsInstance(event, ecore.EventExeDel)
            self.num_del += 1
            return ecore.ECORE_CALLBACK_RENEW

        def catch_all_exe_data(event):
            self.assertIsInstance(event, ecore.EventExeData)
            self.num_data += 1
            return ecore.ECORE_CALLBACK_RENEW

        ecore.on_exe_add_event_add(catch_all_exe_add, "pos1", "pos2", karg1="k")
        ecore.on_exe_del_event_add(catch_all_exe_del)
        ecore.on_exe_data_event_add(catch_all_exe_data)
        exe2 = ecore.Exe('uname -a', flags)


        # EXE 3: start "cat", send data to it, then read, send again and kill
        def on_cat_pipe_add(x, event):
            self.assertEqual(x, exe3)
            self.assertIsInstance(event, ecore.EventExeAdd)
            x.send(b"123\nabc\nxyz\n")
            self.num_add += 1

        def on_cat_pipe_del(x, event):
            self.assertEqual(x, exe3)
            self.assertIsInstance(event, ecore.EventExeDel)
            
            self.num_del += 1

        def on_cat_pipe_data(x, event):
            self.assertEqual(x, exe3)
            self.assertIsInstance(event, ecore.EventExeData)
            self.assertEqual(event.lines, ["123", "abc", "xyz"])
            x.on_data_event_del(on_cat_pipe_data)
            self.num_data += 1

        def on_cat_pipe_data2(x, event):
            self.assertEqual(x, exe3)
            self.assertIsInstance(event, ecore.EventExeData)
            x.send("some\nmore\nlines!\n")
            if event.lines and event.lines[-1] == "lines!":
                x.on_data_event_del(on_cat_pipe_data2)
                x.kill()
            self.num_data += 1

        exe3 = ecore.Exe("cat", flags | ecore.ECORE_EXE_PIPE_WRITE)
        exe3.on_add_event_add(on_cat_pipe_add)
        exe3.on_del_event_add(on_cat_pipe_del)
        exe3.on_data_event_add(on_cat_pipe_data)
        exe3.on_data_event_add(on_cat_pipe_data2)


        # start everything (assuming 2 secs is enough for ls)
        t = ecore.timer_add(2, ecore.main_loop_quit)
        ecore.main_loop_begin()
        t.delete()


        # all the callback has been called?
        self.assertEqual(self.num_add, 5)
        self.assertEqual(self.num_del, 5)
        self.assertEqual(self.num_data, 8)


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
