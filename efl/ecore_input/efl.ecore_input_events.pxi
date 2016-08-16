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


from efl.utils.conversions cimport _ctouni
from efl.ecore cimport _event_mapping_register, _event_mapping_get


ECORE_EVENT_MODIFIER_SHIFT = enums.ECORE_EVENT_MODIFIER_SHIFT
ECORE_EVENT_MODIFIER_CTRL = enums.ECORE_EVENT_MODIFIER_CTRL
ECORE_EVENT_MODIFIER_ALT = enums.ECORE_EVENT_MODIFIER_ALT
ECORE_EVENT_MODIFIER_WIN = enums.ECORE_EVENT_MODIFIER_WIN
ECORE_EVENT_MODIFIER_SCROLL = enums.ECORE_EVENT_MODIFIER_SCROLL
ECORE_EVENT_MODIFIER_NUM = enums.ECORE_EVENT_MODIFIER_NUM
ECORE_EVENT_MODIFIER_CAPS = enums.ECORE_EVENT_MODIFIER_CAPS
ECORE_EVENT_LOCK_SCROLL = enums.ECORE_EVENT_LOCK_SCROLL
ECORE_EVENT_LOCK_NUM = enums.ECORE_EVENT_LOCK_NUM
ECORE_EVENT_LOCK_CAPS = enums.ECORE_EVENT_LOCK_CAPS
ECORE_EVENT_LOCK_SHIFT = enums.ECORE_EVENT_LOCK_SHIFT
ECORE_EVENT_MODIFIER_ALTGR = enums.ECORE_EVENT_MODIFIER_ALTGR



cdef int _input_events_registered = 0

cdef int _ecore_input_events_register() except 0:
    global _input_events_registered

    if _input_events_registered == 0:
        _event_mapping_register(ECORE_EVENT_KEY_DOWN, EventKey)
        _event_mapping_register(ECORE_EVENT_KEY_UP, EventKey)
        _event_mapping_register(ECORE_EVENT_MOUSE_BUTTON_DOWN, EventMouseButton)
        _event_mapping_register(ECORE_EVENT_MOUSE_BUTTON_UP, EventMouseButton)
        _event_mapping_register(ECORE_EVENT_MOUSE_MOVE, EventMouseMove)
        _event_mapping_register(ECORE_EVENT_MOUSE_IN, EventMouseIO)
        _event_mapping_register(ECORE_EVENT_MOUSE_OUT, EventMouseIO)
        _event_mapping_register(ECORE_EVENT_MOUSE_WHEEL, EventMouseWheel)

        _input_events_registered = 1

    return 1


cdef Eina_Bool _input_event_handler_cb(void *data, int type, void *event) with gil:
    cdef EventHandler handler
    cdef Eina_Bool r

    assert event != NULL
    assert data != NULL, "data should not be NULL!"
    handler = <EventHandler>data
    assert type == handler.type, "handler type isn't the same as event type!"

    try:
        r = handler._exec(event)
    except Exception:
        traceback.print_exc()
        r = 0

    return r


cdef class InputEventHandler(EventHandler):
    """
    The event handler class

    You never instantiate this class directly, instead use one of the
    on_*_add() functions.
    """
    def __init__(self, int type, func, *args, **kargs):

        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")

        event_cls = _event_mapping_get(type)
        if event_cls is None:
            raise ValueError("Unknow Ecore_Event type %d" % type)

        self.type = type
        self.event_cls = event_cls
        self.func = func
        self.args = args
        self.kargs = kargs
        self._set_obj(ecore_event_handler_add(type, _input_event_handler_cb,
                                              <void *>self))


