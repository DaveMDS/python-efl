# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

include "widget_header.pxi"

from layout_class cimport LayoutClass

from object_item cimport    _object_item_to_python, \
                            _object_item_list_to_python

cdef class NaviframeItem(ObjectItem):

    """

    An item for the Naviframe widget.

    """

    cdef unicode label, item_style
    cdef Evas_Object *prev_btn, *next_btn, *item_content

    def __cinit__(self):
        self.prev_btn = NULL
        self.next_btn = NULL
        self.item_content = NULL

    def __init__(self, title_label = None, evasObject prev_btn = None,
        evasObject next_btn = None, evasObject content = None,
        item_style = None):

        """The following styles are available for this item:

        - ``"default"``

        :param title_label: The label in the title area. The name of the
            title label part is "elm.text.title"
        :type title_label: string
        :param prev_btn: The button to go to the previous item. If it is
            None, then naviframe will create a back button automatically. The
            name of the prev_btn part is "elm.swallow.prev_btn"
        :type prev_btn: :py:class:`elementary.button.Button`
        :param next_btn: The button to go to the next item. Or It could be
            just an extra function button. The name of the next_btn part is
            "elm.swallow.next_btn"
        :type next_btn: :py:class:`elementary.button.Button`
        :param content: The main content object. The name of content part is
            "elm.swallow.content"
        :type content: :py:class:`elementary.object.Object`
        :param item_style: The current item style name. ``None`` would be
            default.
        :type item_style: string

        """
        self.label = unicode(title_label)

        if prev_btn is not None:
            self.prev_btn = prev_btn.obj
        if next_btn is not None:
            self.next_btn = next_btn.obj
        if content is not None:
            self.item_content = content.obj

    def push_to(self, Naviframe naviframe):
        """push_to(Naviframe naviframe)

        Push a new item to the top of the naviframe stack (and show it).

        The item pushed becomes one page of the naviframe, this item will be
        deleted when it is popped.

        .. seealso::
            :py:attr:`style`
            :py:func:`insert_before()`
            :py:func:`insert_after()`

        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`NaviframeItem`

        """
        cdef Elm_Object_Item *item = elm_naviframe_item_push(
            naviframe.obj,
            _cfruni(self.label) if self.label else NULL,
            self.prev_btn,
            self.next_btn,
            self.item_content,
            _cfruni(self.item_style) if self.item_style else NULL)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            return None

    def insert_before(self, NaviframeItem before):
        """insert_before(NaviframeItem before)

        Insert a new item into the naviframe before item *before*.

        The item is inserted into the naviframe straight away without any
        transition operations. This item will be deleted when it is popped.

        .. seealso::
            :py:attr:`style`
            :py:func:`push_to()`
            :py:func:`insert_after()`

        :param before: The naviframe item to insert before.
        :type before: :py:class:`NaviframeItem`

        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`NaviframeItem`

        """
        cdef Naviframe naviframe = before.widget
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_insert_before(
            naviframe.obj,
            before.item,
            _cfruni(self.label) if self.label else NULL,
            self.prev_btn,
            self.next_btn,
            self.item_content,
            _cfruni(self.item_style) if self.item_style else NULL)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            return None

    def insert_after(self, NaviframeItem after):
        """insert_after(NaviframeItem after)

        Insert a new item into the naviframe after item *after*.

        The item is inserted into the naviframe straight away without any
        transition operations. This item will be deleted when it is popped.

        .. seealso::
            :py:attr:`style`
            :py:func:`push_to()`
            :py:func:`insert_before()`

        :param after: The naviframe item to insert after.
        :type after: :py:class:`NaviframeItem`

        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`NaviframeItem`

        """
        cdef Naviframe naviframe = after.widget
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_insert_after(
            naviframe.obj,
            after.item,
            _cfruni(self.label) if self.label else NULL,
            self.prev_btn,
            self.next_btn,
            self.item_content,
            _cfruni(self.item_style) if self.item_style else NULL)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            return None

    def item_pop_to(self):
        #_METHOD_DEPRECATED(self, "pop_to")
        elm_naviframe_item_pop_to(self.item)

    def pop_to(self):
        """pop_to()

        Pop the items between the top and the above one on the given item.

        """
        elm_naviframe_item_pop_to(self.item)

    def item_promote(self):
        #_METHOD_DEPRECATED(self, "promote")
        elm_naviframe_item_promote(self.item)

    def promote(self):
        """promote()

        Promote an item already in the naviframe stack to the top of the
        stack

        This will take the indicated item and promote it to the top of the
        stack as if it had been pushed there. The item must already be
        inside the naviframe stack to work.

        """
        elm_naviframe_item_promote(self.item)

    property style:
        """The item style.

        The following styles are available for this item:

        - ``"default"``

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_naviframe_item_style_get(self.item))

        def __set__(self, style):
            elm_naviframe_item_style_set(self.item, _cfruni(style))

    def style_set(self, style):
        elm_naviframe_item_style_set(self.item, _cfruni(style))
    def style_get(self):
        return _ctouni(elm_naviframe_item_style_get(self.item))

    property title_visible:
        """Show/Hide the title area

        When the title area is invisible, then the controls would be hidden
        so as to expand the content area to full-size.

        :type: bool

        """
        def __get__(self):
            return bool(elm_naviframe_item_title_visible_get(self.item))

        def __set__(self, visible):
            elm_naviframe_item_title_visible_set(self.item, visible)

    def title_visible_set(self, visible):
        elm_naviframe_item_title_visible_set(self.item, visible)
    def title_visible_get(self):
        return bool(elm_naviframe_item_title_visible_get(self.item))

cdef class Naviframe(LayoutClass):

    """

    Naviframe stands for navigation frame. It's a views manager
    for applications.

    A naviframe holds views (or pages) as its items. Those items are
    organized in a stack, so that new items get pushed on top of the
    old, and only the topmost view is displayed at one time. The
    transition between views is animated, depending on the theme
    applied to the widget.

    Naviframe views hold spaces to various elements, which are:

    - back button, used to navigate to previous views,
    - next button, used to navigate to next views in the stack,
    - title label,
    - sub-title label,
    - title icon and
    - content area.

    Becase this widget is a layout, one places content on those areas
    by using :py:func:`content_set()` on the right swallow part names
    expected for each, which are:

    - ``"default"`` - The main content of the current page
    - ``"icon"`` - An icon in the title area of the current page
    - ``"prev_btn"`` - A button of the current page to go to the
                     previous page
    - ``"next_btn"`` - A button of the current page to go to the next
                     page

    For text, :py:func:`text_set()` will work here on:

    - ``"default"`` - Title label in the title area of the current
                    page
    - ``"subtitle"`` - Sub-title label in the title area of the
                     current page

    Most of those content objects can be passed at the time of an item
    creation (see :py:func:`item_push()`).

    Naviframe items can have different styles, which affect the
    transition between views, for example. On the default theme, two of
    them are supported:

    - ``"basic"``   - views are switched sliding horizontally, one after
                  the other
    - ``"overlap"`` - like the previous one, but the previous view stays
                  at its place and is ovelapped by the new


    This widget emits the following signals, besides the ones sent from
    :py:class:`elementary.layout_class.LayoutClass`:

    - ``"transition,finished"`` - When the transition is finished in
                                changing the item
    - ``"title,clicked"`` - User clicked title area

    All the parts, for content and text, described here will also be
    reachable by naviframe **items** direct calls:

    - :py:func:`part_text_set()`
    - :py:func:`part_text_get()`
    - :py:func:`part_content_set()`
    - :py:func:`part_content_get()`
    - :py:func:`part_content_unset()`
    - :py:func:`signal_emit()`

    What happens is that the topmost item of a naviframe will be the
    widget's target layout, when accessed directly. Items lying below
    the top one can be interacted with this way.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_naviframe_add(parent.obj))

    def item_push(self, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, item_style):
        return NaviframeItem(title_label, prev_btn, next_btn, content, item_style).push_to(self)

    def item_insert_before(self, NaviframeItem before, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, item_style):
        return NaviframeItem(title_label, prev_btn, next_btn, content, item_style).insert_before(before)

    def item_insert_after(self, NaviframeItem after, title_label, evasObject prev_btn, evasObject next_btn, evasObject content, item_style):
        return NaviframeItem(title_label, prev_btn, next_btn, content, item_style).insert_after(after)

    def item_pop(self):
        """item_pop() -> evas.Object

        Pop an item that is on top of the stack

        This pops an item that is on the top (visible) of the naviframe,
        makes it disappear, then deletes the item. The item that was
        underneath it on the stack will become visible.

        .. seealso:: :py:attr:`content_preserve_on_pop`

        :return: ``None`` or the content object(if
            :py:attr:`content_preserve_on_pop` is True).
        :rtype: :py:class:`evas.object.Object`

        """
        return object_from_instance(elm_naviframe_item_pop(self.obj))

    property content_preserve_on_pop:
        """Preserve the content objects when items are popped.

        :type: bool

        """
        def __get__(self):
            return bool(elm_naviframe_content_preserve_on_pop_get(self.obj))
        def __set__(self, preserve):
            elm_naviframe_content_preserve_on_pop_set(self.obj, preserve)

    def content_preserve_on_pop_set(self, preserve):
        elm_naviframe_content_preserve_on_pop_set(self.obj, preserve)
    def content_preserve_on_pop_get(self):
        return bool(elm_naviframe_content_preserve_on_pop_get(self.obj))

    property top_item:
        """Get a top item on the naviframe stack

        :type: :py:class:`NaviframeItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_naviframe_top_item_get(self.obj))

    def top_item_get(self):
        return _object_item_to_python(elm_naviframe_top_item_get(self.obj))

    property bottom_item:
        """Get a bottom item on the naviframe stack

        :type: :py:class:`NaviframeItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_naviframe_bottom_item_get(self.obj))

    def bottom_item_get(self):
        return _object_item_to_python(elm_naviframe_bottom_item_get(self.obj))

    property prev_btn_auto_pushed:
        """Whether prev button(back button) will be created automatically or
        not.

        .. seealso:: item_push()

        :type: bool

        """
        def __get__(self):
            return bool(elm_naviframe_prev_btn_auto_pushed_get(self.obj))
        def __set__(self, auto_pushed):
            elm_naviframe_prev_btn_auto_pushed_set(self.obj, auto_pushed)

    def prev_btn_auto_pushed_set(self, auto_pushed):
        elm_naviframe_prev_btn_auto_pushed_set(self.obj, auto_pushed)
    def prev_btn_auto_pushed_get(self):
        return bool(elm_naviframe_prev_btn_auto_pushed_get(self.obj))

    property items:
        """Get a list of all the naviframe items.

        :type: tuple of :py:class:`NaviframeItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_naviframe_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_naviframe_items_get(self.obj))

    property event_enabled:
        """Whether the event when pushing/popping items is enabled

        If is True, the contents of the naviframe item will receives events
        from mouse and keyboard during view changing such as item push/pop.

        .. warning:: Events will be blocked by
            calling :py:func:`freeze_events_set()` internally.
            So don't call the API while pushing/popping items.

        .. seealso:: :py:attr:`evas.object.Object.freeze_events`

        :type: bool

        """
        def __get__(self):
            return bool(elm_naviframe_event_enabled_get(self.obj))
        def __set__(self, enabled):
            elm_naviframe_event_enabled_set(self.obj, enabled)

    def event_enabled_set(self, enabled):
        elm_naviframe_event_enabled_set(self.obj, enabled)
    def event_enabled_get(self):
        return bool(elm_naviframe_event_enabled_get(self.obj))

    def item_simple_push(self, evasObject content):
        """item_simple_push(evas.Object content) -> NaviframeItem

        Simple version of :py:func:`NaviframeItem.push_to()`.

        .. seealso:: :py:func:`NaviframeItem.push_to()`

        """
        cdef NaviframeItem ret = NaviframeItem()
        cdef Elm_Object_Item *item

        item = elm_naviframe_item_simple_push(self.obj, content.obj)
        if item != NULL:
            ret._set_obj(item)
            return ret
        else:
            return None

    def item_simple_promote(self, evasObject content):
        """item_simple_promote(evas.Object content)

        Simple version of :py:func:`NaviframeItem.promote()`.

        .. seealso:: :py:func:`NaviframeItem.promote()`

        """
        elm_naviframe_item_simple_promote(self.obj, content.obj)

    def callback_transition_finished_add(self, func, *args, **kwargs):
        """When the transition is finished in changing the item."""
        self._callback_add("transition,finished", func, *args, **kwargs)

    def callback_transition_finished_del(self, func):
        self._callback_del("transition,finished", func)

    def callback_title_clicked_add(self, func, *args, **kwargs):
        """User clicked title area."""
        self._callback_add("title,clicked", func, *args, **kwargs)

    def callback_title_clicked_del(self, func):
        self._callback_del("title,clicked", func)


_object_mapping_register("elm_naviframe", Naviframe)
