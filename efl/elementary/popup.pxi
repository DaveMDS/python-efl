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

include "popup_cdef.pxi"

cdef class PopupItem(ObjectItem):
    """

    An item for the :py:class:`Popup` widget.

    Default contents parts of the popup items that you can use for are:

    - ``default`` - Item's icon

    Default text parts of the popup items that you can use for are:

    - ``default`` - Item's label

    """
    cdef:
        bytes label
        evasObject icon

    def __init__(self, evasObject popup, label = None, evasObject icon = None,
        func = None, cb_data = None, *args, **kwargs):
        if func is not None:
            if not callable(func):
                raise TypeError("func is not None or callable")

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label
        self.icon = icon
        self.cb_func = func
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kwargs

    def append_to(self, Popup popup not None):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_popup_item_append(popup.obj,
            <const char *>self.label if not None else NULL,
            self.icon.obj if not None else NULL,
            cb, <void *>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)>") % \
               (self.__class__.__name__,
                <uintptr_t><void*>self,
                PY_REFCOUNT(self),
                <uintptr_t>self.item,
                self.cb_func,
                self.args)

cdef class Popup(LayoutClass):
    """

    This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Popup(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_popup_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def item_append(self, label, evasObject icon, func = None, *args, **kwargs):
        """Add a new item to a Popup object

        Both an item list and a content cannot be set at the same time!
        Once you add an item, the previous content will be removed.

        :param label: The Label of the new item
        :type label: string
        :param icon: Icon to be set on new item
        :type icon: :py:class:`~efl.evas.Object`
        :param func: Convenience function called when item selected
        :type func: function

        :return: A handle to the item added or ``None`` on errors.
        :rtype: :py:class:`PopupItem`

        .. warning:: When the first item is appended to popup object, any
            previous content of the content area is deleted. At a time, only
            one of content, content-text and item(s) can be there in a popup
            content area.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            PopupItem ret = PopupItem.__new__(PopupItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_popup_item_append(self.obj,
            <const char *>label if label is not None else NULL,
            icon.obj if icon is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = func
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    property content_text_wrap_type:
        """Sets the wrapping type of content text packed in content
        area of popup object.

        :type: :ref:`Elm_Wrap_Type`

        """
        def __set__(self, wrap):
            elm_popup_content_text_wrap_type_set(self.obj, wrap)
        def __get__(self):
            return elm_popup_content_text_wrap_type_get(self.obj)

    property orient:
        """Sets the orientation of the popup in the parent region

        Sets the position in which popup will appear in its parent

        :type: :ref:`Elm_Popup_Orient`

        """
        def __set__(self, orient):
            elm_popup_orient_set(self.obj, orient)
        def __get__(self):
            return elm_popup_orient_get(self.obj)

    property timeout:
        """A timeout to hide popup automatically

        Setting this starts the timer controlling when the popup is hidden.
        Since calling evas_object_show() on a popup restarts the timer
        controlling when it is hidden, setting this before the popup is
        shown will in effect mean starting the timer when the popup is
        shown. Smart signal "timeout" is called afterwards which can be
        handled if needed.

        .. note:: Set a value <= 0.0 to disable a running timer.

        .. note:: If the value > 0.0 and the popup is previously visible, the
            timer will be started with this value, canceling any running timer.

        :type: float

        """
        def __set__(self, timeout):
            elm_popup_timeout_set(self.obj, timeout)
        def __get__(self):
            return elm_popup_timeout_get(self.obj)

    property allow_events:
        """Whether events should be passed to by a click outside.

        Enabling allow event will remove the Blocked event area and events will
        pass to the lower layer objects otherwise they are blocked.

        .. note:: The default value is False.

        :type: bool

        """
        def __set__(self, allow):
            elm_popup_allow_events_set(self.obj, allow)
        def __get__(self):
            return bool(elm_popup_allow_events_get(self.obj))

    def dismiss(self):
        """Dismiss a popup object.

        .. versionadded:: 1.17

        """
        elm_popup_dismiss(self.obj)

    property align:
        """The alignment of the popup object.

        The alignment in which the popup will appear inside its parent.

        :type: 2 doubles tuple: (horiz, vert)

        .. versionadded:: 1.18

        """
        def __set__(self, value):
            cdef double h, v
            h, v = value
            elm_popup_align_set(self.obj, h, v)
        def __get__(self):
            cdef double h, v
            elm_popup_align_get(self.obj, &h, &v)
            return (h, v)

    property scrollable:
        """The scrollable state of popup content area

        Normally content area does not contain scroller.

        :type: bool

        .. versionadded:: 1.18

        """
        def __set__(self, bint scrollable):
            elm_popup_scrollable_set(self.obj, scrollable)
        def __get__(self):
            return bool(elm_popup_scrollable_get(self.obj))

    def callback_dismissed_add(self, func, *args, **kwargs):
        """When popup is closed as a result of a dismiss.

        .. versionadded:: 1.17

        """
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)

    def callback_timeout_add(self, func, *args, **kwargs):
        """When popup is closed as a result of timeout."""
        self._callback_add("timeout", func, args, kwargs)

    def callback_timeout_del(self, func):
        self._callback_del("timeout", func)

    def callback_block_clicked_add(self, func, *args, **kwargs):
        """When the user taps on Blocked Event area."""
        self._callback_add("block,clicked", func, args, kwargs)

    def callback_block_clicked_del(self, func):
        self._callback_del("block,clicked", func)

    def callback_item_focused_add(self, func, *args, **kwargs):
        """When the popup item has received focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,focused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_focused_del(self, func):
        self._callback_del_full("item,focused", _cb_object_item_conv, func)

    def callback_item_unfocused_add(self, func, *args, **kwargs):
        """When the popup item has lost focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,unfocused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_unfocused_del(self, func):
        self._callback_del_full("item,unfocused", _cb_object_item_conv, func)

_object_mapping_register("Elm_Popup", Popup)
