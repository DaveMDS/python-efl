# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
#

"""

.. _General:

General
=======

General Elementary API. Functions that don't relate to
Elementary objects specifically.

Here are documented functions which init/shutdown the library,
that apply to generic Elementary objects, that deal with
configuration, et cetera.


.. _Fingers:

Fingers
=======

Elementary is designed to be finger-friendly for touchscreens,
and so in addition to scaling for display resolution, it can
also scale based on finger "resolution" (or size). You can then
customize the granularity of the areas meant to receive clicks
on touchscreens.

Different profiles may have pre-set values for finger sizes.


Enumerations
============


.. _Elm_Policy:

Policy types
------------

.. data:: ELM_POLICY_QUIT

    Under which circumstances the application should quit automatically.

.. data:: ELM_POLICY_EXIT

    Defines elm_exit() behaviour. (since 1.8)

.. data:: ELM_POLICY_THROTTLE

    Defines how throttling should work (since 1.8)


.. _Elm_Policy_Quit:

Quit policy types
-----------------

.. data:: ELM_POLICY_QUIT_NONE

    Never quit the application automatically

.. data:: ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

    Quit when the application's last window is closed


.. _Elm_Policy_Exit:

Exit policy types
-----------------

Possible values for the ELM_POLICY_EXIT policy.

.. data:: ELM_POLICY_EXIT_NONE

    Just quit the main loop on exit().

.. data:: ELM_POLICY_EXIT_WINDOWS_DEL

    Delete all the windows after quitting the main loop.


.. _Elm_Policy_Throttle:

Throttle policy types
---------------------

Possible values for the #ELM_POLICY_THROTTLE policy.

.. data:: ELM_POLICY_THROTTLE_CONFIG

    Do whatever elementary config is configured to do.

.. data:: ELM_POLICY_THROTTLE_HIDDEN_ALWAYS

    Always throttle when all windows are no longer visible.

.. data:: ELM_POLICY_THROTTLE_NEVER

    Never throttle when windows are all hidden, regardless of config settings.


"""

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String, \
    PyMem_Malloc, PyMem_Free
from libc.stdint cimport uintptr_t

from efl.evas cimport Object as evasObject

from efl.utils.conversions cimport _touni, _ctouni, \
    python_list_strings_to_eina_list, \
    eina_list_strings_to_python_list

from efl.utils.logger cimport add_logger

from efl.eina cimport EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, \
    EINA_LOG_DOM_WARN, EINA_LOG_DOM_ERR, EINA_LOG_DOM_CRIT

import sys
import traceback

cimport enums

ELM_POLICY_QUIT = enums.ELM_POLICY_QUIT
ELM_POLICY_EXIT = enums.ELM_POLICY_EXIT
ELM_POLICY_THROTTLE = enums.ELM_POLICY_THROTTLE

ELM_POLICY_QUIT_NONE = enums.ELM_POLICY_QUIT_NONE
ELM_POLICY_QUIT_LAST_WINDOW_CLOSED = enums.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

ELM_POLICY_EXIT_NONE = enums.ELM_POLICY_EXIT_NONE
ELM_POLICY_EXIT_WINDOWS_DEL = enums.ELM_POLICY_EXIT_WINDOWS_DEL

ELM_POLICY_THROTTLE_CONFIG = enums.ELM_POLICY_THROTTLE_CONFIG
ELM_POLICY_THROTTLE_HIDDEN_ALWAYS = enums.ELM_POLICY_THROTTLE_HIDDEN_ALWAYS
ELM_POLICY_THROTTLE_NEVER = enums.ELM_POLICY_THROTTLE_NEVER

cdef class FontProperties(object):

    """Elementary font properties"""

    cdef Elm_Font_Properties *efp

    property name:
        """:type: unicode"""
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.efp.name = value

        def __get__(self):
            return _ctouni(self.efp.name)

    property styles:
        """:type: list of strings"""
        def __set__(self, value):
            self.efp.styles = python_list_strings_to_eina_list(value)

        def __get__(self):
            return eina_list_strings_to_python_list(self.efp.styles)

elm_log = add_logger("efl.elementary")
cdef int PY_EFL_ELM_LOG_DOMAIN = elm_log.eina_log_domain

