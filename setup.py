#! /usr/bin/env python
# encoding: utf-8

import os
import sys
import subprocess
from distutils.core import setup, Command
from distutils.extension import Extension
from distutils.version import StrictVersion, LooseVersion
from efl import __version_info__ as vers

script_path = os.path.dirname(os.path.abspath(__file__))


# python-efl version (change in efl/__init__.py)
RELEASE = "%d.%d.%d" % (vers[0], vers[1], vers[2])
VERSION = "%d.%d" % (vers[0], vers[1] if vers[2] < 99 else vers[1] + 1)

# dependencies
CYTHON_MIN_VERSION = "0.19"
EFL_MIN_VERSION = RELEASE
ELM_MIN_VERSION = RELEASE


# Add git commit count for dev builds
if vers[2] == 99:
    try:
        call = subprocess.Popen(
            ["git", "log", "--oneline"], stdout=subprocess.PIPE)
        out, err = call.communicate()
    except Exception:
        RELEASE += "a0"
    else:
        log = out.decode("utf-8").strip()
        if log:
            ver = log.count("\n")
            RELEASE += "a" + str(ver)
        else:
            RELEASE += "a0"

# XXX: Force default visibility. See phab T504
if os.getenv("CFLAGS") is not None and "-fvisibility=" in os.environ["CFLAGS"]:
    os.environ["CFLAGS"] += " -fvisibility=default"


# === Sphinx ===
try:
    from sphinx.setup_command import BuildDoc
except ImportError:
    class BuildDoc(Command):
        description = \
            "build documentation using sphinx, that must be installed."
        version = ""
        release = ""
        user_options = []

        def initialize_options(self):
            pass

        def finalize_options(self):
            pass

        def run(self):
            print("Error: sphinx not found")


# === pkg-config ===
def pkg_config(name, require, min_vers=None):
    try:
        sys.stdout.write("Checking for " + name + ": ")

        call = subprocess.Popen(
            ["pkg-config", "--modversion", require], stdout=subprocess.PIPE)
        out, err = call.communicate()
        ver = out.decode("utf-8").strip()

        if min_vers is not None:
            assert 0 == subprocess.call(
                ["pkg-config", "--atleast-version", min_vers, require])

        call = subprocess.Popen(
            ["pkg-config", "--cflags", require], stdout=subprocess.PIPE)
        out, err = call.communicate()
        cflags = out.decode("utf-8").split()

        call = subprocess.Popen(
            ["pkg-config", "--libs", require], stdout=subprocess.PIPE)
        out, err = call.communicate()
        libs = out.decode("utf-8").split()

        sys.stdout.write("OK, found " + ver + "\n")

        cflags = list(set(cflags))

        return (cflags, libs)
    except (OSError, subprocess.CalledProcessError):
        raise SystemExit("Did not find " + name + " with 'pkg-config'.")
    except (AssertionError):
        raise SystemExit(
            name + " version mismatch. Found: " + ver + "  Needed: " + min_vers
        )


# use cython or pre-generated c files

if os.getenv("DISABLE_CYTHON"):
    module_suffix = ".c"
    from distutils.command.build_ext import build_ext

    def cythonize(modules, *args, **kwargs):
        return modules
else:
    try:
        from Cython.Distutils import build_ext
        from Cython.Build import cythonize
        import Cython.Compiler.Options
    except ImportError:
        if not os.path.exists(os.path.join(script_path, "efl/eo/efl.eo.c")):
            raise SystemExit(
                "Requires Cython >= %s (http://cython.org/)" % (
                    CYTHON_MIN_VERSION
                    )
                )
        module_suffix = ".c"
        from distutils.command.build_ext import build_ext

        def cythonize(modules, *args, **kwargs):
            return modules
    else:
        module_suffix = ".pyx"
        try:
            try:
                assert StrictVersion(Cython.__version__) >= \
                    StrictVersion(CYTHON_MIN_VERSION)
            except ValueError:
                print("""
Your Cython version string (%s) is weird. We'll attempt to
check that it's higher than the minimum required: %s, but
this is unreliable.\n
If you run into any problems during or after installation it
may be caused by version of Cython that's too old.""" % (
                    Cython.__version__, CYTHON_MIN_VERSION
                    )
                )
                assert LooseVersion(Cython.__version__) >= \
                    LooseVersion(CYTHON_MIN_VERSION)
        except AssertionError:
            raise SystemExit(
                "Requires Cython >= %s (http://cython.org/)" % (
                    CYTHON_MIN_VERSION
                    )
                )

        # Cython 0.21.1 PyMethod_New() is broken! blacklisted
        if Cython.__version__ == "0.21.1":
            raise SystemExit("Cython 0.21.1 is broken! Use another release.")

        Cython.Compiler.Options.fast_fail = True    # Stop compilation on first
                                                    #  error
        Cython.Compiler.Options.annotate = False    # Generates HTML files with
                                                    #  annotated source
        Cython.Compiler.Options.docstrings = True   # Set to False to disable
                                                    #  docstrings


