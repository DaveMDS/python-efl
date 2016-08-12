# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

#from cpython cimport PyObject, Py_INCREF, Py_DECREF
from cpython cimport PyMem_Malloc, PyMem_Free, PyUnicode_AsUTF8String
from efl.utils.deprecated cimport DEPRECATED

import atexit


def init(name=None):
    """Initialize the X display connection to the given display.

    :param name: display target name, if None, default will be used.
    :rtype: int
    """
    cdef int i
    if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
    i = ecore_x_init(<char *>name if name is not None else NULL)
    x_events_register()
    return i


def shutdown():
    """Shuts down the Ecore X library.

    In shutting down the library, the X display connection is terminated
    and any event handlers for it are removed.

    :rtype: int
    """
    return ecore_x_shutdown()


def disconnect():
    """Shuts down the Ecore X library.

    As ecore_x_shutdown, except do not close Display, only connection.

    :rtype: int
    """
    return ecore_x_disconnect()


def fd_get():
    """Retrieves the X display file descriptor.

    :rtype: int
    """
    return ecore_x_fd_get()


def double_click_time_set(double t):
    """Sets the timeout for a double and triple clicks to be flagged.

    This sets the time between clicks before the double_click flag is
    set in a button down event. If 3 clicks occur within double this
    time, the triple_click flag is also set.
    """
    ecore_x_double_click_time_set(t)

def double_click_time_get():
    ":rtype: float"
    return ecore_x_double_click_time_get()


def flush():
    "Sends all X commands in the X Display buffer."
    ecore_x_flush()


def sync():
    "Flushes the command buffer and waits until all requests have been"
    ecore_x_sync()


def current_time_get():
    "Return the last event time."
    return ecore_x_current_time_get()


def error_request_get():
    """Get the request code that caused the error.

    :rtype: int
    """
    return ecore_x_error_request_get()


def error_code_get():
    """Get the error code from the error.

    :rtype: int
    """
    return ecore_x_error_code_get()


def window_focus_get():
    """Returns the window that has the focus.

    :rtype: L{Window}
    """
    cdef Ecore_X_Window xid
    xid = ecore_x_window_focus_get()
    return Window_from_xid(xid)


cdef int _skip_list_build(skip_list, Ecore_X_Window **pskips, int *pskip_num) except 0:
    cdef Window win
    cdef int i

    if skip_list:
        pskip_num[0] = len(skip_list)
    else:
        pskip_num[0] = 0

    if pskip_num[0] == 0:
        pskips[0] = NULL
        return 1
    else:
        pskips[0] = <Ecore_X_Window *>PyMem_Malloc(pskip_num[0] * sizeof(Ecore_X_Window))
        i = 0
        try:
            for w in skip_list:
                win = w
                pskips[0][i] = win.xid
                i += 1
        except:
            pskip_num[0] = 0
            PyMem_Free(<void*>pskips[0])
            raise
    return 1


def window_shadow_tree_at_xy_with_skip_get(Window base, int x, int y, skip_list=None):
    """Retrieves the top, visible window at the given location,
       but skips the windows in the list. This uses a shadow tree built from the
       window tree that is only updated the first time
       L{window_shadow_tree_at_xy_with_skip_get()} is called, or the next time
       it is called after a L{window_shadow_tree_flush()}.

       :param base: Window to use as base, or None to use root window.
       :param x: The given X position.
       :param y: The given Y position.
       :rtype: Window
    """
    cdef:
        Ecore_X_Window base_xid, ret_xid
        Ecore_X_Window *skips
        int skip_num
    if base is <Window>None:
        base_xid = 0
    else:
        base_xid = base.xid

    _skip_list_build(skip_list, &skips, &skip_num)
    ret_xid = ecore_x_window_shadow_tree_at_xy_with_skip_get(base_xid, x, y,
                                                             skips, skip_num)
    if skips != NULL:
        PyMem_Free(<void*>skips)

    return Window_from_xid(ret_xid)


def window_shadow_tree_flush():
    "Flushes the window shadow tree so nothing is stored."
    ecore_x_window_shadow_tree_flush()


