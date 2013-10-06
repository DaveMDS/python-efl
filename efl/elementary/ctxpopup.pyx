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

Widget description
------------------

.. image:: /images/ctxpopup-preview.png
    :align: left

A ctxpopup is a widget that, when shown, pops up a list of items. It
automatically chooses an area inside its parent object's view to
optimally fit into it. In the default theme, it will also point an arrow
to it's top left position at the time one shows it. Ctxpopup items have
a label and/or an icon. It is intended for a small number of items
(hence the use of list, not genlist).

Signals that you can add callbacks for are:

- ``dismissed`` - This is called when 1. the outside of ctxpopup was clicked
  or 2. its parent area is changed or 3. the language is changed and also when
  4. the parent object is resized due to the window rotation. Then ctxpopup is
  dismissed.
- ``language,changed`` - This is called when the program's language is
  changed.
- ``focused`` - When the ctxpopup has received focus. (since 1.8)
- ``unfocused`` - When the ctxpopup has lost focus. (since 1.8)

Default content parts of the ctxpopup widget that you can use for are:

- "default" - A content of the ctxpopup

Default content parts of the ctxpopup items that you can use for are:

- "icon" - An icon in the title area

Default text parts of the ctxpopup items that you can use for are:

- "default" - Title label in the title area

.. note:: Ctxpopup is a specialization of :py:class:`elementary.hover.Hover`.


Enumerations
------------

.. _Elm_Ctxpopup_Direction:

Ctxpopup arrow directions
=========================

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

from efl.evas cimport Evas_Object, const_Evas_Object, \
    Object as evasObject
from efl.eo cimport object_from_instance, _object_mapping_register
from efl.utils.conversions cimport _ctouni, _touni

from object cimport Object

from efl.evas cimport Eina_Bool, Evas_Smart_Cb
from object_item cimport Elm_Object_Item
from enums cimport Elm_Ctxpopup_Direction
from libc.string cimport const_char
from cpython cimport PyUnicode_AsUTF8String, Py_DECREF

cdef extern from "Elementary.h":
    Evas_Object             *elm_ctxpopup_add(Evas_Object *parent)
    void                     elm_ctxpopup_hover_parent_set(Evas_Object *obj, Evas_Object *parent)
    Evas_Object             *elm_ctxpopup_hover_parent_get(Evas_Object *obj)
    void                     elm_ctxpopup_clear(Evas_Object *obj)
    void                     elm_ctxpopup_horizontal_set(Evas_Object *obj, Eina_Bool horizontal)
    Eina_Bool                elm_ctxpopup_horizontal_get(Evas_Object *obj)
    Elm_Object_Item         *elm_ctxpopup_item_append(Evas_Object *obj, const_char *label, Evas_Object *icon, Evas_Smart_Cb func, void *data)
    void                     elm_ctxpopup_direction_priority_set(Evas_Object *obj, Elm_Ctxpopup_Direction first, Elm_Ctxpopup_Direction second, Elm_Ctxpopup_Direction third, Elm_Ctxpopup_Direction fourth)
    void                     elm_ctxpopup_direction_priority_get(Evas_Object *obj, Elm_Ctxpopup_Direction *first, Elm_Ctxpopup_Direction *second, Elm_Ctxpopup_Direction *third, Elm_Ctxpopup_Direction *fourth)
    Elm_Ctxpopup_Direction   elm_ctxpopup_direction_get(Evas_Object *obj)
    void                     elm_ctxpopup_dismiss(Evas_Object *obj)


from layout_class cimport LayoutClass
from object_item cimport ObjectItem, _object_item_callback

cimport enums

ELM_CTXPOPUP_DIRECTION_DOWN = enums.ELM_CTXPOPUP_DIRECTION_DOWN
ELM_CTXPOPUP_DIRECTION_RIGHT = enums.ELM_CTXPOPUP_DIRECTION_RIGHT
ELM_CTXPOPUP_DIRECTION_LEFT = enums.ELM_CTXPOPUP_DIRECTION_LEFT
ELM_CTXPOPUP_DIRECTION_UP = enums.ELM_CTXPOPUP_DIRECTION_UP
ELM_CTXPOPUP_DIRECTION_UNKNOWN = enums.ELM_CTXPOPUP_DIRECTION_UNKNOWN

cdef class CtxpopupItem(ObjectItem):

    cdef:
        bytes label
        evasObject icon

    def __init__(self, label = None, evasObject icon = None, callback = None, *args, **kargs):
        """
        .. warning:: Ctxpopup can't hold both an item list and a content at the
            same time. When an item is added, any previous content will be
            removed.

        :param icon: Icon to be set on new item
        :type icon: :py:class:`evas.object.Object`
        :param label: The Label of the new item
        :type label: string
        :param func: Convenience function called when item selected
        :type func: function
        :return: The item added or ``None``, on errors
        :rtype: :py:class:`CtxpopupItem`

        """
        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label
        self.icon = icon
        self.cb_func = callback
        self.args = args
        self.kwargs = kargs

    def append_to(self, evasObject ctxpopup):
        """item_append(unicode label, evas.Object icon, func, *args, **kwargs) -> CtxpopupItem

        Add a new item to a ctxpopup object.

        .. warning:: Ctxpopup can't hold both an item list and a content at the
            same time. When an item is added, any previous content will be
            removed.

        .. seealso:: :py:attr:`elementary.object.Object.content`

        :param ctxpopup: The Ctxpopup widget this item is to be appended on
        :type ctxpopup: :py:class:`Ctxpopup`
        :return: The item added or ``None``, on errors
        :rtype: :py:class:`CtxpopupItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback

        item = elm_ctxpopup_item_append(ctxpopup.obj,
            <const_char *>self.label if self.label is not None else NULL,
            self.icon.obj if self.icon is not None else NULL,
            cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)

cdef class Ctxpopup(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent):
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

        A constructor for a :py:class:`CtxpopupItem`.

        :see: :py:func:`CtxpopupItem.append_to`

        """
        return CtxpopupItem(label, icon, func, *args, **kwargs).append_to(self)

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

    def callback_language_changed_add(self, func, *args, **kwargs):
        """This is called when the program's language is changed."""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the ctxpopup has received focus.

        :since: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the ctxpopup has lost focus.

        :since: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("elm_ctxpopup", Ctxpopup)
