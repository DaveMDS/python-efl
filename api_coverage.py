#!/usr/bin/python

import os
import sys
import re
import subprocess

def pkg_config(name, require, min_vers=None):
    try:
        sys.stdout.write("Checking for " + name + ": ")
        ver = subprocess.check_output(["pkg-config", "--modversion", require]).decode("utf-8").strip()
        if min_vers is not None:
            assert 0 == subprocess.call(["pkg-config", "--atleast-version", min_vers, require])
        cflags = subprocess.check_output(["pkg-config", "--cflags", require]).decode("utf-8").split()
        libs = subprocess.check_output(["pkg-config", "--libs", require]).decode("utf-8").split()
        sys.stdout.write("OK, found " + ver + "\n")
        return (cflags, libs)
    except (OSError, subprocess.CalledProcessError):
        raise SystemExit("Failed to find Evas with 'pkg-config'.  Please make sure that it is installed and available on your system path.")
    except (AssertionError):
        raise SystemExit("Failed to match version. Found: " + ver + "  Needed: " + min_vers)

eo_cflags, eo_libs = pkg_config('Eo', 'eo', "1.7.99")
evas_cflags, evas_libs = pkg_config('Evas', 'evas', "1.7.99")
ecore_cflags, ecore_libs = pkg_config('Ecore', 'ecore', "1.7.99")
efile_cflags, efile_libs = pkg_config('EcoreFile', 'ecore-file', "1.7.99")
edje_cflags, edje_libs = pkg_config('Edje', 'edje', "1.7.99")
emotion_cflags, emotion_libs = pkg_config('Emotion', 'emotion', "1.7.99")
edbus_cflags, edbus_libs = pkg_config('EDBus', 'edbus2', "1.7.99")
elm_cflags, elm_libs = pkg_config('Elementary', 'elementary', "1.7.99")

elm_capis = []
elm_pyapis = []

elm_inc = elm_cflags[0]
elm_inc = elm_inc[2:]
for path, dirs, files in os.walk(elm_inc):
    for f in files:
        with open(os.path.join(path, f), "r") as header:
            capi = header.read()
            matches = re.finditer("^ *EAPI [A-Za-z_ *\n]+(elm_\w+)\(", capi, re.S|re.M)
            for match in matches:
                func = match.group(1)
                #print(func)
                elm_capis.append(func)
                
for path, dirs, files in os.walk("efl/elementary"):
    for f in files:
        if f.endswith(".pxd"):
            with open(os.path.join(path, f), "r") as pxd:
                pyapif = pxd.read()
                cdef = re.search('(cdef extern from "Elementary\.h":\n)(.+)', pyapif, re.S)
                if cdef:
                    matches = re.finditer("    .+(elm_\w+)\(", cdef.group(2))
                    for match in matches:
                        func = match.group(1)
                        #print(func)
                        elm_pyapis.append(func)
                        
ecs = set(elm_capis)
eps = set(elm_pyapis)
print("C api functions: {0}".format(len(ecs)))
print("py api functions: {0}".format(len(eps)))
differences = sorted(ecs.union(eps) - ecs.intersection(eps))
for d in differences:
    if d in ecs:
        print("{0} is missing from py api".format(d))
    else:
        pass#print("{0} is missing from c api".format(d))