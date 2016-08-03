#!/usr/bin/env python

import dbus
import dbus.service
from efl.dbus_mainloop import DBusEcoreMainLoop
from efl import ecore
import unittest
import logging


class TestDBusBasics(unittest.TestCase):
    def setUp(self):
        self.bus = dbus.SessionBus(mainloop=DBusEcoreMainLoop())

    def tearDown(self):
        pass

    def testSignalReceiver(self):
        self.received = False

        def name_owner_changed_cb(name, old_owner, new_owner):
            if name == "org.efl.TestService":
                # name received...good, quit the test now!
                self.received = True
                ecore.main_loop_quit()

        # receive notification on name changes
        self.bus.add_signal_receiver(name_owner_changed_cb,
                                     signal_name="NameOwnerChanged")

        # claim the name 'org.efl.TestService'
        self.name = dbus.service.BusName("org.efl.TestService", self.bus)

        # start the ecore mainloop and wait at max 1.5 seconds
        ecore.Timer(1.5, lambda: ecore.main_loop_quit())
        ecore.main_loop_begin()

        # did we received the signal ?
        self.assertTrue(self.received)


if __name__ == '__main__':
    formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    efllog = logging.getLogger("efl")
    efllog.addHandler(handler)
    efllog.setLevel(logging.DEBUG)
    unittest.main(verbosity=2)