def init():
    """init() -> int

    Initialize Elementary

    :return int: The init counter value.

    This function initializes Elementary and increments a counter of the number
    of calls to it. It returns the new counter's value.

    """
    EINA_LOG_DOM_INFO(PY_EFL_ELM_LOG_DOMAIN,
        "Initializing efl.elementary", NULL)

    # FIXME: Why are we passing the cl args to elm_init here?

    cdef:
        int argc, i, arg_len
        char **argv
        char *arg

    argc = len(sys.argv)
    argv = <char **>PyMem_Malloc(argc * sizeof(char *))
    for i in range(argc):
        t = sys.argv[i]
        if isinstance(t, unicode): t = PyUnicode_AsUTF8String(t)
        arg = t
        arg_len = len(arg)
        argv[i] = <char *>PyMem_Malloc(arg_len + 1)
        memcpy(argv[i], arg, arg_len + 1)

    return elm_init(argc, argv)

def shutdown():
    """shutdown() -> int

    Shut down Elementary

    :return int: The init counter value.

    This should be called at the end of your application, just before it ceases
    to do any more processing. This will clean up any permanent resources your
    application may have allocated via Elementary that would otherwise persist.

    .. note::

        shutdown() will iterate main loop until all ecore_evas are freed. There
        is a possibility to call your ecore callbacks(timer, animator, event,
        job, and etc.) in shutdown()

    """
    EINA_LOG_DOM_INFO(PY_EFL_ELM_LOG_DOMAIN,
        "Shutting down efl.elementary", NULL)
    return elm_shutdown()

def run():
    """run()

    Run Elementary's main loop

    This call should be issued just after all initialization is completed. This
    function will not return until exit() is called. It will keep looping,
    running the main (event/processing) loop for Elementary.

    """
    EINA_LOG_DOM_DBG(PY_EFL_ELM_LOG_DOMAIN,
        "Starting up main loop.", NULL)
    with nogil:
        elm_run()

def exit():
    """exit()
    Ask to exit Elementary's main loop

    If this call is issued, it will flag the main loop to cease processing and
    return back to its parent function (usually your elm_main() function). This
    does not mean the main loop instantly quits. So your ecore callbacks(timer,
    animator, event, job, and etc.) have chances to be called even after
    exit().

    .. note::

        By using the appropriate #ELM_POLICY_QUIT on your Elementary
        applications, you'll be able to get this function called automatically
        for you.

    """
    EINA_LOG_DOM_DBG(PY_EFL_ELM_LOG_DOMAIN,
        "Ending main loop.", NULL)
    elm_exit()

def policy_set(Elm_Policy policy, value):
    """policy_set(Elm_Policy policy, value) -> bool

    Set new policy value.

    This will emit the ecore event ELM_EVENT_POLICY_CHANGED in the main
    loop giving the event information Elm_Event_Policy_Changed with
    policy identifier, new and old values.

    :param policy: policy identifier as in Elm_Policy.
    :type policy: :ref:`Elm_Policy`
    :param value: policy value, depends on identifiers, usually there is
        an enumeration with the same prefix as the policy name, for
        example: ELM_POLICY_QUIT and Elm_Policy_Quit
        (ELM_POLICY_QUIT_NONE, ELM_POLICY_QUIT_LAST_WINDOW_CLOSED).
    :type value: :ref:`Elm_Policy_Quit`

    :return: True on success or False on error (right
        now just invalid policy identifier, but in future policy
        value might be enforced).

    """
    return bool(elm_policy_set(policy, value))

def policy_get(Elm_Policy policy):
    """policy_get(Elm_Policy policy) -> value

    Gets the policy value set for given identifier.

    :param policy: policy identifier as in Elm_Policy.
    :type policy: :ref:`Elm_Policy`

    :return: policy value. Will be 0 if policy identifier is invalid.
    :rtype: :ref:`Elm_Policy_Quit`

    """
    return elm_policy_get(policy)

def coords_finger_size_adjust(int times_w, int w, int times_h, int h):
    """coords_finger_size_adjust(int times_w, int w, int times_h, int h) -> tuple

    Adjust size of an element for finger usage.

    :param times_w: How many fingers should fit horizontally
    :type times_w: int
    :param w: Width size to adjust
    :type w: int
    :param times_h: How many fingers should fit vertically
    :type times_h: int
    :param h: Height size to adjust
    :type h: int

    :return: The adjusted width and height
    :rtype: (int **w**, int **h**)

    This takes width and height sizes (in pixels) as input and a
    size multiple (which is how many fingers you want to place
    within the area, being "finger" the size set by
    elm_config_finger_size_set()), and adjusts the size to be large enough
    to accommodate the resulting size -- if it doesn't already
    accommodate it.

    .. note:: This is kind of low level Elementary call, most useful
        on size evaluation times for widgets. An external user wouldn't
        be calling, most of the time.

    """
    cdef Evas_Coord width = w, height = h
    elm_coords_finger_size_adjust(times_w, &width, times_h, &height)
    return (width, height)

