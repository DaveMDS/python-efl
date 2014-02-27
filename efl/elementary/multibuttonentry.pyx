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

"""

.. image:: /images/multibuttonentry-preview.png

Widget description
------------------

A Multibuttonentry is a widget to allow a user enter text and manage
it as a number of buttons. Each text button is inserted by pressing the
"return" key. If there is no space in the current row, a new button is
added to the next row. When a text button is pressed, it will become
focused. Backspace removes the focus. When the Multibuttonentry loses
focus items longer than one line are shrunk to one line.

Typical use case of multibuttonentry is, composing emails/messages to a
group of addresses, each of which is an item that can be clicked for
further actions.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``item,selected`` - this is called when an item is selected by
  api, user interaction, and etc. this is also called when a
  user press back space while cursor is on the first field of
  entry.
- ``item,added`` - when a new multi-button entry item is added.
- ``item,deleted`` - when a multi-button entry item is deleted.
- ``item,clicked`` - this is called when an item is clicked by user
  interaction. Both "item,selected" and "item,clicked" are needed.
- ``clicked`` - when multi-button entry is clicked.
- ``focused`` - when multi-button entry is focused.
- ``unfocused`` - when multi-button entry is unfocused.
- ``expanded`` - when multi-button entry is expanded.
- ``contracted`` - when multi-button entry is contracted.
- ``expand,state,changed`` - when shrink mode state of
  multi-button entry is changed.

Default text parts of the multibuttonentry widget that you can use for are:

- ``default`` - A label of the multibuttonentry

Default text parts of the multibuttonentry items that you can use for are:

- ``default`` - A label of the multibuttonentry item

"""

from cpython cimport PyUnicode_AsUTF8String, Py_DECREF, Py_INCREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, object_from_instance, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject

from libc.stdlib cimport free
from libc.string cimport strdup
from object cimport Object
import traceback
from object_item cimport _object_item_callback, _object_item_callback2, \
    _object_item_to_python, _object_item_list_to_python

cdef Eina_Bool _multibuttonentry_filter_callback(Evas_Object *obj, \
    const_char *item_label, void *item_data, void *data) with gil:

    cdef:
        MultiButtonEntry mbe = object_from_instance(obj)
        bint ret

    (callback, a, ka) = <object>data

    try:
        ret = callback(mbe, _ctouni(item_label), *a, **ka)
    except:
        traceback.print_exc()

    return ret

cdef char * _multibuttonentry_format_cb(int count, void *data) with gil:
    (callback, a, ka) = <object>data

    try:
        s = callback(count, *a, **ka)
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
    except:
        traceback.print_exc()
        return NULL

    # TODO leak here
    return strdup(<char *>s)


cdef class MultiButtonEntryItem(ObjectItem):

    """An item for the MultiButtonEntry widget."""

    cdef:
        bytes label

    def __init__(self, label = None, callback = None, cb_data = None,
        *args, **kargs):

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.label = label
        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kargs

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "label=%r, callback=%r, args=%r, kargs=%s)>") % \
            (self.__class__.__name__, <uintptr_t><void *>self,
             PY_REFCOUNT(self), <uintptr_t><void *>self.item,
             self.text_get(), self.cb_func, self.args, self.kwargs)

    def append_to(self, MultiButtonEntry mbe not None):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_multibuttonentry_item_append(mbe.obj,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, MultiButtonEntry mbe not None):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_multibuttonentry_item_prepend(mbe.obj,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, MultiButtonEntryItem before not None):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        cdef MultiButtonEntry mbe = before.widget

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_multibuttonentry_item_insert_before(mbe.obj,
            before.item,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, MultiButtonEntryItem after not None):
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL
        cdef MultiButtonEntry mbe = after.widget

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_multibuttonentry_item_insert_after(mbe.obj,
            after.item,
            <const_char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property selected:
        def __get__(self):
            return bool(elm_multibuttonentry_item_selected_get(self.item))

        def __set__(self, selected):
            elm_multibuttonentry_item_selected_set(self.item, bool(selected))

    def selected_set(self, selected):
        elm_multibuttonentry_item_selected_set(self.item, bool(selected))
    def selected_get(self):
        return bool(elm_multibuttonentry_item_selected_get(self.item))

    property prev:
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_multibuttonentry_item_prev_get(self.item))

    property next:
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_multibuttonentry_item_next_get(self.item))

