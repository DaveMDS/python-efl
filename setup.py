#! /usr/bin/env python

import sys
import subprocess
from distutils.core import setup
from distutils.extension import Extension

try:
    from Cython.Distutils import build_ext
    from Cython.Build import cythonize
    import Cython.Compiler.Options

    Cython.Compiler.Options.fast_fail = True # stop compilation on first error
except ImportError:
    raise SystemExit("Requires Cython (http://cython.org/)")


def pkg_config(name, require, min_vers=None):
    try:
        sys.stdout.write("Checking for " + name + ": ")
        ver = subprocess.check_output(["pkg-config", "--modversion", require]).decode("utf-8").strip()
        #if min_vers is not None:
        if False:
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
                        extra_compile_args = evas_cflags + eo_cflags,
                        extra_link_args = evas_libs)
modules.append(evas_ext)

# Ecore
ecore_cflags, ecore_libs = pkg_config('Ecore', 'ecore', "1.7.99")
efile_cflags, efile_libs = pkg_config('EcoreFile', 'ecore-file', "1.7.99")
ecore_ext = Extension("efl.ecore", ["efl/ecore/efl.ecore.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = ecore_cflags + efile_cflags + eo_cflags,
                        extra_link_args = ecore_libs + efile_libs)
modules.append(ecore_ext)

# Edje
edje_cflags, edje_libs = pkg_config('Edje', 'edje', "1.7.99")
edje_ext = Extension("efl.edje", ["efl/edje/efl.edje.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = edje_cflags + eo_cflags,
                        extra_link_args = edje_libs)
modules.append(edje_ext)

# Emotion
emotion_cflags, emotion_libs = pkg_config('Emotion', 'emotion', "1.7.99")
emotion_ext = Extension("efl.emotion", ["efl/emotion/efl.emotion.pyx"],
                        include_dirs = ['include/'],
                        extra_compile_args = emotion_cflags + eo_cflags,
                        extra_link_args = emotion_libs)
modules.append(emotion_ext)

# Elementary
elm_cflags, elm_libs = pkg_config('Elementary', 'elementary', "1.7.99")
elm_exts = [
    Extension("efl.elementary.actionslider", ["efl/elementary/actionslider.pyx"]),
    Extension("efl.elementary.background", ["efl/elementary/background.pyx"]),
    Extension("efl.elementary.box", ["efl/elementary/box.pyx"]),
    Extension("efl.elementary.bubble", ["efl/elementary/bubble.pyx"]),
    Extension("efl.elementary.button", ["efl/elementary/button.pyx"]),
    Extension("efl.elementary.calendar_elm", ["efl/elementary/calendar_elm.pyx"]),
    Extension("efl.elementary.check", ["efl/elementary/check.pyx"]),
    Extension("efl.elementary.clock", ["efl/elementary/clock.pyx"]),
    Extension("efl.elementary.colorselector", ["efl/elementary/colorselector.pyx"]),
    Extension("efl.elementary.configuration", ["efl/elementary/configuration.pyx"]),
    Extension("efl.elementary.conformant", ["efl/elementary/conformant.pyx"]),
    Extension("efl.elementary.ctxpopup", ["efl/elementary/ctxpopup.pyx"]),
    Extension("efl.elementary.datetime_elm", ["efl/elementary/datetime_elm.pyx"]),
    Extension("efl.elementary.dayselector", ["efl/elementary/dayselector.pyx"]),
    Extension("efl.elementary.diskselector", ["efl/elementary/diskselector.pyx"]),
    Extension("efl.elementary.entry", ["efl/elementary/entry.pyx"]),
    Extension("efl.elementary.fileselector_button", ["efl/elementary/fileselector_button.pyx"]),
    Extension("efl.elementary.fileselector_entry", ["efl/elementary/fileselector_entry.pyx"]),
    Extension("efl.elementary.fileselector", ["efl/elementary/fileselector.pyx"]),
    Extension("efl.elementary.flip", ["efl/elementary/flip.pyx"]),
    Extension("efl.elementary.flipselector", ["efl/elementary/flipselector.pyx"]),
    Extension("efl.elementary.frame", ["efl/elementary/frame.pyx"]),
    Extension("efl.elementary.general", ["efl/elementary/general.pyx"]),
    Extension("efl.elementary.gengrid", ["efl/elementary/gengrid.pyx"]),
    Extension("efl.elementary.genlist", ["efl/elementary/genlist.pyx"]),
    Extension("efl.elementary.gesture_layer", ["efl/elementary/gesture_layer.pyx"]),
    Extension("efl.elementary.grid", ["efl/elementary/grid.pyx"]),
    Extension("efl.elementary.hover", ["efl/elementary/hover.pyx"]),
    Extension("efl.elementary.hoversel", ["efl/elementary/hoversel.pyx"]),
    Extension("efl.elementary.icon", ["efl/elementary/icon.pyx"]),
    Extension("efl.elementary.image", ["efl/elementary/image.pyx"]),
    Extension("efl.elementary.index", ["efl/elementary/index.pyx"]),
    Extension("efl.elementary.innerwindow", ["efl/elementary/innerwindow.pyx"]),
    Extension("efl.elementary.label", ["efl/elementary/label.pyx"]),
    Extension("efl.elementary.layout_class", ["efl/elementary/layout_class.pyx"]),
    Extension("efl.elementary.layout", ["efl/elementary/layout.pyx"]),
    Extension("efl.elementary.list", ["efl/elementary/list.pyx"]),
    Extension("efl.elementary.mapbuf", ["efl/elementary/mapbuf.pyx"]),
    Extension("efl.elementary.map", ["efl/elementary/map.pyx"]),
    Extension("efl.elementary.menu", ["efl/elementary/menu.pyx"]),
    Extension("efl.elementary.multibuttonentry", ["efl/elementary/multibuttonentry.pyx"]),
    Extension("efl.elementary.naviframe", ["efl/elementary/naviframe.pyx"]),
    Extension("efl.elementary.need", ["efl/elementary/need.pyx"]),
    Extension("efl.elementary.notify", ["efl/elementary/notify.pyx"]),
    Extension("efl.elementary.object_item", ["efl/elementary/object_item.pyx"]),
    Extension("efl.elementary.object", ["efl/elementary/object.pyx"]),
    Extension("efl.elementary.panel", ["efl/elementary/panel.pyx"]),
    Extension("efl.elementary.panes", ["efl/elementary/panes.pyx"]),
    Extension("efl.elementary.photocam", ["efl/elementary/photocam.pyx"]),
    Extension("efl.elementary.photo", ["efl/elementary/photo.pyx"]),
    Extension("efl.elementary.plug", ["efl/elementary/plug.pyx"]),
    Extension("efl.elementary.popup", ["efl/elementary/popup.pyx"]),
    Extension("efl.elementary.progressbar", ["efl/elementary/progressbar.pyx"]),
    Extension("efl.elementary.radio", ["efl/elementary/radio.pyx"]),
    Extension("efl.elementary.scroller", ["efl/elementary/scroller.pyx"]),
    Extension("efl.elementary.segment_control", ["efl/elementary/segment_control.pyx"]),
    Extension("efl.elementary.separator", ["efl/elementary/separator.pyx"]),
    Extension("efl.elementary.slider", ["efl/elementary/slider.pyx"]),
    Extension("efl.elementary.slideshow", ["efl/elementary/slideshow.pyx"]),
    Extension("efl.elementary.spinner", ["efl/elementary/spinner.pyx"]),
    Extension("efl.elementary.table", ["efl/elementary/table.pyx"]),
    Extension("efl.elementary.theme", ["efl/elementary/theme.pyx"]),
    Extension("efl.elementary.thumb", ["efl/elementary/thumb.pyx"]),
    Extension("efl.elementary.toolbar", ["efl/elementary/toolbar.pyx"]),
    Extension("efl.elementary.transit", ["efl/elementary/transit.pyx"]),
    Extension("efl.elementary.video", ["efl/elementary/video.pyx"]),
    Extension("efl.elementary.web", ["efl/elementary/web.pyx"]),
    Extension("efl.elementary.window", ["efl/elementary/window.pyx"]),
]

for e in elm_exts:
    e.include_dirs = ['include/']
    e.extra_compile_args = elm_cflags + eo_cflags
    e.extra_link_args = elm_libs

modules = modules + elm_exts


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
        #ext_modules = modules
        ext_modules = cythonize(modules, include_path=["include",], compiler_directives={"embedsignature": False}),
    )
