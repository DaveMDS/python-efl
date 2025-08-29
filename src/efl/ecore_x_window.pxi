# Copyright (C) 2007-2022 various contributors (see AUTHORS)
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

cdef class Window:
    def __init__(self, Window parent=None, int x=0, int y=0, int w=1, int h=1,
                 input=False, argb=False, override_redirect=False):
        """Create a new X window.

        :param parent: window to use as parent, or None to use the
               root window.
        :param x: horizontal position.
        :param y: vertical position.
        :param w: horizontal size.
        :param h: vertical size.
        :param input: if should be an input-only window or not.
        :param argb: if window should be ARGB.
        :param override_redirect: if override redirect attribute must be set.
        """
        cdef Ecore_X_Window p_xid, xid
        if parent is <Window>None:
            p_xid = 0
        else:
            p_xid = parent.xid

        if not input and not argb and not override_redirect:
            xid = ecore_x_window_new(p_xid, x, y, w, h)
        elif argb:
            if not override_redirect:
                xid = ecore_x_window_argb_new(p_xid, x, y, w, h)
            else:
                xid = ecore_x_window_override_argb_new(p_xid, x, y, w, h)
        elif input:
            xid = ecore_x_window_input_new(p_xid, x, y, w, h)
        elif override_redirect:
            xid = ecore_x_window_override_new(p_xid, x, y, w, h)
        else:
            raise ValueError("not able to create window!")

        self._set_xid(xid)

    cdef int _set_xid(self, Ecore_X_Window xid) except 0:
        if self.xid == 0:
            self.xid = xid
            return 1
        else:
            raise ValueError("object already wraps an X Window.")

    def __str__(self):
        cdef int x, y, w, h, visible
        cdef unsigned int parent

        ecore_x_window_geometry_get(self.xid, &x, &y, &w, &h)
        parent = ecore_x_window_parent_get(self.xid)
        visible = ecore_x_window_visible_get(self.xid)
        return "%s(xid=%#x, parent=%#x, x=%d, y=%d, w=%d, h=%d, visible=%s)" % \
               (self.__class__.__name__, self.xid, parent, x, y, w, h,
                bool(visible))

    def __repr__(self):
        cdef int x, y, w, h
        cdef unsigned int parent

        ecore_x_window_geometry_get(self.xid, &x, &y, &w, &h)
        parent = ecore_x_window_parent_get(self.xid)
        return "%s(%#x, xid=%#x, parent=%#x, x=%d, y=%d, w=%d, h=%d)" % \
               (self.__class__.__name__, <unsigned long><void *>self,
                self.xid, parent, x, y, w, h)

    def __richcmp__(self, other, int op):
        if op == 2: # equal
            if self is other:
                return 1
            else:
                return self.xid == int(other)
        else:
            return 0

    def __int__(self):
        return self.xid

    def __long__(self):
        return self.xid

    def delete(self):
        "Deletes the current window."
        if self.xid != 0:
            ecore_x_window_free(self.xid)
            self.xid = 0

    def delete_request_send(self):
        "Sends a delete request to this window."
        ecore_x_window_delete_request_send(self.xid)

    def root_get(self):
        ":rtype: Window"
        cdef Ecore_X_Window xid
        xid = ecore_x_window_root_get(self.xid)
        return Window_from_xid(xid)

    def reparent(self, Window new_parent=None, int x=0, int y=0):
        """Moves this window to within another window at a given position.

        :param new_parent: window to use as parent, or None to use the root
           window.
        :param x: horizontal position within the new parent.
        :param y: vertical position within the new parent.
        """
        cdef Ecore_X_Window p_xid
        if new_parent is <Window>None:
            p_xid = 0
        else:
            p_xid = new_parent.xid
        ecore_x_window_reparent(self.xid, p_xid, x, y)

    def parent_set(self, Window new_parent=None):
        """Set window parent.

        :param new_parent: window to use as parent, or None to use the root
           window.
        :see: same as :py:meth:`reparent` with both x and y being 0.
        """
        cdef Ecore_X_Window p_xid
        if new_parent is <Window>None:
            p_xid = 0
        else:
            p_xid = new_parent.xid
        ecore_x_window_reparent(self.xid, p_xid, 0, 0)

    def parent_get(self):
        ":rtype: Window"
        cdef Ecore_X_Window xid
        xid = ecore_x_window_parent_get(self.xid)
        return Window_from_xid(xid)

    property parent:
        def __set__(self, value):
            self.parent_set(value)

        def __get__(self):
            return self.parent_get()

    def show(self):
        """Shows this window.

        Synonymous to "mapping" a window in X Window System terminology.
        """
        ecore_x_window_show(self.xid)

    def hide(self):
        """Hides a window.

        Synonymous to "unmapping" a window in X Window System terminology.
        """
        ecore_x_window_hide(self.xid)

    def visible_set(self, value):
        if value:
            self.show()
        else:
            self.hide()

    def visible_get(self):
        ":rtype: bool"
        return bool(ecore_x_window_visible_get(self.xid))

    def focus(self):
        "Give focus to this windows."
        ecore_x_window_focus(self.xid)

    def focus_at_time(self, Ecore_X_Time time):
        """Sets the focus this window at a specific time.

        :param time: time specification, see :py:meth:`current_time_get`.
        """
        ecore_x_window_focus_at_time(self.xid, time)

    def ignore_set(self, int setting):
        ecore_x_window_ignore_set(self.xid, bool(setting))

    def raise_(self):
        "Raises this window."
        ecore_x_window_raise(self.xid)

    def lower(self):
        "Lowers this window."
        ecore_x_window_lower(self.xid)

    def move(self, int x, int y):
        """Set window position.

        :param x: horizontal.
        :param y: vertical.
        """
        ecore_x_window_move(self.xid, x, y)

    def pos_set(self, int x, int y):
        """Set window position.

        :param x: horizontal.
        :param y: vertical.

        .. note:: alias for :py:meth:`move`
        """
        ecore_x_window_move(self.xid, x, y)

    def pos_get(self):
        ":rtype: tuple of int"
        cdef int x, y, w, h
        ecore_x_window_geometry_get(self.xid, &x, &y, &w, &h)
        return (x, y)

    property pos:
        def __set__(self, spec):
            self.pos_set(*spec)

        def __get__(self):
            return self.pos_get()

    def resize(self, int w, int h):
        """Set window size.

        :param w: horizontal.
        :param h: vertical.
        """
        ecore_x_window_resize(self.xid, w, h)

    def size_set(self, int w, int h):
        """Set window size.

        :param w: horizontal.
        :param h: vertical.

        .. note:: alias for :py:meth:`resize`
        """
        ecore_x_window_resize(self.xid, w, h)

    def size_get(self):
        ":rtype: tuple of int"
        cdef int w, h
        ecore_x_window_size_get(self.xid, &w, &h)
        return (w, h)

    property size:
        def __set__(self, spec):
            self.size_set(*spec)

        def __get__(self):
            return self.size_get()

    def move_resize(self, int x, int y, int w, int h):
        """Set both position and size.

        :param x: horizontal position.
        :param y: vertical position.
        :param w: horizontal size.
        :param h: vertical size.
        """
        ecore_x_window_move_resize(self.xid, x, y, w, h)

    def geometry_set(self, int x, int y, int w, int h):
        """Set both position and size.

        :param x: horizontal position.
        :param y: vertical position.
        :param w: horizontal size.
        :param h: vertical size.
        """
        ecore_x_window_move_resize(self.xid, x, y, w, h)

    def geometry_get(self):
        ":rtype: tuple of int"
        cdef int x, y, w, h
        ecore_x_window_geometry_get(self.xid, &x, &y, &w, &h)
        return (x, y, w, h)

    property geometry:
        def __set__(self, spec):
            self.geometry_set(*spec)

        def __get__(self):
            return self.geometry_get()

    def border_width_set(self, int width):
        """Sets the width of the border of this window.

        :param width: border width, in pixels.
        """
        ecore_x_window_border_width_set(self.xid, width)

    def border_width_get(self):
        ":rtype: int"
        return ecore_x_window_border_width_get(self.xid)

    property border_width:
        def __set__(self, spec):
            self.border_width_set(*spec)

        def __get__(self):
            return self.border_width_get()

    def depth_get(self):
        ":rtype: int"
        return ecore_x_window_depth_get(self.xid)

    property depth:
        def __get__(self):
            return self.depth_get()

    def configure(self, int mask, int x, int y, int w, int h, int border_width,
                  Window sibling, int stack_mode):
        cdef Ecore_X_Window sibling_xid
        if sibling is <Window>None:
            sibling_xid = 0
        else:
            sibling_xid = sibling.xid
        ecore_x_window_configure(self.xid, <Ecore_X_Window_Configure_Mask>mask,
                                 x, y, w, h, border_width, sibling_xid,
                                 stack_mode)

    def cursor_show(self):
        ecore_x_window_cursor_show(self.xid, 1)

    def cursor_hide(self):
        ecore_x_window_cursor_show(self.xid, 0)

    def cursor_set(self, Ecore_X_Cursor cursor):
        ecore_x_window_cursor_set(self.xid, cursor)

    def pointer_warp(self, int x, int y):
        ecore_x_pointer_warp(self.xid, x, y)

    def pointer_xy_get(self):
        cdef int x, y
        ecore_x_pointer_xy_get(self.xid, &x, &y);
        return (x, y)

    def defaults_set(self):
        """Sets the default properties for the given window.

        The default properties set for the window are WM_CLIENT_MACHINE and
        _NET_WM_PID.
        """
        ecore_x_window_defaults_set(self.xid)

    def killall_children(self):
        "Kill all clients with subwindows under this window."
        ecore_x_killall(self.xid)

    def kill(self):
        "Kill this specific client"
        ecore_x_kill(self.xid)

    def background_color_set(self, int r, int g, int b):
        """Set background color.

        :param r: red (0...65536, 16 bits)
        :param g: green (0...65536, 16 bits)
        :param b: blue (0...65536, 16 bits)
        """
        ecore_x_window_background_color_set(self.xid, r, g, b)

    def area_clear(self, int x, int y, int w, int h):
        "Paints the specified area with background's color or pixmap."
        ecore_x_window_area_clear(self.xid, x, y, w, h)

    def area_expose(self, int x, int y, int w, int h):
        "Like :py:meth:`area_clear`, but generates exposures."
        ecore_x_window_area_expose(self.xid, x, y, w, h)

    def override_set(self, int setting):
        ecore_x_window_override_set(self.xid, bool(setting))

    def argb_get(self):
        ":rtype: bool"
        return bool(ecore_x_window_argb_get(self.xid))

    def gravity_set(self, int gravity):
        ecore_x_window_gravity_set(self.xid, <Ecore_X_Gravity>gravity)

    def pixel_gravity_set(self, int gravity):
        ecore_x_window_pixel_gravity_set(self.xid, <Ecore_X_Gravity>gravity)

    def event_mask_set(self, int mask):
        ecore_x_event_mask_set(self.xid, <Ecore_X_Event_Mask>mask)

    def event_mask_unset(self, int mask):
        ecore_x_event_mask_unset(self.xid, <Ecore_X_Event_Mask>mask)

    def icccm_hints_set(self, int accepts_focus, int initial_state,
            int icon_pixmap, int icon_mask, int icon_window,
                        int window_group, int is_urgent):
        """Set ICCCM window hints.

        :param accepts_focus: if window accepts focus or not.
        :param initial_state: one of ECORE_X_WINDOW_STATE_HINT_*.
        :param icon_pixmap: pixmap id to be used as icon.
        :param icon_mask: pixmap id to be used as icon mask.
        :param icon_window: window id to be used as icon.
        :param window_group: window id representing the group.
        :param is_urgent: if window is urgent or not.
        """
        ecore_x_icccm_hints_set(self.xid, accepts_focus,
                                <Ecore_X_Window_State_Hint>initial_state,
                                icon_pixmap, icon_mask, icon_window,
                                window_group, is_urgent)

    def icccm_hints_get(self):
        """Get ICCCM window hints.

        :see: :py:meth:`icccm_hints_set`
        :return: tuple with: accepts_focus, initial_state, icon_pixmap,
                 icon_mask, icon_window, window_group, is_urgent
        """
        cdef Eina_Bool accepts_focus, is_urgent
        cdef int initial_state, icon_pixmap, icon_mask, \
             icon_window, window_group
        ecore_x_icccm_hints_get(self.xid, &accepts_focus,
                                <Ecore_X_Window_State_Hint *>&initial_state,
                                <Ecore_X_Pixmap *>&icon_pixmap,
                                <Ecore_X_Pixmap *>&icon_mask,
                                <Ecore_X_Window *>&icon_window,
                                <Ecore_X_Window *>&window_group,
                                &is_urgent)
        return (bool(accepts_focus), initial_state, icon_pixmap, icon_mask,
                icon_window, window_group, bool(is_urgent))

    def type_set(self, int type):
        ecore_x_netwm_window_type_set(self.xid, <Ecore_X_Window_Type>type)

    def state_set(self, states):
        # building list
        cdef Ecore_X_Window_State *_states
        _states = <Ecore_X_Window_State *>PyMem_Malloc(len(states) * sizeof(Ecore_X_Window_State))
        for i in xrange(len(states)):
            _states[i] = states[i]

        ecore_x_netwm_window_state_set(self.xid, _states, len(states))
        PyMem_Free(<void*>_states)

    def keyboard_grab(self):
        return bool(ecore_x_keyboard_grab(self.xid))

def Window_from_xid(unsigned long xid):
    """Create a Python wrapper for given window id.

    :param xid: window id.
    :rtype: L{Window}
    """
    cdef Window w
    w = Window.__new__(Window)
    w._set_xid(xid)
    return w