cdef class EventKey(Event):
    """ EventKey()

    Contains information about an Ecore keyboard event.

    .. seealso :: :func:`on_key_down_add`, :func:`on_key_up_add`

    :ivar str keyname: The key name
    :ivar str key: The key symbol
    :ivar str string:
    :ivar int compose: Final string corresponding to the key symbol composed
    :ivar int timestamp: Time when the event occurred.
    :ivar int modifiers: :ref:`Ecore_Event_Modifier` The OR combination of modifiers key
    :ivar bool same_screen: Same screen flag
    :ivar int keycode: Key scan code numeric value

    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Key *obj
        obj = <Ecore_Event_Key*>o
        self.keyname = _ctouni(obj.keyname)
        self.key = _ctouni(obj.key)
        self.string = _ctouni(obj.string)
        self.compose = _ctouni(obj.compose)
        ## Can we do something with this Window opaque struct ?
        # self.window = Window(<unsigned long><void*>obj.window)
        # self.root_window = Window(<unsigned long><void*>obj.root_window)
        # self.event_window = Window(<unsigned long><void*>obj.event_window)
        self.timestamp = obj.timestamp
        self.modifiers = obj.modifiers
        self.same_screen = bool(obj.same_screen)
        self.keycode = obj.keycode
        return 1


cdef class EventPoint:
    """
    :ivar int x: x coordinate
    :ivar int y: y coordinate
    """
    def __init__(self, int x, int y):
        self.x = x
        self.y = y

    def __repr__(self):
        return "<EventPoint x=%d y=%d>" % (self.x, self.y)

cdef class EventMulti:
    """
    :ivar int device: 0 if normal mouse, 1+ for other mouse-devices (eg multi-touch - other fingers)
    :ivar double radius: radius of press point - radius_x and y if its an ellipse (radius is the average of the 2)
    :ivar double radius_x:
    :ivar double radius_y:
    :ivar double pressure: 1.0 == normal, > 1.0 == more, 0.0 == none
    :ivar double angle: relative to perpendicular (0.0 == perpendicular), in degrees
    :ivar double x: with sub-pixel precision, if available
    :ivar double y:  with sub-pixel precision, if available
    :ivar double root_x:  with sub-pixel precision, if available
    :ivar double root_y:  with sub-pixel precision, if available
    """
    def __init__(self, int device, double radius, double radius_x, double radius_y,
                 double pressure, double angle, double x, double y,
                 double root_x, double root_y):
        self.device = device
        self.radius = radius
        self.radius_x = radius_x
        self.radius_y = radius_y
        self.pressure = pressure
        self.angle = angle
        self.x = x
        self.y = y
        self.root_x = root_x
        self.root_y = root_y

    def __repr__(self):
        return "<EventMulti>"


cdef class EventMouseButton(Event):
    """ EventMouseButton()

    Contains information about an Ecore mouse button event.

    .. seealso :: :func:`on_mouse_button_down_add`, :func:`on_mouse_button_up_add`

    :ivar int timestamp: Time when the event occurred
    :ivar int modifiers: :ref:`Ecore_Event_Modifier` The OR combination of modifiers key
    :ivar int buttons: The button that was used
    :ivar bool double_click: Double click event
    :ivar bool triple_click: Triple click event
    :ivar bool same_screen: Same screen flag
    :ivar int x: x coordinate relative to window where event happened
    :ivar int y: y coordinate relative to window where event happened
    :ivar EventPoint root: :class:`EventPoint` Coordinates relative to root window

    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Mouse_Button *obj
        obj = <Ecore_Event_Mouse_Button*>o
        # self.window = Window(<unsigned long><void*>obj.window)
        # self.root_window = Window(<unsigned long><void*>obj.root_window)
        # self.event_window = Window(<unsigned long><void*>obj.event_window)
        self.timestamp = obj.timestamp
        self.modifiers = obj.modifiers
        self.buttons = obj.buttons
        self.double_click = bool(obj.double_click)
        self.triple_click = bool(obj.triple_click)
        self.same_screen = bool(obj.same_screen)
        self.x = obj.x
        self.y = obj.y
        self.root = EventPoint(obj.root.x, obj.root.y)
        self.multi = EventMulti(obj.multi.device, obj.multi.radius,
                                obj.multi.radius_x, obj.multi.radius_y,
                                obj.multi.pressure, obj.multi.angle,
                                obj.multi.x, obj.multi.y,
                                obj.multi.root.x, obj.multi.root.y)
        return 1


