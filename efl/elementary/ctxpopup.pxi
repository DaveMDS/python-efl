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

include "ctxpopup_cdef.pxi"

cdef class CtxpopupItem(ObjectItem):
    """

    An item for Ctxpopup widget.

    .. warning:: Ctxpopup can't hold both an item list and a content at the
        same time. When an item is added, any previous content will be
        removed.

    """

    cdef:
        bytes label
        evasObject icon

    def __init__(self, label = None, evasObject icon = None,
        callback = None, cb_data = None, *args, **kargs):
        """CtxpopupItem(...)

        :param label: The Label of the new item
        :type label: string
        :param icon: Icon to be set on new item
        :type icon: :py:class:`efl.evas.Object`
        :param callback: Convenience function called when item selected
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

    def append_to(self, evasObject ctxpopup):
        """Add a new item to a ctxpopup object.

        .. seealso:: :py:attr:`~efl.elementary.object.Object.content`

        :param ctxpopup: The Ctxpopup widget this item is to be appended on
        :type ctxpopup: :py:class:`Ctxpopup`
        :return: The item added or ``None``, on errors
        :rtype: :py:class:`CtxpopupItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_ctxpopup_item_append(ctxpopup.obj,
            <const char *>self.label if self.label is not None else NULL,
            self.icon.obj if self.icon is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, evasObject ctxpopup):
        """Prepend a new item to a ctxpopup object.

        .. seealso:: :py:attr:`~efl.elementary.object.Object.content`

        :param ctxpopup: The Ctxpopup widget this item is to be prepended on
        :type ctxpopup: :py:class:`Ctxpopup`
        :return: The item added or ``None``, on errors
        :rtype: :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_ctxpopup_item_prepend(ctxpopup.obj,
                <const char *>self.label if self.label is not None else NULL,
                self.icon.obj if self.icon is not None else NULL,
                cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property prev:
        """ The previous item.

        :type: :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        def __get__(self):
            return _object_item_to_python(elm_ctxpopup_item_prev_get(self.item))

    property next:
        """ The next item.

        :type: :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        def __get__(self):
            return _object_item_to_python(elm_ctxpopup_item_next_get(self.item))

cdef class Ctxpopup(LayoutClass):

    """

    This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from :py:class:`~efl.elementary.layout_class.LayoutClass`

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Ctxpopup(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_ctxpopup_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property hover_parent:
        """Ctxpopup hover's parent

        :type: :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_ctxpopup_hover_parent_get(self.obj))

        def __set__(self, evasObject parent):
            elm_ctxpopup_hover_parent_set(self.obj, parent.obj)

    def hover_parent_set(self, evasObject parent):
        elm_ctxpopup_hover_parent_set(self.obj, parent.obj)
    def hover_parent_get(self):
        return object_from_instance(elm_ctxpopup_hover_parent_get(self.obj))

    def clear(self):
        """Clear all items in the given ctxpopup object."""
        elm_ctxpopup_clear(self.obj)

    property horizontal:
        """Ctxpopup objects orientation.

        :type: bool

        """
        def __get__(self):
            return bool(elm_ctxpopup_horizontal_get(self.obj))

        def __set__(self, horizontal):
            elm_ctxpopup_horizontal_set(self.obj, horizontal)

    def horizontal_set(self, horizontal):
        elm_ctxpopup_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return bool(elm_ctxpopup_horizontal_get(self.obj))

    def item_append(self, label, evasObject icon=None,
                    func=None, *args, **kwargs):
        """A constructor for a :py:class:`CtxpopupItem`.

        :see: :py:func:`CtxpopupItem.append_to`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            CtxpopupItem ret = CtxpopupItem.__new__(CtxpopupItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_ctxpopup_item_append(self.obj,
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

    def item_prepend(self, label, evasObject icon=None,
                     func=None, *args, **kwargs):
        """A constructor for a :py:class:`CtxpopupItem`.

        :see: :py:func:`CtxpopupItem.prepend_to`

        .. versionadded:: 1.11

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            CtxpopupItem ret = CtxpopupItem.__new__(CtxpopupItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_ctxpopup_item_prepend(self.obj,
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

    property items:
        """ Get the list of items in the ctxpopup widget.

        This list is not to be modified in any way and is only valid until
        the object internal items list is changed. It should be fetched again
        with another call to this function when changes happen.

        :type: list of :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        def __get__(self):
            return _object_item_list_to_python(elm_ctxpopup_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_ctxpopup_items_get(self.obj))

    property first_item:
        """ The first item of the Ctxpopup.

        :type: :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        def __get__(self):
            return _object_item_to_python(elm_ctxpopup_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_ctxpopup_first_item_get(self.obj))

    property last_item:
        """ The last item of the Ctxpopup.

        :type: :py:class:`CtxpopupItem`

        .. versionadded:: 1.11

        """
        def __get__(self):
            return _object_item_to_python(elm_ctxpopup_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_ctxpopup_last_item_get(self.obj))

    property direction_priority:
        """The direction priority order of a ctxpopup.

        This functions gives a chance to user to set the priority of ctxpopup
        showing direction. This doesn't guarantee the ctxpopup will appear
        in the requested direction.

        :type: (first, second, third, fourth) :ref:`Elm_Ctxpopup_Direction`

        """
        def __get__(self):
            cdef Elm_Ctxpopup_Direction first, second, third, fourth
            elm_ctxpopup_direction_priority_get(self.obj, &first, &second, &third, &fourth)
            return (first, second, third, fourth)

        def __set__(self, priority):
            cdef Elm_Ctxpopup_Direction first, second, third, fourth
            first, second, third, fourth = priority
            elm_ctxpopup_direction_priority_set(self.obj, first, second, third, fourth)

    def direction_priority_set(self, first, second, third, fourth):
        elm_ctxpopup_direction_priority_set(self.obj, first, second, third, fourth)
    def direction_priority_get(self):
        cdef Elm_Ctxpopup_Direction first, second, third, fourth
        elm_ctxpopup_direction_priority_get(self.obj, &first, &second, &third, &fourth)
        return (first, second, third, fourth)

    property direction:
        """Get the current direction of a ctxpopup.

        .. warning:: Only once the ctxpopup is shown can the direction be
            determined

        :type: :ref:`Elm_Ctxpopup_Direction`

        """
        def __get__(self):
            return elm_ctxpopup_direction_get(self.obj)

    def direction_get(self):
        return elm_ctxpopup_direction_get(self.obj)

    def dismiss(self):
        """Dismiss a ctxpopup object

        Use this function to simulate clicking outside the ctxpopup to
        dismiss it. In this way, the ctxpopup will be hidden and the
        "dismissed" signal will be emitted.

        """
        elm_ctxpopup_dismiss(self.obj)

    property auto_hide_disabled:
        """Set ctxpopup auto hide mode triggered by ctxpopup policy.

        Use this property when you want ctxpopup not to hide automatically.
        By default, ctxpopup is dismissed whenever mouse clicked its background
        area, language is changed, and its parent geometry is updated(changed).

        :type: bool

        .. versionadded:: 1.9

        """
        def __get__(self):
            return bool(elm_ctxpopup_auto_hide_disabled_get(self.obj))

        def __set__(self, disabled):
            elm_ctxpopup_auto_hide_disabled_set(self.obj, disabled)

    def auto_hide_disabled_get(self):
        return bool(elm_ctxpopup_auto_hide_disabled_get(self.obj))
    def auto_hide_disabled_set(self, disabled):
        elm_ctxpopup_auto_hide_disabled_set(self.obj, disabled)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """the ctxpopup was dismissed"""
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)

    def callback_geometry_update_add(self, func, *args, **kwargs):
        """the ctxpopup geometry has changed

        .. versionadded:: 1.17

        """
        self._callback_add_full("geometry,update", _cb_rectangle_conv, func, args, kwargs)

    def callback_geometry_update_del(self, func):
        self._callback_del_full("geometry,update", _cb_rectangle_conv, func)


_object_mapping_register("Elm_Ctxpopup", Ctxpopup)