class CleanGenerated(Command):
    description = "Clean C and html files generated by Cython"
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        for lib in ("eo", "evas", "ecore", "edje", "edje/edit", "emotion",
                    "elementary", "utils"):
            for root, dirs, files in \
                    os.walk(os.path.join(script_path, "efl", lib)):
                for f in files:
                    if f.endswith(".c") or f.endswith(".html"):
                        path = os.path.join(root, f)
                        os.remove(path)
        dbus_ml_path = os.path.join(
            script_path, "efl", "dbus_mainloop", "dbus_mainloop.c")
        if os.path.exists(dbus_ml_path):
            os.remove(dbus_ml_path)


modules = []
packages = ["efl"]
#package_dirs = {}  # Use this if you put packages in non-root paths

if set(("build", "build_ext", "install", "bdist", "sdist")) & set(sys.argv):

    # === Eina ===
    eina_cflags, eina_libs = pkg_config('Eina', 'eina', EFL_MIN_VERSION)

    # === Eo ===
    eo_cflags, eo_libs = pkg_config('Eo', 'eo', EFL_MIN_VERSION)
    eo_ext = Extension(
        "eo", ["efl/eo/efl.eo" + module_suffix],
        define_macros=[('EFL_BETA_API_SUPPORT', None)],
        include_dirs=['include/'],
        extra_compile_args=eo_cflags,
        extra_link_args=eo_libs + eina_libs
    )
    modules.append(eo_ext)

    # === Utilities ===
    utils_ext = [
        Extension(
            "utils.deprecated", ["efl/utils/deprecated" + module_suffix],
            include_dirs=['include/'],
            extra_compile_args=eina_cflags,
            extra_link_args=eina_libs
        ),
        Extension(
            "utils.conversions", ["efl/utils/conversions" + module_suffix],
            include_dirs=['include/'],
            extra_compile_args=eo_cflags,
            extra_link_args=eo_libs + eina_libs,
        ),
        Extension(
            "utils.logger", ["efl/utils/logger" + module_suffix],
            include_dirs=['include/'],
            extra_compile_args=eina_cflags,
            extra_link_args=eina_libs,
        ),
    ]
    modules += utils_ext
    packages.append("efl.utils")

    # === Evas ===
    evas_cflags, evas_libs = pkg_config('Evas', 'evas', EFL_MIN_VERSION)
    evas_ext = Extension(
        "evas", ["efl/evas/efl.evas" + module_suffix],
        include_dirs=['include/'],
        extra_compile_args=evas_cflags,
        extra_link_args=evas_libs + eina_libs,
    )
    modules.append(evas_ext)

    # === Ecore ===
    ecore_cflags, ecore_libs = pkg_config('Ecore', 'ecore', EFL_MIN_VERSION)
    ecore_file_cflags, ecore_file_libs = pkg_config(
        'EcoreFile', 'ecore-file', EFL_MIN_VERSION)
    ecore_exts = [
        Extension(
            "ecore.__init__", ["efl/ecore/__init__" + module_suffix],
            include_dirs=['include/'],
            extra_compile_args=list(set(ecore_cflags + ecore_file_cflags)),
            extra_link_args=ecore_libs + ecore_file_libs + eina_libs +
            evas_libs
        ),
        ]
    try:
        ecore_input_cflags, ecore_input_libs = pkg_config(
            'EcoreInput', 'ecore-input', EFL_MIN_VERSION)
        ecore_x_cflags, ecore_x_libs = pkg_config(
            'EcoreX', 'ecore-x', EFL_MIN_VERSION)
    except SystemExit:  # FIXME: Change pkg-config to return a value
        pass
    else:
        ecore_exts.append(
            Extension(
                "ecore.x", ["efl/ecore/x" + module_suffix],
                include_dirs=['include/'],
                extra_compile_args=
                list(set(
                    ecore_cflags + ecore_file_cflags + ecore_x_cflags +
                    ecore_input_cflags
                    )),
                extra_link_args=
                ecore_libs + ecore_file_libs + ecore_x_libs +
                ecore_input_libs +
                eina_libs + evas_libs,
            )
            )
    modules += ecore_exts
    packages.append("efl.ecore")

    # === Ethumb ===
    ethumb_cflags, ethumb_libs = pkg_config(
        'Ethumb', 'ethumb', EFL_MIN_VERSION)
    ethumb_ext = Extension(
        "ethumb", ["efl/ethumb/efl.ethumb" + module_suffix],
        include_dirs=['include/'],
        extra_compile_args=ethumb_cflags,
        extra_link_args=ethumb_libs + eina_libs,
    )
    modules.append(ethumb_ext)

    ethumb_client_cflags, ethumb_client_libs = pkg_config(
        'Ethumb_Client', 'ethumb_client', EFL_MIN_VERSION)
    ethumb_client_ext = Extension(
        "ethumb_client", ["efl/ethumb/efl.ethumb_client" + module_suffix],
        include_dirs=['include/'],
        extra_compile_args=ethumb_client_cflags,
        extra_link_args=ethumb_client_libs + eina_libs,
    )
    modules.append(ethumb_client_ext)

    # === Edje ===
    edje_cflags, edje_libs = pkg_config('Edje', 'edje', EFL_MIN_VERSION)
    edje_ext = Extension(
        "edje", ["efl/edje/efl.edje" + module_suffix],
        include_dirs=['include/'],
        extra_compile_args=edje_cflags,
        extra_link_args=edje_libs + eina_libs + evas_libs,
    )
    modules.append(edje_ext)

    # --- Edje_Edit ---
    edje_edit_ext = Extension(
        "edje_edit", ["efl/edje/efl.edje_edit" + module_suffix],
        define_macros=[('EDJE_EDIT_IS_UNSTABLE_AND_I_KNOW_ABOUT_IT', None)],
        include_dirs=['include/'],
        extra_compile_args=edje_cflags,
        extra_link_args=edje_libs + eina_libs + evas_libs,
    )
    modules.append(edje_edit_ext)

    # === Emotion ===
    emotion_cflags, emotion_libs = pkg_config(
        'Emotion', 'emotion', EFL_MIN_VERSION)
    emotion_ext = Extension(
        "emotion", ["efl/emotion/efl.emotion" + module_suffix],
        include_dirs=['include/'],
        extra_compile_args=emotion_cflags,
        extra_link_args=emotion_libs +
        eina_libs + evas_libs,
    )
    modules.append(emotion_ext)

    # === dbus mainloop integration ===
    dbus_cflags, dbus_libs = pkg_config('DBus', 'dbus-python', "0.83.0")
    dbus_ml_ext = Extension(
        "dbus_mainloop",
        ["efl/dbus_mainloop/dbus_mainloop" + module_suffix,
         "efl/dbus_mainloop/e_dbus.c"],
        extra_compile_args=list(set(dbus_cflags + ecore_cflags)),
        extra_link_args=dbus_libs + ecore_libs,
        )
    modules.append(dbus_ml_ext)

    # === Elementary ===
    elm_mods = (
        #"access",
        "actionslider",
        "background",
        "box",
        "bubble",
        "button",
        "calendar_elm",
        "check",
        "clock",
        "colorselector",
        "configuration",
        "conformant",
        "ctxpopup",
        "datetime_elm",
        "dayselector",
        "diskselector",
        "entry",
        "fileselector_button",
        "fileselector_entry",
        "fileselector",
        "flip",
        "flipselector",
        "frame",
        "general",
        "gengrid",
        "genlist",
        "gesture_layer",
        #"glview",
        "grid",
        "hover",
        "hoversel",
        "icon",
        "image",
        "index",
        "innerwindow",
        "label",
        "layout_class",
        "layout",
        "list",
        "mapbuf",
        "map",
        "menu",
        "multibuttonentry",
        "naviframe",
        "need",
        "notify",
        "object_item",
        "object",
        "panel",
        "panes",
        "photocam",
        "photo",
        "plug",
        "popup",
        "progressbar",
        "radio",
        "scroller",
        "segment_control",
        "separator",
        "slider",
        "slideshow",
        "spinner",
        #"store",
        "table",
        "theme",
        "thumb",
        "toolbar",
        "transit",
        "video",
        "web",
        "window",
    )

    elm_cflags, elm_libs = pkg_config(
        'Elementary', 'elementary', ELM_MIN_VERSION)
    for m in elm_mods:
        e = Extension(
            "elementary." + m,
            ["efl/elementary/" + m + module_suffix],
            include_dirs=["include/"],
            extra_compile_args=elm_cflags + ecore_x_cflags,
            extra_link_args=elm_libs + eina_libs + evas_libs,
            )
        modules.append(e)

    packages.append("efl.elementary")


