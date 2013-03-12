
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

def init():
    """

    Initializes the Efreet system.

    :return: Value > ``0`` if the initialization was successful, ``0`` otherwise.

    """
    return efreet_init()

def shutdown():
    """

    Shuts down Efreet if a balanced number of init/shutdown calls have
    been made

    :return: The number of times the init function has been called minus the
    corresponding init call.

    """
    return efreet_shutdown()

def lang_reset():
    """

    Resets language dependent variables and resets language dependent
    caches This must be called whenever the locale is changed.

    """
    efreet_lang_reset()

include "base.pxi"
#include "desktop.pxi"
#include "icon.pxi
include "ini.pxi"
#include "menu.pxi"
#include "mime.pxi"
#include "trash.pxi"
#include "uri.pxi"
