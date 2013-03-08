#!/usr/bin/python

import os
import sys
import re
import subprocess
import argparse

def pkg_config(require, min_vers=None):
    name = require.capitalize()
    try:
        sys.stdout.write("Checking for " + name + ": ")
        ver = subprocess.check_output(["pkg-config", "--modversion", require]).decode("utf-8").strip()
        if min_vers is not None:
            assert 0 == subprocess.call(["pkg-config", "--atleast-version", min_vers, require])
        cflags = subprocess.check_output(["pkg-config", "--cflags", require]).decode("utf-8").split()
        sys.stdout.write("OK, found " + ver + "\n")
        return cflags
    except (OSError, subprocess.CalledProcessError):
        raise SystemExit("Failed to find" + name + "with 'pkg-config'.  Please make sure that it is installed and available on your system path.")
    except (AssertionError):
        raise SystemExit("Failed to match version. Found: " + ver + "  Needed: " + min_vers)

def get_capis(inc_path, prefix):
    capis = []

    for path, dirs, files in os.walk(inc_path):
        for f in files:
            with open(os.path.join(path, f), "r") as header:
                capi = header.read()
                matches = re.finditer("^ *EAPI [A-Za-z_ *\n]+(" + prefix + "_\w+)\(", capi, re.S|re.M)
                for match in matches:
                    func = match.group(1)
                    #print(func)
                    capis.append(func)
                    
    return capis

def get_pyapis(pxd_path, header_name, prefix):
    pyapis = []
                
    for path, dirs, files in os.walk(pxd_path):
        for f in files:
            if f.endswith(".pxd"):
                with open(os.path.join(path, f), "r") as pxd:
                    pyapi = pxd.read()
                    cdef = re.search('(cdef extern from "' + header_name + '\.h":\n)(.+)', pyapi, re.S)
                    if cdef:
                        matches = re.finditer("    .+(" + prefix + "_\w+)\(", cdef.group(2))
                        for match in matches:
                            func = match.group(1)
                            #print(func)
                            pyapis.append(func)
                            
    return pyapis

parser = argparse.ArgumentParser()
parser.add_argument("libs", nargs="+", help="Possible values are eo, evas, ecore, efile, edje, emotion, edbus, elementary and all.")
args = parser.parse_args()

if args.libs is "all":
    args.libs = ["eo", "evas", "ecore", "efile", "edje", "emotion", "edbus", "elementary"]

params = {
    "eo": ("include", "Eo", "eo"),
    "evas": ("include", "Evas", "evas"),
    "ecore": ("include", "Ecore", "ecore"),
    "efile": ("include", "Ecore_File", "ecore_file"),
    "edje": ("include", "Edje", "edje"),
    "emotion": ("include", "Emotion", "emotion"),
    "edbus2": ("efl/edbus", "EDBus", "edbus"),
    "elementary": ("efl/elementary", "Elementary", "elm"),
}

for key in args.libs:
    inc_path = pkg_config(key, "1.7.99")[0][2:]
    pxd_path, header_name, prefix = params[key]
    
    capis = get_capis(inc_path, prefix)
    pyapis = get_pyapis(pxd_path, header_name, prefix)
                            
    ecs = set(capis)
    eps = set(pyapis)
    differences = sorted(ecs.union(eps) - ecs.intersection(eps))
    for d in differences:
        if d in ecs:
            print("{0} is missing from py api".format(d))
        else:
            pass#print("{0} is missing from c api".format(d))
        
    print(header_name + " C api functions: {0}".format(len(ecs)))
    print(header_name + " py api functions: {0}".format(len(eps)))
