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

include "diskselector_cdef.pxi"

cdef class DiskselectorItem(ObjectItem):
    """

    An item for the :py:class:`Diskselector` widget.

    A new item will be created and appended to the diskselector, i.e.,
    will be set as last item. Also, if there is no selected item, it will
    be selected. This will always happens for the first appended item.

    If no icon is set, label will be centered on item position, otherwise
    the icon will be placed at left of the label, that will be shifted
    to the right.

    Items created with this method can be deleted with
    :py:meth:`~efl.elementary.object_item.ObjectItem.delete`.

    If a function is passed as argument, it will be called every time
    this item is selected, i.e., the user stops the diskselector with
    this item on center position.

    Simple example (with no function callback or data associated)::

        disk = Diskselector(win)
        ic = Icon(win, file="path/to/image", resizable=(True, True))
        disk.item_append("label", ic)

    .. seealso::
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`
        :py:meth:`Diskselector.clear`
        :py:class:`~efl.elementary.image.Image`

    """

    cdef:
        bytes label
        evasObject icon

    def __init__(self, label=None, evasObject icon=None, callback=None,
        cb_data=None, *args, **kargs):
        """DiskselectorItem(...)

        :param label: The label of the diskselector item.
        :type label: string
        :param icon: The icon object to use at left side of the item. An
            icon can be any Evas object, but usually it is an
            :py:class:`~efl.elementary.icon.Icon`.
        :type icon: :py:class:`~efl.evas.Object`
        :param callback: The function to call when the item is selected.
        :type callback: callable
        :param cb_data: User data for the callback function
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label
        self.icon = icon
        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kargs

    def append_to(self, Diskselector diskselector):
        """Appends a new item to the diskselector object.

        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`DiskselectorItem`

        """
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_diskselector_item_append(diskselector.obj,
            <const char *>self.label if self.label is not None else NULL,
            self.icon.obj if self.icon is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property selected:
        """The selected state of an item.

        This sets the selected state of the given item.
        ``True`` for selected, ``False`` for not selected.

        If a new item is selected the previously selected will be unselected.
        Previously selected item can be fetched from the property
        :py:attr:`Diskselector.selected_item`.

        If the item is unselected, the first item of diskselector will
        be selected.

        Selected items will be visible on center position of diskselector.
        So if it was on another position before selected, or was invisible,
        diskselector will animate items until the selected item reaches center
        position.

        .. seealso:: :py:attr:`Diskselector.selected_item`

        :type: bool

        """
        def __set__(self, selected):
            elm_diskselector_item_selected_set(self.item, selected)
        def __get__(self):
            return bool(elm_diskselector_item_selected_get(self.item))

    property prev:
        """Get the item before ``item`` in diskselector.

        The list of items follows append order. So it will return item appended
        just before ``item`` and that wasn't deleted.

        If it is the first item, ``None`` will be returned.
        First item can be get by :py:attr:`Diskselector.first_item`.

        .. seealso::
            :py:func:`Diskselector.item_append()`
            :py:attr:`Diskselector.items`

        :type: DiskselectorItem

        """
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_item_prev_get(self.item)
            return _object_item_to_python(it)

    property next:
        """Get the item after ``item`` in diskselector.

        The list of items follows append order. So it will return item appended
        just after ``item`` and that wasn't deleted.

        If it is the last item, ``None`` will be returned.
        Last item can be get by :py:attr:`Diskselector.last_item`.

        .. seealso::
            :py:func:`Diskselector.item_append()`
            :py:attr:`Diskselector.items`

        :type: DiskselectorItem

        """
        def __get__(self):
            cdef Elm_Object_Item *it = elm_diskselector_item_next_get(self.item)
            return _object_item_to_python(it)

cdef class Diskselector(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Diskselector(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_diskselector_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property round_enabled:
        """Enable or disable round mode.

        Disabled by default. If round mode is enabled the items list will
        work like a circular list, so when the user reaches the last item,
        the first one will popup.

        :type: bool

        """
        def __set__(self, enabled):
            elm_diskselector_round_enabled_set(self.obj, enabled)
        def __get__(self):
            return bool(elm_diskselector_round_enabled_get(self.obj))

    property side_text_max_length:
        """The side labels max length.

        Length is the number of characters of items' label that will be
        visible when it's set on side positions. It will just crop
        the string after defined size. E.g.:

        An item with label "January" would be displayed on side position as
        "Jan" if max length is set to 3, or "Janu", if this property
        is set to 4.

        When it's selected, the entire label will be displayed, except for
        width restrictions. In this case label will be cropped and "..."
        will be concatenated.

        Default side label max length is 3.

        This property will be applied over all items, included before or
        later this function call.

        :type: int

        """
        def __get__(self):
            return elm_diskselector_side_text_max_length_get(self.obj)
        def __set__(self, length):
            elm_diskselector_side_text_max_length_set(self.obj, length)

    property display_item_num:
        """The number of items to be displayed.

        Default value is 3, and also it's the minimum. If ``num`` is less
        than 3, it will be set to 3.

        Also, it can be set on theme, using data item ``display_item_num``
        on group "elm/diskselector/item/X", where X is style set.
        E.g.::

            group { name: "elm/diskselector/item/X";
                data {
                    item: "display_item_num" "5";
                }

        :type: int

        """
        def __set__(self, num):
            elm_diskselector_display_item_num_set(self.obj, num)
        def __get__(self):
            return elm_diskselector_display_item_num_get(self.obj)

    def clear(self):
        """Remove all diskselector's items.

        .. seealso::
            :py:meth:`~efl.elementary.object_item.ObjectItem.delete()`
            :py:meth:`item_append`

        """
        elm_diskselector_clear(self.obj)

    property items:
        """Get a list of all the diskselector items.

        .. seealso::
            :py:meth:`item_append`
            :py:meth:`~efl.elementary.object_item.ObjectItem.delete()`
            :py:meth:`clear`

        :type: list of :py:class:`DiskselectorItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_diskselector_items_get(self.obj))

    def item_append(self, label, evasObject icon = None, callback = None,
        *args, **kwargs):
        """A constructor for :py:class:`DiskselectorItem`

        :see: :func:`DiskselectorItem.append_to`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            DiskselectorItem ret = DiskselectorItem.__new__(DiskselectorItem)

        if callback is not None and callable(callback):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_diskselector_item_append(self.obj,
            <const char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = callback
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    property selected_item:
        """Get the selected item.

        The selected item can be unselected with function
        :py:attr:`DiskselectorItem.selected`, and the first item of diskselector
        will be selected.

        The selected item always will be centered on diskselector, with full
        label displayed, i.e., max length set to side labels won't apply on
        the selected item. More details on
        :py:attr:`side_text_max_length`.

        :type: :py:class:`DiskselectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_diskselector_selected_item_get(self.obj))

    property first_item:
        """Get the first item of the diskselector.

        The list of items follows append order. So it will return the first
        item appended to the widget that wasn't deleted.

        .. seealso:: :py:func:`item_append` :py:attr:`items`

        :type: :py:class:`DiskselectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_diskselector_first_item_get(self.obj))

    property last_item:
        """Get the last item of the diskselector.

        The list of items follows append order. So it will return last first
        item appended to the widget that wasn't deleted.

        .. seealso:: :py:func:`item_append` :py:attr:`items`

        :type: :py:class:`DiskselectorItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_diskselector_last_item_get(self.obj))

    def callback_selected_add(self, func, *args, **kwargs):
        """When item is selected, i.e. scroller stops."""
        self._callback_add_full("selected", _cb_object_item_conv, func, args, kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_clicked_add(self, func, *args, **kwargs):
        """This is called when a user clicks an item

        .. versionadded:: 1.8
        """
        self._callback_add_full("clicked", _cb_object_item_conv, func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del_full("clicked", _cb_object_item_conv, func)

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
        """Dragging the diskselector has started."""
        self._callback_add("scroll,drag,start", func, args, kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        """Dragging the diskselector has stopped."""
        self._callback_add("scroll,drag,stop", func, args, kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)


    property scroller_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.scroller_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scroller_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)


_object_mapping_register("Elm_Diskselector", Diskselector)