cdef class MultiButtonEntry(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_multibuttonentry_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)
        #
        # TODO: Add callbacks for item added and item deleted, inject
        #       the python instance into Elm_Object_Item's data
        #

    property entry:
        """The Entry object child of the multibuttonentry.

        :type: Entry

        """
        def __get__(self):
            return object_from_instance(elm_multibuttonentry_entry_get(self.obj))

    def entry_get(self):
        return object_from_instance(elm_multibuttonentry_entry_get(self.obj))

    property expanded:
        """The expanded state of the multibuttonentry.

        :type: bool

        """
        def __get__(self):
            return bool(elm_multibuttonentry_expanded_get(self.obj))

        def __set__(self, enabled):
            elm_multibuttonentry_expanded_set(self.obj, bool(enabled))

    def expanded_set(self, enabled):
        elm_multibuttonentry_expanded_set(self.obj, bool(enabled))
    def expanded_get(self):
        return bool(elm_multibuttonentry_expanded_get(self.obj))

    def item_prepend(self, label, func = None, *args, **kwargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_prepend(self.obj,
            <const_char *>label if label is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = func
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    def item_append(self, label, func = None, *args, **kwargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_append(self.obj,
            <const_char *>label if label is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = func
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    def item_insert_before(self, MultiButtonEntryItem before, label, func = None, *args, **kwargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_insert_before(self.obj,
            before.item if before is not None else NULL,
            <const_char *>label if label is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = func
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    def item_insert_after(self, MultiButtonEntryItem after, label, func = None, *args, **kwargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_insert_after(self.obj,
            after.item if after is not None else NULL,
            <const_char *>label if label is not None else NULL,
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
        def __get__(self):
            return _object_item_list_to_python(elm_multibuttonentry_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_multibuttonentry_items_get(self.obj))

    property first_item:
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_first_item_get(self.obj))

    property last_item:
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_last_item_get(self.obj))

    property selected_item:
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_selected_item_get(self.obj))

    def clear(self):
        elm_multibuttonentry_clear(self.obj)

    def filter_append(self, func, *args, **kwargs):
        cbdata = (func, args, kwargs)

        elm_multibuttonentry_item_filter_append(self.obj,
            _multibuttonentry_filter_callback, <void *>cbdata)

        Py_INCREF(cbdata)

    def filter_prepend(self, func, *args, **kwargs):
        cbdata = (func, args, kwargs)

        elm_multibuttonentry_item_filter_prepend(self.obj,
            _multibuttonentry_filter_callback, <void *>cbdata)

        Py_INCREF(cbdata)

    #TODO
    #def filter_remove(self, func, *args, **kwargs):
        #pass

    property editable:
        """Whether the multibuttonentry is to be editable or not.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint editable):
            elm_multibuttonentry_editable_set(self.obj, editable)

        def __get__(self):
            return bool(elm_multibuttonentry_editable_get(self.obj))

    def editable_set(self, bint editable):
        elm_multibuttonentry_editable_set(self.obj, editable)

    def editable_get(self):
        return bool(elm_multibuttonentry_editable_get(self.obj))

    def format_function_set(self, func, *args, **kwargs):
        """format_function_set(func, *args, **kwargs)

        Set a function to format the string that will be used to display
        the hidden items counter.

        :param func: The actual format function.
                     signature: (int count, args, kwargs)->string
        :type func: callable

        .. note:: Setting ``func`` to `None` will restore the default format.

        .. versionadded:: 1.9

        """
        if func is None:
            elm_multibuttonentry_format_function_set(self.obj, NULL, NULL)
            return

        cbdata = (func, args, kwargs)
        elm_multibuttonentry_format_function_set(self.obj,
                                                _multibuttonentry_format_cb,
                                                <void *>cbdata)
        # TODO leak here
        Py_INCREF(cbdata)

    def callback_item_selected_add(self, func, *args, **kwargs):
        self._callback_add("item,selected", func, *args, **kwargs)

    def callback_item_selected_del(self, func):
        self._callback_del("item,selected", func)

    def callback_item_added_add(self, func, *args, **kwargs):
        self._callback_add("item,added", func, *args, **kwargs)

    def callback_item_added_del(self, func):
        self._callback_del("item,added", func)

    def callback_item_deleted_add(self, func, *args, **kwargs):
        self._callback_add("item,deleted", func, *args, **kwargs)

    def callback_item_deleted_del(self, func):
        self._callback_del("item,deleted", func)

    def callback_item_clicked_add(self, func, *args, **kwargs):
        self._callback_add("item,clicked", func, *args, **kwargs)

    def callback_item_clicked_del(self, func):
        self._callback_del("item,clicked", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_focused_add(self, func, *args, **kwargs):
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

    def callback_expanded_add(self, func, *args, **kwargs):
        self._callback_add("expanded", func, *args, **kwargs)

    def callback_expanded_del(self, func):
        self._callback_del("expanded", func)

    def callback_contracted_add(self, func, *args, **kwargs):
        self._callback_add("contracted", func, *args, **kwargs)

    def callback_contracted_del(self, func):
        self._callback_del("contracted", func)

    def callback_expand_state_changed_add(self, func, *args, **kwargs):
        self._callback_add("expand,state,changed", func, *args, **kwargs)

    def callback_expand_state_changed_del(self, func):
        self._callback_del("expand,state,changed", func)


_object_mapping_register("Elm_Multibuttonentry", MultiButtonEntry)
