#!/usr/bin/env python
# encoding: utf-8

import os
import sys
import logging

from efl import ecore
from efl import ethumb_client as ethumb

script_path = os.path.dirname(os.path.abspath(__file__))


# parse command line arguments
if len(sys.argv) != 2:
    print("Python EthumbClient test application.\n\n" \
          "usage: ethumb_client.py filename\n")
    exit(1)
filename = sys.argv[1]
print("Original file: %s\n" % filename)


# setup efl logging (you also need to set EINA_LOG_LEVEL=X)
l = logging.getLogger("efl")
h = logging.StreamHandler()
h.setFormatter(logging.Formatter("EFL %(levelname)s %(message)s"))
l.addHandler(h)
l.setLevel(logging.DEBUG)

complete_count = 0

def generate_cb(client, id, file, key, thumb_path, thumb_key, success, num):
    global complete_count

    # thumbnail completed
    if success is True:
        print("Thumb #%d completed: '%s'" % (num, thumb_path))
        complete_count += 1
        if complete_count >= 6:
            print("\nTest Complete!")
            ecore.main_loop_quit()
    else:
        print("   ERROR! aborting.")
        ecore.main_loop_quit()

def connect_cb(client, success):
    if success is False:
        print("Connection Failed")
        ecore.main_loop_quit()
        return
    else:
        print("Connection Successfull")

    # request some thumbnails
    print("1. Request a standard FDO thumbnail (default)")
    et.file = filename
    et.generate(generate_cb, 1)

    print("2. Request a large FDO thumbnail...")
    et.file = filename
    et.fdo = ethumb.ETHUMB_THUMB_LARGE
    et.generate(generate_cb, 2)

    print("3. Request a very large JPEG thumbnail...")
    et.file = filename
    et.format = ethumb.ETHUMB_THUMB_JPEG
    et.size = 512, 512
    et.generate(generate_cb, 3)

    print("4. Request a cropped thumbnail...")
    et.file = filename
    et.aspect = ethumb.ETHUMB_THUMB_CROP
    et.generate(generate_cb, 4)

    print("5. Request a rotated thumbnail")
    et.file = filename
    et.orientation = ethumb.ETHUMB_THUMB_ROTATE_180
    et.size = 256, 256
    et.aspect = ethumb.ETHUMB_THUMB_KEEP_ASPECT
    et.generate(generate_cb, 5)

    print("6. Request a poor quality thumbnail in this folder\n")
    et.file = filename
    et.orientation = ethumb.ETHUMB_THUMB_ORIENT_NONE
    et.thumb_path = os.path.join(script_path, 'big_poor2.jpg')
    et.format = ethumb.ETHUMB_THUMB_JPEG
    et.size = 512, 512
    et.quality = 10
    et.generate(generate_cb, 6)

    # ...and now wait for the responses


def server_die_cb(client):
    print("Server die!")
    ecore.main_loop_quit()


# create a single Ethumb instance
et = ethumb.EthumbClient(connect_cb)
et.on_server_die_callback_set(server_die_cb)



# enter the ecore the main loop
ecore.main_loop_begin()

# free used resource
et.disconnect()

