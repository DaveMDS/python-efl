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
#

include "scroller_cdef.pxi"

cdef class Scrollable(Object):
    """
    An Elementary scrollable interface will handle an internal **panning**
    object. It has the function of clipping and moving the actual scrollable
    content around, by the command of the scrollable interface calls.

    If a widget supports the scrollable interface, you can inherit from the
    widget class and this class to allow access to the scroller of that widget.

    """

    def __init__(self, *args, **kwargs):
        if type(self) is Scrollable:
            raise TypeError("Must not instantiate Scrollable, but subclasses")

    @DEPRECATED("1.8", "Use :py:attr:`theme<efl.elementary.object.Object.theme>` instead.")
    def custom_widget_base_theme_set(self, widget, base):
        """custom_widget_base_theme_set(widget, base)

        """
        if isinstance(widget, unicode): widget = PyUnicode_AsUTF8String(widget)
        if isinstance(base, unicode): base = PyUnicode_AsUTF8String(base)
        elm_scroller_custom_widget_base_theme_set(self.obj,
            <const char *>widget if widget is not None else NULL,
            <const char *>base if base is not None else NULL)

    def content_min_limit(self, w, h):
        """Make the scroller minimum size limited to the minimum size of the
        content

        By default the scroller will be as small as its design allows,
        irrespective of its content. This will make the scroller minimum
        size the right size horizontally and/or vertically to perfectly fit
        its content in that direction.

        :param w: Enable limiting minimum size horizontally
        :type w: bool
        :param h: Enable limiting minimum size vertically
        :type h: bool

        """
        elm_scroller_content_min_limit(self.obj, w, h)

    def region_show(self, x, y, w, h):
        """Show a specific virtual region within the scroller content object

        This will ensure all (or part if it does not fit) of the designated
        region in the virtual content object (0, 0 starting at the top-left
        of the virtual content object) is shown within the scroller.

        :param x: X coordinate of the region
        :type x: Evas_Coord (int)
        :param y: Y coordinate of the region
        :type y: Evas_Coord (int)
        :param w: Width of the region
        :type w: Evas_Coord (int)
        :param h: Height of the region
        :type h: Evas_Coord (int)

        """
        elm_scroller_region_show(self.obj, x, y, w, h)

    property policy:
        """The scrollbar visibility policy

        This property reflects the scrollbar visibility policy for the given
        scroller. :attr:`ELM_SCROLLER_POLICY_AUTO` means the scrollbar is made
        visible if it is needed, and otherwise kept hidden.
        :attr:`ELM_SCROLLER_POLICY_ON` turns it on all the time, and
        :attr:`ELM_SCROLLER_POLICY_OFF` always keeps it off. This applies
        respectively for the horizontal and vertical scrollbars.

        :type: (:ref:`Elm_Scroller_Policy` **policy_h**, :ref:`Elm_Scroller_Policy` **policy_v**)

        """
        def __get__(self):
            cdef Elm_Scroller_Policy policy_h, policy_v
            elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
            return (policy_h, policy_v)

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            elm_scroller_policy_set(self.obj, policy_h, policy_v)

    def policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    def policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property single_direction:
        """The type of single direction scroll

        :type: :ref:`Elm_Scroller_Single_Direction`

        .. versionadded:: 1.8

        """
        def __set__(self, Elm_Scroller_Single_Direction single_dir):
            elm_scroller_single_direction_set(self.obj, single_dir)

        def __get__(self):
            return elm_scroller_single_direction_get(self.obj)

    def single_direction_set(self, Elm_Scroller_Single_Direction single_dir):
        elm_scroller_single_direction_set(self.obj, single_dir)

    def single_direction_get(self):
        return elm_scroller_single_direction_get(self.obj)

    property region:
        """Get the currently visible content region

        This gets the current region in the content object that is visible
        through the scroller. The region co-ordinates are returned in the
        *x*, *y*, *w*, ``h`` values pointed to.

        .. note:: All coordinates are relative to the content.

        .. seealso:: :py:func:`region_show()`

        :type: tuple of Evas_Coord (int)

        """
        def __get__(self):
            cdef Evas_Coord x, y, w, h
            elm_scroller_region_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

    def region_get(self):
        cdef Evas_Coord x, y, w, h
        elm_scroller_region_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    property child_size:
        """Get the size of the content object

        This gets the size of the content object of the scroller.

        :type: (int **w**, int **h**)

        """
        def __get__(self):
            cdef Evas_Coord w, h
            elm_scroller_child_size_get(self.obj, &w, &h)
            return (w, h)

    def child_size_get(self):
        cdef Evas_Coord w, h
        elm_scroller_child_size_get(self.obj, &w, &h)
        return (w, h)

    property page_snap:
        """

        Page snapping behavior of a scroller

        When scrolling, if a scroller is paged (see
        :attr:`page_size` and :attr:`page_relative`),
        the scroller may snap to pages when being scrolled, i.e., even if
        it had momentum to scroll further, it will stop at the next page
        boundaries. This is **disabled**, by default, for both axis. This
        function will set if it that is enabled or not, for each axis.

        .. note::

            If the object is not set to have pages, nothing will happen after
            this call.

        :type: (bool **page_h_snap**, bool **page_v_snap**)

        .. versionadded:: 1.8


        """
        def __set__(self, value):
            page_h_snap, page_v_snap = value
            elm_scroller_page_snap_set(self.obj, page_h_snap, page_v_snap)

        def __get__(self):
            cdef Eina_Bool page_h_snap, page_v_snap
            elm_scroller_page_snap_get(self.obj, &page_h_snap, &page_v_snap)
            return page_h_snap, page_v_snap

    property bounce:
        """The bouncing behavior

        When scrolling, the scroller may "bounce" when reaching an edge of
        the content object. This is a visual way to indicate the end has
        been reached. This is enabled by default for both axis. This API
        will set if it is enabled for the given axis with the boolean
        parameters for each axis.

        :type: (bool **h**, bool **v**)

        """
        def __get__(self):
            cdef Eina_Bool h, v
            elm_scroller_bounce_get(self.obj, &h, &v)
            return (h, v)

        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            elm_scroller_bounce_set(self.obj, h, v)

    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

    property page_relative:
        """Set scroll page size relative to viewport size.

        The scroller is capable of limiting scrolling by the user to
        "pages". That is to jump by and only show a "whole page" at a time
        as if the continuous area of the scroller content is split into page
        sized pieces. This sets the size of a page relative to the viewport
        of the scroller. 1.0 is "one viewport" in size (horizontally or
        vertically). 0.0 turns it off in that axis. This is mutually
        exclusive with page size (see :py:attr:`page_size` for more
        information). Likewise 0.5 is "half a viewport". Sane usable values
        are normally between 0.0 and 1.0 including 1.0. If you only want a
        single axis to be page "limited", use 0.0 for the other axis.

        :type: (float **h_pagerel**, float **v_pagerel**)

        """
        def __set__(self, value):
            h_pagerel, v_pagerel = value
            elm_scroller_page_relative_set(self.obj, h_pagerel, v_pagerel)

        def __get__(self):
            cdef double h_pagerel, v_pagerel
            elm_scroller_page_relative_get(self.obj, &h_pagerel, &v_pagerel)
            return (h_pagerel, v_pagerel)

    def page_relative_set(self, h_pagerel, v_pagerel):
        elm_scroller_page_relative_set(self.obj, h_pagerel, v_pagerel)

    def page_relative_get(self):
        cdef double h_pagerel, v_pagerel
        elm_scroller_page_relative_get(self.obj, &h_pagerel, &v_pagerel)
        return (h_pagerel, v_pagerel)

    property page_size:
        """Scroller widget's current page size.

        An absolute fixed value, with 0 turning it off for that axis.

        .. seealso:: :attr:`page_relative`

        :type: (int **h_pagesize**, int **v_pagesize**)

        .. versionadded:: 1.8
            Getter for this property

        """
        def __set__(self, value):
            h_pagesize, v_pagesize = value
            elm_scroller_page_size_set(self.obj, h_pagesize, v_pagesize)

        def __get__(self):
            cdef int h_pagesize, v_pagesize
            elm_scroller_page_size_get(self.obj, &h_pagesize,  &v_pagesize)
            return (h_pagesize, v_pagesize)

    def page_size_set(self, h_pagesize, v_pagesize):
        elm_scroller_page_size_set(self.obj, h_pagesize, v_pagesize)

    def page_size_get(self):
        cdef int h_pagesize, v_pagesize
        elm_scroller_page_size_get(self.obj, &h_pagesize,  &v_pagesize)
        return (h_pagesize, v_pagesize)

    property step_size:
        """The step size to move scroller by key event.

        :type: (int **x**, int **y**)

        .. versionadded:: 1.13

        """
        def __set__(self, value):
            x, y = value
            elm_scroller_step_size_set(self.obj, x, y)

        def __get__(self):
            cdef int x, y
            elm_scroller_step_size_get(self.obj, &x,  &y)
            return (x, y)

    def step_size_set(self, x, y):
        elm_scroller_step_size_set(self.obj, x, y)

    def step_size_get(self):
        cdef int x, y
        elm_scroller_step_size_get(self.obj, &x,  &y)
        return (x, y)

    property page_scroll_limit:
        """The maximum of the movable page at a flicking.

        The value of maximum movable page should be more than 1.

        :type: (int **page_limit_h**, int **page_limit_v**)

        .. versionadded:: 1.8

        """
        def __set__(self, value):
            page_limit_h, page_limit_v = value
            elm_scroller_page_scroll_limit_set(self.obj, page_limit_h, page_limit_v)

        def __get__(self):
            cdef int page_limit_h, page_limit_v
            elm_scroller_page_scroll_limit_get(self.obj, &page_limit_h, &page_limit_v)
            return (page_limit_h, page_limit_v)

    def page_scroll_limit_set(self, int page_limit_h, int page_limit_v):
        elm_scroller_page_scroll_limit_set(self.obj, page_limit_h, page_limit_v)

    def page_scroll_limit_get(self):
        cdef int page_limit_h, page_limit_v
        elm_scroller_page_scroll_limit_get(self.obj, &page_limit_h, &page_limit_v)
        return (page_limit_h, page_limit_v)

    property current_page:
        """Get scroll current page number.

        The page number starts from 0. 0 is the first page. Current page
        means the page which meets the top-left of the viewport. If there
        are two or more pages in the viewport, it returns the number of the
        page which meets the top-left of the viewport.

        .. seealso::
            :py:attr:`last_page`
            :py:func:`page_show()`
            :py:func:`page_bring_in()`

        :type: (int **h_pagenumber**, int **v_pagenumber**)

        """
        def __get__(self):
            cdef int h_pagenumber, v_pagenumber
            elm_scroller_current_page_get(self.obj, &h_pagenumber, &v_pagenumber)
            return (h_pagenumber, v_pagenumber)

    def current_page_get(self):
        cdef int h_pagenumber, v_pagenumber
        elm_scroller_current_page_get(self.obj, &h_pagenumber, &v_pagenumber)
        return (h_pagenumber, v_pagenumber)

    property last_page:
        """Get scroll last page number.

        The page number starts from 0. 0 is the first page.
        This returns the last page number among the pages.

        .. seealso::
            :py:attr:`current_page`
            :py:func:`page_show()`
            :py:func:`page_bring_in()`

        :type: (int **h_pagenumber**, int **v_pagenumber**)

        """
        def __get__(self):
            cdef int h_pagenumber, v_pagenumber
            elm_scroller_last_page_get(self.obj, &h_pagenumber, &v_pagenumber)
            return (h_pagenumber, v_pagenumber)

    def last_page_get(self):
        cdef int h_pagenumber, v_pagenumber
        elm_scroller_last_page_get(self.obj, &h_pagenumber, &v_pagenumber)
        return (h_pagenumber, v_pagenumber)

    def page_show(self, h_pagenumber, v_pagenumber):
        """Show a specific virtual region within the scroller content object
        by page number.

        0, 0 of the indicated page is located at the top-left of the viewport.
        This will jump to the page directly without animation.

        Example of usage::

            sc = Scroller(win)
            sc.content = content
            sc.page_relative = (1, 0)
            h_page, v_page = sc.current_page
            sc.page_show(h_page + 1, v_page)

        .. seealso:: :py:func:`page_bring_in()`

        :param h_pagenumber: The horizontal page number
        :type h_pagenumber: int
        :param v_pagenumber: The vertical page number
        :type v_pagenumber: int

        """
        elm_scroller_page_show(self.obj, h_pagenumber, v_pagenumber)

    def page_bring_in(self, h_pagenumber, v_pagenumber):
        """Show a specific virtual region within the scroller content object by page number.

        0, 0 of the indicated page is located at the top-left of the viewport.
        This will slide to the page with animation.

        Example of usage::

            sc = Scroller(win)
            sc.content = content
            sc.page_relative = (1, 0)
            h_page, v_page = sc.last_page
            sc.page_bring_in(h_page, v_page)

        .. seealso:: :py:func:`page_show()`

        :param h_pagenumber: The horizontal page number
        :type h_pagenumber: int
        :param v_pagenumber: The vertical page number
        :type v_pagenumber: int

        """
        elm_scroller_page_bring_in(self.obj, h_pagenumber, v_pagenumber)

    def region_bring_in(self, x, y, w, h):
        """Show a specific virtual region within the scroller content object.

        This will ensure all (or part if it does not fit) of the designated
        region in the virtual content object (0, 0 starting at the top-left of the
        virtual content object) is shown within the scroller. Unlike
        elm_scroller_region_show(), this allow the scroller to "smoothly slide"
        to this location (if configuration in general calls for transitions). It
        may not jump immediately to the new location and make take a while and
        show other content along the way.

        .. seealso:: :py:func:`region_show()`

        :param x: X coordinate of the region
        :type x: Evas_Coord (int)
        :param y: Y coordinate of the region
        :type y: Evas_Coord (int)
        :param w: Width of the region
        :type w: Evas_Coord (int)
        :param h: Height of the region
        :type h: Evas_Coord (int)

        """
        elm_scroller_region_bring_in(self.obj, x, y, w, h)

    property propagate_events:
        """Event propagation for a scroller

        This enables or disables event propagation from the scroller content
        to the scroller and its parent. By default event propagation is
        disabled.

        :type: bool

        """
        def __get__(self):
            return bool(elm_scroller_propagate_events_get(self.obj))

        def __set__(self, propagation):
            elm_scroller_propagate_events_set(self.obj, propagation)

    def propagate_events_set(self, propagation):
        elm_scroller_propagate_events_set(self.obj, propagation)
    def propagate_events_get(self):
        return bool(elm_scroller_propagate_events_get(self.obj))

    property wheel_disabled:
        """Enable or disable mouse wheel to be used to scroll the scroller.
        
        Mouse wheel can be used to scroll up and down the scroller.
        Wheel is enabled by default.

        :type: bool
        
        .. versionadded:: 1.15

        """
        def __get__(self):
            return bool(elm_scroller_wheel_disabled_get(self.obj))

        def __set__(self, disabled):
            elm_scroller_wheel_disabled_set(self.obj, disabled)

    def wheel_disabled_set(self, disabled):
        elm_scroller_wheel_disabled_set(self.obj, disabled)
    def wheel_disabled_get(self):
        return bool(elm_scroller_wheel_disabled_get(self.obj))

    property gravity:
        """Scrolling gravity on a scroller

        The gravity, defines how the scroller will adjust its view when the
        size of the scroller contents increase.

        The scroller will adjust the view to glue itself as follows:

        ``x=0.0``, for showing the left most region of the content.
        ``x=1.0``, for showing the right most region of the content.
        ``y=0.0``, for showing the bottom most region of the content.
        ``y=1.0``, for showing the top most region of the content.

        Default values for x and y are 0.0

        :type: (float **x**, float **y**)

        """
        def __get__(self):
            cdef double x, y
            elm_scroller_gravity_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, value):
            x, y = value
            elm_scroller_gravity_set(self.obj, x, y)

    def gravity_set(self, x, y):
        elm_scroller_gravity_set(self.obj, x, y)
    def gravity_get(self):
        cdef double x, y
        elm_scroller_gravity_get(self.obj, &x, &y)
        return (x, y)

    property movement_block:
        """

        Blocking of scrolling (per axis) on a given scroller

        This function will block scrolling movement (by input of a user) in
        a given direction. One can disable movements in the X axis, the Y
        axis or both. The default value is :attr:`ELM_SCROLLER_MOVEMENT_NO_BLOCK`,
        where movements are allowed in both directions.

        What makes this function different from
        :meth:`~efl.elementary.object.Object.scroll_freeze_push`,
        :meth:`~efl.elementary.object.Object.scroll_hold_push` and
        :meth:`~efl.elementary.object.Object.scroll_lock_x_set`
        (or :meth:`~efl.elementary.object.Object.scroll_lock_x_set`)
        is that it **doesn't** propagate its effects to any parent or child
        widget of the object. Only the target scrollable widget will be locked
        with regard to scrolling.

        :type: :ref:`Elm_Scroller_Movement_Block`

        .. versionadded:: 1.8

        """
        def __set__(self, Elm_Scroller_Movement_Block block):
            elm_scroller_movement_block_set(self.obj, block)

        def __get__(self):
            return elm_scroller_movement_block_get(self.obj)

    property loop:
        """

        Set an infinite loop for the scroller

        :type: (bool **h**, bool **v**)

        .. versionadded:: 1.14

        """
        def __set__(self, value):
            h, v = value
            elm_scroller_loop_set(self.obj, h, v)

        def __get__(self):
            cdef Eina_Bool h, v
            elm_scroller_loop_get(self.obj, &h, &v)
            return (h, v)

    def loop_set(self, h, v):
        elm_scroller_loop_set(self.obj, h, v)
    def loop_get(self):
        cdef Eina_Bool h, v
        elm_scroller_loop_get(self.obj, &h, &v)
        return (h, v)

    def callback_edge_left_add(self, func, *args, **kwargs):
        """The left edge of the content has been reached."""
        self._callback_add("edge,left", func, args, kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left", func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        """The right edge of the content has been reached."""
        self._callback_add("edge,right", func, args, kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right", func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        """The top edge of the content has been reached."""
        self._callback_add("edge,top", func, args, kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top", func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        """The bottom edge of the content has been reached."""
        self._callback_add("edge,bottom", func, args, kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom", func)

    def callback_scroll_add(self, func, *args, **kwargs):
        """The content has been scrolled (moved)."""
        self._callback_add("scroll", func, args, kwargs)

    def callback_scroll_del(self, func):
        self._callback_del("scroll", func)

    def callback_scroll_left_add(self, func, *args, **kwargs):
        """the content has been scrolled (moved) leftwards"""
        self._callback_add("scroll,left", func, args, kwargs)

    def callback_scroll_left_del(self, func):
        self._callback_del("scroll,left", func)

    def callback_scroll_right_add(self, func, *args, **kwargs):
        """the content has been scrolled (moved) rightwards"""
        self._callback_add("scroll,right", func, args, kwargs)

    def callback_scroll_right_del(self, func):
        self._callback_del("scroll,right", func)

    def callback_scroll_up_add(self, func, *args, **kwargs):
        """the content has been scrolled (moved) upwards"""
        self._callback_add("scroll,up", func, args, kwargs)

    def callback_scroll_up_del(self, func):
        self._callback_del("scroll,up", func)

    def callback_scroll_down_add(self, func, *args, **kwargs):
        """the content has been scrolled (moved) downwards"""
        self._callback_add("scroll,down", func, args, kwargs)

    def callback_scroll_down_del(self, func):
        self._callback_del("scroll,down", func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        """Scrolling animation has started."""
        self._callback_add("scroll,anim,start", func, args, kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        """Scrolling animation has stopped."""
        self._callback_add("scroll,anim,stop", func, args, kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        """Dragging the contents around has started."""
        self._callback_add("scroll,drag,start", func, args, kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        """Dragging the contents around has stopped."""
        self._callback_add("scroll,drag,stop", func, args, kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)

    def callback_vbar_drag_add(self, func, *args, **kwargs):
        """the vertical scroll bar has been dragged"""
        self._callback_add("vbar,drag", func, args, kwargs)

    def callback_vbar_drag_del(self, func):
        self._callback_del("vbar,drag", func)

    def callback_vbar_press_add(self, func, *args, **kwargs):
        """the vertical scroll bar has been pressed"""
        self._callback_add("vbar,press", func, args, kwargs)

    def callback_vbar_press_del(self, func):
        self._callback_del("vbar,press", func)

    def callback_vbar_unpress_add(self, func, *args, **kwargs):
        """the vertical scroll bar has been unpressed"""
        self._callback_add("vbar,unpress", func, args, kwargs)

    def callback_vbar_unpress_del(self, func):
        self._callback_del("vbar,unpress", func)

    def callback_hbar_drag_add(self, func, *args, **kwargs):
        """the horizontal scroll bar has been dragged"""
        self._callback_add("hbar,drag", func, args, kwargs)

    def callback_hbar_drag_del(self, func):
        self._callback_del("hbar,drag", func)

    def callback_hbar_press_add(self, func, *args, **kwargs):
        """the horizontal scroll bar has been pressed"""
        self._callback_add("hbar,press", func, args, kwargs)

    def callback_hbar_press_del(self, func):
        self._callback_del("hbar,press", func)

    def callback_hbar_unpress_add(self, func, *args, **kwargs):
        """the horizontal scroll bar has been unpressed"""
        self._callback_add("hbar,unpress", func, args, kwargs)

    def callback_hbar_unpress_del(self, func):
        self._callback_del("hbar,unpress", func)

    def callback_scroll_page_changed_add(self, func, *args, **kwargs):
        """the visible page has changed"""
        self._callback_add("scroll,page,changed", func, args, kwargs)

    def callback_scroll_page_changed_del(self, func):
        self._callback_del("scroll,page,changed", func)


cdef class _ScrollerWidget(LayoutClass):
    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_scroller_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)


class Scroller(Scrollable, _ScrollerWidget):
    """Scroller(..)

    This is the class that actually implement the widget.

    """
    def __init__(self, evasObject parent, *args, **kwargs):
        _ScrollerWidget.__init__(self, parent, *args, **kwargs)


_object_mapping_register("Elm_Scroller", Scroller)
