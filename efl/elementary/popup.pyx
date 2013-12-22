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

.. image:: /images/popup-preview.png

Widget description
------------------

This widget is an enhancement of :py:class:`~efl.elementary.notify.Notify`.
In addition to Content area, there are two optional sections namely Title
area and Action area.

Popup Widget displays its content with a particular orientation in the
parent area. This orientation can be one among top, center, bottom,
left, top-left, top-right, bottom-left and bottom-right. Content part of
Popup can be an Evas Object set by application or it can be Text set by
application or set of items containing an icon and/or text. The
content/item-list can be removed using elm_object_content_set with second
parameter passed as None.

Following figures shows the textual layouts of popup in which Title Area
and Action area area are optional ones. Action area can have up to 3
buttons handled using elm_object common APIs mentioned below. If user
wants to have more than 3 buttons then these buttons can be put inside
the items of a list as content. User needs to handle the clicked signal
of these action buttons if required. No event is processed by the widget
automatically when clicked on these action buttons.

Figure::

    |---------------------|    |---------------------|    |---------------------|
    |     Title Area      |    |     Title Area      |    |     Title Area      |
    |Icon|    Text        |    |Icon|    Text        |    |Icon|    Text        |
    |---------------------|    |---------------------|    |---------------------|
    |       Item 1        |    |                     |    |                     |
    |---------------------|    |                     |    |                     |
    |       Item 2        |    |                     |    |    Description      |
    |---------------------|    |       Content       |    |                     |
    |       Item 3        |    |                     |    |                     |
    |---------------------|    |                     |    |                     |
    |         .           |    |---------------------|    |---------------------|
    |         .           |    |     Action Area     |    |     Action Area     |
    |         .           |    | Btn1  |Btn2|. |Btn3 |    | Btn1  |Btn2|  |Btn3 |
    |---------------------|    |---------------------|    |---------------------|
    |       Item N        |     Content Based Layout     Description based Layout
    |---------------------|
    |     Action Area     |
    | Btn1  |Btn2|. |Btn3 |
    |---------------------|
       Item Based Layout

Timeout can be set on expiry of which popup instance hides and sends a
smart signal "timeout" to the user. The visible region of popup is
surrounded by a translucent region called Blocked Event area. By
clicking on Blocked Event area, the signal "block,clicked" is sent to
the application. This block event area can be avoided by using API
elm_popup_allow_events_set. When gets hidden, popup does not get
destroyed automatically, application should destroy the popup instance
after use. To control the maximum height of the internal scroller for
item, we use the height of the action area which is passed by theme
based on the number of buttons currently set to popup.

Signals that you can add callbacks for are:

- ``timeout`` - when ever popup is closed as a result of timeout.
- ``block,clicked`` - when ever user taps on Blocked Event area.
- ``focused`` - When the popup has received focus. (since 1.8)
- ``unfocused`` - When the popup has lost focus. (since 1.8)
- ``language,changed`` - the program's language changed (since 1.8)

Styles available for Popup

- ``default``

Default contents parts of the popup items that you can use are:

- ``default`` -Item's icon

Default text parts of the popup items that you can use are:

- ``default`` - Item's label

Default contents parts of the popup widget that you can use for are:

- ``default`` - The content of the popup
- ``title,icon`` - Title area's icon
- ``button1`` - 1st button of the action area
- ``button2`` - 2nd button of the action area
- ``button3`` - 3rd button of the action area

Default text parts of the popup widget that you can use for are:

- ``title,text`` - This operates on Title area's label
- ``default`` - content-text set in the content area of the widget


Enumerations
------------

.. _Elm_Popup_Orient:

Popup orientation types
=======================

.. data:: ELM_POPUP_ORIENT_TOP

    Popup should appear in the top of parent, default

.. data:: ELM_POPUP_ORIENT_CENTER

    Popup should appear in the center of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM

    Popup should appear in the bottom of parent

