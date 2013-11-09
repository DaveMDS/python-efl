#!/usr/bin/python

import os
import sys
import re
import subprocess
import argparse

c_exclude_list = [
    "elm_app", # These are only useful for C apps
    "elm_widget", # Custom widgets, probably not feasible for us to provide
    "elm_quicklaunch", # Is quicklaunch relevant for us?
    "emotion_object_extension_may_play_fast_get", # this optimization does not work from py
    "edje_edit_", # Disabled
    "ecore_thread_", # python has his own thread abstraction library
    "ecore_pipe_", # python has his own pipe abstraction library
    "ecore_getopt_", # python has his own getopt implementation
    "ecore_coroutine_", # python has someting similar...maybe
    "ecore_fork_", # low level stuff, not to be exposed
    "ecore_timer_dump", # this is just usefull for debugging
    "ecore_throttle_", # I don't know what this is :/  - davemds
    "elm_check_state_pointer_set", # Cannot be implemented in Python
    "elm_access", # Access disabled until 1.9
    "elm_config_access", # Access disabled until 1.9
    "elm_object_item_access", # Access disabled until 1.9
]
c_excludes = "|".join(c_exclude_list)

py_exclude_list = [
    "elm_naviframe_item_simple_push", # macro
    "elm_object_item_content", # macro
    "elm_object_item_text", # macro
    "elm_object_content", # macro
    "elm_object_text", # macro
    "elm_layout_end", # macros
    "elm_layout_icon", # macros
    "elm_object_domain_translatable_text", # macros
    "elm_object_tooltip_translatable_text", # macros
    "elm_object_translatable_text", # macros
    "elm_access", # Access disabled until 1.9
    "elm_config_access", # Access disabled until 1.9
    "elm_object_item_access", # Access disabled until 1.9
]
py_excludes = "|".join(py_exclude_list)

parser = argparse.ArgumentParser()
parser.add_argument("--python", action="store_true", default=False, help="Show Python API coverage")
parser.add_argument("--c", action="store_true", default=False, help="Show C API coverage")
parser.add_argument("libs", nargs="+", help="Possible values are eo, evas, ecore, ecore-file, edje, emotion, elementary and all.")
args = parser.parse_args()

libs = args.libs[:]

if libs == ["all"]:
    libs = ["eo", "evas", "ecore", "ecore-file", "edje", "emotion", "elementary"]

params = {
    "eo": ("include", "Eo", "eo"),
    "evas": ("include", "Evas", "evas"),
    "ecore": ("include", "Ecore", "ecore"),
    "ecore-file": ("include", "Ecore_File", "ecore_file"),
    "edje": ("include", "Edje", "edje"),
    "emotion": ("include", "Emotion", "emotion"),
    "elementary": ("efl/elementary", "Elementary", "elm"),
}

def pkg_config(require, min_vers=None):
    name = require.capitalize()
    try:
        sys.stdout.write("Checking for " + name + ": ")
        ver = subprocess.check_output(["pkg-config", "--modversion", require]).decode("utf-8").strip()
        if min_vers is not None:
            assert 0 == subprocess.call(["pkg-config", "--atleast-version", min_vers, require])
        cflags = subprocess.check_output(["pkg-config", "--cflags-only-I", require]).decode("utf-8").split()
        sys.stdout.write("OK, found " + ver + "\n")
        return cflags
    except (OSError, subprocess.CalledProcessError):
        raise SystemExit("Failed to find" + name + "with 'pkg-config'.  Please make sure that it is installed and available on your system path.")
    except (AssertionError):
        raise SystemExit("Failed to match version. Found: " + ver + "  Needed: " + min_vers)

def get_capis(inc_path, prefix):
    capis = []
    capi_pattern = re.compile("^ *EAPI [A-Za-z_ *\n]+ *\**\n?(?!" + c_excludes + ")(" + prefix + "_\w+) *\(", flags = re.S|re.M)

    for path, dirs, files in os.walk(inc_path):
        for f in files:
            open_args = (os.path.join(path, f),)
            open_kwargs = dict(mode="r")
            if sys.version_info[0] > 2: open_kwargs["encoding"] = "UTF-8"

            with open(*open_args, **open_kwargs) as header:
                capi = header.read()

                matches = re.finditer(capi_pattern, capi)
                for match in matches:
                    func = match.group(1)
                    capis.append(func)

    return capis

def get_pyapis(pxd_path, header_name, prefix):
    pyapis = []
    pyapi_pattern1 = re.compile('(cdef extern from "' + header_name + '\.h":\n)(.+)', flags = re.S)
    pyapi_pattern2 = re.compile("^ +[a-zA-Z _*]+?(?!" + py_excludes + ")(" + prefix + "_\w+)\(", flags = re.M)

    for path, dirs, files in os.walk(pxd_path):
        for f in files:
            if f.endswith(".pxd"):
                open_args = (os.path.join(path, f),)
                open_kwargs = dict(mode="r")
                if sys.version_info[0] > 2: open_kwargs["encoding"] = "UTF-8"

                with open(*open_args, **open_kwargs) as pxd:
                    pyapi = pxd.read()

                    cdef = re.search(pyapi_pattern1, pyapi)
                    if cdef:
                        matches = re.finditer(pyapi_pattern2, cdef.group(2))
                        for match in matches:
                            func = match.group(1)
                            pyapis.append(func)

    return pyapis


for lib in libs:

    inc_paths = pkg_config(lib, "1.7.99")
    inc_path = None
    for p in inc_paths:
        if lib in p:
            inc_path = p[2:]
            break

    if inc_path is None:
        raise SystemExit

    pxd_path, header_name, prefix = params[lib]

    capis = get_capis(inc_path, prefix)
    pyapis = get_pyapis(pxd_path, header_name, prefix)

    capis = set(capis)
    pyapis = set(pyapis)
    differences = capis.union(pyapis) - capis.intersection(pyapis)

    for d in sorted(differences):
        if args.python and d in capis:
            print("{0} is missing from Python API".format(d))
        if args.c and d in pyapis:
            print("{0} is missing from C API".format(d))

    if args.python or args.c: print("\n---")

    if args.python:
        print("Number of functions missing from Python API: {0}".format(len(capis - capis.intersection(pyapis))))
    if args.c:
        print("Number of functions missing from C API: {0}".format(len(pyapis - capis.intersection(pyapis))))

    if args.python or args.c: print("---")

    if args.python:
        print("Python API functions: {0}".format(len(pyapis)))
    if args.c:
        print("C API functions: {0}".format(len(capis)))

    if args.python and len(capis) > 0:
        percentage = float(len(capis.intersection(pyapis))) / float(len(capis)) * 100.0
        print("===")
        print("Bindings coverage {0:.2f}%".format(percentage))

    if args.python or args.c: print("---\n")