cdef class EventMouseMove(Event):
    """ EventMouseMove()

    Contains information about an Ecore mouse move event.

    .. seealso :: :func:`on_mouse_move_add`

    :ivar int timestamp: Time when the event occurred
    :ivar int modifiers: :ref:`Ecore_Event_Modifier` The OR combination of modifiers key
    :ivar bool same_screen: Same screen flag
    :ivar int x: x coordinate relative to window where event happened
    :ivar int y: y coordinate relative to window where event happened
    :ivar EventPoint root: Coordinates relative to root window

    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Mouse_Move *obj
        obj = <Ecore_Event_Mouse_Move *>o
        # self.window = Window(<unsigned long><void*>obj.window)
        # self.root_window = Window(<unsigned long><void*>obj.root_window)
        # self.event_window = Window(<unsigned long><void*>obj.event_window)
        self.timestamp = obj.timestamp
        self.modifiers = obj.modifiers
        self.same_screen = bool(obj.same_screen)
        self.x = obj.x
        self.y = obj.y
        self.root = EventPoint(obj.root.x, obj.root.y)
        self.multi = EventMulti(obj.multi.device, obj.multi.radius,
                                obj.multi.radius_x, obj.multi.radius_y,
                                obj.multi.pressure, obj.multi.angle,
                                obj.multi.x, obj.multi.y,
                                obj.multi.root.x, obj.multi.root.y)
        return 1


cdef class EventMouseIO(Event):
    """ EventMouseIO()

    Contains information about an Ecore mouse input/output event.

    .. seealso :: :func:`on_mouse_in_add`, :func:`on_mouse_out_add`

    :ivar int timestamp: Time when the event occurred
    :ivar int modifiers: :ref:`Ecore_Event_Modifier` The OR combination of modifiers key
    :ivar int x: x coordinate relative to window where event happened
    :ivar int y: y coordinate relative to window where event happened

    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Mouse_IO *obj
        obj = <Ecore_Event_Mouse_IO *>o
        # self.window = Window(<unsigned long><void*>obj.window)
        # self.event_window = Window(<unsigned long><void*>obj.event_window)
        self.timestamp = obj.timestamp
        self.modifiers = obj.modifiers
        self.x = obj.x
        self.y = obj.y
        return 1


cdef class EventMouseWheel(Event):
    """ EventMouseWheel()

    Contains information about an Ecore mouse wheel event.

    .. seealso :: :func:`on_mouse_wheel_add`

    :ivar int timestamp: Time when the event occurred
    :ivar int modifiers: :ref:`Ecore_Event_Modifier` The OR combination of modifiers key
    :ivar bool same_screen: Same screen flag
    :ivar int direction: Orientation of the wheel (horizontal/vertical)
    :ivar int z: Value of the wheel event (+1/-1)
    :ivar int x: x coordinate relative to window where event happened
    :ivar int y: y coordinate relative to window where event happened
    :ivar EventPoint root: Coordinates relative to root window.

    """
    cdef int _set_obj(self, void *o) except 0:
        cdef Ecore_Event_Mouse_Wheel *obj
        obj = <Ecore_Event_Mouse_Wheel *>o
        # self.window = Window(<unsigned long><void*>obj.window)
        # self.root_window = Window(<unsigned long><void*>obj.root_window)
        # self.event_window = Window(<unsigned long><void*>obj.event_window)
        self.timestamp = obj.timestamp
        self.modifiers = obj.modifiers
        self.same_screen = bool(obj.same_screen)
        self.direction = obj.direction
        self.z = obj.z
        self.x = obj.x
        self.y = obj.y
        self.root = EventPoint(obj.root.x, obj.root.y)
        return 1


def on_key_down_add(func, *args, **kargs):
    """
    Creates an ecore event handler for the ECORE_EVENT_KEY_DOWN event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventKey`
    """
    return InputEventHandler(ECORE_EVENT_KEY_DOWN, func, *args, **kargs)

def on_key_up_add(func, *args, **kargs):
    """
    Creates an ecore event handler for the ECORE_EVENT_KEY_UP event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventKey`
    """
    return InputEventHandler(ECORE_EVENT_KEY_UP, func, *args, **kargs)

def on_mouse_button_down_add(func, *args, **kargs):
    """
    Creates an ecore event handler for the ECORE_EVENT_MOUSE_BUTTON_DOWN event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseButton`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_BUTTON_DOWN, func, *args, **kargs)

def on_mouse_button_up_add(func, *args, **kargs):
    """
    Create an ecore event handler for the ECORE_EVENT_MOUSE_BUTTON_UP event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseButton`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_BUTTON_UP, func, *args, **kargs)

def on_mouse_move_add(func, *args, **kargs):
    """
    Create an ecore event handler for the ECORE_EVENT_MOUSE_MOVE event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseMove`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_MOVE, func, *args, **kargs)

def on_mouse_in_add(func, *args, **kargs):
    """
    Create an ecore event handler for the ECORE_EVENT_MOUSE_IN event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseIO`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_IN, func, *args, **kargs)

def on_mouse_out_add(func, *args, **kargs):
    """
    Create an ecore event handler for the ECORE_EVENT_MOUSE_OUT event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseIO`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_OUT, func, *args, **kargs)

def on_mouse_wheel_add(func, *args, **kargs):
    """
    Create an ecore event handler for the ECORE_EVENT_MOUSE_WHEEL event.

    :return: :class:`InputEventHandler`

    .. seealso:: :class:`EventMouseWheel`
    """
    return InputEventHandler(ECORE_EVENT_MOUSE_WHEEL, func, *args, **kargs)