.. data:: ELM_POPUP_ORIENT_LEFT

    Popup should appear in the left of parent

.. data:: ELM_POPUP_ORIENT_RIGHT

    Popup should appear in the right of parent

.. data:: ELM_POPUP_ORIENT_TOP_LEFT

    Popup should appear in the top left of parent

.. data:: ELM_POPUP_ORIENT_TOP_RIGHT

    Popup should appear in the top right of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM_LEFT

    Popup should appear in the bottom left of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM_RIGHT

    Popup should appear in the bottom right of parent


.. Elm_Wrap_Type:

Wrap modes
==========

.. data:: ELM_WRAP_NONE

    No wrap

.. data:: ELM_WRAP_CHAR

    Wrap between characters

.. data:: ELM_WRAP_WORD

    Wrap in allowed wrapping points (as defined in the unicode standard)

.. data:: ELM_WRAP_MIXED

    Word wrap, and if that fails, char wrap.

"""

from cpython cimport PyUnicode_AsUTF8String, Py_DECREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object
from layout_class cimport LayoutClass
from object_item cimport _object_item_callback, _object_item_callback2, \
    _object_item_to_python

cimport enums

ELM_POPUP_ORIENT_TOP = enums.ELM_POPUP_ORIENT_TOP
ELM_POPUP_ORIENT_CENTER = enums.ELM_POPUP_ORIENT_CENTER
ELM_POPUP_ORIENT_BOTTOM = enums.ELM_POPUP_ORIENT_BOTTOM
ELM_POPUP_ORIENT_LEFT = enums.ELM_POPUP_ORIENT_LEFT
ELM_POPUP_ORIENT_RIGHT = enums.ELM_POPUP_ORIENT_RIGHT
ELM_POPUP_ORIENT_TOP_LEFT = enums.ELM_POPUP_ORIENT_TOP_LEFT
ELM_POPUP_ORIENT_TOP_RIGHT = enums.ELM_POPUP_ORIENT_TOP_RIGHT
ELM_POPUP_ORIENT_BOTTOM_LEFT = enums.ELM_POPUP_ORIENT_BOTTOM_LEFT
ELM_POPUP_ORIENT_BOTTOM_RIGHT = enums.ELM_POPUP_ORIENT_BOTTOM_RIGHT
ELM_POPUP_ORIENT_LAST = enums.ELM_POPUP_ORIENT_LAST

ELM_WRAP_NONE = enums.ELM_WRAP_NONE
ELM_WRAP_CHAR = enums.ELM_WRAP_CHAR
ELM_WRAP_WORD = enums.ELM_WRAP_WORD
ELM_WRAP_MIXED = enums.ELM_WRAP_MIXED

cdef class PopupItem(ObjectItem):

    """

    An item for :py:class:`Popup`.

    Default contents parts of the popup items that you can use for are:

    - "default" -Item's icon

    Default text parts of the popup items that you can use for are:

    - "default" - Item's label

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
            <const_char *>self.label if not None else NULL,
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

    """This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_popup_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def item_append(self, label, evasObject icon, func = None, *args, **kwargs):
        """item_append(unicode label, evas.Object icon, func = None, *args, **kwargs) -> PopupItem

        Add a new item to a Popup object

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
            <const_char *>label if label is not None else NULL,
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

        :type: Elm_Wrap_Type

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

    def callback_timeout_add(self, func, *args, **kwargs):
        """When popup is closed as a result of timeout."""
        self._callback_add("timeout", func, *args, **kwargs)

    def callback_timeout_del(self, func):
        self._callback_del("timeout", func)

    def callback_block_clicked_add(self, func, *args, **kwargs):
        """When the user taps on Blocked Event area."""
        self._callback_add("block,clicked", func, *args, **kwargs)

    def callback_block_clicked_del(self, func):
        self._callback_del("block,clicked", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the popup has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the popup has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """the program's language changed

        .. versionadded:: 1.8
        """
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("Elm_Popup", Popup)
