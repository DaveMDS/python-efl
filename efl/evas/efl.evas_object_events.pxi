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

from cpython cimport PyUnicode_AsUTF8String

from efl.utils.conversions cimport _ctouni

cdef class EventPoint:
    cdef void _set_obj(self, Evas_Point *obj):
        self.obj = obj

    cdef void _unset_obj(self):
        self.obj = NULL

    def __repr__(self):
        self._check_validity()
        return "<%s(%d, %d)>" % (type(self).__name__, self.obj.x, self.obj.y)

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventPoint object is invalid."
        return 1

    property x:
        def __get__(self):
            self._check_validity()
            return self.obj.x

    property y:
        def __get__(self):
            self._check_validity()
            return self.obj.y

    property xy:
        def __get__(self):
            self._check_validity()
            return (self.obj.x, self.obj.y)

    def __len__(self):
        self._check_validity()
        return 2

    def __getitem__(self, int index):
        self._check_validity()
        if index == 0:
            return self.obj.x
        elif index == 1:
            return self.obj.y
        else:
            raise IndexError("list index out of range")


cdef class EventCoordPoint:
    cdef void _set_obj(self, Evas_Coord_Point *obj):
        self.obj = obj

    cdef void _unset_obj(self):
        self.obj = NULL

    def __repr__(self):
        self._check_validity()
        return "<%s(%d, %d)>" % (type(self).__name__, self.obj.x, self.obj.y)

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventCoordPoint object is invalid."
        return 1

    property x:
        def __get__(self):
            self._check_validity()
            return self.obj.x

    property y:
        def __get__(self):
            self._check_validity()
            return self.obj.y

    property xy:
        def __get__(self):
            self._check_validity()
            return (self.obj.x, self.obj.y)

    def __len__(self):
        self._check_validity()
        return 2

    def __getitem__(self, int index):
        self._check_validity()
        if index == 0:
            return self.obj.x
        elif index == 1:
            return self.obj.y
        else:
            raise IndexError("list index out of range")


cdef class EventPrecisionPoint:
    cdef void _set_obj(self, Evas_Coord_Precision_Point *obj):
        self.obj = obj

    cdef void _unset_obj(self):
        self.obj = NULL

    def __repr__(self):
        self._check_validity()
        return "<%s(x=%d, y=%d, xsub=%f, ysub=%f)>" % \
               (type(self).__name__, self.obj.x, self.obj.y,
                self.obj.xsub, self.obj.ysub)

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventPoint object is invalid."
        return 1

    property x:
        def __get__(self):
            self._check_validity()
            return self.obj.x

    property y:
        def __get__(self):
            self._check_validity()
            return self.obj.y

    property xsub:
        def __get__(self):
            self._check_validity()
            return self.obj.xsub

    property ysub:
        def __get__(self):
            self._check_validity()
            return self.obj.ysub

    property xy:
        def __get__(self):
            self._check_validity()
            return (self.obj.x, self.obj.y)

    property xysub:
        def __get__(self):
            self._check_validity()
            return (self.obj.xsub, self.obj.ysub)

    def __len__(self):
        self._check_validity()
        return 4

    def __getitem__(self, int index):
        self._check_validity()
        if index == 0:
            return self.obj.x
        elif index == 1:
            return self.obj.y
        elif index == 2:
            return self.obj.xsub
        elif index == 3:
            return self.obj.ysub
        else:
            raise IndexError("list index out of range")


cdef class EventPosition:
    cdef void _set_objs(self, Evas_Point *output, Evas_Coord_Point *canvas):
        self.output = EventPoint()
        self.output._set_obj(output)
        self.canvas = EventCoordPoint()
        self.canvas._set_obj(canvas)

    cdef void _unset_objs(self):
        self.output._unset_obj()
        self.canvas._unset_obj()

    def __repr__(self):
        return "<%s(output=(%d, %d), canvas=(%d, %d))>" % \
               (type(self).__name__, self.output.x, self.output.y,
                self.canvas.x, self.canvas.y)


cdef class EventPrecisionPosition:
    cdef void _set_objs(self, Evas_Point *output, Evas_Coord_Precision_Point *canvas):
        self.output = EventPoint()
        self.output._set_obj(output)
        self.canvas = EventPrecisionPoint()
        self.canvas._set_obj(canvas)

    cdef void _unset_objs(self):
        self.output._unset_obj()
        self.canvas._unset_obj()

    def __repr__(self):
        return "<%s(output=(%d, %d), canvas=(x=%d, y=%d, xsub=%f, ysub=%f))>" % \
               (type(self).__name__, self.output.x, self.output.y,
                self.canvas.x, self.canvas.y,
                self.canvas.xsub, self.canvas.ysub)


