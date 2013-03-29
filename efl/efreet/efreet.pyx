
"""

The Efreet Library

.. rubric:: Introduction

Efreet is a library designed to help apps work several of the
Freedesktop.org standards regarding Icons, Desktop files and Menus. To
that end it implements the following specifications:

    - XDG Base Directory Specification
    - Icon Theme Specification
    - Desktop Entry Specification
    - Desktop Menu Specification
    - FDO URI Specification
    - Shared Mime Info Specification
    - Trash Specification

"""

import atexit

efreet_init()

def _shutdown():
    return efreet_shutdown()

atexit.register(_shutdown)

def lang_reset():
    """lang_reset()

    Resets language dependent variables and resets language dependent
    caches. This must be called whenever the locale is changed.

    """
    efreet_lang_reset()

include "base.pxi"
include "desktop.pxi"
include "icon.pxi"
include "ini.pxi"
include "menu.pxi"
include "uri.pxi"
