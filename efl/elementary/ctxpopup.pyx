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
#

"""

.. rubric:: Ctxpopup arrow directions

.. data:: ELM_CTXPOPUP_DIRECTION_DOWN

    Arrow is pointing down

.. data:: ELM_CTXPOPUP_DIRECTION_RIGHT

    Arrow is pointing right

.. data:: ELM_CTXPOPUP_DIRECTION_LEFT

    Arrow is pointing left

.. data:: ELM_CTXPOPUP_DIRECTION_UP

    Arrow is pointing up

.. data:: ELM_CTXPOPUP_DIRECTION_UNKNOWN

    Arrow direction is unknown

"""

include "widget_header.pxi"
from object cimport Object
from object_item cimport ObjectItem, _object_item_callback

cimport enums

ELM_CTXPOPUP_DIRECTION_DOWN = enums.ELM_CTXPOPUP_DIRECTION_DOWN
ELM_CTXPOPUP_DIRECTION_RIGHT = enums.ELM_CTXPOPUP_DIRECTION_RIGHT
ELM_CTXPOPUP_DIRECTION_LEFT = enums.ELM_CTXPOPUP_DIRECTION_LEFT
ELM_CTXPOPUP_DIRECTION_UP = enums.ELM_CTXPOPUP_DIRECTION_UP
ELM_CTXPOPUP_DIRECTION_UNKNOWN = enums.ELM_CTXPOPUP_DIRECTION_UNKNOWN

cdef class CtxpopupItem(ObjectItem):
    def __init__(self, evasObject ctxpopup, label = None, evasObject icon = None, callback = None, *args, **kargs):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)
        item = elm_ctxpopup_item_append(ctxpopup.obj,
                                        _cfruni(label) if label is not None else NULL,
                                        icon.obj if icon is not None else NULL,
                                        cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

cdef class Ctxpopup(Object):

    """

    Context popup widget.

    A ctxpopup is a widget that, when shown, pops up a list of items. It
    automatically chooses an area inside its parent object's view to
    optimally fit into it. In the default theme, it will also point an arrow
    to it's top left position at the time one shows it. Ctxpopup items have
    a label and/or an icon. It is intended for a small number of items
    (hence the use of list, not genlist).

    Signals that you can add callbacks for are:

    - "dismissed" - the ctxpopup was dismissed

    Default content parts of the ctxpopup widget that you can use for are:

    - "default" - A content of the ctxpopup

    Default content parts of the ctxpopup items that you can use for are:

    - "icon" - An icon in the title area

    Default text parts of the ctxpopup items that you can use for are:

    - "default" - Title label in the title area

    .. note:: Ctxpopup is a specialization of :py:class:`elementary.hover.Hover`.

    """

    def __init__(self, evasObject parent):
        Object.__init__(self, parent.evas)
        self._set_obj(elm_ctxpopup_add(parent.obj))

    property hover_parent:
        """Ctxpopup hover's parent

        :type: :py:class:`evas.object.Object`

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

    def item_append(self, label, evasObject icon = None, func = None, *args, **kwargs):
        """item_append(unicode label, evas.Object icon, func, *args, **kwargs) -> CtxpopupItem

        Add a new item to a ctxpopup object.

        .. warning:: Ctxpopup can't hold both an item list and a content at the
            same time. When an item is added, any previous content will be
            removed.

        .. seealso:: :py:attr:`elementary.object.Object.content`

        :param icon: Icon to be set on new item
        :type icon: :py:class:`evas.object.Object`
        :param label: The Label of the new item
        :type label: string
        :param func: Convenience function called when item selected
        :type func: function
        :return: The item added or ``None``, on errors
        :rtype: :py:class:`CtxpopupItem`

        """
        return CtxpopupItem(self, label, icon, func, *args, **kwargs)

    property direction_priority:
        """The direction priority order of a ctxpopup.

        This functions gives a chance to user to set the priority of ctxpopup
        showing direction. This doesn't guarantee the ctxpopup will appear
        in the requested direction.

        :type: tuple of Elm_Ctxpopup_Direction

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

        :type: Elm_Ctxpopup_Direction

        """
        def __get__(self):
            return elm_ctxpopup_direction_get(self.obj)

    def direction_get(self):
        return elm_ctxpopup_direction_get(self.obj)

    def dismiss(self):
        """dismiss()

        Dismiss a ctxpopup object

        Use this function to simulate clicking outside the ctxpopup to
        dismiss it. In this way, the ctxpopup will be hidden and the
        "clicked" signal will be emitted.

        """
        elm_ctxpopup_dismiss(self.obj)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """the ctxpopup was dismissed"""
        self._callback_add("dismissed", func, *args, **kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)


_object_mapping_register("elm_ctxpopup", Ctxpopup)
