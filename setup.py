#! /usr/bin/env python

import sys
import subprocess
from distutils.core import setup
from distutils.extension import Extension

try:
    from Cython.Distutils import build_ext
    import Cython.Compiler.Options

    Cython.Compiler.Options.fast_fail = True # stop compilation on first error
except ImportError:
    raise SystemExit("Requires Cython (http://cython.org/)")


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



## This is usefull while working on the source, to force the rebuild of modules.
# subprocess.call("rm -rfv efl/*/*.c", shell=True)
# subprocess.call("rm -rfv efl/eo/*.c", shell=True)
# subprocess.call("rm -rfv efl/evas/*.c", shell=True)
# subprocess.call("rm -rfv efl/ecore/*.c", shell=True)
# subprocess.call("rm -rfv efl/edje/*.c", shell=True)
# subprocess.call("rm -rfv efl/emotion/*.c", shell=True)
# subprocess.call("rm -rfv efl/elementary/*.c", shell=True)


modules = []

# Eo
eo_cflags, eo_libs = pkg_config('Eo', 'eo', "1.7.99")
eo_ext = Extension("efl.eo", ["efl/eo/efl.eo.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = eo_cflags,
                        extra_link_args = eo_libs)
modules.append(eo_ext)

# Evas
evas_cflags, evas_libs = pkg_config('Evas', 'evas', "1.7.99")
evas_ext = Extension("efl.evas", ["efl/evas/efl.evas.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = evas_cflags,
                        extra_link_args = evas_libs)
modules.append(evas_ext)

# Ecore
ecore_cflags, ecore_libs = pkg_config('Ecore', 'ecore', "1.7.99")
efile_cflags, efile_libs = pkg_config('EcoreFile', 'ecore-file', "1.7.99")
ecore_ext = Extension("efl.ecore", ["efl/ecore/efl.ecore.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = ecore_cflags + efile_cflags,
                        extra_link_args = ecore_libs + efile_libs)
modules.append(ecore_ext)

# Edje
edje_cflags, edje_libs = pkg_config('Edje', 'edje', "1.7.99")
edje_ext = Extension("efl.edje", ["efl/edje/efl.edje.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = edje_cflags,
                        extra_link_args = edje_libs)
modules.append(edje_ext)

# Emotion
emotion_cflags, emotion_libs = pkg_config('Emotion', 'emotion', "1.7.99")
emotion_ext = Extension("efl.emotion", ["efl/emotion/efl.emotion.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = emotion_cflags,
                        extra_link_args = emotion_libs)
modules.append(emotion_ext)

# Elementary
elm_cflags, elm_libs = pkg_config('Elementary', 'elementary', "1.7.99")
elm_ext = Extension("efl.elementary", ["efl/elementary/efl.elementary.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = elm_cflags,
                        extra_link_args = elm_libs)
modules.append(elm_ext)


if __name__ == "__main__":
    setup(
        name = "efl",
        version = "1.7.99",
        author = "Davide <davemds> Andreoli",
        author_email = "dave@gurumeditation.it",
        maintainer = "Davide <davemds> Andreoli",
        maintainer_email = "dave@gurumeditation.it",
        url = "http://www.enlightenment.org",
        description = "Python bindings for the EFL stack",
        license = "GNU Lesser General Public License (LGPL)",
        packages = ["efl"],
        cmdclass = {"build_ext": build_ext},
        ext_modules = modules
    )
