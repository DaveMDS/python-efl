#!/usr/bin/env python
# encoding: utf-8

import os
import sys
import time
import logging

from efl import ecore
from efl import ethumb


script_path = os.path.dirname(os.path.abspath(__file__))

TESTS = [
    ("1. Generating a standard FDO thumbnail (default)...", {}),
    ("2. Generating a large FDO thumbnail...", {
        'thumb_fdo': ethumb.ETHUMB_THUMB_LARGE,
    }),
    ("3. Generating a very large JPG thumbnail...", {
        'thumb_format': ethumb.ETHUMB_THUMB_JPEG,
        'thumb_size': (512, 512),
    }),
    ("4. Generating a cropped thumbnail...", {
        'thumb_aspect': ethumb.ETHUMB_THUMB_CROP,
    }),
    ("5. Generating a rotated thumbnail...", {
        'thumb_orientation': ethumb.ETHUMB_THUMB_ROTATE_180,
        'thumb_size': (256, 256),
        'thumb_aspect': ethumb.ETHUMB_THUMB_KEEP_ASPECT,
    }),
    ("6. Generating a poor quality thumbnail in this folder...", {
        'thumb_orientation': ethumb.ETHUMB_THUMB_ORIENT_NONE,
        'thumb_path': os.path.join(script_path, 'big_poor.jpg'),
        'thumb_format': ethumb.ETHUMB_THUMB_JPEG,
        'thumb_size': (512, 512),
        'thumb_quality': 10,
    }),
]


# parse command line arguments
if len(sys.argv) != 2:
    print("Python Ethumb test application.\n\n" \
          "usage: ethumb.py filename\n")
    exit(1)
filename = sys.argv[1]
print("Original file: %s\n" % filename)


# setup efl logging (you also need to set EINA_LOG_LEVEL=X)
l = logging.getLogger("efl")
h = logging.StreamHandler()
h.setFormatter(logging.Formatter("EFL %(levelname)s %(message)s"))
l.addHandler(h)
l.setLevel(logging.DEBUG)


# create a single Ethumb instance
et = ethumb.Ethumb()
in_progress = False
start_time = 0.0



def generate_cb(et, success):
    global in_progress

    # thumbnail completed
    if success is True:
        # print out the result
        print("   Completed in %.3f seconds." % (time.time() - start_time))
        print("   Thumb: '%s'\n" % et.thumb_path[0])
    else:
        print("   ERROR! aborting.")
        ecore.main_loop_quit()
    in_progress = False


def start_thumb(label, params):
    global in_progress
    global start_time

    # setup ethumb params
    et.file = filename
    for name, val in params.items():
        setattr(et, name, val)

    # print test name and keep track of start time
    print(label)
    start_time = time.time()

    # start the thumbnailing process
    ret = et.generate(generate_cb) # TODO test args and kargs
    if ret is False:
        print("Error starting the thumbnailer!")
        ecore.main_loop_quit()
    else:
        in_progress = True


def idler_cb():
    # Ethumb cannot generate more than one thumb at the same time
    if in_progress:
        return ecore.ECORE_CALLBACK_RENEW

    try:
        # advance to the next test
        label, params = TESTS.pop(0)
        start_thumb(label, params)
    except IndexError:
        # all done, quit.
        print("Test Completed!")
        ecore.main_loop_quit()

    return ecore.ECORE_CALLBACK_RENEW


# start the idler and the main loop
idler = ecore.Idler(idler_cb)
ecore.main_loop_begin()

# free used resource
et.delete()