setup(
    name="python-efl",
    fullname="Python bindings for Enlightenment Foundation Libraries",
    description="Python bindings for Enlightenment Foundation Libraries",
    version=RELEASE,
    author=(
        "Gustavo Sverzut Barbieri, Simon Busch, Boris 'billiob' Faure, "
        "Davide Andreoli, Fabiano Fidêncio, Bruno Dilly, Tiago Falcão, "
        "Joost Albers, Kai Huuhko, Ulisses Furquim"
        ),
    author_email="dave@gurumeditation.it, kai.huuhko@gmail.com",
    maintainer="Kai Huuhko, Davide Andreoli",
    maintainer_email="kai.huuhko@gmail.com, dave@gurumeditation.it",
    contact="Enlightenment developer mailing list",
    contact_email="enlightenment-devel@lists.sourceforge.net",
    url="http://www.enlightenment.org",
    license="GNU Lesser General Public License (LGPL)",
    cmdclass={
        'build_ext': build_ext,
        'build_doc': BuildDoc,
        'clean_generated_files': CleanGenerated
    },
    command_options={
        'build_doc': {
            'version': ('setup.py', VERSION),
            'release': ('setup.py', RELEASE)
        }
    },
    #package_dir=package_dirs,
    packages=packages,
    ext_package="efl",  # The prefix for ext modules/packages
    ext_modules=cythonize(
        modules,
        include_path=["include"],
        compiler_directives={
            #"c_string_type": "unicode",
            #"c_string_encoding": "utf-8",
            "embedsignature": True,
        }
    ),
)
