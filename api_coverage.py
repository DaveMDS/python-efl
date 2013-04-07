#!/usr/bin/python

import os
import sys
import re
import subprocess
import argparse

c_excludes = "\
elm_app|\
elm_widget|\
elm_prefs"

py_excludes = "\
elm_naviframe_item_simple_push|\
elm_object_item_content|\
elm_object_item_text|\
elm_object_content|\
elm_object_text"

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
    capi_pattern = re.compile("^ *EAPI [A-Za-z_ *\n]+ +\**(?!" + c_excludes + ")(" + prefix + "_\w+) *\(", flags = re.S|re.M)

    for path, dirs, files in os.walk(inc_path):
        for f in files:
            if sys.version_info[0] < 3:
                header = open(os.path.join(path, f), mode="r")
            else:
                header = open(os.path.join(path, f), encoding="UTF-8", mode="r")

            capi = header.read()

            matches = re.finditer(capi_pattern, capi)
            for match in matches:
                func = match.group(1)
                capis.append(func)

            header.close()

    return capis

def get_pyapis(pxd_path, header_name, prefix):
    pyapis = []
    pyapi_pattern1 = re.compile('(cdef extern from "' + header_name + '\.h":\n)(.+)', flags = re.S)
    pyapi_pattern2 = re.compile("^    [a-zA-Z _*]+?(?!" + py_excludes + ")(" + prefix + "_\w+)\(", flags = re.M)

    for path, dirs, files in os.walk(pxd_path):
        for f in files:
            if f.endswith(".pxd"):
                if sys.version_info[0] < 3:
                    pxd = open(os.path.join(path, f), mode="r")
                else:
                    pxd = open(os.path.join(path, f), encoding="UTF-8", mode="r")

                pyapi = pxd.read()

                cdef = re.search(pyapi_pattern1, pyapi)
                if cdef:
                    matches = re.finditer(pyapi_pattern2, cdef.group(2))
                    for match in matches:
                        func = match.group(1)
                        pyapis.append(func)

                pxd.close()

    return pyapis

parser = argparse.ArgumentParser()
parser.add_argument("--python", action="store_true", default=False, help="Show Python API coverage")
parser.add_argument("--c", action="store_true", default=False, help="Show C API coverage")
parser.add_argument("libs", nargs="+", help="Possible values are eo, evas, ecore, ecore-file, edje, emotion, edbus, elementary and all.")
args = parser.parse_args()

if args.libs is "all":
    args.libs = ["eo", "evas", "efreet", "ecore", "efile", "edje", "emotion", "edbus", "elementary"]

params = {
    "eo": ("include", "Eo", "eo"),
    "evas": ("include", "Evas", "evas"),
    "ecore": ("include", "Ecore", "ecore"),
    "ecore-file": ("include", "Ecore_File", "ecore_file"),
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
    differences = ecs.union(eps) - ecs.intersection(eps)

    for d in sorted(differences):
        if args.python and d in ecs:
            print("{0} is missing from Python API".format(d))
        if args.c and d in eps:
            print("{0} is missing from C API".format(d))

    if args.python or args.c: print("\n---")

    if args.python:
        print("Number of functions missing from Python API: {0}".format(len(ecs - ecs.intersection(eps))))
    if args.c:
        print("Number of functions missing from C API: {0}".format(len(eps - ecs.intersection(eps))))

    if args.python or args.c: print("---")

    if args.python:
        print("Python API functions: {0}".format(len(eps)))
    if args.c:
        print("C API functions: {0}".format(len(ecs)))

    if args.python and len(ecs) > 0:
        percentage = float(len(ecs.intersection(eps))) / float(len(ecs)) * 100.0
        print("===")
        print("Bindings coverage {0:.2f}%".format(percentage))

    if args.python or args.c: print("---\n")