def window_at_xy_get(int x, int y):
    """Retrieves the top, visible window at the given location.

    :param x: horizontal position.
    :param y: vertical position.
    :rtype: Window
    """
    cdef Ecore_X_Window xid
    xid = ecore_x_window_at_xy_get(x, y)
    return Window_from_xid(xid)


def window_at_xy_with_skip_get(int x, int y, skip_list=None):
    """Retrieves the top, visible window at the given location.

    :param x: horizontal position.
    :param y: vertical position.
    :rtype: Window
    """
    cdef:
        Ecore_X_Window xid
        Ecore_X_Window *skips
        int skip_num

    _skip_list_build(skip_list, &skips, &skip_num)
    xid = ecore_x_window_at_xy_with_skip_get(x, y, skips, skip_num)

    if skips != NULL:
        PyMem_Free(<void*>skips)

    return Window_from_xid(xid)


def window_at_xy_begin_get(Window begin, int x, int y):
    """Retrieves the top, visible window at the given location, starting from
       begin.

       :param begin: Window to start at.
       :param x: horizontal position.
       :param y: vertical position.
       :rtype: Window
    """
    cdef Ecore_X_Window xid, begin_xid
    if begin is <Window>None:
        begin_xid = 0
    else:
        begin_xid = begin.xid
    xid = ecore_x_window_at_xy_begin_get(begin_xid, x, y)
    return Window_from_xid(xid)


def keyboard_ungrab():
    ecore_x_keyboard_ungrab()


def screensaver_event_available_get():
    """ .. versionadded:: 1.11 """
    return bool(ecore_x_screensaver_event_available_get())

def screensaver_idle_time_get():
    """ .. versionadded:: 1.11 """
    return ecore_x_screensaver_idle_time_get()

def screensaver_set(int timeout, int interval, int prefer_blanking, int allow_exposures):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_set(timeout, interval, prefer_blanking, allow_exposures)

def screensaver_timeout_set(int timeout):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_timeout_set(timeout)

def screensaver_timeout_get():
    """ .. versionadded:: 1.11 """
    return ecore_x_screensaver_timeout_get()

def screensaver_blank_set(int timeout):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_blank_set(timeout)

def screensaver_blank_get():
    """ .. versionadded:: 1.11 """
    return ecore_x_screensaver_blank_get()

def screensaver_expose_set(int timeout):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_expose_set(timeout)

def screensaver_expose_get():
    """ .. versionadded:: 1.11 """
    return ecore_x_screensaver_expose_get()

def screensaver_interval_set(int timeout):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_interval_set(timeout)

def screensaver_interval_get():
    """ .. versionadded:: 1.11 """
    return ecore_x_screensaver_interval_get()

def screensaver_event_listen_set(Eina_Bool on):
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_event_listen_set(on)

def screensaver_custom_blanking_enable():
    """ .. versionadded:: 1.11 """
    return bool(ecore_x_screensaver_custom_blanking_enable())

def screensaver_custom_blanking_disable():
    """ .. versionadded:: 1.11 """
    return bool(ecore_x_screensaver_custom_blanking_disable())

@DEPRECATED("1.14", "Use screensaver_suspend() instead.")
def screensaver_supend():
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_suspend()

def screensaver_suspend():
    """ .. versionadded:: 1.14 """
    ecore_x_screensaver_suspend()

def screensaver_resume():
    """ .. versionadded:: 1.11 """
    ecore_x_screensaver_resume()

def cursor_shape_get(int shape):
    """
    :param int shape: The shape ID (check Ecore_X_Cursor.h for these)
    :return: The cursor id
    :rtype: Ecore_X_Cursor

    .. versionadded:: 1.14
    """
    return ecore_x_cursor_shape_get(shape)

def cursor_free(Ecore_X_Cursor c):
    """
    :param Ecore_X_Cursor c: The cursor ID

    .. versionadded:: 1.14
    """

include "efl.ecore_x_window.pxi"
include "efl.ecore_x_events.pxi"

init()
atexit.register(shutdown)
