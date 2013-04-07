#!/usr/bin/env python

import dbus
import json
from efl.dbus_mainloop import DBusEcoreMainLoop
from efl import ecore



def dprint(arg):
    print(json.dumps(arg, indent=2))


bus = dbus.SystemBus(mainloop=DBusEcoreMainLoop())

dprint(bus.list_names())

# ecore.main_loop_begin()
