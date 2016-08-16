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

from efl.eina cimport Eina_Bool
from efl.ecore cimport Ecore_Event_Handler, ecore_event_handler_add, \
    ecore_event_handler_del


cdef extern from "Ecore_Input.h":

    ####################################################################
    # events (not exposed to python)
    #
    int ECORE_EVENT_KEY_DOWN
    int ECORE_EVENT_KEY_UP
    int ECORE_EVENT_MOUSE_BUTTON_DOWN
    int ECORE_EVENT_MOUSE_BUTTON_UP
    int ECORE_EVENT_MOUSE_MOVE
    int ECORE_EVENT_MOUSE_IN
    int ECORE_EVENT_MOUSE_OUT
    int ECORE_EVENT_MOUSE_WHEEL

    ####################################################################
    # Data Types
    #
    ctypedef void *Ecore_Window

    ctypedef struct _EventPoint:
        int x
        int y

    ctypedef struct _EventMulti:
        int device
        double radius
        double radius_x
        double radius_y
        double pressure
        double angle
        double x
        double y
        _EventPoint root

    ctypedef struct Ecore_Event_Key:
        const char *keyname
        const char *key
        const char *string
        const char *compose
        Ecore_Window window
        Ecore_Window root_window
        Ecore_Window event_window
        unsigned int timestamp
        unsigned int modifiers
        int same_screen
        unsigned int keycode
        void *data

    ctypedef struct Ecore_Event_Mouse_Button:
        Ecore_Window window
        Ecore_Window root_window
        Ecore_Window event_window
        unsigned int timestamp
        unsigned int modifiers
        unsigned int buttons
        unsigned int double_click
        unsigned int triple_click
        int same_screen
        int x
        int y
        _EventPoint root
        _EventMulti multi

    ctypedef struct Ecore_Event_Mouse_Wheel:
        Ecore_Window window
        Ecore_Window root_window
        Ecore_Window event_window
        unsigned int timestamp
        unsigned int modifiers
        int same_screen
        int direction
        int z
        int x
        int y
        _EventPoint root

    ctypedef struct Ecore_Event_Mouse_Move:
        Ecore_Window window
        Ecore_Window root_window
        Ecore_Window event_window
        unsigned int timestamp
        unsigned int modifiers
        int same_screen
        int x
        int y
        _EventPoint root
        _EventMulti multi

    ctypedef struct Ecore_Event_Mouse_IO:
        Ecore_Window window
        Ecore_Window event_window
        unsigned int timestamp
        unsigned int modifiers
        int x
        int y


    ####################################################################
    # Functions
    #
    int ecore_event_init()
    int ecore_event_shutdown()


####################################################################
# Python classes
#
from efl.ecore cimport Event, EventHandler


cdef class Window:
    # Can we do something with this opaque stuct ?
    pass


cdef class InputEventHandler(EventHandler):
    pass


cdef class EventPoint:
    cdef readonly int x
    cdef readonly int y


cdef class EventMulti:
    cdef readonly int device
    cdef readonly double radius
    cdef readonly double radius_x
    cdef readonly double radius_y
    cdef readonly double pressure
    cdef readonly double angle
    cdef readonly double x
    cdef readonly double y
    cdef readonly double root_x
    cdef readonly double root_y


cdef class EventKey(Event):
    cdef readonly object keyname
    cdef readonly object key
    cdef readonly object string
    cdef readonly object compose
    ## Can we do something with this Window opaque struct ?
    # cdef readonly Window window
    # cdef readonly Window root_window
    # cdef readonly Window event_window
    cdef readonly unsigned int modifiers
    cdef readonly unsigned int timestamp
    cdef readonly unsigned int keycode
    cdef readonly object same_screen


cdef class EventMouseButton(Event):
    # cdef readonly Window window
    # cdef readonly Window root_window
    # cdef readonly Window event_window
    cdef readonly unsigned int modifiers
    cdef readonly unsigned int timestamp
    cdef readonly unsigned int buttons
    cdef readonly object double_click
    cdef readonly object triple_click
    cdef readonly object same_screen
    cdef readonly int x
    cdef readonly int y
    cdef readonly EventPoint root
    cdef readonly EventMulti multi


cdef class EventMouseMove(Event):
    # cdef readonly Window window
    # cdef readonly Window root_window
    # cdef readonly Window event_window
    cdef readonly unsigned int modifiers
    cdef readonly unsigned int timestamp
    cdef readonly object same_screen
    cdef readonly int x
    cdef readonly int y
    cdef readonly EventPoint root
    cdef readonly EventMulti multi


cdef class EventMouseIO(Event):
    # cdef readonly Window window
    # cdef readonly Window event_window
    cdef readonly unsigned int modifiers
    cdef readonly unsigned int timestamp
    cdef readonly int x
    cdef readonly int y


cdef class EventMouseWheel(Event):
    # cdef readonly Window window
    # cdef readonly Window root_window
    # cdef readonly Window event_window
    cdef readonly unsigned int modifiers
    cdef readonly unsigned int timestamp
    cdef readonly object same_screen
    cdef readonly int direction
    cdef readonly int z
    cdef readonly int x
    cdef readonly int y
    cdef readonly EventPoint root