cdef class EventMouseIn:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_In*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseIn object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(buttons=%d, output=(%d, %d), canvas=(%d, %d), "
                "timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.obj.buttons,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.timestamp, self.event_flags)

    property buttons:
        def __get__(self):
            self._check_validity()
            return self.obj.buttons

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMouseOut:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_Out*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseOut object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(buttons=%d, output=(%d, %d), canvas=(%d, %d), "
                "timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.obj.buttons,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.timestamp, self.event_flags)

    property buttons:
        def __get__(self):
            self._check_validity()
            return self.obj.buttons

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMouseDown:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_Down*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseDown object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(button=%d, output=(%d, %d), canvas=(%d, %d), "
                "timestamp=%d, event_flags=%#x, flags=%#x)>") % \
                (type(self).__name__, self.obj.button,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.timestamp, self.event_flags, self.flags)

    property button:
        def __get__(self):
            self._check_validity()
            return self.obj.button

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    property flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMouseUp:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_Up*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseUp object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(button=%d, output=(%d, %d), canvas=(%d, %d), "
                "timestamp=%d, event_flags=%#x, flags=%#x)>") % \
                (type(self).__name__, self.obj.button,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.timestamp, self.event_flags, self.flags)

    property button:
        def __get__(self):
            self._check_validity()
            return self.obj.button

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    property flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMouseMove:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_Move*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.cur.output, &self.obj.cur.canvas)
        self.prev_position = EventPosition()
        self.prev_position._set_objs(&self.obj.prev.output,
                                     &self.obj.prev.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()
        self.prev_position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseMove object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(buttons=%d, output=(%d, %d), canvas=(%d, %d), "
                "prev_output=(%d, %d), prev_canvas=(%d, %d), timestamp=%d, "
                "event_flags=%#x)>") %\
                (type(self).__name__, self.obj.buttons,
                 self.obj.cur.output.x, self.obj.cur.output.y,
                 self.obj.cur.canvas.x, self.obj.cur.canvas.y,
                 self.obj.prev.output.x, self.obj.prev.output.y,
                 self.obj.prev.canvas.x, self.obj.prev.canvas.y,
                 self.obj.timestamp, self.event_flags)

    property buttons:
        def __get__(self):
            self._check_validity()
            return self.obj.buttons

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMultiDown:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Multi_Down*>ptr
        self.position = EventPrecisionPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMultiDown object is invalid."

    def __repr__(self):
        self._check_validity()
        return ("<%s(device=%d, radius=(%f, x=%f, y=%f), pressure=%f, angle=%f, "
                "output=(%d, %d), canvas=(%d, %d, xsub=%f, ysub=%f), "
                "timestamp=%d, event_flags=%#x, flags=%#x)>") % \
                (type(self).__name__, self.obj.device,
                 self.radius, self.radius_x, self.radius_y,
                 self.pressure, self.angle,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.canvas.xsub, self.obj.canvas.ysub,
                 self.obj.timestamp, self.event_flags, self.flags)

    property device:
        def __get__(self):
            self._check_validity()
            return self.obj.device

    property radius:
        def __get__(self):
            self._check_validity()
            return self.obj.radius

    property radius_x:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_x

    property radius_y:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_y

    property pressure:
        def __get__(self):
            self._check_validity()
            return self.obj.pressure

    property angle:
        def __get__(self):
            self._check_validity()
            return self.obj.angle

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    property flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMultiUp:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Multi_Up*>ptr
        self.position = EventPrecisionPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMultiUp object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(device=%d, radius=(%f, x=%f, y=%f), pressure=%f, angle=%f, "
                "output=(%d, %d), canvas=(%d, %d, xsub=%f, ysub=%f), "
                "timestamp=%d, event_flags=%#x, flags=%#x)>") % \
                (type(self).__name__, self.obj.device,
                 self.radius, self.radius_x, self.radius_y,
                 self.pressure, self.angle,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.canvas.xsub, self.obj.canvas.ysub,
                 self.obj.timestamp, self.event_flags, self.flags)

    property device:
        def __get__(self):
            self._check_validity()
            return self.obj.device

    property radius:
        def __get__(self):
            self._check_validity()
            return self.obj.radius

    property radius_x:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_x

    property radius_y:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_y

    property pressure:
        def __get__(self):
            self._check_validity()
            return self.obj.pressure

    property angle:
        def __get__(self):
            self._check_validity()
            return self.obj.angle

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    property flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMultiMove:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Multi_Move*>ptr
        self.position = EventPrecisionPosition()
        self.position._set_objs(&self.obj.cur.output, &self.obj.cur.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMultiMove object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(radius=(%f, x=%f, y=%f), pressure=%f, angle=%f, "
                "output=(%d, %d), canvas=(%d, %d, xsub=%f, ysub=%f), "
                "timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__,
                 self.radius, self.radius_x, self.radius_y,
                 self.pressure, self.angle,
                 self.obj.cur.output.x, self.obj.cur.output.y,
                 self.obj.cur.canvas.x, self.obj.cur.canvas.y,
                 self.obj.cur.canvas.xsub, self.obj.cur.canvas.ysub,
                 self.obj.timestamp, self.event_flags)

    property radius:
        def __get__(self):
            self._check_validity()
            return self.obj.radius

    property radius_x:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_x

    property radius_y:
        def __get__(self):
            self._check_validity()
            return self.obj.radius_y

    property pressure:
        def __get__(self):
            self._check_validity()
            return self.obj.pressure

    property angle:
        def __get__(self):
            self._check_validity()
            return self.obj.angle

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventMouseWheel:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Mouse_Wheel*>ptr
        self.position = EventPosition()
        self.position._set_objs(&self.obj.output, &self.obj.canvas)

    cdef void _unset_obj(self):
        self.obj = NULL
        self.position._unset_objs()

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventMouseWheel object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(direction=%d, z=%d, output=(%d, %d), "
                "canvas=(%d, %d), timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.obj.direction, self.obj.z,
                 self.obj.output.x, self.obj.output.y,
                 self.obj.canvas.x, self.obj.canvas.y,
                 self.obj.timestamp, self.event_flags)

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property direction:
        def __get__(self):
            self._check_validity()
            return self.obj.direction

    property z:
        def __get__(self):
            self._check_validity()
            return self.obj.z

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventKeyDown:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Key_Down*>ptr

    cdef void _unset_obj(self):
        self.obj = NULL

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventKeyDown object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(keyname=%s, key=%s, string=%r, compose=%r, "
                "timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.keyname,
                 self.key, self.string, self.compose,
                 self.obj.timestamp, self.event_flags)

    property keyname:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.keyname)

    property key:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.key)

    property string:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.string)

    property compose:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.compose)

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))


