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


include "multibuttonentry_cdef.pxi"

cdef Eina_Bool _multibuttonentry_filter_callback(Evas_Object *obj, \
    const char *item_label, void *item_data, void *data) with gil:

    cdef:
        MultiButtonEntry mbe = object_from_instance(obj)
        bint ret
        list callbacks = mbe._item_filters

    for func, args, kargs in callbacks:
        try:
            ret = func(mbe, _ctouni(item_label), *args, **kargs)
        except Exception:
            traceback.print_exc()
            continue

        if ret:
            continue
        else:
            return 0 # This emulates the behavior of C code where callbacks
                     # are iterated until EINA_FALSE is returned by user

    return 1

cdef char * _multibuttonentry_format_cb(int count, void *data) with gil:
    cdef MultiButtonEntry obj = <MultiButtonEntry>data
    (callback, a, ka) = obj.internal_data["multibuttonentry_format_cb"]

    try:
        s = callback(count, *a, **ka)
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
    except Exception:
        traceback.print_exc()
        return NULL

    return strdup(s) # Elm will manage the string


cdef class MultiButtonEntryItem(ObjectItem):
    """

    An item for the MultiButtonEntry widget.

    """

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
            <const char *>self.label if self.label is not None else NULL,
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
            <const char *>self.label if self.label is not None else NULL,
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
            <const char *>self.label if self.label is not None else NULL,
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
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property selected:
        """Control the selected state of an item

        :type: bool

        """
        def __get__(self):
            return bool(elm_multibuttonentry_item_selected_get(self.item))

        def __set__(self, selected):
            elm_multibuttonentry_item_selected_set(self.item, bool(selected))

    def selected_set(self, selected):
        elm_multibuttonentry_item_selected_set(self.item, bool(selected))
    def selected_get(self):
        return bool(elm_multibuttonentry_item_selected_get(self.item))

    property prev:
        """Get the previous item in the multibuttonentry

        :type: :class:`MultiButtonEntryItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_multibuttonentry_item_prev_get(self.item))

    property next:
        """Get the next item in the multibuttonentry

        :type: :class:`MultiButtonEntryItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_multibuttonentry_item_next_get(self.item))

cdef void _py_elm_mbe_item_added_cb(
    void *data, Evas_Object *o, void *event_info) with gil:
    cdef:
        MultiButtonEntryItem it
        Elm_Object_Item *item = <Elm_Object_Item *>event_info

    if elm_object_item_data_get(item) == NULL:
        it = MultiButtonEntryItem.__new__(MultiButtonEntryItem)
        it._set_obj(item)

cdef class MultiButtonEntry(Object):
    """

    This is the class that actually implements the widget.

    """

    cdef list _item_filters

    def __init__(self, evasObject parent, *args, **kwargs):
        """MultiButtonEntry(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_multibuttonentry_add(parent.obj))
        evas_object_smart_callback_add(
            self.obj, "item,added",
            _py_elm_mbe_item_added_cb, NULL
            )
        self._set_properties_from_keyword_args(kwargs)
        self._item_filters = list()

    property entry:
        """The Entry object child of the multibuttonentry.

        :type: Entry

        """
        def __get__(self):
            return object_from_instance(elm_multibuttonentry_entry_get(self.obj))

    def entry_get(self):
        return object_from_instance(elm_multibuttonentry_entry_get(self.obj))

    property expanded:
        """Control the multibuttonentry to expanded state.

        In expanded state the entry widget expands to accommodate all items.
        Otherwise a single line of items will be displayed with a counter for
        items that don't fit the line.

        .. seealso:: :meth:`format_function_set`

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
        """Prepend a new item to the multibuttonentry

        :param string label: The label of new item
        :param func: The callback function to be invoked when this item is pressed.
        :param \*args: The data to be attached for callback
        :param \*\*kwargs: The data to be attached for callback

        :return: :class:`MultiButtonEntryItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_prepend(self.obj,
            <const char *>label if label is not None else NULL,
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
        """Append a new item to the multibuttonentry

        :param string label: The label of new item
        :param func: The callback function to be invoked when this item is pressed.
        :param \*args: The data to be attached for callback
        :param \*\*kwargs: The data to be attached for callback

        :return: :class:`MultiButtonEntryItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_append(self.obj,
            <const char *>label if label is not None else NULL,
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
        """Add a new item to the multibuttonentry before the indicated object

        :param MultiButtonEntryItem before: The item before which to add it
        :param string label: The label of new item
        :param func: The callback function to be invoked when this item is pressed.
        :param \*args: The data to be attached for callback
        :param \*\*kwargs: The data to be attached for callback

        :return: :class:`MultiButtonEntryItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_insert_before(self.obj,
            before.item if before is not None else NULL,
            <const char *>label if label is not None else NULL,
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
        """Add a new item to the multibuttonentry after the indicated object

        :param MultiButtonEntryItem before: The item after which to add it
        :param string label: The label of new item
        :param func: The callback function to be invoked when this item is pressed.
        :param \*args: The data to be attached for callback
        :param \*\*kwargs: The data to be attached for callback

        :return: :class:`MultiButtonEntryItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MultiButtonEntryItem ret = MultiButtonEntryItem.__new__(MultiButtonEntryItem)

        if func is not None and callable(func):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_multibuttonentry_item_insert_after(self.obj,
            after.item if after is not None else NULL,
            <const char *>label if label is not None else NULL,
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
        """List of items in the multibuttonentry

        :type: list

        """
        def __get__(self):
            return _object_item_list_to_python(elm_multibuttonentry_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_multibuttonentry_items_get(self.obj))

    property first_item:
        """The first item in the multibuttonentry

        :type: :class:`MultiButtonEntryItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_first_item_get(self.obj))

    property last_item:
        """The last item in the multibuttonentry

        :type: :class:`MultiButtonEntryItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_last_item_get(self.obj))

    property selected_item:
        """The selected item in the multibuttonentry

        :type: :class:`MultiButtonEntryItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_multibuttonentry_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_multibuttonentry_selected_item_get(self.obj))

    def clear(self):
        """Remove all items in the multibuttonentry"""
        elm_multibuttonentry_clear(self.obj)

    def filter_append(self, func, *args, **kwargs):
        """Append an item filter function for items inserted in the Multibuttonentry

        Append the given callback to the list. This function will be called
        when a new text item is inserted into the Multibuttonentry, with the
        text to be inserted as a parameter.

        If the item is wanted the function should return ``True``, else return
        ``False``. Returning ``False`` will also prevent any subsequent filters
        from being called.

        Callback signature::

            func(obj, text, *args, **kwargs) -> bool

        """
        if not self._item_filters:
            elm_multibuttonentry_item_filter_append(
                self.obj,
                _multibuttonentry_filter_callback,
                NULL)

        cbdata = (func, args, kwargs)
        self._item_filters.append(cbdata)

    def filter_prepend(self, func, *args, **kwargs):
        """Prepend a filter function for items inserted in the Multibuttonentry

        Prepend the given callback to the list. See :meth:`filter_append`
        for more information

        """
        if not self._item_filters:
            elm_multibuttonentry_item_filter_append(
                self.obj,
                _multibuttonentry_filter_callback,
                NULL)

        cbdata = (func, args, kwargs)
        self._item_filters[0] = cbdata

    def filter_remove(self, func, *args, **kwargs):
        """Remove a filter from the list

        Removes the given callback from the filter list. See :meth:`filter_append`
        for more information.

        .. versionadded:: 1.17

        """
        cbdata = (func, args, kwargs)
        self._item_filters.remove(cbdata)

        if not self._item_filters:
            elm_multibuttonentry_item_filter_remove(
                self.obj,
                _multibuttonentry_filter_callback,
                NULL)

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
        """Set a function to format the string for the counter

        Sets a function to format the string that will be used to display a
        counter for items that don't fit the line when the widget is not in
        :attr:`expanded` state.

        :param func: The actual format function.
                     signature: (int count, args, kwargs)->string
        :type func: callable

        .. note:: Setting ``func`` to `None` will restore the default format.

        .. versionadded:: 1.9

        """
        if func is None:
            self.internal_data["multibuttonentry_format_cb"] = None
            elm_multibuttonentry_format_function_set(self.obj, NULL, NULL)
            return

        cbdata = (func, args, kwargs)
        self.internal_data["multibuttonentry_format_cb"] = cbdata

        elm_multibuttonentry_format_function_set(self.obj,
                                                _multibuttonentry_format_cb,
                                                <void *>self)

    def callback_item_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("item,selected", _cb_object_item_conv, func, args, kwargs)

    def callback_item_selected_del(self, func):
        self._callback_del_full("item,selected", _cb_object_item_conv, func)

    def callback_item_added_add(self, func, *args, **kwargs):
        self._callback_add_full("item,added", _cb_object_item_conv, func, args, kwargs)

    def callback_item_added_del(self, func):
        self._callback_del_full("item,added", _cb_object_item_conv, func)

    def callback_item_deleted_add(self, func, *args, **kwargs):
        self._callback_add_full("item,deleted", _cb_object_item_conv, func, args, kwargs)

    def callback_item_deleted_del(self, func):
        self._callback_del_full("item,deleted", _cb_object_item_conv, func)

    def callback_item_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("item,clicked", _cb_object_item_conv, func, args, kwargs)

    def callback_item_clicked_del(self, func):
        self._callback_del_full("item,clicked", _cb_object_item_conv, func)

    def callback_item_longpressed_add(self, func, *args, **kwargs):
        """
        .. versionadded:: 1.14
        """
        self._callback_add_full("item,longpressed", _cb_object_item_conv, func, args, kwargs)

    def callback_item_longpressed_del(self, func):
        """
        .. versionadded:: 1.14
        """
        self._callback_del_full("item,longpressed", _cb_object_item_conv, func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_expanded_add(self, func, *args, **kwargs):
        self._callback_add("expanded", func, args, kwargs)

    def callback_expanded_del(self, func):
        self._callback_del("expanded", func)

    def callback_contracted_add(self, func, *args, **kwargs):
        self._callback_add("contracted", func, args, kwargs)

    def callback_contracted_del(self, func):
        self._callback_del("contracted", func)

    def callback_expand_state_changed_add(self, func, *args, **kwargs):
        self._callback_add("expand,state,changed", func, args, kwargs)

    def callback_expand_state_changed_del(self, func):
        self._callback_del("expand,state,changed", func)


_object_mapping_register("Elm_Multibuttonentry", MultiButtonEntry)