def language_set(lang not None):
    """language_set(unicode lang)

    Change the language of the current application

    The ``lang`` passed must be the full name of the locale to use, for
    example ``en_US.utf8`` or ``es_ES@euro``.

    Changing language with this function will make Elementary run through
    all its widgets, translating strings set with
    elm_object_domain_translatable_part_text_set(). This way, an entire
    UI can have its language changed without having to restart the program.

    For more complex cases, like having formatted strings that need
    translation, widgets will also emit a "language,changed" signal that
    the user can listen to and manually translate the text.

    :param lang: Language to set, must be the full name of the locale

    """
    if isinstance(lang, unicode): lang = PyUnicode_AsUTF8String(lang)
    elm_language_set(<const_char *>lang)

def cache_all_flush():
    """cache_all_flush()

    Frees all data that was in cache and is not currently being used to reduce
    memory usage. This frees Edje's, Evas' and Eet's cache.

    .. note:: Evas caches are flushed for every canvas associated with a window.

    .. versionadded:: 1.8

    """
    elm_cache_all_flush()

def font_properties_get(font not None):
    """font_properties_get(unicode font) -> FontProperties

    Translate a font (family) name string in fontconfig's font names
    syntax into a FontProperties object.

    :param font: The font name and styles string
    :return: the font properties object

    .. note:: The reverse translation can be achieved with
        :py:func:`font_fontconfig_name_get`, for one style only (single font
        instance, not family).

    .. versionadded:: 1.8

    """
    if isinstance(font, unicode): font = PyUnicode_AsUTF8String(font)
    cdef FontProperties ret = FontProperties.__new__()

    ret.efp = elm_font_properties_get(<const_char *>font)

    return ret

def font_properties_free(FontProperties fp):
    """Free font properties return by font_properties_get().

    :param fp: the font properties struct

    .. versionadded:: 1.8

    """
    elm_font_properties_free(fp.efp)
    Py_DECREF(fp)

def font_fontconfig_name_get(font_name, style = None):
    """font_fontconfig_name_get(unicode font_name, unicode style = None) -> unicode

    Translate a font name, bound to a style, into fontconfig's font names
    syntax.

    :param font_name: The font (family) name
    :param style: The given style (may be None)

    :return: the font name and style string

    .. note:: The reverse translation can be achieved with
        :py:func:`font_properties_get`, for one style only (single font
        instance, not family).

    .. versionadded:: 1.8

    """
    cdef:
        unicode ret
        char *fc_name
    if isinstance(font_name, unicode): font_name = PyUnicode_AsUTF8String(font_name)
    if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
    fc_name = elm_font_fontconfig_name_get(
        <const_char *>font_name,
        <const_char *>style if style is not None else NULL
        )

    ret = _touni(fc_name)
    elm_font_fontconfig_name_free(fc_name)
    return ret

# TODO: Create an Eina_Hash -> dict conversion function for this
# def font_available_hash_add(list):
#     """Create a font hash table of available system fonts.

#     One must call it with ``list`` being the return value of
#     evas_font_available_list(). The hash will be indexed by font
#     (family) names, being its values ``Elm_Font_Properties`` blobs.

#     :param list: The list of available system fonts, as returned by
#     evas_font_available_list().
#     :return: the font hash.

#     .. note:: The user is supposed to get it populated at least with 3
#     default font families (Sans, Serif, Monospace), which should be
#     present on most systems.

#     """
#     EAPI Eina_Hash *elm_font_available_hash_add(Eina_List *list)


#     """Free the hash returned by elm_font_available_hash_add().

#     :param hash: the hash to be freed.

#     """
#     elm_font_available_hash_del(Eina_Hash *hash)

def object_tree_dump(evasObject top):
    """object_tree_dump(Object top)

    Print Tree object hierarchy in stdout

    :param top: The root object

    .. versionadded:: 1.8

    """
    elm_object_tree_dump(top.obj)

def object_tree_dot_dump(evasObject top, path):
    """object_tree_dot_dump(Object top, unicode path)

    Print Elm Objects tree hierarchy in file as dot(graphviz) syntax.

    :param top: The root object
    :param path: The path of output file

    .. versionadded:: 1.8

    """
    if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
    elm_object_tree_dot_dump(top.obj, <const_char *>path)