cdef class EventKeyUp:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Key_Up*>ptr

    cdef void _unset_obj(self):
        self.obj = NULL

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventKeyUp object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(keyname=%s, key=%s, string=%r, compose=%r, "
                "timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.keyname,
                 self.key, self.string, self.compose,
                 self.obj.timestamp, self.event_flags)

    property keyname:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.keyname)

    property key:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.key)

    property string:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.string)

    property compose:
        def __get__(self):
            self._check_validity()
            return _ctouni(self.obj.compose)

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags

    def modifier_is_set(self, modifier):
        self._check_validity()
        if isinstance(modifier, unicode): modifier = PyUnicode_AsUTF8String(modifier)
        return bool(evas_key_modifier_is_set(self.obj.modifiers, modifier))

cdef class EventHold:
    cdef void _set_obj(self, void *ptr):
        self.obj = <Evas_Event_Hold*>ptr

    cdef void _unset_obj(self):
        self.obj = NULL

    cdef int _check_validity(self) except 0:
        assert self.obj != NULL, "EventHold object is invalid."
        return 1

    def __repr__(self):
        self._check_validity()
        return ("<%s(hold=%d, timestamp=%d, event_flags=%#x)>") % \
                (type(self).__name__, self.hold,
                 self.obj.timestamp, self.event_flags)

    property hold:
        def __get__(self):
            self._check_validity()
            return self.obj.hold

    property timestamp:
        def __get__(self):
            self._check_validity()
            return self.obj.timestamp

    property event_flags:
        def __get__(self):
            self._check_validity()
            return <int>self.obj.event_flags

        def __set__(self, flags):
            self._check_validity()
            self.obj.event_flags = flags
